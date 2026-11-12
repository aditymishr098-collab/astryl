#!/usr/bin/env python3
"""Builds the Astryl website (site/) from its own data.

Reads the website's data in data/ (see tools/site_data.py); it does not
need the app's code. Run it from the
project root:  python3 tools/build_site.py
"""
import hashlib, html, json, math, re, shutil
from pathlib import Path

import deepspace
import galaxies
import lab
import umap
import myspace
import skyevents
import students
import cons
import spacephotos
import formation
import site_data
import photos
import quizbank
import telescope
import iss
import universe
import learn

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / 'tools' / 'site_src'
OUT = ROOT / 'site'
REPO = 'https://github.com/aditymishr098-collab/astryl'
SITE = 'https://astryl.space'

# ------------------------------------------------------------------ data
L = {lg: {k: v for k, v in json.load(open(site_data.TEXT / f'app_{lg}.arb', encoding='utf-8')).items() if not k.startswith('@')} for lg in ('en', 'hi')}


def color(h):
    return '#' + h[4:].lower()


# Strings used only by the website's home-page animation (cosmos.js).
L['en'].update(cosmosHere='The Sun is here', cosmosToday='Today', cosmosSun='Sun', cosmosMoon='The Moon today: {lit}% lit, day {day}')
L['hi'].update(cosmosHere='सूर्य यहाँ है', cosmosToday='आज', cosmosSun='सूर्य', cosmosMoon='आज का चाँद: {lit}% रोशन, दिन {day}')


def parse_bodies():
    text = site_data.table('planets.dart')
    gases = {}
    for m in re.finditer(r'case Gas\.(\w+):\s*return \'([^\']+)\';', text):
        gases.setdefault(m.group(1), {})['f'] = m.group(2)
    # colours: the case labels may be stacked (h2/h share a colour)
    cm = re.search(r'Color get color \{(.*?)\n  \}', text, re.S).group(1)
    for block in re.finditer(r'((?:case Gas\.\w+:\s*)+)return const Color\(0x(\w+)\);', cm):
        for g in re.findall(r'Gas\.(\w+)', block.group(1)):
            gases.setdefault(g, {})['c'] = color('0x' + block.group(2))
    bodies = []
    for m in re.finditer(r'  Planet\(\n(.*?)\n  \),', text, re.S):
        b = m.group(1)

        def g(name, default=None):
            r = re.search(r'\b' + name + r': ([^,\n]+),', b)
            return r.group(1).strip() if r else default

        def num(name):
            v = g(name)
            return None if v in (None, 'null') else float(v)
        atm = [[a, float(p)] for a, p in re.findall(r'GasShare\(Gas\.(\w+), ([\d.]+)\)', b)]
        cols = re.search(r'colors: <Color>\[(.*?)\]', b).group(1)
        bodies.append(dict(
            id=g('id').strip("'"), order=int(g('order')),
            kind=(g('kind') or 'BodyKind.planet').split('.')[1].replace('dwarf', 'dwarf'),
            parent=(g('parentId') or '').strip("'") or None,
            diam=int(g('diameterKm')), g=num('gravity'), temp=int(g('meanTempC')),
            day=num('dayHours'), year=num('yearDays'), moons=int(g('moons')),
            dist=num('distanceMillionKm'), bar=num('pressureBar'), atm=atm,
            thin=g('thinAtmosphere') == 'true',
            color=color(re.search(r'color: Color\(0x(\w+)\)', b).group(0).split('0x')[1][:8] and '0x' + re.search(r'\bcolor: Color\(0x(\w+)\)', b).group(1)),
            colors=[color('0x' + c) for c in re.findall(r'Color\(0x(\w+)\)', cols)],
            style=g('style').split('.')[1], rings=g('hasRings') == 'true', caps=g('polarCaps') == 'true',
            spot=g('spot') == 'true', tilt=num('tiltDeg') or 0,
            water=(g('water') or 'Water.none').split('.')[1], hasSurface=g('hasSurface') != 'false'))
    # order of display: Sun, planets, Pluto, moons (as in allBodies)
    by = {b['id']: b for b in bodies}
    order = ['sun'] + [b['id'] for b in bodies if b['kind'] == 'planet'] + ['pluto'] + [b['id'] for b in bodies if b['kind'] == 'moon']
    return [by[i] for i in order], gases


def parse_orbits():
    text = site_data.table('orbits.dart')
    out = {}
    for m in re.finditer(r"'(\w+)': _Elements\(([^)]*)\)", text):
        out[m.group(1)] = [float(x) for x in re.findall(r'-?[\d.]+(?:e-?\d+)?', m.group(2))]
    return out


def parse_missions():
    text = site_data.table('missions.dart')
    res = []
    for m in re.finditer(r"id: '(\w+)',\s*name: '([^']+)',\s*agency: '([^']+)',\s*year: (\d+),\s*month: (\d+),\s*day: (\d+)", text):
        res.append(dict(id=m.group(1), name=m.group(2), agency=m.group(3), y=int(m.group(4)), m=int(m.group(5)), d=int(m.group(6))))
    return res


def parse_spacecraft():
    text = site_data.table('spacecraft.dart')
    res = []
    for m in re.finditer(r'  Spacecraft\(\n(.*?)\n  \),', text, re.S):
        b = m.group(1)

        def g(n, d=None):
            r = re.search(r'\b' + n + r': ([^,\n]+),', b)
            return r.group(1).strip() if r else d
        s = dict(id=g('id').strip("'"), name=g('name').strip("'"), kind=g('kind').split('.')[1],
                 fixedKm=float(g('fixedKm', 0)), speed=float(g('speedKmS', 0)), anchorAu=float(g('anchorAu', 0)))
        if s['kind'] == 'probe':
            import datetime
            s['anchor'] = int(datetime.datetime(int(g('anchorYear')), int(g('anchorMonth')), int(g('anchorDay')), tzinfo=datetime.timezone.utc).timestamp() * 1000)
        res.append(s)
    return res


def parse_constellations():
    text = site_data.table('sky_catalog.dart')
    res = []
    for m in re.finditer(r"^  ConstellationData\('(\w+)', '((?:[^'\\]|\\.)*)', <String, String>\{([^}]*)\}, ([-\d.]+), ([-\d.]+), <List<double>>\[(.*)\]\),$", text, re.M):
        names = {k: v.replace("\\'", "'") for k, v in re.findall(r"'(\w+)': '((?:[^'\\]|\\.)*)'", m.group(3))}
        lines = [[float(x) for x in re.findall(r'-?[\d.]+', seg)] for seg in re.findall(r'<double>\[([^\]]*)\]', m.group(6))]
        res.append(dict(id=m.group(1), latin=m.group(2), names=names, ra=float(m.group(4)), dec=float(m.group(5)), lines=lines))
    return res


def parse_meteors():
    text = site_data.table('events.dart')
    return [[a, int(b), int(c), int(d)] for a, b, c, d in re.findall(r"\('(\w+)', (\d+), (\d+), (\d+)\),", text)]


def parse_surface():
    text = site_data.table('surface_sites.dart')
    sites = []
    for m in re.finditer(r"SurfaceSite\(id: '(\w+)', world: SurfaceWorld\.(\w+), name: (?:'([^']*)'|\"([^\"]*)\"), agency: '([^']+)', year: (\d+), lat: ([-\d.]+), lon: ([-\d.]+), kind: SiteKind\.(\w+)\)", text):
        sites.append(dict(id=m.group(1), world=m.group(2), name=m.group(3) or m.group(4), agency=m.group(5), year=int(m.group(6)), lat=float(m.group(7)), lon=float(m.group(8)), kind=m.group(9)))
    feats = []
    for m in re.finditer(r"SurfaceFeature\(id: '(\w+)', world: SurfaceWorld\.(\w+), lat: ([-\d.]+), lon: ([-\d.]+), rx: ([\d.]+), ry: ([\d.]+), kind: FeatureKind\.(\w+)(?:, tilt: ([-\d.]+))?(?:, major: (true))?\)", text):
        feats.append(dict(id=m.group(1), world=m.group(2), lat=float(m.group(3)), lon=float(m.group(4)), rx=float(m.group(5)), ry=float(m.group(6)), kind=m.group(7), tilt=float(m.group(8) or 0), major=bool(m.group(9))))
    return sites, feats


def parse_fact_ids():
    text = site_data.table('facts.dart')
    return re.findall(r"^  '(\w+)',$", text, re.M)


def parse_milestones():
    text = site_data.table('birthday.dart')
    return [int(x) for x in re.search(r'milestoneDays = <int>\[([^\]]*)\]', text).group(1).split(',')]


BODIES, GASES = parse_bodies()
ORBITS = parse_orbits()
MISSIONS = parse_missions()
CRAFT = parse_spacecraft()
CONS = parse_constellations()
METEORS = parse_meteors()
FACT_IDS = parse_fact_ids()
SITES, FEATS = parse_surface()
MILESTONES = parse_milestones()
BY = {b['id']: b for b in BODIES}
NAME_KEY = dict(mercury='planetMercury', venus='planetVenus', earth='planetEarth', mars='planetMars', jupiter='planetJupiter', saturn='planetSaturn', uranus='planetUranus', neptune='planetNeptune', sun='bodySun', moon='bodyMoon', pluto='bodyPluto', io='moonIo', europa='moonEuropa', ganymede='moonGanymede', callisto='moonCallisto', titan='moonTitan', enceladus='moonEnceladus', triton='moonTriton')

assert len(BODIES) == 18, len(BODIES)
assert len(ORBITS) == 9 and len(MISSIONS) == 15 and len(CRAFT) == 8 and len(CONS) == 89, (len(ORBITS), len(MISSIONS), len(CRAFT), len(CONS))
assert len(SITES) == 25 and len(FEATS) == 27, (len(SITES), len(FEATS))
assert len(METEORS) == 8 and len(FACT_IDS) == 18 and MILESTONES

# ------------------------------------------------------------------ text helpers


def fmt(lg, n, dec=0):
    n = round(n, dec) if dec else int(round(n))
    s = f'{abs(n):.{dec}f}'.rstrip('0').rstrip('.') if dec else str(abs(int(n)))
    whole, _, frac = s.partition('.')
    if lg == 'hi' and len(whole) > 3:
        head, tail = whole[:-3], whole[-3:]
        parts = []
        while len(head) > 2:
            parts.insert(0, head[-2:]); head = head[:-2]
        if head:
            parts.insert(0, head)
        whole = ','.join(parts + [tail])
    else:
        whole = f'{int(whole):,}'
    return ('-' if n < 0 else '') + whole + ('.' + frac if frac else '')


def tr(lg, key, **p):
    s = L[lg][key]
    for k, v in p.items():
        s = s.replace('{' + k + '}', str(v))
    return s


def esc(s):
    return html.escape(s, quote=True)


# More languages (see tools/i18n/README.md). English and Hindi are written by hand for every
# text; the others are looked up by a short hash of the English text. A text with no
# translation simply shows in English, because the CSS only hides the English span when a
# translated span exists (data-tr).
EXTRA_LANGS = ['es', 'pt', 'fr', 'ar']
LANG_NAMES = {'en': 'English', 'hi': 'हिन्दी', 'es': 'Español', 'pt': 'Português', 'fr': 'Français', 'ar': 'العربية'}
LANG_SHORT = {'en': 'EN', 'hi': 'हि', 'es': 'ES', 'pt': 'PT', 'fr': 'FR', 'ar': 'ع'}
TRX = {}
for _lg in EXTRA_LANGS:
    _f = ROOT / 'tools' / 'i18n' / f'{_lg}.tsv'
    TRX[_lg] = {}
    if _f.exists():
        for _line in _f.read_text(encoding='utf-8').splitlines():
            if '\t' in _line and not _line.startswith('#'):
                _k, _v = _line.split('\t', 1)
                TRX[_lg][_k.strip()] = _v.strip()
SOURCE = {}


def xid(en):
    return hashlib.md5(en.encode('utf-8')).hexdigest()[:8]


def spans(en, hi):
    h = xid(en)
    SOURCE[h] = en
    have = [lg for lg in EXTRA_LANGS if h in TRX[lg]]
    attr = f' data-tr="{" ".join(have)}"' if have else ''
    out = f'<span class="t" lang="en"{attr}>{esc(en)}</span><span class="t" lang="hi">{esc(hi)}</span>'
    for lg in have:
        out += f'<span class="t" lang="{lg}">{esc(TRX[lg][h])}</span>'
    return out


def bi(key, **p):
    """Both languages as two spans; CSS shows the one that matches <html lang>."""
    q = lambda lg: {k: (v[lg] if isinstance(v, dict) else v) for k, v in p.items()}
    return spans(tr('en', key, **q('en')), tr('hi', key, **q('hi')))


def bt(en, hi):
    return spans(en, hi)


def raw2(en, hi):
    return f'<span class="t" lang="en">{en}</span><span class="t" lang="hi">{hi}</span>'


def bname(i):
    return bi(NAME_KEY[i])


def per(fn):
    """Build a bilingual value from a function of lg."""
    return {lg: fn(lg) for lg in ('en', 'hi')}


def val(fn):
    return ''.join(f'<span class="t" lang="{lg}">{esc(fn(lg))}</span>' for lg in ('en', 'hi'))


def v_diam(b): return lambda lg: tr(lg, 'valueKm', value=fmt(lg, b['diam']))
def v_grav(b): return lambda lg: f"{fmt(lg, b['g'], 1)} m/s² ({fmt(lg, b['g'] / 9.8, 2)} g)"
def v_temp(b): return lambda lg: f"{fmt(lg, b['temp'])} °C"
def v_day(b): return lambda lg: tr(lg, 'valueDays', value=fmt(lg, b['day'] / 24, 1)) if b['day'] > 48 else tr(lg, 'valueHours', value=fmt(lg, b['day'], 1))


def v_year(b):
    def f(lg):
        if b['year'] <= 0: return '–'
        return tr(lg, 'valueYears', value=fmt(lg, b['year'] / 365.25, 1)) if b['year'] > 1000 else tr(lg, 'valueDays', value=fmt(lg, b['year'], 1))
    return f


def v_dist(b):
    def f(lg):
        if b['kind'] == 'star': return '–'
        src = BY[b['parent']] if b['kind'] == 'moon' else b
        return tr(lg, 'valueMillionKm', value=fmt(lg, src['dist'], 1))
    return f


def v_press(b):
    def f(lg):
        if b['bar'] is None: return tr(lg, 'noSurface')
        if b['bar'] == 0: return '≈ 0 bar'
        if b['bar'] < 0.001: return '< 0.001 bar'
        return f"{fmt(lg, b['bar'], 3)} bar"
    return f


def oxygen(b):
    if b['thin']: return 0.0
    return next((p for g, p in b['atm'] if g == 'o2'), 0.0)


