#!/usr/bin/env python3
"""Builds the Astryl website (site/) from the app's own data.

Reads lib/data/*.dart, lib/core/*.dart and lib/l10n/app_{en,hi}.arb, so the
website shows the same planets, texts and numbers as the app. Run it from the
project root:  python3 tools/build_site.py
"""
import html, json, math, re, shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / 'tools' / 'site_src'
OUT = ROOT / 'site'
REPO = 'https://github.com/aditymishr098-collab/astryl'
SITE = 'https://astryl.space'

# ------------------------------------------------------------------ data
L = {lg: {k: v for k, v in json.load(open(ROOT / f'lib/l10n/app_{lg}.arb', encoding='utf-8')).items() if not k.startswith('@')} for lg in ('en', 'hi')}


def color(h):
    return '#' + h[4:].lower()


# Strings used only by the website's home-page animation (cosmos.js).
L['en'].update(cosmosHere='The Sun is here', cosmosToday='Today', cosmosSun='Sun', cosmosMoon='The Moon today: {lit}% lit, day {day}')
L['hi'].update(cosmosHere='सूर्य यहाँ है', cosmosToday='आज', cosmosSun='सूर्य', cosmosMoon='आज का चाँद: {lit}% रोशन, दिन {day}')


def parse_bodies():
    text = (ROOT / 'lib/data/planets.dart').read_text(encoding='utf-8')
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
    text = (ROOT / 'lib/core/orbits.dart').read_text(encoding='utf-8')
    out = {}
    for m in re.finditer(r"'(\w+)': _Elements\(([^)]*)\)", text):
        out[m.group(1)] = [float(x) for x in re.findall(r'-?[\d.]+(?:e-?\d+)?', m.group(2))]
    return out


def parse_missions():
    text = (ROOT / 'lib/data/missions.dart').read_text(encoding='utf-8')
    res = []
    for m in re.finditer(r"id: '(\w+)',\s*name: '([^']+)',\s*agency: '([^']+)',\s*year: (\d+),\s*month: (\d+),\s*day: (\d+)", text):
        res.append(dict(id=m.group(1), name=m.group(2), agency=m.group(3), y=int(m.group(4)), m=int(m.group(5)), d=int(m.group(6))))
    return res


def parse_spacecraft():
    text = (ROOT / 'lib/core/spacecraft.dart').read_text(encoding='utf-8')
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
    text = (ROOT / 'lib/data/sky_catalog.dart').read_text(encoding='utf-8')
    res = []
    for m in re.finditer(r"^  ConstellationData\('(\w+)', '((?:[^'\\]|\\.)*)', <String, String>\{([^}]*)\}, ([-\d.]+), ([-\d.]+), <List<double>>\[(.*)\]\),$", text, re.M):
        names = {k: v.replace("\\'", "'") for k, v in re.findall(r"'(\w+)': '((?:[^'\\]|\\.)*)'", m.group(3))}
        lines = [[float(x) for x in re.findall(r'-?[\d.]+', seg)] for seg in re.findall(r'<double>\[([^\]]*)\]', m.group(6))]
        res.append(dict(id=m.group(1), latin=m.group(2), names=names, ra=float(m.group(4)), dec=float(m.group(5)), lines=lines))
    return res


def parse_meteors():
    text = (ROOT / 'lib/core/events.dart').read_text(encoding='utf-8')
    return [[a, int(b), int(c), int(d)] for a, b, c, d in re.findall(r"\('(\w+)', (\d+), (\d+), (\d+)\),", text)]


def parse_surface():
    text = (ROOT / 'lib/data/surface_sites.dart').read_text(encoding='utf-8')
    sites = []
    for m in re.finditer(r"SurfaceSite\(id: '(\w+)', world: SurfaceWorld\.(\w+), name: (?:'([^']*)'|\"([^\"]*)\"), agency: '([^']+)', year: (\d+), lat: ([-\d.]+), lon: ([-\d.]+), kind: SiteKind\.(\w+)\)", text):
        sites.append(dict(id=m.group(1), world=m.group(2), name=m.group(3) or m.group(4), agency=m.group(5), year=int(m.group(6)), lat=float(m.group(7)), lon=float(m.group(8)), kind=m.group(9)))
    feats = []
    for m in re.finditer(r"SurfaceFeature\(id: '(\w+)', world: SurfaceWorld\.(\w+), lat: ([-\d.]+), lon: ([-\d.]+), rx: ([\d.]+), ry: ([\d.]+), kind: FeatureKind\.(\w+)(?:, tilt: ([-\d.]+))?(?:, major: (true))?\)", text):
        feats.append(dict(id=m.group(1), world=m.group(2), lat=float(m.group(3)), lon=float(m.group(4)), rx=float(m.group(5)), ry=float(m.group(6)), kind=m.group(7), tilt=float(m.group(8) or 0), major=bool(m.group(9))))
    return sites, feats


def parse_fact_ids():
    text = (ROOT / 'lib/core/facts.dart').read_text(encoding='utf-8')
    return re.findall(r"^  '(\w+)',$", text, re.M)


def parse_milestones():
    text = (ROOT / 'lib/core/birthday.dart').read_text(encoding='utf-8')
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
assert len(ORBITS) == 9 and len(MISSIONS) == 15 and len(CRAFT) == 7 and len(CONS) == 89, (len(ORBITS), len(MISSIONS), len(CRAFT), len(CONS))
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


def bi(key, **p):
    """Both languages as two spans; CSS shows the one that matches <html lang>."""
    return ''.join(f'<span class="t" lang="{lg}">{esc(tr(lg, key, **{k: (v[lg] if isinstance(v, dict) else v) for k, v in p.items()}))}</span>' for lg in ('en', 'hi'))


def bt(en, hi):
    return f'<span class="t" lang="en">{esc(en)}</span><span class="t" lang="hi">{esc(hi)}</span>'


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
    return '<svg viewBox="-60 -60 120 120" aria-hidden="true"><circle r="34" fill="#f2b84b"/><ellipse rx="56" ry="17" fill="none" stroke="#7aa2ff" stroke-width="6" transform="rotate(-24)"/><circle cx="46" cy="-22" r="7" fill="#eef0fb"/></svg>'


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
NAV = [('index.html', 'home', bt('Home', 'होम')), ('planets.html', 'planets', bi('planetsTitle')), ('solar-system.html', 'solar', bi('solarSystemTitle')), ('compare.html', 'compare', bi('navCompare')),
       ('you.html', 'you', bt('You', 'आप')), ('quiz.html', 'quiz', bi('navQuiz')), ('sky.html', 'sky', bi('skyTitle')), ('constellations.html', 'cons', bi('constellationsLabel')), ('maps.html', 'maps', bi('surfaceMapTitle')), ('missions.html', 'missions', bi('missionsTitle')), ('get.html', 'get', bt('Get the app', 'App पाएँ'))]


