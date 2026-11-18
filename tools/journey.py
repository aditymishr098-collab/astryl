"""The "How we move through space" page: Earth, the Sun, the Milky Way and Andromeda in motion
(drawing in site_src/journey.js). English only."""
from dskit import article_ld

PATH = 'how-we-move.html'
TITLE = 'How Earth, the Sun and the Milky Way move through space'
DESC = ('Watch how the planets follow the Sun round the Milky Way, how the Sun circles the galaxy every 225 million years, '
        'whether we will hit Andromeda, and where we are all heading, with real speeds and directions.')

SPEEDS = [
    ('Earth spinning (at the equator)', '0.47 km/s', '1,670 km/h', 'east'),
    ('Earth round the Sun', '29.8 km/s', '107,000 km/h', 'changes through the year'),
    ('Sun among the nearby stars', 'about 20 km/s', '72,000 km/h', 'Hercules, near the star Vega'),
    ('Sun round the Milky Way', 'about 230 km/s', '828,000 km/h', 'Cygnus'),
    ('Milky Way and Andromeda, closing', 'about 110 km/s', '400,000 km/h', 'each other'),
    ('Sun against the cosmic microwave background', '370 km/s', '1.33 million km/h', 'Crater, next to Leo'),
    ('Local Group against the cosmic microwave background', 'about 620 km/s', '2.2 million km/h', 'Hydra and Centaurus'),
]

FAQ = [
    ('How fast is the Earth moving through space?',
     'It depends on what you measure against. The Earth goes round the Sun at about 29.8 km/s. The Sun, with all the planets, goes round the Milky Way at about 230 km/s. Against the cosmic microwave background, the afterglow of the Big Bang, the Sun moves at about 370 km/s.'),
    ('How long does the Sun take to go round the Milky Way?',
     'About 225 million years; estimates run from about 220 to 250 million. This is called a galactic year. The last time the Sun was where it is now, the first dinosaurs were just appearing.'),
    ('Is the famous “vortex” video of the Solar System right?',
     'Partly. The planets really do trace spirals as the Sun moves. But the planets’ orbits are tilted about 60° to the Sun’s path, not lined up behind it, and the spirals are much more stretched: the Sun moves about 48 times the Earth–Sun distance in the time the Earth takes for one orbit.'),
    ('Will the Milky Way crash into Andromeda?',
     'Maybe. A 2025 study using Hubble and Gaia data found about a 50% chance that the two galaxies merge within 10 billion years, and only about a 2% chance of a head-on crash in the next 4 to 5 billion years. Even if they merge, stars are so far apart that they almost never hit each other.'),
    ('What is the Great Attractor?',
     'A region about 150 to 250 million light years away, towards the constellations Centaurus and Norma, with a lot of mass that pulls our Local Group and thousands of other galaxies towards it. It is hard to see because the dust of our own Milky Way lies in front of it.'),
]


