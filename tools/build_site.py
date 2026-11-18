#!/usr/bin/env python3
"""Builds the Astryl website (site/) from its own data.

Reads the website's data in data/ (see tools/site_data.py); Run it from the
project root:  python3 tools/build_site.py
"""
import datetime, hashlib, html, json, math, re, shutil
from pathlib import Path

import deepspace
import galaxies
import stars
import blog
import icons
import tonight
import discover
import legal
import journey
import lab
import umap
import myspace
import skyevents
import students
import cons
import spacephotos
import missionphotos
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
EXTRA_LANGS = []  # the website is English only
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
    # the website is English only; the Hindi text in the sources is no longer shown
    return f'<span class="t" lang="en">{esc(en)}</span>'


def bi(key, **p):
    """Both languages as two spans; CSS shows the one that matches <html lang>."""
    q = lambda lg: {k: (v[lg] if isinstance(v, dict) else v) for k, v in p.items()}
    return spans(tr('en', key, **q('en')), tr('hi', key, **q('hi')))


def bt(en, hi):
    return spans(en, hi)


def raw2(en, hi):
    return f'<span class="t" lang="en">{en}</span>'


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


# life score
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
NAV_MAIN = [('planets.html', 'planets', bi('planetsTitle')), ('solar-system.html', 'solar', bi('solarSystemTitle')), ('sky.html', 'sky', bi('skyTitle')), ('quiz.html', 'quiz', bi('navQuiz')), ('community.html', 'community', bt('Community', 'Community'))]
NAV_MORE = [('blog.html', 'blog', bt('Blog', 'Blog')), ('my-space.html', 'myspace', bt('My space', 'My space')), ('sky-events.html', 'events', bt('Eclipses and meteor showers', 'ग्रहण और उल्कापात')), ('learn.html', 'school', bt('For students', 'छात्रों के लिए')), ('telescope.html', 'scope', bt('Telescope simulator', 'Telescope simulator')), ('iss.html', 'iss', bt('Space station passes', 'अंतरिक्ष स्टेशन कब दिखेगा')), ('compare.html', 'compare', bi('navCompare')), ('you.html', 'you', bt('You', 'आप')), ('constellations.html', 'cons', bi('constellationsLabel')), ('maps.html', 'maps', bi('surfaceMapTitle')),
            ('missions.html', 'missions', bi('missionsTitle')), ('spacecraft.html', 'spacecraft', bi('spacecraftTitle')),
            ('universe-map.html', 'umap', bt('Universe map', 'ब्रह्मांड का नक्शा')), ('stars.html', 'stars', bt('Stars', 'तारे')), ('galaxies.html', 'gx', bt('Galaxies', 'Galaxies')), ('cosmic-scale.html', 'scale', bt('Scale of the universe', 'ब्रह्मांड का पैमाना')), ('universe-timeline.html', 'tline', bt('Timeline', 'समयरेखा')), ('glossary.html', 'gloss', bt('Glossary', 'शब्दकोश')), ('black-holes.html', 'bh', bt('Black holes', 'ब्लैक होल'))]


_ASSET_V = []


def asset_v():
    '''A short hash of the scripts and styles, so a changed file is never served from an old cache.'''
    if not _ASSET_V:
        h = hashlib.md5()
        for name in ('style.css', 'app.js', 'account.js', 'cosmos.js', 'moons.js', 'fx.js', 'lab.js', 'scale.js', 'learn.js', 'universe.js', 'me.js', 'myspace.js', 'birthday.js', 'tonight.js', 'telescope.js', 'sgp4.js', 'iss.js', 'apod.js', 'worlds.js', 'pwa.js', 'rounds.js', 'bhsim.js', 'sheet.js', 'mapzoom.js', 'home.js', 'community.js', 'moderate.js', 'stars.js', 'profile.js', 'blog.js', 'discover.js', 'citypick.js', 'icons.js', 'journey.js', 'sw.js'):
            h.update((SRC / name).read_bytes())
        h.update((ROOT / 'tools' / 'formation.py').read_bytes())
        h.update((ROOT / 'tools' / 'icons.py').read_bytes())
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


ST_PAGES = {'stars', 'how-stars-are-born', 'life-of-a-star', 'supernova', 'neutron-stars-and-pulsars', 'white-dwarfs-and-planetary-nebulae', 'star-colours-and-sizes', 'famous-stars'}


