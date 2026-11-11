"""Pages for school students (about class 6 to 10): simple English and Hindi, a "remember" box and a short quiz on each page.
Topics follow what school science books cover about the Sun, the Earth, the Moon and the sky."""
from dskit import Kit, article_ld

# slug, icon, title (en, hi), lead (en, hi), sections [(h en, h hi, p en, p hi)], remember [(en, hi)], quiz [(q en, q hi, [(opt en, opt hi)], right index)]
TOPICS = [
    ('sun-earth-moon', '🌍', ('The Sun, the Earth and the Moon', 'सूर्य, पृथ्वी और चाँद'),
     ('Three neighbours that shape our days, months and years.', 'तीन पड़ोसी जो हमारे दिन, महीने और साल तय करते हैं।'),
     [('The Sun is a star', 'सूर्य एक तारा है',
       'The Sun is a huge ball of hot gas that makes its own light and heat. It is about 109 times wider than the Earth and about 15 crore (150 million) km away. Its light takes about 8 minutes and 20 seconds to reach us.',
       'सूर्य गर्म गैस का एक विशाल गोला है जो अपनी रोशनी और गर्मी ख़ुद बनाता है। यह पृथ्वी से लगभग 109 गुना चौड़ा है और लगभग 15 करोड़ किमी दूर है। इसकी रोशनी को हम तक पहुँचने में लगभग 8 मिनट 20 सेकंड लगते हैं।'),
      ('The Earth is a planet', 'पृथ्वी एक ग्रह है',
       'The Earth does not make light. It goes around the Sun once in about 365¼ days (a year) and spins on its own axis once in a day. It is the only planet we know with liquid water on its surface and life.',
       'पृथ्वी रोशनी नहीं बनाती। यह लगभग 365¼ दिन (एक साल) में सूर्य का एक चक्कर लगाती है और एक दिन में अपनी धुरी पर एक बार घूमती है। यह अकेला ग्रह है जिसकी सतह पर तरल पानी और जीवन हमें पता है।'),
      ('The Moon is a satellite', 'चाँद एक उपग्रह है',
       'The Moon goes around the Earth about once a month (27.3 days). It has no light of its own: we see it because sunlight falls on it. It is about 3,84,000 km away, and the same side always faces us.',
       'चाँद लगभग एक महीने (27.3 दिन) में पृथ्वी का एक चक्कर लगाता है। इसकी अपनी रोशनी नहीं है: हम इसे इसलिए देखते हैं क्योंकि इस पर धूप पड़ती है। यह लगभग 3,84,000 किमी दूर है, और इसका एक ही हिस्सा हमेशा हमारी तरफ़ रहता है।')],
     [('Sun = star (makes light). Earth = planet. Moon = natural satellite.', 'सूर्य = तारा (रोशनी बनाता है)। पृथ्वी = ग्रह। चाँद = प्राकृतिक उपग्रह।'),
      ('Earth: one spin = one day, one trip around the Sun = one year.', 'पृथ्वी: एक बार घूमना = एक दिन, सूर्य का एक चक्कर = एक साल।')],
     [('Which of these makes its own light?', 'इनमें से कौन अपनी रोशनी ख़ुद बनाता है?', [('The Moon', 'चाँद'), ('The Sun', 'सूर्य'), ('The Earth', 'पृथ्वी')], 1),
      ('How long does sunlight take to reach the Earth?', 'धूप को पृथ्वी तक पहुँचने में कितना समय लगता है?', [('About 8 seconds', 'लगभग 8 सेकंड'), ('About 8 minutes', 'लगभग 8 मिनट'), ('About 8 hours', 'लगभग 8 घंटे')], 1),
      ('Why can we see the Moon?', 'हम चाँद को क्यों देख पाते हैं?', [('It burns like a fire', 'वह आग की तरह जलता है'), ('Sunlight falls on it', 'उस पर धूप पड़ती है'), ('It is made of ice', 'वह बर्फ़ का बना है')], 1)]),

    ('moon-phases', '🌓', ('Phases of the Moon', 'चाँद की कलाएँ'),
     ('Why the Moon seems to grow and shrink over a month.', 'चाँद महीने भर में बढ़ता और घटता क्यों दिखता है।'),
     [('Half of the Moon is always lit', 'चाँद का आधा हिस्सा हमेशा रोशन रहता है',
       'The Sun always lights half of the Moon, just as it lights half of the Earth (day side). As the Moon goes around us, we see different amounts of that lit half. This changing shape is called the phase of the Moon.',
       'सूर्य हमेशा चाँद का आधा हिस्सा रोशन करता है, जैसे वह पृथ्वी का आधा हिस्सा (दिन वाला) रोशन करता है। जैसे-जैसे चाँद हमारा चक्कर लगाता है, हमें उस रोशन आधे का अलग-अलग हिस्सा दिखता है। इस बदलते आकार को चाँद की कला कहते हैं।'),
      ('From new Moon to full Moon', 'अमावस्या से पूर्णिमा तक',
       'New Moon (amavasya): the Moon is between the Earth and the Sun, and we see its dark side. Then a thin crescent, the first quarter (half Moon), a gibbous Moon, and after about 15 days the full Moon (purnima), when the Earth is between the Sun and the Moon. Then the Moon shrinks again.',
       'अमावस्या: चाँद पृथ्वी और सूर्य के बीच होता है और हमें उसका अँधेरा हिस्सा दिखता है। फिर पतली हँसिया, पहला चौथाई (आधा चाँद), फिर बड़ा चाँद, और लगभग 15 दिन बाद पूर्णिमा, जब पृथ्वी सूर्य और चाँद के बीच होती है। फिर चाँद फिर से घटता है।'),
      ('Shukla and Krishna paksha', 'शुक्ल और कृष्ण पक्ष',
       'The growing half of the month is shukla paksha (waxing), the shrinking half is krishna paksha (waning). One full cycle from new Moon to new Moon takes about 29.5 days, a little longer than the Moon’s 27.3-day trip around us, because the Earth also moves around the Sun meanwhile.',
       'महीने का बढ़ता हिस्सा शुक्ल पक्ष है, घटता हिस्सा कृष्ण पक्ष। अमावस्या से अमावस्या तक एक पूरा चक्र लगभग 29.5 दिन का होता है, जो चाँद के 27.3 दिन के चक्कर से थोड़ा ज़्यादा है, क्योंकि इस बीच पृथ्वी भी सूर्य के चारों ओर आगे बढ़ जाती है।')],
     [('Phases happen because we see different parts of the Moon’s lit half, not because of Earth’s shadow.', 'कलाएँ इसलिए बनती हैं क्योंकि हमें चाँद के रोशन आधे का अलग हिस्सा दिखता है, पृथ्वी की छाया की वजह से नहीं।'),
      ('New Moon to new Moon: about 29.5 days.', 'अमावस्या से अमावस्या: लगभग 29.5 दिन।')],
     [('What causes the phases of the Moon?', 'चाँद की कलाएँ किस वजह से होती हैं?', [('Earth’s shadow on the Moon', 'चाँद पर पृथ्वी की छाया'), ('Seeing different parts of its lit half', 'उसके रोशन आधे का अलग हिस्सा दिखना'), ('Clouds', 'बादल')], 1),
      ('At full Moon, which body is in the middle?', 'पूर्णिमा पर बीच में कौन होता है?', [('The Earth', 'पृथ्वी'), ('The Moon', 'चाँद'), ('The Sun', 'सूर्य')], 0),
      ('How long is one cycle of phases?', 'कलाओं का एक चक्र कितना लंबा होता है?', [('About 7 days', 'लगभग 7 दिन'), ('About 29.5 days', 'लगभग 29.5 दिन'), ('About 365 days', 'लगभग 365 दिन')], 1)]),

    ('eclipses', '🌑', ('Solar and lunar eclipses', 'सूर्य और चंद्र ग्रहण'),
     ('What happens when the Sun, the Earth and the Moon line up.', 'जब सूर्य, पृथ्वी और चाँद एक सीध में आते हैं तो क्या होता है।'),
     [('Solar eclipse', 'सूर्य ग्रहण',
       'When the Moon comes exactly between the Sun and the Earth, its shadow falls on the Earth and blocks the Sun. This can only happen on a new Moon day. If the Moon covers the Sun completely it is a total eclipse; if a ring of Sun is left it is an annular eclipse.',
       'जब चाँद ठीक सूर्य और पृथ्वी के बीच आ जाता है, तो उसकी छाया पृथ्वी पर पड़ती है और सूर्य ढक जाता है। यह सिर्फ़ अमावस्या के दिन हो सकता है। अगर चाँद सूर्य को पूरा ढक ले तो पूर्ण ग्रहण, और सूर्य की अंगूठी बची रहे तो वलयाकार ग्रहण होता है।'),
      ('Lunar eclipse', 'चंद्र ग्रहण',
       'When the Earth comes exactly between the Sun and the Moon, Earth’s shadow falls on the Moon. This can only happen on a full Moon night. In a total lunar eclipse the Moon turns red, because a little sunlight bends through Earth’s air and reaches it.',
       'जब पृथ्वी ठीक सूर्य और चाँद के बीच आ जाती है, तो पृथ्वी की छाया चाँद पर पड़ती है। यह सिर्फ़ पूर्णिमा की रात हो सकता है। पूर्ण चंद्र ग्रहण में चाँद लाल हो जाता है, क्योंकि थोड़ी धूप पृथ्वी की हवा से मुड़कर उस तक पहुँचती है।'),
      ('Why not every month?', 'हर महीने क्यों नहीं?',
       'The Moon’s path is tilted by about 5° to the Earth’s path around the Sun. So most months the Moon passes a little above or below the line. Eclipses happen only when a new or full Moon falls near the points where the two paths cross: two to five times a year.',
       'चाँद का रास्ता पृथ्वी के सूर्य वाले रास्ते से लगभग 5° झुका है। इसलिए ज़्यादातर महीनों में चाँद सीध से थोड़ा ऊपर या नीचे से निकल जाता है। ग्रहण तभी होता है जब अमावस्या या पूर्णिमा उन बिंदुओं के पास पड़े जहाँ दोनों रास्ते मिलते हैं: साल में दो से पाँच बार।'),
      ('Watch safely', 'सुरक्षित देखिए',
       'Never look at the Sun directly, even during an eclipse: it can damage your eyes for ever. Use certified eclipse glasses or a pinhole projector. A lunar eclipse is completely safe to look at.',
       'सूर्य को कभी सीधे मत देखिए, ग्रहण में भी नहीं: इससे आँखें हमेशा के लिए ख़राब हो सकती हैं। प्रमाणित eclipse चश्मा या pinhole projector इस्तेमाल कीजिए। चंद्र ग्रहण देखना पूरी तरह सुरक्षित है।')],
     [('Solar eclipse: Moon in the middle, on amavasya. Lunar eclipse: Earth in the middle, on purnima.', 'सूर्य ग्रहण: बीच में चाँद, अमावस्या को। चंद्र ग्रहण: बीच में पृथ्वी, पूर्णिमा को।'),
      ('Never look at the Sun without proper eclipse glasses.', 'सही eclipse चश्मे के बिना सूर्य को कभी मत देखिए।')],
     [('A solar eclipse can happen only on…', 'सूर्य ग्रहण सिर्फ़ किस दिन हो सकता है?', [('Full Moon (purnima)', 'पूर्णिमा'), ('New Moon (amavasya)', 'अमावस्या'), ('Any day', 'किसी भी दिन')], 1),
      ('What is in the middle during a lunar eclipse?', 'चंद्र ग्रहण में बीच में क्या होता है?', [('The Moon', 'चाँद'), ('The Sun', 'सूर्य'), ('The Earth', 'पृथ्वी')], 2),
      ('Why is there no eclipse every month?', 'हर महीने ग्रहण क्यों नहीं होता?', [('The Moon’s path is tilted', 'चाँद का रास्ता झुका हुआ है'), ('The Sun hides', 'सूर्य छिप जाता है'), ('The Moon stops', 'चाँद रुक जाता है')], 0)]),

    ('solar-system', '🪐', ('The Solar System', 'सौर मंडल'),
     ('The Sun and everything that goes around it.', 'सूर्य और उसके चारों ओर घूमने वाली हर चीज़।'),
     [('Eight planets', 'आठ ग्रह',
       'In order from the Sun: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus and Neptune. A simple way to remember: "My Very Educated Mother Just Served Us Nachos". All of them go around the Sun in the same direction.',
       'सूर्य से क्रम में: बुध, शुक्र, पृथ्वी, मंगल, बृहस्पति, शनि, अरुण (यूरेनस) और वरुण (नेपच्यून)। याद रखने का आसान तरीका: "बु-शु-पृ-मं-बृ-श-अ-व"। सब एक ही दिशा में सूर्य का चक्कर लगाते हैं।'),
      ('Rocky and giant planets', 'चट्टानी और विशाल ग्रह',
       'The four inner planets are small and rocky. The four outer planets are giants: Jupiter and Saturn are mostly gas, Uranus and Neptune are icy giants. Jupiter is the biggest: more than 1,300 Earths would fit inside it.',
       'अंदर के चार ग्रह छोटे और चट्टानी हैं। बाहर के चार विशाल हैं: बृहस्पति और शनि ज़्यादातर गैस के, अरुण और वरुण बर्फ़ीले। बृहस्पति सबसे बड़ा है: इसमें 1,300 से ज़्यादा पृथ्वियाँ समा जाएँ।'),
      ('Dwarf planets, asteroids and comets', 'बौने ग्रह, क्षुद्रग्रह और धूमकेतु',
       'Pluto was called a planet until 2006; now it is a dwarf planet. Between Mars and Jupiter lies the asteroid belt, full of rocks. Comets are balls of ice and dust from far away; near the Sun they grow long glowing tails.',
       '2006 तक प्लूटो को ग्रह कहा जाता था; अब वह बौना ग्रह है। मंगल और बृहस्पति के बीच क्षुद्रग्रहों की पट्टी है, चट्टानों से भरी। धूमकेतु दूर से आने वाले बर्फ़ और धूल के गोले हैं; सूर्य के पास उनकी लंबी चमकती पूँछ बन जाती है।')],
     [('8 planets: 4 rocky (inner), 4 giants (outer). Pluto is a dwarf planet.', '8 ग्रह: 4 चट्टानी (अंदर), 4 विशाल (बाहर)। प्लूटो बौना ग्रह है।'),
      ('Biggest: Jupiter. Closest to the Sun: Mercury. Hottest: Venus.', 'सबसे बड़ा: बृहस्पति। सूर्य के सबसे पास: बुध। सबसे गर्म: शुक्र।')],
     [('Which planet is the largest?', 'सबसे बड़ा ग्रह कौन-सा है?', [('Saturn', 'शनि'), ('Jupiter', 'बृहस्पति'), ('Earth', 'पृथ्वी')], 1),
      ('Where is the asteroid belt?', 'क्षुद्रग्रहों की पट्टी कहाँ है?', [('Between Mars and Jupiter', 'मंगल और बृहस्पति के बीच'), ('Between Earth and Mars', 'पृथ्वी और मंगल के बीच'), ('Beyond Neptune', 'वरुण के बाद')], 0),
      ('What is Pluto now?', 'प्लूटो अब क्या है?', [('A planet', 'ग्रह'), ('A dwarf planet', 'बौना ग्रह'), ('A comet', 'धूमकेतु')], 1)]),

    ('stars-and-constellations', '✨', ('Stars and constellations', 'तारे और तारामंडल'),
     ('What stars are, and the patterns people have seen in them.', 'तारे क्या हैं, और लोगों ने उनमें कौन-से आकार देखे।'),
     [('Stars are distant suns', 'तारे दूर के सूरज हैं',
       'Every star is a sun, many of them bigger than ours, but so far away that they look like points. The nearest star after the Sun, Proxima Centauri, is about 4.2 light-years away: its light takes over four years to reach us.',
       'हर तारा एक सूरज है, उनमें से कई हमारे सूरज से बड़े, पर इतनी दूर कि बिंदु जैसे दिखते हैं। सूरज के बाद सबसे पास का तारा, प्रॉक्सिमा सेंटॉरी, लगभग 4.2 प्रकाश-वर्ष दूर है: उसकी रोशनी को हम तक आने में चार साल से ज़्यादा लगते हैं।'),
      ('Constellations', 'तारामंडल',
       'A constellation is a group of stars that seems to make a shape, like Orion (the hunter) or Ursa Major. Astronomers divide the whole sky into 88 constellations. The stars in one constellation are usually not close to each other at all; they only look close from Earth.',
       'तारामंडल तारों का एक समूह है जो कोई आकार बनाता लगता है, जैसे ओरायन (शिकारी) या सप्तर्षि वाला वृहत सप्तर्षि। खगोलविद पूरे आसमान को 88 तारामंडलों में बाँटते हैं। एक तारामंडल के तारे आमतौर पर एक-दूसरे के पास नहीं होते; बस पृथ्वी से पास दिखते हैं।'),
      ('Saptarishi and the Pole Star', 'सप्तर्षि और ध्रुव तारा',
       'Seven bright stars of Ursa Major form the Saptarishi (Big Dipper). The two stars at its front point to Dhruv tara, the Pole Star, which stays almost still in the north while the whole sky turns around it. Travellers used it to find north.',
       'वृहत सप्तर्षि के सात चमकीले तारे सप्तर्षि बनाते हैं। इसके आगे के दो तारे ध्रुव तारे की ओर इशारा करते हैं, जो उत्तर में लगभग एक जगह टिका रहता है जबकि पूरा आसमान उसके चारों ओर घूमता है। यात्री इससे उत्तर दिशा पहचानते थे।'),
      ('Why stars twinkle', 'तारे टिमटिमाते क्यों हैं',
       'Starlight passes through moving layers of Earth’s air, which bend it this way and that, so stars seem to twinkle. Planets twinkle much less because they look like tiny discs, not points.',
       'तारों की रोशनी पृथ्वी की हवा की हिलती परतों से गुज़रती है, जो उसे इधर-उधर मोड़ देती हैं, इसलिए तारे टिमटिमाते लगते हैं। ग्रह बहुत कम टिमटिमाते हैं क्योंकि वे बिंदु नहीं, नन्ही तश्तरी जैसे दिखते हैं।')],
     [('Stars are suns; planets only reflect light.', 'तारे सूरज हैं; ग्रह सिर्फ़ रोशनी लौटाते हैं।'),
      ('88 constellations. Saptarishi points to the Pole Star, which shows north.', '88 तारामंडल। सप्तर्षि ध्रुव तारे की ओर इशारा करता है, जो उत्तर दिखाता है।')],
     [('What is a star?', 'तारा क्या है?', [('A distant sun', 'दूर का सूरज'), ('A small planet', 'छोटा ग्रह'), ('A hole in the sky', 'आसमान में छेद')], 0),
      ('Which star helps to find north?', 'उत्तर दिशा पहचानने में कौन-सा तारा मदद करता है?', [('Sirius', 'व्याध (Sirius)'), ('The Pole Star', 'ध्रुव तारा'), ('The Sun', 'सूर्य')], 1),
      ('Why do planets twinkle less than stars?', 'ग्रह तारों से कम क्यों टिमटिमाते हैं?', [('They are hotter', 'वे ज़्यादा गर्म हैं'), ('They look like tiny discs', 'वे नन्ही तश्तरी जैसे दिखते हैं'), ('They are farther', 'वे ज़्यादा दूर हैं')], 1)]),

    ('day-night-seasons', '🌗', ('Day, night and the seasons', 'दिन, रात और ऋतुएँ'),
     ('How the Earth’s spin and tilt give us days and seasons.', 'पृथ्वी का घूमना और झुकाव हमें दिन और ऋतुएँ कैसे देते हैं।'),
     [('Day and night', 'दिन और रात',
       'The Earth spins from west to east once in about 24 hours. The half facing the Sun has day, the other half has night. That is why the Sun seems to rise in the east and set in the west.',
       'पृथ्वी लगभग 24 घंटे में पश्चिम से पूर्व की ओर एक बार घूमती है। सूर्य की तरफ़ वाले आधे हिस्से में दिन होता है, दूसरे आधे में रात। इसीलिए सूर्य पूर्व में उगता और पश्चिम में डूबता दिखता है।'),
      ('The tilted Earth', 'झुकी हुई पृथ्वी',
       'The Earth’s axis is tilted by about 23.5°. As the Earth goes around the Sun, for part of the year the northern half leans towards the Sun (summer there: long days, high Sun) and for part of the year it leans away (winter: short days, low Sun).',
       'पृथ्वी की धुरी लगभग 23.5° झुकी है। सूर्य का चक्कर लगाते हुए साल के एक हिस्से में उत्तरी आधा सूर्य की ओर झुका रहता है (वहाँ गर्मी: लंबे दिन, ऊँचा सूर्य) और दूसरे हिस्से में दूर (सर्दी: छोटे दिन, नीचा सूर्य)।'),
      ('Not because of distance', 'दूरी की वजह से नहीं',
       'Seasons are not caused by the Earth being nearer or farther from the Sun. In fact the Earth is closest to the Sun in early January, during the northern winter. When it is summer in India, it is winter in Australia.',
       'ऋतुएँ पृथ्वी के सूर्य से पास या दूर होने से नहीं होतीं। असल में पृथ्वी जनवरी की शुरुआत में सूर्य के सबसे पास होती है, उत्तरी सर्दी के समय। जब भारत में गर्मी होती है, तब ऑस्ट्रेलिया में सर्दी होती है।'),
      ('Solstices and equinoxes', 'अयनांत और विषुव',
       'Around 21 June the day is longest in the northern half (summer solstice) and around 22 December it is shortest (winter solstice). Around 20 March and 23 September day and night are nearly equal everywhere (equinoxes).',
       '21 जून के आसपास उत्तरी हिस्से में दिन सबसे लंबा (ग्रीष्म अयनांत) और 22 दिसंबर के आसपास सबसे छोटा (शीत अयनांत) होता है। 20 मार्च और 23 सितंबर के आसपास हर जगह दिन और रात लगभग बराबर होते हैं (विषुव)।')],
     [('Spin (rotation) → day and night. Trip around the Sun (revolution) + tilt → seasons.', 'घूर्णन → दिन और रात। सूर्य का चक्कर (परिक्रमा) + झुकाव → ऋतुएँ।'),
      ('Earth’s axis is tilted about 23.5°.', 'पृथ्वी की धुरी लगभग 23.5° झुकी है।')],
     [('What causes day and night?', 'दिन और रात किस वजह से होते हैं?', [('The Earth spinning', 'पृथ्वी का घूमना'), ('The Sun moving around us', 'सूर्य का हमारा चक्कर लगाना'), ('The Moon', 'चाँद')], 0),
      ('What mainly causes the seasons?', 'ऋतुएँ मुख्य रूप से किस वजह से होती हैं?', [('Distance from the Sun', 'सूर्य से दूरी'), ('The tilt of Earth’s axis', 'पृथ्वी की धुरी का झुकाव'), ('Clouds', 'बादल')], 1),
      ('When is the longest day in India?', 'भारत में सबसे लंबा दिन कब होता है?', [('Around 21 June', '21 जून के आसपास'), ('Around 22 December', '22 दिसंबर के आसपास'), ('Around 1 January', '1 जनवरी के आसपास')], 0)]),
]