def build(h):
    shell, write, esc, SITE = h['shell'], h['write'], h['esc'], h['SITE']
    v = h['asset_v']()
    rows = ''.join(f'<tr><td>{a}</td><td><b>{b}</b><br><small class="note">{c}</small></td><td class="w">{d}</td></tr>' for a, b, c, d in SPEEDS)
    faq = ''.join(f'<details class="jyfaq"><summary>{q}</summary><p>{a}</p></details>' for q, a in FAQ)
    body = f'''<section class="blk"><h1>Where are we going?</h1>
<p class="sub">Right now you are spinning with the Earth, circling the Sun, and riding with the Sun round the Milky Way, which is itself falling through space. Here is how it all really moves, with real speeds and real directions.</p>
<div class="jylive" aria-live="off"><p class="note">Since you opened this page you have travelled</p>
<div class="jyctr"><div><b id="jyKmSun">0</b><span>km round the Sun</span></div><div><b id="jyKmGal">0</b><span>km round the Milky Way</span></div><div><b id="jyKmCmb">0</b><span>km against the Big Bang’s afterglow</span></div><div><b id="jyKmAnd">0</b><span>km closer to Andromeda</span></div></div></div>
</section>
<section class="blk jy">
<div class="umchips" role="group" aria-label="Choose what to watch">
<button type="button" data-scene="0">1. Planets and Sun</button><button type="button" data-scene="1">2. Sun round the Milky Way</button><button type="button" data-scene="2">3. Milky Way and Andromeda</button><button type="button" data-scene="3">4. Where we are heading</button>
</div>
<div class="jywrap"><canvas id="jyCv" tabindex="0" aria-label="Animation of how we move through space"></canvas></div>
<div class="umtime"><button class="btn primary" type="button" id="jyPlay">❚❚ Pause</button><span id="jyTime" aria-live="off"></span><span class="jybtns"><button class="btn" type="button" id="jyTrue" aria-pressed="false">Show true proportions</button><button class="btn" type="button" id="jyNow">Back to now</button></span></div>
<div class="umchips" id="jySpeeds" role="group" aria-label="Speed of time"></div>
<div class="card jyinfo" id="jyInfo" aria-live="polite"></div>
</section>
<section class="blk prose">
<h2>All our motions at a glance</h2>
<p>Speed only means something against something else. These are the main motions astronomers measure, from the smallest to the largest.</p>
<div class="tblwrap"><table class="cmp cols"><tr><th>Motion</th><th>Speed</th><th>Towards</th></tr>{rows}</table></div>
<h2>The planets trace spirals, but not like the viral video</h2>
<p>The Sun does not sit still while the planets circle it. It carries them with it round the Milky Way, so each planet’s path through space is a long, stretched spiral. Two details are often drawn wrong. First, the planets’ orbits are tilted about 60° to the Sun’s path, because the plane of the Solar System is tilted that much against the plane of the Milky Way. Second, the spirals are far more stretched than in most animations: in one year the Sun moves about 48 times the Earth–Sun distance. In the first scene, press “Show true proportions” to see how straight the paths really are.</p>
<h2>A galactic year</h2>
<p>The Sun is about 26,700 light years from the centre of the Milky Way and moves at about 230 km/s, so one lap takes about 225 million years. Since the Earth formed 4.5 billion years ago, the Sun has gone round about 20 times. On the way it also rises and sinks through the disk of the galaxy like a horse on a merry-go-round, crossing the middle every few tens of millions of years. Right now it is a little above the middle and moving up.</p>
<p>The spiral arms are not solid things that carry the stars. They are slow waves of crowding, like a traffic jam on a road. Stars, the Sun included, drive in and out of them over millions of years.</p>
<h2>Andromeda is coming, maybe</h2>
<p>The Andromeda galaxy, 2.5 million light years away, is moving towards us at about 110 km/s. For years the forecast was a head-on crash in about 4.5 billion years. In 2025 a team led by Till Sawala ran thousands of simulations with the latest Hubble and Gaia data, including the pull of the Large Magellanic Cloud and of Andromeda’s companion M33. They found only about a 2% chance of a crash in 4 to 5 billion years, and about a 50% chance that the two galaxies merge within 10 billion years.</p>
<h2>Falling towards the Great Attractor</h2>
<p>The cosmic microwave background, the afterglow of the Big Bang, fills the whole sky. Because we move through it, it looks very slightly warmer in the direction we are heading and cooler behind us. From that difference, the Planck satellite measured the Sun’s speed as 369.8 km/s towards the constellation Crater. Taking away the Sun’s own lap round the Milky Way, our whole Local Group of galaxies moves at about 620 km/s towards Hydra and Centaurus, pulled by the Great Attractor and the even bigger Shapley Supercluster beyond it.</p>
<h2>Questions</h2>
{faq}
<p class="note">Sources: Planck Collaboration 2018 (speed against the microwave background); Sawala et al., Nature Astronomy 2025, and ESA/Hubble release heic2508 (Andromeda); GRAVITY Collaboration 2019 (distance to the galactic centre). The spiral arms and the Sun’s up-and-down motion are drawn from simple models. Photos: the whole sky by ESO/S. Brunier (CC BY 4.0); Andromeda by Adam Evans (CC BY 2.0).</p>
</section>'''
    ld = article_ld(SITE, TITLE, DESC, PATH, [('Astryl', ''), ('Universe map', 'universe-map.html'), ('How we move', PATH)])
    ld[0]['inLanguage'] = 'en'
    ld[0]['datePublished'] = ld[0]['dateModified'] = '2026-11-18'
    ld.append({'@context': 'https://schema.org', '@type': 'FAQPage', 'mainEntity': [
        {'@type': 'Question', 'name': q, 'acceptedAnswer': {'@type': 'Answer', 'text': a}} for q, a in FAQ]})
    write(PATH, shell(TITLE, TITLE, 'umap', body, DESC, canonical=PATH, ld=ld,
                      extra_head=f'<script defer src="assets/journey.js?v={v}"></script>'))
    return [PATH]
