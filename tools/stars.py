"""The Stars section of astryl.space: how stars are born, live and die.

Numbers are from NASA, ESA, ESO and published measurements. Where astronomers still disagree
(for example the exact size of Betelgeuse), the page gives a range or says "about".
"""
import json
import math

from dskit import Kit, Section, article_ld

# ---------- stars used on several pages ----------
# id, English, Hindi, distance in light-years, surface temperature K, radius (Sun = 1), luminosity (Sun = 1),
# mass (Sun = 1), type en, type hi, note en, note hi
STARS = [
    ('sun', 'The Sun', 'सूर्य', 0.0000158, 5772, 1, 1, 1, 'Yellow dwarf (G2)', 'पीला बौना तारा (G2)',
     'Our own star, 4.6 billion years old and about halfway through its life.', 'हमारा अपना तारा, 4.6 अरब साल पुराना और अपनी उम्र के लगभग आधे रास्ते पर।'),
    ('proxima', 'Proxima Centauri', 'Proxima Centauri', 4.24, 3040, 0.15, 0.0017, 0.12, 'Red dwarf (M5.5)', 'लाल बौना तारा (M5.5)',
     'The nearest star to the Sun. Too faint to see without a telescope, but it has at least one planet.', 'सूर्य के सबसे पास का तारा। बिना telescope के दिखने के लिए बहुत धुँधला, पर इसके पास कम से कम एक ग्रह है।'),
    ('sirius', 'Sirius', 'लुब्धक (Sirius)', 8.6, 9940, 1.71, 25, 2.06, 'White main-sequence star (A1)', 'सफ़ेद main-sequence तारा (A1)',
     'The brightest star in the night sky. Its tiny partner, Sirius B, is a white dwarf.', 'रात के आसमान का सबसे चमकीला तारा। इसका नन्हा साथी, Sirius B, एक white dwarf है।'),
    ('siriusb', 'Sirius B', 'Sirius B', 8.6, 25000, 0.0084, 0.056, 1.02, 'White dwarf', 'White dwarf',
     'As heavy as the Sun but about the size of Earth: the leftover core of a star.', 'सूर्य जितना भारी पर लगभग पृथ्वी जितना बड़ा: एक तारे का बचा हुआ केंद्र।'),
    ('vega', 'Vega', 'अभिजित (Vega)', 25, 9600, 2.5, 40, 2.1, 'White main-sequence star (A0)', 'सफ़ेद main-sequence तारा (A0)',
     'A bright summer star. In about 12,000 years it will be close to the north pole of the sky.', 'गर्मियों का एक चमकीला तारा। लगभग 12,000 साल में यह आसमान के उत्तरी ध्रुव के पास होगा।'),
    ('aldebaran', 'Aldebaran', 'रोहिणी (Aldebaran)', 65, 3900, 44, 440, 1.2, 'Orange giant (K5)', 'नारंगी दानव तारा (K5)',
     'The red eye of Taurus. A star a bit heavier than the Sun that has already become a giant.', 'वृषभ की लाल आँख। सूर्य से थोड़ा भारी तारा जो पहले ही दानव बन चुका है।'),
    ('polaris', 'Polaris', 'ध्रुव तारा (Polaris)', 433, 6000, 46, 1260, 5.4, 'Yellow supergiant (F7)', 'पीला महादानव (F7)',
     'The Pole Star. It stays almost still while the whole sky turns around it.', 'ध्रुव तारा। पूरा आसमान इसके चारों ओर घूमता है, पर यह लगभग एक जगह रहता है।'),
    ('antares', 'Antares', 'ज्येष्ठा (Antares)', 550, 3600, 680, 75000, 12, 'Red supergiant (M1)', 'लाल महादानव (M1)',
     'The red heart of Scorpius. Put in place of the Sun, it would reach past Mars.', 'वृश्चिक का लाल दिल। सूर्य की जगह रखें तो यह मंगल से भी आगे तक फैल जाएगा।'),
    ('betelgeuse', 'Betelgeuse', 'आर्द्रा (Betelgeuse)', 550, 3600, 760, 100000, 17, 'Red supergiant (M1)', 'लाल महादानव (M1)',
     'The red shoulder of Orion. It will explode as a supernova, probably within the next 100,000 years.', 'मृग (Orion) का लाल कंधा। यह supernova बनकर फटेगा, शायद अगले 1,00,000 साल के अंदर।'),
    ('rigel', 'Rigel', 'Rigel', 860, 12100, 79, 120000, 21, 'Blue supergiant (B8)', 'नीला महादानव (B8)',
     'The blue foot of Orion, one of the most powerful stars you can see with your eyes.', 'मृग (Orion) का नीला पैर, आँखों से दिखने वाले सबसे शक्तिशाली तारों में से एक।'),
    ('spica', 'Spica', 'चित्रा (Spica)', 250, 25000, 7.5, 20000, 11, 'Blue giant (B1)', 'नीला दानव (B1)',
     'A very hot blue star in Virgo, actually two stars circling each other in four days.', 'कन्या में एक बहुत गर्म नीला तारा, असल में दो तारे जो चार दिन में एक-दूसरे का चक्कर लगाते हैं।'),
]
BY = {s[0]: s for s in STARS}

# spectral classes: letter, colour, from K, to K, en, hi
CLASSES = [('O', '#9bb0ff', 30000, 50000, 'Blue, hottest', 'नीला, सबसे गर्म'), ('B', '#aabfff', 10000, 30000, 'Blue-white', 'नीला-सफ़ेद'),
           ('A', '#cad7ff', 7500, 10000, 'White', 'सफ़ेद'), ('F', '#f8f7ff', 6000, 7500, 'Yellow-white', 'पीला-सफ़ेद'),
           ('G', '#fff4ea', 5200, 6000, 'Yellow, like the Sun', 'पीला, सूर्य जैसा'), ('K', '#ffd2a1', 3700, 5200, 'Orange', 'नारंगी'),
           ('M', '#ffad51', 2400, 3700, 'Red, coolest', 'लाल, सबसे ठंडा')]


def colour(t):
    """A star colour for a surface temperature (from the classes above)."""
    for _, c, lo, hi, _, _ in CLASSES:
        if lo <= t < hi:
            return c
    return '#9bb0ff' if t >= 30000 else '#ffad51'


def lifetime_years(m):
    """Main-sequence lifetime from mass (Sun = 1): roughly 10 billion years x m^-2.5."""
    return 1e10 * m ** -2.5


def _bil(x, y, en, hi, anchor='start', size=13, fill='var(--text)', weight=600):
    st = f'fill:{fill};font:{weight} {size}px DM Sans,sans-serif'
    return (f'<text x="{x}" y="{y}" text-anchor="{anchor}" class="t" lang="en" style="{st}">{en}</text>'
            f'<text x="{x}" y="{y}" text-anchor="{anchor}" class="t" lang="hi" style="{st}">{hi}</text>')


