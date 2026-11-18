"""Static "Night sky tonight in <city>" pages, worked out when the site is built.

The interactive pages calculate the sky in the browser, so search engines see little of it.
These pages carry the answer in the HTML itself: sunset and sunrise, the Moon, and which planets
can be seen and where, for one night in one city. The Website workflow rebuilds the site twice a
day, so the pages stay current.

The maths is the same as the browser's (tools/site_src/app.js): planets from JPL's Keplerian
elements, the Moon from Paul Schlyter's method, then altitude and azimuth for the city.
"""
import datetime as dt
import json
import math
from zoneinfo import ZoneInfo

import skyevents

# slug, name, country, latitude, longitude, time zone
CITIES = [
    ('delhi', 'Delhi', 'India', 28.61, 77.21, 'Asia/Kolkata'),
    ('mumbai', 'Mumbai', 'India', 19.08, 72.88, 'Asia/Kolkata'),
    ('bengaluru', 'Bengaluru', 'India', 12.97, 77.59, 'Asia/Kolkata'),
    ('kolkata', 'Kolkata', 'India', 22.57, 88.36, 'Asia/Kolkata'),
    ('chennai', 'Chennai', 'India', 13.08, 80.27, 'Asia/Kolkata'),
    ('hyderabad', 'Hyderabad', 'India', 17.39, 78.49, 'Asia/Kolkata'),
    ('pune', 'Pune', 'India', 18.52, 73.86, 'Asia/Kolkata'),
    ('ahmedabad', 'Ahmedabad', 'India', 23.02, 72.57, 'Asia/Kolkata'),
    ('jaipur', 'Jaipur', 'India', 26.91, 75.79, 'Asia/Kolkata'),
    ('lucknow', 'Lucknow', 'India', 26.85, 80.95, 'Asia/Kolkata'),
    ('karachi', 'Karachi', 'Pakistan', 24.86, 67.01, 'Asia/Karachi'),
    ('lahore', 'Lahore', 'Pakistan', 31.55, 74.34, 'Asia/Karachi'),
    ('dhaka', 'Dhaka', 'Bangladesh', 23.81, 90.41, 'Asia/Dhaka'),
    ('kathmandu', 'Kathmandu', 'Nepal', 27.72, 85.32, 'Asia/Kathmandu'),
    ('colombo', 'Colombo', 'Sri Lanka', 6.93, 79.86, 'Asia/Colombo'),
    ('dubai', 'Dubai', 'United Arab Emirates', 25.20, 55.27, 'Asia/Dubai'),
    ('yerevan', 'Yerevan', 'Armenia', 40.18, 44.51, 'Asia/Yerevan'),
    ('istanbul', 'Istanbul', 'Turkey', 41.01, 28.98, 'Europe/Istanbul'),
    ('cairo', 'Cairo', 'Egypt', 30.04, 31.24, 'Africa/Cairo'),
    ('lagos', 'Lagos', 'Nigeria', 6.52, 3.38, 'Africa/Lagos'),
    ('nairobi', 'Nairobi', 'Kenya', -1.29, 36.82, 'Africa/Nairobi'),
    ('johannesburg', 'Johannesburg', 'South Africa', -26.20, 28.05, 'Africa/Johannesburg'),
    ('london', 'London', 'United Kingdom', 51.51, -0.13, 'Europe/London'),
    ('manchester', 'Manchester', 'United Kingdom', 53.48, -2.24, 'Europe/London'),
    ('dublin', 'Dublin', 'Ireland', 53.35, -6.26, 'Europe/Dublin'),
    ('paris', 'Paris', 'France', 48.86, 2.35, 'Europe/Paris'),
    ('berlin', 'Berlin', 'Germany', 52.52, 13.40, 'Europe/Berlin'),
    ('madrid', 'Madrid', 'Spain', 40.42, -3.70, 'Europe/Madrid'),
    ('rome', 'Rome', 'Italy', 41.90, 12.50, 'Europe/Rome'),
    ('amsterdam', 'Amsterdam', 'Netherlands', 52.37, 4.90, 'Europe/Amsterdam'),
    ('moscow', 'Moscow', 'Russia', 55.76, 37.62, 'Europe/Moscow'),
    ('new-york', 'New York', 'United States', 40.71, -74.01, 'America/New_York'),
    ('los-angeles', 'Los Angeles', 'United States', 34.05, -118.24, 'America/Los_Angeles'),
    ('chicago', 'Chicago', 'United States', 41.88, -87.63, 'America/Chicago'),
    ('houston', 'Houston', 'United States', 29.76, -95.37, 'America/Chicago'),
    ('phoenix', 'Phoenix', 'United States', 33.45, -112.07, 'America/Phoenix'),
    ('san-francisco', 'San Francisco', 'United States', 37.77, -122.42, 'America/Los_Angeles'),
    ('seattle', 'Seattle', 'United States', 47.61, -122.33, 'America/Los_Angeles'),
    ('miami', 'Miami', 'United States', 25.76, -80.19, 'America/New_York'),
    ('toronto', 'Toronto', 'Canada', 43.65, -79.38, 'America/Toronto'),
    ('vancouver', 'Vancouver', 'Canada', 49.28, -123.12, 'America/Vancouver'),
    ('mexico-city', 'Mexico City', 'Mexico', 19.43, -99.13, 'America/Mexico_City'),
    ('sao-paulo', 'São Paulo', 'Brazil', -23.55, -46.63, 'America/Sao_Paulo'),
    ('buenos-aires', 'Buenos Aires', 'Argentina', -34.60, -58.38, 'America/Argentina/Buenos_Aires'),
    ('sydney', 'Sydney', 'Australia', -33.87, 151.21, 'Australia/Sydney'),
    ('melbourne', 'Melbourne', 'Australia', -37.81, 144.96, 'Australia/Melbourne'),
    ('auckland', 'Auckland', 'New Zealand', -36.85, 174.76, 'Pacific/Auckland'),
    ('singapore', 'Singapore', 'Singapore', 1.35, 103.82, 'Asia/Singapore'),
    ('jakarta', 'Jakarta', 'Indonesia', -6.21, 106.85, 'Asia/Jakarta'),
    ('manila', 'Manila', 'Philippines', 14.60, 120.98, 'Asia/Manila'),
    ('tokyo', 'Tokyo', 'Japan', 35.68, 139.69, 'Asia/Tokyo'),
    ('seoul', 'Seoul', 'South Korea', 37.57, 126.98, 'Asia/Seoul'),
]

