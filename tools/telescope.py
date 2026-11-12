"""Telescope and eyepiece simulator page (logic in site_src/telescope.js)."""
from dskit import Kit, article_ld


def build(h):
    k = Kit(h)
    bt, P, H2 = k.bt, k.P, k.H2
    raw2 = h['raw2']  # for the lines that carry <b> tags
    v = h['asset_v']()
    scopes = [('70,700', '70 mm refractor (f/10)', '70 mm refractor (f/10)'), ('80,400', '80 mm short refractor (f/5)', '80 mm छोटा refractor (f/5)'),
              ('114,900', '114 mm reflector (f/8)', '114 mm reflector (f/8)'), ('130,650', '130 mm reflector (f/5)', '130 mm reflector (f/5)'),
              ('150,750', '150 mm reflector (f/5)', '150 mm reflector (f/5)'), ('203,1200', '8-inch Dobsonian (203 mm, f/6)', '8-इंच Dobsonian (203 mm, f/6)'),
              ('254,1200', '10-inch Dobsonian (254 mm, f/4.7)', '10-इंच Dobsonian (254 mm, f/4.7)'), ('90,1250', '90 mm Maksutov (f/14)', '90 mm Maksutov (f/14)')]
    eyes = [('32,52', '32 mm Plössl (52°)'), ('25,52', '25 mm Plössl (52°)'), ('20,68', '20 mm wide (68°)'), ('15,52', '15 mm Plössl (52°)'),
            ('10,52', '10 mm Plössl (52°)'), ('6,60', '6 mm (60°)'), ('4,52', '4 mm (52°)')]
    sel_scope = ''.join(f'<option value="{a}"{" selected" if a == "114,900" else ""}>{en}</option>' for a, en, hi in scopes)
    sel_eye = ''.join(f'<option value="{a}"{" selected" if a == "25,52" else ""}>{n}</option>' for a, n in eyes)
    targets = [('moon', 'The Moon', 'चाँद'), ('jupiter', 'Jupiter and its moons', 'बृहस्पति और उसके चाँद'), ('saturn', 'Saturn and its rings', 'शनि और उसके छल्ले'), ('mars', 'Mars', 'मंगल'),
               ('orion', 'Orion Nebula (M42)', 'ओरायन नीहारिका'), ('pleiades', 'Pleiades (M45)', 'कृत्तिका'), ('andromeda', 'Andromeda Galaxy (M31)', 'एंड्रोमेडा galaxy')]
    sel_t = ''.join(f'<option value="{a}">{en} / {hi}</option>' for a, en, hi in targets)
    body = f'''<section class="blk"><h1>🔭 {bt("Telescope eyepiece simulator", "Telescope eyepiece simulator")}</h1><p class="sub">{bt("Pick a telescope and an eyepiece to see the magnification, how much sky fits in view and roughly what the Moon, planets and deep-sky objects look like.", "Telescope और eyepiece चुनिए और देखिए कितना ज़ूम मिलेगा, कितना आसमान दिखेगा, और चाँद, ग्रह और दूर की चीज़ें लगभग कैसी दिखेंगी।")}</p></section>
<section class="blk ts"><div class="tsgrid"><div>
<label>{bt("Telescope", "Telescope")}<select id="tsScope">{sel_scope}<option value="">{bt("My own…", "अपना…")}</option></select></label>
<div class="row"><label>{bt("Aperture (mm)", "Aperture (mm)")}<input type="number" id="tsAp" value="114" min="20" max="1000"></label><label>{bt("Focal length (mm)", "Focal length (mm)")}<input type="number" id="tsFl" value="900" min="100" max="5000"></label></div>
<label>{bt("Eyepiece", "Eyepiece")}<select id="tsEyeP">{sel_eye}<option value="">{bt("My own…", "अपना…")}</option></select></label>
<div class="row"><label>{bt("Eyepiece focal length (mm)", "Eyepiece focal length (mm)")}<input type="number" id="tsEp" value="25" min="2" max="60"></label><label>{bt("Apparent field (°)", "Apparent field (°)")}<input type="number" id="tsAf" value="52" min="30" max="110"></label></div>
<label class="chk"><input type="checkbox" id="tsBar"> {bt("2× Barlow lens", "2× Barlow lens")}</label>
<label>{bt("Look at", "क्या देखें")}<select id="tsTarget">{sel_t}</select></label>
</div><div><canvas id="tsCv" aria-label="Eyepiece view"></canvas><p class="note" id="tsFit"></p></div></div>
<div id="tsStats"></div>
<p class="note">{bt("Real photos (NASA, Hubble, and Adam Evans for Andromeda), shown at their true size for this telescope. Real views are fainter and have less colour, and many telescopes show the view upside down. Planets look tiny even at high power; detail comes with practice and steady air.", "असली तस्वीरें (NASA, Hubble, और Andromeda के लिए Adam Evans), इस telescope में उनके असली आकार में। असली नज़ारा कम चमकीला और कम रंगीन होता है, और कई telescope उल्टा दिखाते हैं। तेज़ ज़ूम पर भी ग्रह छोटे दिखते हैं; detail अभ्यास और शांत हवा से आती है।")}</p></section>
<section class="blk prose">{H2("How the numbers work", "ये आँकड़े कैसे निकलते हैं")}
<ul><li>{raw2("<b>Magnification</b> = telescope focal length ÷ eyepiece focal length (× 2 with a Barlow).", "<b>ज़ूम</b> = telescope की focal length ÷ eyepiece की focal length (Barlow हो तो × 2)।")}</li>
<li>{raw2("<b>True field of view</b> = the eyepiece’s apparent field ÷ magnification. The full Moon is about half a degree wide.", "<b>असली दृश्य-क्षेत्र</b> = eyepiece का apparent field ÷ ज़ूम। पूरा चाँद लगभग आधा डिग्री चौड़ा है।")}</li>
<li>{raw2("<b>Exit pupil</b> = aperture ÷ magnification. Between about 1 and 7 mm is useful.", "<b>Exit pupil</b> = aperture ÷ ज़ूम। लगभग 1 से 7 mm तक काम का है।")}</li>
<li>{raw2("<b>Highest useful magnification</b> ≈ 2 × aperture in mm; above that the view only gets blurrier.", "<b>सबसे ज़्यादा काम का ज़ूम</b> ≈ 2 × aperture (mm में); उससे ऊपर नज़ारा बस धुंधला होता है।")}</li>
<li>{raw2("<b>Faintest star</b> ≈ 2.7 + 5 × log₁₀(aperture in mm), under a dark sky. <b>Finest detail</b> ≈ 116 ÷ aperture in mm, in arcseconds (Dawes limit).", "<b>सबसे धुंधला तारा</b> ≈ 2.7 + 5 × log₁₀(aperture mm में), अँधेरे आसमान में। <b>सबसे बारीक detail</b> ≈ 116 ÷ aperture mm, arcsecond में (Dawes सीमा)।")}</li></ul>
{k.callout("⚠️ Never point a telescope or binoculars at the Sun without a proper solar filter over the front. It can blind you instantly.", "⚠️ सामने सही solar filter के बिना telescope या दूरबीन को कभी सूरज की ओर मत कीजिए। इससे तुरंत अंधापन हो सकता है।")}</section>
{k.keep_exploring('', [('constellations.html', '⭐', 'Constellations', 'तारामंडल'), ('sky-events.html', '🌑', 'Eclipses and meteor showers', 'ग्रहण और उल्कापात'), ('galaxies/galaxies-you-can-see.html', '👀', 'Galaxies you can see', 'जो galaxies आप देख सकते हैं'), ('my-space.html', '🌆', 'Tonight in your city', 'आज रात आपके शहर में')])}'''
    desc = 'Free telescope and eyepiece simulator: magnification, true field of view, exit pupil, limiting magnitude and a picture of the Moon, planets and deep-sky objects in the eyepiece.'
    h['write']('telescope.html', h['shell']('Telescope eyepiece simulator', 'Telescope eyepiece simulator', 'scope', body, desc, canonical='telescope.html',
                                            ld=[{'@context': 'https://schema.org', '@type': 'WebApplication', 'name': 'Telescope eyepiece simulator', 'applicationCategory': 'EducationalApplication', 'operatingSystem': 'Any', 'url': h['SITE'] + '/telescope.html', 'inLanguage': ['en', 'hi'], 'isAccessibleForFree': True, 'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'USD'}}],
                                            extra_head=f'<script defer src="assets/telescope.js?v={v}"></script>'))
    return ['telescope.html']
