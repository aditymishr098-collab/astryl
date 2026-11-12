"""Real deep-space photos for astryl.space (black holes, galaxies, nebulae, eclipses).

The originals are in data/photos/space (fetched once by tools/media/fetch_space.py from
Wikimedia Commons; only free licences). Here they are shrunk into site/img/space and given
a caption with their credit and licence. SLOTS says which page shows which photos: they are
placed right after the page's opening section.
"""
import json
from pathlib import Path
from PIL import Image

SRC = Path(__file__).resolve().parent.parent / 'data' / 'photos' / 'space'

# id: (credit, what it is in English, in Hindi)
INFO = {
    'bh-m87': ('EHT Collaboration', 'M87*, the first picture of a black hole (2019). The dark centre is its shadow; the glowing ring is hot gas around it.',
               'M87*, ब्लैक होल की पहली तस्वीर (2019)। बीच का काला हिस्सा उसकी परछाईं है; चमकता छल्ला उसके चारों ओर की गर्म गैस है।'),
    'bh-sgra': ('EHT Collaboration', 'Sagittarius A*, the black hole at the centre of our Milky Way (2022).',
                'Sagittarius A*, हमारी आकाशगंगा के केंद्र का ब्लैक होल (2022)।'),
    'bh-sgra-pol': ('EHT Collaboration', 'Sagittarius A* in polarised light (2024): the lines show the direction of its magnetic field.',
                    'polarised रोशनी में Sagittarius A* (2024): लकीरें उसके magnetic field की दिशा दिखाती हैं।'),
    'bh-m87-jet': ('NASA and The Hubble Heritage Team (STScI/AURA)', 'The jet of the galaxy M87, shot out from near its black hole at almost the speed of light (Hubble).',
                   'M87 galaxy का jet, जो उसके ब्लैक होल के पास से लगभग रोशनी की रफ़्तार से निकलता है (Hubble)।'),
    'bh-cygx1': ('ESA/Hubble (illustration)', 'An artist\'s picture of Cygnus X-1: a black hole pulling gas from a giant blue star. This is a drawing, not a photo.',
                 'Cygnus X-1 का चित्र: एक ब्लैक होल एक विशाल नीले तारे से गैस खींच रहा है। यह चित्र है, फ़ोटो नहीं।'),
    'bh-sgra-multi': ('NASA, ESA, CSA, STScI, CXC (via NASA\'s Webb Flickr)', 'The crowded centre of the Milky Way around Sagittarius A*, seen in X-ray, infrared and visible light together.',
                      'Sagittarius A* के आसपास आकाशगंगा का भीड़ भरा केंद्र, X-ray, infrared और सामान्य रोशनी में एक साथ।'),
    'bh-crab': ('NASA, ESA, J. Hester and A. Loll (Arizona State University)', 'The Crab Nebula: what is left of a star that exploded in 1054. Its core became a neutron star; heavier stars leave black holes.',
                'Crab Nebula: 1054 में फटे एक तारे का बचा हिस्सा। उसका केंद्र neutron star बना; इससे भारी तारे ब्लैक होल छोड़ते हैं।'),
    'gx-andromeda': ('Adam Evans', 'The Andromeda Galaxy, 2.5 million light years away; you can see it with your own eyes from a dark place.',
                     'Andromeda galaxy, 25 लाख प्रकाश वर्ष दूर; अँधेरी जगह से इसे नंगी आँखों से देखा जा सकता है।'),
    'gx-milkyway': ('ESO/S. Brunier', 'The Milky Way all around the sky, joined into one picture. We see our galaxy from inside, as a band of light.',
                    'पूरे आसमान में फैली आकाशगंगा, एक तस्वीर में जोड़ी हुई। हम अपनी galaxy को अंदर से, रोशनी की एक पट्टी की तरह देखते हैं।'),
    'gx-sombrero': ('NASA/ESA and The Hubble Heritage Team (STScI/AURA)', 'The Sombrero Galaxy, a spiral seen almost edge-on, with a dark lane of dust (Hubble).',
                    'Sombrero galaxy, लगभग किनारे से दिखती spiral, धूल की काली पट्टी के साथ (Hubble)।'),
    'gx-whirlpool': ('NASA and ESA', 'The Whirlpool Galaxy (M51), a spiral pulling on a smaller galaxy next to it (Hubble).',
                     'Whirlpool galaxy (M51), एक spiral जो अपने पास की छोटी galaxy को खींच रही है (Hubble)।'),
    'gx-antennae': ('NASA, ESA and The Hubble Heritage Team (STScI/AURA)', 'The Antennae Galaxies: two galaxies in the middle of a collision, lit up by new stars (Hubble).',
                    'Antennae galaxies: टकराव के बीच दो galaxies, नए तारों से चमकती हुई (Hubble)।'),
    'gx-lmc': ('NASA/Ames Research Center', 'The Large Magellanic Cloud, a small galaxy that goes around the Milky Way, seen from the southern half of Earth.',
               'Large Magellanic Cloud, एक छोटी galaxy जो आकाशगंगा का चक्कर लगाती है, पृथ्वी के दक्षिणी हिस्से से दिखती है।'),
    'gx-udf': ('NASA and ESA', 'The Hubble Ultra Deep Field: almost every dot is a galaxy, some seen as they were more than 13 billion years ago.',
               'Hubble Ultra Deep Field: लगभग हर बिंदु एक galaxy है, कुछ वैसी दिखती हैं जैसी 13 अरब साल से भी पहले थीं।'),
    'gx-webb': ('NASA, ESA, CSA and STScI', 'Webb\'s First Deep Field (2022): thousands of galaxies in a patch of sky the size of a grain of sand held at arm\'s length.',
                'Webb का पहला Deep Field (2022): हाथ भर दूर रखे रेत के एक दाने जितने आसमान में हज़ारों galaxies।'),
    'nb-pillars': ('NASA, ESA, CSA, STScI; J. DePasquale, A. Koekemoer, A. Pagan (STScI)', 'The Pillars of Creation (Webb, 2022): towers of gas and dust where new stars are being born.',
                   'Pillars of Creation (Webb, 2022): गैस और धूल की मीनारें जहाँ नए तारे जन्म ले रहे हैं।'),
    'nb-cliffs': ('NASA, ESA, CSA and STScI', 'The "Cosmic Cliffs" of the Carina Nebula (Webb, 2022), a nursery of young stars.',
                  'Carina Nebula की "Cosmic Cliffs" (Webb, 2022), नए तारों का पालना।'),
    'sun-sdo': ('NASA/SDO (AIA)', 'The Sun in ultraviolet light, from NASA\'s Solar Dynamics Observatory.',
                'पराबैंगनी रोशनी में सूरज, NASA के Solar Dynamics Observatory से।'),
    'sun-eclipse': ('Luc Viatour', 'A total solar eclipse (1999): the Moon hides the Sun and its pale outer air, the corona, shines around it.',
                    'पूर्ण सूर्य ग्रहण (1999): चाँद सूरज को ढक लेता है और उसकी हल्की बाहरी परत, corona, चारों ओर चमकती है।'),
    'moon-eclipse': ('Alfredo Garcia, Jr', 'A total lunar eclipse (2014): the Moon turns red in the light that Earth\'s air bends into its shadow.',
                     'पूर्ण चंद्र ग्रहण (2014): पृथ्वी की हवा जो रोशनी उसकी छाया में मोड़ती है, उससे चाँद लाल हो जाता है।'),
}