def og_theme(name):
    return 'bh' if name in BH_PAGES else 'gx' if name in GX_PAGES or name in ST_PAGES else 'cosmos' if name in COSMOS_PAGES else ''


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
    more_on = page in ('compare', 'you', 'cons', 'maps', 'missions', 'bh', 'gx', 'scale', 'tline', 'gloss', 'umap', 'myspace', 'events', 'school', 'scope', 'iss', 'stars', 'blog')
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
<meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob: https://apod.nasa.gov https://science.nasa.gov https://assets.science.nasa.gov https://pmfjjlfggzihbnbmqkao.supabase.co; connect-src 'self' https://pmfjjlfggzihbnbmqkao.supabase.co https://api.github.com https://api.wheretheiss.at; font-src 'self'; media-src 'self'; worker-src 'self'; manifest-src 'self'; frame-src 'none'; object-src 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests"><meta name="referrer" content="strict-origin-when-cross-origin">
<title>{esc(title_en)} · Astryl</title>
<meta name="description" content="{esc(desc_en)}">
<link rel="canonical" href="{url}">
<meta property="og:title" content="{esc(title_en)} · Astryl"><meta property="og:description" content="{esc(desc_en)}"><meta property="og:type" content="website"><meta property="og:url" content="{url}"><meta name="theme-color" content="#06080e">
<meta property="og:site_name" content="Astryl"><meta name="robots" content="max-image-preview:large"><meta property="og:image:alt" content="{esc(title_en)} · Astryl">
<meta property="og:image" content="{ogimg}"><meta property="og:image:width" content="1200"><meta property="og:image:height" content="630"><meta name="twitter:card" content="summary_large_image"><meta name="twitter:title" content="{esc(title_en)} · Astryl"><meta name="twitter:description" content="{esc(desc_en)}"><meta name="twitter:image" content="{ogimg}">
<link rel="icon" href="{p}assets/icon.svg" type="image/svg+xml"><link rel="manifest" href="/manifest.webmanifest"><link rel="apple-touch-icon" href="/img/icons/apple-touch-icon.png"><meta name="apple-mobile-web-app-capable" content="yes"><meta name="mobile-web-app-capable" content="yes"><meta name="apple-mobile-web-app-title" content="Astryl"><meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<link rel="preload" href="{p}fonts/DMSans-Regular.woff" as="font" type="font/woff" crossorigin><link rel="preload" href="{p}fonts/SpaceGrotesk-Bold.woff" as="font" type="font/woff" crossorigin>
<link rel="stylesheet" href="{p}assets/style.css?v={asset_v()}">
<script>try{{var s=localStorage,A=["en","hi","es","pt","fr","ar"],l=s.getItem("astryl-lang");if(A.indexOf(l)<0){{l=(navigator.language||"en").slice(0,2);if(A.indexOf(l)<0)l="en"}}var d=document.documentElement;d.lang=l;d.dir=l==="ar"?"rtl":"ltr";if(s.getItem("astryl-theme")!=="light")d.setAttribute("data-theme","dark")}}catch(e){{document.documentElement.setAttribute("data-theme","dark")}}if(window.IntersectionObserver&&!(window.matchMedia&&matchMedia("(prefers-reduced-motion: reduce)").matches))document.documentElement.classList.add("js")</script>
{ldtag}{extra_head}</head>
<body data-page="{page}" data-root="{p}">
<a class="skip" href="#main">Skip to content</a>
<div class="stars"></div>
<header class="top"><div class="wrap bar">
<a class="brand" href="{p}index.html">{logo_svg()}Astryl</a>
<nav class="links" id="siteNav" aria-label="Main">{nav}</nav>
<div class="tools"><button id="themeBtn" aria-label="Theme">☾</button><span id="acctNav" class="acctnav"><a class="btn" href="{p}account.html?mode=login">{bt("Log in", "Login")}</a><a class="btn primary" href="{p}account.html">{bt("Sign up", "खाता बनाएँ")}</a></span><button type="button" class="menubtn" id="menuBtn" aria-expanded="false" aria-controls="siteNav" aria-label="Menu"><span></span><span></span><span></span></button></div>
</div></header>
<main class="wrap" id="main" tabindex="-1">
{body}
</main>
<footer><div class="wrap cols">
<div><b>Astryl</b><br>{bt("Know your space.", "अपने अंतरिक्ष को जानिए।")}<br>© 2026 Astryl · <a href="{SITE}">astryl.space</a></div>
<div><a href="{p}privacy.html">{bt("Privacy Policy", "Privacy Policy")}</a><br><a href="{p}terms.html">Terms and Conditions</a><br><a href="{p}your-data.html">Your data</a><br><a href="{p}account.html">{bt("Account", "खाता")}</a><br><a href="{p}my-space.html">{bt("My space", "My space")}</a><br><a href="{p}community.html">👥 {bt("Astryl Community", "Astryl Community")}</a></div>
<div>{bt("Facts: NASA Planetary Fact Sheet", "तथ्य: NASA Planetary Fact Sheet")}<div id="installBox" class="installbox"></div></div>
</div></footer>
{"<script src=\"" + p + "assets/data.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/app.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/account.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/me.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/fx.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/pwa.js?v=" + asset_v() + "\"></script><script src=\"" + p + "assets/icons.js?v=" + asset_v() + "\"></script>" if scripts else ""}
</body></html>
'''


# A short pointer to the Astryl Community at the end of some pages.
CM_PROMO = {
    'quiz.html': ('❓', 'Stuck on a question, or want to know more? Ask in the Astryl Community.', 'किसी सवाल पर अटके, या और जानना है? Astryl Community में पूछिए।'),
    'sky.html': ('📷', 'Saw something in the sky tonight? Take a photo and share it in the Astryl Community.', 'आज रात आसमान में कुछ देखा? फ़ोटो खींचिए और Astryl Community में बाँटिए।'),
    'iss.html': ('📷', 'Saw the space station fly over? Share your photo in the Astryl Community.', 'अंतरिक्ष स्टेशन को गुज़रते देखा? अपनी फ़ोटो Astryl Community में बाँटिए।'),
    'learn.html': ('❓', 'Did not understand something? Ask in the Astryl Community, and others will help.', 'कुछ समझ नहीं आया? Astryl Community में पूछिए, दूसरे मदद करेंगे।'),
    'glossary.html': ('❓', 'Did not understand something? Ask in the Astryl Community, and others will help.', 'कुछ समझ नहीं आया? Astryl Community में पूछिए, दूसरे मदद करेंगे।'),
    'my-space.html': ('👥', 'Your sky photos and your questions live in the Astryl Community.', 'आपकी आसमान की फ़ोटो और आपके सवाल Astryl Community में हैं।'),
}


def cm_promo(path):
    icon, en, hi = CM_PROMO[path]
    p = '../' * path.count('/')
    return f'<section class="blk"><div class="callout cmpromo"><span class="cmic">{icon}</span><p>{bt(en, hi)}</p><a class="btn" href="{p}community.html">👥 {bt("Astryl Community", "Astryl Community")} →</a></div></section>'


# Pages whose first headings after the title are card titles (h3): a heading for screen readers
# goes before them, so the outline does not jump from h1 to h3.
H2_FOR = {
    'black-holes/famous-black-holes.html': 'The black holes', 'galaxies/types-of-galaxies.html': 'The types of galaxies',
    'constellations.html': 'All constellations', 'glossary.html': 'Space words from A to Z', 'missions.html': 'Missions in order',
    'privacy.html': 'Our promises', 'solar-system.html': 'The planets', 'universe-timeline.html': 'The timeline',
    'you.html': 'Your weight on each world', 'stars/famous-stars.html': 'The ten stars', 'stars/life-of-a-star.html': 'Play the life of a star',
}

H2_AT = {'solar-system.html': '<div class="eyes-wrap">', 'you.html': '<div id="wOut">'}


def heading_fix(path, html):
    label = H2_FOR.get(path)
    if not label:
        return html
    at = H2_AT.get(path)
    if at and at in html:  # cards drawn later by the page's script: the heading goes before their box
        return html.replace(at, f'<h2 class="sr-only">{esc(label)}</h2>' + at, 1)
    m = html.find('<main')
    h1 = html.find('<h1', m)
    h3 = html.find('<h3', h1)
    if h1 < 0 or h3 < 0 or '<h2' in html[h1:h3]:
        return html
    # put it at the start of the block (section or div) that holds the first card title
    k = max(html.rfind('<section', h1, h3), html.rfind('<div class="grid', h1, h3), html.rfind('<div class="lifecycle', h1, h3))
    k = k if k > h1 else h3
    return html[:k] + f'<h2 class="sr-only">{esc(label)}</h2>' + html[k:]


# "You may also like": every feature page ends with links to related pages (pages that already
# have "Keep exploring" keep that instead).
REL_CARDS = {
    'planets.html': ('🪐', 'Planets and moons', 'Every planet and big moon, with real numbers'),
    'solar-system.html': ('☀️', 'Solar System 3D Live', 'The planets where they really are today'),
    'compare.html': ('⚖️', 'Compare two worlds', 'Size, gravity and day length side by side'),
    'you.html': ('🧑‍🚀', 'You in space', 'Your weight and age on every world'),
    'quiz.html': ('🧠', 'Space quiz', 'Daily 5 and ranked rounds for Space Points'),
    'deep-space-quiz.html': ('🌌', 'Black hole and galaxy quiz', 'Test what you know about deep space'),
    'sky.html': ('🌙', 'Moon and sky tonight', 'Moon phase and what is up from your city'),
    'tonight.html': ('🔭', 'Night sky tonight', 'Planets and the Moon for 50 cities'),
    'sky-events.html': ('🌑', 'Eclipses and meteor showers', 'Every eclipse until 2029, with times'),
    'constellations.html': ('✨', 'Constellations', 'All 88 patterns of the night sky'),
    'maps.html': ('🗺️', 'Moon and Mars maps', 'Where every mission landed'),
    'missions.html': ('🚀', 'Space missions', 'From Sputnik to Chandrayaan-3'),
    'spacecraft.html': ('🛰️', 'Spacecraft now', 'A map of where Voyager and the others are today'),
    'iss.html': ('🛰️', 'Space station passes', 'Live map and when it flies over you'),
    'telescope.html': ('🔭', 'Telescope simulator', 'What a telescope really shows'),
    'stars.html': ('⭐', 'Stars', 'How stars are born, live and die'),
    'black-holes.html': ('⚫', 'Black holes', 'How they form and what falling in is like'),
    'black-holes-101.html': ('🎓', 'Black holes 101', 'Seven lessons, a quiz and a badge'),
    'black-hole-lab.html': ('🧪', 'Black hole lab', 'Play with gravity, light and time'),
    'galaxies.html': ('🌌', 'Galaxies', 'The Milky Way, Andromeda and beyond'),
    'universe-map.html': ('🧭', 'Universe map', 'Fly through 3,600 real galaxies in 3D'),
    'how-we-move.html': ('🌀', 'How we move through space', 'The Sun, the Milky Way and Andromeda in motion'),
    'cosmic-scale.html': ('📏', 'Scale of the universe', 'From a proton to everything we can see'),
    'universe-timeline.html': ('⏳', 'Timeline of the universe', '13.8 billion years in one year'),
    'glossary.html': ('📖', 'Glossary', 'Space words, explained simply'),
    'learn.html': ('🎓', 'For students', 'Sun, Moon, eclipses and stars for class 6 to 10'),
    'community.html': ('👥', 'Astryl Community', 'Sky photos, questions and answers'),
    'blog.html': ('📝', 'Blog', 'Longer stories about space and time'),
    'blog/time-travel.html': ('⏳', 'Time travel', 'What physics really allows'),
    'stars/life-of-a-star.html': ('🌟', 'The life of a star', 'From a cloud of gas to a supernova'),
    'black-holes/falling-into-a-black-hole.html': ('🕳️', 'Falling into a black hole', 'What you would see and feel'),
}
REL = {
    'planets.html': ['solar-system.html', 'compare.html', 'you.html', 'maps.html'],
    'solar-system.html': ['planets.html', 'spacecraft.html', 'sky.html', 'cosmic-scale.html'],
    'compare.html': ['planets.html', 'you.html', 'cosmic-scale.html', 'quiz.html'],
    'you.html': ['compare.html', 'planets.html', 'blog/time-travel.html', 'quiz.html'],
    'quiz.html': ['deep-space-quiz.html', 'black-holes-101.html', 'learn.html', 'community.html'],
    'deep-space-quiz.html': ['quiz.html', 'black-holes.html', 'galaxies.html', 'black-holes-101.html'],
    'sky.html': ['tonight.html', 'sky-events.html', 'iss.html', 'telescope.html'],
    'sky-events.html': ['tonight.html', 'sky.html', 'constellations.html', 'iss.html'],
    'constellations.html': ['sky.html', 'stars.html', 'telescope.html', 'sky-events.html'],
    'maps.html': ['missions.html', 'spacecraft.html', 'planets.html', 'telescope.html'],
    'missions.html': ['spacecraft.html', 'maps.html', 'iss.html', 'blog.html'],
    'spacecraft.html': ['missions.html', 'solar-system.html', 'blog/time-travel.html', 'iss.html'],
    'stars.html': ['stars/life-of-a-star.html', 'black-holes.html', 'constellations.html', 'galaxies.html'],
    'black-holes.html': ['black-holes-101.html', 'black-hole-lab.html', 'blog/time-travel.html', 'stars.html'],
    'black-holes-101.html': ['black-hole-lab.html', 'black-holes.html', 'deep-space-quiz.html', 'blog/time-travel.html'],
    'black-hole-lab.html': ['black-holes/falling-into-a-black-hole.html', 'black-holes-101.html', 'blog/time-travel.html', 'deep-space-quiz.html'],
    'galaxies.html': ['universe-map.html', 'how-we-move.html', 'cosmic-scale.html', 'black-holes.html'],
    'how-we-move.html': ['universe-map.html', 'galaxies.html', 'cosmic-scale.html', 'solar-system.html'],
    'cosmic-scale.html': ['universe-timeline.html', 'universe-map.html', 'compare.html', 'galaxies.html'],
    'universe-timeline.html': ['cosmic-scale.html', 'blog/time-travel.html', 'stars/life-of-a-star.html', 'galaxies.html'],
    'glossary.html': ['learn.html', 'quiz.html', 'stars.html', 'blog.html'],
    'learn.html': ['quiz.html', 'glossary.html', 'sky.html', 'planets.html'],
    'community.html': ['blog.html', 'sky.html', 'telescope.html', 'quiz.html'],
    'blog.html': ['community.html', 'spacecraft.html', 'black-holes.html', 'universe-timeline.html'],
    'blog/time-travel.html': ['black-holes/falling-into-a-black-hole.html', 'black-hole-lab.html', 'spacecraft.html', 'universe-timeline.html'],
}


def related(path, content):
    if 'Keep exploring' in content or 'class="blk related"' in content:
        return ''
    if path.startswith('body/'):
        bid = path[5:-5]
        picks = ['compare.html', 'solar-system.html', 'maps.html' if bid in ('moon', 'mars') else 'you.html', 'spacecraft.html' if bid in ('jupiter', 'saturn', 'uranus', 'neptune', 'pluto', 'sun') else 'missions.html']
    else:
        picks = REL.get(path)
    if not picks:
        return ''
    pre = '../' * path.count('/')
    cards = ''.join(f'<a class="sc" href="{pre}{h}"><span class="ic">{REL_CARDS[h][0]}</span><span><b>{REL_CARDS[h][1]}</b><small>{REL_CARDS[h][2]}</small></span><span class="go">→</span></a>' for h in picks)
    return f'<section class="blk related"><h2>You may also like</h2><div class="sc-grid" style="padding-top:6px">{cards}</div></section>'


def write(path, content):
    f = OUT / path
    f.parent.mkdir(parents=True, exist_ok=True)
    if path.endswith('.html'):
        content = spacephotos.place(path, content, bt, esc)
        if path in CM_PROMO:
            content = content.replace('\n</main>', '\n' + cm_promo(path) + '\n</main>', 1)
        rel = related(path, content)
        if rel:
            content = content.replace('\n</main>', '\n' + rel + '\n</main>', 1)
        content = heading_fix(path, content)
        content = icons.html(content)
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
    steps = ''.join(f'<div class="m"><div class="y">{bt(te, th)}</div><p>{bt(en, hi)}</p></div>' for te, th, en, hi in f['steps'])
    op = f'<div class="callout">❓ <b>{bt("Still unknown", "अभी भी अनजाना")}:</b> {bt(f["open"][0], f["open"][1])}</div>' if f.get('open') else ''
    return (f'<div class="formhead"><div class="stat"><b>{bt(f["when"][0], f["when"][1])}</b><span>{bt("Formed", "कब बना")}</span></div>'
            f'<div class="stat"><b>{bt(f["took"][0], f["took"][1])}</b><span>{bt("How long it took", "कितना समय लगा")}</span></div></div>'
            f'<p>{bt(f["how"][0], f["how"][1])}</p><div class="tl formtl">{steps}</div>{op}'
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


def pghero(title, grad, lead, buttons, img, alt=''):
    """The top of a section page: big title, one line, buttons and a photo (the Stars page style)."""
    btns = ''.join(f'<a class="btn{" primary" if i == 0 else ""}" href="{h}">{t}</a>' for i, (t, h) in enumerate(buttons))
    return (f'<section class="hero2 starhero pghero"><div><h1 class="rise">{title} <span class="grad">{grad}</span></h1><p class="lead rise">{lead}</p>'
            f'<div class="btns rise">{btns}</div></div><div class="starhero-img"><img src="{img}" alt="{esc(alt)}" loading="eager"></div></section>')


def city_picker(p, compact=False):
    """A city box that opens that city's "Night sky tonight" page (handled by citypick.js)."""
    data = json.dumps([[c[0], c[1], c[2], c[3], c[4]] for c in tonight.CITIES], ensure_ascii=False)
    opts = ''.join(f'<option value="{esc(c[1])}, {esc(c[2])}"></option>' for c in tonight.CITIES)
    return (f'<form class="citypick{" compact" if compact else ""}" action="{p}tonight.html" data-root="{p}" data-cities=\'{esc(data)}\'>'
            f'<label class="sr-only" for="cityIn{"2" if compact else ""}">Your city</label><input id="cityIn{"2" if compact else ""}" name="city" list="cityList{"2" if compact else ""}" placeholder="Type your city: Delhi, London, New York…" autocomplete="off" required>'
            f'<datalist id="cityList{"2" if compact else ""}">{opts}</datalist><button class="btn primary" type="submit">{"Go" if compact else "See tonight’s sky"} →</button>'
            f'<button class="btn" type="button" data-near>📍 {"Near me" if compact else "Use my location"}</button><p class="note cpmsg" aria-live="polite"></p></form>')


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
             ('📖', bt('Glossary', 'शब्दकोश'), 'Space words, explained simply', 'अंतरिक्ष के शब्द, आसान भाषा में', 'glossary.html'),
             ('📝', bt('Blog', 'Blog'), 'New post: time travel, what physics really allows', 'New post: time travel, what physics really allows', 'blog.html'),
             ('🛰️', 'spacecraftTitle', 'How far Voyager and JWST are now', 'Voyager और JWST अभी कितनी दूर हैं', 'spacecraft.html'),
             ('⚖️', 'weightTitle', 'Weight, jump and age on every world', 'हर दुनिया पर वज़न, कूद और उम्र', 'you.html'),
             (pic('earth'), 'navCompare', 'Any two worlds side by side', 'कोई भी दो दुनियाएँ आमने-सामने', 'compare.html')]
    by = {t[4]: t for t in tiles}
    by['telescope.html'] = ('🔭', bt('Telescope simulator', 'Telescope simulator'), 'What a telescope really shows, in real photos', 'Telescope में असल में क्या दिखता है, असली तस्वीरों में', 'telescope.html')
    by['stars.html'] = ('⭐', bt('Stars', 'तारे'), 'How stars are born, live and die', 'तारे कैसे जन्म लेते, जीते और मरते हैं', 'stars.html')
    by['community.html'] = ('👥', bt('Astryl Community', 'Astryl Community'), 'Sky photos, and questions and answers', 'आसमान की फ़ोटो, और सवाल-जवाब', 'community.html')
    by['quiz.html'] = ('🏆', bt('Quiz and Space Points', 'Quiz और Space Points'), 'Photo, constellation and mission rounds', 'फ़ोटो, नक्षत्र और mission वाले rounds', 'quiz.html')

    def card(h):
        ic, k, en, hi_, _ = by[h]
        return f'<a class="sc" href="{h}"><span class="ic">{ic}</span><span><b>{k if k.startswith("<") else bi(k)}</b><small>{bt(en, hi_)}</small></span><span class="go">→</span></a>'
    groups = [('img/planets/saturn.webp', bt('The Solar System', 'सौरमंडल'), bt('Planets, moons and where they are today', 'ग्रह, चाँद और वे आज कहाँ हैं'), ['planets.html', 'solar-system.html', 'compare.html', 'you.html', 'maps.html']),
              ('img/space/gx-whirlpool.webp', bt('Deep space', 'गहरा अंतरिक्ष'), bt('Stars, black holes, galaxies and the whole universe', 'तारे, ब्लैक होल, आकाशगंगाएँ और पूरा ब्रह्मांड'), ['stars.html', 'black-holes.html', 'black-holes-101.html', 'galaxies.html', 'universe-map.html', 'cosmic-scale.html', 'universe-timeline.html']),
              ('img/space/sun-eclipse.webp', bt('Watch the sky', 'आसमान देखिए'), bt('What to look for tonight, from your city', 'आज रात क्या देखें, आपके शहर से'), ['sky.html', 'constellations.html', 'sky-events.html', 'iss.html', 'telescope.html']),
              ('img/space/pic-earthrise.webp', bt('Explore and learn', 'खोजिए और सीखिए'), bt('Missions, spacecraft, lessons and quizzes', 'Missions, अंतरिक्ष यान, पाठ और quiz'), ['community.html', 'blog.html', 'missions.html', 'spacecraft.html', 'learn.html', 'quiz.html', 'glossary.html'])]
    cards = ''.join(f'<section class="grp"><div class="grph" style="background-image:url({img})"><h2>{t}</h2><p>{sub}</p></div><div class="sc-grid">{"".join(card(h) for h in hs)}</div></section>' for img, t, sub, hs in groups)
    quiz = ''.join(f'<button type="button" class="opt"{" data-ok=1" if k == "planetJupiter" else ""}>{bi(k)}</button>' for k in ('planetSaturn', 'planetJupiter', 'planetMars', 'planetNeptune'))
    surprise = []
    for b in BODIES:
        cap = b['id'].capitalize()
        for n in (1, 2):
            if f'fact{cap}{n}' in L['en']:
                surprise.append({'u': f'body/{b["id"]}.html', 'img': f'img/planets/{b["id"]}-s.webp' if b['id'] in PHOTO else 'assets/icon.svg', 't': [tr('en', NAME_KEY[b['id']]), tr('hi', NAME_KEY[b['id']])], 'd': [L['en'][f'fact{cap}{n}'], L['hi'][f'fact{cap}{n}']]})
    for pid, u in (('bh-m87', 'black-holes/famous-black-holes.html'), ('pic-paleblue', 'missions.html'), ('gx-webb', 'galaxies/what-is-a-galaxy.html'), ('pic-pluto', 'body/pluto.html'), ('nb-pillars', 'learn/stars-and-constellations.html'),
                   ('pic-huygens', 'body/titan.html'), ('gx-andromeda', 'galaxies/andromeda-galaxy.html'), ('pic-apollo11', 'missions.html'), ('sc-chandrayaan3', 'maps.html'), ('iss-india-night', 'iss.html'), ('pic-rosetta', 'missions.html'), ('gx-antennae', 'galaxies/galaxy-formation-and-collisions.html')):
        if pid in spacephotos.SIZES:
            _, en, hi_ = spacephotos.INFO[pid]
            surprise.append({'u': u, 'img': f'img/space/{pid}.webp', 't': [en.split(':')[0].split('(')[0].split(',')[0].strip()[:60], hi_.split(':')[0].split('(')[0].split(',')[0].strip()[:60]], 'd': [en, hi_]})
    by['tonight.html'] = ('🔭', bt('Night sky tonight', 'Night sky tonight'), 'Planets, Moon and sunset for your city', 'Planets, Moon and sunset for your city', 'tonight.html')
    explore = ['tonight.html', 'planets.html', 'solar-system.html', 'sky-events.html', 'iss.html', 'spacecraft.html', 'stars.html', 'black-holes.html', 'galaxies.html', 'learn.html', 'quiz.html', 'blog.html']
    body = f"""<section class="hero2 homehero">
<div>
<h1 class="rise">{bt("What’s in your", "What’s in your")} <span class="grad">{bt("sky tonight?", "sky tonight?")}</span></h1>
<p class="lead rise">{bt("The planets you can see, where to look, the Moon and sunset, worked out for your city tonight. Plus real photos and real numbers for everything in space.", "")}</p>
<div class="rise">{city_picker('')}</div>
<div class="chips rise popcities">{''.join(f'<a class="chip" href="tonight/{c[0]}.html">{esc(c[1])}</a>' for c in tonight.CITIES if c[0] in ('delhi', 'mumbai', 'london', 'new-york', 'dubai', 'sydney', 'yerevan'))}<a class="chip" href="tonight.html">{bt("All 50 cities", "All 50 cities")} →</a></div>
</div>
<div class="herog"><canvas id="heroGlobe" aria-label="{esc("The Earth right now, with day and night and the space station")}"></canvas><p class="note herocap">{bt("The Earth right now: real day and night, and the space station where it really is.", "")}</p></div>
</section>
<section class="blk discover" id="discover"></section>
<script>window.ASTRYL_DISCOVER={json.dumps(discover.data(universe.GLOSSARY, {b["id"]: tr("en", NAME_KEY[b["id"]]) for b in BODIES if b["id"] in PHOTO}, [f"blog/{blog.POSTS[0]['slug']}.html", blog.POSTS[0]["title"], blog.POSTS[0]["desc"]]), ensure_ascii=False).replace('</', '<\\/')};</script>
<section class="blk"><h2>{bt("Explore", "Explore")}</h2><p class="sub">{bt("Everything on Astryl starts from one of these.", "")}</p><div class="sc-grid homegrid">{"".join(card(h) for h in explore)}</div></section>
<section class="blk"><div class="grid daily2"><div class="card cmhome" id="homeCommunity"><div class="cmtext"><h2>👥 {bt("Astryl Community", "Astryl Community")}</h2><p>{bt("Share your own photos of the Moon, planets and stars, ask anything about space and answer other people's questions.", "")}</p><div class="btns"><a class="btn primary" href="community.html">{bt("Open the community", "Open the community")} →</a><a class="btn" href="community.html#talk">❓ {bt("Ask a question", "Ask a question")}</a></div></div></div><div class="card apod" id="dailyPhoto"></div></div></section>"""
    write('index.html', shell('What’s in your sky tonight? Planets, Moon and space for your city', 'ब्रह्मांड खोजिए', 'home', body, 'What planets can you see tonight? Astryl shows the planets, the Moon and sunset for your city, plus real photos and real numbers for everything in space. Free, no ads.', canonical='', extra_head=f'<script defer src="assets/sgp4.js?v={asset_v()}"></script><script defer src="assets/home.js?v={asset_v()}"></script><script defer src="assets/citypick.js?v={asset_v()}"></script><script defer src="assets/apod.js?v={asset_v()}"></script><script defer src="assets/discover.js?v={asset_v()}"></script>', ld=[{'@context': 'https://schema.org', '@type': 'WebApplication', 'name': 'Astryl', 'applicationCategory': 'EducationalApplication', 'operatingSystem': 'Any', 'description': 'Planets, moons, stars and space missions with real positions and real numbers for any date. Free.', 'url': SITE + '/', 'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'USD'}, 'inLanguage': ['en', 'hi']}, {'@context': 'https://schema.org', '@type': 'WebSite', 'name': 'Astryl', 'url': SITE + '/', 'inLanguage': ['en', 'hi']}]))


def planets_page():
    def card(b):
        return f'<a class="card pcard" data-id="{b["id"]}" data-search="{b["id"]}" href="body/{b["id"]}.html">{planet_pic(b, uid="p")}<div><b>{bname(b["id"])}</b><br><small>{val(v_diam(b))}</small></div></a>'
    groups = [('planet', bt('The Sun and the planets', 'The Sun and the planets'), [b for b in BODIES if b['kind'] in ('star', 'planet')]),
              ('dwarf', bt('Dwarf planet', 'बौना ग्रह'), [b for b in BODIES if b['id'] == 'pluto']), ('moon', bi('majorMoons'), [b for b in BODIES if b['kind'] == 'moon'])]
    secs = ''.join(f'<section class="blk"><h2>{t}</h2><div class="grid">{"".join(card(b) for b in bs)}</div></section>' for _, t, bs in groups)
    body = pghero('Planets and', 'moons.', 'Every planet, Pluto and the big moons: how big they are, their gravity, weather, air and how they formed, with real photos.', [('Compare two worlds →', 'compare.html'), ('See them in 3D', 'solar-system.html')], 'img/space/pic-voyager-jupiter.webp', 'Jupiter photographed by Voyager') + f'''<section class="blk"><p class="sub">{bt("Tap a world for its size, gravity, temperature, atmosphere and facts.", "")}</p>