def shell(title_en, title_hi, page, body, desc_en, depth=0, canonical='', scripts=True, extra_head=''):
    p = '../' * depth
    nav = ''.join(f'<a href="{p}{h}"{" class=on" if k == page else ""}>{label}</a>' for h, k, label in NAV)
    url = f'{SITE}/{canonical}' if canonical else SITE + '/'
    return f'''<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{esc(title_en)} · Astryl</title>
<meta name="description" content="{esc(desc_en)}">
<link rel="canonical" href="{url}">
<meta property="og:title" content="{esc(title_en)} · Astryl"><meta property="og:description" content="{esc(desc_en)}"><meta property="og:type" content="website"><meta property="og:url" content="{url}"><meta name="theme-color" content="#0a0d1a">
<link rel="icon" href="{p}assets/icon.svg" type="image/svg+xml">
<link rel="stylesheet" href="{p}assets/style.css">
<script>try{{var s=localStorage,l=s.getItem("astryl-lang")||((navigator.language||"en").slice(0,2)==="hi"?"hi":"en"),h=s.getItem("astryl-theme");document.documentElement.lang=l==="hi"?"hi":"en";if(h)document.documentElement.setAttribute("data-theme",h)}}catch(e){{}}</script>
{extra_head}</head>
<body data-page="{page}" data-root="{p}">
<div class="stars"></div>
<header class="top"><div class="wrap bar">
<a class="brand" href="{p}index.html">{logo_svg()}Astryl</a>
<nav class="links">{nav}</nav>
<div class="tools"><button id="langBtn" aria-label="Language">हिन्दी</button><button id="themeBtn" aria-label="Theme">☀</button></div>
</div></header>
<main class="wrap">
{body}
</main>
<footer><div class="wrap cols">
<div><b>Astryl</b><br>{bt("Know your space.", "अपने अंतरिक्ष को जानिए।")}<br>© 2026 Astryl · <a href="{SITE}">astryl.space</a></div>
<div>{bt("Free and open source", "मुफ़्त और open source")}<br><a href="{REPO}">{bt("Source code on GitHub", "GitHub पर source code")}</a><br><a href="{REPO}/blob/main/LICENSE">AGPL-3.0</a> · <a href="{p}privacy.html">{bt("Privacy Policy", "Privacy Policy")}</a><br><a href="{p}account.html">{bt("Account", "खाता")}</a></div>
<div>{bt("Facts: NASA Planetary Fact Sheet", "तथ्य: NASA Planetary Fact Sheet")}<br><a href="{REPO}/releases">{bt("All versions", "सभी versions")}</a></div>
</div></footer>
{"<script src=\"" + p + "assets/data.js\"></script><script src=\"" + p + "assets/app.js\"></script><script src=\"" + p + "assets/account.js\"></script>" if scripts else ""}
</body></html>
'''


def write(path, content):
    f = OUT / path
    f.parent.mkdir(parents=True, exist_ok=True)
    f.write_text(content, encoding='utf-8')


# ------------------------------------------------------------------ pages
def stat(label_key, value_html):
    return f'<div class="stat"><b>{value_html}</b><span>{bi(label_key)}</span></div>'


def body_page(b, i):
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
        moons = f'<h2>{bi("majorMoons")}</h2><div class="grid sm">' + ''.join(f'<a class="card pcard" href="{m["id"]}.html">{planet_svg(m, uid="m")}<div><b>{bname(m["id"])}</b><br><small>{val(v_diam(m))}</small></div></a>' for m in mo) + '</div>'
    dyn = ''
    if b['kind'] in ('planet', 'dwarf') or b['id'] == 'pluto':
        if b['id'] != 'earth':
            dyn = f'<h2>{bi("travelTitle")}</h2><div class="card" id="travel" data-body="{idn}"></div>'
    # weight
    prev = BODIES[i - 1] if i > 0 else None
    nxt = BODIES[i + 1] if i + 1 < len(BODIES) else None
    pn = '<div class="pn">' + (f'<a class="btn" href="{prev["id"]}.html">← {bname(prev["id"])}</a>' if prev else '<span></span>') + (f'<a class="btn" href="{nxt["id"]}.html">{bname(nxt["id"])} →</a>' if nxt else '<span></span>') + '</div>'
    wt = f'<h2>{bi("weightFeelsLike", weight="60")}</h2><div class="card"><div class="life">{val(lambda lg: fmt(lg, 60 * b["g"] / 9.8, 1) + " kg")}</div><p class="note">{bi("gravityTimes", factor={lg: fmt(lg, b["g"] / 9.8, 2) for lg in ("en", "hi")})} · <a href="../you.html">{bi("weightTitle")}</a></p></div>' if b['hasSurface'] or True else ''
    body = f'''<p style="margin-top:20px"><a href="../planets.html">← {bi("planetsTitle")}</a></p>
<div class="bodyhead">{planet_svg(b)}<div><h1 style="margin:0">{bname(idn)}</h1><p class="sub" style="margin:.2em 0 0">{sub}</p></div></div>
<div class="stats">{"".join(stats)}</div>
<section class="blk">{atm}</section>
<section class="blk">{lifehtml}</section>
<section class="blk">{wt}</section>
<section class="blk">{facts}</section>
<section class="blk">{moons}{dyn}</section>
{pn}'''
    en_name = tr('en', NAME_KEY[idn])
    write(f'body/{idn}.html', shell(en_name, tr('hi', NAME_KEY[idn]), 'planets', body, f'{en_name}: size, gravity, temperature, day and year length, atmosphere and facts. From the Astryl Solar System app.', depth=1, canonical=f'body/{idn}.html'))


