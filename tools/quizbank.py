"""The question bank for the quiz rounds that earn Space Points.

One bank, two copies:
  site/assets/quiz-bank.js            everything the page needs to show and practise the rounds
  supabase/functions/quiz/bank.json   the answers, for the "quiz" Edge Function that checks ranked rounds
"""
import json
import random

import cons as conslib

# ---------- rounds ----------
ROUNDS = [
    # id, questions per round, icon, English, Hindi, English description, Hindi description
    ('easy', 10, '🪐', 'Planets: easy', 'ग्रह: आसान', 'The basics about the planets', 'ग्रहों की बुनियादी बातें'),
    ('medium', 10, '🌗', 'Planets: medium', 'ग्रह: मध्यम', 'Planets and moons', 'ग्रह और चाँद'),
    ('hard', 10, '🌌', 'Planets: hard', 'ग्रह: कठिन', 'Tricky comparisons', 'मुश्किल तुलनाएँ'),
    ('photo', 10, '📷', 'Which world is this?', 'यह कौन-सी दुनिया है?', 'Real NASA photos', 'NASA की असली तस्वीरें'),
    ('cons', 10, '⭐', 'Name the constellation', 'नक्षत्र पहचानिए', 'Star patterns as they look in the sky', 'तारों के आकार जैसे आसमान में दिखते हैं'),
    ('missions', 10, '🚀', 'Missions and history', 'मिशन और इतिहास', 'Space firsts, India in space and famous missions', 'अंतरिक्ष में पहली बार, भारत और मशहूर मिशन'),
    ('hl', 10, '⚖️', 'Bigger or smaller?', 'बड़ा या छोटा?', 'Pick the one with more', 'जिसमें ज़्यादा है उसे चुनिए'),
    ('est', 5, '🎯', 'Best guess', 'अंदाज़ा लगाइए', 'Slide to your guess; closer means more points', 'Slider से अंदाज़ा लगाइए; जितना पास, उतने ज़्यादा points'),
]