PLANETS = [('mercury', 'Mercury', -0.4), ('venus', 'Venus', -4.2), ('mars', 'Mars', 0.6), ('jupiter', 'Jupiter', -2.3), ('saturn', 'Saturn', 0.7),
           ('uranus', 'Uranus', 5.7), ('neptune', 'Neptune', 7.8)]
EYE = {'mercury', 'venus', 'mars', 'jupiter', 'saturn'}
OBL = math.radians(23.4393)
rad, deg = math.radians, math.degrees


def n360(x):
    return x % 360.0


def jd(t):
    return t.timestamp() / 86400.0 + 2440587.5


def helio(orbits, pid, t):
    el, T = orbits[pid], (jd(t) - 2451545) / 36525
    a, e, inc = el[0] + el[1] * T, el[2] + el[3] * T, rad(el[4] + el[5] * T)
    l, peri, node = el[6] + el[7] * T, el[8] + el[9] * T, rad(el[10] + el[11] * T)
    omega = rad(peri) - node
    m = n360(l - peri)
    if m > 180:
        m -= 360
    m = rad(m)
    E = m + e * math.sin(m)
    for _ in range(10):
        d = (E - e * math.sin(E) - m) / (1 - e * math.cos(E))
        E -= d
        if abs(d) < 1e-10:
            break
    xp, yp = a * (math.cos(E) - e), a * math.sqrt(1 - e * e) * math.sin(E)
    cw, sw, cn, sn, ci, si = math.cos(omega), math.sin(omega), math.cos(node), math.sin(node), math.cos(inc), math.sin(inc)
    return ((cw * cn - sw * sn * ci) * xp + (-sw * cn - cw * sn * ci) * yp,
            (cw * sn + sw * cn * ci) * xp + (-sw * sn + cw * cn * ci) * yp,
            (sw * si) * xp + (cw * si) * yp)


