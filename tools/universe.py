"""Scale of the universe, the cosmic timeline and the glossary of astryl.space (English and Hindi)."""
import json
from datetime import datetime, timedelta

from dskit import Kit

LY = 9.4607e15
AU = 1.495978707e11
UNIVERSE_AGE = 13.8e9   # years

SUP = {'-': '⁻', '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴', '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹'}


def sci(x, d=1):
    import math
    e = math.floor(math.log10(abs(x)))
    m = x / 10 ** e
    if round(m, d) >= 10:
        m /= 10
        e += 1
    return f'{m:.{d}f} × 10' + ''.join(SUP[c] for c in str(e))


# (english, hindi, size in metres, blurb en, blurb hi)
SCALE = [
    ('A proton', 'प्रोटॉन', 1.7e-15, 'The nucleus of a hydrogen atom. About a hundred thousand times smaller than the atom itself.', 'हाइड्रोजन परमाणु का नाभिक। परमाणु से लगभग एक लाख गुना छोटा।'),
    ('An atom', 'परमाणु', 1e-10, 'Mostly empty space around a tiny nucleus. A hydrogen atom is about 0.1 nanometres wide.', 'छोटे नाभिक के चारों ओर ज़्यादातर ख़ाली जगह। हाइड्रोजन परमाणु लगभग 0.1 नैनोमीटर चौड़ा है।'),
    ('A red blood cell', 'लाल रक्त कोशिका', 7.5e-6, 'About 7.5 micrometres across. A drop of blood holds millions of them.', 'लगभग 7.5 माइक्रोमीटर चौड़ी। ख़ून की एक बूँद में लाखों होती हैं।'),
    ('A human hair', 'बाल की मोटाई', 7e-5, 'Around 0.07 mm thick, about as small as you can see with the naked eye.', 'लगभग 0.07 mm मोटाई, नंगी आँख से दिखने की सीमा के आसपास।'),
    ('A person', 'एक इंसान', 1.7, 'The middle of the scale. Everything here is measured against you.', 'पैमाने का बीच। यहाँ हर चीज़ आपसे तुलना में नापी गई है।'),
    ('Mount Everest', 'Mount Everest', 8849, 'The highest point on Earth above sea level, 8,849 m.', 'समुद्र तल से पृथ्वी का सबसे ऊँचा बिंदु, 8,849 m।'),
    ('Earth', 'पृथ्वी', 1.2742e7, 'Our planet, about 12,742 km wide. Earth could hold a million Earth-sized… no: about 1.3 million Earths fit inside the Sun.', 'हमारा ग्रह, लगभग 12,742 km चौड़ा। सूर्य के अंदर लगभग 13 लाख पृथ्वियाँ समा सकती हैं।'),
    ('Earth to the Moon', 'पृथ्वी से चाँद', 3.844e8, 'The Moon is about 384,400 km away. Light needs about 1.3 seconds to get there.', 'चाँद लगभग 3,84,400 km दूर है। रोशनी को वहाँ पहुँचने में लगभग 1.3 सेकंड लगते हैं।'),
    ('The Sun', 'सूरज', 1.3927e9, 'A star 1.39 million km wide, about 109 times the width of Earth.', '13.9 लाख km चौड़ा तारा, पृथ्वी की चौड़ाई का लगभग 109 गुना।'),
    ('Sagittarius A* (horizon)', 'Sagittarius A* (horizon)', 2.54e10, 'The event horizon of our Galaxy’s black hole, about 25 million km across. It would fit inside Mercury’s orbit.', 'हमारी आकाशगंगा के ब्लैक होल का event horizon, लगभग 2.5 करोड़ km चौड़ा। यह बुध की कक्षा के अंदर समा जाएगा।'),
    ('Earth’s orbit', 'पृथ्वी की कक्षा', 2 * AU, 'The path Earth takes round the Sun is 2 AU wide, about 300 million km.', 'पृथ्वी का सूर्य के चारों ओर का रास्ता 2 AU चौड़ा है, लगभग 30 करोड़ km।'),
    ('The Solar System', 'सौरमंडल', 2 * 30.07 * AU, 'Out to the orbit of Neptune, about 9 billion km across. The Sun’s influence reaches much farther.', 'वरुण (Neptune) की कक्षा तक, लगभग 9 अरब km चौड़ा। सूर्य का असर इससे कहीं आगे तक है।'),
    ('Nearest star (distance)', 'सबसे पास का तारा (दूरी)', 4.24 * LY, 'Proxima Centauri is 4.24 light-years away. Voyager 1 would need about 75,000 years.', 'Proxima Centauri 4.24 प्रकाश-वर्ष दूर है। Voyager 1 को लगभग 75,000 साल लगेंगे।'),
    ('The Milky Way', 'आकाशगंगा', 1e5 * LY, 'Our Galaxy’s disk, about 100,000 light-years across, with a few hundred billion stars.', 'हमारी आकाशगंगा की disk, लगभग 1,00,000 प्रकाश-वर्ष चौड़ी, कुछ सौ अरब तारों के साथ।'),
    ('Andromeda (distance)', 'Andromeda (दूरी)', 2.5e6 * LY, 'The nearest large galaxy is 2.5 million light-years away.', 'सबसे पास की बड़ी galaxy 25 लाख प्रकाश-वर्ष दूर है।'),
    ('The Local Group', 'Local Group', 1e7 * LY, 'Our group of more than 80 galaxies, about 10 million light-years across.', '80 से ज़्यादा galaxies का हमारा समूह, लगभग 1 करोड़ प्रकाश-वर्ष चौड़ा।'),
    ('Laniakea Supercluster', 'Laniakea Supercluster', 5e8 * LY, 'Our home supercluster: about 100,000 galaxies in a region 500 million light-years across.', 'हमारा supercluster: 50 करोड़ प्रकाश-वर्ष के क्षेत्र में लगभग 1,00,000 galaxies।'),
    ('The observable universe', 'दिखने योग्य ब्रह्मांड', 9.3e10 * LY, 'Everything whose light has had time to reach us: about 93 billion light-years across.', 'वह सब कुछ जिसकी रोशनी को हम तक पहुँचने का समय मिला है: लगभग 93 अरब प्रकाश-वर्ष चौड़ा।'),
]
SCALE[6] = ('Earth', 'पृथ्वी', 1.2742e7, 'Our planet, about 12,742 km wide. About 1.3 million Earths would fit inside the Sun.', 'हमारा ग्रह, लगभग 12,742 km चौड़ा। सूर्य के अंदर लगभग 13 लाख पृथ्वियाँ समा सकती हैं।')