# Missions and history: the first option is the right one (the order is shuffled when shown).
MISSIONS = [
    (('Which was the first artificial satellite (1957)?', 'पहला कृत्रिम उपग्रह (1957) कौन-सा था?'), [('Sputnik 1', 'स्पुतनिक 1'), ('Explorer 1', 'एक्सप्लोरर 1'), ('Vanguard 1', 'वैनगार्ड 1'), ('Aryabhata', 'आर्यभट')], ('The Soviet Union launched Sputnik 1 on 4 October 1957. It beeped radio signals for three weeks.', 'सोवियत संघ ने 4 अक्टूबर 1957 को स्पुतनिक 1 छोड़ा। उसने तीन हफ़्ते तक रेडियो संकेत भेजे।')),
    (('Who was the first human in space?', 'अंतरिक्ष में जाने वाले पहले इंसान कौन थे?'), [('Yuri Gagarin', 'यूरी गागरिन'), ('Neil Armstrong', 'नील आर्मस्ट्रांग'), ('Alan Shepard', 'एलन शेपर्ड'), ('John Glenn', 'जॉन ग्लेन')], ('Yuri Gagarin orbited Earth once on 12 April 1961 in Vostok 1.', 'यूरी गागरिन ने 12 अप्रैल 1961 को वोस्तोक 1 में पृथ्वी का एक चक्कर लगाया।')),
    (('Who first walked on the Moon?', 'चाँद पर सबसे पहले कौन चले?'), [('Neil Armstrong', 'नील आर्मस्ट्रांग'), ('Buzz Aldrin', 'बज़ एल्ड्रिन'), ('Michael Collins', 'माइकल कॉलिन्स'), ('Yuri Gagarin', 'यूरी गागरिन')], ('Neil Armstrong stepped onto the Moon on 20 July 1969 (Apollo 11); Buzz Aldrin followed him.', 'नील आर्मस्ट्रांग ने 20 जुलाई 1969 (Apollo 11) को चाँद पर क़दम रखा; बज़ एल्ड्रिन उनके बाद उतरे।')),
    (('Who was the first woman in space (1963)?', 'अंतरिक्ष में जाने वाली पहली महिला (1963) कौन थीं?'), [('Valentina Tereshkova', 'वेलेंटीना तेरेश्कोवा'), ('Sally Ride', 'सैली राइड'), ('Kalpana Chawla', 'कल्पना चावला'), ('Mae Jemison', 'मे जेमिसन')], ('Valentina Tereshkova flew Vostok 6 for almost three days in June 1963.', 'वेलेंटीना तेरेश्कोवा ने जून 1963 में वोस्तोक 6 में लगभग तीन दिन उड़ान भरी।')),
    (('Who was the first Indian in space (1984)?', 'अंतरिक्ष में जाने वाले पहले भारतीय (1984) कौन थे?'), [('Rakesh Sharma', 'राकेश शर्मा'), ('Kalpana Chawla', 'कल्पना चावला'), ('Sunita Williams', 'सुनीता विलियम्स'), ('Shubhanshu Shukla', 'शुभांशु शुक्ला')], ('Rakesh Sharma flew on Soyuz T-11 in April 1984. Asked how India looked, he said “Saare Jahan Se Achha”.', 'राकेश शर्मा अप्रैल 1984 में सोयूज़ T-11 से गए। भारत कैसा दिखता है पूछने पर उन्होंने कहा “सारे जहाँ से अच्छा”।')),
    (('What was India’s first satellite (1975)?', 'भारत का पहला उपग्रह (1975) कौन-सा था?'), [('Aryabhata', 'आर्यभट'), ('Bhaskara', 'भास्कर'), ('Rohini', 'रोहिणी'), ('INSAT-1A', 'INSAT-1A')], ('Aryabhata, named after the ancient Indian astronomer, was launched on 19 April 1975.', 'प्राचीन भारतीय खगोलशास्त्री के नाम वाला आर्यभट 19 अप्रैल 1975 को छोड़ा गया।')),
    (('In which year did Chandrayaan-3 land near the Moon’s south pole?', 'चंद्रयान-3 किस साल चाँद के दक्षिणी ध्रुव के पास उतरा?'), [('2023', '2023'), ('2019', '2019'), ('2008', '2008'), ('2021', '2021')], ('Chandrayaan-3’s lander Vikram touched down on 23 August 2023, now India’s National Space Day.', 'चंद्रयान-3 का lander विक्रम 23 अगस्त 2023 को उतरा; यह दिन अब भारत का राष्ट्रीय अंतरिक्ष दिवस है।')),
    (('Which country first landed near the Moon’s south pole?', 'चाँद के दक्षिणी ध्रुव के पास सबसे पहले कौन-सा देश उतरा?'), [('India', 'भारत'), ('USA', 'अमेरिका'), ('China', 'चीन'), ('Russia', 'रूस')], ('India did it with Chandrayaan-3 in August 2023.', 'भारत ने अगस्त 2023 में चंद्रयान-3 से यह किया।')),
    (('What was the name of Chandrayaan-3’s rover?', 'चंद्रयान-3 के rover का नाम क्या था?'), [('Pragyan', 'प्रज्ञान'), ('Vikram', 'विक्रम'), ('Sojourner', 'सोजर्नर'), ('Yutu', 'युतु')], ('Vikram was the lander; the six-wheeled rover Pragyan rolled out of it onto the Moon.', 'विक्रम lander था; छह पहियों वाला rover प्रज्ञान उसमें से निकलकर चाँद पर चला।')),
    (('When did India’s Mangalyaan reach Mars?', 'भारत का मंगलयान मंगल तक कब पहुँचा?'), [('2014', '2014'), ('2008', '2008'), ('2019', '2019'), ('2023', '2023')], ('Mangalyaan entered orbit around Mars on 24 September 2014, India’s first try.', 'मंगलयान 24 सितंबर 2014 को मंगल की कक्षा में पहुँचा, भारत की पहली ही कोशिश में।')),
    (('What is India’s first mission to study the Sun (2023)?', 'सूरज को देखने वाला भारत का पहला मिशन (2023) कौन-सा है?'), [('Aditya-L1', 'आदित्य-L1'), ('Chandrayaan-2', 'चंद्रयान-2'), ('AstroSat', 'एस्ट्रोसैट'), ('Gaganyaan', 'गगनयान')], ('Aditya-L1 watches the Sun from a point 1.5 million km from Earth.', 'आदित्य-L1 पृथ्वी से 15 लाख km दूर एक जगह से सूरज को देखता है।')),
    (('Which spacecraft is the farthest from Earth?', 'पृथ्वी से सबसे दूर कौन-सा अंतरिक्ष यान है?'), [('Voyager 1', 'वॉयेजर 1'), ('Voyager 2', 'वॉयेजर 2'), ('New Horizons', 'न्यू होराइज़न्स'), ('Pioneer 10', 'पायनियर 10')], ('Voyager 1, launched in 1977, is in interstellar space, more than 24 billion km away.', '1977 में छोड़ा गया वॉयेजर 1 तारों के बीच के अंतरिक्ष में है, 24 अरब km से भी दूर।')),
    (('Which space telescope launched in 2021 and sees in infrared?', 'कौन-सा अंतरिक्ष telescope 2021 में छोड़ा गया और infrared में देखता है?'), [('James Webb Space Telescope', 'जेम्स वेब स्पेस टेलिस्कोप'), ('Hubble', 'हबल'), ('Kepler', 'केप्लर'), ('Chandra', 'चंद्रा')], ('Webb launched on 25 December 2021; its mirror is 6.5 m wide.', 'वेब 25 दिसंबर 2021 को छोड़ा गया; इसका दर्पण 6.5 m चौड़ा है।')),
    (('In which year was the Hubble Space Telescope launched?', 'हबल अंतरिक्ष telescope किस साल छोड़ा गया?'), [('1990', '1990'), ('1981', '1981'), ('2001', '2001'), ('1975', '1975')], ('Hubble went up on the Space Shuttle Discovery in April 1990.', 'हबल अप्रैल 1990 में Space Shuttle Discovery से ऊपर गया।')),
    (('Which spacecraft flew past Pluto in 2015?', '2015 में प्लूटो के पास से कौन-सा यान गुज़रा?'), [('New Horizons', 'न्यू होराइज़न्स'), ('Voyager 2', 'वॉयेजर 2'), ('Cassini', 'कैसिनी'), ('Juno', 'जूनो')], ('New Horizons showed Pluto’s heart-shaped plain on 14 July 2015.', 'न्यू होराइज़न्स ने 14 जुलाई 2015 को प्लूटो का दिल जैसा मैदान दिखाया।')),
    (('What was the first aircraft to fly on another planet?', 'किसी दूसरे ग्रह पर उड़ने वाला पहला विमान कौन-सा था?'), [('Ingenuity', 'इंजेन्युटी'), ('Dragonfly', 'ड्रैगनफ़्लाई'), ('Perseverance', 'पर्सिवियरेंस'), ('Curiosity', 'क्यूरियोसिटी')], ('The small helicopter Ingenuity first flew on Mars on 19 April 2021 and made 72 flights.', 'छोटे helicopter इंजेन्युटी ने 19 अप्रैल 2021 को मंगल पर पहली उड़ान भरी और 72 उड़ानें कीं।')),
    (('Which mission studied Saturn from 2004 to 2017?', 'किस मिशन ने 2004 से 2017 तक शनि का अध्ययन किया?'), [('Cassini', 'कैसिनी'), ('Galileo', 'गैलीलियो'), ('Juno', 'जूनो'), ('Voyager 1', 'वॉयेजर 1')], ('Cassini ended by diving into Saturn on 15 September 2017.', 'कैसिनी 15 सितंबर 2017 को शनि में गोता लगाकर ख़त्म हुआ।')),
    (('Which spacecraft has been orbiting Jupiter since 2016?', 'कौन-सा यान 2016 से बृहस्पति की परिक्रमा कर रहा है?'), [('Juno', 'जूनो'), ('Galileo', 'गैलीलियो'), ('Cassini', 'कैसिनी'), ('New Horizons', 'न्यू होराइज़न्स')], ('Juno arrived on 4 July 2016 and found Jupiter’s core is fuzzy.', 'जूनो 4 जुलाई 2016 को पहुँचा और पाया कि बृहस्पति का केंद्र धुंधला है।')),
    (('Which was the first spacecraft to land on the far side of the Moon?', 'चाँद के पीछे वाले हिस्से पर सबसे पहले कौन-सा यान उतरा?'), [('Chang’e 4', 'चांग-ए 4'), ('Luna 9', 'लूना 9'), ('Apollo 17', 'अपोलो 17'), ('Chandrayaan-2', 'चंद्रयान-2')], ('China’s Chang’e 4 landed there on 3 January 2019.', 'चीन का चांग-ए 4 वहाँ 3 जनवरी 2019 को उतरा।')),
    (('The first photo of a black hole (2019) showed the one in which galaxy?', 'ब्लैक होल की पहली तस्वीर (2019) किस galaxy वाले ब्लैक होल की थी?'), [('M87', 'M87'), ('Andromeda', 'एंड्रोमेडा'), ('Milky Way', 'आकाशगंगा'), ('Whirlpool', 'व्हर्लपूल')], ('The Event Horizon Telescope pictured M87*, 55 million light-years away; our own Sgr A* followed in 2022.', 'Event Horizon Telescope ने 5.5 करोड़ प्रकाश-वर्ष दूर M87* की तस्वीर ली; हमारे Sgr A* की तस्वीर 2022 में आई।')),
    (('Which observatory first detected gravitational waves (2015)?', 'गुरुत्वीय तरंगें सबसे पहले (2015) किसने पकड़ीं?'), [('LIGO', 'LIGO'), ('Hubble', 'हबल'), ('Kepler', 'केप्लर'), ('Arecibo', 'आरेसिबो')], ('LIGO caught the ripples of two black holes merging 1.3 billion light-years away.', 'LIGO ने 1.3 अरब प्रकाश-वर्ष दूर दो ब्लैक होल के मिलने की लहरें पकड़ीं।')),
    (('Who discovered four moons of Jupiter with a telescope in 1610?', '1610 में telescope से बृहस्पति के चार चाँद किसने खोजे?'), [('Galileo Galilei', 'गैलीलियो गैलिली'), ('Isaac Newton', 'आइज़क न्यूटन'), ('Johannes Kepler', 'योहानेस केप्लर'), ('Tycho Brahe', 'टाइको ब्राहे')], ('Io, Europa, Ganymede and Callisto are still called the Galilean moons.', 'आयो, यूरोपा, गैनिमीड और कैलिस्टो को आज भी गैलीलियन चाँद कहते हैं।')),
    (('Who wrote in 1543 that Earth goes around the Sun?', '1543 में किसने लिखा कि पृथ्वी सूरज के चारों ओर घूमती है?'), [('Nicolaus Copernicus', 'निकोलस कोपरनिकस'), ('Ptolemy', 'टॉलेमी'), ('Tycho Brahe', 'टाइको ब्राहे'), ('Edwin Hubble', 'एडविन हबल')], ('Copernicus’ book came out in the year he died.', 'कोपरनिकस की किताब उसी साल छपी जिस साल उनकी मृत्यु हुई।')),
    (('In which year did Pluto become a dwarf planet?', 'प्लूटो किस साल बौना ग्रह बना?'), [('2006', '2006'), ('1930', '1930'), ('1990', '1990'), ('2015', '2015')], ('The International Astronomical Union decided in August 2006 that Pluto is a dwarf planet.', 'अंतरराष्ट्रीय खगोलीय संघ ने अगस्त 2006 में तय किया कि प्लूटो बौना ग्रह है।')),
    (('Who discovered Uranus in 1781?', '1781 में यूरेनस किसने खोजा?'), [('William Herschel', 'विलियम हर्शेल'), ('Galileo Galilei', 'गैलीलियो गैलिली'), ('Clyde Tombaugh', 'क्लाइड टॉमबॉ'), ('Edmond Halley', 'एडमंड हैली')], ('Herschel first thought it was a comet. It was the first planet found with a telescope.', 'हर्शेल ने पहले इसे धूमकेतु समझा। यह telescope से खोजा गया पहला ग्रह था।')),
    (('Who discovered Pluto in 1930?', '1930 में प्लूटो किसने खोजा?'), [('Clyde Tombaugh', 'क्लाइड टॉमबॉ'), ('William Herschel', 'विलियम हर्शेल'), ('Percival Lowell', 'पर्सिवल लोवेल'), ('Edwin Hubble', 'एडविन हबल')], ('Clyde Tombaugh found it by comparing photos of the sky, at the age of 24.', 'क्लाइड टॉमबॉ ने 24 साल की उम्र में आसमान की तस्वीरों की तुलना करके इसे खोजा।')),
    (('Which animal was the first to orbit Earth (1957)?', 'पृथ्वी की परिक्रमा करने वाला पहला जानवर (1957) कौन था?'), [('Laika the dog', 'कुतिया लाइका'), ('Ham the chimpanzee', 'चिम्पैंज़ी हैम'), ('Félicette the cat', 'बिल्ली फ़ेलिसेट'), ('A fruit fly', 'एक फल मक्खी')], ('Laika flew on Sputnik 2 in November 1957. Fruit flies went up earlier, but not into orbit.', 'लाइका नवंबर 1957 में स्पुतनिक 2 पर गई। फल मक्खियाँ पहले गई थीं, पर कक्षा में नहीं।')),
    (('How many people have walked on the Moon?', 'कितने लोग चाँद पर चले हैं?'), [('12', '12'), ('6', '6'), ('24', '24'), ('2', '2')], ('Twelve astronauts walked on the Moon on six Apollo landings from 1969 to 1972.', '1969 से 1972 तक छह Apollo उतरानों में बारह astronauts चाँद पर चले।')),
    (('Since which year has the International Space Station always had people on board?', 'अंतरराष्ट्रीय अंतरिक्ष स्टेशन पर किस साल से हमेशा लोग रहते हैं?'), [('2000', '2000'), ('1998', '1998'), ('1986', '1986'), ('2011', '2011')], ('The first crew moved in on 2 November 2000; the first part of the station flew in 1998.', 'पहला दल 2 नवंबर 2000 को पहुँचा; स्टेशन का पहला हिस्सा 1998 में गया था।')),
    (('Kalpana Chawla flew to space on which spacecraft?', 'कल्पना चावला किस यान से अंतरिक्ष गईं?'), [('Space Shuttle Columbia', 'स्पेस शटल कोलंबिया'), ('Soyuz', 'सोयूज़'), ('Apollo', 'अपोलो'), ('Space Shuttle Challenger', 'स्पेस शटल चैलेंजर')], ('She flew on Columbia twice, in 1997 and 2003, and lost her life when it broke up on return in 2003.', 'वे दो बार कोलंबिया से गईं, 1997 और 2003 में, और 2003 में लौटते समय उसके टूटने पर उनकी जान चली गई।')),
]

