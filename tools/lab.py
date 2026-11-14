"""The Black hole lab page: a lensing simulator and two calculators (logic in site_src/lab.js)."""
from dskit import Kit


def build(h):
    k = Kit(h)
    bt, P, H2, callout = k.bt, k.P, k.H2, k.callout

    def preset_btn(label_en, label_hi, **attrs):
        a = ' '.join(f'data-{n}="{v}"' for n, v in attrs.items())
        return f'<button class="btn" type="button" {a}>{bt(label_en, label_hi)}</button>'

    body = f'''<p style="margin-top:20px"><a href="black-holes.html">← {bt("Black holes", "ब्लैक होल")}</a></p>
<section class="blk"><h1>{bt("Black hole lab", "ब्लैक होल lab")}</h1><p class="sub">{bt("Bend the sky, size any black hole and slow down a clock. It all runs in your browser and nothing is sent anywhere.", "आसमान मोड़िए, किसी भी ब्लैक होल का आकार निकालिए और घड़ी धीमी कीजिए। सब कुछ आपके browser में चलता है, कुछ कहीं नहीं भेजा जाता।")}</p></section>
<section class="blk prose"><h2>{bt("1. Bend the sky", "1. आसमान को मोड़िए")}</h2>
{P("Gravity bends light, so a black hole in front of stars acts like a lens. Drag the black hole across the sky and watch the stars behind it stretch into arcs and a bright ring, called the Einstein ring. Use the slider to make it heavier.", "Gravity रोशनी को मोड़ती है, इसलिए तारों के सामने रखा ब्लैक होल लेंस की तरह काम करता है। ब्लैक होल को आसमान में खींचिए और देखिए कि पीछे के तारे चापों और एक चमकदार छल्ले (Einstein ring) में कैसे खिंचते हैं। भारी बनाने के लिए slider चलाइए।")}
<div class="simwrap"><canvas id="simCv" aria-label="Gravitational lensing simulator" width="480" height="320"></canvas></div>
<div class="row"><label>{bt("Mass", "द्रव्यमान")} <input type="range" id="simMass" min="25" max="110" value="55" aria-label="Mass"></label><button class="btn" type="button" id="simReset">{bt("Centre it", "बीच में लाएँ")}</button></div>
{k.note("A point-lens model, not a full ray-traced image: real black holes also show an accretion disk and the photon ring. The orange circle marks the Einstein radius.", "यह point-lens model है, पूरी ray-tracing वाली तस्वीर नहीं: असली ब्लैक होल में accretion disk और photon ring भी दिखते हैं। नारंगी घेरा Einstein radius दिखाता है।")}
</section>
<section class="blk prose"><h2>{bt("2. How big is it?", "2. यह कितना बड़ा है?")}</h2>
{P("Type any mass and get the size of its event horizon, r = 2GM/c², plus a few more things worked out from it. Tap a preset to try an example.", "कोई भी द्रव्यमान लिखिए और उसके event horizon का आकार, r = 2GM/c², और उससे निकली कुछ और बातें पाइए। उदाहरण के लिए preset दबाइए।")}
<div class="row"><input type="number" id="cMass" value="1" min="0" step="any" aria-label="Mass"><select id="cUnit" aria-label="Unit"><option value="kg">kg</option><option value="earth">Earths</option><option value="sun" selected>Suns</option></select></div>
<div class="row">{preset_btn("A person", "एक इंसान", v=70, u="kg")}{preset_btn("Earth", "पृथ्वी", v=1, u="earth")}{preset_btn("The Sun", "सूरज", v=1, u="sun")}{preset_btn("10 Suns", "10 सूरज", v=10, u="sun")}{preset_btn("Sagittarius A*", "Sagittarius A*", v=4300000, u="sun")}{preset_btn("M87*", "M87*", v=6500000000, u="sun")}</div>
<div class="stats" id="cOut"></div><p class="note" id="cNote"></p>
{k.note("Density is the mass divided by the volume inside the horizon. Hawking temperature and evaporation time come from Hawking’s 1974 formulas; they are predictions, never measured.", "घनत्व = द्रव्यमान ÷ horizon के अंदर का आयतन। Hawking temperature और ख़त्म होने का समय Hawking के 1974 के सूत्रों से हैं; ये भविष्यवाणियाँ हैं, कभी नापी नहीं गईं।")}
</section>
<section class="blk prose"><h2>{bt("3. Slow down a clock", "3. घड़ी को धीमा कीजिए")}</h2>
{P("Near a black hole, time runs slower as seen from far away. Pick a mass and move the slider to set how close you hover, measured in horizon radii. At 1 you are at the event horizon.", "ब्लैक होल के पास दूर से देखने पर समय धीमा चलता है। द्रव्यमान चुनिए और slider से तय कीजिए कि आप कितने पास मँडरा रहे हैं, horizon की त्रिज्या के गुणकों में। 1 का मतलब event horizon पर।")}
<div class="row"><label>{bt("Mass in Suns", "सूरज में द्रव्यमान")} <input type="number" id="dMass" value="10" min="0" step="any"></label><label style="flex:1;min-width:200px">{bt("Distance", "दूरी")}: <b id="dXv">3</b> × {bt("horizon radius", "horizon की त्रिज्या")}<input type="range" id="dX" min="0.0004" max="9" step="any" value="0.4771" style="width:100%" aria-label="Distance"></label></div>
<div class="row">{preset_btn("Photon sphere", "Photon sphere", m=10, x=1.5)}{preset_btn("Close to the horizon", "Horizon के बहुत पास", m=10, x=1.01)}{preset_btn("Last stable orbit", "आख़िरी स्थिर कक्षा", m=10, x=3)}{preset_btn("Earth’s surface", "पृथ्वी की सतह", m=0.000003003, x=718000000)}</div>
<div class="stats" id="dOut"></div><p class="note" id="dNote"></p>
{k.note("For a clock that hovers at rest at that distance. The clock rate is √(1 − r_s/r). It depends only on the distance in horizon radii, so a bigger black hole gives the same effect farther out in km.", "उस दूरी पर स्थिर टिकी घड़ी के लिए। घड़ी की गति √(1 − r_s/r) है। यह सिर्फ़ horizon की त्रिज्या के गुणकों में दूरी पर निर्भर है, इसलिए बड़े ब्लैक होल में वही असर km में ज़्यादा दूर मिलता है।")}
</section>
<section class="blk callout">{bt("Want the story behind the numbers?", "इन आँकड़ों के पीछे की कहानी चाहिए?")} <a href="black-holes/falling-into-a-black-hole.html">{bt("Falling into a black hole", "ब्लैक होल में गिरना")} →</a></section>'''
    html = h['shell']('Black hole lab', 'ब्लैक होल lab', 'bh', body,
                      'Free black hole tools: a gravitational lensing simulator, a Schwarzschild radius calculator for any mass and a gravitational time dilation calculator.',
                      canonical='black-hole-lab.html', ld=[{'@context': 'https://schema.org', '@type': 'WebApplication', 'name': 'Black hole lab', 'applicationCategory': 'EducationalApplication', 'operatingSystem': 'Any', 'url': h['SITE'] + '/black-hole-lab.html', 'inLanguage': ['en', 'hi'], 'isAccessibleForFree': True, 'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'USD'}}], extra_head=f'<script defer src="assets/lab.js?v={h["asset_v"]()}"></script>')
    h['write']('black-hole-lab.html', html)
    return ['black-hole-lab.html']