def moon_ecl(t):
    d = jd(t) - 2451543.5
    n, inc, w, a, e, m = n360(125.1228 - 0.0529538083 * d), 5.1454, n360(318.0634 + 0.1643573223 * d), 60.2666, 0.0549, n360(115.3654 + 13.0649929509 * d)
    mr = rad(m)
    ecc = mr + e * math.sin(mr) * (1 + e * math.cos(mr))
    for _ in range(8):
        ecc -= (ecc - e * math.sin(ecc) - mr) / (1 - e * math.cos(ecc))
    xv, yv = a * (math.cos(ecc) - e), a * math.sqrt(1 - e * e) * math.sin(ecc)
    v, r = deg(math.atan2(yv, xv)), math.hypot(xv, yv)
    nr, vw, ir = rad(n), rad(v + w), rad(inc)
    xh = r * (math.cos(nr) * math.cos(vw) - math.sin(nr) * math.sin(vw) * math.cos(ir))
    yh = r * (math.sin(nr) * math.cos(vw) + math.cos(nr) * math.sin(vw) * math.cos(ir))
    zh = r * (math.sin(vw) * math.sin(ir))
    lon, lat = deg(math.atan2(yh, xh)), deg(math.atan2(zh, math.hypot(xh, yh)))
    ms_ = rad(356.047 + 0.9856002585 * d)
    ls = deg(ms_) + 282.9404 + 4.70935e-5 * d
    lm = m + w + n
    dd, f, mm = rad(lm - ls), rad(lm - n), mr
    lon += (-1.274 * math.sin(mm - 2 * dd) + 0.658 * math.sin(2 * dd) - 0.186 * math.sin(ms_) - 0.059 * math.sin(2 * mm - 2 * dd)
            - 0.057 * math.sin(mm - 2 * dd + ms_) + 0.053 * math.sin(mm + 2 * dd) + 0.046 * math.sin(2 * dd - ms_) + 0.041 * math.sin(mm - ms_)
            - 0.035 * math.sin(dd) - 0.031 * math.sin(mm + ms_) - 0.015 * math.sin(2 * f - 2 * dd) + 0.011 * math.sin(mm - 4 * dd))
    lat += -0.173 * math.sin(f - 2 * dd) - 0.055 * math.sin(mm - f - 2 * dd) - 0.046 * math.sin(mm + f - 2 * dd) + 0.033 * math.sin(f + 2 * dd) + 0.017 * math.sin(2 * mm + f)
    return n360(lon), lat


def ecl_to_eq(x, y, z):
    ye, ze = y * math.cos(OBL) - z * math.sin(OBL), y * math.sin(OBL) + z * math.cos(OBL)
    return math.atan2(ye, x), math.atan2(ze, math.hypot(x, ye))  # ra, dec in radians


def alt_az(ra, dec, t, lat, lon):
    gmst = n360(280.46061837 + 360.98564736629 * (jd(t) - 2451545))
    ha = rad(gmst + lon) - ra
    la = rad(lat)
    alt = math.asin(math.sin(la) * math.sin(dec) + math.cos(la) * math.cos(dec) * math.cos(ha))
    az = math.atan2(-math.cos(dec) * math.sin(ha), math.sin(dec) * math.cos(la) - math.cos(dec) * math.sin(la) * math.cos(ha))
    return deg(alt), n360(deg(az))