# Best guess: answer, slider range, log scale or not, unit.
ESTIMATES = [
    ('moon', ('How far away is the Moon?', 'चाँद कितना दूर है?'), 384400, 10000, 10000000, True, ('km', 'km'), ('About 384,400 km on average, about 30 Earths side by side.', 'औसतन लगभग 3,84,400 km, लगभग 30 पृथ्वियाँ एक लाइन में।')),
    ('sun', ('How far away is the Sun?', 'सूरज कितना दूर है?'), 149600000, 1000000, 10000000000, True, ('km', 'km'), ('About 150 million km: one astronomical unit.', 'लगभग 15 करोड़ km: एक खगोलीय इकाई।')),
    ('earthd', ('How wide is Earth?', 'पृथ्वी कितनी चौड़ी है?'), 12742, 1000, 1000000, True, ('km', 'km'), ('About 12,742 km across.', 'लगभग 12,742 km चौड़ी।')),
    ('jupd', ('How wide is Jupiter?', 'बृहस्पति कितना चौड़ा है?'), 142984, 1000, 10000000, True, ('km', 'km'), ('About 143,000 km: 11 Earths would fit across it.', 'लगभग 1,43,000 km: इसके पार 11 पृथ्वियाँ आ जाएँगी।')),
    ('sunlight', ('How many minutes does sunlight take to reach Earth?', 'सूरज की रोशनी को पृथ्वी तक आने में कितने मिनट लगते हैं?'), 8.3, 0.1, 1000, True, ('minutes', 'मिनट'), ('About 8 minutes 20 seconds.', 'लगभग 8 मिनट 20 सेकंड।')),
    ('iss', ('How high does the space station fly?', 'अंतरिक्ष स्टेशन कितनी ऊँचाई पर उड़ता है?'), 420, 10, 100000, True, ('km', 'km'), ('About 400 to 420 km up, about as far as Delhi to Jaipur, but straight up.', 'लगभग 400 से 420 km ऊपर, दिल्ली से जयपुर जितना, पर सीधा ऊपर।')),
    ('venust', ('How hot is the surface of Venus?', 'शुक्र की सतह कितनी गर्म है?'), 465, 0, 1000, False, ('°C', '°C'), ('About 465 °C, hot enough to melt lead.', 'लगभग 465 °C, सीसा पिघलाने लायक़ गर्म।')),
    ('marsyear', ('How many Earth days is one year on Mars?', 'मंगल का एक साल पृथ्वी के कितने दिनों का है?'), 687, 10, 100000, True, ('days', 'दिन'), ('687 Earth days, almost two of our years.', 'पृथ्वी के 687 दिन, लगभग हमारे दो साल।')),
    ('proxima', ('How many light-years away is the nearest star after the Sun?', 'सूरज के बाद सबसे पास का तारा कितने प्रकाश-वर्ष दूर है?'), 4.24, 0.1, 1000, True, ('light-years', 'प्रकाश-वर्ष'), ('Proxima Centauri is 4.24 light-years away, about 40 trillion km.', 'प्रॉक्सिमा सेंटॉरी 4.24 प्रकाश-वर्ष दूर है, लगभग 40 लाख करोड़ km।')),
    ('mw', ('How many light-years wide is the Milky Way?', 'आकाशगंगा (Milky Way) कितने प्रकाश-वर्ष चौड़ी है?'), 100000, 100, 1000000000, True, ('light-years', 'प्रकाश-वर्ष'), ('About 100,000 light-years across.', 'लगभग 1,00,000 प्रकाश-वर्ष चौड़ी।')),
    ('andromeda', ('How many light-years away is the Andromeda galaxy?', 'एंड्रोमेडा galaxy कितने प्रकाश-वर्ष दूर है?'), 2500000, 1000, 10000000000, True, ('light-years', 'प्रकाश-वर्ष'), ('About 2.5 million light-years: the light you see left it before humans existed.', 'लगभग 25 लाख प्रकाश-वर्ष: जो रोशनी आप देखते हैं वह इंसानों के होने से पहले चली थी।')),
    ('jupday', ('How many hours is one day on Jupiter?', 'बृहस्पति का एक दिन कितने घंटे का है?'), 9.9, 1, 1000, True, ('hours', 'घंटे'), ('Just under 10 hours: the fastest spin of any planet.', '10 घंटे से थोड़ा कम: किसी भी ग्रह का सबसे तेज़ घूमना।')),
    ('age', ('How many billion years old is the universe?', 'ब्रह्मांड कितने अरब साल पुराना है?'), 13.8, 0.01, 1000, True, ('billion years', 'अरब साल'), ('About 13.8 billion years.', 'लगभग 13.8 अरब साल।')),
    ('light', ('How fast does light travel, in km per second?', 'रोशनी कितनी तेज़ चलती है, km प्रति सेकंड में?'), 299792, 1000, 100000000, True, ('km/s', 'km/s'), ('299,792 km every second: 7.5 times around Earth.', 'हर सेकंड 2,99,792 km: पृथ्वी के 7.5 चक्कर।')),
    ('sunsurf', ('How hot is the surface of the Sun?', 'सूरज की सतह कितनी गर्म है?'), 5500, 100, 100000000, True, ('°C', '°C'), ('About 5,500 °C. Its core is about 15 million °C.', 'लगभग 5,500 °C। इसका केंद्र लगभग 1.5 करोड़ °C है।')),
]