<div class="row"><input type="search" id="q" placeholder="{esc(tr("en", "searchHint"))}" aria-label="Search"></div></section>{secs}'''
    write('planets.html', shell('Planets and moons', 'ग्रह और चाँद', 'planets', body, 'Every planet, Pluto and nine major moons: diameter, gravity, temperature, day and year length, atmosphere and a life score.', canonical='planets.html', extra_head=f'<script defer src="assets/sheet.js?v={asset_v()}"></script>'))


def simple_pages():
    # solar system
    body = f'''<section class="blk"><h1>{bi("solarSystemTitle")}</h1><p class="sub">{bt("The planets where they really are today, in 3D. Drag to turn it, pinch or scroll to zoom, and tap a planet or moon to fly to it.", "NASA Eyes जैसा 3D लाइव सौरमंडल: घुमाने के लिए खींचें, ज़ूम करें, और किसी भी ग्रह या चंद्रमा पर क्लिक करके वहाँ उड़कर जाएँ व नीचे लाइव आँकड़े देखें।")}</p>
<div class="eyes-wrap"><div class="eyes-chips" id="solChips"></div><div class="eyes-stage"><canvas id="solar"></canvas><div class="eyes-badge">● <span class="t" lang="en">SOLAR SYSTEM · 3D LIVE</span><span class="t" lang="hi">3D लाइव सौरमंडल</span></div><button class="btn eyes-back" id="solBack" style="display:none">← {bi("spaceBack")}</button></div>
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
    body = pghero('How well do you know', 'space?', 'Daily 5: the same five questions for everyone, every day. Then rounds of real NASA photos, constellations and missions for Space Points and badges.', [('Play Daily 5 ↓', '#daily'), ('Rounds for Space Points ↓', '#rounds')], 'img/space/gx-webb.webp', 'Galaxies seen by the James Webb Space Telescope') + f'''<section class="blk"><h2 class="sr-only">Daily 5</h2><div id="daily" class="daily"></div></section>
<section class="blk" id="rounds"><h2>{bt("Rounds for Space Points", "Space Points वाले rounds")}</h2><p class="sub">{bt("Real NASA photos, constellations, missions, bigger or smaller and best guess. Log in and every right answer earns Space Points.", "NASA की असली तस्वीरें, नक्षत्र, missions, बड़ा या छोटा और अंदाज़ा। Log in करें तो हर सही जवाब पर Space Points मिलते हैं।")}</p><div id="rounds"></div></section>
<section class="blk"><h2>{bt("Practice", "अभ्यास")}</h2><div id="quiz"></div></section>'''
    write('quiz.html', shell('Space quiz', 'अंतरिक्ष quiz', 'quiz', body, 'A space quiz: real NASA photos, constellations, missions, bigger or smaller, best guess and planet levels, with Space Points and a leaderboard.', canonical='quiz.html', extra_head=f'<script defer src="assets/quiz-bank.js?v={asset_v()}"></script><script defer src="assets/rounds.js?v={asset_v()}"></script>'))
    # sky
    body = f'''<section class="blk"><h1>{bt("What planets are visible tonight?", "What planets are visible tonight?")}</h1><p class="sub">{bt("Pick your city to see which planets are up tonight, where to look and when, with sunset and the Moon.", "")}</p>{city_picker('')}</section>
<section class="blk"><h2>{bt("The Moon tonight", "The Moon tonight")}</h2><div class="card" id="moonNow"></div></section>
<section class="blk"><h2>{bi("moonCalendar")}</h2><div class="row"><button class="btn" id="calPrev">‹ {bi("previousMonth")}</button><b id="calTitle"></b><button class="btn" id="calNext">{bi("nextMonth")} ›</button></div><div class="moons" id="calGrid"></div><div id="calPhases" style="margin-top:14px"></div><p class="note">{bi("moonCalendarNote")}</p></section>
<section class="blk"><h2>{bi("eventsTitle")}</h2><p class="sub">{bt("Meteor shower peaks for the next 12 months, with how bright the Moon will be on the peak night.", "अगले 12 महीनों में उल्कापात के चरम दिन, और उस रात चाँद कितना चमकीला होगा।")}</p><div class="grid" id="showers"></div></section>
<section class="blk callout"><b>{bt("Want it for your city?", "अपने शहर के लिए चाहिए?")}</b> {bt("My space shows sunset, moonrise and the planets you can see tonight from your city, and the space station page shows when the ISS flies over you.", "My space में आपके शहर का सूर्यास्त, चाँद का उगना और आज रात दिखने वाले ग्रह हैं, और अंतरिक्ष स्टेशन वाला page बताता है कि ISS आपके ऊपर से कब गुज़रेगा।")} <a href="my-space.html">{bt("Open My space", "My space खोलें")}</a> · <a href="iss.html">{bt("Space station passes", "अंतरिक्ष स्टेशन कब दिखेगा")}</a></section>'''
    write('sky.html', shell('What planets are visible tonight? Moon phase and night sky', 'चाँद और आसमान', 'sky', body, "What planets can I see tonight? The planets up tonight from your city, the Moon phase and calendar, and the next meteor showers.", canonical='sky.html', extra_head=f'<script defer src="assets/citypick.js?v={asset_v()}"></script>'))
    # spacecraft
    body = pghero('Where are the', 'spacecraft now?', 'Voyager 1 is a full light-day from home. See where it and seven other spacecraft are right now, how fast they move and how long their signals take.', [('Open the map ↓', '#craftMap'), ('All space missions', 'missions.html')], 'img/space/pic-paleblue.webp', 'The Pale Blue Dot photo taken by Voyager 1') + f'''<section class="blk"><div class="card cmap" id="craftMap"></div><div class="card ladder" id="craftLadder"></div><div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(300px,1fr))" id="craft"></div><p class="note">{bi("spacecraftNote")}</p></section>
<script>window.ASTRYL_CRAFTPICS={json.dumps({k: '<div class="mphotos">' + ''.join(spacephotos.figure(p, '', bt, esc, cls='mphoto') for p in v) + '</div>' for k, v in missionphotos.CRAFT.items()}, ensure_ascii=False).replace('</', '<\\/')};</script>'''
    write('spacecraft.html', shell('Spacecraft now', 'अंतरिक्ष यान अभी', 'missions', body, 'How far Voyager 1, Voyager 2, New Horizons, JWST, the ISS, Hubble and the Mars rovers are from Earth right now.', canonical='spacecraft.html'))
    # missions
    items = ''.join(f'<div class="m"><div class="y">{m["y"]}</div><h3>{m["name"]} <small class="note">· {m["agency"]}</small></h3><p>{bi("mission" + m["id"].capitalize())}</p>{mission_photos(m["id"])}</div>' for m in MISSIONS)
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
        o = f'<svg class="surfmap" data-world="{world}" viewBox="0 0 360 180" role="img" aria-label="{esc(tr("en", "surfaceMapOf", body=tr("en", "bodyMoon" if moon else "planetMars")))}" style="width:100%;height:auto;border-radius:16px;display:block;touch-action:none"><rect width="360" height="180" fill="{base}"/>'
        if world in MAPS:
            # the real photo map; the drawn features are left out
            o += f'<image href="img/space/map-{world}.webp" x="0" y="0" width="360" height="180" preserveAspectRatio="none"/>'
        for f in [f for f in FEATS if f['world'] == world and world not in MAPS]:
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
            o += f'<a href="#site-{si["id"]}" aria-label="{esc(si["name"])}" data-site="{si["id"]}" data-x="{si["lon"] + 180:.2f}" data-y="{90 - si["lat"]:.2f}"><circle class="sdot" cx="{si["lon"] + 180:.2f}" cy="{90 - si["lat"]:.2f}" r="2.6" fill="{colors[si["kind"]]}" stroke="#fff" stroke-width="1"><title>{esc(si["name"])}</title></circle></a>'
        return o + '</svg>'

    def fmtll(lat, lon):
        return f'{abs(lat):.2f}° {"N" if lat >= 0 else "S"}, {abs(lon):.2f}° {"E" if lon >= 0 else "W"}'
    legend = ''.join(f'<span style="display:inline-flex;align-items:center;gap:6px;margin-right:14px"><i style="width:12px;height:12px;border-radius:50%;background:{c};border:1.5px solid #fff;display:inline-block"></i>{bi(kind_key[k])}</span>' for k, c in colors.items())
    secs = ''
    for world, title_key in (('moon', 'bodyMoon'), ('mars', 'planetMars')):
        cards = ''.join(f'<div class="card" id="site-{x["id"]}"><div class="y" style="font:700 1rem Space Grotesk;color:var(--accent)">{x["year"]}</div><h3>{esc(x["name"])} <small class="note">· {x["agency"]} · {bi(kind_key[x["kind"]])}</small></h3><p class="note">{fmtll(x["lat"], x["lon"])}</p><p style="color:var(--text)">{bi("site" + x["id"])}</p>{spacephotos.figure("site-" + x["id"], "", bt, esc)}<p><button type="button" class="btn" data-zoomto="{x["id"]}">🔍 {bt("Show on the map", "नक्शे पर दिखाएँ")}</button></p></div>' for x in sorted([x for x in SITES if x['world'] == world], key=lambda x: (x['year'], x['name'])))
        secs += f'<section class="blk"><h2>{bi(title_key)}</h2><p class="sub">{bi("surfaceMapMoonHint" if world == "moon" else "surfaceMapMarsHint")}</p><div class="mapwrap">{svg(world)}<div class="mapctl"><button type="button" class="btn" data-mz="in" aria-label="Zoom in">+</button><button type="button" class="btn" data-mz="out" aria-label="Zoom out">−</button><button type="button" class="btn" data-mz="all">{bt("Whole map", "पूरा नक्शा")}</button></div></div><p class="note" style="margin-top:6px">{bt(*MAP_CREDIT[world]) if world in MAPS else ""} · {bt("Drag to move, pinch or use + to zoom.", "खिसकाने के लिए खींचें, ज़ूम के लिए pinch या + दबाएँ।")}</p><p style="margin-top:10px">{legend}</p><div class="grid" style="margin-top:14px">{cards}</div></section>'
    body = f'''<section class="blk"><h1>{bi("surfaceMapTitle")}</h1><p class="sub">{bi("surfaceMapNote")}</p></section>{secs}
<style>.card:target{{border-color:var(--accent);box-shadow:0 0 0 2px var(--accent)}}</style>'''
    write('maps.html', shell('Moon and Mars surface maps', 'चाँद और मंगल के नक़्शे', 'maps', body, 'Landing sites on the Moon and Mars at their real coordinates: Apollo, Chang\'e, Chandrayaan, Viking, Curiosity, Perseverance and more.', canonical='maps.html', extra_head=f'<script defer src="assets/mapzoom.js?v={asset_v()}"></script>'))


