"""When and how each world formed, in English and Hindi.

The ages come from meteorite and moon-rock dating, from space missions (MESSENGER, Cassini,
Juno, New Horizons, GRAIL, Galileo) and from planet-formation models. They are all estimates,
so every date says "about", and the open questions are said plainly.

FORM[id] = {
  'when': (en, hi)        short answer, shown big
  'took': (en, hi)        how long it took to form
  'how':  (en, hi)        two or three sentences
  'steps': [(t_en, t_hi, en, hi)]   a timeline, oldest first
  'open': (en, hi)        what scientists still argue about (optional)
}
"""

GA = ('About 4.6 billion years ago', 'लगभग 4.6 अरब साल पहले')

FORM = {
    'sun': {
        'when': ('About 4.6 billion years ago', 'लगभग 4.6 अरब साल पहले'),
        'took': ('About 50 million years to start shining steadily', 'स्थिर रूप से चमकने में लगभग 5 करोड़ साल'),
        'how': ('A small part of a huge cloud of gas and dust collapsed under its own gravity, perhaps pushed by the blast of a nearby exploding star. The centre grew hot and dense until hydrogen began to fuse into helium. Everything else in the solar system formed from the flat, spinning disk left around it.',
                'गैस और धूल के एक विशाल बादल का एक छोटा हिस्सा अपनी ही gravity से सिकुड़ गया, शायद पास के किसी फटते तारे के धक्के से। केंद्र इतना गर्म और घना हो गया कि hydrogen जुड़कर helium बनने लगी। सौरमंडल की बाकी हर चीज़ उसके चारों ओर बची चपटी, घूमती disk से बनी।'),
        'steps': [
            ('4.6 billion years ago', '4.6 अरब साल पहले', 'The cloud collapses; the oldest solid grains in meteorites date from this moment (4.567 billion years).', 'बादल सिकुड़ता है; उल्कापिंडों के सबसे पुराने ठोस कण इसी समय के हैं (4.567 अरब साल)।'),
            ('First 100,000 years', 'पहले 1 लाख साल', 'A glowing young star (a protostar) forms in the centre, wrapped in a disk of gas and dust.', 'केंद्र में एक चमकता नया तारा (protostar) बनता है, गैस और धूल की disk में लिपटा हुआ।'),
            ('About 50 million years later', 'लगभग 5 करोड़ साल बाद', 'Hydrogen fusion starts in the core and the Sun becomes a steady, grown-up star.', 'केंद्र में hydrogen fusion शुरू होता है और सूरज एक स्थिर, पूरा तारा बन जाता है।'),
            ('Today', 'आज', 'About halfway through its life; it is about 30% brighter than when it was young.', 'अपनी उम्र के लगभग बीच में; यह अपनी जवानी से लगभग 30% ज़्यादा चमकीला है।'),
            ('In about 5 billion years', 'लगभग 5 अरब साल बाद', 'It swells into a red giant, then shrinks into a white dwarf.', 'यह फूलकर red giant बनेगा, फिर सिकुड़कर white dwarf बन जाएगा।'),
        ],
    },
    'mercury': {
        'when': GA,
        'took': ('Probably a few tens of millions of years', 'शायद कुछ करोड़ साल'),
        'how': ('Rocky grains near the hot young Sun stuck together into bigger and bigger bodies that crashed and merged. Mercury ended up with a giant iron core that fills most of the planet.',
                'गर्म नए सूरज के पास पथरीले कण आपस में चिपककर बड़े और बड़े टुकड़े बने, जो टकराकर जुड़ते गए। बुध के पास एक विशाल लोहे का केंद्र बचा जो ग्रह का ज़्यादातर हिस्सा भरता है।'),
        'steps': [
            ('4.6 billion years ago', '4.6 अरब साल पहले', 'Dust and rock near the Sun clump into small planet seeds.', 'सूरज के पास धूल और चट्टान जुड़कर छोटे ग्रह-बीज बनते हैं।'),
            ('First tens of millions of years', 'पहले कुछ दसियों करोड़ साल', 'The seeds collide and merge into Mercury; heavy iron sinks to the centre.', 'बीज टकराकर बुध बनाते हैं; भारी लोहा केंद्र में डूब जाता है।'),
            ('About 4.1 to 3.8 billion years ago', 'लगभग 4.1 से 3.8 अरब साल पहले', 'Big impacts and lava floods shape the surface; huge basins like Caloris form.', 'बड़ी टक्करें और लावा की बाढ़ सतह बनाती हैं; Caloris जैसे विशाल गड्ढे बनते हैं।'),
            ('Since then', 'तब से', 'The planet slowly cools and shrinks, wrinkling its crust into long cliffs.', 'ग्रह धीरे-धीरे ठंडा होकर सिकुड़ता है, जिससे उसकी परत पर लंबी चट्टानी झुर्रियाँ बनती हैं।'),
        ],
        'open': ('Why is the iron core so big? A giant impact may have knocked away much of the rocky outer layer, but MESSENGER found easily-lost elements like sulfur and potassium on the surface, which a very violent past would have boiled away.',
                 'लोहे का केंद्र इतना बड़ा क्यों है? शायद एक बड़ी टक्कर ने बाहरी पथरीली परत का बड़ा हिस्सा उड़ा दिया, पर MESSENGER को सतह पर sulfur और potassium जैसे तत्व मिले जो इतने हिंसक अतीत में उड़ जाने चाहिए थे।'),
    },
    'venus': {
        'when': GA,
        'took': ('About as long as Earth, tens of millions of years', 'पृथ्वी जितना ही, कुछ करोड़ साल'),
        'how': ('Venus grew the same way as Earth and to almost the same size. Its story split from Earth\'s later: its air filled with carbon dioxide and trapped so much heat that any water boiled away.',
                'शुक्र पृथ्वी की तरह ही बना और लगभग उसी आकार का। उसकी कहानी बाद में अलग हुई: उसकी हवा carbon dioxide से भर गई और इतनी गर्मी फँसी कि सारा पानी उड़ गया।'),
        'steps': [
            ('4.6 billion years ago', '4.6 अरब साल पहले', 'Rocky planet seeds merge into Venus, close to Earth\'s size.', 'पथरीले ग्रह-बीज जुड़कर शुक्र बनाते हैं, लगभग पृथ्वी के आकार का।'),
            ('Early on (unsure)', 'शुरुआत में (पक्का नहीं)', 'It may have had shallow oceans while the young Sun was dimmer.', 'जब नया सूरज कम चमकीला था, तब शायद यहाँ उथले समुद्र थे।'),
            ('Later', 'बाद में', 'A runaway greenhouse effect heats the planet; water escapes to space.', 'बेकाबू greenhouse effect ग्रह को गर्म करता है; पानी अंतरिक्ष में उड़ जाता है।'),
            ('About 300 to 700 million years ago', 'लगभग 30 से 70 करोड़ साल पहले', 'Lava covers most of the surface, so the ground we see is fairly young.', 'लावा सतह के ज़्यादातर हिस्से को ढक देता है, इसलिए दिखने वाली ज़मीन काफ़ी नई है।'),
        ],
        'open': ('Did Venus ever have oceans, and for how long? Missions planned for the 2030s (VERITAS, DAVINCI, EnVision) are meant to find out.',
                 'क्या शुक्र पर कभी समुद्र थे, और कितने समय तक? 2030 के दशक के missions (VERITAS, DAVINCI, EnVision) यही पता लगाएँगे।'),
    },
    'earth': {
        'when': ('About 4.54 billion years ago', 'लगभग 4.54 अरब साल पहले'),
        'took': ('About 30 to 100 million years', 'लगभग 3 से 10 करोड़ साल'),
        'how': ('Earth grew from rocky planet seeds that collided and merged. Heavy iron sank to form the core. A Mars-sized body called Theia then hit the young Earth, and the debris formed the Moon.',
                'पृथ्वी पथरीले ग्रह-बीजों के टकराने और जुड़ने से बनी। भारी लोहा डूबकर केंद्र बना। फिर मंगल जितना बड़ा एक पिंड, Theia, नई पृथ्वी से टकराया और उसके मलबे से चाँद बना।'),
        'steps': [
            ('4.54 billion years ago', '4.54 अरब साल पहले', 'Planet seeds merge; Earth grows and heats up.', 'ग्रह-बीज जुड़ते हैं; पृथ्वी बढ़ती और गर्म होती है।'),
            ('In the first ~30 million years', 'पहले लगभग 3 करोड़ साल में', 'Iron sinks to the centre and forms the core.', 'लोहा केंद्र में डूबकर core बनाता है।'),
            ('About 4.5 billion years ago', 'लगभग 4.5 अरब साल पहले', 'The giant impact with Theia; the Moon forms from the debris.', 'Theia से बड़ी टक्कर; मलबे से चाँद बनता है।'),
            ('About 4.4 billion years ago', 'लगभग 4.4 अरब साल पहले', 'The oldest known crystals (zircons) show that liquid water already existed.', 'सबसे पुराने ज्ञात क्रिस्टल (zircon) बताते हैं कि तब तक तरल पानी मौजूद था।'),
            ('At least 3.5 billion years ago', 'कम से कम 3.5 अरब साल पहले', 'Life appears; about 2.4 billion years ago microbes fill the air with oxygen.', 'जीवन आता है; लगभग 2.4 अरब साल पहले सूक्ष्म जीव हवा को oxygen से भर देते हैं।'),
        ],
    },
    'moon': {
        'when': ('About 4.5 billion years ago', 'लगभग 4.5 अरब साल पहले'),
        'took': ('Very fast: perhaps hours to a few years', 'बहुत तेज़ी से: शायद कुछ घंटों से कुछ सालों में'),
        'how': ('A Mars-sized body called Theia hit the young Earth. Molten rock was thrown into orbit and gathered into the Moon. Apollo rocks have almost the same make-up as Earth\'s rocks, which supports this idea.',
                'मंगल जितना बड़ा एक पिंड, Theia, नई पृथ्वी से टकराया। पिघली चट्टान कक्षा में उछली और जुड़कर चाँद बनी। Apollo की चट्टानें लगभग पृथ्वी की चट्टानों जैसी हैं, जो इस विचार का समर्थन करता है।'),
        'steps': [
            ('About 4.5 billion years ago', 'लगभग 4.5 अरब साल पहले', 'The giant impact; a ring of molten debris circles Earth and clumps into the Moon.', 'बड़ी टक्कर; पिघले मलबे का छल्ला पृथ्वी के चारों ओर घूमता है और जुड़कर चाँद बनता है।'),
            ('Next ~100 million years', 'अगले लगभग 10 करोड़ साल', 'A global ocean of magma cools; light rock floats up to form the bright highlands.', 'magma का पूरा समुद्र ठंडा होता है; हल्की चट्टान ऊपर तैरकर चमकीले पहाड़ी इलाक़े बनाती है।'),
            ('About 3.9 to 3.1 billion years ago', 'लगभग 3.9 से 3.1 अरब साल पहले', 'Lava fills huge impact basins, making the dark "seas" (maria) we see.', 'लावा बड़े गड्ढों को भरता है और वे काले "समुद्र" (maria) बनते हैं जो हमें दिखते हैं।'),
            ('Since then', 'तब से', 'Mostly quiet; the Moon drifts away from Earth by about 3.8 cm a year.', 'ज़्यादातर शांत; चाँद हर साल लगभग 3.8 cm पृथ्वी से दूर जाता है।'),
        ],
        'open': ('The details of the impact are still argued: how big Theia was, how fast it hit, and why the Moon\'s rocks match Earth\'s so closely.',
                 'टक्कर की बारीकियों पर अभी भी बहस है: Theia कितना बड़ा था, कितनी तेज़ी से टकराया, और चाँद की चट्टानें पृथ्वी जैसी इतनी क्यों हैं।'),
    },
    'mars': {
        'when': GA,
        'took': ('Fast: about 2 to 4 million years', 'तेज़ी से: लगभग 20 से 40 लाख साल'),
        'how': ('Mars formed quickly and then stopped growing, which is why it stayed small. Meteorites from Mars show its core formed only a few million years after the solar system began. It once had rivers and lakes, then lost its magnetic field and most of its air.',
                'मंगल तेज़ी से बना और फिर बढ़ना रुक गया, इसीलिए छोटा रह गया। मंगल से आए उल्कापिंड बताते हैं कि उसका core सौरमंडल शुरू होने के कुछ ही दसियों लाख साल बाद बन गया था। कभी यहाँ नदियाँ और झीलें थीं, फिर इसने अपना magnetic field और ज़्यादातर हवा खो दी।'),
        'steps': [
            ('4.6 billion years ago', '4.6 अरब साल पहले', 'Mars grows to nearly full size within a few million years.', 'कुछ ही दसियों लाख साल में मंगल लगभग पूरे आकार का हो जाता है।'),
            ('About 4.1 to 3.7 billion years ago', 'लगभग 4.1 से 3.7 अरब साल पहले', 'A warmer, wetter time: rivers carve valleys and lakes fill craters like Jezero.', 'गर्म, गीला समय: नदियाँ घाटियाँ काटती हैं और Jezero जैसे गड्ढों में झीलें भरती हैं।'),
            ('About 4 billion years ago', 'लगभग 4 अरब साल पहले', 'Its global magnetic field fades; the solar wind strips away much of the air.', 'उसका magnetic field कमज़ोर पड़ता है; सौर हवा ज़्यादातर हवा उड़ा ले जाती है।'),
            ('Until recently', 'हाल तक', 'Giant volcanoes like Olympus Mons erupt from time to time; today Mars is cold and dry.', 'Olympus Mons जैसे विशाल ज्वालामुखी कभी-कभी फटते रहे; आज मंगल ठंडा और सूखा है।'),
        ],
        'open': ('Was early Mars warm for a long time or only in short bursts, and did life ever start there? Perseverance is collecting rock samples to help answer this.',
                 'क्या शुरुआती मंगल लंबे समय तक गर्म था या बस थोड़े-थोड़े समय के लिए, और क्या वहाँ कभी जीवन शुरू हुआ? Perseverance इसके लिए चट्टानों के नमूने जमा कर रहा है।'),
    },
    'jupiter': {
        'when': ('About 4.6 billion years ago, the first planet', 'लगभग 4.6 अरब साल पहले, सबसे पहला ग्रह'),
        'took': ('Its core in about 1 million years; the gas within a few million', 'core लगभग 10 लाख साल में; गैस कुछ दसियों लाख साल में'),
        'how': ('Beyond the "snow line", where water froze into ice, a solid core grew quickly to many times Earth\'s mass. Its gravity then pulled in huge amounts of hydrogen and helium gas. Jupiter was the first planet, and its gravity shaped where the others could form.',
                '"snow line" के आगे, जहाँ पानी बर्फ़ बन जाता था, एक ठोस core तेज़ी से पृथ्वी से कई गुना भारी हो गया। फिर उसकी gravity ने भारी मात्रा में hydrogen और helium गैस खींच ली। बृहस्पति सबसे पहला ग्रह था, और उसकी gravity ने तय किया कि बाकी ग्रह कहाँ बन सकते थे।'),
        'steps': [
            ('First ~1 million years', 'पहले लगभग 10 लाख साल', 'A core of rock and ice grows to about 20 times Earth\'s mass.', 'चट्टान और बर्फ़ का core पृथ्वी से लगभग 20 गुना भारी हो जाता है।'),
            ('Up to ~3 to 4 million years', 'लगभग 30 से 40 लाख साल तक', 'It pulls in gas fast; meteorites show it split the young disk into an inner and an outer part.', 'यह तेज़ी से गैस खींचता है; उल्कापिंड बताते हैं कि इसने नई disk को भीतरी और बाहरी हिस्से में बाँट दिया।'),
            ('Within ~10 million years', 'लगभग 1 करोड़ साल के अंदर', 'The gas disk is gone; Jupiter has its full size, and its big moons form around it.', 'गैस की disk ख़त्म हो जाती है; बृहस्पति पूरे आकार का हो जाता है और उसके बड़े चाँद बनते हैं।'),
            ('Today', 'आज', 'Juno found its core is not a small solid ball but "fuzzy", spread out and mixed with gas.', 'Juno ने पाया कि इसका core कोई छोटी ठोस गेंद नहीं, बल्कि "धुंधला" है, फैला हुआ और गैस से मिला हुआ।'),
        ],
        'open': ('Did Jupiter move inward toward the Sun and back out again early on (the "Grand Tack" idea)? It could explain why Mars is small, but it is not proven.',
                 'क्या शुरुआत में बृहस्पति सूरज की ओर अंदर आया और फिर वापस बाहर गया ("Grand Tack" विचार)? इससे पता चल सकता है कि मंगल छोटा क्यों है, पर यह साबित नहीं है।'),
    },
    'saturn': {
        'when': GA,
        'took': ('A few million years, soon after Jupiter', 'कुछ दसियों लाख साल, बृहस्पति के कुछ ही बाद'),
        'how': ('Saturn formed like Jupiter: an icy core first, then a thick blanket of hydrogen and helium. It grew a little later and caught less gas before the disk faded. Its famous rings came much later.',
                'शनि बृहस्पति की तरह बना: पहले बर्फ़ीला core, फिर hydrogen और helium की मोटी परत। यह थोड़ा बाद में बना और disk ख़त्म होने से पहले कम गैस पकड़ पाया। उसके मशहूर छल्ले बहुत बाद में आए।'),
        'steps': [
            ('First few million years', 'पहले कुछ दसियों लाख साल', 'An ice-and-rock core grows beyond Jupiter\'s orbit.', 'बृहस्पति की कक्षा के आगे बर्फ़ और चट्टान का core बढ़ता है।'),
            ('Before ~10 million years', 'लगभग 1 करोड़ साल से पहले', 'It pulls in gas until the disk around the Sun runs out.', 'सूरज के चारों ओर की disk ख़त्म होने तक यह गैस खींचता है।'),
            ('Soon after', 'उसके तुरंत बाद', 'Titan and the other moons form in a disk around Saturn.', 'Titan और बाकी चाँद शनि के चारों ओर की disk में बनते हैं।'),
            ('Perhaps a few hundred million years ago', 'शायद कुछ दसियों करोड़ साल पहले', 'Cassini\'s measurements suggest the rings may be only a few hundred million years old or less, but scientists still debate it.', 'Cassini के माप बताते हैं कि छल्ले शायद बस कुछ दसियों करोड़ साल या उससे भी कम पुराने हैं, पर वैज्ञानिक अभी भी बहस करते हैं।'),
        ],
        'open': ('Are the rings young, from a moon or comet torn apart, or as old as Saturn itself and just kept clean? Both ideas still have supporters.',
                 'क्या छल्ले नए हैं, किसी टूटे चाँद या धूमकेतु से, या शनि जितने ही पुराने और बस साफ़ बने रहे? दोनों विचारों के समर्थक हैं।'),
    },
    'uranus': {
        'when': GA,
        'took': ('Longer than Jupiter and Saturn, perhaps several million years', 'बृहस्पति और शनि से ज़्यादा, शायद कई दसियों लाख साल'),
        'how': ('Uranus grew a large core of ice and rock, but the gas disk was fading by then, so it caught only a thin layer of hydrogen and helium. That is why it is an "ice giant". It probably formed closer to the Sun and moved outward later. Something big knocked it onto its side.',
                'यूरेनस ने बर्फ़ और चट्टान का बड़ा core बनाया, पर तब तक गैस की disk ख़त्म हो रही थी, इसलिए उसे hydrogen और helium की पतली परत ही मिली। इसीलिए यह "ice giant" है। शायद यह सूरज के ज़्यादा पास बना और बाद में बाहर चला गया। किसी बड़ी चीज़ ने इसे करवट लिटा दिया।'),
        'steps': [
            ('First few million years', 'पहले कुछ दसियों लाख साल', 'An ice-rich core grows, probably closer to the Sun than today.', 'बर्फ़ से भरा core बढ़ता है, शायद आज से ज़्यादा सूरज के पास।'),
            ('As the gas fades', 'जब गैस ख़त्म हो रही थी', 'It gathers only a thin hydrogen-helium envelope.', 'इसे hydrogen-helium की बस पतली परत मिलती है।'),
            ('Early on', 'शुरुआत में', 'One or more giant impacts tilt it to about 98 degrees, rolling it around the Sun on its side.', 'एक या ज़्यादा बड़ी टक्करें इसे लगभग 98 डिग्री झुका देती हैं, यह करवट लेकर सूरज का चक्कर लगाता है।'),
            ('First few hundred million years', 'पहले कुछ दसियों करोड़ साल', 'The giant planets shuffle their orbits and Uranus settles farther out.', 'विशाल ग्रह अपनी कक्षाएँ बदलते हैं और यूरेनस और दूर जाकर बस जाता है।'),
        ],
        'open': ('Exactly what tipped Uranus over, and why it gives off so little inner heat, is still unknown. Only Voyager 2 has visited, in 1986.',
                 'यूरेनस को किसने पलटा, और यह अंदर से इतनी कम गर्मी क्यों छोड़ता है, यह अभी तक पता नहीं है। सिर्फ़ Voyager 2 वहाँ गया है, 1986 में।'),
    },
    'neptune': {
        'when': GA,
        'took': ('Several million years, like Uranus', 'कई दसियों लाख साल, यूरेनस की तरह'),
        'how': ('Neptune is Uranus\'s twin: a big ice-and-rock core with a thinner gas layer. It most likely formed closer to the Sun and was pushed outward, scattering icy bodies and shaping the Kuiper Belt beyond it.',
                'नेपच्यून यूरेनस का जुड़वाँ है: बर्फ़ और चट्टान का बड़ा core, गैस की पतली परत के साथ। सबसे संभावना है कि यह सूरज के ज़्यादा पास बना और बाहर धकेला गया, जिससे बर्फ़ीले पिंड बिखरे और उसके आगे Kuiper Belt बना।'),
        'steps': [
            ('First few million years', 'पहले कुछ दसियों लाख साल', 'An icy core grows and collects a thin envelope of gas.', 'बर्फ़ीला core बढ़ता है और गैस की पतली परत जमा करता है।'),
            ('First few hundred million years', 'पहले कुछ दसियों करोड़ साल', 'It migrates outward, scattering icy bodies; some are flung toward the inner planets.', 'यह बाहर की ओर खिसकता है, बर्फ़ीले पिंडों को बिखेरता है; कुछ भीतरी ग्रहों की ओर फेंके जाते हैं।'),
            ('During the move', 'इस सफ़र में', 'It pushes Pluto and other bodies into step with its own orbit (2 Pluto years for every 3 Neptune years).', 'यह प्लूटो और दूसरे पिंडों को अपनी कक्षा की लय में ले आता है (नेपच्यून के हर 3 साल में प्लूटो के 2 साल)।'),
            ('Later', 'बाद में', 'It captures Triton, a dwarf planet from the Kuiper Belt.', 'यह Kuiper Belt के एक बौने ग्रह, Triton, को पकड़ लेता है।'),
        ],
        'open': ('The exact path of the giant planets\' move (the "Nice model") is still being worked out.',
                 'विशाल ग्रहों के खिसकने का सही रास्ता ("Nice model") अभी भी समझा जा रहा है।'),
    },
    'pluto': {
        'when': GA,
        'took': ('Unknown; it grew slowly from icy bodies far from the Sun', 'पक्का नहीं; सूरज से दूर बर्फ़ीले पिंडों से धीरे-धीरे बना'),
        'how': ('Pluto formed in the cold outer disk from icy pebbles and small bodies, like many other Kuiper Belt objects. Its big moon Charon was probably made by a slow, glancing collision. Neptune\'s outward move later locked Pluto into its present orbit.',
                'प्लूटो ठंडी बाहरी disk में बर्फ़ीले कंकड़ों और छोटे पिंडों से बना, Kuiper Belt के बहुत से पिंडों की तरह। उसका बड़ा चाँद Charon शायद एक धीमी, तिरछी टक्कर से बना। बाद में नेपच्यून के बाहर खिसकने ने प्लूटो को उसकी आज की कक्षा में बाँध दिया।'),
        'steps': [
            ('4.6 billion years ago', '4.6 अरब साल पहले', 'Icy pebbles in the far disk gather into small worlds.', 'दूर की disk में बर्फ़ीले कंकड़ जुड़कर छोटी दुनियाएँ बनाते हैं।'),
            ('Early on', 'शुरुआत में', 'A collision with another body forms Charon and Pluto\'s small moons.', 'किसी दूसरे पिंड से टक्कर से Charon और प्लूटो के छोटे चाँद बनते हैं।'),
            ('First few hundred million years', 'पहले कुछ दसियों करोड़ साल', 'Neptune moves outward and pushes Pluto into its tilted, stretched orbit.', 'नेपच्यून बाहर खिसकता है और प्लूटो को उसकी झुकी, लंबी कक्षा में धकेल देता है।'),
            ('Recent', 'हाल में', 'New Horizons (2015) found young ice plains with no craters, so Pluto is still active.', 'New Horizons (2015) को बिना गड्ढों के नए बर्फ़ीले मैदान मिले, यानी प्लूटो अभी भी सक्रिय है।'),
        ],
        'open': ('What keeps Pluto active so far from the Sun? A hidden ocean under the ice is one possible answer.',
                 'सूरज से इतनी दूर प्लूटो को सक्रिय कौन रखता है? बर्फ़ के नीचे छिपा समुद्र एक संभावित जवाब है।'),
    },
    'io': {
        'when': ('About 4.6 billion years ago, with Jupiter', 'लगभग 4.6 अरब साल पहले, बृहस्पति के साथ'),
        'took': ('Within the first few million years', 'पहले कुछ दसियों लाख साल में'),
        'how': ('Io formed from a disk of gas and dust around the young Jupiter, like a small solar system. Its orbit is locked in step with Europa and Ganymede, so Jupiter\'s gravity keeps squeezing it, heating its inside. That is why Io has more volcanoes than any other world.',
                'Io नए बृहस्पति के चारों ओर गैस और धूल की disk से बना, एक छोटे सौरमंडल की तरह। इसकी कक्षा Europa और Ganymede की लय से बँधी है, इसलिए बृहस्पति की gravity इसे लगातार दबाती है और अंदर से गर्म करती है। इसीलिए Io पर किसी भी दुनिया से ज़्यादा ज्वालामुखी हैं।'),
        'steps': [
            ('First few million years', 'पहले कुछ दसियों लाख साल', 'Rock and dust near Jupiter gather into Io.', 'बृहस्पति के पास चट्टान और धूल जुड़कर Io बनाती है।'),
            ('Early on', 'शुरुआत में', 'Io, Europa and Ganymede fall into a 1:2:4 rhythm of orbits.', 'Io, Europa और Ganymede कक्षाओं की 1:2:4 लय में आ जाते हैं।'),
            ('Ever since', 'तब से', 'Tidal squeezing melts rock; about 400 volcanoes erupt, and the surface is renewed all the time.', 'ज्वारीय दबाव चट्टान पिघलाता है; लगभग 400 ज्वालामुखी फटते हैं और सतह लगातार नई होती रहती है।'),
        ],
    },
    'europa': {
        'when': ('About 4.6 billion years ago, with Jupiter', 'लगभग 4.6 अरब साल पहले, बृहस्पति के साथ'),
        'took': ('Within the first few million years', 'पहले कुछ दसियों लाख साल में'),
        'how': ('Europa formed from rock and ice in the disk around Jupiter. Heat from tidal squeezing keeps a salty ocean liquid under its icy shell. Its surface has few craters, so the ice is young, perhaps 40 to 90 million years.',
                'Europa बृहस्पति के चारों ओर की disk में चट्टान और बर्फ़ से बना। ज्वारीय दबाव की गर्मी इसकी बर्फ़ीली परत के नीचे एक खारे समुद्र को तरल रखती है। सतह पर गड्ढे कम हैं, इसलिए बर्फ़ नई है, शायद 4 से 9 करोड़ साल पुरानी।'),
        'steps': [
            ('First few million years', 'पहले कुछ दसियों लाख साल', 'Rock and ice gather; a rocky core forms with water on top.', 'चट्टान और बर्फ़ जुड़ते हैं; पथरीला core बनता है और ऊपर पानी।'),
            ('Early on', 'शुरुआत में', 'The outer water freezes into a shell, with an ocean left below.', 'बाहरी पानी जमकर परत बनता है, नीचे समुद्र बच जाता है।'),
            ('Last ~100 million years', 'पिछले लगभग 10 करोड़ साल', 'Cracks and ridges keep renewing the ice; plumes of water may escape.', 'दरारें और लकीरें बर्फ़ को नया करती रहती हैं; पानी की धाराएँ शायद बाहर निकलती हैं।'),
        ],
        'open': ('Could the ocean hold life? NASA\'s Europa Clipper, launched in 2024, arrives in 2030 to study it.',
                 'क्या समुद्र में जीवन हो सकता है? NASA का Europa Clipper, 2024 में launch हुआ, 2030 में पहुँचकर इसकी जाँच करेगा।'),
    },
    'ganymede': {
        'when': ('About 4.6 billion years ago, with Jupiter', 'लगभग 4.6 अरब साल पहले, बृहस्पति के साथ'),
        'took': ('Within the first few million years', 'पहले कुछ दसियों लाख साल में'),
        'how': ('The biggest moon in the solar system formed from rock and ice around Jupiter. It got warm enough inside to separate into layers, with an iron core that still makes its own magnetic field, the only moon known to have one.',
                'सौरमंडल का सबसे बड़ा चाँद बृहस्पति के चारों ओर चट्टान और बर्फ़ से बना। यह अंदर से इतना गर्म हुआ कि परतों में बँट गया, और इसका लोहे का core आज भी अपना magnetic field बनाता है। यह अकेला ज्ञात चाँद है जिसके पास यह है।'),
        'steps': [
            ('First few million years', 'पहले कुछ दसियों लाख साल', 'Rock and ice gather into a huge moon.', 'चट्टान और बर्फ़ जुड़कर एक विशाल चाँद बनाते हैं।'),
            ('Early on', 'शुरुआत में', 'It separates into an iron core, a rocky layer, ice and a deep ocean.', 'यह लोहे के core, पथरीली परत, बर्फ़ और गहरे समुद्र में बँट जाता है।'),
            ('Billions of years', 'अरबों साल', 'Old dark areas and younger grooved bright areas form on the surface.', 'सतह पर पुराने काले इलाक़े और नए, धारीदार चमकीले इलाक़े बनते हैं।'),
        ],
        'open': ('ESA\'s JUICE spacecraft, launched in 2023, will orbit Ganymede from 2034 to study its hidden ocean.',
                 'ESA का JUICE यान, 2023 में launch हुआ, 2034 से Ganymede की परिक्रमा करके उसका छिपा समुद्र पढ़ेगा।'),
    },
    'callisto': {
        'when': ('About 4.6 billion years ago, with Jupiter', 'लगभग 4.6 अरब साल पहले, बृहस्पति के साथ'),
        'took': ('Slowly, perhaps over a million years or more', 'धीरे-धीरे, शायद 10 लाख साल या ज़्यादा'),
        'how': ('Callisto formed farthest out among Jupiter\'s big moons and grew slowly, so it never got hot enough to fully separate rock from ice. It is not squeezed by tides, so its surface is the oldest and most cratered in the solar system.',
                'Callisto बृहस्पति के बड़े चाँदों में सबसे दूर बना और धीरे-धीरे बढ़ा, इसलिए यह कभी इतना गर्म नहीं हुआ कि चट्टान और बर्फ़ पूरी तरह अलग हो सकें। इस पर ज्वारीय दबाव नहीं पड़ता, इसलिए इसकी सतह सौरमंडल की सबसे पुरानी और सबसे ज़्यादा गड्ढों वाली है।'),
        'steps': [
            ('First million years or more', 'पहले 10 लाख साल या ज़्यादा', 'Rock and ice slowly gather in the outer part of Jupiter\'s disk.', 'बृहस्पति की disk के बाहरी हिस्से में चट्टान और बर्फ़ धीरे-धीरे जुड़ते हैं।'),
            ('About 4 billion years ago', 'लगभग 4 अरब साल पहले', 'Heavy bombardment covers it in craters, including the giant Valhalla basin.', 'भारी बमबारी इसे गड्ढों से ढक देती है, जिसमें विशाल Valhalla गड्ढा भी है।'),
            ('Since then', 'तब से', 'Almost unchanged; Galileo found signs of a salty ocean deep inside.', 'लगभग बदला नहीं; Galileo को गहराई में खारे समुद्र के संकेत मिले।'),
        ],
    },
    'titan': {
        'when': ('About 4.6 billion years ago, with Saturn', 'लगभग 4.6 अरब साल पहले, शनि के साथ'),
        'took': ('Within the first few million years', 'पहले कुछ दसियों लाख साल में'),
        'how': ('Titan formed from rock and ice in the disk around Saturn. It is the only moon with a thick atmosphere, mostly nitrogen, which may have come from ammonia ice broken apart long ago. Today it has rain, rivers and lakes of liquid methane.',
                'Titan शनि के चारों ओर की disk में चट्टान और बर्फ़ से बना। यह अकेला चाँद है जिसकी हवा घनी है, ज़्यादातर nitrogen, जो शायद बहुत पहले टूटी ammonia बर्फ़ से आई। आज यहाँ तरल methane की बारिश, नदियाँ और झीलें हैं।'),
        'steps': [
            ('First few million years', 'पहले कुछ दसियों लाख साल', 'Rock and ice gather into a moon bigger than Mercury.', 'चट्टान और बर्फ़ जुड़कर बुध से बड़ा चाँद बनाते हैं।'),
            ('Early on (unsure)', 'शुरुआत में (पक्का नहीं)', 'Its thick nitrogen air forms, perhaps from ammonia in its ice.', 'इसकी घनी nitrogen हवा बनती है, शायद इसकी बर्फ़ की ammonia से।'),
            ('Today', 'आज', 'Methane rain fills lakes near the poles; an ocean of water lies deep below the ice.', 'methane की बारिश ध्रुवों के पास झीलें भरती है; बर्फ़ के नीचे गहराई में पानी का समुद्र है।'),
        ],
        'open': ('Where Titan\'s methane comes from, since sunlight keeps destroying it, is still a puzzle. NASA\'s Dragonfly drone is due to arrive in 2034.',
                 'Titan का methane कहाँ से आता है, जबकि सूरज की रोशनी उसे लगातार तोड़ती है, यह अभी पहेली है। NASA का Dragonfly drone 2034 में पहुँचेगा।'),
    },
    'enceladus': {
        'when': ('With Saturn, about 4.6 billion years ago (some think later)', 'शनि के साथ, लगभग 4.6 अरब साल पहले (कुछ के अनुसार बाद में)'),
        'took': ('Unknown', 'पक्का नहीं'),
        'how': ('Enceladus is a small moon of ice and rock. Tidal squeezing from Saturn heats it enough to keep a salty ocean under the south pole, which sprays water into space through cracks. Cassini flew through these jets and tasted salt and simple organic molecules.',
                'Enceladus बर्फ़ और चट्टान का छोटा चाँद है। शनि का ज्वारीय दबाव इसे इतना गर्म करता है कि दक्षिणी ध्रुव के नीचे खारा समुद्र तरल रहता है, जो दरारों से पानी अंतरिक्ष में उछालता है। Cassini इन धाराओं के बीच से उड़ा और उसे नमक और सरल organic अणु मिले।'),
        'steps': [
            ('4.6 billion years ago (or later)', '4.6 अरब साल पहले (या बाद में)', 'Ice and rock gather into a small moon.', 'बर्फ़ और चट्टान जुड़कर एक छोटा चाँद बनाते हैं।'),
            ('Over time', 'समय के साथ', 'Tidal heating melts a global ocean under the ice shell.', 'ज्वारीय गर्मी बर्फ़ की परत के नीचे पूरा समुद्र पिघला देती है।'),
            ('Today', 'आज', 'More than 100 geysers spray from the "tiger stripes"; the spray feeds Saturn\'s E ring.', '"tiger stripes" से 100 से ज़्यादा फव्वारे उछलते हैं; यही फुहार शनि के E ring को भरती है।'),
        ],
        'open': ('Some models say Saturn\'s mid-sized moons, Enceladus among them, are only about 100 million years old. Others say they are as old as Saturn. It is not settled.',
                 'कुछ models कहते हैं कि शनि के मँझले चाँद, Enceladus भी, बस लगभग 10 करोड़ साल पुराने हैं। दूसरे कहते हैं वे शनि जितने पुराने हैं। यह तय नहीं है।'),
    },
    'triton': {
        'when': ('In the Kuiper Belt about 4.6 billion years ago; captured later', 'लगभग 4.6 अरब साल पहले Kuiper Belt में; बाद में पकड़ा गया'),
        'took': ('Unknown', 'पक्का नहीं'),
        'how': ('Triton did not form around Neptune. It goes around Neptune backwards, which a moon born there would not do, so it was probably a dwarf planet like Pluto that Neptune captured. The capture heated and reshaped it.',
                'Triton नेपच्यून के चारों ओर नहीं बना। यह नेपच्यून के चारों ओर उल्टी दिशा में घूमता है, जो वहाँ जन्मा चाँद नहीं करता, इसलिए यह शायद प्लूटो जैसा बौना ग्रह था जिसे नेपच्यून ने पकड़ लिया। पकड़े जाने से यह गर्म हुआ और इसका रूप बदला।'),
        'steps': [
            ('4.6 billion years ago', '4.6 अरब साल पहले', 'It forms in the Kuiper Belt, perhaps as one of a pair of bodies.', 'यह Kuiper Belt में बनता है, शायद दो पिंडों की जोड़ी में से एक।'),
            ('Later (unknown when)', 'बाद में (कब, पता नहीं)', 'Neptune captures it into a backwards orbit; tides heat it.', 'नेपच्यून इसे उल्टी कक्षा में पकड़ लेता है; ज्वार इसे गर्म करते हैं।'),
            ('Today', 'आज', 'Voyager 2 (1989) saw nitrogen geysers and a young surface.', 'Voyager 2 (1989) ने nitrogen के फव्वारे और नई सतह देखी।'),
            ('In billions of years', 'अरबों साल बाद', 'Its orbit slowly shrinks; Neptune\'s gravity may tear it into a ring.', 'इसकी कक्षा धीरे-धीरे छोटी होगी; नेपच्यून की gravity शायद इसे तोड़कर छल्ला बना दे।'),
        ],
    },
}