def build(h):
    k = Kit(h)
    bt, P, H2 = k.bt, k.P, k.H2
    pages = []
    crumbs = [('Astryl', ''), ('For students', 'learn.html')]
    for i, (slug, icon, (ten, thi), (len_, lhi), secs, remember, quiz) in enumerate(TOPICS):
        body = f'<p style="margin-top:20px"><a href="../learn.html">← {bt("For students", "छात्रों के लिए")}</a></p>'
        body += f'<section class="blk"><h1>{icon} {bt(ten, thi)}</h1><p class="sub">{bt(len_, lhi)}</p></section>'
        inner = ''.join(H2(a, b) + P(c, d) for a, b, c, d in secs)
        inner += '<div class="callout"><b>' + bt('Remember', 'याद रखिए') + '</b><ul>' + ''.join(f'<li>{bt(a, b)}</li>' for a, b in remember) + '</ul></div>'
        q = '<h2>' + bt('Quick quiz', 'छोटी quiz') + '</h2>'
        for qi, (qe, qh, opts, right) in enumerate(quiz):
            q += f'<div class="card mq" data-right="{right}"><b>{qi + 1}. {bt(qe, qh)}</b><div class="opts">' + ''.join(f'<button class="opt" type="button" data-i="{oi}">{bt(oe, oh)}</button>' for oi, (oe, oh) in enumerate(opts)) + '</div><p class="mqfb note"></p></div>'
        body += k.sec(inner + q)
        nxt = TOPICS[(i + 1) % len(TOPICS)]
        body += k.keep_exploring('../', [(f'learn/{nxt[0]}.html', nxt[1], nxt[2][0], nxt[2][1]), ('learn.html', '🎓', 'All student topics', 'सारे विषय'), ('sky-events.html', '🌑', 'Coming eclipses', 'आने वाले ग्रहण'), ('quiz.html', '❓', 'Planet quiz', 'ग्रहों की quiz')])
        path = f'learn/{slug}.html'
        desc = f'{ten}: explained simply for school students (class 6 to 10), in English and Hindi, with a short quiz.'
        h['write'](path, k.shell(ten, thi, 'school', body, desc, depth=1, canonical=path, ld=article_ld(k.site, ten, desc, path, crumbs + [(ten, path)])))
        pages.append(path)
    cards = ''.join(f'<a class="sc" href="learn/{s}.html"><span class="ic">{ic}</span><span><b>{bt(t[0], t[1])}</b><small>{bt(l[0], l[1])}</small></span><span class="go">→</span></a>' for s, ic, t, l, *_ in TOPICS)
    body = f'''<section class="blk"><h1>🎓 {bt("For students", "छात्रों के लिए")}</h1><p class="sub">{bt("The Sun, the Moon, eclipses, planets, stars and seasons, explained simply for classes 6 to 10, in English and Hindi. Each topic ends with a short quiz.", "सूर्य, चाँद, ग्रहण, ग्रह, तारे और ऋतुएँ, कक्षा 6 से 10 के लिए आसान भाषा में, English और हिंदी में। हर विषय के अंत में एक छोटी quiz है।")}</p></section>
<section class="blk"><div class="sc-grid">{cards}</div></section>
<section class="blk prose">{k.note("Teachers are welcome to share these pages with their class. Everything is free, with no sign-up and no ads.", "शिक्षक ये पन्ने अपनी कक्षा के साथ खुलकर बाँट सकते हैं। सब मुफ़्त है, बिना sign-up और बिना विज्ञापन के।")}</section>'''
    desc = 'Astronomy for school students (class 6 to 10) in English and Hindi: the Sun, Earth and Moon, Moon phases, eclipses, the Solar System, stars and seasons, with quizzes.'
    h['write']('learn.html', k.shell('For students', 'छात्रों के लिए', 'school', body, desc, canonical='learn.html', ld=article_ld(k.site, 'For students', desc, 'learn.html', crumbs)))
    return ['learn.html'] + pages