# life score (port of lib/core/habitability.dart)
def life(b):
    t = b['temp']; tp = 2 if -20 <= t <= 40 else (1 if -80 <= t <= 80 else 0)
    bar = b['bar'] or 0
    pp = 0 if not b['hasSurface'] else (2 if 0.5 <= bar <= 2 else (1 if (0.06 <= bar < 0.5) or (2 < bar <= 5) else 0))
    ox = oxygen(b); op = 2 if 15 <= ox <= 30 else (1 if ox >= 1 else 0)
    wp = {'liquid': 2, 'ice': 1, 'ocean': 1, 'none': 0}[b['water']]
    sp = 1 if b['hasSurface'] else 0
    g = b['g'] / 9.8; gp = 1 if 0.3 <= g <= 2 else 0
    return [('avgTemp', tp, 2, v_temp(b)), ('pressure', pp, 2, v_press(b)), ('oxygen', op, 2, lambda lg: (fmt(lg, 0, 2) if b['thin'] else fmt(lg, ox, 2)) + '%'),
            ('water', wp, 2, lambda lg: tr(lg, {'liquid': 'waterLiquid', 'ice': 'waterIce', 'ocean': 'waterOcean', 'none': 'waterNone'}[b['water']])),
            ('surface', sp, 1, lambda lg: tr(lg, 'solidSurface' if b['hasSurface'] else 'noSurface')),
            ('gravity', gp, 1, lambda lg: f"{fmt(lg, g, 2)} g")]


def life_verdict(score):
    return 'lifeHome' if score >= 8 else ('lifeHard' if score >= 3 else 'lifeNo')


# ------------------------------------------------------------------ SVG
PHOTO = set()
PHOTO_CREDIT = {}


def planet_pic(b, prefix='', small=True, uid=''):
    """The body's real photo when there is one, else the drawn globe."""
    if b['id'] in PHOTO:
        name = tr('en', NAME_KEY[b['id']])
        return f'<img class="pimg" src="{prefix}img/planets/{b["id"]}{"-s" if small else ""}.webp" alt="{esc(name)}" width="{160 if small else 600}" height="{160 if small else 600}" loading="{"lazy" if small else "eager"}" decoding="async">'
    return planet_svg(b, uid=uid)


def planet_svg(b, size=100, uid=''):
    c0, c1, c2 = b['colors']
    gid = f'g{b["id"]}{uid}'
    s = f'<svg viewBox="-60 -60 120 120" role="img" aria-label="{esc(tr("en", NAME_KEY[b["id"]]))}"><defs>'
    s += f'<radialGradient id="{gid}" cx="35%" cy="32%" r="75%"><stop offset="0" stop-color="{c2}"/><stop offset=".45" stop-color="{c0}"/><stop offset="1" stop-color="{c1}"/></radialGradient>'
    s += f'<clipPath id="c{gid}"><circle r="40"/></clipPath></defs>'
    if b['style'] == 'sun':
        s += f'<circle r="56" fill="{b["color"]}" opacity=".12"/><circle r="48" fill="{b["color"]}" opacity=".2"/>'
    ring_back = ring_front = ''
    if b['rings']:
        ring_back = f'<ellipse rx="58" ry="16" fill="none" stroke="#e6d4a0" stroke-width="7" opacity=".55" transform="rotate(-18)"/><ellipse rx="49" ry="13" fill="none" stroke="#c8b27a" stroke-width="3" opacity=".6" transform="rotate(-18)"/>'
    s += ring_back
    s += f'<circle r="40" fill="url(#{gid})"/>'
    s += f'<g clip-path="url(#c{gid})">'
    if b['style'] in ('banded', 'ice') and b['id'] not in ('venus',):
        for i, y in enumerate((-26, -14, -3, 9, 21, 31)):
            s += f'<rect x="-44" y="{y}" width="88" height="{5 + i % 3 * 2}" fill="{c1 if i % 2 else c2}" opacity=".28"/>'
    elif b['id'] == 'venus':
        for y in (-22, -6, 12):
            s += f'<rect x="-44" y="{y}" width="88" height="8" fill="{c2}" opacity=".3"/>'
    if b['style'] == 'earth':
        s += f'<path d="M-30,-8 q8,-18 20,-8 q6,10 -4,16 q-10,6 -16,-8z M8,6 q14,-10 22,2 q-2,14 -14,14 q-10,-4 -8,-16z" fill="{c1}" opacity=".95"/>'
    if b['style'] in ('rocky', 'icyMoon') and b['kind'] != 'star':
        for cx, cy, r in ((-14, -8, 6), (10, 8, 8), (-4, 20, 4), (18, -16, 4), (-24, 10, 3)):
            s += f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="#000" opacity=".16"/>'
    if b['caps']:
        s += f'<ellipse cy="-39" rx="16" ry="6" fill="#fff" opacity=".85"/><ellipse cy="39" rx="14" ry="5" fill="#fff" opacity=".8"/>'
    if b['spot']:
        s += '<ellipse cx="14" cy="14" rx="9" ry="5" fill="#c4553a" opacity=".85"/>'
    s += '</g>'
    if b['rings']:
        ring_front = f'<path d="M-58,3 A58,16 -18 0 0 58,-3" fill="none" stroke="#e6d4a0" stroke-width="7" opacity=".85" transform="rotate(0)"/>'
        s += f'<g transform="rotate(-18)"><path d="M-58,0 A58,16 0 0 0 58,0" fill="none" stroke="#e6d4a0" stroke-width="7" opacity=".9"/><path d="M-49,0 A49,13 0 0 0 49,0" fill="none" stroke="#c8b27a" stroke-width="3" opacity=".9"/></g>'
    s += '</svg>'
    return s


def logo_svg():
    return '<svg viewBox="0 0 120 120" aria-hidden="true"><rect width="120" height="120" rx="28" fill="#10141f" stroke="#222a3d" stroke-width="4"/><g transform="rotate(-22 60 60)"><ellipse cx="60" cy="60" rx="44" ry="17" fill="none" stroke="#5b9bff" stroke-width="5" opacity=".75"/><circle cx="60" cy="60" r="19" fill="#f5a524"/><path d="M16,60 A44,17 0 0 0 104,60" fill="none" stroke="#5b9bff" stroke-width="5"/><circle cx="104" cy="60" r="7.5" fill="#7db0ff"/></g></svg>'


def cons_svg(c):
    lines = c['lines']
    pts = [(lines_i[k], lines_i[k + 1]) for lines_i in lines for k in range(0, len(lines_i) - 1, 2)]
    ra0, dec0 = c['ra'], c['dec']

    def proj(ra, dec):
        d = (ra - ra0 + 180) % 360 - 180
        return (-d * math.cos(math.radians(dec0)), -dec)
    xy = [proj(*p) for p in pts]
    xs, ys = [p[0] for p in xy], [p[1] for p in xy]
    w, h = max(xs) - min(xs) or 1, max(ys) - min(ys) or 1
    scale = min(170 / w, 110 / h)
    ox, oy = 100 - (min(xs) + max(xs)) / 2 * scale, 75 - (min(ys) + max(ys)) / 2 * scale
    s = '<svg viewBox="0 0 200 150" role="img">'
    dots = set()
    for seg in lines:
        p = [proj(seg[k], seg[k + 1]) for k in range(0, len(seg) - 1, 2)]
        p = [(x * scale + ox, y * scale + oy) for x, y in p]
        s += '<polyline fill="none" stroke="#7aa2ff" stroke-width="1.2" stroke-linejoin="round" points="' + ' '.join(f'{x:.1f},{y:.1f}' for x, y in p) + '"/>'
        dots.update((round(x, 1), round(y, 1)) for x, y in p)
    s += ''.join(f'<circle cx="{x}" cy="{y}" r="2.2" fill="#eef0fb"/>' for x, y in sorted(dots))
    return s + '</svg>'


# ------------------------------------------------------------------ page shell
# The top menu keeps four main pages; the rest sit under "More". Home is the logo.
NAV_MAIN = [('planets.html', 'planets', bi('planetsTitle')), ('solar-system.html', 'solar', bi('solarSystemTitle')), ('sky.html', 'sky', bi('skyTitle')), ('quiz.html', 'quiz', bi('navQuiz'))]
NAV_MORE = [('my-space.html', 'myspace', bt('My space', 'My space')), ('sky-events.html', 'events', bt('Eclipses and meteor showers', 'ग्रहण और उल्कापात')), ('learn.html', 'school', bt('For students', 'छात्रों के लिए')), ('telescope.html', 'scope', bt('Telescope simulator', 'Telescope simulator')), ('iss.html', 'iss', bt('Space station passes', 'अंतरिक्ष स्टेशन कब दिखेगा')), ('compare.html', 'compare', bi('navCompare')), ('you.html', 'you', bt('You', 'आप')), ('constellations.html', 'cons', bi('constellationsLabel')), ('maps.html', 'maps', bi('surfaceMapTitle')),
            ('missions.html', 'missions', bi('missionsTitle')), ('spacecraft.html', 'spacecraft', bi('spacecraftTitle')),
            ('universe-map.html', 'umap', bt('Universe map', 'ब्रह्मांड का नक्शा')), ('galaxies.html', 'gx', bt('Galaxies', 'Galaxies')), ('cosmic-scale.html', 'scale', bt('Scale of the universe', 'ब्रह्मांड का पैमाना')), ('universe-timeline.html', 'tline', bt('Timeline', 'समयरेखा')), ('glossary.html', 'gloss', bt('Glossary', 'शब्दकोश')), ('black-holes.html', 'bh', bt('Black holes', 'ब्लैक होल'))]


_ASSET_V = []


def asset_v():
    '''A short hash of the scripts and styles, so a changed file is never served from an old cache.'''
    if not _ASSET_V:
        h = hashlib.md5()
        for name in ('style.css', 'app.js', 'account.js', 'cosmos.js', 'moons.js', 'fx.js', 'lab.js', 'scale.js', 'learn.js', 'universe.js', 'me.js', 'myspace.js', 'birthday.js', 'tonight.js', 'telescope.js', 'sgp4.js', 'iss.js', 'apod.js', 'worlds.js', 'pwa.js', 'rounds.js', 'bhsim.js', 'sheet.js', 'sw.js'):
            h.update((SRC / name).read_bytes())
        h.update((ROOT / 'tools' / 'formation.py').read_bytes())
        if (OUT / 'assets/quiz-bank.js').exists():
            h.update((OUT / 'assets/quiz-bank.js').read_bytes())
        h.update(data_js().encode('utf-8'))
        h.update(umap.CATALOG.read_bytes())
        _ASSET_V.append(h.hexdigest()[:10])
    return _ASSET_V[0]



# ---------- share images (Open Graph) and structured data ----------
_OG = {}


def og_name(canonical):
    name = canonical[:-5] if canonical.endswith('.html') else canonical
    return name.split('/')[-1] or 'home'


def ld_json(obj):
    return '<script type="application/ld+json">' + json.dumps(obj, ensure_ascii=False, separators=(',', ':')).replace('</', '<\\/') + '</script>\n'


def _hex(c):
    c = c.lstrip('#')
    return tuple(int(c[i:i + 2], 16) for i in (0, 2, 4))