def mission_photos(mid):
    figs = ''.join(spacephotos.figure(p, '', bt, esc, cls='mphoto') for p in missionphotos.MISSION.get(mid, []))
    return f'<div class="mphotos">{figs}</div>' if figs else ''


def surface_maps():
    '''Real global maps: Mars (NASA/USGS Viking mosaic), the Moon and Earth (Solar System Scope, from NASA data).'''
    from PIL import Image
    d = OUT / 'img' / 'space'
    d.mkdir(parents=True, exist_ok=True)
    sp = ROOT / 'data/photos/space'
    src = {'mars': sp / 'map-mars.webp', 'moon': sp / 'map-moon.webp' if (sp / 'map-moon.webp').exists() else ROOT / 'data/textures/moon.webp',
           'earth': sp / 'map-earth.webp' if (sp / 'map-earth.webp').exists() else ROOT / 'data/textures/earth.webp'}
    for k, f in src.items():
        if f.exists():
            im = Image.open(f).convert('RGB')
            im.thumbnail((3000, 1500) if k == 'moon' else (2400, 1200) if k == 'mars' else (1440, 720))
            im.save(d / f'map-{k}.webp', 'WEBP', quality=72, method=6)
            MAPS[k] = im.size


MAPS = {}
MAP_CREDIT = {
    'mars': ('Map: NASA/JPL/USGS Viking color mosaic · public domain', 'नक्शा: NASA/JPL/USGS Viking रंगीन mosaic · public domain'),
    'moon': ('Map: Solar System Scope, made from NASA LRO data · CC BY 4.0', 'नक्शा: Solar System Scope, NASA LRO data से बना · CC BY 4.0'),
}


