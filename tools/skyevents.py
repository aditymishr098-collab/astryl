"""Eclipses and meteor showers: the data the site's calendar, the city view and the event pages use.

Eclipse dates, times of greatest eclipse (UT), types and magnitudes are from NASA's eclipse pages
(eclipse.gsfc.nasa.gov/OH/OH2027.html, OH2028.html, OH2029.html). Where a solar eclipse can be seen
is summarised from NASA's maps in plain words. Lunar eclipses are seen from wherever the Moon is up,
so the website works that out for the chosen city.
"""

# id, date, UT of greatest eclipse, lunar?, type, magnitude, where (en, hi) for solar eclipses
ECLIPSES = [
    ('2027-02-06-annular-solar', '2027-02-06', '16:00', False, 'annular', 0.928,
     'Ring of fire across Chile, Argentina, Uruguay and West Africa (Côte d’Ivoire, Ghana, Togo, Benin, Nigeria); a partial eclipse over most of South America and Africa.',
     'आग की अंगूठी चिली, अर्जेंटीना, उरुग्वे और पश्चिम अफ़्रीका (आइवरी कोस्ट, घाना, टोगो, बेनिन, नाइजीरिया) में; दक्षिण अमेरिका और अफ़्रीका के ज़्यादातर हिस्से में आंशिक ग्रहण।'),
    ('2027-02-20-penumbral-lunar', '2027-02-20', '23:13', True, 'penumbral', 0.927, '', ''),
    ('2027-07-18-penumbral-lunar', '2027-07-18', '16:03', True, 'penumbral', 0.001, '', ''),
    ('2027-08-02-total-solar', '2027-08-02', '10:07', False, 'total', 1.079,
     'The longest total eclipse on land this century (up to 6 min 23 s): southern Spain, Morocco, Algeria, Tunisia, Libya, Egypt (Luxor), Saudi Arabia, Yemen and Somalia. A partial eclipse over Europe, Africa, the Middle East and western South Asia, including Armenia and western India.',
     'इस सदी का ज़मीन पर सबसे लंबा पूर्ण ग्रहण (6 मिनट 23 सेकंड तक): दक्षिणी स्पेन, मोरक्को, अल्जीरिया, ट्यूनीशिया, लीबिया, मिस्र (लक्सर), सऊदी अरब, यमन और सोमालिया। यूरोप, अफ़्रीका, मध्य-पूर्व और पश्चिमी दक्षिण एशिया (आर्मेनिया और पश्चिमी भारत समेत) में आंशिक ग्रहण।'),
    ('2027-08-17-penumbral-lunar', '2027-08-17', '07:14', True, 'penumbral', 0.546, '', ''),
    ('2028-01-12-partial-lunar', '2028-01-12', '04:13', True, 'partial', 0.066, '', ''),
    ('2028-01-26-annular-solar', '2028-01-26', '15:08', False, 'annular', 0.921,
     'Ring of fire across Ecuador, Peru and Brazil, ending at sunset in Portugal and Spain; a partial eclipse over the Americas, western Europe and West Africa.',
     'आग की अंगूठी इक्वाडोर, पेरू और ब्राज़ील में, सूर्यास्त के समय पुर्तगाल और स्पेन में ख़त्म; अमेरिका, पश्चिमी यूरोप और पश्चिम अफ़्रीका में आंशिक ग्रहण।'),
    ('2028-07-06-partial-lunar', '2028-07-06', '18:20', True, 'partial', 0.389, '', ''),
    ('2028-07-22-total-solar', '2028-07-22', '02:55', False, 'total', 1.056,
     'Totality across Australia (the Kimberley, Northern Territory, Queensland and Sydney) and New Zealand’s South Island; a partial eclipse over Southeast Asia, Australia and New Zealand.',
     'पूर्ण ग्रहण ऑस्ट्रेलिया (किम्बरली, नॉर्दर्न टेरिटरी, क्वींसलैंड और सिडनी) और न्यूज़ीलैंड के दक्षिणी द्वीप में; दक्षिण-पूर्व एशिया, ऑस्ट्रेलिया और न्यूज़ीलैंड में आंशिक ग्रहण।'),
    ('2028-12-31-total-lunar', '2028-12-31', '16:52', True, 'total', 1.246, '', ''),
    ('2029-01-14-partial-solar', '2029-01-14', '17:13', False, 'partial', 0.871,
     'A partial eclipse over North America and Central America.',
     'उत्तरी और मध्य अमेरिका में आंशिक ग्रहण।'),
    ('2029-06-12-partial-solar', '2029-06-12', '04:05', False, 'partial', 0.458,
     'A partial eclipse over the Arctic: northern Canada, Greenland, Scandinavia and northern Russia.',
     'आर्कटिक के ऊपर आंशिक ग्रहण: उत्तरी कनाडा, ग्रीनलैंड, स्कैंडिनेविया और उत्तरी रूस।'),
    ('2029-06-26-total-lunar', '2029-06-26', '03:22', True, 'total', 1.844, '', ''),
    ('2029-07-11-partial-solar', '2029-07-11', '15:36', False, 'partial', 0.230,
     'A small partial eclipse over the far south of South America.',
     'दक्षिण अमेरिका के सुदूर दक्षिण में छोटा आंशिक ग्रहण।'),
    ('2029-12-05-partial-solar', '2029-12-05', '15:03', False, 'partial', 0.891,
     'A partial eclipse over Antarctica and the far south of South America.',
     'अंटार्कटिका और दक्षिण अमेरिका के सुदूर दक्षिण में आंशिक ग्रहण।'),
    ('2029-12-20-total-lunar', '2029-12-20', '22:42', True, 'total', 1.117, '', ''),
]