def index_page():
    feats = [('🪐', 'planetsTitle', 'Every planet, dwarf planet and 9 major moons: size, gravity, temperature, atmosphere and a "could we live here" score.', 'हर ग्रह, बौना ग्रह और 9 बड़े चाँद: आकार, गुरुत्वाकर्षण, तापमान, वायुमंडल और "क्या हम यहाँ रह सकते हैं" score।', 'planets.html'),
             ('🌌', 'solarSystemTitle', 'Real positions of the planets on any date, with 2D and 3D views in the app.', 'किसी भी तारीख़ पर ग्रहों की असली स्थिति। App में 2D और 3D दोनों views हैं।', 'solar-system.html'),
             ('🌙', 'skyTitle', "Tonight's Moon, a Moon calendar and meteor showers. The app adds your city, sunrise and planets you can see.", 'आज रात का चाँद, चाँद का calendar और उल्कापात। App में आपका शहर, सूर्योदय और दिखने वाले ग्रह भी हैं।', 'sky.html'),
             ('⚖️', 'weightTitle', 'Your weight, jump height and age on every world, and the sky on your birthday.', 'हर दुनिया पर आपका वज़न, कूद की ऊँचाई और उम्र, और आपके जन्मदिन का आसमान।', 'you.html'),
             ('🧠', 'quizTitle', 'Ten questions in three levels, built from the planet data.', 'तीन levels में दस सवाल, ग्रहों के data से बने।', 'quiz.html'),
             ('⭐', 'starMapTitle', '89 constellations with their stories. The app has a live star map, a compass planet finder and a binocular guide.', '89 तारामंडल और उनकी कहानियाँ। App में live star map, compass से ग्रह ढूँढना और दूरबीन guide भी है।', 'constellations.html'),
             ('🗺️', 'surfaceMapTitle', 'Landing sites on the Moon and Mars, at their real coordinates, from Luna 9 to Chandrayaan-3 and Perseverance.', 'चाँद और मंगल पर उतरने की जगहें, असली coordinates पर, Luna 9 से Chandrayaan-3 और Perseverance तक।', 'maps.html'),
             ('🚀', 'missionsTitle', 'Sputnik to Chandrayaan-3: famous moments in space exploration.', 'Sputnik से Chandrayaan-3 तक: अंतरिक्ष खोज के मशहूर पल।', 'missions.html'),
             ('🛰️', 'spacecraftTitle', 'How far Voyager, JWST and the Mars rovers are from Earth, right now.', 'Voyager, JWST और Mars rovers इस वक़्त Earth से कितनी दूर हैं।', 'spacecraft.html')]
    cards = ''.join(f'<a class="card" href="{h}"><div class="ico">{ic}</div><h3>{bi(k)}</h3><p>{bt(en, hi)}</p></a>' for ic, k, en, hi, h in feats)
    body = f'''<section class="cosmos-hero">
<canvas id="galaxy" aria-hidden="true"></canvas>
<div class="hero-text">
<h1>{bt("Know your space.", "अपने अंतरिक्ष को जानिए।")}</h1>
<p class="lead">{bt("Astryl is a free, open-source Android app for the planets, moons, the sky and space missions. Real positions for any date, live updates, and no ads. An account is optional.", "Astryl ग्रहों, चाँदों, आसमान और अंतरिक्ष missions का मुफ़्त open-source Android app है। किसी भी तारीख़ की असली स्थिति, live updates और कोई विज्ञापन नहीं। खाता वैकल्पिक है।")}</p>
<div class="btns"><a class="btn primary dl-btn" href="{REPO}/releases/latest">⬇ {bt("Download for Android", "Android के लिए download करें")}</a><a class="btn" href="#journey">{bt("Start the journey", "सफ़र शुरू करें")}</a></div>
<p class="note"><span class="ver"></span></p>
<div class="chips"><span class="chip">{bt("Free", "मुफ़्त")}</span><span class="chip">{bt("Open source", "Open source")}</span><span class="chip">{bt("No ads", "कोई विज्ञापन नहीं")}</span><span class="chip">{bt("English + हिन्दी", "English + हिन्दी")}</span><span class="chip">AGPL-3.0</span></div>
</div>
<p class="art-note">{bt("The Milky Way is an artist's impression.", "Milky Way कलाकार की कल्पना है।")}</p>
</section>
<section class="journey" id="journey"><div class="stick">
<canvas id="cosmos" aria-label="{esc("Scroll to travel from the Milky Way to the Solar System, Earth and the Moon")}"></canvas>
<div class="caps">
<div class="cap on"><h2>{bt("Our galaxy", "हमारी आकाशगंगा")}</h2><p>{bt("The Milky Way holds hundreds of billions of stars. The Sun sits in one of its arms, about 26,000 light-years from the centre.", "आकाशगंगा में सैकड़ों अरब तारे हैं। सूर्य उसकी एक भुजा में है, केंद्र से लगभग 26,000 प्रकाश-वर्ष दूर।")}</p></div>
<div class="cap"><h2>{bt("The Solar System", "सौरमंडल")}</h2><p>{bt("Every planet in its real place today. Keep scrolling and time moves forward. Distances are squeezed so the inner planets stay visible.", "हर ग्रह आज अपनी असली जगह पर। Scroll करते रहिए, समय आगे बढ़ता है। भीतरी ग्रह दिखते रहें इसलिए दूरियाँ दबाई गई हैं।")} <a href="solar-system.html">{bt("Open the full Solar System", "पूरा सौरमंडल खोलें")}</a></p></div>
<div class="cap"><h2>{bt("Earth and the Moon", "पृथ्वी और चाँद")}</h2><p>{bt("The Moon is where it really is right now, and the Sun is on the side that lights it.", "चाँद ठीक वहीं है जहाँ वह अभी है, और सूर्य उस तरफ़ है जिधर से उसे रोशनी मिलती है।")} <a href="sky.html">{bt("Moon calendar", "चाँद का calendar")}</a></p></div>
</div>
<div class="jdate" id="jDate"></div>
<div class="jphase" id="jPhase"><canvas width="64" height="64"></canvas><span></span></div>
<div class="jdots"><i class="on"></i><i></i><i></i></div>
</div></section>
<section class="blk"><div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(260px,1fr))"><div class="card" id="dailyFact"></div><div class="card pcard" id="homeMoon"></div></div></section>
<section class="blk"><h2>{bt("What is inside", "अंदर क्या है")}</h2><p class="sub">{bt("Everything below works on this website. The app has more and works without internet.", "नीचे सब कुछ इस website पर चलता है। App में इससे ज़्यादा है और वह बिना internet के चलता है।")}</p><div class="grid">{cards}</div></section>
<section class="blk"><h2>{bt("Astryl in numbers", "Astryl आँकड़ों में")}</h2><div class="stats" id="stats"></div><p class="note" id="statsCountries"></p><p class="note" id="statsNote"></p></section>
<section class="blk"><h2>{bt("Only in the app", "सिर्फ़ app में")}</h2>
<div class="grid">
<div class="card"><h3>🧭 {bt("Planet finder", "ग्रह खोजक")}</h3><p>{bt("Point your phone at the sky and the compass guides you to a planet.", "फ़ोन आसमान की तरफ़ करें, compass आपको ग्रह तक ले जाता है।")}</p></div>
<div class="card"><h3>🔔 {bt("Reminders", "Reminders")}</h3><p>{bt("Notes for eclipses, meteor showers, planet views and a nightly sky note.", "ग्रहण, उल्कापात, ग्रह दिखने और हर रात के आसमान के लिए याद दिलाने वाले notes।")}</p></div>
<div class="card"><h3>📍 {bt("Your city or your location", "आपका शहर या आपकी location")}</h3><p>{bt("Moonrise, sunset, golden hour and the planets above your horizon, from a city or from your approximate location.", "चाँद का उगना, सूर्यास्त, golden hour और आपके क्षितिज के ऊपर के ग्रह, किसी शहर से या आपकी अनुमानित location से।")}</p></div>
<div class="card"><h3>👤 {bt("Account (optional)", "खाता (वैकल्पिक)")}</h3><p>{bt("Username and password only. Your favourites, scores and settings sync between the app and this website.", "सिर्फ़ username और password। आपके favourites, scores और settings app और इस website के बीच sync होते हैं।")} <a href="account.html">{bt("Open", "खोलें")}</a></p></div>
<div class="card"><h3>🛰️ {bt("Space station", "अंतरिक्ष station")}</h3><p>{bt("ISS, Tiangong and Hubble passes over your city (optional online data).", "आपके शहर के ऊपर ISS, Tiangong और Hubble का गुज़रना (optional online data)।")}</p></div>
<div class="card"><h3>💾 {bt("Backup", "Backup")}</h3><p>{bt("Favourites, scores and settings in one small file that stays on your phone.", "Favourites, scores और settings एक छोटी file में, जो आपके फ़ोन में ही रहती है।")}</p></div>
<div class="card"><h3>🔄 {bt("Updates", "Updates")}</h3><p>{bt("Download and install new versions from inside the app, straight from GitHub.", "नए versions app के अंदर से ही, सीधे GitHub से download और install करें।")}</p></div>
</div><div class="btns"><a class="btn primary dl-btn" href="{REPO}/releases/latest">⬇ {bt("Download", "Download")}</a><a class="btn" href="get.html">{bt("How to install", "Install कैसे करें")}</a></div></section>'''
    write('index.html', shell('Know your space', 'अपने अंतरिक्ष को जानिए', 'home', body, 'Astryl is a free, open-source Android app to know your space: planets, moons, the sky, quiz and space missions. Real positions, no ads.', canonical='', extra_head='<script defer src="assets/cosmos.js"></script>'))