def community_pages():
    cfg = json.loads((ROOT / 'supabase/functions/community/config.json').read_text(encoding='utf-8'))
    v = asset_v()
    body = f'''<section class="blk cmhero slim"><div class="cmherobg" aria-hidden="true"></div><div class="cmherotx"><span class="cmeyebrow">👥 Astryl Community</span>
<h1>{bt("Share the sky. Ask the universe.", "आसमान बाँटिए। ब्रह्मांड से पूछिए।")}</h1>
<p class="sub">{bt("Photos of the Moon, planets and stars taken by space lovers, and a place to ask and answer anything about space.", "अंतरिक्ष के शौक़ीनों की खींची चाँद, ग्रहों और तारों की फ़ोटो, और अंतरिक्ष के बारे में कुछ भी पूछने और जवाब देने की जगह।")}</p>
<div class="btns"><button type="button" class="btn primary" data-new="photo">📷 {bt("Share a photo", "फ़ोटो भेजिए")}</button><button type="button" class="btn" data-new="post">❓ {bt("Ask a question", "सवाल पूछिए")}</button><a class="btn" id="cmMe" hidden href="profile.html">👤 {bt("My profile", "My profile")}</a><a class="btn" id="cmAdmin" hidden href="moderate.html">🛡️ {bt("Moderation queue", "Moderation queue")}</a></div>
<div class="cmnums" id="cmNums"></div></div></section>
<div class="cmtabs" id="cmTabs" role="tablist"><button type="button" role="tab" data-tab="gallery">📷 <span class="tlong">{bt("Sky photos", "आसमान की फ़ोटो")}</span><span class="tshort">{bt("Photos", "फ़ोटो")}</span></button><button type="button" role="tab" data-tab="talk">💬 <span class="tlong">{bt("Questions and answers", "सवाल और जवाब")}</span><span class="tshort">{bt("Questions", "सवाल-जवाब")}</span></button></div>
<section class="blk cmpanel" id="gallery"><div id="cmGallery"></div></section>
<section class="blk cmpanel" id="talk" hidden><div id="cmPosts"></div></section>
<section class="blk"><details class="cmrules"><summary>📜 {bt("Community rules", "Community के नियम")}</summary><ul>
<li>{bt("Be kind and stay on space and the sky.", "अच्छे से बात कीजिए और अंतरिक्ष व आसमान के विषय पर रहिए।")}</li>
<li>{bt("Never share your phone number, e-mail, address, school or photos of people.", "अपना फ़ोन नंबर, e-mail, पता, स्कूल या लोगों की फ़ोटो कभी न डालें।")}</li>
<li>{bt("Only share photos you took yourself.", "सिर्फ़ अपनी खींची फ़ोटो भेजिए।")}</li>
<li>{bt("You can edit or delete your own photos and posts at any time from the ⋯ menu.", "अपनी फ़ोटो और posts आप कभी भी ⋯ menu से बदल या हटा सकते हैं।")}</li>
<li>{bt("Use “Report” in the ⋯ menu for anything that breaks these rules. The moderator checks every report, and anything reported by three people is hidden at once.", "नियम तोड़ने वाली किसी भी चीज़ पर ⋯ menu में “शिकायत करें” दबाइए। Moderator हर शिकायत जाँचते हैं, और जिसकी तीन लोग शिकायत करें वह तुरंत छिप जाती है।")}</li>
<li>{bt("Deleting your account deletes all your photos and posts.", "खाता मिटाने पर आपकी सारी फ़ोटो और posts मिट जाते हैं।")}</li></ul></details></section>
<button type="button" class="cmfab" id="cmFab" aria-label="New">＋</button><div class="cmfabmenu" id="cmFabMenu" hidden><button type="button" data-new="photo">📷 {bt("Share a photo", "फ़ोटो भेजिए")}</button><button type="button" data-new="post">❓ {bt("Ask a question", "सवाल पूछिए")}</button></div>
<script>window.ASTRYL_COMMUNITY={json.dumps(cfg, ensure_ascii=False).replace('</', '<\\/')};</script>'''
    write('community.html', shell('Astryl Community', 'Astryl Community', 'community', body, 'The Astryl Community: sky photos by space lovers, and questions and answers about space.', canonical='community.html', extra_head=f'<script defer src="assets/community.js?v={v}"></script>'))
    body = f'''<div id="prof" class="prof"></div>
<script>window.ASTRYL_COMMUNITY={json.dumps(cfg, ensure_ascii=False).replace('</', '<\\/')};</script>'''
    write('profile.html', shell('Profile', 'Profile', 'community', body, 'A space lover’s public page on Astryl: sky photos, questions, answers and quiz badges.', canonical='profile.html', extra_head=f'<meta name="robots" content="noindex"><script defer src="assets/profile.js?v={v}"></script>'))
    body = f'''<section class="blk"><h1>🛡️ Moderation</h1><p class="sub">Photos, posts and blog comments people reported. Keep it to show it again, remove to delete it for good.</p><div id="mod"></div></section>'''
    write('moderate.html', shell('Moderation', 'Moderation', 'community', body, 'Astryl Community moderation.', canonical='moderate.html', extra_head=f'<meta name="robots" content="noindex"><script defer src="assets/moderate.js?v={v}"></script>'))


