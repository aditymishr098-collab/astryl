"""The Universe map page: the app's 3D map in the browser (logic in site_src/universe.js).

The data file is made from data/tables/universe_catalog.dart (made by tools/build_universe.py)."""
import json
import site_data
import re
from pathlib import Path

from dskit import Kit

CATALOG = site_data.TABLES / 'universe_catalog.dart'


def data_js():
    src = CATALOG.read_text(encoding='utf-8')
    rows = re.search(r"const String galaxyRows = '''\n(.*?)\n''';", src, re.S).group(1)

    def table(name):
        out = []
        for m in re.finditer(name + r"\('((?:[^'\\]|\\.)*)', ([^)]*)\),", src):
            out.append([m.group(1).replace("\\'", "'")] + [float(x) for x in m.group(2).split(', ')])
        return out

    data = {'g': rows, 's': table('StarRow'), 'h': table('HoleRow'), 'm': table('MarkRow')}
    assert len(data['s']) > 30 and len(data['h']) > 55 and len(data['m']) > 8 and rows.count('\n') > 3000
    return ('/* Universe map data. Galaxies: OpenNGC by Mattia Verga and contributors, CC BY-SA 4.0. '
            'Made by tools/umap.py from data/tables/universe_catalog.dart. */\nwindow.ASTRYL_UNI='
            + json.dumps(data, ensure_ascii=False, separators=(',', ':')) + ';\n')


def build(h):
    k = Kit(h)
    bt, P, H2 = k.bt, k.P, k.H2
    v = h['asset_v']()
    h['write']('assets/universe-data.js', data_js())
    body = f'''<section class="blk"><h1>{bt("Universe map", "ब्रह्मांड का नक्शा")}</h1><p class="sub">{bt("One 3D space with the planets where they are right now, nearby stars, 62 black holes and 3,600 real galaxies. Drag to turn, pinch or scroll to zoom, tap anything.", "एक 3D अंतरिक्ष जिसमें ग्रह अभी जहाँ हैं वहीं हैं, पास के तारे, 62 ब्लैक होल और 3,600 असली आकाशगंगाएँ। घुमाने के लिए खींचिए, ज़ूम के लिए चुटकी या scroll, किसी भी चीज़ पर टैप कीजिए।")}</p></section>
<section class="blk umap">
<div class="umchips" id="umLevels"></div>
<label class="umfind">{bt("Go to", "यहाँ जाएँ")} <input type="search" id="umFind" autocomplete="off" placeholder="Andromeda, M87, Sirius…" aria-label="Search stars, galaxies, black holes"></label>
<div class="umfound" id="umFound" hidden></div>
<div class="umwrap"><canvas id="umCv" tabindex="0" aria-label="Universe map. Arrow keys turn, plus and minus zoom."></canvas>
<div class="umzoom"><button type="button" id="umFull" aria-label="Full screen" title="Full screen">⛶</button><button type="button" id="umIn" aria-label="Zoom in">+</button><button type="button" id="umOut" aria-label="Zoom out">−</button></div>
<div class="umtour" id="umTour" hidden></div>
<div class="uminfo" id="umInfo" hidden></div></div>
<p class="note" id="umScale"></p>
<div class="umtime"><button class="btn primary" type="button" id="umTourBtn">🚀 {bt("Take the tour", "सैर कीजिए")}</button><span id="umTime"></span><button class="btn" type="button" id="umNow">{bt("Back to now", "अभी पर लौटें")}</button></div>
<div class="umchips" id="umSpeeds"></div>
</section>
<section class="blk prose">{H2("What is real here", "यहाँ क्या असली है")}
{P("The planets are where they are at this moment, from the orbit formulas of NASA JPL. Stars, black holes and galaxies sit at their real directions and distances. Sizes and shapes of galaxies come from the catalogue, and a black hole’s horizon is drawn at its real size when you zoom in on it.", "ग्रह ठीक इस समय जहाँ हैं वहीं दिखते हैं (NASA JPL के कक्षा सूत्रों से)। तारे, ब्लैक होल और आकाशगंगाएँ अपनी असली दिशा और दूरी पर हैं। आकाशगंगाओं का आकार और रूप catalogue से है, और ज़ूम करने पर ब्लैक होल का horizon असली आकार में बनता है।")}
{H2("What is a model", "क्या model है")}
{P("The dots of the Milky Way are a model with the real size, a bar and four arms: nobody can map single stars that far. Distances of far galaxies are estimated from their redshift, so some groups look stretched along our line of sight. The catalogue holds the brightest galaxies, most of them within 500 million light-years; the real universe has about two trillion.", "आकाशगंगा (मिल्की वे) के बिंदु एक model हैं, असली आकार, bar और चार भुजाओं के साथ: इतनी दूर के एक-एक तारे का नक्शा किसी के पास नहीं है। दूर की आकाशगंगाओं की दूरी उनके redshift से आँकी गई है, इसलिए कुछ समूह हमारी नज़र की दिशा में खिंचे दिखते हैं। catalogue में सबसे चमकीली आकाशगंगाएँ हैं, ज़्यादातर 50 करोड़ प्रकाश-वर्ष के भीतर; असली ब्रह्मांड में लगभग 2 ट्रिलियन हैं।")}
{H2("Speeding up time", "समय को तेज़ करना")}
{P("In real time nothing here seems to move: the Sun needs about 230 million years for one trip around the Galaxy. The speed buttons run the clock faster so you can watch planets orbit and the Milky Way turn. The disk is turned as one piece to keep the picture simple.", "असली समय में यहाँ कुछ हिलता नहीं दिखता: सूर्य को आकाशगंगा का एक चक्कर लगाने में लगभग 23 करोड़ साल लगते हैं। speed के बटन घड़ी तेज़ कर देते हैं, ताकि आप ग्रहों को घूमते और मिल्की वे को घूमते देख सकें। तस्वीर सरल रखने के लिए पूरी disk एक साथ घुमाई गई है।")}
<p class="note">{bt("Galaxy data:", "आकाशगंगाओं का data:")} <a href="https://github.com/mattiaverga/OpenNGC" rel="noopener">OpenNGC</a> {bt("by Mattia Verga and contributors (CC BY-SA 4.0).", "Mattia Verga और साथी (CC BY-SA 4.0)।")}</p>
</section>
{k.keep_exploring('', [('black-holes.html', '⚫', 'Black holes', 'ब्लैक होल'), ('galaxies.html', '🌌', 'Galaxies', 'Galaxies'), ('cosmic-scale.html', '📏', 'Scale of the universe', 'ब्रह्मांड का पैमाना'), ('black-hole-lab.html', '🧪', 'Black hole lab', 'ब्लैक होल lab')])}'''
    html = h['shell']('Universe map', 'ब्रह्मांड का नक्शा', 'umap', body,
                      'A free 3D map of the universe in your browser: the planets right now, nearby stars, 62 black holes and 3,600 real galaxies. Zoom from the Solar System to the edge of the observable universe.',
                      canonical='universe-map.html',
                      ld=[{'@context': 'https://schema.org', '@type': 'WebApplication', 'name': 'Universe map', 'applicationCategory': 'EducationalApplication', 'operatingSystem': 'Any', 'url': h['SITE'] + '/universe-map.html', 'inLanguage': ['en', 'hi'], 'isAccessibleForFree': True, 'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'USD'}}],
                      extra_head=f'<script defer src="assets/universe-data.js?v={v}"></script><script defer src="assets/universe.js?v={v}"></script>')
    h['write']('universe-map.html', html)
    return ['universe-map.html']
