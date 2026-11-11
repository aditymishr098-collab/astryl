"""The constellations page: all 88 IAU constellations drawn with a true sky projection, star sizes by brightness,
the brightest star, when to see each one in the evening, whether it can be seen from India, and what to find in it."""
import math
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# Serpens is one constellation in two parts. The app's catalogue lists its tail twice; the head is added here.
SERPENS_CAPUT = [237.405, -3.430, 237.704, 4.478, 236.067, 6.426, 233.701, 10.539, 236.547, 15.422, 235.388, 19.670, 237.185, 18.142, 239.113, 15.662, 236.547, 15.422]

ZODIAC = {'Ari', 'Tau', 'Gem', 'Cnc', 'Leo', 'Vir', 'Lib', 'Sco', 'Sgr', 'Cap', 'Aqr', 'Psc', 'Oph'}
MONTHS_EN = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
MONTHS_HI = ['जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर']
DSO_KIND = [('Star cluster', 'तारा समूह'), ('Galaxy', 'Galaxy'), ('Nebula', 'नीहारिका')]


def load():
    text = (ROOT / 'lib/data/sky_catalog.dart').read_text(encoding='utf-8')
    stars = [(float(a), float(b), float(c), d) for a, b, c, d in re.findall(r"StarData\(([-\d.]+), ([-\d.]+), ([-\d.]+)(?:, '([^']*)')?\)", text)]
    dsos = [dict(id=a, name=b.replace("\\'", "'"), kind=int(c), mag=float(d), ra=float(e), dec=float(f), con=g)
            for a, b, c, d, e, f, g in re.findall(r"DeepSkyData\('(\w+)', '((?:[^'\\]|\\.)*)', (\d), ([-\d.]+), ([-\d.]+), ([-\d.]+), '(\w+)'\)", text)]
    return stars, dsos


def merge_serpens(cons):
    out, seen = [], False
    for c in cons:
        if c['id'] == 'Ser':
            if seen:
                continue
            seen = True
            c = dict(c, lines=c['lines'] + [SERPENS_CAPUT], ra=258.0, dec=5.0)
        out.append(c)
    return out


def _unit(ra, dec):
    a, d = math.radians(ra), math.radians(dec)
    return (math.cos(d) * math.cos(a), math.cos(d) * math.sin(a), math.sin(d))


def centre(points):
    x = sum(_unit(r, d)[0] for r, d in points)
    y = sum(_unit(r, d)[1] for r, d in points)
    z = sum(_unit(r, d)[2] for r, d in points)
    n = math.sqrt(x * x + y * y + z * z) or 1
    return math.degrees(math.atan2(y, x)) % 360, math.degrees(math.asin(z / n))


def sep(a1, d1, a2, d2):
    u, v = _unit(a1, d1), _unit(a2, d2)
    return math.degrees(math.acos(max(-1.0, min(1.0, u[0] * v[0] + u[1] * v[1] + u[2] * v[2]))))


def gnomonic(ra, dec, ra0, dec0):
    """Tangent-plane projection as seen from inside the sky: east to the left, north up."""
    a, d, a0, d0 = map(math.radians, (ra, dec, ra0, dec0))
    cosc = math.sin(d0) * math.sin(d) + math.cos(d0) * math.cos(d) * math.cos(a - a0)
    x = math.cos(d) * math.sin(a - a0) / cosc
    y = (math.cos(d0) * math.sin(d) - math.sin(d0) * math.cos(d) * math.cos(a - a0)) / cosc
    return -x, -y


def info(c, stars):
    pts = [(seg[k], seg[k + 1]) for seg in c['lines'] for k in range(0, len(seg) - 1, 2)]
    ra0, dec0 = centre(pts)
    # stars of the figure, matched to the catalogue for brightness and names
    fig = []
    for r, d in pts:
        best = min(stars, key=lambda s: sep(r, d, s[0], s[1]))
        fig.append(best if sep(r, d, best[0], best[1]) < 0.3 else (r, d, 4.5, ''))
    bright = min(fig, key=lambda s: s[2])
    return ra0, dec0, pts, fig, bright


