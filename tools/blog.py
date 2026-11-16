"""The Astryl blog: longer posts on space and physics, with comments from readers.

Each post is a dict in POSTS (newest first). The comments are kept by the "community" Edge
Function; its config.json lists the post slugs it accepts (checked by build()).
Numbers are from published measurements (NASA, NIST, CERN and the papers named in each post).
"""
import json
import math

import spacephotos
from dskit import article_ld


def gamma(beta):
    return 1 / math.sqrt(1 - beta * beta)


def _speed_rows():
    c = 299792.458
    rows = []
    for name, kms in [('A car on the motorway (100 km/h)', 100 / 3600), ('An airliner (900 km/h)', 900 / 3600), ('The ISS (7.7 km/s)', 7.66),
                      ('Voyager 1 (17 km/s)', 16.9), ('Parker Solar Probe at its fastest (192 km/s)', 191.7)]:
        b = kms / c
        lag = b * b / 2 * 365.25 * 86400  # seconds a year your clock falls behind (v much smaller than c)
        txt = f'{lag * 1e9:.0f} billionths of a second' if lag < 1e-6 else f'{lag * 1e6:.0f} millionths of a second' if lag < 1e-3 else f'{lag:.2f} seconds' if lag < 1 else f'{lag:.1f} seconds'
        rows.append((name, txt))
    for pct in (50, 90, 99, 99.9, 99.99):
        g = gamma(pct / 100)
        rows.append((f'{pct}% of the speed of light', f'1 year for you = {g:.2f} years on Earth'.replace('.00 ', ' ')))
    return rows


TIME_TRAVEL = {
    'slug': 'time-travel',
    'title': 'Time travel: what physics really allows',
    'desc': 'Travel to the future is real and has been measured. Travel to the past is far harder. Here is what Einstein, GPS satellites, astronauts and black holes tell us about time travel.',
    'date': '2026-11-16',
    'photo': 'gx-udf',
    'emoji': '⏳',
    'minutes': 12,
}


