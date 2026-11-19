"""Plain text and questions for pages whose main content is drawn by JavaScript, so that readers
and search engines see an explanation even before the scripts run. English only."""
import json

TEXT = {
    'compare': {
        'h2': 'How to compare planets',
        'p': [
            'Pick any two worlds above to put them side by side: size, mass, gravity, the length of a day and a year, temperature, moons and what the air is made of. The numbers come from NASA fact sheets.',
            'Some results surprise people. Jupiter is so big that about 1,300 Earths would fit inside it. Venus is hotter than Mercury even though it is almost twice as far from the Sun, because its thick carbon dioxide air traps heat. Saturn is the least dense planet, less dense than water, and Earth is the densest.',
            'Gravity decides how heavy you would feel. On Mars you would weigh about 38% of your Earth weight; on the Moon about 17%. To try it with your own weight, open the “You” page.',
        ],
        'faq': [
            ('Which is the biggest planet?', 'Jupiter. It is about 11 times wider than Earth and more than twice as heavy as all the other planets put together.'),
            ('Which is the hottest planet?', 'Venus, at about 464 °C on average, day and night. Its thick carbon dioxide atmosphere traps the Sun’s heat.'),
            ('Which planet is most like Earth?', 'In size and mass, Venus: it is about 95% as wide as Earth. In the length of a day, Mars: one Martian day lasts 24 hours 37 minutes.'),
            ('Which planet has the most moons?', 'Saturn has by far the most known moons. Astronomers keep finding more small ones, so the count goes up every few years.'),
        ],
    },
    'spacecraft': {
        'h2': 'Where our spacecraft are',
        'p': [
            'Eight spacecraft are shown here, from the space station a few hundred kilometres up to Voyager 1, the most distant object people have ever built. Each card shows how far away it is today, how fast it is moving and how long a radio signal takes to reach it.',
            'Voyager 1 and Voyager 2 were launched in 1977. Both have left the bubble of the Sun’s wind and are now in interstellar space. New Horizons flew past Pluto in 2015 and is still heading outwards. The James Webb Space Telescope works about 1.5 million kilometres from Earth, four times farther than the Moon.',
            'Radio signals travel at the speed of light, yet a message to Voyager 1 still takes almost a whole day to arrive, and the answer another day to come back.',
        ],
        'faq': [
            ('Which spacecraft is farthest from Earth?', 'Voyager 1. It is about a light-day away, more than 25 billion kilometres, and moves about 17 km every second.'),
            ('Are the Voyagers still working?', 'Yes, they still send data, but their power is running down, so engineers have switched off some instruments to keep the rest going for as long as possible.'),
            ('How is the distance worked out?', 'For the far probes it is worked out from their known speed and direction, so it can be off by about 1% as Earth moves round the Sun. The Mars distance is calculated for today.'),
        ],
    },
    'quiz': {
        'h2': 'About the Astryl space quiz',
        'p': [
            'The quiz has three parts. The Daily 5 gives everybody the same five questions each day, with a leaderboard for the day and the week. The rounds use real NASA photos, constellations, space missions, “bigger or smaller” and best-guess questions. Practice lets you go through questions at your own pace.',
            'Every answer comes with a short explanation, so you learn something even when you get it wrong. Without an account, the rounds are practice. With a free account, right answers earn Space Points and badges, and you can play the Daily 5 and appear on the leaderboard.',
        ],
        'faq': [
            ('Is the quiz free?', 'Yes. Astryl is free and has no ads.'),
            ('Do I need an account?', 'For the Daily 5, Space Points and the leaderboard, yes, a free one. Without an account the rounds work as practice.'),
            ('When do the Daily 5 questions change?', 'Every day at midnight UTC. Everybody gets the same five questions on the same day.'),
            ('Is there an easier quiz on black holes and galaxies?', 'Yes, the black hole and galaxy quiz has its own questions, each with an explanation, and needs no account.'),
        ],
    },
    'you': {
        'h2': 'Why your weight changes from planet to planet',
        'p': [
            'Your mass, how much of you there is, stays the same everywhere. Your weight is how hard a planet’s gravity pulls on that mass, so it changes. On the Moon you would weigh about a sixth of your Earth weight and could jump about six times as high. On Jupiter, at the top of its clouds, you would weigh about 2.4 times as much.',
            'Your age changes too, because a year is the time a planet takes to go once round the Sun. A Mars year lasts 687 Earth days, so you are younger in Mars years; a Mercury year lasts only 88 days, so you are much older in Mercury years.',
            'The birthday sky shows where the planets and the Moon were on the day you were born, and how far the light that left Earth that day has travelled since. Everything is worked out in your browser; nothing is sent or saved.',
        ],
        'faq': [
            ('How much would I weigh on the Moon?', 'About 17% of your weight on Earth. Someone who weighs 60 kg on Earth would feel like about 10 kg.'),
            ('How much would I weigh on Mars?', 'About 38% of your Earth weight, so 60 kg would feel like about 23 kg.'),
            ('What is a birthday star?', 'A star whose distance in light years is the same as your age, so the light you see from it tonight left the star around the time you were born.'),
            ('Is my birth date saved?', 'No. It is worked out in your browser and never sent anywhere.'),
        ],
    },
    'blog': {
        'h2': 'About the blog',
        'p': [
            'The Astryl blog is for longer stories about space, time and the universe: the questions that need more than a fact card. Each post explains the science in plain words and links to the sources.',
            'Anyone can comment, with or without an account. Links are not allowed in comments, and comments that readers report are checked by a moderator.',
        ],
        'faq': [
            ('Can I comment without an account?', 'Yes. Write any name you like, or leave it empty to post as Guest.'),
            ('Can I suggest a topic?', 'Yes, please write to contact@astryl.space with your idea.'),
        ],
    },
    'dsq': {
        'h2': 'What the quiz covers',
        'p': [
            'The questions cover what black holes are, how they form, what happens near the event horizon, the giant black hole at the centre of the Milky Way, and the main kinds of galaxies and how they grow.',
            'A few things to get you started: the Milky Way is about 100,000 light years across and holds a few hundred billion stars. At its centre sits Sagittarius A*, a black hole about four million times as heavy as the Sun. The nearest black hole known so far, Gaia BH1, is about 1,560 light years away.',
        ],
        'faq': [
            ('How many questions are there?', '21, split into black holes and galaxies. Each round takes five at random from the set you pick.'),
            ('Do I need an account?', 'No. Your best scores stay in this browser only.'),
            ('Where can I learn more first?', 'Black holes 101 is a short course in seven lessons, and it ends with a badge.'),
        ],
    },
}


def section(key):
    """The text and questions as a page section."""
    t = TEXT[key]
    ps = ''.join(f'<p>{p}</p>' for p in t['p'])
    faq = ''.join(f'<details class="jyfaq"><summary>{q}</summary><p>{a}</p></details>' for q, a in t['faq'])
    return f'<section class="blk prose"><h2>{t["h2"]}</h2>{ps}<h2>Questions</h2>{faq}</section>'


def faq_ld(key):
    """FAQPage structured data for the same questions."""
    return {'@context': 'https://schema.org', '@type': 'FAQPage', 'mainEntity': [
        {'@type': 'Question', 'name': q, 'acceptedAnswer': {'@type': 'Answer', 'text': a}} for q, a in TEXT[key]['faq']]}