def get_page():
    # Old links to get.html go to the home page.
    body = f'''<section class="blk"><h1>{bt("Astryl is a website", "Astryl एक website है")}</h1><p class="sub">{bt("Everything is here on astryl.space, in your browser. Taking you to the home page…", "सब कुछ यहीं astryl.space पर, आपके browser में है। आपको home page पर ले जा रहे हैं…")}</p><p><a class="btn primary" href="index.html">{bt("Go to the home page", "Home page पर जाएँ")} →</a></p></section>'''
    write('get.html', shell('Astryl', 'Astryl', 'home', body, 'Astryl is a website: astryl.space.', canonical='index.html', extra_head='<meta name="robots" content="noindex"><meta http-equiv="refresh" content="2;url=index.html">'))


def account_page():
    body = f"""<section class="acpage"><div id="acct"><h1>{bt("Astryl account", "Astryl खाता")}</h1><noscript><p>{bt("The account page needs JavaScript.", "Account page को JavaScript चाहिए।")}</p></noscript></div>
<p class="note acfoot"><a href="privacy.html">{bt("Privacy Policy", "Privacy Policy")}</a> · <a href="terms.html">Terms and Conditions</a> · <a href="your-data.html">Your data</a></p></section>"""
    write('account.html', shell('Account', 'खाता', 'account', body, 'Create your Astryl account with a username and password, and keep your favourites, quiz scores and settings on every device.', canonical='account.html'))


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
        'description': 'Planets, moons, stars and space missions: real positions and real numbers for any date.',
        'icons': [{'src': '/img/icons/icon-192.png', 'sizes': '192x192', 'type': 'image/png'},
                  {'src': '/img/icons/icon-512.png', 'sizes': '512x512', 'type': 'image/png'},
                  {'src': '/img/icons/maskable-512.png', 'sizes': '512x512', 'type': 'image/png', 'purpose': 'maskable'}],
        'shortcuts': [{'name': 'Tonight in your city', 'url': '/tonight.html'}, {'name': 'Space station passes', 'url': '/iss.html'}, {'name': 'Quiz', 'url': '/quiz.html'}],
    }
    (OUT / 'manifest.webmanifest').write_text(json.dumps(manifest, ensure_ascii=False, indent=1), encoding='utf-8')
    v = asset_v()
    core = ['/', '/index.html', '/offline.html', '/planets.html', '/assets/icon.svg', '/img/icons/icon-192.png']
    core += [f'/assets/{n}?v={v}' for n in ('style.css', 'data.js', 'app.js', 'account.js', 'me.js', 'fx.js', 'pwa.js', 'icons.js', 'citypick.js', 'home.js', 'apod.js')]
    core += [f'/fonts/{f.replace(".ttf", ".woff")}' for f in FONT_FILES]
    sw = (SRC / 'sw.js').read_text(encoding='utf-8').replace("'__VERSION__'", json.dumps(v)).replace('__CORE__', json.dumps(core))
    (OUT / 'sw.js').write_text(sw, encoding='utf-8')


