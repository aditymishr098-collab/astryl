"""Home page "Discover today": things that change every day by themselves.

On this day in space history, a word of the day (from the glossary), a world of the day, a link
to the Daily 5 quiz and the newest blog post, plus a count of the days in a row the visitor has
come back (kept only in their own browser).
"""

# (month, day, year, what happened, page to read more)
HISTORY = [
    (1, 1, 1801, 'Giuseppe Piazzi discovered Ceres, the first asteroid ever found. Today it is called a dwarf planet.', 'planets.html'),
    (1, 2, 1959, 'Luna 1 was launched. It became the first spacecraft to escape Earth’s gravity and fly past the Moon.', 'missions.html'),
    (1, 4, 2004, 'The rover Spirit landed on Mars. It was built to last 90 days and worked for more than six years.', 'body/mars.html'),
    (1, 7, 1610, 'Galileo pointed his telescope at Jupiter and saw its moons for the first time.', 'body/jupiter.html'),
    (1, 14, 2005, 'The Huygens probe landed on Titan, the most distant landing ever made.', 'body/titan.html'),
    (1, 19, 2006, 'New Horizons was launched towards Pluto, the fastest spacecraft ever to leave Earth at that time.', 'spacecraft.html'),
    (1, 25, 2004, 'The rover Opportunity landed on Mars. It kept driving for more than 14 years.', 'body/mars.html'),
    (1, 31, 1958, 'Explorer 1, the first satellite of the United States, was launched. It discovered the Van Allen radiation belts.', 'missions.html'),
    (2, 6, 2018, 'Falcon Heavy flew for the first time and two of its boosters landed side by side.', 'missions.html'),
    (2, 9, 1986, 'Halley’s Comet passed closest to the Sun on its last visit. It comes back in 2061.', 'missions.html'),
    (2, 14, 1990, 'Voyager 1 looked back from 6 billion km and took the “Pale Blue Dot” photo of Earth.', 'spacecraft.html'),
    (2, 18, 1930, 'Clyde Tombaugh discovered Pluto. On the same date in 2021 the rover Perseverance landed on Mars.', 'body/pluto.html'),
    (2, 20, 1962, 'John Glenn became the first American to orbit the Earth.', 'missions.html'),
    (2, 24, 1968, 'The discovery of pulsars, spinning dead stars that flash like lighthouses, was published. Jocelyn Bell Burnell had spotted the first one.', 'stars.html'),
    (3, 2, 1972, 'Pioneer 10 was launched. It became the first spacecraft to cross the asteroid belt and fly past Jupiter.', 'missions.html'),
    (3, 5, 1979, 'Voyager 1 flew past Jupiter and found active volcanoes on its moon Io.', 'body/io.html'),
    (3, 10, 1977, 'Astronomers watching a star pass behind Uranus discovered that Uranus has rings.', 'body/uranus.html'),
    (3, 13, 1781, 'William Herschel discovered Uranus, the first planet found with a telescope.', 'body/uranus.html'),
    (3, 18, 1965, 'Alexei Leonov made the first spacewalk. It lasted 12 minutes.', 'missions.html'),
    (3, 23, 2001, 'The Russian space station Mir came down into the Pacific Ocean after 15 years in orbit.', 'iss.html'),
    (4, 10, 2019, 'The first picture of a black hole, in the galaxy M87, was shown to the world.', 'black-holes/how-we-see-black-holes.html'),
    (4, 12, 1961, 'Yuri Gagarin became the first human in space, with one orbit of the Earth in 108 minutes.', 'missions.html'),
    (4, 19, 1975, 'Aryabhata, India’s first satellite, was launched.', 'missions.html'),
    (4, 24, 1990, 'The Hubble Space Telescope was launched on the Space Shuttle Discovery.', 'telescope.html'),
    (4, 28, 2001, 'Dennis Tito flew to the International Space Station, the first person to pay for a trip to space.', 'iss.html'),
    (5, 5, 1961, 'Alan Shepard became the first American in space.', 'missions.html'),
    (5, 14, 1973, 'Skylab, the first space station of the United States, was launched.', 'iss.html'),
    (5, 22, 2021, 'China’s rover Zhurong rolled onto Mars, making China the second country to drive a rover there.', 'body/mars.html'),
    (5, 25, 2008, 'Phoenix landed near the north pole of Mars and later found water ice just under the soil.', 'body/mars.html'),
    (5, 30, 2020, 'Crew Dragon carried astronauts to the space station, the first crewed flight to orbit by a private company.', 'iss.html'),
    (6, 3, 1965, 'Ed White made the first American spacewalk, floating outside Gemini 4 for about 20 minutes.', 'missions.html'),
    (6, 16, 1963, 'Valentina Tereshkova became the first woman in space.', 'missions.html'),
    (6, 18, 1983, 'Sally Ride became the first American woman in space.', 'missions.html'),
    (6, 21, 2004, 'SpaceShipOne reached space, the first human spaceflight paid for by a private company.', 'missions.html'),
    (6, 30, 1908, 'A space rock exploded over Tunguska in Siberia and flattened about 2,000 square km of forest.', 'sky-events.html'),
    (7, 1, 2004, 'Cassini went into orbit around Saturn, the first spacecraft ever to do so.', 'body/saturn.html'),
    (7, 4, 1997, 'Mars Pathfinder landed and released Sojourner, the first rover on Mars.', 'body/mars.html'),
    (7, 12, 2022, 'The first full-colour pictures from the James Webb Space Telescope were released.', 'galaxies.html'),
    (7, 14, 2015, 'New Horizons flew past Pluto and showed its heart-shaped plain of ice for the first time.', 'body/pluto.html'),
    (7, 20, 1969, 'Apollo 11 landed on the Moon. Neil Armstrong and Buzz Aldrin became the first people to walk on another world.', 'body/moon.html'),
    (8, 6, 2012, 'The rover Curiosity landed on Mars, lowered to the ground by a rocket-powered “sky crane”.', 'body/mars.html'),
    (8, 12, 2018, 'Parker Solar Probe was launched. It is the fastest spacecraft ever built and flies through the Sun’s outer atmosphere.', 'body/sun.html'),
    (8, 20, 1977, 'Voyager 2 was launched. It is the only spacecraft that has visited Uranus and Neptune.', 'spacecraft.html'),
    (8, 23, 2023, 'Chandrayaan-3 became the first mission to land near the Moon’s south pole, and India the fourth country to land on the Moon.', 'maps.html'),
    (8, 24, 2006, 'Astronomers voted on what a planet is, and Pluto became a dwarf planet.', 'body/pluto.html'),
    (8, 25, 2012, 'Voyager 1 crossed into interstellar space, the first human-made object to do so.', 'spacecraft.html'),
    (9, 5, 1977, 'Voyager 1 was launched. It is now the most distant thing humans have ever made.', 'spacecraft.html'),
    (9, 14, 2015, 'Gravitational waves were detected for the first time, from two black holes that merged 1.3 billion years ago.', 'black-holes.html'),
    (9, 15, 2017, 'Cassini ended 13 years at Saturn by diving into the planet.', 'body/saturn.html'),
    (9, 23, 1846, 'Neptune was discovered, almost exactly where mathematics said it would be.', 'body/neptune.html'),
    (9, 24, 2014, 'Mangalyaan entered orbit around Mars. India reached Mars on its first try.', 'body/mars.html'),
    (9, 26, 2022, 'DART crashed into the asteroid moon Dimorphos on purpose and changed its orbit.', 'missions.html'),
    (10, 1, 1958, 'NASA began its work.', 'missions.html'),
    (10, 4, 1957, 'Sputnik 1 became the first artificial satellite, and the space age began.', 'missions.html'),
    (10, 7, 1959, 'Luna 3 took the first photos of the far side of the Moon, which always faces away from us.', 'body/moon.html'),
    (10, 15, 1997, 'Cassini-Huygens was launched on its seven-year trip to Saturn.', 'body/saturn.html'),
    (10, 22, 2008, 'Chandrayaan-1, India’s first mission to the Moon, was launched. It helped find water on the Moon.', 'body/moon.html'),
    (10, 24, 1946, 'A camera on a V-2 rocket took the first photo of the Earth from space, from about 105 km up.', 'body/earth.html'),
    (11, 2, 2000, 'The first long-stay crew arrived at the International Space Station. People have lived in space every day since.', 'iss.html'),
    (11, 3, 1957, 'The dog Laika became the first animal to orbit the Earth, on Sputnik 2.', 'missions.html'),
    (11, 5, 2013, 'Mangalyaan, India’s first mission to Mars, was launched.', 'body/mars.html'),
    (11, 12, 2014, 'Philae became the first spacecraft to land on a comet.', 'missions.html'),
    (11, 14, 1971, 'Mariner 9 reached Mars and became the first spacecraft to orbit another planet.', 'body/mars.html'),
    (11, 16, 2022, 'Artemis I was launched, sending an Orion capsule around the Moon and back.', 'body/moon.html'),
    (11, 17, 1970, 'Lunokhod 1 landed on the Moon, the first rover on another world.', 'maps.html'),
    (11, 18, 2026, 'Voyager 1 became the first spacecraft one light-day from Earth: light now takes a whole day to reach it.', 'blog/voyager-1-one-light-day.html'),
    (11, 20, 1998, 'Zarya, the first piece of the International Space Station, was launched.', 'iss.html'),
    (11, 26, 2018, 'InSight landed on Mars to listen for marsquakes.', 'body/mars.html'),
    (11, 28, 1964, 'Mariner 4 was launched. It took the first close-up photos of Mars.', 'body/mars.html'),
    (12, 2, 1995, 'The Sun-watching spacecraft SOHO was launched. It is still working.', 'body/sun.html'),
    (12, 3, 2018, 'OSIRIS-REx arrived at the asteroid Bennu. It later brought a sample of it back to Earth.', 'missions.html'),
    (12, 7, 1995, 'The Galileo spacecraft arrived at Jupiter and dropped a probe into its clouds.', 'body/jupiter.html'),
    (12, 14, 1972, 'Apollo 17 lifted off from the Moon. Nobody has walked there since.', 'body/moon.html'),
    (12, 15, 1970, 'Venera 7 landed on Venus, the first spacecraft to land on another planet and send a signal back.', 'body/venus.html'),
    (12, 21, 1968, 'Apollo 8 was launched, carrying the first people ever to leave Earth’s orbit.', 'body/moon.html'),
    (12, 24, 1968, 'The crew of Apollo 8 took the “Earthrise” photo from the Moon’s orbit.', 'body/earth.html'),
    (12, 25, 2021, 'The James Webb Space Telescope was launched.', 'galaxies.html'),
]

