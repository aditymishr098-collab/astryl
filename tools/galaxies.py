"""The Galaxies section of astryl.space (English and Hindi).

Numbers are from NASA, ESA and published surveys; travel times and unit
conversions are worked out here from the distances, not typed in.
"""
import math
import random

from dskit import Kit, Section, article_ld

LY_KM = 9.4607e12          # kilometres in one light-year
VOYAGER_KMS = 17.0         # Voyager 1, km per second (about 61,000 km/h)
YEAR_S = 365.25 * 86400


def _bil(x, y, en, hi, anchor='start', size=14):
    st = f'fill:var(--text);font:600 {size}px DM Sans,sans-serif'
    return (f'<text x="{x}" y="{y}" text-anchor="{anchor}" class="t" lang="en" style="{st}">{en}</text>'
            f'<text x="{x}" y="{y}" text-anchor="{anchor}" class="t" lang="hi" style="{st}">{hi}</text>')


def milky_way_svg():
    cx, cy = 300, 205
    b = math.tan(math.radians(12))
    arms = ''
    cols = ['#7db0ff', '#a98bff', '#7db0ff', '#a98bff']
    for k in range(4):
        pts = []
        th = 0.0
        while th < 6.1:
            r = 52 * math.exp(b * th)
            a = th + k * math.pi / 2 + 0.4
            pts.append((cx + r * math.cos(a), cy + r * math.sin(a) * 0.62))
            th += 0.12
        d = 'M' + ' L'.join(f'{x:.1f} {y:.1f}' for x, y in pts)
        arms += f'<path d="{d}" fill="none" stroke="{cols[k]}" stroke-width="13" stroke-opacity=".16" stroke-linecap="round"/>'
        arms += f'<path d="{d}" fill="none" stroke="{cols[k]}" stroke-width="4" stroke-opacity=".45" stroke-linecap="round"/>'
    rnd = random.Random(7)
    dots = ''
    for _ in range(220):
        r = 190 * math.sqrt(rnd.random())
        a = rnd.random() * 2 * math.pi
        dots += f'<circle cx="{cx + r * math.cos(a):.1f}" cy="{cy + r * math.sin(a) * 0.62:.1f}" r="{rnd.choice((.6, .9, 1.2)):.1f}" fill="#fff" fill-opacity="{rnd.uniform(.25, .8):.2f}"/>'
    sx, sy = cx + 99 * math.cos(math.radians(100)), cy + 99 * math.sin(math.radians(100)) * 0.62
    return f'''<svg class="bhart" viewBox="0 0 640 410" role="img" aria-label="Top view of the Milky Way with its bar, spiral arms and the Sun">
<defs><radialGradient id="mwCore"><stop offset="0" stop-color="#ffe2a6" stop-opacity=".95"/><stop offset=".5" stop-color="#ffb347" stop-opacity=".35"/><stop offset="1" stop-color="#ffb347" stop-opacity="0"/></radialGradient></defs>
<rect width="640" height="410" rx="18" fill="#05070f"/>
{dots}{arms}
<ellipse cx="{cx}" cy="{cy}" rx="62" ry="17" transform="rotate(-22 {cx} {cy})" fill="url(#mwCore)"/>
<circle cx="{cx}" cy="{cy}" r="4" fill="#fff"/>
<circle cx="{sx:.1f}" cy="{sy:.1f}" r="5" fill="#ffd34d" stroke="#fff" stroke-width="1.5"/>
<g stroke="#8c9bb5" stroke-width="1" fill="none"><path d="M{cx + 6} {cy - 8} L430 70"/><path d="M{sx + 7:.1f} {sy + 2:.1f} L400 330"/><path d="M{cx - 40} {cy + 10} L110 120"/></g>
{_bil(430, 66, 'Centre (Sagittarius A*)', 'केंद्र (Sagittarius A*)')}
{_bil(372, 340, 'The Sun, 26,000 light-years out', 'सूर्य, 26,000 प्रकाश-वर्ष दूर')}
{_bil(22, 112, 'Central bar', 'केंद्रीय bar')}
<line x1="105" y1="392" x2="495" y2="392" stroke="#8c9bb5" stroke-width="1"/><path d="M105 387 V397 M495 387 V397" stroke="#8c9bb5"/>
{_bil(300, 386, '~100,000 light-years across', '~1,00,000 प्रकाश-वर्ष चौड़ी', 'middle', 13)}
</svg>'''


def indian(n):
    s = f'{int(n)}'
    if len(s) <= 3:
        return s
    head, tail = s[:-3], s[-3:]
    parts = []
    while len(head) > 2:
        parts.insert(0, head[-2:])
        head = head[:-2]
    if head:
        parts.insert(0, head)
    return ','.join(parts + [tail])