def eclipse_json():
    """Compact list for the browser: [id, ISO time UT, lunar, type, magnitude]."""
    return [[e[0], f'{e[1]}T{e[2]}:00Z', e[3], e[4], e[5]] for e in ECLIPSES]


# id, name en, name hi, peak (month, day), rate per hour, speed km/s, parent (en, hi), radiant (en, hi), best (en, hi), fact (en, hi)
SHOWERS = [
    ('quadrantids', 'Quadrantids', 'क्वाड्रैंटिड', (1, 3), 110, 41, ('the asteroid 2003 EH1', 'क्षुद्रग्रह 2003 EH1'), ('Boötes, near the handle of the Big Dipper', 'बूटीज़, सप्तर्षि के हत्थे के पास'),
     ('Before dawn, from the northern half of the world. The peak is short: only a few hours.', 'भोर से पहले, पृथ्वी के उत्तरी हिस्से से। चरम छोटा होता है: बस कुछ घंटे।'),
     ('It is named after Quadrans Muralis, a constellation that no longer exists.', 'इसका नाम Quadrans Muralis पर है, एक तारामंडल जो अब नहीं गिना जाता।')),
    ('lyrids', 'Lyrids', 'लिरिड', (4, 22), 18, 49, ('Comet Thatcher (C/1861 G1)', 'धूमकेतु थैचर (C/1861 G1)'), ('Lyra, near the bright star Vega', 'लायरा, चमकीले तारे अभिजित (Vega) के पास'),
     ('After midnight until dawn.', 'आधी रात के बाद से भोर तक।'),
     ('One of the oldest showers on record: Chinese astronomers noted it in 687 BCE.', 'सबसे पुराने दर्ज उल्कापातों में से एक: चीनी खगोलविदों ने इसे 687 ईसा-पूर्व में लिखा था।')),
    ('etaAquariids', 'Eta Aquariids', 'ईटा एक्वेरिड', (5, 6), 50, 66, ('Halley’s Comet', 'हैली धूमकेतु'), ('Aquarius', 'कुंभ तारामंडल'),
     ('The last two hours before dawn. Best from the tropics and the southern half of the world, so India sees it well.', 'भोर से पहले के आख़िरी दो घंटे। उष्णकटिबंध और दक्षिणी हिस्से से सबसे अच्छा, इसलिए भारत से अच्छा दिखता है।'),
     ('These are tiny bits of Halley’s Comet, the same comet that gives us the Orionids in October.', 'ये हैली धूमकेतु के नन्हे टुकड़े हैं, वही धूमकेतु जो अक्टूबर में ओरियोनिड देता है।')),
    ('perseids', 'Perseids', 'पर्सिड', (8, 12), 100, 59, ('Comet Swift–Tuttle (109P)', 'धूमकेतु स्विफ़्ट–टटल (109P)'), ('Perseus', 'पर्सियस तारामंडल'),
     ('After midnight until dawn, from the northern half of the world. Warm August nights make it the favourite shower of many.', 'आधी रात के बाद भोर तक, पृथ्वी के उत्तरी हिस्से से। अगस्त की गर्म रातों की वजह से यह बहुत लोगों का पसंदीदा है।'),
     ('Famous for bright fireballs that leave glowing trails.', 'चमकीले आग के गोलों के लिए मशहूर, जो चमकती लकीर छोड़ जाते हैं।')),
    ('orionids', 'Orionids', 'ओरियोनिड', (10, 21), 20, 66, ('Halley’s Comet', 'हैली धूमकेतु'), ('Orion, near Betelgeuse', 'ओरायन (मृग), आर्द्रा (Betelgeuse) के पास'),
     ('After midnight until dawn, from anywhere on Earth.', 'आधी रात के बाद भोर तक, पृथ्वी पर कहीं से भी।'),
     ('Among the fastest meteors: they hit the air at about 66 km a second.', 'सबसे तेज़ उल्काओं में: ये हवा से लगभग 66 किमी प्रति सेकंड की रफ़्तार से टकराते हैं।')),
    ('leonids', 'Leonids', 'लियोनिड', (11, 17), 15, 71, ('Comet Tempel–Tuttle (55P)', 'धूमकेतु टेम्पल–टटल (55P)'), ('Leo', 'सिंह तारामंडल'),
     ('After midnight until dawn.', 'आधी रात के बाद भोर तक।'),
     ('About every 33 years it can turn into a storm: in 1833 and 1966 people saw thousands of meteors an hour.', 'लगभग हर 33 साल में यह तूफ़ान बन सकता है: 1833 और 1966 में लोगों ने घंटे में हज़ारों उल्काएँ देखीं।')),
    ('geminids', 'Geminids', 'जेमिनिड', (12, 14), 150, 35, ('the asteroid 3200 Phaethon', 'क्षुद्रग्रह 3200 फ़ेथॉन'), ('Gemini, near Castor', 'मिथुन तारामंडल, कैस्टर के पास'),
     ('All night from about 10 pm, best around 2 am, from almost anywhere.', 'लगभग रात 10 बजे से पूरी रात, सबसे अच्छा रात 2 बजे के आसपास, लगभग कहीं से भी।'),
     ('The richest shower of the year, and one of the few that comes from an asteroid rather than a comet.', 'साल का सबसे भरपूर उल्कापात, और उन गिने-चुने में से एक जो धूमकेतु की जगह क्षुद्रग्रह से आता है।')),
    ('ursids', 'Ursids', 'उर्सिड', (12, 22), 10, 33, ('Comet Tuttle (8P)', 'धूमकेतु टटल (8P)'), ('Ursa Minor, near the Pole Star', 'लघु सप्तर्षि, ध्रुव तारे के पास'),
     ('Before dawn, from the northern half of the world.', 'भोर से पहले, पृथ्वी के उत्तरी हिस्से से।'),
     ('A quiet shower right at the winter solstice.', 'ठीक शीत अयनांत (सबसे छोटे दिन) के आसपास एक शांत उल्कापात।')),
]