# page: photos shown after its first section
SLOTS = {
    'black-holes/what-is-a-black-hole.html': ['bh-cygx1'],
    'black-holes/how-black-holes-form.html': ['bh-crab'],
    'black-holes/event-horizon-and-singularity.html': ['bh-m87'],
    'black-holes/famous-black-holes.html': ['bh-sgra', 'bh-m87', 'bh-sgra-pol', 'bh-m87-jet', 'bh-sgra-multi', 'bh-cygx1'],
    'black-holes/how-we-see-black-holes.html': ['bh-m87', 'bh-sgra'],
    'galaxies.html': ['gx-webb', 'gx-udf'],
    'galaxies/what-is-a-galaxy.html': ['gx-whirlpool', 'gx-udf'],
    'galaxies/the-milky-way.html': ['gx-milkyway', 'bh-sgra-multi'],
    'galaxies/andromeda-galaxy.html': ['gx-andromeda'],
    'galaxies/types-of-galaxies.html': ['gx-whirlpool', 'gx-sombrero', 'gx-lmc'],
    'galaxies/the-local-group.html': ['gx-lmc', 'gx-andromeda'],
    'galaxies/galaxy-formation-and-collisions.html': ['gx-antennae', 'gx-webb'],
    'galaxies/galaxies-you-can-see.html': ['gx-andromeda', 'gx-lmc'],
    'learn/stars-and-constellations.html': ['nb-pillars', 'nb-cliffs'],
    'learn/eclipses.html': ['sun-eclipse', 'moon-eclipse'],
    'learn/sun-earth-moon.html': ['sun-sdo'],
    'universe-timeline.html': ['gx-udf', 'nb-pillars'],
}

