"""The space station page: live map and passes over your city (logic in site_src/iss.js and sgp4.js)."""
import json
import re

from dskit import Kit


def land_outline(root):
    """The app's simplified world map (lib/data/world_outline.dart) as a list of shapes."""
    text = (root / 'lib/data/world_outline.dart').read_text(encoding='utf-8')
    block = text[text.index('worldLand'):]
    block = block[:block.index('];')]
    return re.findall(r"'([-0-9., ]+)'", block)


def build(h):
    k = Kit(h)
    bt, H2 = k.bt, k.H2
    v = h['asset_v']()
    land = land_outline(h['ROOT'])
    assert len(land) > 20, len(land)
    body = f'''<section class="blk"><h1>🛰️ {bt("When can I see the space station?", "अंतरिक्ष स्टेशन मुझे कब दिखेगा?")}</h1><p class="sub">{bt("The International Space Station (ISS) is the brightest thing in the night sky after the Moon and Venus. Here is where it is right now and when it flies over your city, worked out in your browser from its real orbit.", "अंतरराष्ट्रीय अंतरिक्ष स्टेशन (ISS) रात के आसमान में चाँद और शुक्र के बाद सबसे चमकीली चीज़ है। यहाँ देखिए वह अभी कहाँ है और आपके शहर के ऊपर से कब गुज़रेगा, उसकी असली कक्षा से आपके browser में ही निकाला गया।")}</p></section>
<section class="blk iss"><div id="issApp"><p>⏳ {bt("Loading…", "Load हो रहा है…")}</p></div></section>
<section class="blk prose">{H2("How to see it", "इसे कैसे देखें")}
<ul><li>{bt("Look for a steady, bright white “star” moving smoothly across the sky. It does not blink; aeroplanes do.", "एक स्थिर, चमकीला सफ़ेद “तारा” ढूँढिए जो आसमान में आराम से चलता हुआ दिखे। यह टिमटिमाता नहीं; हवाई जहाज़ टिमटिमाते हैं।")}</li>
<li>{bt("A pass lasts a few minutes. Be outside a couple of minutes early and face the direction it comes from.", "एक उड़ान कुछ मिनट चलती है। दो-चार मिनट पहले बाहर आ जाइए और उस दिशा में देखिए जहाँ से वह आएगा।")}</li>
<li>{bt("The higher the pass (in degrees), the brighter it is. 90° is straight overhead; 10° is just above the horizon.", "उड़ान जितनी ऊँची (डिग्री में), उतनी चमकीली। 90° मतलब ठीक सिर के ऊपर; 10° मतलब क्षितिज से ज़रा ऊपर।")}</li>
<li>{bt("It often fades out suddenly in the middle of the sky. That is the moment it flies into Earth’s shadow.", "अक्सर यह आसमान के बीच में अचानक गायब हो जाता है। उसी पल वह पृथ्वी की छाया में चला जाता है।")}</li></ul>
{H2("Why only some passes are visible", "सिर्फ़ कुछ उड़ानें ही क्यों दिखती हैं")}
<p>{bt("The station has no lights you could see from the ground; it shines because sunlight reflects off it. So you can only see it when your sky is dark (after sunset or before sunrise) but the station, 400 km up, is still in sunlight. In the middle of the night it is usually in Earth’s shadow, and in the day the sky is too bright.", "Station पर ऐसी कोई light नहीं जो ज़मीन से दिखे; वह इसलिए चमकता है क्योंकि उस पर धूप पड़ती है। इसलिए वह तभी दिखता है जब आपका आसमान अँधेरा हो (सूर्यास्त के बाद या सूर्योदय से पहले) पर 400 किमी ऊपर station पर अभी धूप हो। आधी रात को वह अक्सर पृथ्वी की छाया में होता है, और दिन में आसमान बहुत चमकीला होता है।")}</p>
<p>{bt("It circles Earth about every 92 minutes, about 16 times a day, at around 27,600 km/h.", "यह लगभग हर 92 मिनट में पृथ्वी का एक चक्कर लगाता है, दिन में लगभग 16 बार, लगभग 27,600 किमी/घंटा की रफ़्तार से।")}</p>
<p class="note">{bt("Orbit data: wheretheiss.at and CelesTrak, kept by Astryl’s server for a few hours. Positions use SGP4, the standard model for satellite orbits. The Astryl app also shows Tiangong and Hubble and can remind you before a pass.", "कक्षा का data: wheretheiss.at और CelesTrak, जिसे Astryl का server कुछ घंटे रखता है। Positions SGP4 से निकलती हैं, जो satellite कक्षाओं का standard तरीका है। Astryl app Tiangong और Hubble भी दिखाता है और उड़ान से पहले याद दिला सकता है।")}</p></section>
{k.keep_exploring('', [('my-space.html', '🌆', 'Tonight in your city', 'आज रात आपके शहर में'), ('sky-events.html', '🌑', 'Eclipses and meteor showers', 'ग्रहण और उल्कापात'), ('spacecraft.html', '🛰️', 'Spacecraft', 'अंतरिक्ष यान'), ('telescope.html', '🔭', 'Telescope simulator', 'Telescope simulator')])}
<script type="application/json" id="issLand">{json.dumps(land, separators=(',', ':'))}</script>'''
    desc = 'When can I see the International Space Station? Live ISS map with day and night, and the visible passes over your city for the next 10 days, with calendar reminders. Free, in English and Hindi.'
    h['write']('iss.html', h['shell']('When can I see the space station (ISS)?', 'अंतरिक्ष स्टेशन (ISS) कब दिखेगा?', 'iss', body, desc, canonical='iss.html',
                                      ld=[{'@context': 'https://schema.org', '@type': 'WebApplication', 'name': 'ISS pass finder', 'applicationCategory': 'EducationalApplication', 'operatingSystem': 'Any', 'url': h['SITE'] + '/iss.html', 'inLanguage': ['en', 'hi'], 'isAccessibleForFree': True, 'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'USD'}}],
                                      extra_head=f'<script defer src="assets/tonight.js?v={v}"></script><script defer src="assets/sgp4.js?v={v}"></script><script defer src="assets/iss.js?v={v}"></script>'))
    return ['iss.html']