def planets_page():
    def card(b):
        return f'<a class="card pcard" data-id="{b["id"]}" data-search="{b["id"]}" href="body/{b["id"]}.html">{planet_svg(b, uid="p")}<div><b>{bname(b["id"])}</b><br><small>{val(v_diam(b))}</small></div></a>'
    groups = [('star', bt('Star', 'तारा'), [b for b in BODIES if b['kind'] == 'star']), ('planet', bt('Planets', 'ग्रह'), [b for b in BODIES if b['kind'] == 'planet']),
              ('dwarf', bt('Dwarf planet', 'बौना ग्रह'), [b for b in BODIES if b['id'] == 'pluto']), ('moon', bi('majorMoons'), [b for b in BODIES if b['kind'] == 'moon'])]
    secs = ''.join(f'<section class="blk"><h2>{t}</h2><div class="grid">{"".join(card(b) for b in bs)}</div></section>' for _, t, bs in groups)
    body = f'''<section class="blk"><h1>{bi("planetsTitle")}</h1><p class="sub">{bt("Tap a world for its size, gravity, temperature, atmosphere and facts.", "किसी दुनिया पर क्लिक करें: उसका आकार, गुरुत्वाकर्षण, तापमान, वायुमंडल और तथ्य।")}</p>
<div class="row"><input type="search" id="q" placeholder="{esc(tr("en", "searchHint"))}" aria-label="Search"></div></section>{secs}'''
    write('planets.html', shell('Planets and moons', 'ग्रह और चाँद', 'planets', body, 'Every planet, Pluto and nine major moons: diameter, gravity, temperature, day and year length, atmosphere and a life score.', canonical='planets.html'))