def time_travel_body():
    rows = ''.join(f'<tr><td>{a}</td><td class="w">{b}</td></tr>' for a, b in _speed_rows())
    return f'''
<p class="lead">You are a time traveller right now. You move into the future at one second per second, like everyone else. The real question is whether you can go <b>faster</b> than that, or go <b>backwards</b>. Physics has a surprising answer: the first is real and has been measured many times, and the second is not ruled out by the equations, but it needs things nobody has ever found.</p>

<div class="stats">
<div class="stat"><b>Yes</b><span>Travel to the future (measured)</span></div>
<div class="stat"><b>0.02 s</b><span>How far into the future the record-holding cosmonaut travelled</span></div>
<div class="stat"><b>38 µs</b><span>How much faster GPS clocks tick each day</span></div>
<div class="stat"><b>Unknown</b><span>Travel to the past</span></div>
</div>

<h2>What is time, for a physicist?</h2>
<p>Before 1905, everyone thought time was the same everywhere: one big clock ticking for the whole universe. Albert Einstein showed that this is wrong. Space and time are woven together into one thing, <b>spacetime</b>, and how fast your clock ticks depends on <b>how fast you move</b> and <b>how strong the gravity around you is</b>.</p>
<p>This is not a trick of clocks. Everything slows down together: your heartbeat, your thoughts, the atoms in your body. You would never feel it. You would only notice when you met someone whose clock had ticked at a different speed.</p>

<h2>Way 1 to the future: go very fast</h2>
<p>Einstein’s <b>special relativity</b> (1905) says that a moving clock ticks more slowly than one at rest. The effect is called <b>time dilation</b>. At everyday speeds it is unimaginably small. Near the speed of light (about 300,000 km every second) it becomes huge.</p>
<p>The slowing is given by one number, the <b>Lorentz factor</b>: γ = 1 / √(1 − v²/c²), where v is your speed and c is the speed of light. If γ is 10, then one year for you is ten years for the people you left behind.</p>
<div class="tscroll"><table class="cmp"><thead><tr><th>Speed</th><th>How much your clock falls behind in a year of moving</th></tr></thead><tbody>{rows}</tbody></table></div>
<p class="note">For the slow speeds the gravity effect (below) is left out, so the ISS line is the speed part only.</p>

<h3>Has anyone really done it?</h3>
<ul>
<li><b>Cosmonaut Sergei Krikalev</b> spent 803 days in orbit. Because he was moving so fast, he came back about <b>one fiftieth of a second</b> younger than if he had stayed home. He has travelled further into the future than anyone else.</li>
<li><b>Astronaut Scott Kelly</b> spent almost a year on the ISS while his identical twin Mark stayed on Earth. Scott came back a few thousandths of a second younger than his twin.</li>
<li><b>Atomic clocks on airliners.</b> In 1971 Joseph Hafele and Richard Keating flew very precise clocks around the world on normal passenger flights. When they landed, the clocks disagreed with the ones left at home by billionths of a second, just as Einstein predicted.</li>
<li><b>Muons from the sky.</b> When cosmic rays hit the air about 15 km up, they make tiny particles called muons. A muon falls apart in about 2.2 millionths of a second, which should be far too short to reach the ground. Yet we detect them at sea level, because at 99.9% of the speed of light their clocks run slow.</li>
<li><b>Particle accelerators.</b> Protons in the Large Hadron Collider at CERN move so close to the speed of light that their clocks run about 7,000 times slower than ours.</li>
</ul>

<h3>The twin paradox</h3>
<p>Imagine twins. One stays on Earth. The other flies to a star 10 light-years away at 99.5% of the speed of light and comes straight back. For the twin on Earth the trip takes about <b>20 years</b>. For the traveller, whose γ is about 10, it takes only about <b>2 years</b>. When they meet again, the traveller is 18 years younger than their twin. It sounds like a paradox (each twin sees the other moving), but it is not: only the traveller turns around and changes speed, and that breaks the symmetry.</p>

<div class="card ttcalc" id="ttCalc">
<h3 style="margin-top:0">🚀 Your time machine to the future</h3>
<p class="note">Choose a speed and how long the trip lasts for you. See how much time passes on Earth.</p>
<div class="ttspeeds" role="group" aria-label="Speed">
<button type="button" data-b="0.5">50%</button><button type="button" data-b="0.9">90%</button><button type="button" data-b="0.99" class="on">99%</button><button type="button" data-b="0.999">99.9%</button><button type="button" data-b="0.9999">99.99%</button><button type="button" data-b="0.999999">99.9999%</button>
</div>
<label class="ttyears">Trip time for you: <b id="ttY">5</b> years<input type="range" min="1" max="40" value="5" aria-label="Trip time for you in years"></label>
<div class="stats"><div class="stat"><b id="ttG">7.09</b><span>Your clock runs this many times slower</span></div><div class="stat"><b id="ttE">35 years</b><span>Time that passes on Earth</span></div><div class="stat"><b id="ttA">2061</b><span>The year when you get home</span></div></div>
</div>

<h3>The catch: energy</h3>
<p>Going fast enough to make a big jump is the hard part. To push a spaceship of just one tonne to 99% of the speed of light you would need about <b>5.5 × 10²⁰ joules</b> of energy, roughly what all of humanity uses in a whole year. Today’s fastest spacecraft, the Parker Solar Probe, reaches 0.064% of the speed of light.</p>

<h2>Way 2 to the future: sit near strong gravity</h2>
<p>Einstein’s <b>general relativity</b> (1915) adds a second effect: clocks deeper in gravity tick more slowly. A clock on the floor runs a tiny bit slower than one on a shelf.</p>
<ul>
<li><b>GPS depends on it.</b> GPS satellites fly about 20,200 km up, where gravity is weaker. Their clocks gain about 45 millionths of a second a day because of the weaker gravity and lose about 7 because of their speed. That is <b>38 millionths of a second a day</b>. Without correcting for this, your phone’s map would drift by roughly 10 km every day.</li>
<li><b>Even 33 cm matters.</b> In 2010 scientists at NIST in the USA compared two extremely precise aluminium clocks and saw the higher one tick faster when it was lifted by just 33 centimetres.</li>
<li><b>Earth’s centre is younger.</b> Because gravity slows time deeper down, physicists worked out in 2016 that Earth’s core is about two and a half years younger than its surface.</li>
<li><b>Neutron stars.</b> On the surface of a neutron star, a ball heavier than the Sun squeezed to the size of a city, clocks run roughly a fifth slower than far away.</li>
<li><b>Black holes.</b> Close to a black hole the slowing becomes extreme. In the film <i>Interstellar</i> (whose science adviser was the Nobel-winning physicist Kip Thorne), one hour on a planet near a giant spinning black hole is seven years on Earth. That planet is made up, but the physics behind it is real. At the edge of a black hole, the event horizon, time seen from far away seems to stop.</li>
</ul>
<p>So you could travel to the future by orbiting close to a black hole for a while and then flying away. You would come back to a world that had moved on by years while only hours passed for you.</p>

<h2>What about going back in time?</h2>
<p>This is where things get strange. General relativity does not forbid travel to the past. Some solutions of Einstein’s equations contain <b>closed timelike curves</b>: paths through spacetime that loop back to their own past. But every one found so far needs something we have never seen:</p>
<div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(230px,1fr))">
<div class="card"><h3>🌀 Gödel’s universe (1949)</h3><p>The mathematician Kurt Gödel found a universe that spins as a whole, where you could travel into your own past. Our universe does not seem to spin.</p></div>
<div class="card"><h3>🕳️ Wormholes (1988)</h3><p>Kip Thorne and Michael Morris showed that a tunnel through spacetime could, in theory, be turned into a time machine. Keeping it open needs “exotic matter” with negative energy, which has only been seen in tiny amounts in the lab (the Casimir effect).</p></div>
<div class="card"><h3>🧵 Tipler cylinder (1974)</h3><p>Frank Tipler found that an extremely heavy cylinder spinning very fast could twist spacetime into a loop. But it would have to be infinitely long.</p></div>
<div class="card"><h3>➰ Cosmic strings (1991)</h3><p>J. Richard Gott showed that two cosmic strings, thin threads of energy left from the early universe, racing past each other could allow loops in time. Nobody has found a cosmic string.</p></div>
<div class="card"><h3>💨 Faster than light</h3><p>In relativity, anything that goes faster than light would, for some observers, arrive before it left. That is why faster-than-light travel and time travel to the past are really the same problem. Nothing with mass has ever been seen moving faster than light.</p></div>
<div class="card"><h3>🚪 No visits before the machine</h3><p>In wormhole-type time machines you can never travel back to a time before the machine was built. That is one answer to “why haven’t we met tourists from the future?”</p></div>
</div>

<h2>The paradoxes</h2>
<p><b>The grandfather paradox.</b> You go back and stop your grandparents from meeting. Then you are never born, so you never go back, so they do meet, so you are born… Which is true?</p>
<p><b>The bootstrap paradox.</b> You travel back and give a young composer the music of their own famous symphony, which they then publish. Who wrote the music? The information has no beginning.</p>
<p>Physicists have suggested three ways out:</p>
<ul>
<li><b>The past cannot be changed.</b> The Russian physicist Igor Novikov proposed that anything a time traveller does was always part of history. You can visit the past, but whatever you try, events work out so that nothing contradicts itself.</li>
<li><b>Branching histories.</b> In the “many worlds” idea of quantum physics, a time traveller would arrive in a different branch of history. In 1991 the physicist David Deutsch showed how quantum mechanics could make such loops consistent.</li>
<li><b>Nature forbids it.</b> Stephen Hawking proposed the <b>chronology protection conjecture</b> (1992): the laws of physics, once we understand quantum gravity, will always stop a time machine from forming, for example because the energy in the loop would build up without limit and destroy it.</li>
</ul>
<div class="callout">🥂 In 2009 Stephen Hawking held a party for time travellers. He sent out the invitations only <b>after</b> the party was over, so only someone from the future could know about it. He waited, but nobody came. He joked that this was evidence that time travel to the past is not possible.</div>

<h2>You look into the past every night</h2>
<p>There is one kind of time travel everybody can do: looking up. Light takes time to reach us, so we always see things as they were, not as they are.</p>
<div class="tscroll"><table class="cmp"><thead><tr><th>What you look at</th><th>You see it as it was</th></tr></thead><tbody>
<tr><td>The Moon</td><td class="w">1.3 seconds ago</td></tr>
<tr><td>The Sun</td><td class="w">8 minutes 20 seconds ago</td></tr>
<tr><td>A radio message from Voyager 1</td><td class="w">about 24 hours ago (see <a href="../spacecraft.html">where it is now</a>)</td></tr>
<tr><td>Proxima Centauri, the nearest star</td><td class="w">4.2 years ago</td></tr>
<tr><td>The Andromeda Galaxy</td><td class="w">2.5 million years ago</td></tr>
<tr><td>The most distant galaxies seen by the James Webb Space Telescope</td><td class="w">more than 13.4 billion years ago, when the universe was about 300 million years old</td></tr>
<tr><td>The cosmic microwave background, the oldest light there is</td><td class="w">13.8 billion years ago, about 380,000 years after the Big Bang</td></tr>
</tbody></table></div>
<p>The photo at the top of this post, the Hubble Ultra Deep Field, is a time machine of its own: almost every speck in it is a galaxy, and some of them are seen as they were more than 13 billion years ago.</p>

<h2>So, can we time travel?</h2>
<div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(260px,1fr))">
<div class="card"><h3>✅ To the future</h3><p>Yes. It is proven and measured every day, from GPS satellites to astronauts. Small jumps are easy. Big jumps need speeds close to light or the gravity of a black hole, which are far beyond us today.</p></div>
<div class="card"><h3>❓ To the past</h3><p>Not ruled out by Einstein’s equations, but every known recipe needs something never observed: exotic matter, infinite cylinders or cosmic strings. Most physicists expect a full theory of quantum gravity to forbid it.</p></div>
</div>

<h2>Quick answers</h2>
<details class="card"><summary><b>Does time really slow down, or do clocks just run wrong?</b></summary><p>Time itself. Every process slows down together, including your body’s ageing, which is why the twin who travels comes back younger.</p></details>
<details class="card"><summary><b>Would I feel time slowing down?</b></summary><p>No. Your own time always feels normal to you. You only notice when you compare clocks with someone else.</p></details>
<details class="card"><summary><b>Could I travel back to see the dinosaurs?</b></summary><p>Not with any physics we know. Even the theoretical wormhole time machines cannot take you back to before the machine was built.</p></details>
<details class="card"><summary><b>Is light-speed travel possible?</b></summary><p>Not for anything with mass. As you get closer to the speed of light, the energy needed to go faster grows without limit. Only massless things like light travel at exactly that speed.</p></details>

<p class="note">Sources: Einstein’s papers on special (1905) and general relativity (1915); Hafele and Keating, <i>Science</i> 1972; Chou and colleagues at NIST, <i>Science</i> 2010; Uggerhøj and colleagues, <i>European Journal of Physics</i> 2016; Morris and Thorne, <i>American Journal of Physics</i> 1988; Hawking, <i>Physical Review D</i> 1992; NASA (Twins Study, GPS, Parker Solar Probe); CERN.</p>
'''