MONTHS_HI = ['जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर']
MONTHS_EN = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']


def calendar_stamp(years_after_bang):
    """When an event falls if the 13.8 billion years were one year (1 January = Big Bang)."""
    secs = years_after_bang / UNIVERSE_AGE * 365 * 86400
    t = datetime(2001, 1, 1) + timedelta(seconds=secs)
    if secs >= 364 * 86400:
        return MONTHS_EN[t.month - 1] + f' {t.day}, {t.strftime("%H:%M:%S")}', f'{t.day} {MONTHS_HI[t.month - 1]}, {t.strftime("%H:%M:%S")}'
    return MONTHS_EN[t.month - 1] + f' {t.day}', f'{t.day} {MONTHS_HI[t.month - 1]}'


# (years after the Big Bang, title en/hi, text en/hi)
EVENTS = [
    (0, 'The Big Bang', 'Big Bang', 'Space, time and all the matter and energy we know begin as an extremely hot, dense state and start to expand.', 'अंतरिक्ष, समय और हमारी जानी हुई सारी पदार्थ और ऊर्जा एक अत्यंत गर्म और घने रूप में शुरू होकर फैलना शुरू करते हैं।'),
    (380000, 'First atoms, first light', 'पहले परमाणु, पहली रोशनी', 'The universe cools enough for atoms to form and light travels free. That light is still around as the cosmic microwave background.', 'ब्रह्मांड इतना ठंडा होता है कि परमाणु बनें और रोशनी आज़ादी से चले। वही रोशनी आज cosmic microwave background के रूप में मौजूद है।'),
    (2e8, 'The first stars', 'पहले तारे', 'Gas collapses into the first giant stars, which light up the dark universe.', 'गैस ढहकर पहले दानव तारे बनाती है, जो अँधेरे ब्रह्मांड को रोशन करते हैं।'),
    (3e8, 'The first galaxies', 'पहली galaxies', 'The James Webb Space Telescope sees galaxies from this time.', 'James Webb Space Telescope इस समय की galaxies देखता है।'),
    (9.23e9, 'The Sun and planets form', 'सूरज और ग्रह बनते हैं', 'A cloud of gas collapses 4.57 billion years ago and makes the Sun and the planets, including Earth.', '4.57 अरब साल पहले गैस का बादल ढहकर सूरज और पृथ्वी समेत ग्रह बनाता है।'),
    (10.3e9, 'The first life', 'पहला जीवन', 'The earliest known traces of life on Earth, simple microbes, are about 3.5 billion years old.', 'पृथ्वी पर जीवन के सबसे पुराने ज्ञात निशान, साधारण सूक्ष्मजीव, लगभग 3.5 अरब साल पुराने हैं।'),
    (11.4e9, 'Oxygen fills the air', 'हवा में oxygen', 'Photosynthesis raises oxygen in the atmosphere about 2.4 billion years ago.', 'लगभग 2.4 अरब साल पहले photosynthesis वायुमंडल में oxygen बढ़ाता है।'),
    (13.26e9, 'Animals multiply', 'जानवर तेज़ी से बढ़ते हैं', 'About 540 million years ago most major animal groups appear in the Cambrian explosion.', 'लगभग 54 करोड़ साल पहले Cambrian explosion में ज़्यादातर बड़े जंतु समूह दिखते हैं।'),
    (13.734e9, 'The dinosaurs end', 'डायनासोर का अंत', 'An asteroid hits Earth 66 million years ago and most dinosaurs die out.', '66 मिलियन साल पहले एक क्षुद्रग्रह पृथ्वी से टकराता है और ज़्यादातर डायनासोर ख़त्म हो जाते हैं।'),
    (13.8e9 - 3e5, 'Homo sapiens', 'Homo sapiens', 'Modern humans appear about 300,000 years ago.', 'आधुनिक मानव लगभग 3,00,000 साल पहले दिखते हैं।'),
    (13.8e9 - 5000, 'Writing', 'लेखन', 'The first writing, about 5,000 years ago. All of recorded history is in the last seconds.', 'पहला लेखन, लगभग 5,000 साल पहले। पूरा लिखित इतिहास आख़िरी कुछ सेकंडों में है।'),
]