def simple_pages():
    # solar system
    body = f'''<section class="blk"><h1>{bi("solarSystemTitle")}</h1><p class="sub">{bt("Real positions of the planets on this date. Sizes and distances are not to scale. Use the slider or play to move through time.", "इस तारीख़ पर ग्रहों की असली स्थिति। आकार और दूरी पैमाने के हिसाब से नहीं हैं। Slider या play से समय में आगे-पीछे जाइए।")}</p>
<div style="max-width:640px"><canvas id="solar"></canvas></div>
<div class="row"><button class="btn" id="solMonthBack">« {bi("monthBack")}</button><button class="btn" id="solPlay">▶</button><button class="btn" id="solToday"></button><button class="btn" id="solMonthFwd">{bi("monthForward")} »</button><b id="solDate"></b></div>
<input type="range" id="solDay" min="-3650" max="3650" value="0" style="width:100%;max-width:640px" aria-label="Date">
<p class="note">{bt("Radius is stretched (square root of the distance) so all planets fit. In the app you also get a 3D view with zoom.", "सारे ग्रह दिखें इसलिए दूरी (वर्गमूल के हिसाब से) खींची गई है। App में zoom वाला 3D view भी है।")}</p></section>
<section class="blk"><h2>{bi("distanceFromEarth")}</h2><div id="solTable"></div></section>'''
    write('solar-system.html', shell('Solar System today', 'सौरमंडल आज', 'solar', body, 'Real positions of the planets on any date, and how far each one is from Earth today.', canonical='solar-system.html'))
    # compare
    body = f'''<section class="blk"><h1>{bi("compareTitle")}</h1><p class="sub">{bi("compareHint")}</p><div class="row"><select id="cmpA" aria-label="A"></select><span>vs</span><select id="cmpB" aria-label="B"></select></div><div id="cmpOut"></div></section>'''
    write('compare.html', shell('Compare planets', 'ग्रहों की तुलना', 'compare', body, 'Compare any two planets or moons side by side.', canonical='compare.html'))
    # you
    body = f'''<section class="blk"><h1>{bi("weightTitle")}</h1>
<div class="row"><label>{bi("weightInput")}<br><input type="number" id="kg" value="60" min="0" step="1"></label><label>{bi("jumpInput")}<br><input type="number" id="cm" value="40" min="0" step="1"></label></div>
<p class="note">{bi("jumpNote")}</p><div id="wOut"></div></section>
<section class="blk"><h2>{bi("setBirthDate")}</h2><div class="row"><input type="date" id="birth" aria-label="Birth date"></div><p class="note">{bt("Worked out in your browser. Nothing is sent or saved.", "आपके browser में ही निकाला जाता है। कुछ भेजा या save नहीं किया जाता।")}</p><div id="ageOut"></div><div id="bdOut"></div></section>'''
    write('you.html', shell('Weight, age and birthday sky', 'वज़न, उम्र और जन्मदिन का आसमान', 'you', body, 'Your weight, jump height and age on every planet, and the Moon on the day you were born.', canonical='you.html'))
    # quiz
    body = f'''<section class="blk"><h1>{bi("quizTitle")}</h1><div id="quiz"></div></section>'''
    write('quiz.html', shell('Planet quiz', 'ग्रहों की quiz', 'quiz', body, 'A planet and moon quiz with three levels, built from real planet data.', canonical='quiz.html'))
    # sky
    body = f'''<section class="blk"><h1>{bi("skyTitle")}</h1><div class="card" id="moonNow"></div></section>
<section class="blk"><h2>{bi("moonCalendar")}</h2><div class="row"><button class="btn" id="calPrev">‹ {bi("previousMonth")}</button><b id="calTitle"></b><button class="btn" id="calNext">{bi("nextMonth")} ›</button></div><div class="moons" id="calGrid"></div><div id="calPhases" style="margin-top:14px"></div><p class="note">{bi("moonCalendarNote")}</p></section>
<section class="blk"><h2>{bi("eventsTitle")}</h2><p class="sub">{bt("Meteor shower peaks for the next 12 months, with how bright the Moon will be on the peak night.", "अगले 12 महीनों में उल्कापात के चरम दिन, और उस रात चाँद कितना चमकीला होगा।")}</p><div class="grid" id="showers"></div></section>
<section class="blk callout"><b>{bt("Want it for your city?", "अपने शहर के लिए चाहिए?")}</b> {bt("The app adds moonrise and sunset for your city, which planets you can see, eclipses, a live star map and a compass planet finder, all offline.", "App में आपके शहर के लिए चाँद-सूरज के उगने-डूबने के समय, कौन-से ग्रह दिखेंगे, ग्रहण, live star map और compass से ग्रह ढूँढना है, सब ऑफ़लाइन।")} <a href="get.html">{bt("Get the app", "App पाएँ")}</a></section>'''
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
    cards = ''
    for c in sorted(CONS, key=lambda c: c['names'].get('en', c['latin'])):
        en = c['names'].get('en', c['latin']); hi = c['names'].get('hi', c['latin'])
        st = f'<p>{bi(stories[c["id"]])}</p>' if c['id'] in stories else ''
        cards += f'<div class="card" data-cons="{esc((en + " " + c["latin"] + " " + hi).lower())}">{cons_svg(c)}<h3>{bt(en, hi)}</h3><small>{c["latin"]}</small>{st}</div>'
    body = f'''<section class="blk"><h1>{bi("constellationsLabel")}</h1><p class="sub">{bt("89 constellations drawn as they appear in the sky (north is up). The app shows them live for your place and time.", "89 तारामंडल, जैसे आसमान में दिखते हैं (ऊपर उत्तर है)। App उन्हें आपकी जगह और समय के हिसाब से live दिखाता है।")}</p><div class="row"><input type="search" id="cq" placeholder="Orion, सप्तर्षि…" aria-label="Search"></div><div class="cons">{cards}</div></section>
<script>document.getElementById('cq').addEventListener('input',function(e){{var s=e.target.value.toLowerCase();document.querySelectorAll('[data-cons]').forEach(function(c){{c.classList.toggle('hide',!!s&&c.dataset.cons.indexOf(s)<0)}})}})</script>'''
    write('constellations.html', shell('Constellations', 'तारामंडल', 'cons', body, '89 constellations with line drawings and stories, from the Astryl star map.', canonical='constellations.html'))


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
    body = f'''<section class="blk"><h1>{bt("Get Astryl", "Astryl पाएँ")}</h1>
<p class="sub">{bt("Astryl is only on GitHub Releases. There is no Play Store or other store listing, so nobody else controls it.", "Astryl सिर्फ़ GitHub Releases पर है। Play Store या किसी और store पर नहीं, इसलिए इस पर किसी और का control नहीं।")}</p>
<div class="btns"><a class="btn primary dl-btn" href="{REPO}/releases/latest">⬇ {bt("Download the APK", "APK download करें")}</a><a class="btn" href="{REPO}/releases">{bt("All versions", "सभी versions")}</a></div><p class="note"><span class="ver"></span></p></section>
<section class="blk"><h2>{bt("Install", "Install कैसे करें")}</h2>
<ol class="steps">
<li>{bt("Download the APK from the button above on your phone.", "ऊपर के button से अपने फ़ोन में APK download करें।")}</li>
<li>{bt("Open it. If Android asks, allow your browser (or file manager) to install apps.", "उसे खोलें। Android पूछे तो अपने browser (या file manager) को apps install करने दें।")}</li>
<li>{bt("Tap Install. Astryl updates itself later: Settings → Check for updates.", "Install दबाएँ। आगे Astryl खुद update होता है: Settings → Check for updates।")}</li>
</ol></section>
<section class="blk"><div class="callout"><h3>{bt("Coming from Heliora (before version 1.17.5)?", "Heliora (version 1.17.5 से पहले) से आ रहे हैं?")}</h3>
<p>{bt("Astryl 1.17.5 has a new app id, so it installs next to the old Heliora instead of replacing it. Your data moves in a minute:", "Astryl 1.17.5 का app id नया है, इसलिए यह पुराने Heliora की जगह नहीं लेता, उसके बग़ल में install होता है। आपका data एक मिनट में आ जाता है:")}</p>
<ol><li>{bt("In the old Heliora: Settings → Backup → Save a backup.", "पुराने Heliora में: Settings → Backup → Save a backup।")}</li><li>{bt("In Astryl: Settings → Backup → Restore a backup, pick that file.", "Astryl में: Settings → Backup → Restore a backup, वही file चुनें।")}</li><li>{bt("Uninstall the old Heliora.", "पुराना Heliora uninstall कर दें।")}</li></ol></div></section>
<section class="blk"><h2>{bt("Open source", "Open source")}</h2><p>{bt("Astryl is free software under the AGPL-3.0 licence (versions up to 1.17.3 were MIT). You can read, change and share the code.", "Astryl AGPL-3.0 licence के तहत मुफ़्त software है (1.17.3 तक के versions MIT थे)। आप code पढ़ सकते हैं, बदल सकते हैं और बाँट सकते हैं।")}</p>
<div class="btns"><a class="btn" href="{REPO}">{bt("Source code", "Source code")}</a><a class="btn" href="{REPO}/blob/main/LICENSE">AGPL-3.0</a><a class="btn" href="{REPO}/issues">{bt("Report a problem", "समस्या बताएँ")}</a></div></section>'''
    write('get.html', shell('Download Astryl', 'Astryl download', 'get', body, 'Download the Astryl APK from GitHub Releases, install steps and how to move from Heliora.', canonical='get.html'))