POSTS = [TIME_TRAVEL]


def nice_date(d):
    import datetime
    return datetime.date.fromisoformat(d).strftime('%-d %B %Y')


def build(h):
    shell, write, esc, bt, SITE, ROOT = h['shell'], h['write'], h['esc'], h['bt'], h['SITE'], h['ROOT']
    v = h['asset_v']()
    cfg = json.loads((ROOT / 'supabase/functions/community/config.json').read_text(encoding='utf-8'))
    assert sorted(cfg.get('blogPosts', [])) == sorted(p['slug'] for p in POSTS), 'update blogPosts in supabase/functions/community/config.json'
    head = f'<script defer src="{{p}}assets/blog.js?v={v}"></script>'
    urls = ['blog.html']

    def card(p, prefix):
        return (f'<a class="card blogcard" href="{prefix}blog/{p["slug"]}.html"><img src="{prefix}img/space/sm/{p["photo"]}.webp" alt="" loading="lazy" width="640" height="360">'
                f'<div><small class="note">{nice_date(p["date"])} · {p["minutes"]} min read · <span data-cc="{p["slug"]}"></span></small><h2>{p["emoji"]} {esc(p["title"])}</h2><p>{esc(p["desc"])}</p><span class="more">Read the post →</span></div></a>')

    # the list of posts
    body = ('<section class="blk"><h1>📝 The Astryl blog</h1><p class="sub">Longer stories about space, time and the universe. Everyone can join the conversation in the comments.</p>'
            '<div class="bloglist feat">' + ''.join(card(p, '') for p in POSTS) + '</div></section>')
    write('blog.html', shell('Blog', 'Blog', 'blog', body, 'The Astryl blog: longer stories about space, time and the universe, with comments from readers.', canonical='blog.html', extra_head=head.format(p='')))

    for p in POSTS:
        path = f'blog/{p["slug"]}.html'
        urls.append(path)
        fig = spacephotos.figure(p['photo'], '../', bt, esc, cls='sphoto blogfig').replace('loading="lazy"', 'loading="eager"')
        others = [o for o in POSTS if o is not p][:3]
        body = (f'<article class="blk prose blogpost"><p class="note"><a href="../blog.html">← Blog</a> · {nice_date(p["date"])} · {p["minutes"]} min read</p>'
                f'<h1>{p["emoji"]} {esc(p["title"])}</h1>{fig}{time_travel_body() if p is TIME_TRAVEL else ""}</article>'
                f'<section class="blk prose" id="comments" data-slug="{p["slug"]}"><h2>💬 Comments</h2><div id="blogComments"><p class="note">⏳ Loading comments…</p></div></section>'
                + (f'<section class="blk"><h2>More from the blog</h2><div class="bloglist">' + ''.join(card(o, '../') for o in others) + '</div></section>' if others else ''))
        ld = article_ld(SITE, p['title'], p['desc'], path, [('Astryl', ''), ('Blog', 'blog.html'), (p['title'], path)])
        ld[0]['datePublished'] = ld[0]['dateModified'] = p['date']
        ld[0]['inLanguage'] = 'en'
        write(path, shell(p['title'], p['title'], 'blog', body, p['desc'], depth=1, canonical=path, extra_head=head.format(p='../'), ld=ld))
    return urls