def _mix(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


BH_PAGES = {'black-holes', 'black-hole-lab', 'black-holes-101', 'what-is-a-black-hole', 'how-black-holes-form', 'event-horizon-and-singularity',
            'falling-into-a-black-hole', 'famous-black-holes', 'how-we-see-black-holes', 'black-hole-myths-and-big-questions'}
GX_PAGES = {'galaxies', 'what-is-a-galaxy', 'the-milky-way', 'andromeda-galaxy', 'types-of-galaxies', 'the-local-group',
            'galaxy-formation-and-collisions', 'galaxies-you-can-see'}
COSMOS_PAGES = {'universe-map', 'cosmic-scale', 'universe-timeline', 'glossary', 'deep-space-quiz'}


def og_theme(name):
    return 'bh' if name in BH_PAGES else 'gx' if name in GX_PAGES else 'cosmos' if name in COSMOS_PAGES else ''


def _og_theme_art(img, theme, name):
    """Black hole, spiral galaxy or star-cloud pictures for the share cards of the deep space pages."""
    import random
    from PIL import Image, ImageDraw, ImageFilter
    W, H = img.size
    cx, cy = 900, 315
    rnd = random.Random('art' + theme)
    if theme == 'bh':
        glow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        gd = ImageDraw.Draw(glow)
        gd.ellipse([cx - 230, cy - 230, cx + 230, cy + 230], fill=(255, 150, 50, 70))
        gd.polygon([(cx - 14, cy), (cx - 60, 0), (cx + 60, 0), (cx + 14, cy)], fill=(125, 176, 255, 70))
        gd.polygon([(cx - 14, cy), (cx - 60, H), (cx + 60, H), (cx + 14, cy)], fill=(125, 176, 255, 70))
        img.paste(glow.filter(ImageFilter.GaussianBlur(28)), (0, 0), glow.filter(ImageFilter.GaussianBlur(28)))
        disk = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        dd = ImageDraw.Draw(disk)
        for rr, w, a, col in ((3.1, 6, 110, (255, 140, 50)), (2.6, 12, 170, (255, 170, 70)), (2.15, 16, 220, (255, 196, 110)), (1.8, 12, 240, (255, 220, 150))):
            dd.ellipse([cx - 120 * rr, cy - 120 * rr * 0.2, cx + 120 * rr, cy + 120 * rr * 0.2], outline=col + (a,), width=w)
        disk = disk.rotate(-12, center=(cx, cy), resample=Image.BICUBIC)
        img.paste(disk, (0, 0), disk)
        pd = ImageDraw.Draw(img)
        pd.ellipse([cx - 112, cy - 112, cx + 112, cy + 112], fill=(0, 0, 0), outline=(255, 226, 170), width=3)
        front = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        fd = ImageDraw.Draw(front)
        for rr, w, a, col in ((2.15, 16, 220, (255, 196, 110)), (1.8, 12, 240, (255, 220, 150))):
            fd.arc([cx - 120 * rr, cy - 120 * rr * 0.2, cx + 120 * rr, cy + 120 * rr * 0.2], 0, 180, fill=col + (a,), width=w)
        front = front.rotate(-12, center=(cx, cy), resample=Image.BICUBIC)
        img.paste(front, (0, 0), front)
    else:
        layer = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        ld = ImageDraw.Draw(layer)
        arms = 4 if theme == 'gx' else 2
        for k in range(arms):
            for i in range(900):
                t = i / 900 * 6.0
                r = 28 * math.exp(0.2126 * t) * (1 + rnd.uniform(-0.05, 0.05))
                a = t + k * (2 * math.pi / arms)
                x, y = cx + r * math.cos(a) + rnd.gauss(0, 7 + r * 0.04), cy + r * math.sin(a) * 0.62 + rnd.gauss(0, 5 + r * 0.03)
                col = (170, 200, 255) if k % 2 == 0 else (190, 160, 255)
                rad = rnd.choice((1, 1, 2, 2, 3))
                ld.ellipse([x - rad, y - rad, x + rad, y + rad], fill=col + (rnd.randrange(90, 230),))
        halo = layer.filter(ImageFilter.GaussianBlur(9))
        img.paste(halo, (0, 0), halo)
        img.paste(layer, (0, 0), layer)
        core = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        ImageDraw.Draw(core).ellipse([cx - 70, cy - 40, cx + 70, cy + 40], fill=(255, 215, 150, 190))
        core = core.filter(ImageFilter.GaussianBlur(20))
        img.paste(core, (0, 0), core)


def make_og(name, title):
    """A 1200x630 picture for link previews: the world on the right, its name on the left."""
    import random
    from PIL import Image, ImageDraw, ImageFont
    W, H = 1200, 630
    img = Image.new('RGB', (W, H), (6, 8, 14))
    px = ImageDraw.Draw(img)
    for y in range(H):
        px.line([(0, y), (W, y)], fill=_mix((6, 8, 14), (16, 22, 46), y / H))
    rnd = random.Random(name)
    for _ in range(140):
        x, y, r = rnd.randrange(W), rnd.randrange(H), rnd.choice((1, 1, 1, 2))
        c = rnd.randrange(110, 230)
        px.ellipse([x - r, y - r, x + r, y + r], fill=(c, c, min(255, c + 25)))
    theme = og_theme(name)
    if theme:
        _og_theme_art(img, theme, name)
    body = next((b for b in BODIES if b['id'] == name), None)
    cols = [_hex(c) for c in (body['colors'] if body else ['#7aa2ff', '#3b5bd6', '#cfe0ff'])]
    base, dark, light = cols[0], _mix(cols[0], (0, 0, 0), 0.55), _mix(cols[-1] if len(cols) > 1 else cols[0], (255, 255, 255), 0.35)
    cx, cy, R = 900, 315, 185
    rings = bool(body and body.get('rings')) or (body is None and not theme)
    layer = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer)
    if rings:
        for rr, w, a in ((1.75, 16, 190), (2.05, 10, 150), (2.3, 5, 120)):
            ld.ellipse([cx - R * rr, cy - R * rr * 0.28, cx + R * rr, cy + R * rr * 0.28], outline=(223, 192, 124, a), width=w)
        layer = layer.rotate(14, center=(cx, cy), resample=Image.BICUBIC)
        img.paste(layer, (0, 0), layer)
    sphere = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    sd = ImageDraw.Draw(sphere)
    steps = 60
    for i in range(steps):
        t = i / (steps - 1)
        r = R * (1 - 0.78 * t)
        ox, oy = -0.38 * R * t, -0.38 * R * t
        col = _mix(dark, base, min(1, t * 1.6)) if t < 0.625 else _mix(base, light, (t - 0.625) / 0.375)
        sd.ellipse([cx + ox - r, cy + oy - r, cx + ox + r, cy + oy + r], fill=col + (255,))
    mask = Image.new('L', (W, H), 0)
    ImageDraw.Draw(mask).ellipse([cx - R, cy - R, cx + R, cy + R], fill=255)
    if not theme:
        img.paste(sphere, (0, 0), mask)
    if rings:
        front = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        fd = ImageDraw.Draw(front)
        for rr, w, a in ((1.75, 16, 190), (2.05, 10, 150), (2.3, 5, 120)):
            fd.arc([cx - R * rr, cy - R * rr * 0.28, cx + R * rr, cy + R * rr * 0.28], 0, 180, fill=(223, 192, 124, a), width=w)
        front = front.rotate(14, center=(cx, cy), resample=Image.BICUBIC)
        img.paste(front, (0, 0), front)
    fonts = site_data.FONTS
    f_brand = ImageFont.truetype(str(fonts / 'SpaceGrotesk-Bold.ttf'), 40)
    f_title = ImageFont.truetype(str(fonts / 'SpaceGrotesk-Bold.ttf'), 82)
    f_small = ImageFont.truetype(str(fonts / 'DMSans-Medium.ttf'), 32)
    d = ImageDraw.Draw(img)
    d.text((70, 60), 'Astryl', font=f_brand, fill=(122, 162, 255))
    words, lines, cur = title.split(), [], ''
    for w in words:
        t = (cur + ' ' + w).strip()
        if d.textlength(t, font=f_title) > 600 and cur:
            lines.append(cur)
            cur = w
        else:
            cur = t
    lines.append(cur)
    y = 250 - (len(lines) - 1) * 46
    for ln in lines[:3]:
        d.text((70, y), ln, font=f_title, fill=(240, 244, 255))
        y += 96
    d.text((70, 540), 'Know your space  ·  astryl.space', font=f_small, fill=(160, 176, 214))
    out = OUT / 'img/og'
    out.mkdir(parents=True, exist_ok=True)
    img.save(out / f'{name}.jpg', quality=82, optimize=True, progressive=False)


def og_images():
    for name, title in sorted(_OG.items()):
        make_og(name, title)


def lang_menu():
    return ''.join(f'<button type="button" data-lang="{lg}">{name}</button>' for lg, name in LANG_NAMES.items())


def shell(title_en, title_hi, page, body, desc_en, depth=0, canonical='', scripts=True, extra_head='', ld=None):
    p = '../' * depth
    def navlink(h, k, label):
        return f'<a href="{p}{h}"{" class=on" if k == page else ""}>{label}</a>'
    more_on = page in ('compare', 'you', 'cons', 'maps', 'missions', 'bh', 'gx', 'scale', 'tline', 'gloss', 'umap', 'myspace', 'events', 'school', 'scope', 'iss')
    nav = (''.join(navlink(*x) for x in NAV_MAIN)
           + f'<details class="more"><summary{" class=on" if more_on else ""}>{bt("More", "और")} ▾</summary><div class="morepanel">'
           + ''.join(navlink(*x) for x in NAV_MORE) + '</div></details>')
    url = f'{SITE}/{canonical}' if canonical else SITE + '/'
    og = og_name(canonical)
    _OG.setdefault(og, title_en)
    ogimg = f'{SITE}/img/og/{og}.jpg'
    ldtag = ld_json(ld) if ld else ''
    return f'''<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{esc(title_en)} · Astryl</title>
<meta name="description" content="{esc(desc_en)}">
<link rel="canonical" href="{url}">
<meta property="og:title" content="{esc(title_en)} · Astryl"><meta property="og:description" content="{esc(desc_en)}"><meta property="og:type" content="website"><meta property="og:url" content="{url}"><meta name="theme-color" content="#06080e">
<meta property="og:site_name" content="Astryl"><meta name="robots" content="max-image-preview:large"><meta property="og:image:alt" content="{esc(title_en)} · Astryl">
<meta property="og:image" content="{ogimg}"><meta property="og:image:width" content="1200"><meta property="og:image:height" content="630"><meta name="twitter:card" content="summary_large_image"><meta name="twitter:title" content="{esc(title_en)} · Astryl"><meta name="twitter:description" content="{esc(desc_en)}"><meta name="twitter:image" content="{ogimg}">
<link rel="icon" href="{p}assets/icon.svg" type="image/svg+xml"><link rel="manifest" href="/manifest.webmanifest"><link rel="apple-touch-icon" href="/img/icons/apple-touch-icon.png"><meta name="apple-mobile-web-app-capable" content="yes"><meta name="mobile-web-app-capable" content="yes"><meta name="apple-mobile-web-app-title" content="Astryl"><meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<link rel="stylesheet" href="{p}assets/style.css?v={asset_v()}">
<script>try{{var s=localStorage,A=["en","hi","es","pt","fr","ar"],l=s.getItem("astryl-lang");if(A.indexOf(l)<0){{l=(navigator.language||"en").slice(0,2);if(A.indexOf(l)<0)l="en"}}var d=document.documentElement;d.lang=l;d.dir=l==="ar"?"rtl":"ltr";if(s.getItem("astryl-theme")!=="light")d.setAttribute("data-theme","dark")}}catch(e){{document.documentElement.setAttribute("data-theme","dark")}}if(window.IntersectionObserver&&!(window.matchMedia&&matchMedia("(prefers-reduced-motion: reduce)").matches))document.documentElement.classList.add("js")</script>
{ldtag}{extra_head}</head>
<body data-page="{page}" data-root="{p}">
<div class="stars"></div>
<header class="top"><div class="wrap bar">
<a class="brand" href="{p}index.html">{logo_svg()}Astryl</a>
<nav class="links">{nav}</nav>
<div class="tools"><details class="more langdd" id="langDd"><summary id="langBtn" aria-label="Language">🌐 <b id="langCur">EN</b></summary><div class="morepanel" id="langMenu">{lang_menu()}</div></details><button id="themeBtn" aria-label="Theme">☾</button><span id="acctNav" class="acctnav"><a class="btn" href="{p}account.html?mode=login">{bt("Log in", "Login")}</a><a class="btn primary" href="{p}account.html">{bt("Sign up", "खाता बनाएँ")}</a></span></div>
</div></header>
<main class="wrap">
{body}
</main>
<footer><div class="wrap cols">
<div><b>Astryl</b><br>{bt("Know your space.", "अपने अंतरिक्ष को जानिए।")}<br>© 2026 Astryl · <a href="{SITE}">astryl.space</a></div>
<div><a href="{p}privacy.html">{bt("Privacy Policy", "Privacy Policy")}</a><br><a href="{p}account.html">{bt("Account", "खाता")}</a><br><a href="{p}my-space.html">{bt("My space", "My space")}</a></div>
<div>{bt("Facts: NASA Planetary Fact Sheet", "तथ्य: NASA Planetary Fact Sheet")}<div id="installBox" class="installbox"></div></div>
</div></footer>
{"<script src=\"" + p + "assets/data.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/app.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/account.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/me.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/fx.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/pwa.js?v=" + asset_v() + "\"></script>" if scripts else ""}
</body></html>
'''


def write(path, content):
    f = OUT / path
    f.parent.mkdir(parents=True, exist_ok=True)
    if path.endswith('.html'):
        content = spacephotos.place(path, content, bt, esc)
    f.write_text(content, encoding='utf-8')


# ------------------------------------------------------------------ pages
def stat(label_key, value_html):
    return f'<div class="stat"><b>{value_html}</b><span>{bi(label_key)}</span></div>'


def body_sub_stats(b):
    """The short line under the name and the number boxes, shared by the body page and the planet panel."""
    idn = b['id']
    sub = {'star': bi('kindStar'), 'dwarf': bi('kindDwarf')}.get(b['kind']) if b['kind'] in ('star', 'dwarf') else None
    if b['id'] == 'pluto':
        sub = bi('kindDwarf')
    elif b['kind'] == 'moon':
        sub = bi('moonOf', planet={lg: tr(lg, NAME_KEY[b['parent']]) for lg in ('en', 'hi')})
    elif b['kind'] == 'planet':
        sub = bi('planetOrder', n=b['order'])
    stats = [stat('diameter', val(v_diam(b))), stat('gravity', val(v_grav(b))), stat('avgTemp', val(v_temp(b))), stat('dayLength', val(v_day(b)))]
    stats.append(stat('orbitPeriod' if b['kind'] == 'moon' else 'yearLength', val(v_year(b))))
    if b['kind'] != 'moon':
        stats.append(stat('moons', val(lambda lg: fmt(lg, b['moons']))))
        stats.append(stat('distance', val(v_dist(b))))
    else:
        stats.append(stat('distance', val(v_dist(b))))
        stats.append(f'<div class="stat"><b>{val(lambda lg: tr(lg, "valueKm", value=fmt(lg, b["dist"] * 1e6)))}</b><span>{bi("distanceFrom", body={lg: tr(lg, NAME_KEY[b["parent"]]) for lg in ("en", "hi")})}</span></div>')
    stats.append(stat('pressure', val(v_press(b))))
    return sub, stats


def form_html(idn):
    """'When and how it formed': a short answer, the story, a timeline and the open question."""
    f = formation.FORM.get(idn)
    if not f:
        return ''
    steps = ''.join(f'<div class="m"><div class="y">{bt(esc(te), esc(th))}</div><p>{bt(esc(en), esc(hi))}</p></div>' for te, th, en, hi in f['steps'])
    op = f'<div class="callout">❓ <b>{bt("Still unknown", "अभी भी अनजाना")}:</b> {bt(esc(f["open"][0]), esc(f["open"][1]))}</div>' if f.get('open') else ''
    return (f'<div class="formhead"><div class="stat"><b>{bt(esc(f["when"][0]), esc(f["when"][1]))}</b><span>{bt("Formed", "कब बना")}</span></div>'
            f'<div class="stat"><b>{bt(esc(f["took"][0]), esc(f["took"][1]))}</b><span>{bt("How long it took", "कितना समय लगा")}</span></div></div>'
            f'<p>{bt(esc(f["how"][0]), esc(f["how"][1]))}</p><div class="tl formtl">{steps}</div>{op}'
            f'<p class="note">{bt("All dates are estimates from meteorites, moon rocks, space missions and computer models.", "सभी तारीख़ें अनुमान हैं, जो उल्कापिंडों, चाँद की चट्टानों, अंतरिक्ष missions और computer models से आती हैं।")}</p>')


def sheet_js():
    """assets/sheet-data.js: everything the planet panel shows, already in both languages."""
    data = {}
    for b in BODIES:
        idn = b['id']
        sub, stats = body_sub_stats(b)
        mo = [m for m in BODIES if m['parent'] == idn]
        moons = ''
        if mo:
            moons = f'<h3>{bi("majorMoons")}</h3><div class="sheetmoons">' + ''.join(f'<a href="body/{m["id"]}.html">{planet_pic(m, "", uid="sm")}<span>{bname(m["id"])}</span></a>' for m in mo) + '</div>'
        cap = idn.capitalize()
        facts = ''.join(f'<li>{bi("fact" + cap + str(n))}</li>' for n in (1, 2) if f'fact{cap}{n}' in L['en'])
        data[idn] = {
            'head': f'<div class="sheethead">{planet_pic(b, "", small=False, uid="sh")}<div><h2 id="sheetTitle">{bname(idn)}</h2><p class="sub">{sub or ""}</p></div></div>',
            'body': f'<div class="stats">{"".join(stats)}</div><h3>{bt("When and how it formed", "कब और कैसे बना")}</h3>{form_html(idn)}'
                    + (f'<h3>{bi("factTitle")}</h3><ul class="sheetfacts">{facts}</ul>' if facts else '') + moons
                    + f'<p><a class="btn primary" href="body/{idn}.html" data-full>{bt("Full page: layers, telescope view, atmosphere", "पूरा page: परतें, दूरबीन का दृश्य, वायुमंडल")} →</a></p>',
        }
    return 'window.ASTRYL_SHEET=' + json.dumps(data, ensure_ascii=False, separators=(',', ':')) + ';'