def privacy_page():
    def li(en, hi):
        return f'<li>{bt(en, hi)}</li>'
    def tr(a_en, a_hi, b_en, b_hi, c_en, c_hi):
        return f'<tr><td>{bt(a_en, a_hi)}</td><td>{bt(b_en, b_hi)}</td><td>{bt(c_en, c_hi)}</td></tr>'
    body = f"""<section class="blk policy" style="max-width:800px"><h1>{bt("Privacy Policy", "Privacy Policy")}</h1>
<p class="note">{bt("Last updated 9 November 2026 · applies to the Astryl app (version 1.19.0 and later; account features from 1.18.0) and to astryl.space", "आख़िरी बार 9 नवंबर 2026 को बदली गई · Astryl app (version 1.19.0 और बाद के; खाते की सुविधाएँ 1.18.0 से) और astryl.space पर लागू")}</p>
<p class="sub">{bt("Short version: no ads, nothing is sold. The app works without an account. If you make one, or if the app crashes, we keep only what is listed below, you choose every optional switch, and you can delete everything yourself at any time.", "छोटे में: कोई विज्ञापन नहीं, कुछ बेचा नहीं जाता। App खाते के बिना चलता है। खाता बनाएँ, या app crash हो, तो हम सिर्फ़ वही रखते हैं जो नीचे लिखा है, हर वैकल्पिक switch आप चुनते हैं, और आप कभी भी सब कुछ ख़ुद मिटा सकते हैं।")}</p>

<h2>{bt("1. Who is responsible", "1. ज़िम्मेदार कौन है")}</h2>
<p>{bt("Astryl is a free, open-source project (AGPL-3.0). For questions about your data, write to", "Astryl एक मुफ़्त, open-source project है (AGPL-3.0)। अपने data के बारे में सवाल हों तो यहाँ लिखें:")} <a href="mailto:contact@astryl.space">contact@astryl.space</a>.</p>

<h2>{bt("2. Without an account", "2. खाते के बिना")}</h2>
<ul>
{li("Planet facts, the Moon, planet positions, eclipses, the star map and the quiz are worked out on your phone or in your browser. No internet is needed for the app.", "ग्रहों के तथ्य, चाँद, ग्रहों की स्थिति, ग्रहण, star map और quiz आपके फ़ोन या browser में ही निकाले जाते हैं। App के लिए internet ज़रूरी नहीं।")}
{li("Your city, birth date, favourites, quiz scores and settings are saved on your phone. The Backup file is made by you and goes only where you send it.", "आपका शहर, जन्मतिथि, favourites, quiz scores और settings आपके फ़ोन में save होते हैं। Backup file आप बनाते हैं और वह वहीं जाती है जहाँ आप भेजें।")}
{li("Update check: each time the app opens, it asks GitHub for the newest release and, if there is one, offers it first (you can tap Skip). GitHub sees your IP address, like in any web request.", "Update check: app हर बार खुलने पर GitHub से सबसे नया release पूछता है और नया हो तो सबसे पहले वही दिखाता है (आप Skip दबा सकते हैं)। जैसे हर web request में होता है, GitHub आपका IP address देख सकता है।")}
{li("Online features are off until you turn them on. Then the app downloads orbit data, the rocket launch list and space news from public services (wheretheiss.at, Celestrak, Launch Library 2, Spaceflight News API), which can see your IP address. Nothing about you is sent.", "Online features आप चालू करें तभी चलते हैं। तब app public services (wheretheiss.at, Celestrak, Launch Library 2, Spaceflight News API) से orbit data, rocket launch की list और space news लेता है, जो आपका IP address देख सकती हैं। आपके बारे में कुछ नहीं भेजा जाता।")}
{li("“Use my location” in the city list asks Android for your approximate location, once, and uses it only on your phone to work out the sky. Nothing is sent for this.", "शहर की list में “मेरी location इस्तेमाल करें” Android से आपकी अनुमानित location एक बार माँगता है और उसे सिर्फ़ आपके फ़ोन पर आसमान निकालने में इस्तेमाल करता है। इसके लिए कुछ नहीं भेजा जाता।")}
</ul>

<h2>{bt("3. The optional account", "3. वैकल्पिक खाता")}</h2>
<p>{bt("The account is for one thing: keeping your favourites, scores and settings in step between the app and this website. It needs a username and a password. No e-mail address, name or phone number is asked for. You can skip it with “Skip now” and use everything.", "खाते का एक ही काम है: आपके favourites, scores और settings को app और इस website के बीच एक जैसा रखना। इसके लिए username और password चाहिए। e-mail, नाम या फ़ोन नंबर नहीं माँगा जाता। “अभी छोड़ें” दबाकर आप खाते के बिना सब कुछ इस्तेमाल कर सकते हैं।")}</p>
<table><tr><th>{bt("What we store", "हम क्या रखते हैं")}</th><th>{bt("Why", "क्यों")}</th><th>{bt("For how long", "कब तक")}</th></tr>
{tr("Your username and a hash of your password (the password itself is never stored or visible to us)", "आपका username और password का hash (password ख़ुद कभी store नहीं होता और हमें दिखता नहीं)", "To log you in", "आपको log in कराने के लिए", "Until you delete the account", "जब तक आप खाता नहीं मिटाते")}
{tr("A hash of your recovery code, how many times it can still be used, failed tries", "Recovery code का hash, वह कितनी बार और चल सकता है, ग़लत कोशिशें", "So you can set a new password if you forget it", "ताकि password भूलने पर आप नया लगा सकें", "Until you delete the account", "जब तक आप खाता नहीं मिटाते")}
{tr("The date you accepted this policy and its version, the date you joined, the date you last used the account", "आपने यह policy कब मानी और उसका version, आप कब जुड़े, खाता आख़िरी बार कब इस्तेमाल हुआ", "To show your consent and run the account", "आपकी सहमति दिखाने और खाता चलाने के लिए", "Until you delete the account", "जब तक आप खाता नहीं मिटाते")}
{tr("If sync is on: favourites, quiz scores, language, theme, text size, city (never a GPS place), birth date and the daily sky note setting", "Sync चालू हो तो: favourites, quiz scores, भाषा, theme, text size, शहर (GPS वाली जगह कभी नहीं), जन्मतिथि और रोज़ के आसमान वाले note की setting", "To keep the app and the website in step", "App और website को एक जैसा रखने के लिए", "Until you delete the account or switch sync off and delete it", "जब तक आप खाता नहीं मिटाते")}
</table>
<p>{bt("Your birth date is stored only if you have entered it in the app and sync is on. Turn sync off in Settings → Account to stop this.", "आपकी जन्मतिथि तभी रखी जाती है जब आपने उसे app में लिखा हो और sync चालू हो। इसे रोकने के लिए Settings → Account में sync बंद करें।")}</p>
<p>{bt("The recovery code is shown once when you make the account. Keep it safe: it is the only way back in if you forget your password, it works 3 times, and nobody (including us) can read it back. If you lose both the password and the code, the account cannot be recovered.", "Recovery code खाता बनाते समय एक बार दिखता है। इसे सुरक्षित रखें: password भूलने पर वापस आने का यही अकेला रास्ता है, यह 3 बार चलता है, और इसे कोई (हम भी) वापस नहीं पढ़ सकता। Password और code दोनों खो जाएँ तो खाता वापस नहीं मिल सकता।")}</p>

<h2>{bt("4. Optional switches (all off until you turn them on)", "4. वैकल्पिक switches (आप चालू करें तभी, वरना सब बंद)")}</h2>
<ul>
{li("Count me as an active user: the app sends a random number made on your phone, at most once every few hours, with no username. It is not linked to you or your account. It is kept for 90 days and is used only to show how many people use Astryl.", "मुझे active user में गिनें: app आपके फ़ोन पर बना एक random number भेजता है, कुछ घंटों में ज़्यादा से ज़्यादा एक बार, बिना username के। यह आपसे या आपके खाते से जुड़ा नहीं होता। यह 90 दिन रखा जाता है और सिर्फ़ यह दिखाने में लगता है कि Astryl कितने लोग इस्तेमाल करते हैं।")}
{li("Share my country: the country from your phone's (or browser's) language and region setting, kept with that random number and shown only as a count per country. It is not worked out from your IP address or your location.", "मेरा देश बताएँ: आपके फ़ोन (या browser) की भाषा और region setting वाला देश, उसी random number के साथ रखा जाता है और सिर्फ़ हर देश की गिनती के रूप में दिखता है। यह आपके IP address या location से नहीं निकाला जाता।")}
{li("Share my approximate location (app only, needs an account): after you allow Android's location permission, the app sends Android's approximate location (a few kilometres) when you open it, at most once a day. The server rounds it to about 10 km and keeps only the latest place with its date, tied to your account. There is no location in the background. Switch it off and the place is deleted from the server.", "मेरी अनुमानित location बताएँ (सिर्फ़ app में, खाता चाहिए): Android की location अनुमति देने के बाद app आपके app खोलने पर Android की अनुमानित location (कुछ किलोमीटर तक) भेजता है, दिन में ज़्यादा से ज़्यादा एक बार। Server उसे लगभग 10 किमी में गोल करके सिर्फ़ सबसे ताज़ा जगह तारीख़ के साथ, आपके खाते से जुड़ी रखता है। Background में कोई location नहीं ली जाती। Switch बंद करने पर वह जगह server से मिट जाती है।")}
</ul>

<h2>{bt("5. Crash reports (on by default, you can switch them off)", "5. Crash reports (डिफ़ॉल्ट रूप से चालू, आप बंद कर सकते हैं)")}</h2>
<ul>
{li("If the app crashes, it sends one small report to the Astryl server: the error text, the technical trace of where it happened, the app version, the Android version string and the app language. It contains no name, no account, no device id, no IP address (the server keeps none in readable form) and no location.", "App crash हो तो वह Astryl server को एक छोटा report भेजता है: error का text, कहाँ हुआ उसका technical trace, app version, Android version string और app की भाषा। उसमें कोई नाम, खाता, device id, IP address (server उसे पढ़ने लायक़ रूप में नहीं रखता) या location नहीं होती।")}
{li("It is used only to find and fix bugs, and is kept for 90 days. If the phone is offline, the report waits on the phone and is sent later.", "इसका इस्तेमाल सिर्फ़ bugs ढूँढने और ठीक करने के लिए होता है, और यह 90 दिन रखा जाता है। फ़ोन offline हो तो report फ़ोन पर रुका रहता है और बाद में भेजा जाता है।")}
{li("Turn it off in Settings → Send crash reports. Nothing is then kept or sent, and reports still waiting on the phone are not sent.", "इसे Settings → Crash reports भेजें में बंद करें। तब कुछ रखा या भेजा नहीं जाता, और फ़ोन पर रुके reports भी नहीं भेजे जाते।")}
</ul>

<h2>{bt("6. Where the data is kept and who handles it", "6. Data कहाँ रखा जाता है और कौन सँभालता है")}</h2>
<p>{bt("Account data is stored with Supabase (database and login service), on servers in Singapore. The app and this website reach it only through one function that checks who is asking; the tables themselves cannot be read from outside. To limit abuse, a hashed (not readable) key and a counter are kept for up to 2 days; no IP address is stored in readable form. This website is hosted on GitHub Pages, and downloads and the update check use GitHub; both follow GitHub's own privacy statement. We do not sell data, show ads, use analytics or trackers, or share data with anyone else.", "खाते का data Supabase (database और login service) के पास, सिंगापुर के servers पर, रखा जाता है। App और यह website उस तक सिर्फ़ एक function से पहुँचते हैं, जो जाँचता है कि कौन माँग रहा है; tables को बाहर से पढ़ा नहीं जा सकता। दुरुपयोग रोकने के लिए hash किया हुआ (पढ़ने लायक़ नहीं) key और एक counter ज़्यादा से ज़्यादा 2 दिन रखा जाता है; IP address पढ़ने लायक़ रूप में नहीं रखा जाता। यह website GitHub Pages पर है, और downloads व update check GitHub से होते हैं; दोनों GitHub की अपनी privacy policy के हिसाब से चलते हैं। हम data बेचते नहीं, विज्ञापन नहीं दिखाते, analytics या trackers इस्तेमाल नहीं करते, और किसी और से data साझा नहीं करते।")}</p>

<h2>{bt("7. This website", "7. यह website")}</h2>
<ul>
{li("No cookies, no analytics, no ads, no third-party scripts or fonts. Everything is calculated in your browser.", "कोई cookies, analytics, विज्ञापन, बाहरी scripts या fonts नहीं। सब कुछ आपके browser में calculate होता है।")}
{li("Your browser remembers language, theme and quiz scores in local storage on your own device. If you log in, a login token is kept there too, until you log out.", "आपका browser भाषा, theme और quiz scores आपके अपने device की local storage में याद रखता है। Log in करने पर वहीं एक login token भी रहता है, log out करने तक।")}
{li("The home page asks the Astryl server for the public counter (accounts and active users) and asks GitHub for the download count.", "Home page Astryl server से public counter (खाते और active users) और GitHub से download की गिनती माँगता है।")}
</ul>

<h2>{bt("8. Your choices and rights", "8. आपके विकल्प और अधिकार")}</h2>
<ul>
{li("Delete your account at any time: app → Settings → Account → Delete my account, or on the Account page of this website. Your account and everything stored for it online are removed straight away. The data on your phone stays.", "खाता कभी भी मिटाएँ: app → Settings → Account → मेरा खाता मिटाएँ, या इस website के Account page पर। आपका खाता और उससे जुड़ा सारा online data तुरंत मिट जाता है। आपके फ़ोन का data रहता है।")}
{li("Turn any optional switch off at any time. This withdraws your consent for that part; the data it created is removed or stops growing.", "कोई भी वैकल्पिक switch कभी भी बंद करें। इससे उस हिस्से की सहमति वापस हो जाती है; उससे बना data मिट जाता है या बढ़ना रुक जाता है।")}
{li("Log out to stop syncing on a device. Uninstalling the app removes its data from the phone.", "किसी device पर sync रोकने के लिए log out करें। App uninstall करने पर उसका data फ़ोन से हट जाता है।")}
{li("To ask what is stored about you, to get a copy, or to have something corrected or removed, write to contact@astryl.space and tell us your username. Depending on where you live you may also have the right to complain to your data protection authority.", "आपके बारे में क्या रखा है यह पूछने, उसकी copy लेने, या कुछ सुधारने/हटाने के लिए contact@astryl.space पर लिखें और अपना username बताएँ। आप जहाँ रहते हैं उसके हिसाब से आपको अपनी data protection authority से शिकायत करने का अधिकार भी हो सकता है।")}
</ul>

<h2>{bt("9. Children", "9. बच्चे")}</h2>
<p>{bt("Astryl is for everyone who likes space. If you are under 16, please ask a parent or guardian before making an account. The app is fully usable without one.", "Astryl उन सब के लिए है जिन्हें अंतरिक्ष पसंद है। अगर आप 16 साल से कम के हैं, तो खाता बनाने से पहले माता-पिता या अभिभावक से पूछ लें। App खाते के बिना भी पूरा इस्तेमाल हो सकता है।")}</p>

<h2>{bt("10. Changes", "10. बदलाव")}</h2>
<p>{bt("If this policy changes in a way that matters, the new version is published on this page and in the app's release notes, and the app asks again before you make a new account. The full source code, including the server code in the folder", "अगर यह policy किसी ज़रूरी तरह से बदली, तो नया version इसी page और app के release notes में छपेगा, और नया खाता बनाने से पहले app फिर पूछेगा। पूरा source code, server का code भी (folder")} <a href="{REPO}/tree/main/supabase">supabase/</a>{bt(", is open for anyone to read.", ") सबके पढ़ने के लिए खुला है।")}</p>
</section>"""
    write('privacy.html', shell('Privacy Policy', 'Privacy Policy', 'get', body, 'Astryl Privacy Policy: no ads. An account (username and password only) is optional, crash reports can be switched off; what is stored, why, and how to delete it.', canonical='privacy.html'))