SIZES = {}
CREDITS = {}


def build(out):
    """Writes img/space/<id>.webp (at most 1000 px, the Milky Way panorama 1400) and reads the credits."""
    if not SRC.exists():
        return {}
    meta = json.loads((SRC / 'credits.json').read_text(encoding='utf-8'))
    (out / 'img' / 'space').mkdir(parents=True, exist_ok=True)
    for pid in INFO:
        f = SRC / f'{pid}.webp'
        if not f.exists():
            continue
        im = Image.open(f).convert('RGB')
        im.thumbnail((1400, 700) if pid == 'gx-milkyway' else (1000, 1000))
        im.save(out / 'img' / 'space' / f'{pid}.webp', 'WEBP', quality=78, method=6)
        SIZES[pid] = im.size
        m = meta.get(pid, {})
        CREDITS[pid] = {'licence': m.get('licence', ''), 'page': m.get('page', '')}
    return SIZES


def figure(pid, prefix, bt, esc, cls='sphoto'):
    if pid not in SIZES:
        return ''
    w, h = SIZES[pid]
    credit, en, hi = INFO[pid]
    c = CREDITS[pid]
    lic = f' · <a href="{esc(c["page"])}" rel="noopener" target="_blank">{esc(c["licence"])}</a>' if c['page'] else ''
    return (f'<figure class="{cls}"><img src="{prefix}img/space/{pid}.webp" width="{w}" height="{h}" loading="lazy" decoding="async" alt="{esc(en)}">'
            f'<figcaption>{bt(esc(en), esc(hi))}<br><small>📷 {esc(credit)}{lic}</small></figcaption></figure>')


def strip(ids, prefix, bt, esc):
    figs = [figure(i, prefix, bt, esc) for i in ids if i in SIZES]
    if not figs:
        return ''
    return f'<section class="blk"><div class="sphotos{" one" if len(figs) == 1 else ""}">' + ''.join(figs) + '</div></section>'


def place(path, html, bt, esc):
    """Puts the photos of SLOTS[path] after the page's first section."""
    ids = SLOTS.get(path)
    if path.startswith('sky-events/') and not ids:
        ids = ['sun-eclipse'] if 'total-solar' in path else (['moon-eclipse'] if 'total-lunar' in path else None)
    if not ids or '<main' not in html:
        return html
    prefix = '../' * path.count('/')
    block = strip(ids, prefix, bt, esc)
    if not block:
        return html
    m = html.index('<main')
    i = html.find('</section>', m)
    if i < 0:
        return html
    i += len('</section>')
    return html[:i] + block + html[i:]