class Sky:
    def __init__(self, orbits, lat, lon):
        self.o, self.lat, self.lon = orbits, lat, lon

    def sun(self, t):
        ex, ey, ez = helio(self.o, 'earth', t)
        return alt_az(*ecl_to_eq(-ex, -ey, -ez), t, self.lat, self.lon)

    def moon(self, t):
        lo, la = moon_ecl(t)
        lo, la = rad(lo), rad(la)
        return alt_az(*ecl_to_eq(math.cos(la) * math.cos(lo), math.cos(la) * math.sin(lo), math.sin(la)), t, self.lat, self.lon)

    def planet(self, pid, t):
        ex, ey, ez = helio(self.o, 'earth', t)
        px, py, pz = helio(self.o, pid, t)
        return alt_az(*ecl_to_eq(px - ex, py - ey, pz - ez), t, self.lat, self.lon)


def crossings(f, start, end, horizon, step=2):
    """Times when f(t)[0] crosses the horizon between start and end: [(time, 'rise'|'set')]."""
    out, t = [], start
    prev = f(t)[0] - horizon
    while t < end:
        t2 = t + dt.timedelta(minutes=step)
        cur = f(t2)[0] - horizon
        if (prev < 0) != (cur < 0):
            frac = prev / (prev - cur)
            out.append((t + (t2 - t) * frac, 'rise' if cur > 0 else 'set'))
        t, prev = t2, cur
    return out


COMPASS = ['north', 'north-northeast', 'northeast', 'east-northeast', 'east', 'east-southeast', 'southeast', 'south-southeast',
           'south', 'south-southwest', 'southwest', 'west-southwest', 'west', 'west-northwest', 'northwest', 'north-northwest']