FUTURE = [
    ('About 1 billion years from now', 'लगभग 1 अरब साल बाद', 'The Sun will be bright enough to boil away Earth’s oceans. Estimates range from 0.9 to 1.5 billion years.', 'सूर्य इतना चमकीला हो जाएगा कि पृथ्वी के महासागर भाप बन जाएँगे। अनुमान 0.9 से 1.5 अरब साल के बीच हैं।'),
    ('About 5 billion years', 'लगभग 5 अरब साल', 'The Sun runs out of hydrogen in its core, swells into a red giant, then shrinks to a white dwarf.', 'सूर्य के केंद्र की हाइड्रोजन ख़त्म होती है, वह फूलकर red giant बनता है और फिर सिकुड़कर white dwarf।'),
    ('4 to 5 billion years, or later', '4 से 5 अरब साल, या उसके बाद', 'The Milky Way may merge with Andromeda, though the latest studies say it is not certain.', 'आकाशगंगा Andromeda से मिल सकती है, हालाँकि नए अध्ययन कहते हैं कि यह पक्का नहीं।'),
    ('About 10¹⁴ years', 'लगभग 10¹⁴ साल', 'The last stars burn out. After that, only dark remnants remain.', 'आख़िरी तारे बुझ जाते हैं। उसके बाद सिर्फ़ अँधेरे अवशेष बचते हैं।'),
    ('About 10¹⁰⁰ years', 'लगभग 10¹⁰⁰ साल', 'Even the largest black holes would have evaporated through Hawking radiation, if the theory is right.', 'अगर सिद्धांत सही है तो सबसे बड़े ब्लैक होल भी Hawking radiation से भाप बनकर ख़त्म हो चुके होंगे।'),
]