# Bigger or smaller: property, question, value unit
HL_PROPS = [
    ('diam', ('Which is bigger?', 'कौन बड़ा है?'), 'km'),
    ('g', ('Which has stronger gravity?', 'किसका गुरुत्व ज़्यादा है?'), 'm/s²'),
    ('temp', ('Which is hotter on average?', 'औसतन कौन ज़्यादा गर्म है?'), '°C'),
    ('day', ('Which has the longer day?', 'किसका दिन लंबा है?'), 'h'),
    ('year', ('Which takes longer to go around the Sun?', 'सूरज का चक्कर लगाने में किसे ज़्यादा समय लगता है?'), 'days'),
    ('moons', ('Which has more moons?', 'किसके ज़्यादा चाँद हैं?'), ''),
    ('dist', ('Which is farther from the Sun?', 'सूरज से कौन ज़्यादा दूर है?'), 'million km'),
]

CONS_IDS = ['Ori', 'UMa', 'UMi', 'Cas', 'Cyg', 'Lyr', 'Aql', 'Sco', 'Cru', 'Cen', 'CMa', 'CMi', 'Peg', 'And', 'Per', 'Aur', 'Boo', 'Her', 'Dra', 'Cep',
            'Leo', 'Tau', 'Gem', 'Vir', 'Sgr', 'Cnc', 'Ari', 'Psc', 'Aqr', 'Cap', 'Lib', 'Lep', 'Crv', 'Del', 'Car', 'Oph']