WORLDS = ['mercury', 'venus', 'earth', 'moon', 'mars', 'jupiter', 'io', 'europa', 'ganymede', 'callisto', 'saturn', 'titan', 'enceladus', 'uranus', 'neptune', 'triton', 'pluto', 'sun']


def _day(h):
    d = h / 24
    return f'{h:g} hours' if h < 48 else f'about {d:.0f} Earth days' if d >= 10 else f'{d:.1f} Earth days'


def _temp(t):
    return f'{t}'.replace('-', '−') + ' °C'


def world_fact(b, names):
    """One line of real numbers for the world of the day, from the site's own data."""
    width = f'{b["diam"]:,} km wide'
    if b['id'] == 'sun':
        return f'{width}, about 5,500 °C at the surface. At its equator one turn takes about {b["day"] / 24:.0f} days.'
    if b['kind'] == 'moon':
        return f'{width}, about {_temp(b["temp"])}. It goes round {names.get(b["parent"], b["parent"].title())} every {b["year"]:g} days.'
    moons = f'{b["moons"]} known moon' + ('' if b['moons'] == 1 else 's') if b['moons'] else 'no moons'
    return f'{width}, about {_temp(b["temp"])} on average, {moons}. A day lasts {_day(b["day"])}.'


def data(glossary, names, newest_post, bodies=()):
    """Everything discover.js needs, as one JSON-ready dict."""
    facts = {b['id']: world_fact(b, names) for b in bodies}
    return {
        'history': [[m, d, y, t, u] for m, d, y, t, u in HISTORY],
        'words': [[g[0], g[2]] for g in glossary],
        'worlds': [[w, names[w], facts.get(w, '')] for w in WORLDS if w in names],
        'post': newest_post,
    }