# ---------- drawings ----------
def hr_svg():
    """Hertzsprung-Russell diagram: hot on the left, bright at the top. Each star is a button."""
    W, H, L, R, T, B = 680, 470, 70, 650, 30, 410
    tmax, tmin = math.log10(40000), math.log10(2400)
    lmin, lmax = -4.5, 6.5
    X = lambda t: L + (tmax - math.log10(t)) / (tmax - tmin) * (R - L)
    Y = lambda lum: B - (math.log10(lum) - lmin) / (lmax - lmin) * (B - T)
    # main sequence band: luminosity ~ (T/5772)^7.5 near the Sun, drawn as a soft band
    pts = []
    for i in range(41):
        t = 10 ** (tmax - i * (tmax - tmin) / 40)
        pts.append((X(t), Y(max(1e-4, min(1e6, (t / 5772) ** 7.2)))))
    band = 'M' + ' L'.join(f'{x:.1f} {y:.1f}' for x, y in pts)
    grad = ''.join(f'<stop offset="{i / 6:.2f}" stop-color="{c[1]}"/>' for i, c in enumerate(CLASSES))
    ticks = ''
    for t in (30000, 10000, 6000, 3000):
        ticks += f'<line x1="{X(t):.1f}" y1="{B}" x2="{X(t):.1f}" y2="{B + 5}" stroke="#8c9bb5"/><text x="{X(t):.1f}" y="{B + 19}" text-anchor="middle" style="fill:#8c9bb5;font:12px DM Sans,sans-serif">{t:,} K</text>'
    for e in (-4, -2, 0, 2, 4, 6):
        lab = '1' if e == 0 else f'10<tspan dy="-5" font-size="9">{e}</tspan>'
        ticks += f'<line x1="{L - 5}" y1="{Y(10 ** e):.1f}" x2="{L}" y2="{Y(10 ** e):.1f}" stroke="#8c9bb5"/><text x="{L - 9}" y="{Y(10 ** e) + 4:.1f}" text-anchor="end" style="fill:#8c9bb5;font:12px DM Sans,sans-serif">{lab}</text>'
    dots = ''
    for s in STARS:
        sid, en, hi, d, t, r, lum = s[:7]
        x, y = X(t), Y(lum)
        rad = max(4, min(22, 5 + 3.2 * math.log10(max(r, 0.01)) + (2 if r < 0.05 else 0)))
        lx = x + rad + 6
        anchor = 'start'
        dy = {'betelgeuse': -9, 'antares': 13, 'vega': -7, 'sirius': 11}.get(sid, 0)
        if lx > R - 60:
            lx, anchor = x - rad - 6, 'end'
        dots += (f'<g class="hrstar" data-star="{sid}" tabindex="0" role="button" aria-label="{en}"><circle cx="{x:.1f}" cy="{y:.1f}" r="{rad + 8:.1f}" fill="transparent"/>'
                 f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{rad:.1f}" fill="{colour(t)}" stroke="#fff" stroke-opacity=".35"/>'
                 + _bil(f'{lx:.1f}', f'{y + 4 + dy:.1f}', en.replace('The ', ''), hi, anchor, 12, '#e6ebf7', 500) + '</g>')
    return f'''<svg class="hrsvg" viewBox="0 0 {W} {H}" role="img" aria-label="Hertzsprung-Russell diagram of famous stars">
<defs><linearGradient id="hrg" x1="0" x2="1">{grad}</linearGradient></defs>
<rect width="{W}" height="{H}" rx="18" fill="#05070f"/>
<rect x="{L}" y="{B + 30}" width="{R - L}" height="6" rx="3" fill="url(#hrg)"/>
<path d="{band}" fill="none" stroke="#7db0ff" stroke-opacity=".10" stroke-width="26" stroke-linecap="round"/>
{_bil(X(9000), Y(30) - 26, 'Main sequence', 'Main sequence', 'middle', 13, '#7db0ff')}
{_bil(X(7000), Y(400000), 'Supergiants', 'महादानव', 'middle', 13, '#ffad51')}
{_bil(X(4300), Y(300) + 24, 'Giants', 'दानव', 'middle', 13, '#ffd2a1')}
{_bil(X(16000), Y(0.0004), 'White dwarfs', 'White dwarfs', 'middle', 13, '#cad7ff')}
<line x1="{L}" y1="{T}" x2="{L}" y2="{B}" stroke="#2a3350"/><line x1="{L}" y1="{B}" x2="{R}" y2="{B}" stroke="#2a3350"/>
{ticks}{dots}
{_bil((L + R) // 2, H - 8, '← hotter · surface temperature · cooler →', '← ज़्यादा गर्म · सतह का तापमान · ज़्यादा ठंडा →', 'middle', 12, '#8c9bb5', 500)}
<text x="16" y="{(T + B) // 2}" transform="rotate(-90 16 {(T + B) // 2})" text-anchor="middle" class="t" lang="en" style="fill:#8c9bb5;font:500 12px DM Sans,sans-serif">brightness (Sun = 1)</text>
<text x="16" y="{(T + B) // 2}" transform="rotate(-90 16 {(T + B) // 2})" text-anchor="middle" class="t" lang="hi" style="fill:#8c9bb5;font:500 12px DM Sans,sans-serif">चमक (सूर्य = 1)</text>
</svg>'''