def compass(az):
    return COMPASS[int((az + 11.25) // 22.5) % 16]


def moon_phase(orbits, t):
    ex, ey, _ = helio(orbits, 'earth', t)
    sun_lon = n360(deg(math.atan2(-ey, -ex)))
    elong = n360(moon_ecl(t)[0] - sun_lon)
    lit = (1 - math.cos(rad(elong))) / 2
    if elong < 6 or elong > 354:
        name = 'New Moon'
    elif elong < 84:
        name = 'Waxing crescent'
    elif elong < 96:
        name = 'First quarter'
    elif elong < 174:
        name = 'Waxing gibbous'
    elif elong < 186:
        name = 'Full Moon'
    elif elong < 264:
        name = 'Waning gibbous'
    elif elong < 276:
        name = 'Last quarter'
    else:
        name = 'Waning crescent'
    return name, lit, elong


MOON_ICON = {'New Moon': '🌑', 'Waxing crescent': '🌒', 'First quarter': '🌓', 'Waxing gibbous': '🌔', 'Full Moon': '🌕', 'Waning gibbous': '🌖', 'Last quarter': '🌗', 'Waning crescent': '🌘'}


def night(orbits, city, now):
    """Everything for the night that starts on the city's local date (4 hours after midnight still counts as last night)."""
    slug, name, country, lat, lon, tzname = city
    tz = ZoneInfo(tzname)
    local = now.astimezone(tz) - dt.timedelta(hours=4)
    day = local.date()
    noon = dt.datetime(day.year, day.month, day.day, 12, tzinfo=tz)
    sky = Sky(orbits, lat, lon)
    span_end = noon + dt.timedelta(hours=24)
    sun_x = crossings(sky.sun, noon, span_end, -0.833)
    sunset = next((t for t, k in sun_x if k == 'set'), None)
    sunrise = next((t for t, k in sun_x if k == 'rise' and (sunset is None or t > sunset)), None)
    dark_x = crossings(sky.sun, noon, span_end, -12)
    dark_start = next((t for t, k in dark_x if k == 'set'), None)
    dark_end = next((t for t, k in dark_x if k == 'rise' and (dark_start is None or t > dark_start)), None)
    # the part of the night we look at: from 30 min after sunset to 30 min before sunrise
    a = (sunset or noon + dt.timedelta(hours=6)) + dt.timedelta(minutes=30)
    b = (sunrise or span_end - dt.timedelta(hours=6)) - dt.timedelta(minutes=30)
    moon_x = crossings(sky.moon, noon, span_end, 0.125)
    phase, lit, elong = moon_phase(orbits, a)
    planets = []
    for pid, pname, mag in PLANETS:
        best, first, last, t = None, None, None, a
        while t <= b:
            alt, az = sky.planet(pid, t)
            if alt > 8:
                first = first or t
                last = t
                if best is None or alt > best[1]:
                    best = (t, alt, az)
            t += dt.timedelta(minutes=10)
        if best:
            planets.append({'id': pid, 'name': pname, 'eye': pid in EYE, 'mag': mag, 'from': first, 'to': last, 'best': best[0], 'alt': best[1], 'dir': compass(best[2]),
                            'first_dir': compass(sky.planet(pid, first)[1]), 'evening': first <= a + dt.timedelta(minutes=10), 'morning': last >= b - dt.timedelta(minutes=10)})
    return {'city': city, 'tz': tz, 'day': day, 'sunset': sunset, 'sunrise': sunrise, 'dark_start': dark_start, 'dark_end': dark_end,
            'moonrise': next((t for t, k in moon_x if k == 'rise'), None), 'moonset': next((t for t, k in moon_x if k == 'set'), None),
            'phase': phase, 'lit': lit, 'waxing': elong < 180, 'planets': planets}


def hm(t, tz):
    return t.astimezone(tz).strftime('%-I:%M %p').replace('AM', 'am').replace('PM', 'pm') if t else '—'


def planet_line(p, tz):
    when = ('all night' if p['evening'] and p['morning'] else
            f'from dusk until about {hm(p["to"], tz)}' if p['evening'] else
            f'from about {hm(p["from"], tz)} until dawn' if p['morning'] else
            f'from about {hm(p["from"], tz)} to {hm(p["to"], tz)}')
    look = f'look {p["dir"]}, about {round(p["alt"])}° up, around {hm(p["best"], tz)}'
    how = 'needs binoculars or a telescope' if not p['eye'] else 'low near the horizon, so you need a clear view that way' if p['alt'] < 15 else 'easy to see with your eyes' if p['mag'] < 0 else 'visible to the eye'
    return when, look, how


def next_events(day):
    today = day.isoformat()
    ecl = next((e for e in skyevents.ECLIPSES if e[1] >= today), None)
    sh = None
    for y in (day.year, day.year + 1):
        for s in skyevents.SHOWERS:
            d = dt.date(y, s[3][0], s[3][1])
            if d >= day and (sh is None or d < sh[1]):
                sh = (s, d)
    return ecl, sh


def page_body(n, esc):
    slug, name, country, lat, lon, tzname = n['city']
    tz, day = n['tz'], n['day']
    date_txt = day.strftime('%A %-d %B %Y')
    eye = [p for p in n['planets'] if p['eye']]
    other = [p for p in n['planets'] if not p['eye']]
    names = [p['name'] for p in eye]
    summary = ('No bright planets are up tonight' if not names else
               f'{names[0]} is up tonight' if len(names) == 1 else
               ', '.join(names[:-1]) + f' and {names[-1]} are up tonight')
    moon_txt = f'{MOON_ICON[n["phase"]]} {n["phase"]}, {round(n["lit"] * 100)}% lit'
    h = (f'<section class="blk tnhead"><p class="note"><a href="../tonight.html">← Night sky tonight</a> · Updated {day.strftime("%-d %B %Y")}</p>'
         f'<h1>Night sky tonight in {esc(name)}</h1><p class="sub">{date_txt}. {summary}. The Moon is a {n["phase"].lower()} ({round(n["lit"] * 100)}% lit).</p>'
         '<div class="stats">'
         f'<div class="stat"><b>{hm(n["sunset"], tz)}</b><span>🌇 Sunset</span></div>'
         f'<div class="stat"><b>{hm(n["dark_start"], tz)}</b><span>🌌 Properly dark</span></div>'
         f'<div class="stat"><b>{hm(n["sunrise"], tz)}</b><span>🌅 Sunrise tomorrow</span></div>'
         f'<div class="stat"><b>{moon_txt}</b><span>Moon</span></div></div></section>')
    h += '<section class="blk"><h2>🪐 Planets you can see tonight</h2>'
    if eye:
        h += '<div class="tnplanets">'
        for p in eye:
            when, look, how = planet_line(p, tz)
            h += f'<div class="card tnp"><img src="../img/planets/{p["id"]}-s.webp" alt="" width="56" height="56" loading="lazy"><div><h3>{p["name"]}</h3><p><b>When:</b> {when}.</p><p><b>Where:</b> {look}.</p><p class="note">{how.capitalize()}.</p></div></div>'
        h += '</div>'
    else:
        h += '<p>None of the five bright planets is well placed tonight. They are too close to the Sun, below the horizon, or too low to see.</p>'
    if other:
        h += '<p class="note">With binoculars or a small telescope you can also find ' + ' and '.join(p['name'] for p in other) + '.</p>'
    h += '</section>'
    h += (f'<section class="blk"><h2>🌙 The Moon tonight</h2><p>The Moon is a <b>{n["phase"].lower()}</b>, {round(n["lit"] * 100)}% lit, and {"growing" if n["waxing"] else "shrinking"} each night. '
          f'Moonrise: <b>{hm(n["moonrise"], tz)}</b>. Moonset: <b>{hm(n["moonset"], tz)}</b>.'
          + (' A bright Moon washes out faint stars and meteors.' if n['lit'] > 0.6 else ' With little moonlight, it is a good night for faint stars, if your sky is dark.' if n['lit'] < 0.25 else '')
          + ' <a href="../sky.html">See the Moon calendar →</a></p></section>')
    ecl, sh = next_events(day)
    h += '<section class="blk"><h2>📅 Coming up</h2><div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(240px,1fr))">'
    if sh:
        s, d = sh
        h += f'<a class="card tnev" href="../sky-events/{skyevents.slug_shower(s[0])}.html"><small>☄️ Next meteor shower</small><b>{s[1]}</b><span>Peak on {d.strftime("%-d %B %Y")}, up to about {s[4]} meteors an hour from a dark place.</span></a>'
    if ecl:
        kind = f'{ecl[4].capitalize()} {"lunar" if ecl[3] else "solar"} eclipse'
        h += f'<a class="card tnev" href="../sky-events/{ecl[0]}.html"><small>🌑 Next eclipse</small><b>{kind}</b><span>{dt.date.fromisoformat(ecl[1]).strftime("%-d %B %Y")}. See where it can be seen and the times for your city.</span></a>'
    h += '<a class="card tnev" href="../iss.html"><small>🛰️ Space station</small><b>When the ISS flies over</b><span>The visible passes over your city for the next 10 days.</span></a></div></section>'
    h += ('<section class="blk"><h2>How to see the planets</h2><ul><li>Planets do not twinkle like stars: look for a steady, bright point.</li>'
          '<li>Venus and Jupiter are the brightest things in the night sky after the Moon. Mars looks orange, Saturn pale yellow.</li>'
          '<li>Find a place with a clear view of the horizon in the direction given, away from bright lights. Give your eyes 10 minutes to get used to the dark.</li>'
          '<li>Binoculars show Jupiter’s four big moons as tiny dots in a line. A small telescope shows Saturn’s rings.</li></ul>'
          f'<p class="note">Times are for central {esc(name)} ({tzname.replace("_", " ")} time) and can differ by a few minutes across the city. Planets are listed when they are at least 8° above the horizon after dusk. '
          '<a href="../sky.html">Open the live sky for your exact place →</a></p></section>')
    others = [c for c in CITIES if c[2] == country and c[0] != slug][:6] or [c for c in CITIES if c[0] != slug][:6]
    h += '<section class="blk"><h2>Other cities</h2><div class="chips">' + ''.join(f'<a class="chip" href="{c[0]}.html">{esc(c[1])}</a>' for c in others) + '<a class="chip" href="../tonight.html">All cities →</a></div></section>'
    faq = [(f'What planets can I see tonight in {name}?',
            (summary + '. ' + ' '.join(f'{p["name"]}: {planet_line(p, tz)[0]}; {planet_line(p, tz)[1]}.' for p in eye)) if eye else 'None of the five bright planets is well placed tonight.'),
           (f'What time is sunset in {name} today?', f'Sunset in {name} on {day.strftime("%-d %B %Y")} is at {hm(n["sunset"], tz)}, and it is properly dark from about {hm(n["dark_start"], tz)}. Sunrise tomorrow is at {hm(n["sunrise"], tz)}.'),
           (f'What is the Moon phase tonight in {name}?', f'The Moon is a {n["phase"].lower()}, {round(n["lit"] * 100)}% lit. It rises at {hm(n["moonrise"], tz)} and sets at {hm(n["moonset"], tz)}.')]
    return h, summary, faq


def build(h):
    shell, write, esc, SITE = h['shell'], h['write'], h['esc'], h['SITE']
    orbits = h['orbits']
    now = dt.datetime.now(dt.timezone.utc)
    urls, rows = ['tonight.html'], []
    for c in CITIES:
        n = night(orbits, c, now)
        body, summary, faq = page_body(n, esc)
        path = f'tonight/{c[0]}.html'
        ld = [{'@context': 'https://schema.org', '@type': 'FAQPage', 'mainEntity': [{'@type': 'Question', 'name': q, 'acceptedAnswer': {'@type': 'Answer', 'text': a}} for q, a in faq]},
              {'@context': 'https://schema.org', '@type': 'BreadcrumbList', 'itemListElement': [
                  {'@type': 'ListItem', 'position': 1, 'name': 'Astryl', 'item': SITE + '/'},
                  {'@type': 'ListItem', 'position': 2, 'name': 'Night sky tonight', 'item': SITE + '/tonight.html'},
                  {'@type': 'ListItem', 'position': 3, 'name': c[1], 'item': f'{SITE}/{path}'}]}]
        desc = f'Night sky tonight in {c[1]}, {n["day"].strftime("%-d %B %Y")}: {summary.lower() if summary.startswith("No") else summary}. Sunset {hm(n["sunset"], n["tz"])}, Moon {n["phase"].lower()} {round(n["lit"] * 100)}% lit.'
        write(path, shell(f'Night sky tonight in {c[1]}: planets, Moon and sunset', '', 'sky', body, desc, depth=1, canonical=path, ld=ld))
        urls.append(path)
        rows.append((c, n, summary))
    # the hub
    by = {}
    for c, n, s in rows:
        by.setdefault(c[2], []).append((c, n, s))
    hub = ('<section class="blk"><h1>🔭 Night sky tonight</h1><p class="sub">Which planets you can see tonight, where to look, the Moon and sunset, for your city. Updated twice a day.</p>'
           '<p><a class="btn primary" href="sky.html">📍 Use my exact place</a></p></section><section class="blk"><div class="tncities">')
    for country in sorted(by, key=lambda k: (k not in ('India', 'United States', 'United Kingdom'), k)):
        hub += f'<div class="card"><h2>{esc(country)}</h2><ul>' + ''.join(
            f'<li><a href="tonight/{c[0]}.html"><b>{esc(c[1])}</b></a><small>{esc(s)} · sunset {hm(n["sunset"], n["tz"])}</small></li>' for c, n, s in by[country]) + '</ul></div>'
    hub += '</div></section>'
    write('tonight.html', shell('Night sky tonight: planets, Moon and sunset for your city', '', 'sky', hub,
                                'What planets can I see tonight? Planets, Moon phase, moonrise and sunset tonight for 50 cities around the world, updated twice a day.', canonical='tonight.html'))
    return urls