FONT_FILES = ('DMSans-Regular.ttf', 'DMSans-Medium.ttf', 'DMSans-Bold.ttf', 'SpaceGrotesk-Medium.ttf', 'SpaceGrotesk-Bold.ttf')
# Latin, punctuation and the symbols the pages use; everything else falls back to the system font
FONT_UNICODES = '0000-00FF,0131,0152-0153,02C6,02DA,02DC,2000-206F,2070-209F,20AC,2100-214F,2190-21FF,2212,2215,2248,2260,2264,2265,00D7,2032,2033'


def web_font(src, dst):
    """A smaller copy of a font for the website: Latin only, as WOFF (cached by source size)."""
    from fontTools import subset
    cache = ROOT / 'build' / 'fonts' / (dst.name + f'.{src.stat().st_size}')
    if not cache.exists():
        cache.parent.mkdir(parents=True, exist_ok=True)
        opts = subset.Options(); opts.flavor = 'woff'; opts.layout_features = ['*']; opts.name_IDs = ['*']; opts.notdef_outline = True
        font = subset.load_font(str(src), opts)
        sub = subset.Subsetter(opts); sub.populate(unicodes=subset.parse_unicodes(FONT_UNICODES)); sub.subset(font)
        subset.save_font(font, str(cache), opts)
    shutil.copy(cache, dst)