def sizes_svg():
    """Sizes side by side: small stars in one row, then the Sun as a dot next to giant stars."""
    small = [('proxima', 0.15), ('sun', 1), ('sirius', 1.71), ('vega', 2.5)]
    W = 680
    out = f'<svg class="sizesvg" viewBox="0 0 {W} 520" role="img" aria-label="Sizes of stars compared"><rect width="{W}" height="520" rx="18" fill="#05070f"/>'
    out += _bil(20, 30, 'Small and medium stars', 'छोटे और मझोले तारे', 'start', 14, '#e6ebf7')
    k = 34  # pixels per Sun radius
    x = 60
    for sid, r in small:
        s = BY[sid]
        rr = max(2.5, r * k)
        out += f'<circle cx="{x + rr:.1f}" cy="130" r="{rr:.1f}" fill="{colour(s[4])}"/>' + _bil(f'{x + rr:.1f}', 130 + max(rr, 10) + 22, s[1].replace('The ', ''), s[2], 'middle', 12, '#c9d2ea', 500)
        x += 2 * rr + 70
    out += _bil(20, 250, 'Giants: here the Sun is the tiny dot', 'दानव तारे: यहाँ सूर्य वह नन्हा बिंदु है', 'start', 14, '#e6ebf7')
    k2 = 0.95  # pixels per Sun radius
    base = 505
    # Betelgeuse as a big arc, Antares inside, then Rigel and Aldebaran
    for sid, cx in (('betelgeuse', 600), ('antares', 600)):
        s = BY[sid]
        r = s[5] * k2 * 0.33
        out += f'<circle cx="{cx}" cy="{base + r - 230:.1f}" r="{r:.1f}" fill="{colour(s[4])}" fill-opacity="{.55 if sid == "betelgeuse" else .8}"/>'
    out += _bil(600, 300, 'Betelgeuse', 'आर्द्रा (Betelgeuse)', 'middle', 13, '#05070f', 700)
    out += _bil(600, 350, 'Antares', 'ज्येष्ठा (Antares)', 'middle', 13, '#05070f', 700)
    for sid, cx in (('rigel', 210), ('aldebaran', 330)):
        s = BY[sid]
        r = s[5] * k2 * 0.33
        out += f'<circle cx="{cx}" cy="{420:.1f}" r="{r:.1f}" fill="{colour(s[4])}"/>' + _bil(cx, 420 + r + 20, s[1], s[2], 'middle', 12, '#c9d2ea', 500)
    out += '<circle cx="90" cy="420" r="1.2" fill="#fff4ea"/><path d="M90 414 V380" stroke="#8c9bb5"/>' + _bil(90, 372, 'The Sun', 'सूर्य', 'middle', 12, '#c9d2ea', 500)
    out += _bil(W // 2, 512, 'Drawn to scale within each row.', 'हर पंक्ति के अंदर सही अनुपात में बना।', 'middle', 11, '#8c9bb5', 400)
    return out + '</svg>'


def pulsar_svg():
    return '''<div class="pulsar" aria-hidden="true"><svg viewBox="0 0 300 300"><defs><radialGradient id="psg"><stop offset="0" stop-color="#fff"/><stop offset=".4" stop-color="#bcd4ff"/><stop offset="1" stop-color="#5b9bff" stop-opacity="0"/></radialGradient>
<linearGradient id="psb" x1="0" x2="0" y1="0" y2="1"><stop offset="0" stop-color="#9fc2ff" stop-opacity="0"/><stop offset="1" stop-color="#9fc2ff" stop-opacity=".85"/></linearGradient></defs>
<rect width="300" height="300" rx="18" fill="#05070f"/><g class="psrot"><path d="M150 150 L128 0 H172 Z" fill="url(#psb)"/><path d="M150 150 L128 300 H172 Z" fill="url(#psb)" transform="rotate(180 150 150) scale(1 1)"/>
<ellipse cx="150" cy="150" rx="70" ry="22" fill="none" stroke="#5b9bff" stroke-opacity=".35"/></g><circle cx="150" cy="150" r="34" fill="url(#psg)"/><circle cx="150" cy="150" r="9" fill="#fff"/></svg></div>'''


V = ''


def build(h):
    global V
    V = h['asset_v']()
    k = Kit(h)
    bt = k.bt
    P, H2, callout, sec, card, facts, table, note = k.P, k.H2, k.callout, k.sec, k.card, k.facts, k.table, k.note

    def grid(*cards, w=230):
        return f'<div class="grid" style="grid-template-columns:repeat(auto-fit,minmax({w}px,1fr))">' + ''.join(cards) + '</div>'

    SLUGS = [
        ('how-stars-are-born', 'How stars are born', 'तारे कैसे बनते हैं', 'From a cold cloud of gas and dust to a shining star.', 'गैस और धूल के ठंडे बादल से चमकते तारे तक।', '🌫️'),
        ('life-of-a-star', 'The life of a star', 'तारे का जीवन', 'Mass decides everything: how long a star lives and how it ends.', 'द्रव्यमान सब तय करता है: तारा कितना जिएगा और कैसे ख़त्म होगा।', '⏳'),
        ('supernova', 'Supernovae', 'Supernova', 'The biggest explosions since the Big Bang, and where your iron came from.', 'Big Bang के बाद के सबसे बड़े धमाके, और आपके ख़ून का लोहा कहाँ से आया।', '💥'),
        ('neutron-stars-and-pulsars', 'Neutron stars and pulsars', 'Neutron star और pulsar', 'A city-sized ball heavier than the Sun, spinning hundreds of times a second.', 'शहर जितना गोला, सूर्य से भारी, जो एक सेकंड में सैकड़ों बार घूमता है।', '🌀'),
        ('white-dwarfs-and-planetary-nebulae', 'White dwarfs and planetary nebulae', 'White dwarf और planetary nebula', 'How the Sun will end: a glowing shell and an Earth-sized ember.', 'सूर्य का अंत कैसा होगा: चमकता खोल और पृथ्वी जितना अंगारा।', '💍'),
        ('star-colours-and-sizes', 'Star colours and sizes', 'तारों के रंग और आकार', 'Why stars have colours, the HR diagram and how big the giants are.', 'तारों के रंग क्यों होते हैं, HR diagram और दानव तारे कितने बड़े हैं।', '🌈'),
        ('famous-stars', 'Famous stars', 'मशहूर तारे', 'Sirius, Betelgeuse, Rigel, Polaris, Vega and more, with real numbers.', 'लुब्धक, आर्द्रा, Rigel, ध्रुव तारा, अभिजित और भी, असली आँकड़ों के साथ।', '⭐'),
    ]
    S = Section(k, 'stars', 'stars.html', 'stars', 'Stars', 'तारे', SLUGS)
    REL = [('black-holes.html', '🕳️', 'Black holes', 'ब्लैक होल'), ('galaxies.html', '🌌', 'Galaxies', 'Galaxies'),
           ('constellations.html', '✨', 'Constellations', 'नक्षत्र'), ('quiz.html', '🧠', 'Quiz', 'Quiz')]
    _page = S.page
    S.page = lambda *a, **kw: _page(*a, related=REL, **kw)
    data = {s[0]: {'en': s[1], 'hi': s[2], 'ly': s[3], 't': s[4], 'r': s[5], 'l': s[6], 'm': s[7], 'ten': s[8], 'thi': s[9], 'nen': s[10], 'nhi': s[11], 'c': colour(s[4])} for s in STARS}
    data_js = '<script>window.ASTRYL_STARS=' + json.dumps(data, ensure_ascii=False).replace('</', '<\\/') + ';</script>'
    out = []

    # ---------------- hub ----------------
    hub = f'''<section class="hero2 starhero" style="padding-bottom:0">
<div><h1 class="rise">{bt("Every star has a", "हर तारे की एक")} <span class="grad">{bt("life story.", "जीवन कहानी है।")}</span></h1>
<p class="lead rise">{bt("Stars are born in cold clouds, shine for millions or billions of years, and die as white dwarfs, neutron stars or black holes. Some explode. The iron in your blood was made inside one.", "तारे ठंडे बादलों में जन्म लेते हैं, लाखों या अरबों साल चमकते हैं, और white dwarf, neutron star या ब्लैक होल बनकर ख़त्म होते हैं। कुछ फट जाते हैं। आपके ख़ून का लोहा किसी तारे के अंदर बना था।")}</p>
<div class="btns rise"><a class="btn primary" href="stars/how-stars-are-born.html">{bt("Start: how stars are born", "शुरू कीजिए: तारे कैसे बनते हैं")} →</a><a class="btn" href="stars/life-of-a-star.html">⏳ {bt("Play the life of a star", "तारे का जीवन चलाकर देखिए")}</a></div></div>
<div class="starhero-img"><img src="img/space/nb-pillars.webp" alt="" loading="eager"></div></section>
<section class="blk">{facts([
        ('Stars in the Milky Way', 'आकाशगंगा में तारे', '100 to 400 billion', '100 से 400 अरब'),
        ('Nearest star after the Sun', 'सूर्य के बाद सबसे पास का तारा', 'Proxima Centauri, 4.24 light-years', 'Proxima Centauri, 4.24 प्रकाश-वर्ष'),
        ('Smallest mass to be a star', 'तारा बनने के लिए सबसे कम द्रव्यमान', 'about 8% of the Sun', 'सूर्य का लगभग 8%'),
        ('The Sun’s age', 'सूर्य की उम्र', '4.6 billion years', '4.6 अरब साल'),
    ])}</section>
<section class="blk"><h2>{bt("Seven short pages", "सात छोटे पन्ने")}</h2><div class="sc-grid" style="padding-top:6px">{S.cards().replace('href="stars/', 'href="stars/')}</div></section>
<section class="blk"><h2>{bt("A star’s life in one picture", "एक तस्वीर में तारे का जीवन")}</h2>{life_strip(bt, '')}</section>
<section class="blk callout"><b>🧠 {bt("Test yourself:", "ख़ुद को परखिए:")}</b> {bt("the Quiz page has a Stars round.", "Quiz page पर तारों वाला round है।")} <a href="quiz.html">{bt("Play the Stars round", "तारों वाला round खेलिए")} →</a></section>'''
    out.append({'file': 'stars.html', 'html': h['shell']('Stars explained', 'तारे, आसान भाषा में', 'stars', hub,
                'How stars are born, live and die: nebulae, the Sun, red giants, supernovae, neutron stars, white dwarfs and famous stars, with real photos. Free.',
                canonical='stars.html', ld=article_ld(h['SITE'], 'Stars explained', 'How stars are born, live and die, with real photos.', 'stars.html', [('Astryl', ''), ('Stars', 'stars.html')]))})

    # ---------------- 1 born ----------------
    s = 'how-stars-are-born'
    body = S.head('How stars are born', 'तारे कैसे बनते हैं', 'Every star starts as a cold, dark cloud. Gravity does the rest.', 'हर तारा एक ठंडे, अँधेरे बादल से शुरू होता है। बाक़ी काम गुरुत्वाकर्षण करता है।') + sec(
        H2('1. A cold cloud', '1. एक ठंडा बादल'),
        P('Space between the stars is not completely empty. In places there are huge clouds of gas, mostly hydrogen, mixed with dust. These molecular clouds are very cold, about minus 260 °C, and can be hundreds of light-years across.',
          'तारों के बीच की जगह पूरी तरह ख़ाली नहीं है। कहीं-कहीं गैस के विशाल बादल हैं, ज़्यादातर hydrogen, धूल के साथ मिली हुई। ये molecular clouds बहुत ठंडे होते हैं, लगभग माइनस 260 °C, और सैकड़ों प्रकाश-वर्ष चौड़े हो सकते हैं।'),
        H2('2. Something gives it a push', '2. कोई चीज़ धक्का देती है'),
        P('A cloud can float for millions of years. Then something squeezes part of it: the shock wave of a nearby supernova, a collision with another cloud, or the pull of a passing spiral arm. The densest knots start to collapse under their own gravity.',
          'एक बादल लाखों साल तक तैरता रह सकता है। फिर कोई चीज़ उसके किसी हिस्से को दबाती है: पास के supernova की shock wave, किसी दूसरे बादल से टक्कर, या गुज़रती spiral arm का खिंचाव। सबसे घने हिस्से अपने ही गुरुत्वाकर्षण से सिकुड़ने लगते हैं।'),
        H2('3. A protostar', '3. Protostar (शिशु तारा)'),
        P('As a knot shrinks it spins faster and flattens into a disk, the way a pizza maker spins dough. The middle gets hotter and hotter. This glowing ball is a protostar. It shines from the heat of falling gas, not yet from fusion.',
          'सिकुड़ते हुए वह हिस्सा तेज़ घूमने लगता है और चपटी disk बन जाता है, जैसे पिज़्ज़ा बनाने वाला आटा घुमाता है। बीच का हिस्सा गर्म, और गर्म होता जाता है। यह चमकता गोला protostar है। यह गिरती गैस की गर्मी से चमकता है, अभी fusion से नहीं।'),
        P('Young stars also shoot jets of gas out of their poles at hundreds of kilometres per second. Where the jets hit the cloud they make glowing knots called Herbig-Haro objects.',
          'नए तारे अपने ध्रुवों से सैकड़ों किलोमीटर प्रति सेकंड की रफ़्तार से गैस की धाराएँ (jets) भी फेंकते हैं। जहाँ ये jets बादल से टकराते हैं, वहाँ चमकती गाँठें बनती हैं जिन्हें Herbig-Haro objects कहते हैं।'),
        H2('4. Fusion switches on: a star is born', '4. Fusion शुरू: तारे का जन्म'),
        P('When the core reaches about 10 million °C, hydrogen nuclei crash together hard enough to fuse into helium. Each fusion turns a tiny bit of mass into energy (E = mc²). The outward push of that energy now balances gravity, and the star stops shrinking. It has joined the main sequence, where it will spend about 90% of its life.',
          'जब केंद्र लगभग 1 करोड़ °C तक पहुँचता है, hydrogen के nuclei इतनी ज़ोर से टकराते हैं कि जुड़कर helium बन जाते हैं। हर fusion थोड़े से द्रव्यमान को ऊर्जा में बदलता है (E = mc²)। उस ऊर्जा का बाहर की ओर दबाव अब गुरुत्वाकर्षण को संतुलित कर देता है, और तारा सिकुड़ना बंद कर देता है। अब यह main sequence पर है, जहाँ यह अपने जीवन का लगभग 90% समय बिताएगा।'),
        facts([('Core temperature for fusion', 'Fusion के लिए केंद्र का तापमान', 'about 10 million °C', 'लगभग 1 करोड़ °C'),
               ('The Sun’s core today', 'आज सूर्य का केंद्र', 'about 15 million °C', 'लगभग 1.5 करोड़ °C'),
               ('Hydrogen the Sun fuses each second', 'सूर्य हर सेकंड कितनी hydrogen जोड़ता है', 'about 600 million tonnes', 'लगभग 60 करोड़ टन'),
               ('Time for the Sun to form', 'सूर्य को बनने में लगा समय', 'roughly 50 million years', 'लगभग 5 करोड़ साल')]),
        H2('5. Leftovers make planets', '5. बचे हुए हिस्से से ग्रह'),
        P('The disk around a young star does not go to waste. Dust sticks into pebbles, pebbles into rocks, rocks into planets. Our Earth and the other planets formed this way from the disk around the young Sun, about 4.6 billion years ago.',
          'नए तारे के चारों ओर की disk बेकार नहीं जाती। धूल चिपककर कंकड़ बनती है, कंकड़ से पत्थर, पत्थरों से ग्रह। हमारी पृथ्वी और बाक़ी ग्रह लगभग 4.6 अरब साल पहले नए सूर्य के चारों ओर की disk से इसी तरह बने।'),
        callout('Too small to be a star: below about 8% of the Sun’s mass (about 80 Jupiters), the core never gets hot enough for hydrogen fusion. Such objects are called brown dwarfs, "failed stars".',
                'तारा बनने के लिए बहुत छोटा: सूर्य के द्रव्यमान के लगभग 8% (लगभग 80 बृहस्पति) से कम हो, तो केंद्र hydrogen fusion के लिए कभी पर्याप्त गर्म नहीं होता। ऐसी चीज़ों को brown dwarf, "नाकाम तारे", कहते हैं।'),
        H2('Star nurseries you can see', 'तारों के पालने जो आप देख सकते हैं'),
        P('The Orion Nebula, the fuzzy middle "star" of Orion’s sword, is the nearest big star nursery, about 1,350 light-years away. You can see it with your own eyes from a dark place, and binoculars show its glow.',
          'Orion Nebula, मृग (Orion) की तलवार का धुँधला बीच वाला "तारा", सबसे पास का बड़ा तारों का पालना है, लगभग 1,350 प्रकाश-वर्ष दूर। अँधेरी जगह से इसे आँखों से देखा जा सकता है, और दूरबीन से इसकी चमक दिखती है।'),
    ) + S.pn(s)
    out.append(S.page(s, body, 'How stars are born', 'तारे कैसे बनते हैं', 'How a star is born: molecular clouds, collapse, protostars, jets, nuclear fusion and the planets made from the leftovers, with real Webb and Hubble photos.'))

    # ---------------- 2 life ----------------
    s = 'life-of-a-star'
    rows = []
    for m, en, hi in ((0.1, 'Red dwarf (0.1 Sun)', 'लाल बौना (0.1 सूर्य)'), (1, 'The Sun (1 Sun)', 'सूर्य (1 सूर्य)'), (3, 'Vega-like (3 Suns)', 'Vega जैसा (3 सूर्य)'), (10, 'Massive star (10 Suns)', 'भारी तारा (10 सूर्य)'), (25, 'Very massive (25 Suns)', 'बहुत भारी (25 सूर्य)')):
        y = lifetime_years(m)
        if y >= 1e12:
            ye, yh = f'about {y / 1e12:,.0f} trillion years', f'लगभग {y / 1e12:,.0f} लाख करोड़ साल'
        elif y >= 1e9:
            ye, yh = f'about {y / 1e9:,.0f} billion years', f'लगभग {y / 1e9:,.0f} अरब साल'
        elif y >= 1e7:
            ye, yh = f'about {y / 1e6:,.0f} million years', f'लगभग {y / 1e7:,.1f} करोड़ साल'
        else:
            ye, yh = f'about {y / 1e6:,.0f} million years', f'लगभग {y / 1e5:,.0f} लाख साल'
        rows.append([(en, hi), (ye, yh)])
    body = S.head('The life of a star', 'तारे का जीवन', 'A star’s mass at birth decides how long it lives and how it dies.', 'जन्म के समय तारे का द्रव्यमान तय करता है कि वह कितना जिएगा और कैसे मरेगा।') + f'''
<section class="blk"><div class="lifecycle" id="lifecycle"><div class="lcpick" role="group">
<button type="button" data-path="low" class="on">☀️ {bt("A star like the Sun", "सूर्य जैसा तारा")}</button><button type="button" data-path="high">🔥 {bt("8 to 25 Suns", "8 से 25 सूर्य")}</button><button type="button" data-path="huge">💀 {bt("More than 25 Suns", "25 सूर्य से ज़्यादा")}</button></div>
<div class="lcstage"><div class="lcsky"><div class="lcstar" id="lcStar"></div><div class="lcring" id="lcRing"></div></div><div class="lctext"><span class="lcstep" id="lcStep"></span><h3 id="lcTitle"></h3><p id="lcBody"></p><p class="note" id="lcTime"></p></div></div>
<input type="range" id="lcRange" min="0" max="5" value="0" step="1" aria-label="Stage"><div class="lcbtns"><button type="button" class="btn" id="lcPrev">←</button><button type="button" class="btn primary" id="lcPlay">▶ {bt("Play", "चलाइए")}</button><button type="button" class="btn" id="lcNext">→</button></div></div></section>''' + sec(
        H2('Mass is everything', 'द्रव्यमान ही सब कुछ है'),
        P('A heavier star has more fuel, but it burns it far faster, because the crushing weight makes its core hotter. So big stars live short, bright lives, and small stars live almost forever.',
          'भारी तारे के पास ज़्यादा ईंधन होता है, पर वह उसे कहीं तेज़ी से जलाता है, क्योंकि भारी वज़न उसके केंद्र को और गर्म कर देता है। इसलिए बड़े तारे छोटा, चमकीला जीवन जीते हैं, और छोटे तारे लगभग हमेशा जीते हैं।'),
        table([('Star', 'तारा'), ('Time spent shining on hydrogen', 'Hydrogen से चमकने का समय')], rows, cols=True),
        note('Worked out from the rule of thumb lifetime ≈ 10 billion years × mass⁻²·⁵. Real stars vary.', 'मोटे नियम से निकाला गया: उम्र ≈ 10 अरब साल × द्रव्यमान⁻²·⁵। असली तारे थोड़े अलग हो सकते हैं।'),
        callout('A red dwarf lives so long that not one has died yet: the universe is only 13.8 billion years old.', 'लाल बौना तारा इतना लंबा जीता है कि अभी तक एक भी नहीं मरा: ब्रह्मांड सिर्फ़ 13.8 अरब साल पुराना है।'),
        H2('What will happen to the Sun', 'सूर्य के साथ क्या होगा'),
        P('In about 5 billion years the Sun will run out of hydrogen in its core. The core will shrink and heat up, and the outer layers will swell into a red giant more than 100 times wider than today. It will swallow Mercury and Venus, and maybe Earth.',
          'लगभग 5 अरब साल में सूर्य के केंद्र में hydrogen ख़त्म हो जाएगी। केंद्र सिकुड़कर गर्म होगा, और बाहरी परतें फूलकर आज से 100 गुना से ज़्यादा चौड़ा red giant बन जाएँगी। यह बुध और शुक्र को निगल लेगा, और शायद पृथ्वी को भी।'),
        P('Then it will gently blow its outer layers away into a glowing planetary nebula, and its core will remain as a white dwarf about the size of Earth, slowly cooling for trillions of years.',
          'फिर यह अपनी बाहरी परतें धीरे से उड़ाकर चमकती planetary nebula बना देगा, और इसका केंद्र पृथ्वी जितने white dwarf के रूप में बचेगा, जो खरबों साल तक धीरे-धीरे ठंडा होगा।'),
        H2('And the big ones', 'और बड़े तारे'),
        P('Stars of more than about 8 Suns go further. After helium they fuse carbon, neon, oxygen and silicon, building layers like an onion, until the core is iron. Fusing iron gives no energy, so the core collapses in less than a second and the star explodes as a supernova.',
          'लगभग 8 सूर्य से भारी तारे आगे जाते हैं। Helium के बाद वे carbon, neon, oxygen और silicon जोड़ते हैं, प्याज़ जैसी परतें बनाते हुए, जब तक केंद्र लोहे (iron) का न हो जाए। लोहा जोड़ने से ऊर्जा नहीं मिलती, इसलिए केंद्र एक सेकंड से कम में ढह जाता है और तारा supernova बनकर फट जाता है।'),
    ) + S.pn(s)
    out.append(S.page(s, body + data_js_life(), 'The life of a star', 'तारे का जीवन', 'The life cycle of a star, played step by step: how mass decides whether a star ends as a white dwarf, a neutron star or a black hole, and what will happen to the Sun.'))

    # ---------------- 3 supernova ----------------
    s = 'supernova'
    body = S.head('Supernovae', 'Supernova', 'For a few weeks one exploding star can outshine a whole galaxy.', 'कुछ हफ़्तों के लिए एक फटता तारा पूरी galaxy से ज़्यादा चमक सकता है।') + sec(
        H2('Two ways to explode', 'फटने के दो तरीक़े'),
        grid(card('Core collapse (Type II and others)', 'Core collapse (Type II और दूसरे)',
                  'A star of more than about 8 Suns builds an iron core. When the core reaches about 1.4 Suns it can no longer hold itself up and collapses in under a second, from the size of Earth to about 20 km. The falling layers bounce off it and a blast wave, pushed by a flood of neutrinos, tears the star apart.',
                  'लगभग 8 सूर्य से भारी तारा लोहे का केंद्र बनाता है। जब केंद्र लगभग 1.4 सूर्य का हो जाता है, वह ख़ुद को सँभाल नहीं पाता और एक सेकंड से कम में ढह जाता है, पृथ्वी जितने आकार से लगभग 20 km तक। गिरती परतें उससे टकराकर लौटती हैं और neutrinos की बाढ़ से धकेली गई shock wave तारे को चीर देती है।'),
             card('White dwarf explosion (Type Ia)', 'White dwarf का धमाका (Type Ia)',
                  'A white dwarf in a pair of stars pulls gas from its partner, or merges with another white dwarf. When it gets close to about 1.4 Suns, carbon fusion runs away all at once and the whole star blows up, leaving nothing behind.',
                  'जोड़ी में रहने वाला white dwarf अपने साथी से गैस खींचता है, या किसी दूसरे white dwarf से मिल जाता है। जब वह लगभग 1.4 सूर्य के क़रीब पहुँचता है, carbon fusion एक साथ बेक़ाबू हो जाता है और पूरा तारा उड़ जाता है, पीछे कुछ नहीं बचता।'), w=280),
        callout('That limit, about 1.4 times the Sun’s mass, is called the Chandrasekhar limit after Subrahmanyan Chandrasekhar, the Indian-born astrophysicist who worked it out as a young man in 1930 and won the Nobel Prize in 1983.',
                'यह सीमा, सूर्य के द्रव्यमान की लगभग 1.4 गुना, Chandrasekhar limit कहलाती है, भारत में जन्मे खगोल-भौतिकविद सुब्रह्मण्यन चंद्रशेखर के नाम पर, जिन्होंने 1930 में युवावस्था में इसे निकाला और 1983 में Nobel पुरस्कार जीता।'),
        H2('How bright?', 'कितना चमकीला?'),
        P('A supernova can shine as brightly as billions of Suns for weeks. Type Ia explosions all peak at nearly the same brightness, so astronomers use them as measuring sticks for distance. In 1998 they showed that the expansion of the universe is speeding up.',
          'एक supernova हफ़्तों तक अरबों सूर्य जितना चमक सकता है। Type Ia धमाके लगभग एक जैसी अधिकतम चमक तक पहुँचते हैं, इसलिए खगोलविद उन्हें दूरी नापने के पैमाने की तरह इस्तेमाल करते हैं। 1998 में इन्हीं से पता चला कि ब्रह्मांड का फैलना तेज़ हो रहा है।'),
        H2('You are made of star stuff', 'आप तारों की धूल से बने हैं'),
        P('The Big Bang made almost only hydrogen and helium. The carbon in your cells, the oxygen you breathe, the calcium in your bones and the iron in your blood were made inside stars and spread through space when they died. Many heavier elements, such as gold, come from colliding neutron stars and rare kinds of supernova.',
          'Big Bang ने लगभग सिर्फ़ hydrogen और helium बनाई। आपकी कोशिकाओं का carbon, जो oxygen आप साँस में लेते हैं, आपकी हड्डियों का calcium और आपके ख़ून का लोहा तारों के अंदर बने और उनके मरने पर अंतरिक्ष में फैले। सोने जैसे कई भारी तत्व टकराते neutron stars और कुछ दुर्लभ supernova से आते हैं।'),
        H2('Famous supernovae', 'मशहूर supernova'),
        table([('Year seen', 'कब दिखा'), ('Name', 'नाम'), ('What happened', 'क्या हुआ')], [
            [('1054', '1054'), ('SN 1054', 'SN 1054'), ('Recorded by Chinese astronomers, bright enough to see in daylight for 23 days. Its remains are the Crab Nebula.', 'चीनी खगोलविदों ने दर्ज किया, 23 दिन तक दिन में भी दिखता था। इसके अवशेष Crab Nebula हैं।')],
            [('1572', '1572'), ('Tycho’s supernova', 'Tycho का supernova'), ('Studied by Tycho Brahe; it showed that the sky beyond the Moon can change.', 'Tycho Brahe ने अध्ययन किया; इससे पता चला कि चाँद के पार का आसमान भी बदल सकता है।')],
            [('1604', '1604'), ('Kepler’s supernova', 'Kepler का supernova'), ('The last one seen with the eyes in our own galaxy.', 'हमारी अपनी galaxy में आँखों से दिखा आख़िरी supernova।')],
            [('~1680', '~1680'), ('Cassiopeia A', 'Cassiopeia A'), ('Hidden by dust, almost nobody saw it, but its glowing shell is one of the brightest radio sources in the sky.', 'धूल में छिपा, लगभग किसी ने नहीं देखा, पर इसका चमकता खोल आसमान के सबसे चमकीले radio स्रोतों में से एक है।')],
            [('1987', '1987'), ('SN 1987A', 'SN 1987A'), ('In the Large Magellanic Cloud, 168,000 light-years away. Detectors on Earth caught its neutrinos hours before the light.', 'Large Magellanic Cloud में, 1,68,000 प्रकाश-वर्ष दूर। पृथ्वी पर detectors ने रोशनी से घंटों पहले इसके neutrinos पकड़े।')]], cols=True),
        H2('Will one hurt us?', 'क्या कोई हमें नुक़सान पहुँचाएगा?'),
        P('Only a supernova within roughly 50 light-years could harm life on Earth, and no star that close is able to explode. Betelgeuse, about 550 light-years away, will be a spectacular sight: as bright as a half Moon for weeks, visible in daylight, but harmless.',
          'सिर्फ़ लगभग 50 प्रकाश-वर्ष के अंदर का supernova पृथ्वी पर जीवन को नुक़सान पहुँचा सकता है, और इतना पास कोई तारा फटने लायक़ नहीं है। लगभग 550 प्रकाश-वर्ष दूर आर्द्रा (Betelgeuse) शानदार नज़ारा होगा: हफ़्तों तक आधे चाँद जितना चमकीला, दिन में भी दिखेगा, पर बेख़तर।'),
    ) + S.pn(s)
    out.append(S.page(s, body, 'Supernovae', 'Supernova', 'What a supernova is: core-collapse and Type Ia explosions, the Chandrasekhar limit, how supernovae made the elements in our bodies, famous supernovae and whether one could hurt us.'))

    # ---------------- 4 neutron stars ----------------
    s = 'neutron-stars-and-pulsars'
    body = S.head('Neutron stars and pulsars', 'Neutron star और pulsar', 'What is left when a big star explodes is stranger than science fiction.', 'बड़े तारे के फटने के बाद जो बचता है, वह science fiction से भी अजीब है।') + sec(
        f'<div class="pswrap">{pulsar_svg()}<div>' + facts([
            ('Width', 'चौड़ाई', 'about 20 km, like a city', 'लगभग 20 km, एक शहर जितना'),
            ('Mass', 'द्रव्यमान', '1.4 to about 2 Suns', '1.4 से लगभग 2 सूर्य'),
            ('A teaspoon would weigh', 'एक चम्मच का वज़न', 'about a billion tonnes', 'लगभग 1 अरब टन'),
            ('Fastest known spin', 'सबसे तेज़ ज्ञात घूमना', '716 times a second', 'एक सेकंड में 716 बार')]) + '</div></div>',
        H2('Made of neutrons', 'Neutrons से बना'),
        P('When the iron core of a big star collapses, it is crushed so hard that electrons and protons merge into neutrons. The result is a ball of neutrons packed as tightly as the inside of an atom’s nucleus. Its gravity is so strong that a ball dropped from one metre would hit the ground at millions of kilometres per hour.',
          'जब बड़े तारे का लोहे का केंद्र ढहता है, तो इतनी ज़ोर से दबता है कि electrons और protons मिलकर neutrons बन जाते हैं। नतीजा neutrons का एक गोला है जो atom के nucleus के अंदर जितना कसकर भरा है। इसका गुरुत्वाकर्षण इतना तेज़ है कि एक मीटर ऊपर से गिराई गेंद लाखों किलोमीटर प्रति घंटे से ज़मीन से टकराएगी।'),
        H2('Pulsars: cosmic lighthouses', 'Pulsar: अंतरिक्ष के lighthouse'),
        P('A collapsing core spins faster, like a skater pulling in her arms, and its magnetic field gets squeezed and much stronger. Beams of radio waves shoot out from its magnetic poles. If a beam sweeps past Earth we see a blink each turn. Such a neutron star is a pulsar.',
          'ढहता केंद्र तेज़ घूमने लगता है, जैसे skater बाहें अंदर खींचकर तेज़ घूमती है, और इसका magnetic field दबकर बहुत तेज़ हो जाता है। इसके magnetic ध्रुवों से radio तरंगों की किरणें निकलती हैं। अगर कोई किरण पृथ्वी के ऊपर से गुज़रे तो हर चक्कर में हमें एक झपक दिखती है। ऐसा neutron star pulsar कहलाता है।'),
        P('The first pulsar was found in 1967 by Jocelyn Bell Burnell, a PhD student, who noticed a strange signal repeating every 1.34 seconds. It was so regular that the team half-jokingly called it LGM-1, "little green men".',
          'पहला pulsar 1967 में PhD छात्रा Jocelyn Bell Burnell ने खोजा, जिन्होंने हर 1.34 सेकंड में दोहराता एक अजीब signal देखा। यह इतना नियमित था कि टीम ने आधे मज़ाक़ में इसे LGM-1, "little green men", कहा।'),
        table([('Pulsar', 'Pulsar'), ('Turns per second', 'एक सेकंड में चक्कर'), ('Note', 'ख़ास बात')], [
            [('Crab Pulsar', 'Crab Pulsar'), ('30', '30'), ('The core of the star that exploded in 1054.', '1054 में फटे तारे का केंद्र।')],
            [('Vela Pulsar', 'Vela Pulsar'), ('11', '11'), ('About 11,000 years old; its jet is seen in X-rays.', 'लगभग 11,000 साल पुराना; इसका jet X-rays में दिखता है।')],
            [('PSR J1748-2446ad', 'PSR J1748-2446ad'), ('716', '716'), ('The fastest known: its surface moves at about a quarter of the speed of light.', 'सबसे तेज़ ज्ञात: इसकी सतह रोशनी की लगभग एक-चौथाई रफ़्तार से चलती है।')]], cols=True),
        H2('Magnetars and collisions', 'Magnetar और टक्करें'),
        P('Magnetars are neutron stars with the strongest magnetic fields known, about a thousand trillion times Earth’s. When two neutron stars spiral together and collide, they shake space itself. In 2017 detectors on Earth caught these gravitational waves (GW170817), and telescopes then saw freshly made gold and platinum glowing in the blast.',
          'Magnetar सबसे तेज़ ज्ञात magnetic field वाले neutron stars हैं, पृथ्वी के field से लगभग एक हज़ार लाख करोड़ गुना। जब दो neutron stars घूमते हुए पास आकर टकराते हैं, तो अंतरिक्ष ही काँप उठता है। 2017 में पृथ्वी पर detectors ने ये gravitational waves (GW170817) पकड़ीं, और फिर telescopes ने धमाके में ताज़ा बने सोने और platinum को चमकते देखा।'),
        callout('If the core left after a supernova is heavier than about 2 to 3 Suns, not even neutrons can hold it up. It collapses all the way into a black hole.', 'अगर supernova के बाद बचा केंद्र लगभग 2 से 3 सूर्य से भारी हो, तो neutrons भी उसे नहीं सँभाल पाते। वह पूरी तरह ढहकर ब्लैक होल बन जाता है।'),
    ) + S.pn(s)
    out.append(S.page(s, body, 'Neutron stars and pulsars', 'Neutron star और pulsar', 'Neutron stars and pulsars explained: how they form, how dense they are, how Jocelyn Bell Burnell found the first pulsar, magnetars and neutron star collisions that make gold.'))

    # ---------------- 5 white dwarfs ----------------
    s = 'white-dwarfs-and-planetary-nebulae'
    body = S.head('White dwarfs and planetary nebulae', 'White dwarf और planetary nebula', 'The quiet, beautiful end of stars like the Sun.', 'सूर्य जैसे तारों का शांत, सुंदर अंत।') + sec(
        H2('A planetary nebula', 'Planetary nebula'),
        P('When a Sun-like red giant has used up its fuel, it puffs its outer layers into space. The hot core lights the gas from inside, making a glowing shell of many colours. Early astronomers with small telescopes thought these round shapes looked like planets, so they are called planetary nebulae, though they have nothing to do with planets.',
          'जब सूर्य जैसा red giant अपना ईंधन ख़त्म कर लेता है, तो अपनी बाहरी परतें अंतरिक्ष में फूँक देता है। गर्म केंद्र उस गैस को अंदर से रोशन करता है, जिससे कई रंगों का चमकता खोल बनता है। छोटे telescopes वाले पुराने खगोलविदों को ये गोल आकार ग्रहों जैसे लगे, इसलिए इन्हें planetary nebula कहते हैं, हालाँकि इनका ग्रहों से कोई लेना-देना नहीं।'),
        P('A planetary nebula fades in only about 10,000 to 20,000 years, a blink in a star’s life. Its gas, now carrying carbon and nitrogen made by the star, mixes into clouds that will make new stars and planets.',
          'Planetary nebula सिर्फ़ लगभग 10,000 से 20,000 साल में धुँधली पड़ जाती है, तारे के जीवन में पलक झपकने जितना। इसकी गैस, जिसमें अब तारे का बनाया carbon और nitrogen है, उन बादलों में मिल जाती है जो नए तारे और ग्रह बनाएँगे।'),
        H2('A white dwarf', 'White dwarf'),
        facts([('Typical mass', 'आम द्रव्यमान', 'about 0.6 Suns', 'लगभग 0.6 सूर्य'), ('Size', 'आकार', 'about the size of Earth', 'लगभग पृथ्वी जितना'),
               ('A teaspoon would weigh', 'एक चम्मच का वज़न', 'about 5 tonnes, like an elephant', 'लगभग 5 टन, एक हाथी जितना'), ('Most massive possible', 'सबसे ज़्यादा संभव द्रव्यमान', 'about 1.4 Suns (Chandrasekhar limit)', 'लगभग 1.4 सूर्य (Chandrasekhar limit)')]),
        P('The core left behind is mostly carbon and oxygen, squeezed so hard that electrons refuse to be packed any closer. That push, not fusion, holds it up. It starts hotter than 100,000 °C and simply cools down, slowly, over trillions of years.',
          'पीछे बचा केंद्र ज़्यादातर carbon और oxygen है, इतना दबा हुआ कि electrons और पास आने से इनकार कर देते हैं। यही दबाव, fusion नहीं, इसे सँभाले रखता है। यह 1,00,000 °C से भी ज़्यादा गर्म शुरू होता है और बस धीरे-धीरे, खरबों साल में, ठंडा होता जाता है।'),
        P('The nearest white dwarf is Sirius B, the faint partner of the brightest star in the sky. It has about the mass of the Sun packed into a ball a bit smaller than Earth.',
          'सबसे पास का white dwarf Sirius B है, आसमान के सबसे चमकीले तारे का धुँधला साथी। इसमें लगभग सूर्य जितना द्रव्यमान पृथ्वी से थोड़े छोटे गोले में भरा है।'),
        callout('Over 97% of all stars in the Milky Way, including the Sun, will end as white dwarfs.', 'आकाशगंगा के 97% से ज़्यादा तारे, सूर्य समेत, white dwarf बनकर ख़त्म होंगे।'),
    ) + S.pn(s)
    out.append(S.page(s, body, 'White dwarfs and planetary nebulae', 'White dwarf और planetary nebula', 'How Sun-like stars end: planetary nebulae like the Ring and Cat’s Eye, white dwarfs like Sirius B, how dense they are and the Chandrasekhar limit.'))

    # ---------------- 6 colours ----------------
    s = 'star-colours-and-sizes'
    cls_rows = [[f'<b style="color:{c}">{l}</b>', (f'{lo:,}–{hi_:,} K' if hi_ < 50000 else f'over {lo:,} K', f'{lo:,}–{hi_:,} K' if hi_ < 50000 else f'{lo:,} K से ज़्यादा'), (en, hi)] for l, c, lo, hi_, en, hi in CLASSES]
    body = S.head('Star colours and sizes', 'तारों के रंग और आकार', 'Look closely at the night sky: stars are not all white.', 'रात के आसमान को ध्यान से देखिए: सारे तारे सफ़ेद नहीं हैं।') + sec(
        H2('Colour tells temperature', 'रंग तापमान बताता है'),
        P('Like a piece of iron in a fire, a star glows red when it is cooler and turns white, then blue, as it gets hotter. Betelgeuse looks orange-red at about 3,600 K; Rigel looks blue-white at about 12,000 K. The Sun, at about 5,800 K, gives out most light in the green-yellow, but together its colours look white from space.',
          'आग में लोहे के टुकड़े की तरह, तारा ठंडा हो तो लाल चमकता है और गर्म होने पर सफ़ेद, फिर नीला हो जाता है। आर्द्रा (Betelgeuse) लगभग 3,600 K पर नारंगी-लाल दिखता है; Rigel लगभग 12,000 K पर नीला-सफ़ेद। सूर्य, लगभग 5,800 K पर, सबसे ज़्यादा रोशनी हरे-पीले में देता है, पर अंतरिक्ष से उसके सारे रंग मिलकर सफ़ेद दिखते हैं।'),
        table([('Class', 'वर्ग'), ('Surface temperature', 'सतह का तापमान'), ('Colour', 'रंग')], cls_rows, cols=True),
        note('Astronomers remember the order O B A F G K M with the phrase "Oh Be A Fine Girl/Guy, Kiss Me". The Sun is a G star.', 'खगोलविद O B A F G K M का क्रम "Oh Be A Fine Girl/Guy, Kiss Me" वाक्य से याद रखते हैं। सूर्य एक G तारा है।'),
        H2('The HR diagram', 'HR diagram'),
        P('Around 1910, Ejnar Hertzsprung and Henry Norris Russell plotted stars by temperature and brightness and found they are not scattered randomly. Most fall on a band, the main sequence. Giants and supergiants sit above it, white dwarfs below. Tap a star to learn about it.',
          'लगभग 1910 में Ejnar Hertzsprung और Henry Norris Russell ने तारों को तापमान और चमक के हिसाब से बनाया और पाया कि वे बेतरतीब नहीं बिखरे। ज़्यादातर एक पट्टी पर हैं, main sequence। दानव और महादानव उसके ऊपर हैं, white dwarfs नीचे। किसी तारे पर tap कीजिए और उसके बारे में जानिए।'),
        f'<div class="hrwrap">{hr_svg()}<div class="hrcard card" id="hrCard"></div></div>',
        H2('How big can a star be?', 'तारा कितना बड़ा हो सकता है?'),
        P('Stars range from red dwarfs a little bigger than Jupiter to red supergiants that would swallow the orbit of Mars or even Jupiter. Here are real stars drawn to scale.',
          'तारे बृहस्पति से थोड़े बड़े लाल बौनों से लेकर ऐसे लाल महादानवों तक हैं जो मंगल या बृहस्पति की कक्षा तक को निगल लें। ये असली तारे सही अनुपात में बने हैं।'),
        f'<div style="margin:8px 0 14px">{sizes_svg()}</div>',
        callout('The biggest known stars, such as Stephenson 2-18 and UY Scuti, may be 900 to 2,000 times wider than the Sun. Their exact sizes are still uncertain, because their edges are fuzzy and their distances are hard to measure.',
                'सबसे बड़े ज्ञात तारे, जैसे Stephenson 2-18 और UY Scuti, सूर्य से 900 से 2,000 गुना चौड़े हो सकते हैं। उनका सही आकार अभी पक्का नहीं, क्योंकि उनके किनारे धुँधले हैं और उनकी दूरी नापना मुश्किल है।'),
    ) + S.pn(s)
    out.append(S.page(s, body + data_js + f'<script defer src="../assets/stars.js?v={V}"></script>', 'Star colours and sizes', 'तारों के रंग और आकार', 'Why stars have colours, the spectral classes O B A F G K M, an interactive Hertzsprung-Russell diagram, and real stars drawn to scale.'))

    # ---------------- 7 famous ----------------
    s = 'famous-stars'
    fam = ['sun', 'proxima', 'sirius', 'vega', 'aldebaran', 'spica', 'polaris', 'antares', 'betelgeuse', 'rigel']

    def ly(d):
        if d < 0.001:
            return ('8.3 light-minutes', '8.3 प्रकाश-मिनट')
        return (f'{d:,.4g} light-years', f'{d:,.4g} प्रकाश-वर्ष')

    cards = ''
    for sid in fam:
        st = BY[sid]
        de, dh = ly(st[3])
        cards += (f'<article class="card fstar" id="{sid}"><div class="fsdot" style="--c:{colour(st[4])}"></div><div><h3>{bt(st[1], st[2])}</h3><p class="note">{bt(st[8], st[9])}</p><p>{bt(st[10], st[11])}</p>'
                  f'<dl class="fsdl"><div><dt>{bt("Distance", "दूरी")}</dt><dd>{bt(de, dh)}</dd></div><div><dt>{bt("Surface", "सतह")}</dt><dd>{st[4]:,} K</dd></div>'
                  f'<div><dt>{bt("Width", "चौड़ाई")}</dt><dd>{bt(f"{st[5]:g} × Sun", f"{st[5]:g} × सूर्य")}</dd></div><div><dt>{bt("Brightness", "चमक")}</dt><dd>{bt(f"{st[6]:,g} × Sun", f"{st[6]:,g} × सूर्य")}</dd></div></dl></div></article>')
    body = S.head('Famous stars', 'मशहूर तारे', 'Ten stars worth knowing, with real numbers.', 'दस तारे जिन्हें जानना चाहिए, जहाँ हैं वहाँ भारतीय नामों के साथ।') + sec(
        f'<div class="fstars">{cards}</div>',
        note('Sizes and brightness of the supergiants are estimates; Betelgeuse in particular has published sizes between about 640 and 1,000 times the Sun.', 'महादानवों के आकार और चमक अनुमान हैं; ख़ासकर आर्द्रा (Betelgeuse) के प्रकाशित आकार सूर्य के लगभग 640 से 1,000 गुना के बीच हैं।'),
        H2('How to find them', 'इन्हें कैसे खोजें'),
        P('Start with Orion (Mriga in Indian astronomy), high in the evening sky from December to March. Red Betelgeuse is its left shoulder, blue Rigel its right foot. Follow the three belt stars down and left to Sirius, the brightest star of the night. Follow them up and right to orange Aldebaran (Rohini).',
          'मृग (Orion) से शुरू कीजिए, जो दिसंबर से मार्च तक शाम के आसमान में ऊँचा होता है। लाल आर्द्रा (Betelgeuse) इसका बायाँ कंधा है, नीला Rigel इसका दायाँ पैर। कमर के तीन तारों के साथ नीचे बाईं ओर चलिए तो लुब्धक (Sirius) मिलेगा, रात का सबसे चमकीला तारा। उनके साथ ऊपर दाईं ओर चलिए तो नारंगी रोहिणी (Aldebaran)।'),
        P('For Polaris, find the Saptarishi (Big Dipper) and follow its two pointer stars. The Constellations and Tonight’s sky pages show where each star is from your city right now.',
          'ध्रुव तारे के लिए सप्तर्षि खोजिए और उसके दो इशारा करने वाले तारों के साथ चलिए। नक्षत्र और आज रात का आसमान वाले pages दिखाते हैं कि आपके शहर से अभी हर तारा कहाँ है।'),
    ) + S.pn(s, last_link=('../black-holes.html', 'Black holes', 'ब्लैक होल'))
    out.append(S.page(s, body, 'Famous stars', 'मशहूर तारे', 'Famous stars with real numbers and Indian names: the Sun, Proxima Centauri, Sirius, Vega, Aldebaran, Spica, Polaris, Antares, Betelgeuse and Rigel, and how to find them.'))

    for p in out:
        h['write'](p['file'], p['html'])
    return [p['file'] for p in out]


# ---------- the life cycle player ----------
LIFE = {
    'low': [
        ('nebula', 'A cloud of gas and dust', 'गैस और धूल का बादल', 'A cold cloud, about minus 260 °C, starts to collapse.', 'माइनस 260 °C के आसपास का ठंडा बादल सिकुड़ने लगता है।', 'millions of years', 'लाखों साल'),
        ('proto', 'Protostar', 'Protostar (शिशु तारा)', 'A spinning, glowing ball heated by falling gas, inside a disk that may make planets.', 'गिरती गैस से गर्म होता, घूमता चमकता गोला, एक disk के अंदर जिससे ग्रह बन सकते हैं।', 'about 50 million years', 'लगभग 5 करोड़ साल'),
        ('main', 'Main-sequence star', 'Main-sequence तारा', 'Hydrogen fuses into helium in the core. This is the Sun today.', 'केंद्र में hydrogen जुड़कर helium बनती है। आज सूर्य यही है।', 'about 10 billion years', 'लगभग 10 अरब साल'),
        ('giant', 'Red giant', 'Red giant (लाल दानव)', 'The core runs out of hydrogen; the star swells more than 100 times wider.', 'केंद्र में hydrogen ख़त्म; तारा 100 गुना से ज़्यादा चौड़ा फूल जाता है।', 'about 1 billion years', 'लगभग 1 अरब साल'),
        ('pn', 'Planetary nebula', 'Planetary nebula', 'The outer layers drift away as a glowing shell.', 'बाहरी परतें चमकते खोल की तरह दूर चली जाती हैं।', 'about 10,000 to 20,000 years', 'लगभग 10,000 से 20,000 साल'),
        ('wd', 'White dwarf', 'White dwarf', 'An Earth-sized core that slowly cools for trillions of years.', 'पृथ्वी जितना केंद्र जो खरबों साल तक धीरे-धीरे ठंडा होता है।', 'trillions of years', 'खरबों साल'),
    ],
    'high': [
        ('nebula', 'A cloud of gas and dust', 'गैस और धूल का बादल', 'A big, dense part of a cloud collapses.', 'बादल का एक बड़ा, घना हिस्सा सिकुड़ता है।', 'millions of years', 'लाखों साल'),
        ('mainb', 'Blue main-sequence star', 'नीला main-sequence तारा', 'A hot, blue star burning its hydrogen thousands of times faster than the Sun.', 'गर्म, नीला तारा जो सूर्य से हज़ारों गुना तेज़ अपनी hydrogen जलाता है।', 'about 10 to 30 million years', 'लगभग 1 से 3 करोड़ साल'),
        ('sgiant', 'Red supergiant', 'Red supergiant (लाल महादानव)', 'Layers like an onion: helium, carbon, oxygen, silicon, and finally an iron core. Betelgeuse is here now.', 'प्याज़ जैसी परतें: helium, carbon, oxygen, silicon, और आख़िर में लोहे का केंद्र। आर्द्रा (Betelgeuse) अभी यहाँ है।', 'about 1 million years', 'लगभग 10 लाख साल'),
        ('sn', 'Supernova', 'Supernova', 'The iron core collapses in under a second and the star explodes.', 'लोहे का केंद्र एक सेकंड से कम में ढहता है और तारा फट जाता है।', 'weeks of brightness', 'हफ़्तों की चमक'),
        ('remnant', 'Supernova remnant', 'Supernova के अवशेष', 'An expanding cloud full of new elements, like the Crab Nebula.', 'नए तत्वों से भरा फैलता बादल, जैसे Crab Nebula।', 'tens of thousands of years', 'हज़ारों साल'),
        ('ns', 'Neutron star', 'Neutron star', 'A 20-km ball of neutrons, often a spinning pulsar.', 'Neutrons का 20 km का गोला, अक्सर घूमता pulsar।', 'billions of years', 'अरबों साल'),
    ],
    'huge': [
        ('nebula', 'A cloud of gas and dust', 'गैस और धूल का बादल', 'Only the biggest, densest clouds can make such stars.', 'सिर्फ़ सबसे बड़े, घने बादल ऐसे तारे बना सकते हैं।', 'millions of years', 'लाखों साल'),
        ('mainb', 'Blue giant', 'नीला दानव', 'Among the brightest stars there are, a million times the Sun.', 'सबसे चमकीले तारों में से, सूर्य से दस लाख गुना।', 'a few million years', 'कुछ लाख साल'),
        ('wr', 'Losing its skin', 'अपनी खाल उतारता', 'Fierce winds blow off its outer layers, like WR 124 seen by Webb.', 'तेज़ हवाएँ इसकी बाहरी परतें उड़ा देती हैं, जैसे Webb का देखा WR 124।', 'hundreds of thousands of years', 'लाखों साल'),
        ('sn', 'Supernova (or a direct collapse)', 'Supernova (या सीधा ढहना)', 'The core collapses. Some explode; some may fall in with hardly a flash.', 'केंद्र ढहता है। कुछ फटते हैं; कुछ शायद बिना किसी चमक के अंदर गिर जाते हैं।', 'seconds', 'सेकंड'),
        ('remnant', 'Expanding debris', 'फैलता मलबा', 'Whatever was thrown out spreads into space.', 'जो बाहर फेंका गया, वह अंतरिक्ष में फैल जाता है।', 'tens of thousands of years', 'हज़ारों साल'),
        ('bh', 'Black hole', 'ब्लैक होल', 'The core is too heavy for anything to hold up. Nothing, not even light, gets out.', 'केंद्र इतना भारी है कि कुछ भी उसे नहीं सँभाल सकता। कुछ भी, रोशनी तक, बाहर नहीं निकलती।', 'forever, almost', 'लगभग हमेशा'),
    ],
}


def data_js_life():
    return ('<script>window.ASTRYL_LIFE=' + json.dumps(LIFE, ensure_ascii=False).replace('</', '<\\/') + f';</script><script defer src="../assets/stars.js?v={V}"></script>')


def life_strip(bt, prefix):
    """A simple two-row picture of the two main paths, used on the hub."""
    def row(steps, path):
        items = ''.join(f'<li><span class="lsd ls-{st[0]}"></span><b>{bt(st[1], st[2])}</b></li>' for st in steps)
        return f'<ol class="lstrip">{items}</ol>'
    return (f'<p class="note">☀️ {bt("Stars like the Sun", "सूर्य जैसे तारे")}</p>' + row(LIFE['low'], 'low')
            + f'<p class="note">🔥 {bt("Stars of more than 8 Suns", "8 सूर्य से भारी तारे")}</p>' + row(LIFE['high'], 'high')
            + f'<p><a class="btn" href="{prefix}stars/life-of-a-star.html">⏳ {bt("Play it step by step", "क़दम-दर-क़दम चलाकर देखिए")} →</a></p>')