def svg(c, stars):
    ra0, dec0, pts, fig, bright = info(c, stars)
    xy = [gnomonic(r, d, ra0, dec0) for r, d in pts]
    xs, ys = [p[0] for p in xy], [p[1] for p in xy]
    w, h = (max(xs) - min(xs)) or 0.01, (max(ys) - min(ys)) or 0.01
    W, H, pad = 320, 220, 26
    scale = min((W - 2 * pad) / w, (H - 2 * pad) / h)
    cx, cy = (min(xs) + max(xs)) / 2, (min(ys) + max(ys)) / 2

    def to(r, d):
        x, y = gnomonic(r, d, ra0, dec0)
        return W / 2 + (x - cx) * scale, H / 2 + (y - cy) * scale

    def size(mag):
        return max(1.8, min(7.0, 6.0 - 1.0 * mag))

    radius = max(sep(ra0, dec0, r, d) for r, d in pts) * 1.45 + 2
    s = f'<svg viewBox="0 0 {W} {H}" role="img" aria-label="{c["latin"]}">'
    # background stars around the figure
    for r, d, m, _ in stars:
        if m < 5.2 and sep(ra0, dec0, r, d) < radius:
            x, y = to(r, d)
            if 2 < x < W - 2 and 2 < y < H - 2:
                s += f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{size(m) * 0.45:.2f}" fill="#b4c2e6" opacity=".55"/>'
    for seg in c['lines']:
        p = [to(seg[k], seg[k + 1]) for k in range(0, len(seg) - 1, 2)]
        s += '<polyline fill="none" stroke="#7aa2ff" stroke-width="2" stroke-linejoin="round" stroke-linecap="round" opacity=".85" points="' + ' '.join(f'{x:.1f},{y:.1f}' for x, y in p) + '"/>'
    done = set()
    for r, d, m, _ in fig:
        key = (round(r, 2), round(d, 2))
        if key in done:
            continue
        done.add(key)
        x, y = to(r, d)
        s += f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{size(m):.2f}" fill="#f2f4ff"/>'
    if bright[3]:
        x, y = to(bright[0], bright[1])
        anchor = 'end' if x > W * 0.7 else 'start'
        dx = -9 if anchor == 'end' else 9
        s += f'<text x="{x + dx:.1f}" y="{y - 9:.1f}" fill="#ffd27a" font-size="15" font-family="DM Sans,system-ui,sans-serif" text-anchor="{anchor}">{bright[3]}</text>'
    return s + '</svg>'