def parse_cities():
    text = site_data.table('cities.dart')
    return [[a, b, c, float(d), float(e)] for a, b, c, d, e in re.findall(r"City\('([\w-]+)', '([^']+)', '([^']+)', ([-\d.]+), ([-\d.]+)\)", text)]


def data_js():
    data = dict(cities=parse_cities(), eclipses=skyevents.eclipse_json(),
        bodies=[{k: v for k, v in b.items()} for b in BODIES], orbits=ORBITS, factIds=FACT_IDS, milestones=MILESTONES, meteors=METEORS,
        spacecraft=CRAFT, L={'en': L['en']})
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
    for sub in ('assets', 'body', 'fonts', 'black-holes', 'galaxies', 'stars', 'sky-events', 'learn'):
        if (OUT / sub).exists():
            shutil.rmtree(OUT / sub)
    for old in OUT.glob('*.html'):
        old.unlink()
    (OUT / 'assets').mkdir(parents=True, exist_ok=True)
    (OUT / 'assets/style.css').write_text((SRC / 'style.css').read_text(encoding='utf-8') + '\n/* line icons (tools/icons.py) */\n' + icons.css(), encoding='utf-8')
    (OUT / 'assets/icons.js').write_text('window.ASTRYL_IC=' + json.dumps(icons.js_map(), ensure_ascii=False) + ';\n' + (SRC / 'icons.js').read_text(encoding='utf-8'), encoding='utf-8')
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
    for name in ('me.js', 'myspace.js', 'birthday.js', 'tonight.js', 'telescope.js', 'sgp4.js', 'iss.js', 'apod.js', 'worlds.js', 'pwa.js', 'rounds.js', 'bhsim.js', 'sheet.js', 'mapzoom.js', 'home.js', 'community.js', 'moderate.js', 'stars.js', 'profile.js', 'blog.js', 'discover.js', 'citypick.js', 'journey.js'):
        shutil.copy(SRC / name, OUT / 'assets' / name)
    (OUT / 'assets/data.js').write_text(data_js(), encoding='utf-8')
    (OUT / 'assets/icon.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg" viewBox="-60 -60 120 120"><rect x="-60" y="-60" width="120" height="120" rx="26" fill="#fbf7ee"/><circle r="30" fill="#1b3a8a"/><ellipse rx="50" ry="15" fill="none" stroke="#6a45d6" stroke-width="6" transform="rotate(-24)"/><circle cx="40" cy="-20" r="6" fill="#1b3a8a"/></svg>', encoding='utf-8')
    (OUT / 'fonts').mkdir()
    for f in ('OFL-DMSans.txt', 'OFL-SpaceGrotesk.txt'):
        shutil.copy(site_data.FONTS / f, OUT / 'fonts' / f)
    for f in FONT_FILES:
        web_font(site_data.FONTS / f, OUT / 'fonts' / f.replace('.ttf', '.woff'))
    (OUT / 'CNAME').write_text('astryl.space\n', encoding='utf-8')
    (OUT / '.nojekyll').write_text('', encoding='utf-8')
    (OUT / 'robots.txt').write_text(f'User-agent: *\nAllow: /\nSitemap: {SITE}/sitemap.xml\n', encoding='utf-8')
    # Google Search Console ownership check (not a secret)
    (OUT / 'googlec7b6e53400a8007d.html').write_text('google-site-verification: googlec7b6e53400a8007d.html', encoding='utf-8')
    PHOTO.update(photos.build(OUT)); PHOTO_CREDIT.update(photos.credits())
    spacephotos.build(OUT)
    surface_maps()
    (OUT / 'assets/sheet-data.js').write_text(sheet_js(), encoding='utf-8')
    QB_SIZES = quizbank.build(OUT, ROOT, BODIES, lambda lg, i: tr(lg, NAME_KEY[i]), CONS, PHOTO)
    for i, b in enumerate(BODIES):
        body_page(b, i)
    index_page(); planets_page(); simple_pages(); community_pages(); maps_page(); get_page(); account_page(); not_found(); pwa_files()
    helpers = dict(bt=bt, bi=bi, raw2=raw2, shell=shell, write=write, esc=esc, fmt=fmt, asset_v=asset_v, SITE=SITE, ROOT=ROOT, orbits=ORBITS, city_picker=city_picker)
    tonight_urls = tonight.build(helpers)
    deep = deepspace.build(helpers) + galaxies.build(helpers) + stars.build(helpers) + lab.build(helpers) + universe.build(helpers) + learn.build(helpers) + umap.build(helpers) + myspace.build(helpers) + skyevents.build(helpers) + students.build(helpers) + telescope.build(helpers) + iss.build(helpers) + blog.build(helpers) + legal.build(helpers) + journey.build(helpers)
    urls = ['', 'community.html', 'planets.html', 'solar-system.html', 'compare.html', 'you.html', 'quiz.html', 'sky.html', 'constellations.html', 'maps.html', 'missions.html', 'spacecraft.html', 'privacy.html', 'account.html', 'black-holes.html', 'galaxies.html'] + deep + [f'body/{b["id"]}.html' for b in BODIES]
    today = datetime.date.today().isoformat()
    urls = urls + [u for u in tonight_urls if u not in urls]
    def sm(u):
        return f'<url><loc>{SITE}/{u}</loc>' + (f'<lastmod>{today}</lastmod><changefreq>daily</changefreq>' if u.startswith('tonight') else '') + '</url>\n'
    (OUT / 'sitemap.xml').write_text('<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' + ''.join(sm(u) for u in urls) + '</urlset>\n', encoding='utf-8')
    og_images()
    (ROOT / 'tools' / 'i18n' / 'source.tsv').write_text('# id<TAB>English text of every translatable text on the site (generated by build_site.py)\n' + ''.join(f'{k}\t{v}\n' for k, v in sorted(SOURCE.items(), key=lambda kv: kv[1])), encoding='utf-8')
    print('pages:', len(list(OUT.rglob('*.html'))), 'share images:', len(_OG), 'texts:', len(SOURCE), {lg: len(TRX[lg]) for lg in EXTRA_LANGS})


if __name__ == '__main__':
    main()