def body_page(b, i):
    idn = b['id']
    sub, stats = body_sub_stats(b)
    # atmosphere
    atm = ''
    if b['atm'] or b['thin']:
        atm += f'<h2>{bi("atmosphere")}</h2>'
        if b['thin'] and b['atm']:
            atm += f'<p class="note">{bi("thinAtmosphere")}</p>'
        if not b['atm']:
            atm += f'<p>{bi("noAtmosphere")}</p>'
        for gas, pct in b['atm']:
            gi = GASES[gas]
            key = 'gas' + {'co2': 'Co2', 'n2': 'N2', 'o2': 'O2', 'ar': 'Ar', 'h2': 'H2', 'h': 'H2', 'he': 'He', 'ch4': 'Ch4', 'na': 'Na', 'k': 'K'}[gas]
            name = bi(key) if gas != 'h' else bt('Hydrogen', 'हाइड्रोजन')
            atm += f'<div class="bar-row"><span class="n">{name} <small class="note">{gi["f"]}</small></span><span class="meter"><i style="width:{min(100, max(pct, 1.5))}%;background:{gi["c"]}"></i></span><span class="v">{val(lambda lg, pct=pct: fmt(lg, pct, 2) + "%")}</span></div>'
        if b['id'] != 'sun':
            ox = oxygen(b)
            atm += f'<p style="margin-top:14px"><b>{bi("oxygenVsEarth")}:</b> {val(lambda lg: fmt(lg, ox, 2) + "% / 20.95%")} · <b class="{"ok" if b["id"] == "earth" else "no"}">{bi("breathable" if b["id"] == "earth" else "notBreathable")}</b></p>'
    # life score
    fs = life(b)
    total = sum(f[1] for f in fs)
    cls = 'ok' if total >= 8 else ('mid' if total >= 3 else 'no')
    rows = ''
    for key, pts, mx, vf in fs:
        mark = ('✓', 'ok') if pts == mx else (('✕', 'no') if pts == 0 else ('–', 'mid'))
        rows += f'<div class="bar-row"><span class="{mark[1]}" style="width:20px;font-weight:700">{mark[0]}</span><span class="n" style="width:auto;flex:1">{bi(key)}</span><span style="font-weight:700">{val(vf)}</span></div>'
    lifehtml = f'<h2>{bi("lifeTitle")}</h2><div class="card"><div class="life {cls}">{total}/10 <span style="font-size:1rem;font-weight:500;color:var(--text)">{bi(life_verdict(total))}</span></div><div class="progress"><i style="width:{total * 10}%;background:var(--{"good" if cls == "ok" else ("accent" if cls == "mid" else "bad")})"></i></div>{rows}<p class="note" style="margin-top:10px">{bi("lifeNote")}</p></div>'
    # facts
    name_cap = idn.capitalize()
    facts = ''.join(f'<div class="card"><p style="color:var(--text)">{bi("fact" + name_cap + str(n))}</p></div>' for n in (1, 2) if f'fact{name_cap}{n}' in L['en'])
    facts = f'<h2>{bi("factTitle")}</h2><div class="grid">{facts}</div>' if facts else ''
    # moons
    mo = [m for m in BODIES if m['parent'] == idn]
    moons = ''
    if mo:
        moons = f'<h2>{bi("majorMoons")}</h2><div class="grid sm">' + ''.join(f'<a class="card pcard" href="{m["id"]}.html">{planet_pic(m, "../", uid="m")}<div><b>{bname(m["id"])}</b><br><small>{val(v_diam(m))}</small></div></a>' for m in mo) + '</div>'
    dyn = ''
    if b['kind'] in ('planet', 'dwarf') or b['id'] == 'pluto':
        if b['id'] != 'earth':
            dyn = f'<h2>{bi("travelTitle")}</h2><div class="card" id="travel" data-body="{idn}"></div>'
    # weight
    prev = BODIES[i - 1] if i > 0 else None
    nxt = BODIES[i + 1] if i + 1 < len(BODIES) else None
    pn = '<div class="pn">' + (f'<a class="btn" href="{prev["id"]}.html">← {bname(prev["id"])}</a>' if prev else '<span></span>') + (f'<a class="btn" href="{nxt["id"]}.html">{bname(nxt["id"])} →</a>' if nxt else '<span></span>') + '</div>'
    wt = f'<h2>{bi("weightFeelsLike", weight="60")}</h2><div class="card"><div class="life">{val(lambda lg: fmt(lg, 60 * b["g"] / 9.8, 1) + " kg")}</div><p class="note">{bi("gravityTimes", factor={lg: fmt(lg, b["g"] / 9.8, 2) for lg in ("en", "hi")})} · <a href="../you.html">{bi("weightTitle")}</a></p></div>' if b['hasSurface'] or True else ''
    moon_orb = f'<section class="blk"><h2>{bt("Live moon positions", "चंद्रमाओं की लाइव स्थिति")}</h2><div class="card" id="moonOrbitSim" data-body="{idn}"></div></section>' if idn in ('jupiter', 'saturn') else ''
    body = f'''<p style="margin-top:20px"><a href="../planets.html">← {bi("planetsTitle")}</a></p>
<div class="bodyhead"><figure class="bodyphoto">{planet_pic(b, "../", small=False)}{f'<figcaption>📷 {esc(PHOTO_CREDIT[idn])}</figcaption>' if idn in PHOTO_CREDIT else ''}</figure><div><h1 style="margin:0">{bname(idn)}</h1><p class="sub" style="margin:.2em 0 0">{sub}</p><button class="btn favbtn" type="button" data-fav="{idn}" aria-pressed="false">☆</button></div></div>
<div class="stats">{"".join(stats)}</div>
<section class="blk"><h2>{bt("When and how it formed", "कब और कैसे बना")}</h2>{form_html(idn)}</section>
<section class="blk"><h2>{bt("Inside this world · Tap a layer", "आंतरिक संरचना · किसी परत पर टैप करें")}</h2><div class="card" id="cutawaySim" data-body="{idn}"></div></section>
<section class="blk"><h2>{bt("Telescope eyepiece simulator", "दूरबीन ज़ूम सिम्युलेटर (1x · 10x · 100x)")}</h2><div class="card" id="telescopeSim" data-body="{idn}"></div></section>
{moon_orb}
<section class="blk">{atm}</section>
<section class="blk">{lifehtml}</section>
<section class="blk">{wt}</section>
<section class="blk">{facts}</section>
<section class="blk">{moons}{dyn}</section>
{pn}'''
    en_name = tr('en', NAME_KEY[idn])
    write(f'body/{idn}.html', shell(en_name, tr('hi', NAME_KEY[idn]), 'planets', body, f'{en_name}: size, gravity, temperature, day and year length, atmosphere and facts. On Astryl.', depth=1, canonical=f'body/{idn}.html', extra_head=f'<script defer src="../assets/moons.js?v={asset_v()}"></script><script defer src="../assets/worlds.js?v={asset_v()}"></script>', ld=[{'@context': 'https://schema.org', '@type': 'WebPage', 'name': f'{en_name} · Astryl', 'url': f'{SITE}/body/{idn}.html', 'about': {'@type': 'Thing', 'name': en_name}, 'inLanguage': ['en', 'hi'], 'isPartOf': {'@type': 'WebSite', 'name': 'Astryl', 'url': SITE + '/'}}, {'@context': 'https://schema.org', '@type': 'BreadcrumbList', 'itemListElement': [{'@type': 'ListItem', 'position': 1, 'name': 'Astryl', 'item': SITE + '/'}, {'@type': 'ListItem', 'position': 2, 'name': 'Planets and moons', 'item': SITE + '/planets.html'}, {'@type': 'ListItem', 'position': 3, 'name': en_name, 'item': f'{SITE}/body/{idn}.html'}]}]))


def orrery_svg():
    '''The hero picture: the planets going round the Sun, drawn with CSS motion.'''
    plan = [('mercury', 52, 4, 14, 40), ('venus', 78, 6, 22, 200), ('earth', 104, 6.5, 32, 100), ('mars', 130, 5, 46, 300),
            ('jupiter', 164, 13, 80, 20), ('saturn', 196, 11, 112, 250), ('uranus', 222, 8, 150, 150), ('neptune', 244, 8, 190, 330)]
    defs = '<radialGradient id="orSun"><stop offset="0" stop-color="#fff3c4"/><stop offset=".5" stop-color="#f2b84b"/><stop offset="1" stop-color="#f2b84b" stop-opacity="0"/></radialGradient>'
    rings = ''
    orbs = ''
    for pid, r, pr, dur, ang in plan:
        c0, c1, c2 = BY[pid]['colors']
        defs += f'<radialGradient id="or{pid}" cx="35%" cy="32%" r="75%"><stop offset="0" stop-color="{c2}"/><stop offset=".5" stop-color="{c0}"/><stop offset="1" stop-color="{c1}"/></radialGradient>'
        rings += f'<circle class="ring" r="{r}"/>'
        ring = f'<ellipse rx="{pr * 1.9:.1f}" ry="{pr * 0.55:.1f}" fill="none" stroke="#c8b27a" stroke-width="2.4" transform="rotate(-18)"/>' if pid == 'saturn' else ''
        body = f'<circle r="{pr}" fill="url(#or{pid})"/>'
        planet = f'<g class="keep" style="animation-duration:{dur}s">{ring}{body}</g>' if ring else body
        orbs += f'<g transform="rotate({ang})"><g class="orb" style="animation-duration:{dur}s"><g transform="translate({r} 0)"><title>{esc(tr("en", NAME_KEY[pid]))}</title>{planet}</g></g></g>'
    sun = '<circle r="58" fill="url(#orSun)" opacity=".55"/><circle r="22" fill="#f2b84b"/><circle r="22" fill="url(#orSun)"/>'
    return f'<svg class="orrery" width="520" height="520" viewBox="-256 -256 512 512" role="img" aria-label="{esc("The planets going round the Sun")}"><defs>{defs}</defs>{rings}{sun}{orbs}</svg>'