def best_month(ra0):
    """The month when the constellation is highest at about 9 pm."""
    # The Sun is at right ascension 0h around 21 March; a place is due south at 9 pm
    # when its right ascension is the Sun's plus 9 hours.
    days = ((ra0 / 15 - 9) % 24) / 24 * 365.25
    return int((79 + days) % 365.25 // 30.44) % 12


def build_page(h, cons_raw, stories):
    bt, bi, esc, write, shell = h['bt'], h['bi'], h['esc'], h['write'], h['shell']
    stars, dsos = load()
    cons = merge_serpens(cons_raw)
    assert len(cons) == 88, len(cons)
    cards = ''
    for c in sorted(cons, key=lambda c: c['names'].get('en', c['latin'])):
        en = c['names'].get('en', c['latin'])
        hi_ = c['names'].get('hi', c['latin'])
        ra0, dec0, pts, fig, bright = info(c, stars)
        m = best_month(ra0)
        # from Delhi (28.6° N) the highest point is 90 - |28.6 - dec|
        top = 90 - abs(28.6 - dec0)
        india = ('whole', '✅', 'Seen well from India', 'भारत से अच्छा दिखता है') if top > 25 else (('low', '🟡', 'Low in the south from India', 'भारत से दक्षिण में नीचे') if top > 5 else ('no', '❌', 'Not seen from most of India', 'भारत के ज़्यादातर हिस्से से नहीं दिखता'))
        hemi = 'north' if dec0 > 15 else ('south' if dec0 < -15 else 'equator')
        tags = ' '.join([hemi, 'zodiac' if c['id'] in ZODIAC else '', 'india' if india[0] == 'whole' else ''])
        st = f'<p class="story">{bi(stories[c["id"]])}</p>' if c['id'] in stories else ''
        bstar = f'<li>⭐ {bt("Brightest star", "सबसे चमकीला तारा")}: <b>{esc(bright[3]) if bright[3] else "–"}</b> ({bright[2]:.1f})</li>' if bright[3] else ''
        objs = [d for d in dsos if d['con'] == c['id']]
        olist = f'<li>🔭 {", ".join(esc(d["id"] + " " + d["name"]) for d in objs[:3])}</li>' if objs else ''
        cards += (f'<div class="card con" data-tags="{tags}" data-cons="{esc((en + " " + c["latin"] + " " + hi_ + " " + c["id"]).lower())}">{svg(c, stars)}'
                  f'<h3>{bt(en, hi_)}</h3><small>{c["latin"]}{" · " + bt("Zodiac", "राशि-पथ") if c["id"] in ZODIAC else ""}</small>'
                  f'<ul class="conmeta">{bstar}<li>🗓️ {bt("Best in the evening", "शाम को सबसे अच्छा")}: <b>{bt(MONTHS_EN[m], MONTHS_HI[m])}</b></li><li>{india[1]} {bt(india[2], india[3])}</li>{olist}</ul>{st}</div>')
    chips = ''.join(f'<button type="button" class="{"on" if k == "all" else ""}" data-f="{k}">{bt(e, hh)}</button>' for k, e, hh in [
        ('all', 'All 88', 'सभी 88'), ('india', 'Seen well from India', 'भारत से दिखने वाले'), ('north', 'Northern sky', 'उत्तरी आसमान'), ('south', 'Southern sky', 'दक्षिणी आसमान'), ('zodiac', 'Zodiac', 'राशि-पथ')])
    body = f'''<section class="blk"><h1>{bi("constellationsLabel")}</h1><p class="sub">{bt("All 88 constellations, drawn as you see them when you face them in the sky: north up and east to the left. Bigger dots are brighter stars; faint dots are the stars around them.", "सभी 88 तारामंडल, वैसे ही बने जैसे आसमान में उनकी तरफ़ देखने पर दिखते हैं: ऊपर उत्तर और बाईं ओर पूर्व। बड़े बिंदु चमकीले तारे हैं; हल्के बिंदु आसपास के तारे।")}</p>
<div class="row"><input type="search" id="cq" placeholder="Orion, सप्तर्षि…" aria-label="Search"></div><div class="umchips" id="cf">{chips}</div><p class="note" id="cn"></p><div class="cons">{cards}</div>
<p class="note">{bt("“Best in the evening” is the month when it is highest at about 9 pm. “Seen from India” is worked out for Delhi; from South India a little more of the southern sky is visible. The app shows the sky live for your place and time.", "“शाम को सबसे अच्छा” वह महीना है जब यह रात 9 बजे के आसपास सबसे ऊँचा होता है। “भारत से” दिल्ली के लिए निकाला गया है; दक्षिण भारत से दक्षिणी आसमान थोड़ा ज़्यादा दिखता है। App आपकी जगह और समय के हिसाब से live आसमान दिखाता है।")}</p></section>
<script>(function(){{var q=document.getElementById('cq'),f='all',cards=document.querySelectorAll('[data-cons]'),cn=document.getElementById('cn');function run(){{var s=q.value.toLowerCase(),n=0;cards.forEach(function(c){{var ok=(!s||c.dataset.cons.indexOf(s)>=0)&&(f==='all'||(' '+c.dataset.tags+' ').indexOf(' '+f+' ')>=0);c.classList.toggle('hide',!ok);if(ok)n++}});cn.textContent=n+' / 88'}}q.addEventListener('input',run);document.getElementById('cf').addEventListener('click',function(e){{var b=e.target.closest('button');if(!b)return;f=b.dataset.f;document.querySelectorAll('#cf button').forEach(function(x){{x.classList.toggle('on',x===b)}});run()}});run()}})();</script>'''
    write('constellations.html', shell('Constellations', 'तारामंडल', 'cons', body, 'All 88 constellations with true-to-the-sky drawings, the brightest star, the best month to see each one and whether it can be seen from India. In English and Hindi.', canonical='constellations.html'))