TYPE = {'total': ('Total', 'पूर्ण'), 'annular': ('Annular', 'वलयाकार'), 'partial': ('Partial', 'आंशिक'), 'penumbral': ('Penumbral', 'उपछाया')}

# Cities for the lunar eclipse table: name, lat, lon, IANA time zone
TABLE_CITIES = [('Delhi', 28.61, 77.21, 'Asia/Kolkata'), ('Mumbai', 19.08, 72.88, 'Asia/Kolkata'), ('Kolkata', 22.57, 88.36, 'Asia/Kolkata'),
                ('Chennai', 13.08, 80.27, 'Asia/Kolkata'), ('Yerevan', 40.18, 44.51, 'Asia/Yerevan'), ('Dubai', 25.2, 55.27, 'Asia/Dubai'),
                ('London', 51.51, -0.13, 'Europe/London'), ('New York', 40.71, -74.01, 'America/New_York'), ('Tokyo', 35.68, 139.69, 'Asia/Tokyo'),
                ('Sydney', -33.87, 151.21, 'Australia/Sydney')]


def slug_shower(sid):
    return ''.join('-' + ch.lower() if ch.isupper() else ch for ch in sid)


def build(h):
    import json
    from dskit import Kit, article_ld
    k = Kit(h)
    bt, P, H2 = k.bt, k.P, k.H2
    v = h['asset_v']()
    pages = []
    head = lambda depth: f'<script defer src="{"../" * depth}assets/tonight.js?v={v}"></script>'
    crumbs_hub = [('Astryl', ''), ('Eclipses and meteor showers', 'sky-events.html')]

    def ecl_title(e):
        t = TYPE[e[4]]
        return (f'{t[0]} {"lunar" if e[3] else "solar"} eclipse', f'{t[1]} {"चंद्र" if e[3] else "सूर्य"} ग्रहण')

    def date_words(iso):
        import datetime
        d = datetime.date.fromisoformat(iso)
        months_hi = ['जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर']
        return d.strftime('%-d %B %Y'), f'{d.day} {months_hi[d.month - 1]} {d.year}'

    # ---- eclipse pages
    for e in ECLIPSES:
        eid, iso, ut, lunar, typ, mag, wen, whi = e
        ten, thi = ecl_title(e)
        den, dhi = date_words(iso)
        title_en, title_hi = f'{ten} of {den}', f'{dhi} का {thi}'
        what = {
            ('total', True): ('The whole Moon passes into Earth’s dark shadow and turns a deep red or copper colour, lit only by sunlight bent through Earth’s air.', 'पूरा चाँद पृथ्वी की गहरी छाया में चला जाता है और गहरा लाल या ताँबे जैसा हो जाता है, सिर्फ़ पृथ्वी की हवा से मुड़कर आई धूप से रोशन।'),
            ('partial', True): ('Only part of the Moon enters Earth’s dark shadow, so a dark bite appears on one side of the full Moon.', 'चाँद का सिर्फ़ एक हिस्सा पृथ्वी की गहरी छाया में जाता है, इसलिए पूरे चाँद के एक तरफ़ एक काला हिस्सा दिखता है।'),
            ('penumbral', True): ('The Moon passes only through Earth’s faint outer shadow. It dims a little, often too little to notice without a camera.', 'चाँद सिर्फ़ पृथ्वी की हल्की बाहरी छाया से गुज़रता है। वह थोड़ा धुँधला होता है, अक्सर इतना कम कि कैमरे के बिना पता नहीं चलता।'),
            ('total', False): ('The Moon covers the whole Sun. For a few minutes the sky goes dark, stars come out and the Sun’s glowing outer air, the corona, appears.', 'चाँद पूरे सूरज को ढक लेता है। कुछ मिनट के लिए आसमान अँधेरा हो जाता है, तारे निकल आते हैं और सूरज की चमकती बाहरी हवा, corona, दिखती है।'),
            ('annular', False): ('The Moon is a little too far from Earth to cover the Sun completely, so a bright “ring of fire” stays around it.', 'चाँद पृथ्वी से थोड़ा ज़्यादा दूर होता है और सूरज को पूरा नहीं ढक पाता, इसलिए उसके चारों ओर चमकती “आग की अंगूठी” बची रहती है।'),
            ('partial', False): ('The Moon covers only part of the Sun, which looks like a cookie with a bite taken out.', 'चाँद सूरज का सिर्फ़ एक हिस्सा ढकता है, जो ऐसा दिखता है जैसे किसी ने biscuit से एक कौर काट लिया हो।'),
        }[(typ, lunar)]
        body = f'<p style="margin-top:20px"><a href="../sky-events.html">← {bt("Eclipses and meteor showers", "ग्रहण और उल्कापात")}</a></p>'
        body += f'<section class="blk"><h1>{"🌑" if lunar else "🌞"} {bt(title_en, title_hi)}</h1><p class="sub">{bt(what[0], what[1])}</p></section>'
        facts = f'<div class="stats"><div class="stat"><b>{den}</b><span>{bt("Date", "तारीख़")}</span></div><div class="stat"><b>{ut} UT</b><span>{bt("Middle of the eclipse", "ग्रहण का बीच")}</span></div><div class="stat"><b>{mag:.3f}</b><span>{bt("Magnitude", "परिमाण (magnitude)")}</span></div></div>'
        local = f'<div class="card" id="evLocal" data-at="{iso}T{ut}:00Z" data-lunar="{1 if lunar else 0}"></div>'
        sec = H2('Key facts', 'मुख्य बातें') + facts + H2('For your city', 'आपके शहर के लिए') + local
        if lunar:
            sec += H2('When and where it can be seen', 'कब और कहाँ दिखेगा') + P('A lunar eclipse can be seen from every place where the Moon is above the horizon at the time. The table shows the middle of the eclipse in local time.', 'चंद्र ग्रहण हर उस जगह से दिखता है जहाँ उस समय चाँद क्षितिज के ऊपर हो। Table में ग्रहण का बीच स्थानीय समय में है।')
            sec += f'<div id="evTable" data-cities=\'{json.dumps(TABLE_CITIES)}\'></div>'
            sec += k.callout('A lunar eclipse is completely safe to watch with your eyes, binoculars or a telescope.', 'चंद्र ग्रहण आँखों, दूरबीन या telescope से देखना पूरी तरह सुरक्षित है।')
        else:
            sec += H2('Where it can be seen', 'कहाँ दिखेगा') + P(wen, whi)
            sec += k.callout('⚠️ Never look at the Sun directly, not even during an eclipse. Use certified eclipse glasses (ISO 12312-2), a welder’s glass no. 14, or a pinhole projector. Sunglasses are not safe.', '⚠️ सूरज को कभी सीधे मत देखिए, ग्रहण के समय भी नहीं। प्रमाणित eclipse चश्मा (ISO 12312-2), welding का नंबर 14 वाला काँच, या pinhole projector इस्तेमाल कीजिए। धूप का चश्मा सुरक्षित नहीं है।')
        sec += k.note('Date, time and magnitude: NASA eclipse pages (eclipse.gsfc.nasa.gov). Times are the middle of the eclipse; partial phases start earlier and end later.', 'तारीख़, समय और परिमाण: NASA के eclipse पन्ने (eclipse.gsfc.nasa.gov)। समय ग्रहण के बीच का है; आंशिक चरण पहले शुरू होते हैं और बाद में ख़त्म होते हैं।')
        body += k.sec(sec)
        body += k.keep_exploring('../', [('sky-events.html', '📅', 'All eclipses and meteor showers', 'सारे ग्रहण और उल्कापात'), ('my-space.html', '⭐', 'My space: add to calendar', 'My space: calendar में जोड़ें'), ('sky.html', '🌙', 'Moon calendar', 'चाँद का calendar'), ('learn/eclipses.html', '🎓', 'How eclipses work', 'ग्रहण कैसे होते हैं')])
        path = f'sky-events/{eid}.html'
        desc = f'{title_en}: date, time ({ut} UT), type and where it can be seen, with local times for your city.'
        html = k.shell(title_en, title_hi, 'events', body, desc, depth=1, canonical=path, extra_head=head(1),
                       ld=article_ld(k.site, title_en, desc, path, crumbs_hub + [(title_en, path)]) + [{'@context': 'https://schema.org', '@type': 'Event', 'name': title_en, 'startDate': f'{iso}T{ut}:00Z', 'eventAttendanceMode': 'https://schema.org/OfflineEventAttendanceMode', 'eventStatus': 'https://schema.org/EventScheduled', 'location': {'@type': 'Place', 'name': 'Sky', 'address': 'Earth'}, 'description': what[0], 'url': f'{k.site}/{path}'}])
        h['write'](path, html)
        pages.append(path)

    # ---- meteor shower pages
    for sid, nen, nhi, (mo, dy), rate, speed, parent, radiant, best, fact in SHOWERS:
        slug = slug_shower(sid)
        title_en, title_hi = f'{nen} meteor shower', f'{nhi} उल्कापात'
        months_en = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
        months_hi = ['जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर']
        body = f'<p style="margin-top:20px"><a href="../sky-events.html">← {bt("Eclipses and meteor showers", "ग्रहण और उल्कापात")}</a></p>'
        body += f'<section class="blk"><h1>☄️ {bt(title_en, title_hi)}</h1><p class="sub">{bt(f"Peaks every year around {dy} {months_en[mo - 1]}, with up to {rate} meteors an hour under a dark sky.", f"हर साल {dy} {months_hi[mo - 1]} के आसपास चरम पर, अँधेरे आसमान में घंटे में {rate} तक उल्काएँ।")}</p></section>'
        facts = (f'<div class="stats"><div class="stat"><b>{dy} {months_en[mo - 1][:3]}</b><span>{bt("Peak night", "चरम रात")}</span></div><div class="stat"><b>{rate}</b><span>{bt("Meteors an hour (best case)", "उल्काएँ प्रति घंटा (सबसे अच्छी हालत में)")}</span></div>'
                 f'<div class="stat"><b>{speed} km/s</b><span>{bt("Speed", "रफ़्तार")}</span></div></div>')
        sec = H2('Key facts', 'मुख्य बातें') + facts
        sec += f'<div class="card" id="evShower" data-month="{mo}" data-day="{dy}" data-rate="{rate}"></div>'
        sec += H2('Where it comes from', 'यह कहाँ से आता है') + P(f'Earth passes through the dust left behind by {parent[0]}. Each grain, often smaller than a grain of sand, burns up about 100 km above us as a shooting star.', f'पृथ्वी {parent[1]} के पीछे छोड़ी धूल से गुज़रती है। हर कण, अक्सर रेत के दाने से भी छोटा, हमसे लगभग 100 किमी ऊपर जलकर टूटता तारा बन जाता है।')
        sec += P(f'The meteors seem to fly out of one point in the sky, the radiant, in {radiant[0]}. You do not need to look there: meteors appear all over the sky.', f'उल्काएँ आसमान के एक बिंदु से निकलती लगती हैं, जिसे radiant कहते हैं; यह {radiant[1]} में है। वहाँ देखना ज़रूरी नहीं: उल्काएँ पूरे आसमान में दिखती हैं।')
        sec += H2('When and how to watch', 'कब और कैसे देखें') + P(best[0], best[1])
        sec += '<ul>' + ''.join(f'<li>{bt(a, b)}</li>' for a, b in [
            ('Get away from city lights. A dark country sky can show several times as many meteors as a city sky.', 'शहर की रोशनी से दूर जाइए। जितनी कम रोशनी, उतनी ज़्यादा उल्काएँ।'),
            ('Lie back and look at a wide patch of sky. No telescope or binoculars needed.', 'लेटकर आसमान का बड़ा हिस्सा देखिए। Telescope या दूरबीन की ज़रूरत नहीं।'),
            ('Give your eyes 20 minutes to get used to the dark, and keep your phone screen off.', 'आँखों को अँधेरे की आदत होने में 20 मिनट दीजिए, और phone की screen बंद रखिए।'),
            ('A bright Moon washes out the faint meteors: check the Moon on the night.', 'तेज़ चाँद हल्की उल्काओं को छिपा देता है: उस रात चाँद देख लीजिए।')]) + '</ul>'
        sec += k.callout(fact[0], fact[1])
        body += k.sec(sec)
        body += k.keep_exploring('../', [('sky-events.html', '📅', 'All eclipses and meteor showers', 'सारे ग्रहण और उल्कापात'), ('my-space.html', '👀', 'Tick it off in My space', 'My space में tick कीजिए'), ('sky.html', '🌙', 'Moon calendar', 'चाँद का calendar'), ('glossary.html', '📖', 'Space glossary', 'अंतरिक्ष शब्दकोश')])
        path = f'sky-events/{slug}.html'
        desc = f'{title_en}: when it peaks ({dy} {months_en[mo - 1]}), how many meteors to expect, where it comes from and how to watch it.'
        html = k.shell(title_en, title_hi, 'events', body, desc, depth=1, canonical=path, extra_head=head(1), ld=article_ld(k.site, title_en, desc, path, crumbs_hub + [(title_en, path)]))
        h['write'](path, html)
        pages.append(path)

    # ---- hub
    def ecl_card(e):
        ten, thi = ecl_title(e)
        den, dhi = date_words(e[1])
        return f'<a class="sc" href="sky-events/{e[0]}.html"><span class="ic">{"🌑" if e[3] else "🌞"}</span><span><b>{bt(ten, thi)}</b><small>{bt(den, dhi)}</small></span><span class="go">→</span></a>'

    def sh_card(s):
        months_en = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        return f'<a class="sc" href="sky-events/{slug_shower(s[0])}.html"><span class="ic">☄️</span><span><b>{bt(s[1], s[2])}</b><small>{bt(f"Peak {s[3][1]} {months_en[s[3][0] - 1]} · up to {s[4]}/hour", f"चरम {s[3][1]} {months_en[s[3][0] - 1]} · घंटे में {s[4]} तक")}</small></span><span class="go">→</span></a>'

    body = f'''<section class="blk"><h1>{bt("Eclipses and meteor showers", "ग्रहण और उल्कापात")}</h1><p class="sub">{bt("Every eclipse until the end of 2029 and the year's best meteor showers, with times for your city and a calendar file for your phone.", "2029 के अंत तक का हर ग्रहण और साल के सबसे अच्छे उल्कापात, आपके शहर के समय के साथ और phone के लिए calendar file के साथ।")}</p>
<p><a class="btn primary" href="my-space.html#calendar">📅 {bt("My calendar for my city", "मेरे शहर के लिए मेरा calendar")}</a></p></section>
<section class="blk"><h2>{bt("Eclipses", "ग्रहण")}</h2><div class="sc-grid">{"".join(ecl_card(e) for e in ECLIPSES)}</div></section>
<section class="blk"><h2>{bt("Meteor showers every year", "हर साल के उल्कापात")}</h2><div class="sc-grid">{"".join(sh_card(s) for s in SHOWERS)}</div></section>'''
    desc = 'Every solar and lunar eclipse until 2029 and the main meteor showers: dates, times for your city, where to see them and how to watch safely.'
    h['write']('sky-events.html', k.shell('Eclipses and meteor showers', 'ग्रहण और उल्कापात', 'events', body, desc, canonical='sky-events.html', ld=article_ld(k.site, 'Eclipses and meteor showers', desc, 'sky-events.html', crumbs_hub)))
    return ['sky-events.html'] + pages