def index_page():
    # (icon html, title key, English line, Hindi line, link)
    def pic(i):
        return planet_svg(BY[i], 42, 'h').replace('<svg ', '<svg width="42" height="42" ', 1)
    tiles = [(pic('saturn'), 'planetsTitle', 'All planets, Pluto and the big moons', 'सारे ग्रह, Pluto और बड़े चाँद', 'planets.html'),
             (pic('sun'), 'solarSystemTitle', 'Real positions on any date', 'किसी भी तारीख़ की असली स्थिति', 'solar-system.html'),
             (pic('moon'), 'skyTitle', 'Moon phase, calendar, meteor showers', 'चाँद की कला, calendar, उल्कापात', 'sky.html'),
             ('⭐', 'constellationsLabel', 'All 88 constellations, true to the sky', 'सभी 88 तारामंडल, आसमान जैसे', 'constellations.html'),
             ('🚀', 'missionsTitle', 'Sputnik to Chandrayaan-3', 'Sputnik से Chandrayaan-3 तक', 'missions.html'),
             ('🗺️', 'surfaceMapTitle', 'Landing sites on the Moon and Mars', 'चाँद और मंगल पर उतरने की जगहें', 'maps.html'),
             ('🎓', bt('For students', 'छात्रों के लिए'), 'Class 6 to 10: Sun, Moon, eclipses, stars', 'कक्षा 6 से 10: सूर्य, चाँद, ग्रहण, तारे', 'learn.html'),
             ('🌑', bt('Eclipses and meteor showers', 'ग्रहण और उल्कापात'), 'Every eclipse until 2029, times for your city', '2029 तक हर ग्रहण, आपके शहर के समय', 'sky-events.html'),
             ('🛰️', bt('Space station passes', 'अंतरिक्ष स्टेशन कब दिखेगा'), 'Live map and when the ISS flies over your city', 'Live नक्शा और ISS आपके शहर के ऊपर से कब गुज़रेगा', 'iss.html'),
             ('🪐', bt('Universe map', 'ब्रह्मांड का नक्शा'), 'Fly through 3,600 real galaxies in 3D', '3,600 असली आकाशगंगाओं के बीच 3D में उड़िए', 'universe-map.html'),
             ('⚫', bt('Black holes', 'ब्लैक होल'), 'How they form and what falling in would be like', 'कैसे बनते हैं और अंदर गिरना कैसा होगा', 'black-holes.html'),
             ('🌌', bt('Galaxies', 'Galaxies'), 'The Milky Way, Andromeda and beyond', 'आकाशगंगा, Andromeda और उसके आगे', 'galaxies.html'),
             ('🎓', bt('Black holes 101', 'Black holes 101'), 'Seven lessons, a quiz and a badge', 'सात पाठ, एक quiz और एक badge', 'black-holes-101.html'),
             ('📏', bt('Scale of the universe', 'ब्रह्मांड का पैमाना'), 'From a proton to everything we can see', 'प्रोटॉन से लेकर वह सब जो हम देख सकते हैं', 'cosmic-scale.html'),
             ('⏳', bt('Timeline', 'समयरेखा'), '13.8 billion years in one calendar year', '13.8 अरब साल एक कैलेंडर वर्ष में', 'universe-timeline.html'),
             ('📖', bt('Glossary', 'शब्दकोश'), 'Space words in plain English and Hindi', 'अंतरिक्ष के शब्द, सरल English और हिंदी में', 'glossary.html'),
             ('🛰️', 'spacecraftTitle', 'How far Voyager and JWST are now', 'Voyager और JWST अभी कितनी दूर हैं', 'spacecraft.html'),
             ('⚖️', 'weightTitle', 'Weight, jump and age on every world', 'हर दुनिया पर वज़न, कूद और उम्र', 'you.html'),
             (pic('earth'), 'navCompare', 'Any two worlds side by side', 'कोई भी दो दुनियाएँ आमने-सामने', 'compare.html')]
    cards = ''.join(f'<a class="sc" href="{h}"><span class="ic">{ic}</span><span><b>{k if k.startswith('<') else bi(k)}</b><small>{bt(en, hi)}</small></span><span class="go">→</span></a>' for ic, k, en, hi, h in tiles)
    quiz = ''.join(f'<a class="opt" href="quiz.html">{bi(k)}</a>' for k in ('planetJupiter', 'planetSaturn', 'planetMars', 'planetNeptune'))
    body = f'''<section class="hero2">
<div>
<h1 class="rise">{bt("Explore the", "खोजिए")} <span class="grad">{bt("Universe.", "ब्रह्मांड।")}</span></h1>
<p class="lead rise">{bt("Planets, moons, stars and space missions: real positions and real numbers for any date, in English and Hindi.", "ग्रह, चाँद, तारे और अंतरिक्ष missions: किसी भी तारीख़ की असली स्थिति और असली आँकड़े, English और हिंदी में।")}</p>
<div class="btns rise"><a class="btn primary" href="planets.html">{bt("Explore space", "अंतरिक्ष खोजिए")} →</a><a class="btn" href="quiz.html">{bt("Take the quiz", "Quiz खेलिए")}</a></div>
<p class="acctline rise">{bt("Free account: your favourites, scores and streak are kept on every device.", "मुफ़्त खाता: आपके favourites, scores और streak हर device पर साथ रहते हैं।")} <a href="account.html">{bt("Create account", "खाता बनाएँ")} →</a></p>
<div class="chips rise"><span class="chip">{bt("Free", "मुफ़्त")}</span><span class="chip">{bt("Open source", "Open source")}</span><span class="chip">{bt("No ads", "कोई विज्ञापन नहीं")}</span><span class="chip">{bt("English + हिन्दी", "English + हिन्दी")}</span></div>
</div>
{orrery_svg()}
</section>
<section class="sc-grid">{cards}</section>
<section class="journey" id="journey"><div class="stick">
<canvas id="cosmos" aria-label="{esc("Scroll to travel from the Milky Way to the Solar System, Earth and the Moon")}"></canvas>
<div class="caps">
<div class="cap on"><h2>{bt("Our galaxy", "हमारी आकाशगंगा")}</h2><p>{bt("The Milky Way holds hundreds of billions of stars. The Sun sits in one of its arms, about 26,000 light-years from the centre. Scroll to travel in.", "आकाशगंगा में सैकड़ों अरब तारे हैं। सूर्य उसकी एक भुजा में है, केंद्र से लगभग 26,000 प्रकाश-वर्ष दूर। भीतर जाने के लिए scroll करें।")}</p></div>
<div class="cap"><h2>{bt("The Solar System", "सौरमंडल")}</h2><p>{bt("Every planet in its real place today. Keep scrolling and time moves forward. Distances are squeezed so the inner planets stay visible.", "हर ग्रह आज अपनी असली जगह पर। Scroll करते रहिए, समय आगे बढ़ता है। भीतरी ग्रह दिखते रहें इसलिए दूरियाँ दबाई गई हैं।")} <a href="solar-system.html">{bt("Open the full Solar System", "पूरा सौरमंडल खोलें")}</a></p></div>
<div class="cap"><h2>{bt("Earth and the Moon", "पृथ्वी और चाँद")}</h2><p>{bt("The Moon is where it really is right now, and the Sun is on the side that lights it.", "चाँद ठीक वहीं है जहाँ वह अभी है, और सूर्य उस तरफ़ है जिधर से उसे रोशनी मिलती है।")} <a href="sky.html">{bt("Moon calendar", "चाँद का calendar")}</a></p></div>
</div>
<div class="jdate" id="jDate"></div>
<div class="jphase" id="jPhase"><canvas width="64" height="64"></canvas><span></span></div>
<div class="jdots"><i class="on"></i><i></i><i></i></div>
</div></section>
<section class="duo">
<div class="card"><h2>{bt("Tonight's sky", "आज रात का आसमान")}</h2><div class="moonrow" id="homeMoon"></div><div id="homeTonight"></div><a class="btn" href="sky.html">{bt("Open the Moon calendar", "चाँद का calendar खोलें")} →</a></div>
<div class="card"><h2>{bt("Planet quiz", "ग्रहों की quiz")}</h2><p>{bt("Ten questions in three levels, made from the planet data.", "तीन levels में दस सवाल, ग्रहों के data से बने।")}</p><div class="q">{bt("Which planet is known for its Great Red Spot?", "किस ग्रह का Great Red Spot मशहूर है?")}</div><div class="opts">{quiz}</div></div>
</section>
<section class="blk"><div class="grid daily2"><div class="card apod" id="dailyPhoto"></div><div class="card" id="dailyFact"></div></div></section>
<section class="blk"><h2>{bt("This website in numbers", "यह website आँकड़ों में")}</h2><div class="stats" id="stats"></div><p class="note" id="statsCountries"></p><p class="note" id="statsNote"></p></section>'''
    write('index.html', shell('Explore the Universe', 'ब्रह्मांड खोजिए', 'home', body, 'Astryl: planets, moons, stars and space missions. Real positions and real numbers for any date, free and open source, in English and Hindi.', canonical='', extra_head=f'<script defer src="assets/cosmos.js?v={asset_v()}"></script><script defer src="assets/tonight.js?v={asset_v()}"></script><script defer src="assets/apod.js?v={asset_v()}"></script>', ld=[{'@context': 'https://schema.org', '@type': 'WebApplication', 'name': 'Astryl', 'applicationCategory': 'EducationalApplication', 'operatingSystem': 'Any', 'description': 'Planets, moons, stars and space missions with real positions and real numbers for any date, in English and Hindi. Free.', 'url': SITE + '/', 'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'USD'}, 'inLanguage': ['en', 'hi']}, {'@context': 'https://schema.org', '@type': 'WebSite', 'name': 'Astryl', 'url': SITE + '/', 'inLanguage': ['en', 'hi']}]))


def planets_page():
    def card(b):
        return f'<a class="card pcard" data-id="{b["id"]}" data-search="{b["id"]}" href="body/{b["id"]}.html">{planet_pic(b, uid="p")}<div><b>{bname(b["id"])}</b><br><small>{val(v_diam(b))}</small></div></a>'
    groups = [('star', bt('Star', 'तारा'), [b for b in BODIES if b['kind'] == 'star']), ('planet', bt('Planets', 'ग्रह'), [b for b in BODIES if b['kind'] == 'planet']),
              ('dwarf', bt('Dwarf planet', 'बौना ग्रह'), [b for b in BODIES if b['id'] == 'pluto']), ('moon', bi('majorMoons'), [b for b in BODIES if b['kind'] == 'moon'])]
    secs = ''.join(f'<section class="blk"><h2>{t}</h2><div class="grid">{"".join(card(b) for b in bs)}</div></section>' for _, t, bs in groups)
    body = f'''<section class="blk"><h1>{bi("planetsTitle")}</h1><p class="sub">{bt("Tap a world for its size, gravity, temperature, atmosphere and facts.", "किसी दुनिया पर क्लिक करें: उसका आकार, गुरुत्वाकर्षण, तापमान, वायुमंडल और तथ्य।")}</p>
<div class="row"><input type="search" id="q" placeholder="{esc(tr("en", "searchHint"))}" aria-label="Search"></div></section>{secs}'''
    write('planets.html', shell('Planets and moons', 'ग्रह और चाँद', 'planets', body, 'Every planet, Pluto and nine major moons: diameter, gravity, temperature, day and year length, atmosphere and a life score.', canonical='planets.html', extra_head=f'<script defer src="assets/sheet.js?v={asset_v()}"></script>'))


def simple_pages():
    # solar system
    body = f'''<section class="blk"><h1>{bi("solarSystemTitle")}</h1><p class="sub">{bt("NASA Eyes-style 3D Solar System explorer: drag to rotate in 3D, scroll/pinch to zoom, and tap any planet or moon to fly the camera to it and see live telemetry below.", "NASA Eyes जैसा 3D लाइव सौरमंडल: घुमाने के लिए खींचें, ज़ूम करें, और किसी भी ग्रह या चंद्रमा पर क्लिक करके वहाँ उड़कर जाएँ व नीचे लाइव आँकड़े देखें।")}</p>
<div class="eyes-wrap"><div class="eyes-chips" id="solChips"></div><div class="eyes-stage"><canvas id="solar"></canvas><div class="eyes-badge">● <span class="t" lang="en">EYES ON SOLAR SYSTEM · 3D LIVE</span><span class="t" lang="hi">3D लाइव सौरमंडल</span></div><button class="btn eyes-back" id="solBack" style="display:none">← {bi("spaceBack")}</button></div>
<div class="row" style="margin-top:12px"><button class="btn" id="solMonthBack">« {bi("monthBack")}</button><button class="btn" id="solPlay">▶</button><button class="btn" id="solToday"></button><button class="btn" id="solMonthFwd">{bi("monthForward")} »</button><b id="solDate"></b></div>
<input type="range" id="solDay" min="-3650" max="3650" value="0" style="width:100%" aria-label="Date">
<div class="card eyes-telemetry" id="solTelemetry"></div></div>
<p class="note">{bt("Drag to tilt & rotate 3D camera · Click a planet to fly to it and see its 3D moon orbits · Distances compressed so inner and outer worlds fit together.", "3D कैमरा घुमाने के लिए खींचें · किसी ग्रह पर क्लिक करके उसकी और उसके चंद्रमाओं की 3D कक्षा देखें।")}</p></section>
<section class="blk"><h2>{bi("distanceFromEarth")}</h2><div id="solTable"></div></section>'''
    write('solar-system.html', shell('Solar System 3D Live', '3D लाइव सौरमंडल', 'solar', body, 'Interactive 3D Solar System explorer with real planet positions, moon orbits and live telemetry.', canonical='solar-system.html', extra_head=f'<script defer src="assets/sheet.js?v={asset_v()}"></script>'))
    # compare
    body = f'''<section class="blk"><h1>{bi("compareTitle")}</h1><p class="sub">{bi("compareHint")}</p><div class="row"><select id="cmpA" aria-label="A"></select><span>vs</span><select id="cmpB" aria-label="B"></select></div><div id="cmpOut"></div></section>'''
    write('compare.html', shell('Compare planets', 'ग्रहों की तुलना', 'compare', body, 'Compare any two planets or moons side by side.', canonical='compare.html'))
    # you
    body = f'''<section class="blk"><h1>{bi("weightTitle")}</h1><p><a class="btn primary" href="#bday">🎂 {bt("Jump to your birthday sky", "अपने जन्मदिन के आसमान पर जाएँ")} ↓</a></p>
<div class="row"><label>{bi("weightInput")}<br><input type="number" id="kg" value="60" min="0" step="1"></label><label>{bi("jumpInput")}<br><input type="number" id="cm" value="40" min="0" step="1"></label></div>
<p class="note">{bi("jumpNote")}</p><div id="wOut"></div></section>
<section class="blk" id="bday"><h2>🎂 {bi("setBirthDate")}</h2><div class="row"><input type="date" id="birth" aria-label="Birth date"></div><p class="note">{bt("Worked out in your browser. Nothing is sent or saved.", "आपके browser में ही निकाला जाता है। कुछ भेजा या save नहीं किया जाता।")}</p><div id="ageOut"></div><div id="bdOut"></div><div id="bsOut"></div><script type="application/json" id="bsStars">{myspace.birthday_stars()}</script></section>'''
    write('you.html', shell('Weight, age and birthday sky', 'वज़न, उम्र और जन्मदिन का आसमान', 'you', body, 'Your weight, jump height and age on every planet, the Moon and the planets on the day you were born, how far your birthday light has travelled, and a picture to share.', canonical='you.html', extra_head=f'<script defer src="assets/birthday.js?v={asset_v()}"></script>'))
    # quiz
    body = f'''<section class="blk"><h1>{bi("quizTitle")}</h1><div id="daily" class="daily"></div></section>
<section class="blk"><h2>{bt("Rounds for Space Points", "Space Points वाले rounds")}</h2><p class="sub">{bt("Real NASA photos, constellations, missions, bigger or smaller and best guess. Log in and every right answer earns Space Points.", "NASA की असली तस्वीरें, नक्षत्र, missions, बड़ा या छोटा और अंदाज़ा। Log in करें तो हर सही जवाब पर Space Points मिलते हैं।")}</p><div id="rounds"></div></section>
<section class="blk"><h2>{bt("Practice", "अभ्यास")}</h2><div id="quiz"></div></section>'''
    write('quiz.html', shell('Space quiz', 'अंतरिक्ष quiz', 'quiz', body, 'A space quiz: real NASA photos, constellations, missions, bigger or smaller, best guess and planet levels, with Space Points and a leaderboard.', canonical='quiz.html', extra_head=f'<script defer src="assets/quiz-bank.js?v={asset_v()}"></script><script defer src="assets/rounds.js?v={asset_v()}"></script>'))
    # sky
    body = f'''<section class="blk"><h1>{bi("skyTitle")}</h1><div class="card" id="moonNow"></div></section>
<section class="blk"><h2>{bt("Planets tonight", "आज रात के ग्रह")}</h2><div class="card" id="planetsTonight"></div></section>
<section class="blk"><h2>{bi("moonCalendar")}</h2><div class="row"><button class="btn" id="calPrev">‹ {bi("previousMonth")}</button><b id="calTitle"></b><button class="btn" id="calNext">{bi("nextMonth")} ›</button></div><div class="moons" id="calGrid"></div><div id="calPhases" style="margin-top:14px"></div><p class="note">{bi("moonCalendarNote")}</p></section>
<section class="blk"><h2>{bi("eventsTitle")}</h2><p class="sub">{bt("Meteor shower peaks for the next 12 months, with how bright the Moon will be on the peak night.", "अगले 12 महीनों में उल्कापात के चरम दिन, और उस रात चाँद कितना चमकीला होगा।")}</p><div class="grid" id="showers"></div></section>
<section class="blk callout"><b>{bt("Want it for your city?", "अपने शहर के लिए चाहिए?")}</b> {bt("My space shows sunset, moonrise and the planets you can see tonight from your city, and the space station page shows when the ISS flies over you.", "My space में आपके शहर का सूर्यास्त, चाँद का उगना और आज रात दिखने वाले ग्रह हैं, और अंतरिक्ष स्टेशन वाला page बताता है कि ISS आपके ऊपर से कब गुज़रेगा।")} <a href="my-space.html">{bt("Open My space", "My space खोलें")}</a> · <a href="iss.html">{bt("Space station passes", "अंतरिक्ष स्टेशन कब दिखेगा")}</a></section>'''
    write('sky.html', shell('Moon and sky', 'चाँद और आसमान', 'sky', body, "Tonight's Moon phase, a Moon calendar and the next meteor showers.", canonical='sky.html'))
    # spacecraft
    body = f'''<section class="blk"><h1>{bi("spacecraftTitle")}</h1><p class="sub">{bi("spacecraftSubtitle")}</p><div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(300px,1fr))" id="craft"></div><p class="note">{bi("spacecraftNote")}</p></section>'''
    write('spacecraft.html', shell('Spacecraft now', 'अंतरिक्ष यान अभी', 'missions', body, 'How far Voyager 1, Voyager 2, New Horizons, JWST, the ISS, Hubble and the Mars rovers are from Earth right now.', canonical='spacecraft.html'))
    # missions
    items = ''.join(f'<div class="m"><div class="y">{m["y"]}</div><h3>{m["name"]} <small class="note">· {m["agency"]}</small></h3><p>{bi("mission" + m["id"].capitalize())}</p></div>' for m in MISSIONS)
    body = f'''<section class="blk"><h1>{bi("missionsTitle")}</h1><p class="sub">{bi("missionsSubtitle")}</p><div class="tl">{items}</div><p><a class="btn" href="spacecraft.html">🛰️ {bi("spacecraftTitle")}</a></p></section>'''
    write('missions.html', shell('Space missions', 'अंतरिक्ष missions', 'missions', body, 'Famous moments in space exploration, from Sputnik 1 to Chandrayaan-3.', canonical='missions.html'))
    # constellations
    stories = {c: f'story{c}' for c in ('Ori', 'UMa', 'UMi', 'Cas', 'Cyg', 'Sco', 'Leo', 'Tau', 'Gem', 'Lyr', 'Cru')}
    cons.build_page(dict(bt=bt, bi=bi, esc=esc, write=write, shell=shell), CONS, stories)


def maps_page():
    colors = dict(crewed='#f5a524', lander='#5b8cff', rover='#2fbf71', sample='#b07cff')
    kind_key = dict(crewed='siteKindCrewed', lander='siteKindLander', rover='siteKindRover', sample='siteKindSample')

    def svg(world):
        moon = world == 'moon'
        base, shade, high = ('#9c978e', '#55524d', '#c4bfb5') if moon else ('#b5683f', '#6e3a22', '#d9915f')
        o = f'<svg viewBox="0 0 360 180" role="img" aria-label="{esc(tr("en", "surfaceMapOf", body=tr("en", "bodyMoon" if moon else "planetMars")))}" style="width:100%;height:auto;border-radius:16px;display:block"><rect width="360" height="180" fill="{base}"/>'
        for f in [f for f in FEATS if f['world'] == world]:
            cx, cy = f['lon'] + 180, 90 - f['lat']
            for dx in (-360, 0, 360):
                x = cx + dx
                if x + f['rx'] < 0 or x - f['rx'] > 360:
                    continue
                tf = f'transform="rotate({-f["tilt"]} {x:.2f} {cy:.2f})"' if f['tilt'] else ''
                e = f'cx="{x:.2f}" cy="{cy:.2f}" rx="{f["rx"]}" ry="{f["ry"]}" {tf}'
                k = f['kind']
                if k == 'sea': o += f'<ellipse {e} fill="{shade}" fill-opacity=".62"/>'
                elif k == 'basin': o += f'<ellipse {e} fill="{shade}" fill-opacity=".42" stroke="{shade}" stroke-opacity=".7" stroke-width=".8"/>'
                elif k in ('crater', 'volcano'): o += f'<ellipse {e} fill="{high}" fill-opacity=".9" stroke="{shade}" stroke-opacity=".8" stroke-width=".8"/>'
                elif k == 'canyon': o += f'<ellipse {e} fill="{shade}" fill-opacity=".85"/>'
                elif k == 'highland': o += f'<ellipse {e} fill="{high}" fill-opacity=".5"/>'
                elif k == 'cap': o += f'<ellipse {e} fill="#fff" fill-opacity=".9"/>'
        for lon in range(0, 361, 30):
            o += f'<line x1="{lon}" y1="0" x2="{lon}" y2="180" stroke="#fff" stroke-opacity=".16" stroke-width=".4"/>'
        for lat in range(0, 181, 30):
            o += f'<line x1="0" y1="{lat}" x2="360" y2="{lat}" stroke="#fff" stroke-opacity=".16" stroke-width=".4"/>'
        for f in [f for f in FEATS if f['world'] == world and f['major'] and f['kind'] != 'cap']:
            en = L['en']['feat' + f['id']].split(' (')[0]
            tx = min(max(f["lon"] + 180, 30), 330)
            o += f'<text x="{tx:.1f}" y="{90 - f["lat"]:.1f}" font-size="5" fill="#fff" text-anchor="middle" stroke="#000" stroke-opacity=".5" stroke-width=".6" paint-order="stroke" class="t" lang="en">{esc(en)}</text>'
            hi = L['hi']['feat' + f['id']].split(' (')[0]
            o += f'<text x="{tx:.1f}" y="{90 - f["lat"]:.1f}" font-size="5" fill="#fff" text-anchor="middle" stroke="#000" stroke-opacity=".5" stroke-width=".6" paint-order="stroke" class="t" lang="hi">{esc(hi)}</text>'
        for si in [x for x in SITES if x['world'] == world]:
            o += f'<a href="#site-{si["id"]}"><circle cx="{si["lon"] + 180:.2f}" cy="{90 - si["lat"]:.2f}" r="2.6" fill="{colors[si["kind"]]}" stroke="#fff" stroke-width="1"><title>{esc(si["name"])}</title></circle></a>'
        return o + '</svg>'

    def fmtll(lat, lon):
        return f'{abs(lat):.2f}° {"N" if lat >= 0 else "S"}, {abs(lon):.2f}° {"E" if lon >= 0 else "W"}'
    legend = ''.join(f'<span style="display:inline-flex;align-items:center;gap:6px;margin-right:14px"><i style="width:12px;height:12px;border-radius:50%;background:{c};border:1.5px solid #fff;display:inline-block"></i>{bi(kind_key[k])}</span>' for k, c in colors.items())
    secs = ''
    for world, title_key in (('moon', 'bodyMoon'), ('mars', 'planetMars')):
        cards = ''.join(f'<div class="card" id="site-{x["id"]}"><div class="y" style="font:700 1rem Space Grotesk;color:var(--accent)">{x["year"]}</div><h3>{esc(x["name"])} <small class="note">· {x["agency"]} · {bi(kind_key[x["kind"]])}</small></h3><p class="note">{fmtll(x["lat"], x["lon"])}</p><p style="color:var(--text)">{bi("site" + x["id"])}</p></div>' for x in sorted([x for x in SITES if x['world'] == world], key=lambda x: (x['year'], x['name'])))
        secs += f'<section class="blk"><h2>{bi(title_key)}</h2><p class="sub">{bi("surfaceMapMoonHint" if world == "moon" else "surfaceMapMarsHint")}</p>{svg(world)}<p style="margin-top:10px">{legend}</p><div class="grid" style="margin-top:14px">{cards}</div></section>'
    body = f'''<section class="blk"><h1>{bi("surfaceMapTitle")}</h1><p class="sub">{bi("surfaceMapNote")}</p></section>{secs}
<style>.card:target{{border-color:var(--accent);box-shadow:0 0 0 2px var(--accent)}}</style>'''
    write('maps.html', shell('Moon and Mars surface maps', 'चाँद और मंगल के नक़्शे', 'maps', body, 'Landing sites on the Moon and Mars at their real coordinates: Apollo, Chang\'e, Chandrayaan, Viking, Curiosity, Perseverance and more.', canonical='maps.html'))


def get_page():
    # The Android app is no longer offered here; old links to get.html go to the home page.
    body = f'''<section class="blk"><h1>{bt("Astryl is a website", "Astryl एक website है")}</h1><p class="sub">{bt("Everything is here on astryl.space, in your browser. Taking you to the home page…", "सब कुछ यहीं astryl.space पर, आपके browser में है। आपको home page पर ले जा रहे हैं…")}</p><p><a class="btn primary" href="index.html">{bt("Go to the home page", "Home page पर जाएँ")} →</a></p></section>'''
    write('get.html', shell('Astryl', 'Astryl', 'home', body, 'Astryl is a website: astryl.space.', canonical='index.html', extra_head='<meta name="robots" content="noindex"><meta http-equiv="refresh" content="2;url=index.html">'))


def privacy_page():
    def li(en, hi):
        return f'<li>{bt(en, hi)}</li>'
    def tr(a_en, a_hi, b_en, b_hi, c_en, c_hi):
        return f'<tr><td>{bt(a_en, a_hi)}</td><td>{bt(b_en, b_hi)}</td><td>{bt(c_en, c_hi)}</td></tr>'
    toc = [("1", "Who is responsible", "ज़िम्मेदार कौन है"), ("2", "On your phone or in your browser", "आपके फ़ोन या browser में"), ("3", "The account", "खाता"),
           ("4", "Optional switches", "वैकल्पिक switches"), ("5", "Crash reports", "Crash reports"), ("6", "Where data is kept", "Data कहाँ रखा जाता है"),
           ("7", "This website", "यह website"), ("8", "Your choices and rights", "आपके विकल्प और अधिकार"), ("9", "Children", "बच्चे"), ("10", "Changes", "बदलाव")]
    toc_html = ''.join(f'<a href="#s{n}">{n}. {bt(en, hi)}</a>' for n, en, hi in toc)
    body = f"""<section class="blk policy-head"><h1>{bt("Privacy Policy", "Privacy Policy")}</h1>
<p class="note">{bt("Last updated 12 November 2026 · applies to astryl.space, and to the old Astryl Android app for people who still use it (it gets no new versions; 1.40.0 was the last)", "आख़िरी बार 12 नवंबर 2026 को बदली गई · astryl.space पर लागू, और पुराने Astryl Android app पर भी, उनके लिए जो उसे अब भी चलाते हैं (उसके नए version नहीं आएँगे; 1.40.0 आख़िरी था)")}</p>
<p class="sub">{bt("In plain words: we do not sell anything about you, there are no ads, and you can use everything without an account. This page lists exactly what is kept when you do choose something, and how to remove it.", "सीधे शब्दों में: हम आपके बारे में कुछ नहीं बेचते, कोई विज्ञापन नहीं है, और आप खाते के बिना सब कुछ इस्तेमाल कर सकते हैं। जब आप कुछ चुनते हैं तब क्या रखा जाता है और उसे कैसे हटाएँ, यह पूरा इसी page पर है।")}</p>
<div class="glance">
<div class="card"><div class="ico">🚫</div><h3>{bt("No ads, nothing sold", "कोई विज्ञापन नहीं, कुछ बिकता नहीं")}</h3><p>{bt("No ad networks, no data brokers, no third-party analytics.", "कोई ad network, data broker या बाहरी analytics नहीं।")}</p></div>
<div class="card"><div class="ico">👤</div><h3>{bt("One account, no e-mail", "एक खाता, e-mail नहीं")}</h3><p>{bt("The app needs an account; the website does not. Just a username and a password, no e-mail, name or phone number.", "App के लिए खाता चाहिए, website के लिए नहीं। बस username और password, e-mail, नाम या फ़ोन नंबर नहीं।")}</p></div>
<div class="card"><div class="ico">📊</div><h3>{bt("Counted, not tracked", "गिनती, पीछा नहीं")}</h3><p>{bt("Page views are only added up: no cookie, no IP address, no id.", "Page views बस जोड़े जाते हैं: कोई cookie, IP address या id नहीं।")}</p></div>
<div class="card"><div class="ico">🗑️</div><h3>{bt("You can delete it all", "सब कुछ आप मिटा सकते हैं")}</h3><p>{bt("One button deletes your account and everything stored for it.", "एक button आपका खाता और उससे जुड़ा सारा data मिटा देता है।")}</p></div>
</div></section>
<section class="blk policy-layout"><nav class="toc" aria-label="Contents"><b>{bt("On this page", "इस page पर")}</b>{toc_html}</nav>
<div class="policy">
<h2 id="s1">{bt("1. Who is responsible", "1. ज़िम्मेदार कौन है")}</h2>
<p>{bt("For questions about your data, write to", "अपने data के बारे में सवाल हों तो यहाँ लिखें:")} <a href="mailto:contact@astryl.space">contact@astryl.space</a>.</p>

<h2 id="s2">{bt("2. On your phone or in your browser", "2. आपके फ़ोन या browser में")}</h2>
<ul>
{li("Planet facts, the Moon, planet positions, eclipses, the star map and the quiz are worked out on your phone or in your browser.", "ग्रहों के तथ्य, चाँद, ग्रहों की स्थिति, ग्रहण, star map और quiz आपके फ़ोन या browser में ही निकाले जाते हैं।")}
{li("Your city, birth date, favourites, quiz scores and settings are saved on your phone. The Backup file is made by you and goes only where you send it.", "आपका शहर, जन्मतिथि, favourites, quiz scores और settings आपके फ़ोन में save होते हैं। Backup file आप बनाते हैं और वह वहीं जाती है जहाँ आप भेजें।")}
{li("Update check: each time the app opens, it asks GitHub for the newest release and, if there is one, offers it first (you can tap Skip). GitHub sees your IP address, like in any web request.", "Update check: app हर बार खुलने पर GitHub से सबसे नया release पूछता है और नया हो तो सबसे पहले वही दिखाता है (आप Skip दबा सकते हैं)। जैसे हर web request में होता है, GitHub आपका IP address देख सकता है।")}
{li("Astryl news (on by default, switch it off in Settings): about every six hours the app asks the Astryl server \"anything new?\" and shows a notification when the team has published a note. Only that question is sent, with nothing about you, and nothing is stored about the check.", "Astryl की ख़बरें (डिफ़ॉल्ट रूप से चालू, Settings में बंद करें): लगभग हर छह घंटे में app Astryl server से पूछता है \"कुछ नया है?\" और टीम ने कोई सूचना डाली हो तो notification दिखाता है। सिर्फ़ यही सवाल जाता है, आपके बारे में कुछ नहीं, और इस जाँच के बारे में कुछ संग्रहित नहीं होता।")}
{li("Live features are always on. The app downloads orbit data, the rocket launch list, space news and NASA’s space photo of the day from public services (wheretheiss.at, Celestrak, Launch Library 2, Spaceflight News API, NASA through the Astryl server), which can see your IP address. Nothing about you is sent.", "Live features हमेशा चालू रहते हैं। App public services (wheretheiss.at, Celestrak, Launch Library 2, Spaceflight News API, Astryl server के ज़रिए NASA) से orbit data, rocket launch की list, space news और NASA की आज की अंतरिक्ष तस्वीर लेता है, जो आपका IP address देख सकती हैं। आपके बारे में कुछ नहीं भेजा जाता।")}
{li("“Use my location” in the city list asks Android for your approximate location, once, and uses it only on your phone to work out the sky. Nothing is sent for this.", "शहर की list में “मेरी location इस्तेमाल करें” Android से आपकी अनुमानित location एक बार माँगता है और उसे सिर्फ़ आपके फ़ोन पर आसमान निकालने में इस्तेमाल करता है। इसके लिए कुछ नहीं भेजा जाता।")}
</ul>

<h2 id="s3">{bt("3. The account", "3. खाता")}</h2>
<p>{bt("The account is for one thing: keeping your favourites, scores and settings in step between the app and this website. It needs a username and a password. No e-mail address, name or phone number is asked for. The app asks you to make an account (or log in) when it is first opened. On the website the account is optional: “Continue without account” lets you look around.", "खाते का एक ही काम है: आपके favourites, scores और settings को app और इस website के बीच एक जैसा रखना। इसके लिए username और password चाहिए। e-mail, नाम या फ़ोन नंबर नहीं माँगा जाता। App पहली बार खुलने पर खाता बनाने (या log in करने) को कहता है। Website पर खाता वैकल्पिक है: “बिना खाते के आगे बढ़ें” दबाकर आप बस घूमकर देख सकते हैं।")}</p>
<table><tr><th>{bt("What we store", "हम क्या रखते हैं")}</th><th>{bt("Why", "क्यों")}</th><th>{bt("For how long", "कब तक")}</th></tr>
{tr("Your username and a hash of your password (the password itself is never stored or visible to us)", "आपका username और password का hash (password ख़ुद कभी store नहीं होता और हमें दिखता नहीं)", "To log you in", "आपको log in कराने के लिए", "Until you delete the account", "जब तक आप खाता नहीं मिटाते")}
{tr("A hash of your recovery code, how many times it can still be used, failed tries", "Recovery code का hash, वह कितनी बार और चल सकता है, ग़लत कोशिशें", "So you can set a new password if you forget it", "ताकि password भूलने पर आप नया लगा सकें", "Until you delete the account", "जब तक आप खाता नहीं मिटाते")}
{tr("The date you accepted this policy and its version, the date you joined, the date you last used the account", "आपने यह policy कब मानी और उसका version, आप कब जुड़े, खाता आख़िरी बार कब इस्तेमाल हुआ", "To show your consent and run the account", "आपकी सहमति दिखाने और खाता चलाने के लिए", "Until you delete the account", "जब तक आप खाता नहीं मिटाते")}
{tr("If sync is on: favourites, quiz scores (also the website’s black hole and galaxy quiz), which lessons you have read (Black holes, Galaxies and For students, in the app or on this website), the “I’ve seen it” list, language, theme, text size, city (never a GPS place), birth date and the daily sky note setting. Other website pages you have read stay in your browser and are never sent.", "Sync चालू हो तो: favourites, quiz scores (website की black hole और galaxy quiz भी), कौन-से पाठ पढ़े (Black holes, Galaxies और छात्रों के लिए, app में या इस website पर), “मैंने देखा” वाली list, भाषा, theme, text size, शहर (GPS वाली जगह कभी नहीं), जन्मतिथि और रोज़ के आसमान वाले note की setting। Website के बाक़ी pages जो आपने पढ़े वे आपके browser में ही रहते हैं, कभी भेजे नहीं जाते।", "To keep the app and the website in step", "App और website को एक जैसा रखने के लिए", "Until you delete the account or switch sync off and delete it", "जब तक आप खाता नहीं मिटाते")}
{tr("Daily 5: for each day you play, your score, how many answers were right and how long it took", "Daily 5: आप जिस दिन खेलें, उस दिन का score, कितने जवाब सही थे और कितना समय लगा", "To make the leaderboard and rank you", "Leaderboard बनाने और आपकी rank बताने के लिए", "Until you delete the account", "जब तक आप खाता नहीं मिटाते")}
{tr("Quiz rounds (only when you play one while logged in): which questions you got, your answers with their time, the points of each round, and your Space Points in all and this week. The leaderboard shows only your username and points, and the “Show me on the leaderboard” switch hides you there too", "Quiz rounds (सिर्फ़ तब जब आप log in करके खेलें): आपको कौन-से सवाल मिले, आपके जवाब और उनका समय, हर round के points, और आपके कुल व इस हफ़्ते के Space Points। Leaderboard पर सिर्फ़ आपका username और points दिखते हैं, और “मुझे leaderboard में दिखाएँ” switch से आप वहाँ से भी छिप जाते हैं", "To check each answer on the server, keep the points fair and show the leaderboard", "Server पर हर जवाब जाँचने, points को निष्पक्ष रखने और leaderboard दिखाने के लिए", "Until you delete the account", "जब तक आप खाता नहीं मिटाते")}
{tr("An optional profile photo (a small 256 px square picture you choose yourself)", "एक वैकल्पिक profile फ़ोटो (आपकी चुनी हुई छोटी 256 px चौकोर तस्वीर)", "To show it on your own passport and profile; it is not shown to other people and not on the leaderboard", "सिर्फ़ आपके अपने passport और profile पर दिखाने के लिए; दूसरों को या leaderboard पर नहीं दिखती", "Until you remove it or delete the account", "जब तक आप उसे हटाएँ या खाता मिटाएँ")}
</table>
<p>{bt("Your birth date is stored only if you have entered it in the app and sync is on. Turn sync off in the You tab → Account to stop this.", "आपकी जन्मतिथि तभी रखी जाती है जब आपने उसे app में लिखा हो और sync चालू हो। इसे रोकने के लिए You tab → Account में sync बंद करें।")}</p>
<p>{bt("The recovery code is shown once when you make the account. Keep it safe: it is the only way back in if you forget your password, it works 3 times, and nobody (including us) can read it back. If you lose both the password and the code, the account cannot be recovered.", "Recovery code खाता बनाते समय एक बार दिखता है। इसे सुरक्षित रखें: password भूलने पर वापस आने का यही अकेला रास्ता है, यह 3 बार चलता है, और इसे कोई (हम भी) वापस नहीं पढ़ सकता। Password और code दोनों खो जाएँ तो खाता वापस नहीं मिल सकता।")}</p>

<h2 id="s4">{bt("4. Switches (you can change each one in your account)", "4. Switches (हर एक आप अपने खाते में बदल सकते हैं)")}</h2>
<ul>
{li("Count me as an active user: the app sends a random number made on your phone, at most once every few hours, with no username. It is not linked to you or your account. It is kept for 90 days and is used only to show how many people use Astryl.", "मुझे active user में गिनें: app आपके फ़ोन पर बना एक random number भेजता है, कुछ घंटों में ज़्यादा से ज़्यादा एक बार, बिना username के। यह आपसे या आपके खाते से जुड़ा नहीं होता। यह 90 दिन रखा जाता है और सिर्फ़ यह दिखाने में लगता है कि Astryl कितने लोग इस्तेमाल करते हैं।")}
{li("Share my country: the country from your phone's (or browser's) language and region setting, kept with that random number and shown only as a count per country. It is not worked out from your IP address or your location.", "मेरा देश बताएँ: आपके फ़ोन (या browser) की भाषा और region setting वाला देश, उसी random number के साथ रखा जाता है और सिर्फ़ हर देश की गिनती के रूप में दिखता है। यह आपके IP address या location से नहीं निकाला जाता।")}
{li("Share my approximate location (app only, needs an account): when you make an account, the app asks Android for the location permission. If you allow it, this switch is on and the app sends Android's approximate location (a few kilometres) when you open it, at most once a day. The server rounds it to about 10 km and keeps only the latest place with its date, tied to your account. There is no location in the background. Switch it off in your account and the place is deleted from the server. If you say no to the permission, nothing is sent.", "मेरी अनुमानित location बताएँ (सिर्फ़ app में, खाता चाहिए): खाता बनाते समय app Android से location की अनुमति माँगता है। आप अनुमति दें तो यह switch चालू हो जाता है और app आपके app खोलने पर Android की अनुमानित location (कुछ किलोमीटर तक) भेजता है, दिन में ज़्यादा से ज़्यादा एक बार। Server उसे लगभग 10 किमी में गोल करके सिर्फ़ सबसे ताज़ा जगह तारीख़ के साथ, आपके खाते से जुड़ी रखता है। Background में कोई location नहीं ली जाती। अपने खाते में switch बंद करने पर वह जगह server से मिट जाती है। अनुमति न दें तो कुछ नहीं भेजा जाता।")}
{li("Show me on the leaderboard (on by default): the Daily 5 leaderboard shows your username, score, right answers and time. Switch it off in your account (website or the You tab in the app) and your name no longer appears; your own rank stays visible to you.", "मुझे leaderboard में दिखाएँ (डिफ़ॉल्ट रूप से चालू): Daily 5 leaderboard में आपका username, score, सही जवाब और समय दिखता है। इसे अपने खाते (website या app के You tab) में बंद करें तो आपका नाम नहीं दिखता; आपकी अपनी rank आपको दिखती रहती है।")}
</ul>

<h2 id="s5">{bt("5. Crash reports (on by default, you can switch them off)", "5. Crash reports (डिफ़ॉल्ट रूप से चालू, आप बंद कर सकते हैं)")}</h2>
<ul>
{li("If the app crashes, it sends one small report to the Astryl server: the error text, the technical trace of where it happened, the app version, the Android version string and the app language. It contains no name, no account, no device id, no IP address (the server keeps none in readable form) and no location.", "App crash हो तो वह Astryl server को एक छोटा report भेजता है: error का text, कहाँ हुआ उसका technical trace, app version, Android version string और app की भाषा। उसमें कोई नाम, खाता, device id, IP address (server उसे पढ़ने लायक़ रूप में नहीं रखता) या location नहीं होती।")}
{li("It is used only to find and fix bugs, and is kept for 90 days. If the phone is offline, the report waits on the phone and is sent later.", "इसका इस्तेमाल सिर्फ़ bugs ढूँढने और ठीक करने के लिए होता है, और यह 90 दिन रखा जाता है। फ़ोन offline हो तो report फ़ोन पर रुका रहता है और बाद में भेजा जाता है।")}
{li("Turn it off in the You tab → Send crash reports. Nothing is then kept or sent, and reports still waiting on the phone are not sent.", "इसे You tab → Crash reports भेजें में बंद करें। तब कुछ रखा या भेजा नहीं जाता, और फ़ोन पर रुके reports भी नहीं भेजे जाते।")}
</ul>

<h2 id="s6">{bt("6. Where the data is kept and who handles it", "6. Data कहाँ रखा जाता है और कौन सँभालता है")}</h2>
<p>{bt("Account data is stored with Supabase (database and login service), on servers in Singapore. The app and this website reach it only through one function that checks who is asking; the tables themselves cannot be read from outside. To limit abuse, a hashed (not readable) key and a counter are kept for up to 2 days; no IP address is stored in readable form. This website is a plain static site, and downloads and the update check use GitHub, which follows its own privacy statement. We do not sell data, show ads, use third-party analytics or trackers, or share data with anyone else.", "खाते का data Supabase (database और login service) के पास, सिंगापुर के servers पर, रखा जाता है। App और यह website उस तक सिर्फ़ एक function से पहुँचते हैं, जो जाँचता है कि कौन माँग रहा है; tables को बाहर से पढ़ा नहीं जा सकता। दुरुपयोग रोकने के लिए hash किया हुआ (पढ़ने लायक़ नहीं) key और एक counter ज़्यादा से ज़्यादा 2 दिन रखा जाता है; IP address पढ़ने लायक़ रूप में नहीं रखा जाता। यह website एक सादी static site है, और downloads व update check GitHub से होते हैं, जो अपनी privacy policy के हिसाब से चलता है। हम data बेचते नहीं, विज्ञापन नहीं दिखाते, बाहरी analytics या trackers इस्तेमाल नहीं करते, और किसी और से data साझा नहीं करते।")}</p>

<h2 id="s7">{bt("7. This website", "7. यह website")}</h2>
<ul>
{li("No cookies, no ads, no third-party analytics, scripts or fonts. Everything is calculated in your browser.", "कोई cookies, विज्ञापन, बाहरी analytics, scripts या fonts नहीं। सब कुछ आपके browser में calculate होता है।")}
{li("Your browser remembers language, theme, quiz scores and whether you have seen the welcome window, in local storage on your own device. If you log in, a login token is kept there too, until you log out.", "आपका browser भाषा, theme, quiz scores और यह कि आपने welcome window देख ली है, आपके अपने device की local storage में याद रखता है। Log in करने पर वहीं एक login token भी रहता है, log out करने तक।")}
{li("The first time you open the site, a welcome window offers to create an account or log in. “Continue without account” closes it and the site remembers that choice on your device.", "Site पहली बार खोलने पर एक welcome window खाता बनाने या log in करने का विकल्प देती है। “बिना खाते के आगे बढ़ें” उसे बंद कर देता है और site आपके device पर वह चुनाव याद रखती है।")}
{li("A small notice at the bottom of the page can show a note from the Astryl team (you can close it) and, once, ask whether you want to share your approximate place. Your answer is remembered on your device. See “Visitors and places” below.", "Page के नीचे एक छोटी सूचना Astryl टीम का कोई संदेश दिखा सकती है (आप उसे बंद कर सकते हैं) और एक बार पूछ सकती है कि क्या आप अपनी अनुमानित जगह बताना चाहते हैं। आपका जवाब आपके device पर याद रखा जाता है। नीचे “Visitors और जगहें” देखें।")}
{li("The home page asks the Astryl server for the public counter (accounts, active users, visitors, page views).", "Home page Astryl server से public counter (खाते, active users, visitors, page views) माँगता है।")}
{li("To work offline and open fast, the website keeps copies of its own pages, scripts and pictures in your browser (a service worker cache). It stores nothing about you and sends nothing. Clearing the site data in your browser removes it; installing the website only adds an icon.", "Offline चलने और जल्दी खुलने के लिए website अपने pages, scripts और तस्वीरों की copies आपके browser में रखती है (service worker cache)। इसमें आपके बारे में कुछ नहीं रखा या भेजा जाता। Browser में site का data साफ़ करने से यह हट जाता है; website install करने से बस एक icon जुड़ता है।")}
{li("The home page shows NASA’s Astronomy Picture of the Day. The text comes through the Astryl server; the picture loads straight from NASA’s server (assets.science.nasa.gov), which sees your IP address like any website. The space station page gets the station’s orbit data from the Astryl server (or, if that fails, from wheretheiss.at). Nothing about you is sent.", "Home page पर NASA की Astronomy Picture of the Day दिखती है। उसका text Astryl server से आता है; तस्वीर सीधे NASA के server (assets.science.nasa.gov) से load होती है, जो किसी भी website की तरह आपका IP address देखता है। अंतरिक्ष स्टेशन वाला page station की कक्षा का data Astryl server से (या वह न चले तो wheretheiss.at से) लेता है। आपके बारे में कुछ नहीं भेजा जाता।")}
</ul>
<h3>{bt("Counting page views", "Page views की गिनती")}</h3>
<p>{bt("To see which pages are read, each page view adds one to a daily total on the Astryl server. This is what is counted, and nothing else:", "यह देखने के लिए कि कौन से pages पढ़े जाते हैं, हर page view Astryl server पर एक दिन के कुल में एक जोड़ता है। बस यही गिना जाता है, और कुछ नहीं:")}</p>
<table><tr><th>{bt("Counted", "गिना जाता है")}</th><th>{bt("Not stored at all", "बिल्कुल नहीं रखा जाता")}</th></tr>
<tr><td>{bt("The page name, the language, a size class of your screen (small, medium or large), the website that sent you here (if any), and the country.", "Page का नाम, भाषा, आपकी screen का आकार (छोटी, मध्यम या बड़ी), जिस website से आप आए (अगर कोई), और देश।")}</td><td>{bt("Your IP address itself, a cookie, any id, the time of day, your browser or device model, or anything that could point to one person.", "आपका IP address ख़ुद, cookie, कोई id, दिन का समय, आपका browser या device model, या कुछ भी जो किसी एक व्यक्ति की ओर इशारा करे।")}</td></tr></table>
<p>{bt("The country is read by the network from the connection when the request arrives; the address itself is not kept. A row only says, for example, “on 9 November, the page planets.html was opened 12 times in English from a medium screen in Armenia”. Rows are kept for 400 days. Nothing is counted if your browser sends “Do Not Track” or “Global Privacy Control”.", "Request पहुँचते समय network connection से देश पढ़ लेता है; address ख़ुद नहीं रखा जाता। एक row बस इतना कहती है, जैसे “9 नवंबर को planets.html page अंग्रेज़ी में, मध्यम screen से, आर्मीनिया में 12 बार खुला”। Rows 400 दिन रखी जाती हैं। आपका browser “Do Not Track” या “Global Privacy Control” भेजे तो कुछ नहीं गिना जाता।")}</p>

<h3>{bt("Visitors and places", "Visitors और जगहें")}</h3>
<p>{bt("To see how many different people visit, the Astryl server makes a one-way code from your IP address, the day and a secret that only the server knows, and adds that code to the list for the day. The IP address itself is not saved. The code cannot be turned back into an address, and it is different on every day, so a person cannot be followed from one day to the next. The codes are deleted after 90 days. This is not done if your browser sends “Do Not Track” or “Global Privacy Control”.", "यह देखने के लिए कि कितने अलग लोग आते हैं, Astryl server आपके IP address, दिन और एक ऐसे secret से, जो सिर्फ़ server जानता है, एक एकतरफ़ा code बनाता है और उस दिन की सूची में जोड़ देता है। IP address ख़ुद सेव नहीं होता। Code को वापस address में नहीं बदला जा सकता और वह हर दिन अलग होता है, इसलिए किसी व्यक्ति का एक दिन से दूसरे दिन पीछा नहीं हो सकता। Codes 90 दिन बाद मिटा दिए जाते हैं। अगर आपका browser “Do Not Track” या “Global Privacy Control” भेजता है तो यह नहीं होता।")}</p>
<p>{bt("The place question is optional. If you press “Share”, your browser asks for permission; the point is rounded to about 10 km and added to a count for the day. It carries no code, no account and no IP address, so it cannot be tied to you. If you say no, nothing is sent. Your answer is kept only in your browser.", "जगह वाला सवाल वैकल्पिक है। “बताएँ” दबाने पर आपका browser अनुमति माँगता है; बिंदु को लगभग 10 km तक गोल करके उस दिन की गिनती में जोड़ा जाता है। उसके साथ कोई code, खाता या IP address नहीं होता, इसलिए वह आपसे जोड़ा नहीं जा सकता। आप मना करें तो कुछ नहीं भेजा जाता। आपका जवाब सिर्फ़ आपके browser में रहता है।")}</p>
<p>{bt("The team’s notes come from the Astryl server and are the same for everyone; asking for them sends nothing about you.", "टीम के संदेश Astryl server से आते हैं और सबके लिए एक जैसे होते हैं; उन्हें माँगने पर आपके बारे में कुछ नहीं भेजा जाता।")}</p>

<h2 id="s8">{bt("8. Your choices and rights", "8. आपके विकल्प और अधिकार")}</h2>
<ul>
{li("Delete your account at any time: app → You tab → Account → Delete my account, or on the Account page of this website. Your account and everything stored for it online are removed straight away. The data on your phone stays.", "खाता कभी भी मिटाएँ: app → You tab → Account → मेरा खाता मिटाएँ, या इस website के Account page पर। आपका खाता और उससे जुड़ा सारा online data तुरंत मिट जाता है। आपके फ़ोन का data रहता है।")}
{li("Turn any optional switch off at any time. This withdraws your consent for that part; the data it created is removed or stops growing.", "कोई भी वैकल्पिक switch कभी भी बंद करें। इससे उस हिस्से की सहमति वापस हो जाती है; उससे बना data मिट जाता है या बढ़ना रुक जाता है।")}
{li("Log out to stop syncing on a device. Uninstalling the app removes its data from the phone.", "किसी device पर sync रोकने के लिए log out करें। App uninstall करने पर उसका data फ़ोन से हट जाता है।")}
{li("To ask what is stored about you, to get a copy, or to have something corrected or removed, write to contact@astryl.space and tell us your username. Depending on where you live you may also have the right to complain to your data protection authority.", "आपके बारे में क्या रखा है यह पूछने, उसकी copy लेने, या कुछ सुधारने/हटाने के लिए contact@astryl.space पर लिखें और अपना username बताएँ। आप जहाँ रहते हैं उसके हिसाब से आपको अपनी data protection authority से शिकायत करने का अधिकार भी हो सकता है।")}
</ul>

<h2 id="s9">{bt("9. Children", "9. बच्चे")}</h2>
<p>{bt("Astryl is for everyone who likes space. If you are under 16, please ask a parent or guardian before making an account. The app is fully usable without one.", "Astryl उन सब के लिए है जिन्हें अंतरिक्ष पसंद है। अगर आप 16 साल से कम के हैं, तो खाता बनाने से पहले माता-पिता या अभिभावक से पूछ लें। App खाते के बिना भी पूरा इस्तेमाल हो सकता है।")}</p>

<h2 id="s10">{bt("10. Changes", "10. बदलाव")}</h2>
<p>{bt("If this policy changes in a way that matters, the new version is published on this page and in the app's release notes, and the app asks again before you make a new account. The full source code, including the server code in the folder", "अगर यह policy किसी ज़रूरी तरह से बदली, तो नया version इसी page और app के release notes में छपेगा, और नया खाता बनाने से पहले app फिर पूछेगा। पूरा source code, server का code भी (folder")} <a href="{REPO}/tree/main/supabase">supabase/</a>{bt(", is open for anyone to read.", ") सबके पढ़ने के लिए खुला है।")}</p>
</div></section>"""
    write('privacy.html', shell('Privacy Policy', 'Privacy Policy', 'get', body, 'Astryl Privacy Policy: no ads. An account (username and password only) is needed for the app and optional on the website, crash reports can be switched off; what is stored, why, and how to delete it.', canonical='privacy.html'))


def account_page():
    body = f"""<section class="blk" style="max-width:640px"><h1>{bt("Astryl account", "Astryl खाता")}</h1>
<div id="acct"><noscript><p>{bt("The account page needs JavaScript.", "Account page को JavaScript चाहिए।")}</noscript></p></div>
<p class="note"><a href="privacy.html">{bt("Privacy Policy", "Privacy Policy")}</a></p></section>"""
    write('account.html', shell('Account', 'खाता', 'account', body, 'Create your Astryl account with a username and password, and keep your favourites, quiz scores and settings in step between the app and this website.', canonical='account.html'))


def not_found():
    body = f'''<section class="blk" style="text-align:center;padding:80px 0"><h1>404</h1><p class="sub" style="margin:auto">{bt("This page drifted off into space.", "यह page अंतरिक्ष में खो गया।")}</p><p><a class="btn primary" href="/index.html">{bt("Back home", "होम पर लौटें")}</a></p></section>'''
    write('404.html', shell('Page not found', 'Page नहीं मिला', 'home', body, 'Page not found.', scripts=False, extra_head='<meta name="robots" content="noindex">').replace('href="index.html"', 'href="/index.html"').replace('href="assets/', 'href="/assets/'))


def pwa_files():
    """The installable website: offline page, web app manifest, icons and the service worker."""
    body = f'''<section class="blk" style="text-align:center;padding:60px 0"><h1>📡 {bt("You are offline", "आप offline हैं")}</h1><p class="sub" style="margin:auto">{bt("This page has not been opened on this device yet, so it is not saved. Pages you have opened before still work, and everything else comes back when you are online again.", "यह page इस device पर पहले नहीं खुला, इसलिए save नहीं है। पहले खोले हुए pages अब भी चलते हैं, और बाक़ी सब internet आते ही वापस आ जाएगा।")}</p><p><a class="btn primary" href="/index.html">{bt("Home", "होम")}</a> <a class="btn" href="/planets.html">{bt("Planets", "ग्रह")}</a></p></section>'''
    write('offline.html', shell('Offline', 'Offline', 'home', body, 'You are offline.', extra_head='<meta name="robots" content="noindex">').replace('href="index.html"', 'href="/index.html"').replace('href="assets/', 'href="/assets/').replace('src="assets/', 'src="/assets/'))
    (OUT / 'img' / 'icons').mkdir(parents=True, exist_ok=True)
    for f in ('icon-192.png', 'icon-512.png', 'maskable-512.png', 'apple-touch-icon.png'):
        shutil.copy(site_data.DATA / 'icons' / f, OUT / 'img' / 'icons' / f)
    manifest = {
        'name': 'Astryl: Know your space', 'short_name': 'Astryl', 'id': '/', 'start_url': '/', 'scope': '/', 'display': 'standalone',
        'background_color': '#05070f', 'theme_color': '#06080e', 'lang': 'en', 'dir': 'ltr', 'categories': ['education', 'science'],
        'description': 'Planets, moons, stars and space missions: real positions and real numbers for any date, in English and Hindi.',
        'icons': [{'src': '/img/icons/icon-192.png', 'sizes': '192x192', 'type': 'image/png'},
                  {'src': '/img/icons/icon-512.png', 'sizes': '512x512', 'type': 'image/png'},
                  {'src': '/img/icons/maskable-512.png', 'sizes': '512x512', 'type': 'image/png', 'purpose': 'maskable'}],
        'shortcuts': [{'name': 'Tonight in your city', 'url': '/my-space.html'}, {'name': 'Space station passes', 'url': '/iss.html'}, {'name': 'Quiz', 'url': '/quiz.html'}],
    }
    (OUT / 'manifest.webmanifest').write_text(json.dumps(manifest, ensure_ascii=False, indent=1), encoding='utf-8')
    v = asset_v()
    core = ['/', '/index.html', '/offline.html', '/planets.html', '/assets/icon.svg', '/img/icons/icon-192.png']
    core += [f'/assets/{n}?v={v}' for n in ('style.css', 'data.js', 'app.js', 'account.js', 'me.js', 'fx.js', 'pwa.js', 'cosmos.js', 'tonight.js', 'apod.js')]
    core += [f'/fonts/{f}' for f in ('DMSans-Regular.ttf', 'DMSans-Medium.ttf', 'DMSans-Bold.ttf', 'SpaceGrotesk-Medium.ttf', 'SpaceGrotesk-Bold.ttf')]
    sw = (SRC / 'sw.js').read_text(encoding='utf-8').replace("'__VERSION__'", json.dumps(v)).replace('__CORE__', json.dumps(core))
    (OUT / 'sw.js').write_text(sw, encoding='utf-8')


def parse_cities():
    text = site_data.table('cities.dart')
    return [[a, b, c, float(d), float(e)] for a, b, c, d, e in re.findall(r"City\('([\w-]+)', '([^']+)', '([^']+)', ([-\d.]+), ([-\d.]+)\)", text)]


def data_js():
    data = dict(cities=parse_cities(), eclipses=skyevents.eclipse_json(),
        bodies=[{k: v for k, v in b.items()} for b in BODIES], orbits=ORBITS, factIds=FACT_IDS, milestones=MILESTONES, meteors=METEORS,
        spacecraft=CRAFT, L=dict(L))
    for lg in EXTRA_LANGS:
        f = ROOT / 'tools' / 'i18n' / f'arb_{lg}.json'
        if f.exists():
            data['L'][lg] = json.load(open(f, encoding='utf-8'))
    for b in data['bodies']:
        b['color'] = b['color']
    return 'window.ASTRYL=' + json.dumps(data, ensure_ascii=False, separators=(',', ':')) + ';'


def main():
    # Only the generated parts are rebuilt; other files in site/ (images, the
    # favicon) are left alone.
    for sub in ('assets', 'body', 'fonts', 'black-holes', 'galaxies', 'sky-events', 'learn'):
        if (OUT / sub).exists():
            shutil.rmtree(OUT / sub)
    for old in OUT.glob('*.html'):
        old.unlink()
    (OUT / 'assets').mkdir(parents=True, exist_ok=True)
    shutil.copy(SRC / 'style.css', OUT / 'assets/style.css')
    shutil.copy(SRC / 'app.js', OUT / 'assets/app.js')
    shutil.copy(SRC / 'account.js', OUT / 'assets/account.js')
    shutil.copy(SRC / 'cosmos.js', OUT / 'assets/cosmos.js')
    shutil.copy(SRC / 'moons.js', OUT / 'assets/moons.js')
    shutil.copy(SRC / 'fx.js', OUT / 'assets/fx.js')
    shutil.copy(SRC / 'lab.js', OUT / 'assets/lab.js')
    shutil.copy(SRC / 'scale.js', OUT / 'assets/scale.js')
    shutil.copy(SRC / 'learn.js', OUT / 'assets/learn.js')
    shutil.copy(SRC / 'universe.js', OUT / 'assets/universe.js')
    shutil.copytree(site_data.CITIES, OUT / 'assets' / 'cities')
    for name in ('me.js', 'myspace.js', 'birthday.js', 'tonight.js', 'telescope.js', 'sgp4.js', 'iss.js', 'apod.js', 'worlds.js', 'pwa.js', 'rounds.js', 'bhsim.js', 'sheet.js'):
        shutil.copy(SRC / name, OUT / 'assets' / name)
    (OUT / 'assets/data.js').write_text(data_js(), encoding='utf-8')
    (OUT / 'assets/icon.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg" viewBox="-60 -60 120 120"><rect x="-60" y="-60" width="120" height="120" rx="26" fill="#fbf7ee"/><circle r="30" fill="#1b3a8a"/><ellipse rx="50" ry="15" fill="none" stroke="#6a45d6" stroke-width="6" transform="rotate(-24)"/><circle cx="40" cy="-20" r="6" fill="#1b3a8a"/></svg>', encoding='utf-8')
    (OUT / 'fonts').mkdir()
    for f in ('DMSans-Regular.ttf', 'DMSans-Medium.ttf', 'DMSans-Bold.ttf', 'SpaceGrotesk-Medium.ttf', 'SpaceGrotesk-Bold.ttf', 'OFL-DMSans.txt', 'OFL-SpaceGrotesk.txt'):
        shutil.copy(site_data.FONTS / f, OUT / 'fonts' / f)
    (OUT / 'CNAME').write_text('astryl.space\n', encoding='utf-8')
    (OUT / '.nojekyll').write_text('', encoding='utf-8')
    (OUT / 'robots.txt').write_text(f'User-agent: *\nAllow: /\nSitemap: {SITE}/sitemap.xml\n', encoding='utf-8')
    PHOTO.update(photos.build(OUT)); PHOTO_CREDIT.update(photos.credits())
    spacephotos.build(OUT)
    (OUT / 'assets/sheet-data.js').write_text(sheet_js(), encoding='utf-8')
    QB_SIZES = quizbank.build(OUT, ROOT, BODIES, lambda lg, i: tr(lg, NAME_KEY[i]), CONS, PHOTO)
    for i, b in enumerate(BODIES):
        body_page(b, i)
    index_page(); planets_page(); simple_pages(); maps_page(); get_page(); privacy_page(); account_page(); not_found(); pwa_files()
    helpers = dict(bt=bt, bi=bi, raw2=raw2, shell=shell, write=write, esc=esc, fmt=fmt, asset_v=asset_v, SITE=SITE, ROOT=ROOT)
    deep = deepspace.build(helpers) + galaxies.build(helpers) + lab.build(helpers) + universe.build(helpers) + learn.build(helpers) + umap.build(helpers) + myspace.build(helpers) + skyevents.build(helpers) + students.build(helpers) + telescope.build(helpers) + iss.build(helpers)
    urls = ['', 'planets.html', 'solar-system.html', 'compare.html', 'you.html', 'quiz.html', 'sky.html', 'constellations.html', 'maps.html', 'missions.html', 'spacecraft.html', 'privacy.html', 'account.html', 'black-holes.html', 'galaxies.html'] + deep + [f'body/{b["id"]}.html' for b in BODIES]
    (OUT / 'sitemap.xml').write_text('<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' + ''.join(f'<url><loc>{SITE}/{u}</loc></url>\n' for u in urls) + '</urlset>\n', encoding='utf-8')
    og_images()
    (ROOT / 'tools' / 'i18n' / 'source.tsv').write_text('# id<TAB>English text of every translatable text on the site (generated by build_site.py)\n' + ''.join(f'{k}\t{v}\n' for k, v in sorted(SOURCE.items(), key=lambda kv: kv[1])), encoding='utf-8')
    print('pages:', len(list(OUT.rglob('*.html'))), 'share images:', len(_OG), 'texts:', len(SOURCE), {lg: len(TRX[lg]) for lg in EXTRA_LANGS})


if __name__ == '__main__':
    main()