def build(out_dir, root, bodies, name_of, cons_raw, photos):
    """Writes both copies of the bank. name_of(lang, id) gives a body's name."""
    rng = random.Random(42)
    planet_bank = json.loads((root / 'supabase/functions/account/quiz_bank.json').read_text(encoding='utf-8'))
    level_of = {}
    keys = list(planet_bank)
    for k in keys[:11]:
        level_of[k] = 'easy'
    for k in keys[11:23]:
        level_of[k] = 'medium'
    for k in keys[23:]:
        level_of[k] = 'hard'
    client, server = {}, {}
    for rid, n, icon, en, hi, den, dhi in ROUNDS:
        client[rid] = {'n': n, 'icon': icon, 'name': [en, hi], 'desc': [den, dhi], 'items': []}
        server[rid] = {'n': n, 'items': {}}

    def add(rid, cl, sv):
        client[rid]['items'].append(cl)
        server[rid]['items'][cl['id']] = sv

    for k, v in planet_bank.items():
        qid = 'p:' + k
        add(level_of[k], {'id': qid, 'qk': 'q' + k[0].upper() + k[1:], 'a': v['a'], 'pool': v['pool']}, {'a': v['a'], 'pool': v['pool']})
    ids = [b['id'] for b in bodies if b['id'] in photos]
    for b in ids:
        add('photo', {'id': 'ph:' + b, 'img': f'img/planets/{b}.webp', 'a': b, 'pool': '*'}, {'a': b, 'pool': '*'})  # '*': the other answers of the round
    stars, _ = conslib.load()
    cons = {c['id']: c for c in conslib.merge_serpens(cons_raw)}
    names = {}
    for cid in CONS_IDS:
        c = cons[cid]
        names[cid] = [c['names'].get('en', c['latin']), c['names'].get('hi', c['latin'])]
    for cid in CONS_IDS:
        pool = '*'
        add('cons', {'id': 'cn:' + cid, 'svg': conslib.svg(cons[cid], stars).replace(f'aria-label="{cons[cid]["latin"]}"', 'aria-label="?"'), 'a': cid, 'pool': pool}, {'a': cid, 'pool': pool})
    client['cons']['names'] = names
    for i, (q, opts, ex) in enumerate(MISSIONS):
        add('missions', {'id': f'ms:{i}', 'q': list(q), 'o': [list(o) for o in opts], 'ex': list(ex)}, {'a': '0', 'o': ['0', '1', '2', '3']})
    by = {b['id']: b for b in bodies}
    hl_bodies = [b['id'] for b in bodies if b['kind'] in ('planet', 'dwarf')]
    moon_bodies = [b['id'] for b in bodies if b['kind'] == 'moon']
    pairs = []
    for prop, q, unit in HL_PROPS:
        group = hl_bodies if prop in ('temp', 'day', 'year', 'moons', 'dist') else hl_bodies + moon_bodies
        if prop == 'day':
            group = [x for x in group if x != 'venus']  # Venus spins backwards; its "day" is a special case
        for i, a in enumerate(group):
            for b2 in group[i + 1:]:
                va, vb = by[a][prop], by[b2][prop]
                if va is None or vb is None or va == vb or abs(va - vb) < 0.08 * max(abs(va), abs(vb)):
                    continue
                pairs.append((prop, q, unit, a, b2))
    rng.shuffle(pairs)
    for prop, q, unit, a, b2 in pairs[:160]:
        win = a if by[a][prop] > by[b2][prop] else b2

        def val(x):
            v = by[x][prop]
            return f'{v:,.0f}' if abs(v) >= 100 else (f'{v:.1f}' if isinstance(v, float) else str(v))
        ex_en = f'{name_of("en", a)}: {val(a)} {unit} · {name_of("en", b2)}: {val(b2)} {unit}'.replace('  ', ' ')
        ex_hi = f'{name_of("hi", a)}: {val(a)} {unit} · {name_of("hi", b2)}: {val(b2)} {unit}'.replace('  ', ' ')
        add('hl', {'id': f'hl:{prop}:{a}:{b2}', 'q': list(q), 'o': [a, b2], 'a': win, 'ex': [ex_en, ex_hi]}, {'a': win, 'o': [a, b2]})
    for eid, q, ans, lo, hi_, log, unit, ex in ESTIMATES:
        add('est', {'id': 'es:' + eid, 'q': list(q), 'a': ans, 'min': lo, 'max': hi_, 'log': log, 'unit': list(unit), 'ex': list(ex)}, {'a': ans, 'min': lo, 'max': hi_, 'log': log})
    (out_dir / 'assets' / 'quiz-bank.js').write_text('/* Made by tools/quizbank.py. */\nwindow.ASTRYL_QB=' + json.dumps(client, ensure_ascii=False, separators=(',', ':')) + ';\n', encoding='utf-8')
    target = root / 'supabase' / 'functions' / 'quiz' / 'bank.json'
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(json.dumps(server, ensure_ascii=False, separators=(',', ':'), sort_keys=True) + '\n', encoding='utf-8')
    return {k: len(v['items']) for k, v in client.items()}
