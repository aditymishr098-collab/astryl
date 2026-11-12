"""Deep space pages of astryl.space: the black holes section (and, later, galaxies).

Every text is written twice (English, Hindi). The numbers are from NASA, ESA,
the Event Horizon Telescope and LIGO papers; the sizes in the table are worked
out here from the masses, not typed in.
"""

from dskit import Kit, article_ld

G = 6.674e-11        # m^3 kg^-1 s^-2
C = 299792458.0      # m/s
M_SUN = 1.989e30     # kg
AU_KM = 149597870.7


def horizon_radius_km(mass_kg):
    """Schwarzschild radius 2GM/c^2, in kilometres."""
    return 2 * G * mass_kg / C ** 2 / 1000


def build(h):
    """h: the helpers of build_site (bt, bi, shell, write, esc, fmt, SITE)."""
    bt, shell, write, esc, fmt = h['bt'], h['shell'], h['write'], h['esc'], h['fmt']
    pages = black_hole_pages(h)
    for p in pages:
        write(p['file'], p['html'])
    return [p['file'] for p in pages]


# ------------------------------------------------------------------ drawing
def anatomy_svg(bt):
    def lab(x, y, en, hi, anchor='start'):
        return (f'<text x="{x}" y="{y}" text-anchor="{anchor}" class="t" lang="en" style="fill:var(--text);font:600 14px DM Sans,sans-serif">{en}</text>'
                f'<text x="{x}" y="{y}" text-anchor="{anchor}" class="t" lang="hi" style="fill:var(--text);font:600 14px DM Sans,sans-serif">{hi}</text>')
    return f'''<svg class="bhart" viewBox="0 0 640 380" role="img" aria-label="A black hole with its accretion disk and two jets">
<defs>
<linearGradient id="bhDisk" x1="0" x2="1"><stop offset="0" stop-color="#ff7a1a" stop-opacity=".15"/><stop offset=".5" stop-color="#ffb347"/><stop offset="1" stop-color="#ff7a1a" stop-opacity=".15"/></linearGradient>
<linearGradient id="bhJetU" x1="0" y1="1" x2="0" y2="0"><stop offset="0" stop-color="#7db0ff" stop-opacity=".9"/><stop offset="1" stop-color="#7db0ff" stop-opacity="0"/></linearGradient>
<linearGradient id="bhJetD" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#7db0ff" stop-opacity=".9"/><stop offset="1" stop-color="#7db0ff" stop-opacity="0"/></linearGradient>
<radialGradient id="bhGlow"><stop offset=".45" stop-color="#ffb347" stop-opacity=".35"/><stop offset="1" stop-color="#ffb347" stop-opacity="0"/></radialGradient>
</defs>
<rect width="640" height="380" rx="18" fill="#05070f"/>
<path d="M320 190 L304 20 L336 20 Z" fill="url(#bhJetU)"/>
<path d="M320 190 L304 360 L336 360 Z" fill="url(#bhJetD)"/>
<circle cx="320" cy="190" r="92" fill="url(#bhGlow)"/>
<g fill="none" stroke="url(#bhDisk)">
<ellipse cx="320" cy="190" rx="250" ry="38" stroke-width="3" opacity=".5"/>
<ellipse cx="320" cy="190" rx="215" ry="32" stroke-width="7" opacity=".7"/>
<ellipse cx="320" cy="190" rx="175" ry="26" stroke-width="10"/>
<ellipse cx="320" cy="190" rx="135" ry="20" stroke-width="9"/>
<ellipse cx="320" cy="190" rx="100" ry="15" stroke-width="6"/>
</g>
<circle cx="320" cy="190" r="56" fill="#000" stroke="#ffd9a0" stroke-width="2" stroke-opacity=".85"/>
<g fill="none" stroke="url(#bhDisk)">
<path d="M70 190 A250 38 0 0 0 570 190" stroke-width="3" opacity=".5"/>
<path d="M105 190 A215 32 0 0 0 535 190" stroke-width="7" opacity=".7"/>
<path d="M145 190 A175 26 0 0 0 495 190" stroke-width="10"/>
<path d="M185 190 A135 20 0 0 0 455 190" stroke-width="9"/>
<path d="M220 190 A100 15 0 0 0 420 190" stroke-width="6"/>
</g>
<circle cx="320" cy="190" r="2.5" fill="#fff"/>
<g stroke="#8c9bb5" stroke-width="1" fill="none">
<path d="M375 150 L440 108"/><path d="M95 210 L60 262"/><path d="M322 40 L392 40"/><path d="M320 192 L250 290"/>
</g>
{lab(444, 112, 'Event horizon', 'Event horizon (घटना क्षितिज)')}
{lab(56, 282, 'Accretion disk', 'Accretion disk (गर्म गैस का चक्र)', 'start')}
{lab(398, 44, 'Jet', 'Jet (ऊर्जा की धारा)')}
{lab(244, 308, 'Singularity', 'Singularity (केंद्र)', 'end')}
</svg>'''