def account_page():
    body = f"""<section class="blk" style="max-width:640px"><h1>{bt("Astryl account", "Astryl खाता")}</h1>
<div id="acct"><noscript><p>{bt("The account page needs JavaScript.", "Account page को JavaScript चाहिए।")}</noscript></p></div>
<p class="note"><a href="privacy.html">{bt("Privacy Policy", "Privacy Policy")}</a></p></section>"""
    write('account.html', shell('Account', 'खाता', 'account', body, 'Create an optional Astryl account with a username and password, and keep your favourites, quiz scores and settings in step between the app and this website.', canonical='account.html'))


def not_found():
    body = f'''<section class="blk" style="text-align:center;padding:80px 0"><h1>404</h1><p class="sub" style="margin:auto">{bt("This page drifted off into space.", "यह page अंतरिक्ष में खो गया।")}</p><p><a class="btn primary" href="/index.html">{bt("Back home", "होम पर लौटें")}</a></p></section>'''
    write('404.html', shell('Page not found', 'Page नहीं मिला', 'home', body, 'Page not found.', scripts=False).replace('href="index.html"', 'href="/index.html"').replace('href="assets/', 'href="/assets/'))


def data_js():
    data = dict(
        bodies=[{k: v for k, v in b.items()} for b in BODIES], orbits=ORBITS, factIds=FACT_IDS, milestones=MILESTONES, meteors=METEORS,
        spacecraft=CRAFT, L=L)
    for b in data['bodies']:
        b['color'] = b['color']
    return 'window.ASTRYL=' + json.dumps(data, ensure_ascii=False, separators=(',', ':')) + ';'