# (term, hindi term, definition en, definition hi)
GLOSSARY = [
    ('Accretion disk', 'Accretion disk', 'A flat whirl of hot gas that circles a black hole or a star before falling in.', 'गर्म गैस का चपटा भँवर जो गिरने से पहले ब्लैक होल या तारे का चक्कर लगाता है।'),
    ('Astronomical unit (AU)', 'खगोलीय इकाई (AU)', 'The average distance from Earth to the Sun, about 150 million km.', 'पृथ्वी से सूर्य की औसत दूरी, लगभग 15 करोड़ km।'),
    ('Big Bang', 'Big Bang', 'The hot, dense beginning of the observable universe about 13.8 billion years ago, from which space has been expanding.', 'लगभग 13.8 अरब साल पहले दिखने योग्य ब्रह्मांड की गर्म, घनी शुरुआत, जिसके बाद से अंतरिक्ष फैल रहा है।'),
    ('Binary star', 'युग्म तारा', 'Two stars that orbit each other.', 'दो तारे जो एक-दूसरे की परिक्रमा करते हैं।'),
    ('Black hole', 'ब्लैक होल', 'A region where gravity is so strong that nothing, not even light, can escape from inside its event horizon.', 'ऐसा क्षेत्र जहाँ gravity इतनी तेज़ है कि उसके event horizon के अंदर से कुछ भी, रोशनी भी, नहीं निकल सकता।'),
    ('Cosmic microwave background', 'Cosmic microwave background', 'The faint glow left from when the universe was 380,000 years old. It fills the whole sky.', 'तब की धीमी चमक जब ब्रह्मांड 3,80,000 साल का था। यह पूरे आसमान में फैली है।'),
    ('Cosmic web', 'Cosmic web', 'The largest structure of the universe: galaxies arranged in filaments around huge empty voids.', 'ब्रह्मांड की सबसे बड़ी संरचना: विशाल ख़ाली voids के चारों ओर धागों में सजी galaxies।'),
    ('Dark energy', 'Dark energy', 'The unknown cause that makes the expansion of the universe speed up. It makes up about 68% of the universe’s total energy.', 'वह अज्ञात कारण जिससे ब्रह्मांड का फैलाव तेज़ हो रहा है। यह ब्रह्मांड की कुल ऊर्जा का लगभग 68% है।'),
    ('Dark matter', 'Dark matter', 'Invisible matter that we detect only through its gravity. It makes up about 27% of the universe.', 'अदृश्य द्रव्य जिसे हम सिर्फ़ उसकी gravity से पहचानते हैं। यह ब्रह्मांड का लगभग 27% है।'),
    ('Dwarf galaxy', 'बौनी galaxy', 'A small galaxy with up to a few billion stars. The most common kind.', 'कुछ अरब तारों तक की छोटी galaxy। सबसे आम प्रकार।'),
    ('Event horizon', 'Event horizon (घटना क्षितिज)', 'The boundary around a black hole. Nothing that crosses it can return.', 'ब्लैक होल के चारों ओर की सीमा। इसे पार करने वाली कोई चीज़ लौट नहीं सकती।'),
    ('Exoplanet', 'बाह्यग्रह (Exoplanet)', 'A planet that orbits a star other than the Sun.', 'वह ग्रह जो सूर्य के अलावा किसी और तारे की परिक्रमा करता है।'),
    ('Galaxy', 'Galaxy (मंदाकिनी)', 'A huge system of stars, gas, dust and dark matter held together by gravity.', 'तारों, गैस, धूल और dark matter की विशाल व्यवस्था जो gravity से बँधी है।'),
    ('Gravitational lensing', 'Gravitational lensing', 'The bending of light by gravity, which can magnify or distort objects behind a massive body.', 'Gravity से रोशनी का मुड़ना, जिससे भारी चीज़ के पीछे की वस्तुएँ बड़ी या टेढ़ी दिख सकती हैं।'),
    ('Gravitational waves', 'गुरुत्वीय तरंगें', 'Ripples in space itself, made for example when two black holes merge. First detected in 2015.', 'अंतरिक्ष में ही उठी लहरें, जैसे दो ब्लैक होल के मिलने पर। पहली बार 2015 में पकड़ी गईं।'),
    ('Hawking radiation', 'Hawking radiation', 'A faint glow that quantum effects should make a black hole give off. Predicted in 1974 but never observed.', 'हल्की चमक जो quantum प्रभावों से ब्लैक होल को छोड़नी चाहिए। 1974 में भविष्यवाणी हुई, कभी देखी नहीं गई।'),
    ('Hubble constant', 'Hubble constant', 'How fast the universe expands: about 70 km per second for every megaparsec of distance. The exact value is still debated.', 'ब्रह्मांड कितनी तेज़ फैल रहा है: हर मेगापारसेक दूरी पर लगभग 70 km प्रति सेकंड। सटीक मान पर अब भी बहस है।'),
    ('Infrared', 'अवरक्त (Infrared)', 'Light with a longer wavelength than red that our eyes cannot see. It can pass through dust.', 'लाल से लंबी तरंग-दैर्ध्य की रोशनी जो हमारी आँखें नहीं देख सकतीं। यह धूल के आर-पार जा सकती है।'),
    ('Intermediate-mass black hole', 'मध्यम ब्लैक होल', 'A black hole between about 100 and 100,000 Suns. Few have been found.', 'लगभग 100 से 1,00,000 सूरज के बीच का ब्लैक होल। बहुत कम मिले हैं।'),
    ('Jet', 'Jet', 'A narrow beam of gas shot out at nearly the speed of light along the spin axis of a black hole or young star.', 'ब्लैक होल या नए तारे की घूर्णन अक्ष के साथ लगभग प्रकाश की गति से फेंकी गई गैस की पतली धारा।'),
    ('Light-year', 'प्रकाश-वर्ष', 'The distance light travels in one year, about 9.46 trillion km.', 'प्रकाश एक साल में जितनी दूरी तय करता है, लगभग 9.46 खरब km।'),
    ('Local Group', 'Local Group', 'The group of more than 80 galaxies that includes the Milky Way and Andromeda.', '80 से ज़्यादा galaxies का समूह जिसमें आकाशगंगा और Andromeda हैं।'),
    ('Nebula', 'नीहारिका (Nebula)', 'A cloud of gas and dust in space, where stars may be born or where a dying star has thrown off its layers.', 'अंतरिक्ष में गैस और धूल का बादल, जहाँ तारे जन्म ले सकते हैं या जहाँ कोई मरता तारा अपनी परतें फेंक चुका है।'),
    ('Neutron star', 'न्यूट्रॉन तारा', 'The crushed core of a massive star, about 20 km wide yet heavier than the Sun.', 'भारी तारे का कुचला हुआ केंद्र, लगभग 20 km चौड़ा पर सूरज से भारी।'),
    ('Observable universe', 'दिखने योग्य ब्रह्मांड', 'The part of the universe whose light has had time to reach us, about 93 billion light-years across.', 'ब्रह्मांड का वह हिस्सा जिसकी रोशनी को हम तक पहुँचने का समय मिला, लगभग 93 अरब प्रकाश-वर्ष चौड़ा।'),
    ('Parsec', 'पारसेक (Parsec)', 'A unit of distance used by astronomers: about 3.26 light-years.', 'खगोलविदों की दूरी की इकाई: लगभग 3.26 प्रकाश-वर्ष।'),
    ('Photon sphere', 'Photon sphere', 'The distance, 1.5 times the horizon radius for a non-spinning black hole, where light can orbit in a circle.', 'वह दूरी, बिना घूमने वाले ब्लैक होल के लिए horizon त्रिज्या का 1.5 गुना, जहाँ रोशनी गोल चक्कर लगा सकती है।'),
    ('Pulsar', 'Pulsar', 'A spinning neutron star that sends out beams of radio waves, seen as regular pulses.', 'घूमता न्यूट्रॉन तारा जो radio तरंगों की धाराएँ छोड़ता है, जो नियमित स्पंदनों जैसी दिखती हैं।'),
    ('Quasar', 'Quasar', 'The extremely bright core of a distant galaxy, powered by gas falling into a supermassive black hole.', 'किसी दूर की galaxy का अत्यंत चमकीला केंद्र, जिसे विशाल ब्लैक होल में गिरती गैस ऊर्जा देती है।'),
    ('Redshift', 'Redshift (लाल विस्थापन)', 'The stretching of light to longer, redder wavelengths, caused by motion away from us, the expansion of space or strong gravity.', 'रोशनी का लंबी, ज़्यादा लाल तरंग-दैर्ध्य की ओर खिंचना, जो हमसे दूर जाने, अंतरिक्ष के फैलाव या तेज़ gravity से होता है।'),
    ('Schwarzschild radius', 'Schwarzschild radius', 'The size of the event horizon of a non-spinning black hole: r = 2GM/c², about 3 km per Sun of mass.', 'बिना घूमने वाले ब्लैक होल के event horizon का आकार: r = 2GM/c², हर सूरज के द्रव्यमान पर लगभग 3 km।'),
    ('Singularity', 'Singularity', 'The centre of a black hole, where our theories say density becomes infinite. It is where they stop working.', 'ब्लैक होल का केंद्र, जहाँ हमारे सिद्धांतों के अनुसार घनत्व अनंत हो जाता है। वहीं वे काम करना बंद कर देते हैं।'),
    ('Solar mass', 'सूर्य द्रव्यमान (Solar mass)', 'The mass of the Sun, about 2 × 10³⁰ kg. Black holes and stars are measured in solar masses.', 'सूरज का द्रव्यमान, लगभग 2 × 10³⁰ kg। ब्लैक होल और तारे इसी में नापे जाते हैं।'),
    ('Spaghettification', 'Spaghettification', 'The stretching of an object into a long thin shape by the difference in gravity across it near a black hole.', 'ब्लैक होल के पास किसी चीज़ पर अलग-अलग जगह gravity के फ़र्क़ से उसका लंबे पतले आकार में खिंच जाना।'),
    ('Spiral galaxy', 'Spiral galaxy', 'A galaxy with a flat disk and curving arms. The Milky Way is one.', 'चपटी disk और घुमावदार भुजाओं वाली galaxy। आकाशगंगा एक है।'),
    ('Supermassive black hole', 'विशाल ब्लैक होल', 'A black hole of millions to billions of Suns, found in the centre of most large galaxies.', 'लाखों से अरबों सूरज का ब्लैक होल, जो ज़्यादातर बड़ी galaxies के केंद्र में मिलता है।'),
    ('Supernova', 'Supernova', 'The explosion of a massive star at the end of its life, or of a white dwarf that has taken in too much matter.', 'भारी तारे का जीवन के अंत में, या बहुत द्रव्य खींच चुके white dwarf का, विस्फोट।'),
    ('Void', 'Void (शून्य क्षेत्र)', 'A huge region of space with very few galaxies, tens to hundreds of millions of light-years across.', 'अंतरिक्ष का विशाल क्षेत्र जिसमें बहुत कम galaxies हैं, दसों से सैकड़ों मिलियन प्रकाश-वर्ष चौड़ा।'),
    ('White dwarf', 'White dwarf', 'The glowing core left by a Sun-like star after it ends its life. About the size of Earth.', 'सूर्य जैसे तारे के जीवन के अंत के बाद बचा चमकता केंद्र। लगभग पृथ्वी जितना बड़ा।'),
    ('Wormhole', 'Wormhole', 'A hypothetical tunnel through space and time that appears in the equations of relativity. None has ever been found.', 'अंतरिक्ष और समय में एक काल्पनिक सुरंग जो relativity के समीकरणों में आती है। आज तक कोई मिली नहीं।'),
]