# ------------------------------------------------------------------ the pages
def black_hole_pages(h):
    bt, shell, esc, fmt, bi = h['bt'], h['shell'], h['esc'], h['fmt'], h['bi']
    k = Kit(h)
    raw2 = h['raw2']

    def P(en, hi):
        return f'<p>{bt(en, hi)}</p>'

    def H2(en, hi):
        return f'<h2>{bt(en, hi)}</h2>'

    def H3(en, hi):
        return f'<h3>{bt(en, hi)}</h3>'

    def callout(en, hi):
        return f'<div class="callout">{bt(en, hi)}</div>'

    def sec(*parts):
        return '<section class="blk prose">' + ''.join(parts) + '</section>'

    def card(title_en, title_hi, body_en, body_hi):
        return f'<div class="card"><h3>{bt(title_en, title_hi)}</h3><p>{bt(body_en, body_hi)}</p></div>'

    def facts(rows):
        """rows: [(label_en, label_hi, value_en, value_hi)]"""
        return '<div class="stats">' + ''.join(
            f'<div class="stat"><b>{bt(ve, vh)}</b><span>{bt(le, lh)}</span></div>' for le, lh, ve, vh in rows) + '</div>'

    SLUGS = [
        ('what-is-a-black-hole', 'What is a black hole?', 'ब्लैक होल क्या है?', 'The idea in plain words: gravity, escape speed and the point of no return.', 'सीधे शब्दों में: gravity, escape speed और वापसी का आख़िरी बिंदु।', '⚫'),
        ('how-black-holes-form', 'How black holes form', 'ब्लैक होल कैसे बनते हैं', 'Dying stars, giants in galaxy centres, and the middle sizes in between.', 'मरते तारे, galaxies के केंद्र के दानव, और बीच के आकार।', '💥'),
        ('event-horizon-and-singularity', 'Event horizon and singularity', 'Event horizon और singularity', 'How big a black hole is, what its edge is, and what sits at the centre.', 'ब्लैक होल कितना बड़ा है, उसका किनारा क्या है और केंद्र में क्या है।', '🎯'),
        ('falling-into-a-black-hole', 'Falling into a black hole', 'ब्लैक होल में गिरना', 'Stretching, slowing time, and what an astronaut would really notice.', 'खिंचाव, धीमा समय, और एक यात्री को सच में क्या महसूस होगा।', '🧑‍🚀'),
        ('famous-black-holes', 'Famous black holes', 'मशहूर ब्लैक होल', 'Sagittarius A*, M87*, Cygnus X-1, Gaia BH1, GW150914 and TON 618.', 'Sagittarius A*, M87*, Cygnus X-1, Gaia BH1, GW150914 और TON 618।', '🌟'),
        ('how-we-see-black-holes', 'How we see the invisible', 'अदृश्य को हम कैसे देखते हैं', 'Hot gas, orbiting stars, ripples in space and the first pictures.', 'गर्म गैस, चक्कर लगाते तारे, अंतरिक्ष की लहरें और पहली तस्वीरें।', '📡'),
        ('black-hole-myths-and-big-questions', 'Myths and big questions', 'भ्रम और बड़े सवाल', 'What is not true about black holes, and what nobody knows yet.', 'ब्लैक होल के बारे में क्या सच नहीं है, और क्या अभी कोई नहीं जानता।', '❓'),
    ]
    idx = {s[0]: i for i, s in enumerate(SLUGS)}

    def pn(slug):
        i = idx[slug]
        prev = SLUGS[i - 1] if i > 0 else None
        nxt = SLUGS[i + 1] if i + 1 < len(SLUGS) else None
        left = (f'<a class="btn" href="{prev[0]}.html">← {bt(prev[1], prev[2])}</a>' if prev
                else f'<a class="btn" href="../black-holes.html">← {bt("Black holes", "ब्लैक होल")}</a>')
        right = (f'<a class="btn primary" href="{nxt[0]}.html">{bt(nxt[1], nxt[2])} →</a>' if nxt
                 else f'<a class="btn primary" href="../deep-space-quiz.html">{bt("Take the quiz", "Quiz खेलिए")} →</a>')
        return f'<div class="pn">{left}{right}</div>'

    def head(slug, en, hi, lead_en, lead_hi):
        return (f'<p style="margin-top:20px"><a href="../black-holes.html">← {bt("Black holes", "ब्लैक होल")}</a></p>'
                f'<section class="blk"><h1>{bt(en, hi)}</h1><p class="sub">{bt(lead_en, lead_hi)}</p></section>')

    def page(slug, body, en, hi, desc):
        meta = next(s for s in SLUGS if s[0] == slug)
        rel = k.keep_exploring('../', [('black-hole-lab.html', '🧪', 'Black hole lab', 'ब्लैक होल lab'), ('black-holes-101.html', '🎓', 'Black holes 101', 'Black holes 101'), ('galaxies.html', '🌌', 'Galaxies', 'Galaxies'), ('glossary.html', '📖', 'Glossary', 'शब्दकोश')])
        body = body + rel
        path = f'black-holes/{slug}.html'
        ld = article_ld(h['SITE'], en, desc, path, [('Astryl', ''), ('Black holes', 'black-holes.html'), (en, path)])
        html = shell(en, hi, 'bh', body, desc, depth=1, canonical=path, ld=ld, extra_head=f'<script defer src="../assets/learn.js?v={h["asset_v"]()}"></script>')
        return {'file': f'black-holes/{slug}.html', 'html': html}

    out = []

    # ---- hub
    cards = ''.join(f'<a class="sc" href="black-holes/{s}.html"><span class="ic">{ic}</span><span><b>{bt(en, hi)}</b><small>{bt(de, dh)}</small></span><span class="go">→</span></a>'
                    for s, en, hi, de, dh, ic in SLUGS)
    hub = f'''<section class="hero2" style="padding-bottom:0">
<div><h1 class="rise">{bt("Black", "ब्लैक")} <span class="grad">{bt("holes.", "होल।")}</span></h1>
<p class="lead rise">{bt("The darkest objects in the universe, explained from the start. No maths needed, and every number comes from real measurements.", "ब्रह्मांड की सबसे अँधेरी चीज़ें, शुरू से समझाई हुई। गणित की ज़रूरत नहीं, और हर आँकड़ा असली माप से आया है।")}</p>
<div class="btns rise"><a class="btn primary" href="black-holes/what-is-a-black-hole.html">{bt("Start here", "यहाँ से शुरू करें")} →</a><a class="btn" href="black-holes/famous-black-holes.html">{bt("Famous black holes", "मशहूर ब्लैक होल")}</a><a class="btn" href="black-hole-lab.html">🧪 {bt("Black hole lab", "ब्लैक होल lab")}</a><a class="btn" href="black-holes-101.html">🎓 {bt("Black holes 101", "Black holes 101")}</a></div></div>
<div>{anatomy_svg(bt)}</div></section>
<section class="blk">{facts([
        ("Our Galaxy's black hole", 'हमारी आकाशगंगा का ब्लैक होल', '4.3 million Suns', '43 लाख सूरज के बराबर'),
        ('Distance to it', 'उसकी दूरी', '~26,000 light-years', '~26,000 प्रकाश-वर्ष'),
        ('First picture of one', 'पहली तस्वीर', 'April 2019 (M87*)', 'अप्रैल 2019 (M87*)'),
        ('Nearest known so far', 'अब तक का सबसे पास', '~1,600 light-years', '~1,600 प्रकाश-वर्ष'),
    ])}</section>
<section class="blk"><h2>{bt("Seven short pages", "सात छोटे पन्ने")}</h2><div class="sc-grid" style="padding-top:6px">{cards}</div></section>
<section class="blk callout"><b>{bt("Want to test yourself?", "खुद को परखना है?")}</b> {bt("Play the Daily 5 on the Quiz page, or the black hole and galaxy quiz.", "Quiz page पर Daily 5 खेलिए, या ब्लैक होल और galaxy वाली quiz।")} <a href="quiz.html">{bt("Quiz", "Quiz")} →</a></section>'''
    out.append({'file': 'black-holes.html', 'html': shell('Black holes explained', 'ब्लैक होल, आसान भाषा में', 'bh', hub,
                'Black holes explained simply: what they are, how they form, what happens if you fall in, the famous ones and how we photographed them. Free, in English and Hindi.',
                canonical='black-holes.html', ld=article_ld(h['SITE'], 'Black holes explained', 'Black holes explained simply: what they are, how they form, what happens if you fall in, the famous ones and how we photographed them.', 'black-holes.html', [('Astryl', ''), ('Black holes', 'black-holes.html')]))})

    # ---- 1. what is a black hole
    s = 'what-is-a-black-hole'
    body = head(s, 'What is a black hole?', 'ब्लैक होल क्या है?',
                'A place where gravity is so strong that nothing can get back out, not even light.',
                'ऐसी जगह जहाँ gravity इतनी तेज़ है कि कुछ भी वापस नहीं निकल सकता, रोशनी भी नहीं।') + sec(
        P('A black hole is not a hole in space. It is a lot of mass squeezed into a very small volume, so squeezed that its gravity becomes extreme close to it.',
          'ब्लैक होल अंतरिक्ष में कोई छेद नहीं है। यह बहुत थोड़ी जगह में दबाया हुआ बहुत सारा द्रव्यमान (mass) है, इतना दबा हुआ कि उसके बहुत पास gravity अत्यंत तेज़ हो जाती है।'),
        H2('The escape speed idea', 'Escape speed का विचार'),
        P('Every world has an escape speed: how fast you must go to leave it for good. From Earth it is about 11 km per second. Squeeze the same mass into a smaller and smaller ball and the escape speed keeps growing.',
          'हर दुनिया की एक escape speed होती है: उसे हमेशा के लिए छोड़ने के लिए कितनी तेज़ जाना पड़ेगा। पृथ्वी से यह लगभग 11 km प्रति सेकंड है। यही द्रव्यमान और छोटी गेंद में दबाते जाएँ तो escape speed बढ़ती जाती है।'),
        P('A black hole is a ball so small that the escape speed is more than the speed of light, about 300,000 km per second. Nothing can travel faster than light, so nothing that is inside can get out.',
          'ब्लैक होल इतनी छोटी गेंद है कि उसकी escape speed प्रकाश की गति से भी ज़्यादा है, लगभग 3,00,000 km प्रति सेकंड। कुछ भी प्रकाश से तेज़ नहीं चल सकता, इसलिए अंदर गया कुछ भी बाहर नहीं आ सकता।'),
        H2('Why “black”?', '“ब्लैक” क्यों?'),
        P('It gives off no light of its own, and light that falls in does not return. What we can see is the glow of hot gas around it and how it pulls on nearby stars.',
          'यह अपनी कोई रोशनी नहीं देता, और अंदर गिरी रोशनी लौटती नहीं। हमें जो दिखता है वह उसके आसपास की गर्म गैस की चमक है और यह कि वह पास के तारों को कैसे खींचता है।'),
        H2('The point of no return', 'वापसी का आख़िरी बिंदु'),
        P('The edge is called the event horizon. It is not a hard surface you could land on. It is a boundary in space. Outside it, a fast enough rocket can still escape. Inside it, every path leads inward.',
          'इस किनारे को event horizon (घटना क्षितिज) कहते हैं। यह कोई ठोस सतह नहीं है जिस पर उतरा जा सके। यह अंतरिक्ष में एक सीमा है। इसके बाहर काफ़ी तेज़ रॉकेट अब भी निकल सकता है। इसके अंदर हर रास्ता अंदर की ओर जाता है।'),
        callout('Black holes do not suck things in from far away. If the Sun were swapped for a black hole of the same mass, Earth would keep orbiting exactly as it does now, only in the dark and the cold. Gravity far away depends on mass, not on what the mass is made of.',
                'ब्लैक होल दूर से चीज़ें नहीं खींचते। अगर सूरज की जगह उतने ही द्रव्यमान का ब्लैक होल रख दिया जाए, तो पृथ्वी ठीक वैसे ही घूमती रहेगी जैसे अभी घूमती है, बस अँधेरे और ठंड में। दूर की gravity द्रव्यमान पर निर्भर है, इस पर नहीं कि वह द्रव्यमान किससे बना है।'),
        H2('Four words to remember', 'याद रखने के चार शब्द'),
        '<div class="grid">' + card('Event horizon', 'Event horizon', 'The boundary of the black hole. Cross it and you cannot come back.', 'ब्लैक होल की सीमा। इसे पार किया तो वापस नहीं आ सकते।')
        + card('Singularity', 'Singularity', 'The centre, where our theories say the mass is crushed to a point.', 'केंद्र, जहाँ हमारे सिद्धांतों के अनुसार द्रव्यमान एक बिंदु में कुचल जाता है।')
        + card('Accretion disk', 'Accretion disk', 'A flat whirl of hot gas that circles the black hole before falling in.', 'गर्म गैस का चपटा भँवर जो गिरने से पहले ब्लैक होल का चक्कर लगाता है।')
        + card('Solar mass', 'Solar mass (सूर्य द्रव्यमान)', 'The mass of the Sun. Black holes are measured in “Suns”.', 'सूरज का द्रव्यमान। ब्लैक होल को “सूरजों” में नापा जाता है।') + '</div>',
    ) + pn(s)
    out.append(page(s, body, 'What is a black hole?', 'ब्लैक होल क्या है?',
                    'What a black hole is, in plain words: gravity, escape speed, the event horizon and why nothing, not even light, can get out.'))

    # ---- 2. how they form
    s = 'how-black-holes-form'
    body = head(s, 'How black holes form', 'ब्लैक होल कैसे बनते हैं',
                'Some come from dying stars. Others sit in the middle of galaxies. There are also sizes in between.',
                'कुछ मरते तारों से बनते हैं। कुछ galaxies के बीच में बैठे हैं। बीच के आकार भी होते हैं।') + sec(
        H2('Stellar black holes', 'तारकीय (stellar) ब्लैक होल'),
        P('A star shines because fusion in its core pushes outward while gravity pulls inward. When a very massive star (roughly 20 or more times the Sun) runs out of fuel, its core collapses in a fraction of a second.',
          'तारा इसलिए चमकता है क्योंकि उसके केंद्र में fusion बाहर की ओर धक्का देता है और gravity अंदर की ओर खींचती है। जब बहुत भारी तारे (लगभग सूरज से 20 गुना या ज़्यादा) का ईंधन ख़त्म होता है, तो उसका केंद्र एक सेकंड के भी बहुत छोटे हिस्से में ढह जाता है।'),
        P('The outer layers may be blown away in a supernova. If the core left behind is heavy enough, nothing can stop it from collapsing further, and a black hole of a few to a few dozen Suns is born. Sometimes a star may collapse almost quietly, with hardly any explosion.',
          'बाहरी परतें supernova में उड़ सकती हैं। अगर बचा हुआ केंद्र काफ़ी भारी हो, तो उसे ढहने से कोई नहीं रोक सकता, और कुछ से लेकर कुछ दर्जन सूरजों के बराबर ब्लैक होल बन जाता है। कभी-कभी तारा लगभग चुपचाप भी ढह सकता है, बिना बड़े धमाके के।'),
        callout('The Sun will never become a black hole. It is too light. It will end its life as a white dwarf, a glowing ball about the size of Earth.',
                'सूरज कभी ब्लैक होल नहीं बनेगा। वह बहुत हल्का है। उसका अंत एक white dwarf के रूप में होगा, पृथ्वी जितनी बड़ी चमकती गेंद।'),
        H2('Supermassive black holes', 'विशाल (supermassive) ब्लैक होल'),
        P('Most large galaxies have a black hole in the middle with millions or even billions of Suns. How they grew so big so early in the universe is still being studied. They probably started as smaller seeds, swallowed gas, and merged with other black holes.',
          'ज़्यादातर बड़ी galaxies के बीच में लाखों या अरबों सूरज के बराबर ब्लैक होल होता है। ब्रह्मांड में इतनी जल्दी वे इतने बड़े कैसे हो गए, इस पर अब भी शोध चल रहा है। संभवतः वे छोटे बीजों से शुरू हुए, गैस निगली, और दूसरे ब्लैक होलों से मिलते गए।'),
        H2('The middle sizes', 'बीच के आकार'),
        P('Between the two lie intermediate black holes, roughly 100 to 100,000 Suns. They are hard to find. One strong sign was a merger seen in 2019 that left a black hole of about 140 Suns.',
          'दोनों के बीच intermediate ब्लैक होल आते हैं, लगभग 100 से 1,00,000 सूरज। इन्हें ढूँढना मुश्किल है। 2019 में देखे गए एक विलय (merger) ने लगभग 140 सूरज के बराबर ब्लैक होल छोड़ा, जो एक मज़बूत संकेत था।'),
        P('Some scientists also think tiny primordial black holes may have formed in the very early universe. None has been found. For now it is only an idea.',
          'कुछ वैज्ञानिक यह भी मानते हैं कि बहुत शुरुआती ब्रह्मांड में छोटे primordial ब्लैक होल बने हो सकते हैं। अभी तक कोई मिला नहीं है। फ़िलहाल यह सिर्फ़ एक विचार है।'),
        H2('Four kinds at a glance', 'चार प्रकार एक नज़र में'),
        '<table class="cmp"><tr><th>' + bt('Kind', 'प्रकार') + '</th><th>' + bt('Mass', 'द्रव्यमान') + '</th><th>' + bt('Example', 'उदाहरण') + '</th></tr>'
        + '<tr><td>' + bt('Stellar', 'तारकीय') + '</td><td>' + bt('a few to ~100 Suns', 'कुछ से ~100 सूरज') + '</td><td>' + bt('Cygnus X-1 (about 21 Suns)', 'Cygnus X-1 (लगभग 21 सूरज)') + '</td></tr>'
        + '<tr><td>' + bt('Intermediate', 'मध्यम') + '</td><td>' + bt('~100 to 100,000 Suns', '~100 से 1,00,000 सूरज') + '</td><td>' + bt('Candidates only', 'सिर्फ़ संभावित') + '</td></tr>'
        + '<tr><td>' + bt('Supermassive', 'विशाल') + '</td><td>' + bt('millions to billions of Suns', 'लाखों से अरबों सूरज') + '</td><td>' + bt('Sagittarius A* (4.3 million)', 'Sagittarius A* (43 लाख)') + '</td></tr>'
        + '<tr><td>' + bt('Primordial', 'आदिम (primordial)') + '</td><td>' + bt('unknown', 'अज्ञात') + '</td><td>' + bt('Not found', 'मिला नहीं') + '</td></tr></table>',
        P('Our own Galaxy probably holds tens of millions of stellar black holes or more. Most are invisible because they are quiet: nothing is falling into them.',
          'हमारी अपनी आकाशगंगा में शायद करोड़ों या उससे ज़्यादा तारकीय ब्लैक होल हैं। ज़्यादातर अदृश्य हैं क्योंकि वे शांत हैं: उनमें कुछ गिर नहीं रहा।'),
    ) + pn(s)
    out.append(page(s, body, 'How black holes form', 'ब्लैक होल कैसे बनते हैं',
                    'How stellar, intermediate and supermassive black holes form, and why the Sun will never become one.'))

    # ---- 3. event horizon and singularity (sizes computed)
    rows = [
        ('Earth', 'पृथ्वी', 5.972e24, '1 Earth mass', '1 पृथ्वी द्रव्यमान'),
        ('Jupiter', 'बृहस्पति', 1.898e27, '318 Earths', '318 पृथ्वी'),
        ('The Sun', 'सूरज', M_SUN, '1 Sun', '1 सूरज'),
        ('A 10-Sun black hole', '10 सूरज का ब्लैक होल', 10 * M_SUN, '10 Suns', '10 सूरज'),
        ('Sagittarius A*', 'Sagittarius A*', 4.3e6 * M_SUN, '4.3 million Suns', '43 लाख सूरज'),
        ('M87*', 'M87*', 6.5e9 * M_SUN, '6.5 billion Suns', '6.5 अरब सूरज'),
    ]

    def size_text(r_km, lg):
        if r_km < 1e-3:
            return f'{fmt(lg, r_km * 1e6, 1)} mm'
        if r_km < 1:
            return f'{fmt(lg, r_km * 1000, 1)} m'
        if r_km < 1e6:
            return f'{fmt(lg, r_km, 1)} km'
        if r_km < 1e9:
            return f'{fmt(lg, r_km / 1e6, 1)} ' + ('million km' if lg == 'en' else 'मिलियन km')
        return f'{fmt(lg, r_km / AU_KM, 0)} AU'

    trs = ''
    for en, hi, m, men, mhi in rows:
        r = horizon_radius_km(m)
        trs += f'<tr><td>{bt(en, hi)}</td><td>{bt(men, mhi)}</td><td class="w">{bt(size_text(r, "en"), size_text(r, "hi"))}</td></tr>'
    s = 'event-horizon-and-singularity'
    body = head(s, 'Event horizon and singularity', 'Event horizon और singularity',
                'How big a black hole is, what its edge really is, and what may sit at the centre.',
                'ब्लैक होल कितना बड़ा है, उसका किनारा असल में क्या है, और केंद्र में क्या हो सकता है।') + sec(
        H2('How big is the edge?', 'किनारा कितना बड़ा है?'),
        P('The size of the event horizon grows in a simple way with mass: about 3 km for every Sun of mass. Physicists write it r = 2GM/c², the Schwarzschild radius. The table shows what size each object would have if it were squeezed into a black hole.',
          'Event horizon का आकार द्रव्यमान के साथ सीधे बढ़ता है: हर एक सूरज के द्रव्यमान पर लगभग 3 km। भौतिकविद इसे r = 2GM/c² लिखते हैं, जिसे Schwarzschild radius कहते हैं। नीचे की table बताती है कि हर चीज़ को दबाकर ब्लैक होल बनाया जाए तो उसकी त्रिज्या कितनी होगी।'),
        '<table class="cmp cols"><tr><th>' + bt('Object', 'चीज़') + '</th><th>' + bt('Mass', 'द्रव्यमान') + '</th><th>' + bt('Horizon radius', 'Horizon की त्रिज्या') + '</th></tr>' + trs + '</table>',
        '<p class="note">' + bt('Worked out from r = 2GM/c². 1 AU is the distance from Earth to the Sun. The whole of Earth squeezed into a black hole would be about the size of a marble.', 'r = 2GM/c² से निकाला गया। 1 AU पृथ्वी से सूरज की दूरी है। पूरी पृथ्वी को दबाकर ब्लैक होल बनाएँ तो वह लगभग एक कंचे जितना होगा।') + '</p>',
        P('The horizon of Sagittarius A* would fit inside the orbit of Mercury. The horizon of M87* is about four times wider than the orbit of Neptune.',
          'Sagittarius A* का horizon बुध की कक्षा के अंदर समा जाएगा। M87* का horizon वरुण (Neptune) की कक्षा से लगभग चार गुना चौड़ा है।'),
        H2('Light can circle it', 'रोशनी इसका चक्कर लगा सकती है'),
        P('Gravity bends light so strongly that, at 1.5 times the horizon radius, light can travel in a circle around the black hole. This is why pictures from the Event Horizon Telescope show a bright ring around a dark centre. The dark “shadow” is about 2.6 times wider than the horizon itself.',
          'Gravity रोशनी को इतना मोड़ती है कि horizon की त्रिज्या से 1.5 गुना दूरी पर रोशनी ब्लैक होल के चारों ओर गोल चक्कर लगा सकती है। इसीलिए Event Horizon Telescope की तस्वीरों में गहरे केंद्र के चारों ओर चमकदार छल्ला दिखता है। गहरी “परछाईं” horizon से लगभग 2.6 गुना चौड़ी है।'),
        H2('The singularity', 'Singularity'),
        P('At the centre, Einstein’s theory of gravity (general relativity) says all the mass is squeezed into a single point of infinite density. Most physicists read that as a sign that the theory breaks down there. A full theory of quantum gravity is needed, and we do not have one yet. Nobody knows what is really at the centre.',
          'केंद्र में Einstein का gravity का सिद्धांत (general relativity) कहता है कि सारा द्रव्यमान अनंत घनत्व वाले एक बिंदु में दबा है। ज़्यादातर भौतिकविद इसे इस बात का संकेत मानते हैं कि वहाँ सिद्धांत टूट जाता है। पूरी quantum gravity की theory चाहिए, जो अभी हमारे पास नहीं है। केंद्र में असल में क्या है, यह कोई नहीं जानता।'),
        callout('A black hole is described by very few numbers: its mass, how fast it spins and its electric charge. Everything else about what fell in is lost to the outside.',
                'ब्लैक होल को बहुत कम संख्याओं से बताया जा सकता है: उसका द्रव्यमान, वह कितनी तेज़ घूमता है और उसका विद्युत आवेश। अंदर क्या गिरा था, उसकी बाक़ी सारी जानकारी बाहर वालों के लिए खो जाती है।'),
    ) + pn(s)
    out.append(page(s, body, 'Event horizon and singularity', 'Event horizon और singularity',
                    'How big a black hole is for any mass, what the event horizon and the photon ring are, and what the singularity means.'))

    # ---- 4. falling in
    s = 'falling-into-a-black-hole'
    body = head(s, 'Falling into a black hole', 'ब्लैक होल में गिरना',
                'The same fall looks very different to you and to someone watching from far away.',
                'वही गिरना आपको और दूर से देखने वाले को बहुत अलग दिखता है।') + sec(
        H2('Stretching', 'खिंचाव'),
        P('Gravity pulls harder on the part of you that is closer. Falling feet first, your feet are pulled harder than your head, and you are stretched. Scientists call it spaghettification.',
          'Gravity आपके उस हिस्से को ज़्यादा खींचती है जो पास होता है। पैरों के बल गिरते समय पैर सिर से ज़्यादा खिंचते हैं और आप लंबे खिंच जाते हैं। वैज्ञानिक इसे spaghettification कहते हैं।'),
        P('Near a black hole of about 10 Suns the stretching is deadly well before the horizon. Near a supermassive black hole like Sagittarius A* the horizon is so large that the stretching there is gentle: you could cross it without feeling anything special, and be torn apart only later, deeper inside.',
          '10 सूरज के आसपास वाले ब्लैक होल के पास horizon से बहुत पहले ही खिंचाव जानलेवा हो जाता है। Sagittarius A* जैसे विशाल ब्लैक होल का horizon इतना बड़ा है कि वहाँ खिंचाव हल्का होता है: आप बिना कुछ ख़ास महसूस किए उसे पार कर सकते हैं, और टुकड़े-टुकड़े बाद में, और अंदर जाकर होंगे।'),
        H2('Time', 'समय'),
        P('Seen from far away, a clock falling in ticks slower and slower, and its light turns redder and dimmer. The watcher never sees it cross the horizon. For the person falling, time feels normal and crossing the horizon is unremarkable. Both are true: time is not the same for everyone.',
          'दूर से देखें तो अंदर गिरती घड़ी धीमी और धीमी चलती दिखती है, और उसकी रोशनी और लाल और मद्धम होती जाती है। देखने वाला उसे horizon पार करते कभी नहीं देखता। गिरने वाले के लिए समय सामान्य चलता है और horizon पार करना कोई ख़ास बात नहीं। दोनों सच हैं: समय सबके लिए एक जैसा नहीं है।'),
        H2('A trip in five steps', 'पाँच चरणों की यात्रा'),
        '<div class="tl">'
        + '<div class="m"><div class="y">1</div><h3>' + bt('Approach', 'पास आना') + '</h3><p>' + bt('Light from behind the hole is bent. The sky looks warped around you.', 'ब्लैक होल के पीछे की रोशनी मुड़ती है। आपके चारों ओर आसमान टेढ़ा दिखता है।') + '</p></div>'
        + '<div class="m"><div class="y">2</div><h3>' + bt('Stretching', 'खिंचाव') + '</h3><p>' + bt('For a small black hole you are already being pulled apart here.', 'छोटे ब्लैक होल के लिए आप यहीं खिंचकर टूटने लगते हैं।') + '</p></div>'
        + '<div class="m"><div class="y">3</div><h3>' + bt('The horizon', 'Horizon') + '</h3><p>' + bt('You cross. No bump, no wall. But there is no way back, and no message can reach the outside.', 'आप पार करते हैं। न टक्कर, न दीवार। पर वापसी का कोई रास्ता नहीं, और बाहर कोई संदेश नहीं जा सकता।') + '</p></div>'
        + '<div class="m"><div class="y">4</div><h3>' + bt('Inside', 'अंदर') + '</h3><p>' + bt('Every direction you can move points toward the centre, like time itself flowing that way.', 'आप जिस भी दिशा में बढ़ें, वह केंद्र की ओर है, जैसे समय ख़ुद उसी ओर बह रहा हो।') + '</p></div>'
        + '<div class="m"><div class="y">5</div><h3>' + bt('The centre', 'केंद्र') + '</h3><p>' + bt('For Sagittarius A* the trip from the horizon to the centre takes about a minute. For a 10-Sun black hole it takes less than a thousandth of a second.', 'Sagittarius A* में horizon से केंद्र तक का सफ़र लगभग एक मिनट का है। 10 सूरज के ब्लैक होल में यह एक सेकंड के हज़ारवें हिस्से से भी कम है।') + '</p></div>'
        + '</div>',
        callout('This is what the equations of general relativity say. Nobody has ever gone near a black hole, and what really happens at the very centre is an open question.',
                'यह general relativity के समीकरणों का निष्कर्ष है। आज तक कोई ब्लैक होल के पास नहीं गया है, और ठीक केंद्र में सच में क्या होता है, यह खुला सवाल है।'),
    ) + pn(s)
    out.append(page(s, body, 'Falling into a black hole', 'ब्लैक होल में गिरना',
                    'What would happen if you fell into a black hole: spaghettification, time slowing down and crossing the event horizon.'))

    # ---- 5. famous
    s = 'famous-black-holes'
    fam = ''.join([
        '<div class="card"><h3>Sagittarius A*</h3>' + facts([
            ('Mass', 'द्रव्यमान', '4.3 million Suns', '43 लाख सूरज'), ('Distance', 'दूरी', '~26,000 light-years', '~26,000 प्रकाश-वर्ष')])
        + P('The black hole at the centre of our Galaxy. Stars orbit it; one of them, S2, goes round every 16 years. Its first picture was published in May 2022. The 2020 Nobel Prize in Physics honoured Reinhard Genzel and Andrea Ghez for showing it is there.',
            'हमारी आकाशगंगा के केंद्र का ब्लैक होल। तारे इसका चक्कर लगाते हैं; उनमें से S2 हर 16 साल में एक चक्कर पूरा करता है। इसकी पहली तस्वीर मई 2022 में आई। 2020 का भौतिकी का Nobel Prize Reinhard Genzel और Andrea Ghez को यह दिखाने के लिए मिला कि वह वहाँ है।') + '</div>',
        '<div class="card"><h3>M87*</h3>' + facts([
            ('Mass', 'द्रव्यमान', '6.5 billion Suns', '6.5 अरब सूरज'), ('Distance', 'दूरी', '~55 million light-years', '~5.5 करोड़ प्रकाश-वर्ष')])
        + P('In the giant galaxy Messier 87. On 10 April 2019 it became the first black hole ever pictured, by the Event Horizon Telescope. It fires a jet that stretches thousands of light-years.',
            'विशाल galaxy Messier 87 में। 10 अप्रैल 2019 को Event Horizon Telescope ने इसकी तस्वीर ली, जो किसी भी ब्लैक होल की पहली तस्वीर थी। यह हज़ारों प्रकाश-वर्ष लंबी jet छोड़ता है।') + '</div>',
        '<div class="card"><h3>Cygnus X-1</h3>' + facts([
            ('Mass', 'द्रव्यमान', 'about 21 Suns', 'लगभग 21 सूरज'), ('Distance', 'दूरी', '~7,000 light-years', '~7,000 प्रकाश-वर्ष')])
        + P('One of the first strong black hole candidates, from the early 1970s. In 1974 Stephen Hawking bet Kip Thorne that it was not a black hole. He conceded in 1990, once the evidence was overwhelming.',
            '1970 के दशक की शुरुआत में सामने आए पहले मज़बूत ब्लैक होल उम्मीदवारों में से एक। 1974 में Stephen Hawking ने Kip Thorne से शर्त लगाई कि यह ब्लैक होल नहीं है। सबूत पक्के होने पर उन्होंने 1990 में हार मान ली।') + '</div>',
        '<div class="card"><h3>Gaia BH1</h3>' + facts([
            ('Mass', 'द्रव्यमान', 'about 10 Suns', 'लगभग 10 सूरज'), ('Distance', 'दूरी', '~1,600 light-years', '~1,600 प्रकाश-वर्ष')])
        + P('The nearest known black hole so far, found in 2022 from the tiny wobble it causes in a Sun-like star that orbits it. It is quiet: nothing is falling in, so it gives off no X-rays.',
            'अब तक का सबसे नज़दीकी ज्ञात ब्लैक होल, जो 2022 में उस सूरज जैसे तारे की हल्की डगमगाहट से मिला जो इसका चक्कर लगाता है। यह शांत है: इसमें कुछ गिर नहीं रहा, इसलिए यह X-rays नहीं छोड़ता।') + '</div>',
        '<div class="card"><h3>GW150914</h3>' + facts([
            ('Merger', 'विलय', '36 + 29 Suns → 62 Suns', '36 + 29 सूरज → 62 सूरज'), ('Distance', 'दूरी', '~1.3 billion light-years', '~1.3 अरब प्रकाश-वर्ष')])
        + P('On 14 September 2015 LIGO felt the first gravitational waves ever detected, from two black holes merging. About three Suns of mass were turned into the energy of the waves. The 2017 Nobel Prize in Physics went to the LIGO founders.',
            '14 सितंबर 2015 को LIGO ने पहली बार गुरुत्वीय तरंगें पकड़ीं, जो दो ब्लैक होल के विलय से आई थीं। लगभग तीन सूरज का द्रव्यमान तरंगों की ऊर्जा में बदल गया। 2017 का भौतिकी का Nobel Prize LIGO के संस्थापकों को मिला।') + '</div>',
        '<div class="card"><h3>TON 618</h3>' + facts([
            ('Mass', 'द्रव्यमान', 'tens of billions of Suns', 'दसों अरब सूरज'), ('Distance', 'दूरी', 'billions of light-years', 'अरबों प्रकाश-वर्ष')])
        + P('One of the most massive black holes known. It powers a quasar, a young galaxy core so bright it outshines everything around it. Mass estimates vary between studies.',
            'अब तक ज्ञात सबसे भारी ब्लैक होलों में से एक। यह एक quasar को ऊर्जा देता है, किसी युवा galaxy का केंद्र जो इतना चमकीला है कि अपने आसपास सबको फीका कर देता है। अलग-अलग अध्ययनों में इसका द्रव्यमान अलग निकलता है।') + '</div>',
    ])
    body = head(s, 'Famous black holes', 'मशहूर ब्लैक होल',
                'Six black holes that changed what we know, from our own Galaxy to the far side of the universe.',
                'छह ब्लैक होल जिन्होंने हमारी समझ बदली, हमारी अपनी आकाशगंगा से ब्रह्मांड के दूर कोने तक।') + \
        f'<section class="blk"><div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(300px,1fr))">{fam}</div>' \
        f'<p class="note">{bt("Numbers are rounded from published measurements and some are still being refined.", "आँकड़े प्रकाशित मापों से गोल किए गए हैं और कुछ पर अब भी काम चल रहा है।")}</p></section>' + pn(s)
    out.append(page(s, body, 'Famous black holes', 'मशहूर ब्लैक होल',
                    'Sagittarius A*, M87*, Cygnus X-1, Gaia BH1, GW150914 and TON 618: mass, distance and why each one matters.'))

    # ---- 6. how we see
    s = 'how-we-see-black-holes'
    body = head(s, 'How we see the invisible', 'अदृश्य को हम कैसे देखते हैं',
                'A black hole gives off no light, so astronomers look for what it does to everything around it.',
                'ब्लैक होल कोई रोशनी नहीं देता, इसलिए खगोलविद यह देखते हैं कि वह अपने आसपास की हर चीज़ के साथ क्या करता है।') + sec(
        H2('Hot gas', 'गर्म गैस'),
        P('Gas that spirals in forms an accretion disk. Friction heats it to millions of degrees, so it glows brightly in X-rays. Around the biggest black holes this glow makes a quasar, which can outshine a whole galaxy.',
          'अंदर घूमकर गिरती गैस accretion disk बनाती है। घर्षण से वह लाखों डिग्री तक गर्म हो जाती है और X-rays में तेज़ चमकती है। सबसे बड़े ब्लैक होलों के आसपास यह चमक quasar बनाती है, जो पूरी galaxy से ज़्यादा चमकीला हो सकता है।'),
        H2('Jets', 'Jets'),
        P('Magnetic fields can launch some of the gas out in two narrow beams, along the spin axis, at nearly the speed of light. The jet of M87* is thousands of light-years long.',
          'चुंबकीय क्षेत्र कुछ गैस को घूर्णन अक्ष की दिशा में दो पतली धाराओं में लगभग प्रकाश की गति से बाहर फेंक सकते हैं। M87* की jet हज़ारों प्रकाश-वर्ष लंबी है।'),
        H2('Stars that dance', 'नाचते तारे'),
        P('For more than 25 years, astronomers tracked stars orbiting an invisible point at the centre of our Galaxy. Their paths showed something with 4.3 million Suns of mass in a tiny space. That is Sagittarius A*.',
          'पच्चीस साल से ज़्यादा तक खगोलविदों ने हमारी आकाशगंगा के केंद्र में एक अदृश्य बिंदु का चक्कर लगाते तारों को देखा। उनके रास्तों ने दिखाया कि एक बहुत छोटी जगह में 43 लाख सूरज का द्रव्यमान है। वही Sagittarius A* है।'),
        H2('Bent light', 'मुड़ती रोशनी'),
        P('Gravity bends light, so a black hole can act like a lens and distort or magnify what is behind it. This gravitational lensing also helps find hidden masses.',
          'Gravity रोशनी को मोड़ती है, इसलिए ब्लैक होल लेंस की तरह काम करके अपने पीछे की चीज़ों को तोड़-मरोड़ या बड़ा कर सकता है। इस gravitational lensing से छिपे द्रव्यमान भी ढूँढे जाते हैं।'),
        H2('Ripples in space', 'अंतरिक्ष की लहरें'),
        P('When two black holes merge, they shake space itself. Those gravitational waves reach Earth as a stretch smaller than a proton. Detectors like LIGO and Virgo measure it. The first was heard in 2015, and many more since.',
          'जब दो ब्लैक होल मिलते हैं, तो वे अंतरिक्ष को ही हिला देते हैं। ये गुरुत्वीय तरंगें पृथ्वी तक एक proton से भी छोटे खिंचाव के रूप में पहुँचती हैं। LIGO और Virgo जैसे detector इसे नापते हैं। पहली तरंग 2015 में सुनी गई, और उसके बाद बहुत सी।'),
        H2('The first pictures', 'पहली तस्वीरें'),
        P('The Event Horizon Telescope links radio telescopes around the world so they work like one telescope as big as Earth. It pictured M87* in 2019 and Sagittarius A* in 2022.',
          'Event Horizon Telescope दुनिया भर के radio telescopes को जोड़ता है ताकि वे पृथ्वी जितने बड़े एक telescope की तरह काम करें। उसने 2019 में M87* और 2022 में Sagittarius A* की तस्वीर ली।'),
        callout('What the pictures show is not the black hole itself but its dark shadow and the ring of glowing gas around it. The orange colour is added to show how bright each part is.',
                'तस्वीरों में ब्लैक होल ख़ुद नहीं, उसकी गहरी परछाईं और उसके चारों ओर चमकती गैस का छल्ला दिखता है। नारंगी रंग यह दिखाने के लिए जोड़ा गया है कि कौन सा हिस्सा कितना चमकीला है।'),
    ) + pn(s)
    out.append(page(s, body, 'How we see black holes', 'हम ब्लैक होल को कैसे देखते हैं',
                    'How astronomers find black holes that give off no light: hot gas, jets, orbiting stars, gravitational waves and the Event Horizon Telescope.'))

    # ---- 7. myths and big questions
    s = 'black-hole-myths-and-big-questions'

    def myth(en, hi, ans_en, ans_hi):
        return f'<div class="card"><h3>✗ {bt(en, hi)}</h3><p>{bt(ans_en, ans_hi)}</p></div>'
    body = head(s, 'Myths and big questions', 'भ्रम और बड़े सवाल',
                'Five things that are not true about black holes, and the questions nobody can answer yet.',
                'ब्लैक होल के बारे में पाँच बातें जो सच नहीं हैं, और वे सवाल जिनका जवाब अभी किसी के पास नहीं।') + sec(
        H2('Myths', 'भ्रम'),
        '<div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(280px,1fr))">'
        + myth('Black holes are cosmic vacuum cleaners', 'ब्लैक होल ब्रह्मांडीय vacuum cleaner हैं', 'Far away, a black hole pulls like any object of the same mass. Only very close does its gravity become extreme.', 'दूर से ब्लैक होल उतने ही द्रव्यमान की किसी भी चीज़ जैसा खींचता है। बहुत पास पहुँचकर ही उसकी gravity अत्यंत तेज़ होती है।')
        + myth('The Sun will become a black hole', 'सूरज ब्लैक होल बन जाएगा', 'The Sun is too light. It will end as a white dwarf.', 'सूरज बहुत हल्का है। उसका अंत white dwarf के रूप में होगा।')
        + myth('A black hole is a hole', 'ब्लैक होल एक छेद है', 'It is an object with a great deal of mass, and a region around it, not an empty hole.', 'यह बहुत ज़्यादा द्रव्यमान वाली चीज़ और उसके आसपास का क्षेत्र है, ख़ाली छेद नहीं।')
        + myth('One could swallow Earth soon', 'कोई जल्द ही पृथ्वी को निगल सकता है', 'The nearest known black hole is about 1,600 light-years away. No known black hole is anywhere near us.', 'सबसे नज़दीकी ज्ञात ब्लैक होल लगभग 1,600 प्रकाश-वर्ष दूर है। कोई ज्ञात ब्लैक होल हमारे आसपास नहीं है।')
        + myth('Particle colliders will make dangerous ones', 'Particle collider ख़तरनाक ब्लैक होल बना देंगे', 'Cosmic rays with far more energy than any collider have hit Earth for billions of years, and nothing has happened.', 'किसी भी collider से कहीं ज़्यादा ऊर्जा वाली cosmic rays अरबों सालों से पृथ्वी से टकरा रही हैं, और कुछ नहीं हुआ।')
        + '</div>',
        H2('Hawking radiation', 'Hawking radiation'),
        P('In 1974 Stephen Hawking showed that quantum effects make a black hole give off a very faint heat. The bigger the black hole, the colder it is. A black hole with the mass of the Sun would be about 60 billionths of a degree above absolute zero, colder than the 2.7 degrees of space itself, so today it takes in more than it gives out.',
          '1974 में Stephen Hawking ने दिखाया कि quantum प्रभावों से ब्लैक होल बहुत हल्की गर्मी छोड़ता है। ब्लैक होल जितना बड़ा, उतना ठंडा। सूरज के द्रव्यमान वाला ब्लैक होल absolute zero से सिर्फ़ लगभग 60 अरबवाँ डिग्री ऊपर होगा, यानी अंतरिक्ष के 2.7 डिग्री से भी ठंडा, इसलिए आज वह जितना छोड़ता है उससे ज़्यादा लेता है।'),
        P('Evaporating such a black hole would take far longer than the age of the universe, about 13.8 billion years. Hawking radiation has never been observed. It is a prediction from theory.',
          'ऐसे ब्लैक होल के भाप बनकर ख़त्म होने में ब्रह्मांड की उम्र, लगभग 13.8 अरब साल, से कहीं ज़्यादा समय लगेगा। Hawking radiation कभी देखी नहीं गई है। यह सिद्धांत की भविष्यवाणी है।'),
        H2('Questions still open', 'जो सवाल अभी खुले हैं'),
        '<div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(260px,1fr))">'
        + card('What is at the centre?', 'केंद्र में क्या है?', 'We need a theory that joins gravity and quantum physics.', 'हमें ऐसी theory चाहिए जो gravity और quantum भौतिकी को जोड़े।')
        + card('Where does the information go?', 'जानकारी कहाँ जाती है?', 'If a black hole evaporates, what happens to everything that fell in? This is the information paradox.', 'अगर ब्लैक होल भाप बनकर ख़त्म हो जाए, तो जो कुछ उसमें गिरा था उसका क्या होता है? इसे information paradox कहते हैं।')
        + card('How did giants grow so fast?', 'दानव इतनी जल्दी कैसे बढ़े?', 'Huge black holes already existed when the universe was under a billion years old.', 'ब्रह्मांड की उम्र एक अरब साल से कम थी तब भी विशाल ब्लैक होल मौजूद थे।')
        + card('Are wormholes real?', 'क्या wormhole असली हैं?', 'They appear in the equations, but there is no evidence they exist.', 'वे समीकरणों में आते हैं, पर उनके होने का कोई सबूत नहीं है।')
        + '</div>',
    ) + pn(s)
    out.append(page(s, body, 'Black hole myths and big questions', 'ब्लैक होल के भ्रम और बड़े सवाल',
                    'Five black hole myths, what Hawking radiation is, and the big questions that are still open.'))
    return out