def main():
    # Only the generated parts are rebuilt; other files in site/ (images, the
    # favicon) are left alone.
    for sub in ('assets', 'body', 'fonts'):
        if (OUT / sub).exists():
            shutil.rmtree(OUT / sub)
    for old in OUT.glob('*.html'):
        old.unlink()
    (OUT / 'assets').mkdir(parents=True, exist_ok=True)
    shutil.copy(SRC / 'style.css', OUT / 'assets/style.css')
    shutil.copy(SRC / 'app.js', OUT / 'assets/app.js')
    shutil.copy(SRC / 'account.js', OUT / 'assets/account.js')
    shutil.copy(SRC / 'cosmos.js', OUT / 'assets/cosmos.js')
    (OUT / 'assets/data.js').write_text(data_js(), encoding='utf-8')
    (OUT / 'assets/icon.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg" viewBox="-60 -60 120 120"><rect x="-60" y="-60" width="120" height="120" rx="26" fill="#0a0d1a"/><circle r="30" fill="#f2b84b"/><ellipse rx="50" ry="15" fill="none" stroke="#7aa2ff" stroke-width="6" transform="rotate(-24)"/><circle cx="40" cy="-20" r="6" fill="#eef0fb"/></svg>', encoding='utf-8')
    (OUT / 'fonts').mkdir()
    for f in ('DMSans-Regular.ttf', 'DMSans-Medium.ttf', 'DMSans-Bold.ttf', 'SpaceGrotesk-Medium.ttf', 'SpaceGrotesk-Bold.ttf', 'OFL-DMSans.txt', 'OFL-SpaceGrotesk.txt'):
        shutil.copy(ROOT / 'assets/fonts' / f, OUT / 'fonts' / f)
    (OUT / 'CNAME').write_text('astryl.space\n', encoding='utf-8')
    (OUT / '.nojekyll').write_text('', encoding='utf-8')
    (OUT / 'robots.txt').write_text(f'User-agent: *\nAllow: /\nSitemap: {SITE}/sitemap.xml\n', encoding='utf-8')
    for i, b in enumerate(BODIES):
        body_page(b, i)
    index_page(); planets_page(); simple_pages(); maps_page(); get_page(); privacy_page(); account_page(); not_found()
    urls = ['', 'planets.html', 'solar-system.html', 'compare.html', 'you.html', 'quiz.html', 'sky.html', 'constellations.html', 'maps.html', 'missions.html', 'spacecraft.html', 'get.html', 'privacy.html', 'account.html'] + [f'body/{b["id"]}.html' for b in BODIES]
    (OUT / 'sitemap.xml').write_text('<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' + ''.join(f'<url><loc>{SITE}/{u}</loc></url>\n' for u in urls) + '</urlset>\n', encoding='utf-8')
    print('pages:', len(list(OUT.rglob('*.html'))))


if __name__ == '__main__':
    main()