def build(h):
    k = Kit(h)
    bt, P, H2, callout, sec, table, note = k.bt, k.P, k.H2, k.callout, k.sec, k.table, k.note
    asset_v = h['asset_v']
    out = []

    # ---------- scale of the universe
    data = [dict(en=a, hi=b, m=m, be=c, bh=d, x=(i == len(SCALE) - 1)) for i, (a, b, m, c, d) in enumerate(SCALE)]
    rows = ''.join(f'<tr data-i="{i}" style="cursor:pointer"><td>{bt(a, b)}</td><td class="w">{sci(m)} m</td></tr>' for i, (a, b, m, c, d) in enumerate(SCALE))
    body = f'''<section class="blk"><h1>{bt("Scale of the universe", "ब्रह्मांड का पैमाना")}</h1><p class="sub">{bt("From a proton to everything we can see, in {n} steps. Each step is a size or a distance. Use the arrows or the slider.".replace("{n}", str(len(SCALE))), "प्रोटॉन से लेकर वह सब कुछ जो हम देख सकते हैं, {n} पड़ावों में। हर पड़ाव एक आकार या दूरी है। तीरों या slider का इस्तेमाल कीजिए।".replace("{n}", str(len(SCALE))))}</p></section>
<section class="blk"><div class="card scalebox">
<div class="scrow"><button class="btn" type="button" id="scPrev" aria-label="Smaller">← {bt("Smaller", "छोटा")}</button><span id="scIdx" class="note"></span><button class="btn" type="button" id="scNext" aria-label="Bigger">{bt("Bigger", "बड़ा")} →</button></div>
<h2 id="scName" style="margin:.4em 0 0"></h2><div class="scsize" id="scSize"></div><p id="scBlurb"></p>
<div class="stats" id="scStats"></div>
<div class="scbar"><i id="scDot"></i></div><div class="scends"><span>{bt("a proton", "प्रोटॉन")}</span><span>{bt("the observable universe", "दिखने योग्य ब्रह्मांड")}</span></div>
<input type="range" id="scBar" min="0" max="{len(SCALE) - 1}" step="1" value="4" style="width:100%" aria-label="Scale">
</div></section>
<section class="blk"><h2>{bt("All steps", "सारे पड़ाव")}</h2><div class="card"><table class="cmp cols" id="scList"><tr><th>{bt("Object", "चीज़")}</th><th>{bt("Size or distance", "आकार या दूरी")}</th></tr>{rows}</table></div>{note("Tap a row to jump to it. Sizes are rounded; the Solar System step means Neptune’s orbit.", "किसी पंक्ति पर दबाकर वहाँ जाइए। आकार गोल किए गए हैं; सौरमंडल का पड़ाव वरुण की कक्षा तक है।")}</section>
<section class="blk callout">{bt("Going from the Sun to the whole observable universe is a jump of about 600 quadrillion times (6 × 10¹⁷). Light, the fastest thing there is, needs 4.6 seconds to cross the Sun.", "सूरज से पूरे दिखने योग्य ब्रह्मांड तक की छलाँग लगभग 6 × 10¹⁷ गुना है। प्रकाश, जो सबसे तेज़ है, को सूरज पार करने में 4.6 सेकंड लगते हैं।")} <a href="galaxies.html">{bt("Galaxies", "Galaxies")} →</a></section>
<script type="application/json" id="scaleData">{json.dumps(data, ensure_ascii=False)}</script>'''
    out.append(('cosmic-scale.html', h['shell']('Scale of the universe', 'ब्रह्मांड का पैमाना', 'scale', body,
                'An interactive scale of the universe, from a proton to the observable universe in 18 steps, with how long light takes to cross each.',
                canonical='cosmic-scale.html', extra_head=f'<script defer src="assets/scale.js?v={asset_v()}"></script>')))

    # ---------- timeline
    items = ''
    for t, en, hi, de, dh in EVENTS:
        cal_en, cal_hi = calendar_stamp(t)
        if t < 1e6:
            ago_en = f'{t:,.0f} years after the Big Bang'
            ago_hi = f'Big Bang के {t:,.0f} साल बाद' if t else ''
            ago_en = 'The start' if t == 0 else ago_en
            ago_hi = 'शुरुआत' if t == 0 else ago_hi
        else:
            ago = UNIVERSE_AGE - t
            if ago >= 1e9:
                ago_en, ago_hi = f'{ago / 1e9:.2f} billion years ago', f'{ago / 1e9:.2f} अरब साल पहले'
            elif ago >= 1e6:
                ago_en, ago_hi = f'{ago / 1e6:,.0f} million years ago', f'{ago / 1e6:,.0f} मिलियन साल पहले'
            else:
                ago_en, ago_hi = f'{ago:,.0f} years ago', f'{ago:,.0f} साल पहले'
            if t < 1e9:
                ago_en, ago_hi = f'{t / 1e6:,.0f} million years after the Big Bang', f'Big Bang के {t / 1e6:,.0f} मिलियन साल बाद'
        items += f'<div class="m"><div class="y">{bt(cal_en, cal_hi)} <small class="note">· {bt(ago_en, ago_hi)}</small></div><h3>{bt(en, hi)}</h3><p>{bt(de, dh)}</p></div>'
    fut = ''.join(f'<div class="m"><div class="y">{bt(a, b)}</div><p>{bt(c, d)}</p></div>' for a, b, c, d in FUTURE)
    body = f'''<section class="blk prose"><h1>{bt("Timeline of the universe", "ब्रह्मांड की समयरेखा")}</h1><p class="sub">{bt("The universe is 13.8 billion years old. Squeeze all of it into one calendar year, with the Big Bang at midnight on 1 January, and see when things happen.", "ब्रह्मांड 13.8 अरब साल पुराना है। उस सारे समय को एक कैलेंडर वर्ष में दबाइए, 1 जनवरी की आधी रात को Big Bang के साथ, और देखिए चीज़ें कब होती हैं।")}</p>
<div class="tl">{items}</div>
{callout("On this calendar the Sun does not exist until early September, dinosaurs vanish on 30 December, and the whole of human history fits into the last 12 minutes of 31 December.", "इस कैलेंडर में सूरज सितंबर की शुरुआत तक नहीं होता, डायनासोर 30 दिसंबर को ग़ायब होते हैं, और पूरा मानव इतिहास 31 दिसंबर के आख़िरी 12 मिनटों में आ जाता है।")}
{note("Dates are worked out as years after the Big Bang ÷ 13.8 billion × one year. Ages of early events are estimates and are still being refined.", "तारीख़ें इस तरह निकाली गई हैं: Big Bang के बाद के साल ÷ 13.8 अरब × एक साल। शुरुआती घटनाओं की उम्र अनुमान हैं और उन पर काम जारी है।")}
<h2>{bt("What comes next", "आगे क्या होगा")}</h2><div class="tl">{fut}</div>
{note("Future dates are predictions from current physics and may change.", "भविष्य की तारीख़ें मौजूदा भौतिकी की भविष्यवाणियाँ हैं और बदल सकती हैं।")}</section>'''
    out.append(('universe-timeline.html', h['shell']('Timeline of the universe', 'ब्रह्मांड की समयरेखा', 'tline', body,
                'The 13.8 billion year history of the universe squeezed into one calendar year: first stars, the Sun, life, dinosaurs and humans, and what comes next.',
                canonical='universe-timeline.html')))

    # ---------- glossary
    terms = sorted(GLOSSARY, key=lambda g: g[0].lower())
    cards = ''.join(f'<div class="card" id="{g[0].lower().replace(" ", "-").replace("(", "").replace(")", "")}" data-gl="{h["esc"]((g[0] + " " + g[1] + " " + g[2]).lower())}"><h3>{bt(g[0], g[1])}</h3><p>{bt(g[2], g[3])}</p></div>' for g in terms)
    body = f'''<section class="blk"><h1>{bt("Space glossary", "अंतरिक्ष शब्दकोश")}</h1><p class="sub">{bt("{n} words you meet when reading about the universe, in plain English and Hindi.".replace("{n}", str(len(terms))), "ब्रह्मांड के बारे में पढ़ते हुए मिलने वाले {n} शब्द, सरल English और हिंदी में।".replace("{n}", str(len(terms))))}</p>
<div class="row"><input type="search" id="glq" placeholder="redshift, ब्लैक होल…" aria-label="Search"></div>
<div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(300px,1fr))">{cards}</div><p class="note" id="glNone" style="display:none">{bt("No term matches.", "कोई शब्द नहीं मिला।")}</p></section>
<script>document.getElementById('glq').addEventListener('input',function(e){{var s=e.target.value.toLowerCase().trim(),n=0;document.querySelectorAll('[data-gl]').forEach(function(c){{var hide=!!s&&c.dataset.gl.indexOf(s)<0;c.classList.toggle('hide',hide);if(!hide)n++}});document.getElementById('glNone').style.display=n?'none':'block'}})</script>'''
    ld = {'@context': 'https://schema.org', '@type': 'DefinedTermSet', 'name': 'Astryl space glossary', 'inLanguage': ['en', 'hi'],
          'hasDefinedTerm': [{'@type': 'DefinedTerm', 'name': g[0], 'description': g[2]} for g in terms]}
    out.append(('glossary.html', h['shell']('Space glossary', 'अंतरिक्ष शब्दकोश', 'gloss', body,
                'A glossary of space words in plain English and Hindi: black hole, redshift, dark matter, light-year, event horizon, quasar and more.',
                canonical='glossary.html', ld=ld)))

    for f, html in out:
        h['write'](f, html)
    return [f for f, _ in out]