def build(h):
    k = Kit(h)
    bt = k.bt
    P, H2, callout, sec, card, grid, facts, table, note = k.P, k.H2, k.callout, k.sec, k.card, k.grid, k.facts, k.table, k.note
    fmt = k.fmt

    SLUGS = [
        ('what-is-a-galaxy', 'What is a galaxy?', 'Galaxy (मंदाकिनी) क्या है?', 'Stars, gas, dust and dark matter held together by gravity.', 'तारे, गैस, धूल और dark matter, जो gravity से बँधे हैं।', '🌌'),
        ('the-milky-way', 'The Milky Way', 'हमारी आकाशगंगा', 'Our home: a barred spiral with hundreds of billions of stars.', 'हमारा घर: सैकड़ों अरब तारों वाली barred spiral।', '🌀'),
        ('andromeda-galaxy', 'The Andromeda Galaxy', 'देवयानी (Andromeda) galaxy', 'Our big neighbour, and the collision coming in billions of years.', 'हमारा बड़ा पड़ोसी, और अरबों साल बाद आने वाली टक्कर।', '🔭'),
        ('types-of-galaxies', 'Types of galaxies', 'Galaxies के प्रकार', 'Spiral, barred, elliptical, lenticular, irregular and dwarf.', 'Spiral, barred, elliptical, lenticular, irregular और बौनी galaxies।', '🧩'),
        ('the-local-group', 'The Local Group and beyond', 'Local Group और उसके आगे', 'Our neighbourhood of galaxies, clusters and the cosmic web.', 'Galaxies, clusters और cosmic web में हमारा मोहल्ला।', '🏘️'),
        ('galaxy-formation-and-collisions', 'Formation and collisions', 'बनना और टकराना', 'How galaxies grew from the first ones, and what happens when they meet.', 'पहली galaxies से वे कैसे बढ़ीं, और मिलने पर क्या होता है।', '💫'),
        ('galaxies-you-can-see', 'Galaxies you can see', 'जो galaxies आप देख सकते हैं', 'What your eyes, binoculars and a small telescope can reach.', 'आपकी आँखें, दूरबीन और छोटा telescope कहाँ तक पहुँचते हैं।', '👀'),
    ]
    S = Section(k, 'galaxies', 'galaxies.html', 'gx', 'Galaxies', 'Galaxies', SLUGS)
    REL = [('cosmic-scale.html', '📏', 'Scale of the universe', 'ब्रह्मांड का पैमाना'), ('universe-timeline.html', '⏳', 'Timeline of the universe', 'ब्रह्मांड की समयरेखा'), ('black-holes.html', '⚫', 'Black holes', 'ब्लैक होल'), ('deep-space-quiz.html#galaxies', '🎲', 'Galaxy quiz', 'Galaxy quiz')]
    _page = S.page
    S.page = lambda *a, **kw: _page(*a, related=REL, **kw)
    out = []

    # ---- hub
    hub = f'''<section class="hero2" style="padding-bottom:0">
<div><h1 class="rise">{bt("Cities of", "तारों के")} <span class="grad">{bt("stars.", "शहर।")}</span></h1>
<p class="lead rise">{bt("Galaxies are the great cities of stars. Start with our own, meet our neighbour Andromeda, and see how far the rest are. Every number comes from real measurements.", "Galaxies तारों के विशाल शहर हैं। अपनी आकाशगंगा से शुरू कीजिए, पड़ोसी Andromeda से मिलिए, और देखिए बाक़ी कितनी दूर हैं। हर आँकड़ा असली माप से आया है।")}</p>
<div class="btns rise"><a class="btn primary" href="galaxies/the-milky-way.html">{bt("Our Milky Way", "हमारी आकाशगंगा")} →</a><a class="btn" href="galaxies/what-is-a-galaxy.html">{bt("What is a galaxy?", "Galaxy क्या है?")}</a><a class="btn" href="deep-space-quiz.html#galaxies">🎲 {bt("Galaxy quiz", "Galaxy quiz")}</a></div></div>
<div>{milky_way_svg()}</div></section>
<section class="blk">{facts([
        ('Stars in the Milky Way', 'आकाशगंगा में तारे', '100 to 400 billion', '100 से 400 अरब'),
        ('Nearest big galaxy', 'सबसे पास की बड़ी galaxy', 'Andromeda, 2.5 million light-years', 'Andromeda, 25 लाख प्रकाश-वर्ष'),
        ('Galaxies we can count', 'गिनी जा सकने वाली galaxies', 'about 2 trillion', 'लगभग 2 खरब'),
        ('Farthest seen so far', 'अब तक की सबसे दूर', '~290 million years after the Big Bang', 'Big Bang के लगभग 29 करोड़ साल बाद'),
    ])}</section>
<section class="blk"><h2>{bt("Seven short pages", "सात छोटे पन्ने")}</h2><div class="sc-grid" style="padding-top:6px">{S.cards()}</div></section>
<section class="blk callout"><b>{bt("Next:", "आगे:")}</b> {bt("Learn about the objects that sit in the middle of most galaxies.", "उन चीज़ों के बारे में जानिए जो ज़्यादातर galaxies के बीच में बैठी हैं।")} <a href="black-holes.html">{bt("Black holes", "ब्लैक होल")} →</a></section>'''
    out.append({'file': 'galaxies.html', 'html': shell_hub(h, hub)})

    # ---- 1 what is a galaxy
    s = 'what-is-a-galaxy'
    body = S.head('What is a galaxy?', 'Galaxy (मंदाकिनी) क्या है?', 'A huge family of stars, gas, dust and dark matter, all held together by gravity.', 'तारों, गैस, धूल और dark matter का विशाल परिवार, जो gravity से बँधा है।') + sec(
        P('Space is mostly empty. The stars you see at night are not spread evenly: they come in giant islands called galaxies. Every star you can see with your eyes belongs to our own, the Milky Way.',
          'अंतरिक्ष ज़्यादातर ख़ाली है। रात में दिखने वाले तारे समान रूप से फैले नहीं हैं: वे galaxies नाम के विशाल द्वीपों में हैं। आँखों से दिखने वाला हर तारा हमारी अपनी आकाशगंगा (Milky Way) का है।'),
        H2('What is inside', 'अंदर क्या है'),
        '<div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(220px,1fr))">'
        + card('Stars and planets', 'तारे और ग्रह', 'From millions to trillions of stars, many with planets.', 'लाखों से खरबों तारे, कई के अपने ग्रह।')
        + card('Gas and dust', 'गैस और धूल', 'The material new stars are born from.', 'वह सामग्री जिससे नए तारे बनते हैं।')
        + card('A black hole', 'एक ब्लैक होल', 'Most large galaxies have a supermassive one at the centre.', 'ज़्यादातर बड़ी galaxies के केंद्र में एक विशाल ब्लैक होल होता है।')
        + card('Dark matter', 'Dark matter', 'Invisible matter that gives about five times more gravity than all the normal matter. We only see its pull.', 'अदृश्य द्रव्य जो सामान्य द्रव्य से लगभग पाँच गुना ज़्यादा gravity देता है। हम सिर्फ़ उसका खिंचाव देखते हैं।')
        + '</div>',
        H2('How big, how many', 'कितनी बड़ी, कितनी सारी'),
        P('Galaxies range from dwarfs with a few thousand stars to giants with trillions. The Milky Way is about 100,000 light-years across. A light-year is the distance light travels in one year, about 9.5 trillion km.',
          'Galaxies कुछ हज़ार तारों वाली बौनी से लेकर खरबों तारों वाली दानव तक होती हैं। आकाशगंगा लगभग 1,00,000 प्रकाश-वर्ष चौड़ी है। एक प्रकाश-वर्ष वह दूरी है जो प्रकाश एक साल में तय करता है, लगभग 9.5 खरब km।'),
        P('Deep images from the Hubble and James Webb telescopes show that the observable universe holds roughly two trillion galaxies. This is an estimate that is still being refined.',
          'Hubble और James Webb telescope की गहरी तस्वीरें बताती हैं कि दिखने योग्य ब्रह्मांड में लगभग दो खरब galaxies हैं। यह एक अनुमान है जिस पर अब भी काम चल रहा है।'),
        callout('Before 1924 many astronomers thought the Milky Way was the whole universe. Edwin Hubble then measured the distance to Andromeda and showed it was a separate galaxy, far outside ours.',
                '1924 से पहले कई खगोलविद मानते थे कि आकाशगंगा ही पूरा ब्रह्मांड है। फिर Edwin Hubble ने Andromeda की दूरी नापी और दिखाया कि वह हमारी आकाशगंगा से बहुत बाहर एक अलग galaxy है।'),
    ) + S.pn(s)
    out.append(S.page(s, body, 'What is a galaxy?', 'Galaxy क्या है?', 'What a galaxy is: stars, gas, dust, a central black hole and dark matter. How big they are and how many there are.'))

    # ---- 2 milky way
    s = 'the-milky-way'
    body = S.head('The Milky Way', 'हमारी आकाशगंगा', 'Our home galaxy, seen from the inside.', 'हमारी अपनी galaxy, जिसे हम अंदर से देखते हैं।') + sec(
        f'<div style="margin:6px 0 18px">{milky_way_svg()}</div>',
        facts([('Width of the disk', 'Disk की चौड़ाई', '~100,000 light-years', '~1,00,000 प्रकाश-वर्ष'),
               ('Stars', 'तारे', '100 to 400 billion', '100 से 400 अरब'),
               ('Sun’s distance from the centre', 'सूर्य की केंद्र से दूरी', '~26,000 light-years', '~26,000 प्रकाश-वर्ष'),
               ('One Sun orbit takes', 'सूर्य का एक चक्कर', '~225 to 250 million years', '~22.5 से 25 करोड़ साल')]),
        H2('The shape', 'आकार'),
        P('The Milky Way is a barred spiral galaxy: a flat disk with a bar of stars across the middle and spiral arms winding out of its ends. The disk is only about 1,000 light-years thick, so it is far wider than it is tall. A faint halo of old stars and dark matter surrounds it.',
          'आकाशगंगा एक barred spiral galaxy है: एक चपटी disk जिसके बीच में तारों की bar है और उसके सिरों से spiral भुजाएँ निकलती हैं। Disk सिर्फ़ लगभग 1,000 प्रकाश-वर्ष मोटी है, यानी वह ऊँचाई से कहीं ज़्यादा चौड़ी है। पुराने तारों और dark matter का हल्का halo उसे घेरे है।'),
        H2('Where we are', 'हम कहाँ हैं'),
        P('The Sun is about two thirds of the way out from the centre, on a small branch between two big arms called the Orion Spur. We circle the centre at roughly 220 km per second. One lap takes about 230 million years, so the Sun has made around 20 laps since it was born.',
          'सूर्य केंद्र से लगभग दो-तिहाई दूरी पर है, दो बड़ी भुजाओं के बीच की एक छोटी शाखा पर, जिसे Orion Spur कहते हैं। हम केंद्र का चक्कर लगभग 220 km प्रति सेकंड की गति से लगाते हैं। एक चक्कर में लगभग 23 करोड़ साल लगते हैं, यानी सूर्य के जन्म से अब तक लगभग 20 चक्कर हुए हैं।'),
        H2('Why we see a band', 'हमें पट्टी क्यों दिखती है'),
        P('From inside the disk we look along it, so its stars pile up into a pale band across the night sky. That band is the Milky Way. The dark patches in it are dust clouds that block the light behind them.',
          'Disk के अंदर से हम उसी के साथ-साथ देखते हैं, इसलिए उसके तारे रात के आसमान में हल्की पट्टी बना देते हैं। वही पट्टी Milky Way है। उसमें दिखते गहरे धब्बे धूल के बादल हैं जो पीछे की रोशनी रोक लेते हैं।'),
        H2('The middle', 'बीच का हिस्सा'),
        P('At the centre sits Sagittarius A*, a black hole of 4.3 million Suns. Dust hides the centre in visible light, so astronomers use infrared and radio telescopes to look through it.',
          'केंद्र में Sagittarius A* है, 43 लाख सूरज वाला ब्लैक होल। दिखने वाली रोशनी में धूल केंद्र को छिपा देती है, इसलिए खगोलविद infrared और radio telescopes से उसके आर-पार देखते हैं।'),
        callout('Most of the Milky Way’s mass is not stars. The total of about 1.5 trillion Suns is mostly dark matter, which we know only from how it pulls on stars and gas.',
                'आकाशगंगा का ज़्यादातर द्रव्यमान तारे नहीं हैं। लगभग 1.5 खरब सूरज का कुल द्रव्यमान ज़्यादातर dark matter है, जिसे हम सिर्फ़ तारों और गैस पर उसके खिंचाव से जानते हैं।'),
    ) + S.pn(s)
    out.append(S.page(s, body, 'The Milky Way', 'हमारी आकाशगंगा', 'The Milky Way galaxy: its shape, size, number of stars, where the Sun is, and why we see a band across the night sky.'))

    # ---- 3 andromeda
    s = 'andromeda-galaxy'
    body = S.head('The Andromeda Galaxy', 'देवयानी (Andromeda) galaxy', 'The nearest big galaxy, and the one that will one day merge with ours.', 'सबसे पास की बड़ी galaxy, जो एक दिन हमारी galaxy से मिल जाएगी।') + sec(
        facts([('Distance', 'दूरी', '~2.5 million light-years', '~25 लाख प्रकाश-वर्ष'),
               ('Stars', 'तारे', 'about 1 trillion', 'लगभग 1 खरब'),
               ('Width of the disk', 'Disk की चौड़ाई', '~150,000 light-years', '~1,50,000 प्रकाश-वर्ष'),
               ('Catalogue names', 'सूची के नाम', 'Messier 31, M31', 'Messier 31, M31')]),
        P('Andromeda is a spiral galaxy in the constellation Andromeda. It is larger than the Milky Way and has more stars, though the Milky Way may hold more dark matter. It is the farthest thing most people can see with the naked eye.',
          'Andromeda, Andromeda तारामंडल की एक spiral galaxy है। यह आकाशगंगा से बड़ी है और इसमें तारे ज़्यादा हैं, हालाँकि आकाशगंगा में dark matter शायद ज़्यादा है। ज़्यादातर लोग नंगी आँखों से जो सबसे दूर की चीज़ देख सकते हैं, वह यही है।'),
        H2('Light from the past', 'अतीत की रोशनी'),
        P('Its light takes about 2.5 million years to reach us. When you see Andromeda tonight, you see it as it was when early humans were just appearing on Earth.',
          'इसकी रोशनी हम तक पहुँचने में लगभग 25 लाख साल लगाती है। आज रात आप Andromeda को वैसा देखते हैं जैसी वह तब थी जब पृथ्वी पर शुरुआती इंसान बस उभर रहे थे।'),
        H2('A collision is coming', 'टक्कर आने वाली है'),
        P('Andromeda is moving toward us at about 110 km per second. The two galaxies will most likely begin to merge in roughly 4 to 5 billion years, and settle into one big elliptical galaxy that people sometimes call Milkomeda.',
          'Andromeda लगभग 110 km प्रति सेकंड की गति से हमारी ओर आ रही है। दोनों galaxies के लगभग 4 से 5 अरब साल में मिलना शुरू करने की सबसे ज़्यादा संभावना है, और वे मिलकर एक बड़ी elliptical galaxy बनेंगी जिसे कभी-कभी Milkomeda कहा जाता है।'),
        P('Stars are so far apart that almost none will actually hit another. The Sun will probably be thrown into a new orbit, but not destroyed by the collision. By then the Sun will already be brighter and Earth far too hot for life as we know it.',
          'तारे एक-दूसरे से इतने दूर हैं कि लगभग कोई भी दूसरे से नहीं टकराएगा। सूर्य शायद नई कक्षा में फेंका जाएगा, पर टक्कर से नष्ट नहीं होगा। तब तक सूर्य और चमकीला हो चुका होगा और पृथ्वी हमारे जाने-पहचाने जीवन के लिए बहुत गर्म।'),
        callout('Earlier studies expected a sure collision in about 4 to 5 billion years. A 2025 study that also counted the Large Magellanic Cloud and other galaxies puts the chance of a merger within 10 billion years at roughly one in two. So it is likely, but not certain.',
                'पहले के अध्ययन लगभग 4 से 5 अरब साल में पक्की टक्कर मानते थे। 2025 के एक अध्ययन ने Large Magellanic Cloud और दूसरी galaxies को भी गिना, और 10 अरब साल के भीतर विलय की संभावना लगभग आधी निकाली। यानी यह संभव है, पर पक्का नहीं।'),
        H2('How to find it', 'इसे कैसे ढूँढें'),
        P('On a dark autumn evening in the northern sky, find the Great Square of Pegasus and follow the line of stars of Andromeda. A faint, elongated smudge appears beside the star ν Andromedae. Binoculars show it much better.',
          'उत्तरी आसमान में अँधेरी शरद की शाम को Pegasus का Great Square ढूँढिए और Andromeda के तारों की क़तार पकड़िए। ν Andromedae तारे के पास हल्का, लंबा धुँधला धब्बा दिखता है। दूरबीन से यह बहुत बेहतर दिखता है।'),
    ) + S.pn(s)
    out.append(S.page(s, body, 'The Andromeda Galaxy', 'देवयानी (Andromeda) galaxy', 'The Andromeda Galaxy (M31): distance, size, number of stars, the coming collision with the Milky Way and how to find it in the sky.'))

    # ---- 4 types
    s = 'types-of-galaxies'
    body = S.head('Types of galaxies', 'Galaxies के प्रकार', 'In 1926 Edwin Hubble sorted galaxies by shape. The groups are still used today.', '1926 में Edwin Hubble ने galaxies को आकार के हिसाब से बाँटा। ये समूह आज भी इस्तेमाल होते हैं।') + sec(
        grid(
            card('Spiral', 'Spiral', 'A flat disk with arms, lots of gas, and young blue stars in the arms. The Milky Way and Andromeda are spirals. Most large galaxies near us are of this kind.',
                 'चपटी disk जिसमें भुजाएँ, ढेर सारी गैस और भुजाओं में नए नीले तारे होते हैं। आकाशगंगा और Andromeda spiral हैं। हमारे पास की ज़्यादातर बड़ी galaxies ऐसी हैं।')
            + card('Barred spiral', 'Barred spiral', 'A spiral with a straight bar of stars through the middle. The Milky Way has one.', 'बीच में तारों की सीधी bar वाली spiral। आकाशगंगा में एक है।')
            + card('Elliptical', 'Elliptical', 'A smooth, round or egg-shaped ball of mostly old red stars with little gas. The biggest galaxies in the universe are of this type.', 'चिकनी, गोल या अंडाकार गेंद, जिसमें ज़्यादातर पुराने लाल तारे और कम गैस होती है। ब्रह्मांड की सबसे बड़ी galaxies इसी प्रकार की हैं।')
            + card('Lenticular', 'Lenticular', 'In between: a disk like a spiral, but with no arms and almost no new stars.', 'बीच की: spiral जैसी disk, पर बिना भुजाओं के और लगभग बिना नए तारों के।')
            + card('Irregular', 'Irregular', 'No clear shape, often from a merger or a pull from a neighbour. The Large Magellanic Cloud is one.', 'कोई साफ़ आकार नहीं, अक्सर विलय या पड़ोसी के खिंचाव से। Large Magellanic Cloud एक है।')
            + card('Dwarf', 'बौनी (Dwarf)', 'Small galaxies with a few million to a few billion stars. They are by far the most common kind.', 'छोटी galaxies जिनमें कुछ लाख से कुछ अरब तारे होते हैं। ये अब तक सबसे आम प्रकार की हैं।'), min_w=280),
        H2('Active galaxies', 'सक्रिय galaxies'),
        P('Some galaxies have a centre that outshines all their stars. Gas falling into the supermassive black hole heats up and lights the core. These are called active galaxies, and the brightest ones are quasars.',
          'कुछ galaxies का केंद्र उनके सारे तारों से ज़्यादा चमकता है। विशाल ब्लैक होल में गिरती गैस गर्म होकर केंद्र को रोशन करती है। इन्हें active galaxies कहते हैं, और सबसे चमकीली quasar हैं।'),
        H2('Colour tells the age', 'रंग से उम्र का पता चलता है'),
        P('Blue light comes from hot young stars, so blue galaxies are still making stars. Red galaxies have mostly old stars and have stopped. This is why spirals look blue-white in the arms and ellipticals look yellow-red.',
          'नीली रोशनी गर्म नए तारों से आती है, इसलिए नीली galaxies अब भी तारे बना रही हैं। लाल galaxies में ज़्यादातर पुराने तारे हैं और वे बनाना बंद कर चुकी हैं। इसीलिए spiral की भुजाएँ नीली-सफ़ेद और elliptical पीली-लाल दिखती हैं।'),
        note('Shape groups are a simplification. Many galaxies do not fit neatly and astronomers use finer classes.', 'आकार के समूह एक सरलीकरण हैं। कई galaxies साफ़ किसी समूह में नहीं बैठतीं और खगोलविद बारीक वर्ग इस्तेमाल करते हैं।'),
    ) + S.pn(s)
    out.append(S.page(s, body, 'Types of galaxies', 'Galaxies के प्रकार', 'Spiral, barred spiral, elliptical, lenticular, irregular and dwarf galaxies, what each is and how colour shows a galaxy’s age.'))

    # ---- 5 local group + voyager table
    def span(years):
        if years < 1e6:
            return f'{years:,.0f}'
        if years < 1e9:
            return f'{years / 1e6:,.0f} ' + 'million'
        return f'{years / 1e9:,.0f} ' + 'billion'

    def span_hi(years):
        if years < 1e6:
            return indian(years)
        if years < 1e9:
            return f'{years / 1e6:,.0f} मिलियन'
        return f'{years / 1e9:,.0f} अरब'

    trip = [('Proxima Centauri, the nearest star', 'Proxima Centauri, सबसे पास का तारा', 4.24),
            ('The centre of the Milky Way', 'आकाशगंगा का केंद्र', 26000),
            ('Large Magellanic Cloud', 'Large Magellanic Cloud', 160000),
            ('Andromeda Galaxy', 'Andromeda Galaxy', 2.5e6)]
    rows = []
    for en, hi, ly in trip:
        yrs = ly * LY_KM / VOYAGER_KMS / YEAR_S
        rows.append([(en, hi), (f'{ly:,.0f} light-years' if ly >= 100 else f'{ly:g} light-years', f'{indian(ly)} प्रकाश-वर्ष' if ly >= 100 else f'{ly:g} प्रकाश-वर्ष'), (span(yrs) + ' years', span_hi(yrs) + ' साल')])
    s = 'the-local-group'
    body = S.head('The Local Group and beyond', 'Local Group और उसके आगे', 'Galaxies come in groups, groups in clusters, clusters in giant threads.', 'Galaxies समूहों में हैं, समूह clusters में, और clusters विशाल धागों में।') + sec(
        H2('Our neighbourhood', 'हमारा मोहल्ला'),
        P('The Milky Way belongs to the Local Group, about 10 million light-years across, with more than 80 known galaxies. Two giants dominate it: the Milky Way and Andromeda. Most of the rest are dwarfs that orbit one of the two.',
          'आकाशगंगा Local Group की सदस्य है, जो लगभग 1 करोड़ प्रकाश-वर्ष चौड़ा है और जिसमें 80 से ज़्यादा ज्ञात galaxies हैं। दो दानव इस पर हावी हैं: आकाशगंगा और Andromeda। बाक़ी ज़्यादातर बौनी galaxies हैं जो इन दोनों में से किसी एक की परिक्रमा करती हैं।'),
        table([('Galaxy', 'Galaxy'), ('Distance', 'दूरी'), ('What it is', 'क्या है')], [
            [('Large Magellanic Cloud', 'Large Magellanic Cloud'), ('~160,000 light-years', '~1,60,000 प्रकाश-वर्ष'), ('Irregular dwarf, orbits us', 'Irregular बौनी, हमारी परिक्रमा करती है')],
            [('Small Magellanic Cloud', 'Small Magellanic Cloud'), ('~200,000 light-years', '~2,00,000 प्रकाश-वर्ष'), ('Dwarf, orbits us', 'बौनी, हमारी परिक्रमा करती है')],
            [('Andromeda (M31)', 'Andromeda (M31)'), ('~2.5 million light-years', '~25 लाख प्रकाश-वर्ष'), ('Large spiral', 'बड़ी spiral')],
            [('Triangulum (M33)', 'Triangulum (M33)'), ('~2.7 million light-years', '~27 लाख प्रकाश-वर्ष'), ('Third largest, spiral', 'तीसरी सबसे बड़ी, spiral')]]),
        H2('How far is far?', 'दूरी कितनी दूर है?'),
        P('Voyager 1, the fastest spacecraft we have sent out of the Solar System, moves at about 17 km per second. At that speed:',
          'Voyager 1, जो हमने सौरमंडल से बाहर भेजा सबसे तेज़ यान है, लगभग 17 km प्रति सेकंड चलता है। इस गति से:'),
        table([('Trip', 'यात्रा'), ('Distance', 'दूरी'), ('Time at Voyager speed', 'Voyager की गति से समय')], rows, cols=True),
        note('Worked out from distance ÷ 17 km/s. Even the nearest star would take about 75,000 years.', 'दूरी ÷ 17 km/s से निकाला गया। सबसे पास का तारा भी लगभग 75,000 साल लेगा।'),
        H2('Clusters and the cosmic web', 'Clusters और cosmic web'),
        P('The Local Group sits on the edge of the Virgo Cluster, about 54 million light-years away, with over a thousand galaxies. Clusters join into superclusters. Our home supercluster, Laniakea, spans about 500 million light-years and holds roughly 100,000 galaxies.',
          'Local Group Virgo Cluster के किनारे पर है, जो लगभग 5.4 करोड़ प्रकाश-वर्ष दूर है और जिसमें हज़ार से ज़्यादा galaxies हैं। Clusters मिलकर superclusters बनाते हैं। हमारा supercluster Laniakea लगभग 50 करोड़ प्रकाश-वर्ष में फैला है और उसमें लगभग 1,00,000 galaxies हैं।'),
        P('On the largest scales galaxies line up in filaments around huge empty voids, like the walls of soap bubbles. This pattern is called the cosmic web.',
          'सबसे बड़े पैमाने पर galaxies विशाल ख़ाली voids के चारों ओर धागों में सजी हैं, जैसे साबुन के बुलबुलों की दीवारें। इस ढाँचे को cosmic web कहते हैं।'),
    ) + S.pn(s)
    out.append(S.page(s, body, 'The Local Group and beyond', 'Local Group और उसके आगे', 'The Local Group, nearby galaxies, the Virgo Cluster, Laniakea and the cosmic web, with how long Voyager 1 would take to reach each.'))

    # ---- 6 formation and collisions
    s = 'galaxy-formation-and-collisions'
    body = S.head('Formation and collisions', 'बनना और टकराना', 'Galaxies were not born big. They grew, mostly by merging.', 'Galaxies बड़ी पैदा नहीं हुईं। वे बढ़ीं, ज़्यादातर आपस में मिलकर।') + sec(
        H2('The first ones', 'पहली galaxies'),
        P('After the Big Bang, about 13.8 billion years ago, the universe was a nearly smooth mix of gas and dark matter. Slightly denser spots pulled in more matter. Gas fell into them and the first stars lit up a few hundred million years later.',
          'लगभग 13.8 अरब साल पहले Big Bang के बाद ब्रह्मांड गैस और dark matter का लगभग चिकना मिश्रण था। थोड़े घने स्थानों ने और द्रव्य खींचा। उनमें गैस गिरी और कुछ सौ मिलियन साल बाद पहले तारे जल उठे।'),
        P('The James Webb Space Telescope has found galaxies that existed only about 300 million years after the Big Bang. Some are brighter and more developed than expected, and astronomers are still working out why.',
          'James Webb Space Telescope ने ऐसी galaxies पाई हैं जो Big Bang के सिर्फ़ लगभग 30 करोड़ साल बाद मौजूद थीं। कुछ उम्मीद से ज़्यादा चमकीली और विकसित हैं, और खगोलविद अब भी समझ रहे हैं कि ऐसा क्यों।'),
        H2('Growing by merging', 'मिलकर बढ़ना'),
        P('Small galaxies fall into bigger ones. The Milky Way is still swallowing the Sagittarius Dwarf Galaxy, and streams of stars from earlier meals wrap around it. A bigger meal, a galaxy called Gaia-Enceladus, merged with us about 10 billion years ago.',
          'छोटी galaxies बड़ी में गिरती हैं। आकाशगंगा अब भी Sagittarius Dwarf Galaxy को निगल रही है, और पहले के शिकारों के तारों की धाराएँ उसके चारों ओर लिपटी हैं। और बड़ा शिकार, Gaia-Enceladus नाम की galaxy, लगभग 10 अरब साल पहले हमसे मिली।'),
        H2('What a collision looks like', 'टक्कर कैसी दिखती है'),
        P('Two galaxies passing through each other is slow, over hundreds of millions of years. Stars rarely collide, but gas clouds do. They are squeezed and a burst of new stars forms, called a starburst. The Antennae Galaxies, 70 million light-years away, are two galaxies in the middle of this.',
          'दो galaxies का एक-दूसरे से गुज़रना धीमा होता है, सैकड़ों मिलियन साल में। तारे शायद ही टकराते हैं, पर गैस के बादल टकराते हैं। वे दबते हैं और नए तारों की बौछार बनती है, जिसे starburst कहते हैं। 7 करोड़ प्रकाश-वर्ष दूर Antennae Galaxies इसी प्रक्रिया के बीच की दो galaxies हैं।'),
        H2('Black holes grow too', 'ब्लैक होल भी बढ़ते हैं'),
        P('When galaxies merge, their central black holes sink to the middle and can merge too. The size of a galaxy’s central black hole is closely linked to the size of its central bulge of stars, so the two seem to grow together.',
          'Galaxies के मिलने पर उनके केंद्रीय ब्लैक होल बीच में डूबते हैं और वे भी मिल सकते हैं। Galaxy के केंद्रीय ब्लैक होल का आकार उसके तारों के केंद्रीय उभार के आकार से गहराई से जुड़ा है, यानी दोनों साथ-साथ बढ़ते लगते हैं।'),
        callout('The universe is also expanding. Distant galaxies move away from each other, but galaxies inside a group, like ours and Andromeda, are held together by gravity.',
                'ब्रह्मांड फैल भी रहा है। दूर की galaxies एक-दूसरे से दूर जा रही हैं, पर समूह के भीतर की galaxies, जैसे हमारी और Andromeda, gravity से बँधी रहती हैं।'),
    ) + S.pn(s)
    out.append(S.page(s, body, 'Galaxy formation and collisions', 'Galaxies का बनना और टकराना', 'How galaxies formed after the Big Bang, how they grow by merging, what a galaxy collision looks like and what the James Webb telescope found.'))

    # ---- 7 see
    s = 'galaxies-you-can-see'
    body = S.head('Galaxies you can see', 'जो galaxies आप देख सकते हैं', 'You need no telescope for the first three.', 'पहली तीन के लिए telescope नहीं चाहिए।') + sec(
        table([('Galaxy', 'Galaxy'), ('Where', 'कहाँ'), ('Needs', 'ज़रूरत')], [
            [('The Milky Way band', 'आकाशगंगा की पट्टी'), ('Anywhere dark, best in summer', 'कहीं भी अँधेरे में, गर्मियों में सबसे अच्छी'), ('Eyes', 'आँखें')],
            [('Andromeda (M31)', 'Andromeda (M31)'), ('Northern sky, autumn evenings', 'उत्तरी आसमान, शरद की शामें'), ('Eyes, better with binoculars', 'आँखें, दूरबीन से बेहतर')],
            [('Magellanic Clouds', 'Magellanic Clouds'), ('Only from the southern hemisphere or near the equator', 'सिर्फ़ दक्षिणी गोलार्ध या भूमध्य रेखा के पास से'), ('Eyes', 'आँखें')],
            [('Triangulum (M33)', 'Triangulum (M33)'), ('Northern sky, near Andromeda', 'उत्तरी आसमान, Andromeda के पास'), ('Binoculars, very dark sky', 'दूरबीन, बहुत अँधेरा आसमान')],
            [('Bode’s Galaxy (M81)', 'Bode’s Galaxy (M81)'), ('Near the Big Dipper', 'सप्तर्षि के पास'), ('Small telescope', 'छोटा telescope')]]),
        H2('Tips', 'सुझाव'),
        '<div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(240px,1fr))">'
        + card('Go dark', 'अँधेरे में जाएँ', 'City lights wash out faint galaxies. Move away from them and avoid the Moon.', 'शहर की रोशनी धुँधली galaxies मिटा देती है। उससे दूर जाइए और चाँद की रात से बचिए।')
        + card('Wait 20 minutes', '20 मिनट रुकिए', 'Eyes need that long to adjust. Do not look at a phone screen, or use a red light.', 'आँखों को ढलने में इतना समय लगता है। फ़ोन की screen न देखें, या लाल रोशनी इस्तेमाल करें।')
        + card('Look beside it', 'किनारे से देखिए', 'Look slightly to the side of the spot. The edge of the eye is more sensitive to faint light.', 'उस जगह से थोड़ा बग़ल में देखिए। आँख का किनारा हल्की रोशनी के लिए ज़्यादा संवेदनशील है।')
        + '</div>',
        callout('The Astryl app shows the sky for your place and time, so you can find where Andromeda and the Milky Way are tonight.',
                'Astryl app आपकी जगह और समय का आसमान दिखाता है, इसलिए आप ढूँढ सकते हैं कि आज रात Andromeda और आकाशगंगा कहाँ हैं।') + f' <a href="../get.html">{bt("Get the app", "App पाएँ")}</a>',
    ) + S.pn(s, last_link=('../black-holes.html', 'Black holes', 'ब्लैक होल'))
    out.append(S.page(s, body, 'Galaxies you can see', 'जो galaxies आप देख सकते हैं', 'Which galaxies you can see with your eyes, binoculars or a small telescope, and how to see them: the Milky Way, Andromeda and the Magellanic Clouds.'))

    for p in out:
        h['write'](p['file'], p['html'])
    return [p['file'] for p in out]


def shell_hub(h, body):
    return h['shell']('Galaxies explained', 'Galaxies, आसान भाषा में', 'gx', body,
                      'Galaxies explained simply: the Milky Way, Andromeda, galaxy types, the Local Group, how galaxies form and collide, and which ones you can see. Free, in English and Hindi.',
                      canonical='galaxies.html', ld=article_ld(h['SITE'], 'Galaxies explained', 'Galaxies explained simply: the Milky Way, Andromeda, galaxy types, the Local Group, how galaxies form and collide, and which ones you can see.', 'galaxies.html', [('Astryl', ''), ('Galaxies', 'galaxies.html')]))
