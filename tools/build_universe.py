#!/usr/bin/env python3
"""Builds lib/data/universe_catalog.dart, the data of the app's Universe map.

Usage:
    git clone --depth 1 https://github.com/mattiaverga/OpenNGC
    python3 tools/build_universe.py OpenNGC/database_files

Galaxies come from OpenNGC (CC BY-SA 4.0, Mattia Verga and contributors):
real positions, sizes, types and radial velocities. A galaxy's distance is

  1. a measured distance from the table NEAR below, when it has one,
  2. else the Virgo Cluster's distance when it sits in that cluster (there the
     velocity says more about the cluster's own motion than about distance),
  3. else an estimate from its redshift (flat Lambda-CDM, H0 = 67.7, Om = 0.31).

Stars, black holes and clusters are short hand-made lists with published
values. Far objects are placed at their comoving distance (where they are
"now") and also carry the time their light has travelled.
"""
import csv
import math
import os
import sys

H0 = 67.7
OM = 0.31
C = 299792.458
MPC_MLY = 3.2615638
HUBBLE_GYR = 977.8 / H0  # 1/H0 in billions of years
GALAXIES = 3600


def cosmo(z):
    """(comoving distance in Mly, light travel time in million years)."""
    if z <= 0:
        return 0.0, 0.0
    n = 2000
    dc = 0.0
    tl = 0.0
    for i in range(n):
        zz = (i + 0.5) * z / n
        e = math.sqrt(OM * (1 + zz) ** 3 + 1 - OM)
        dc += 1 / e
        tl += 1 / ((1 + zz) * e)
    dc *= z / n * C / H0 * MPC_MLY
    tl *= z / n * HUBBLE_GYR * 1000
    return dc, tl


def hms(s):
    p = [float(x) for x in s.split(':')]
    return (p[0] + p[1] / 60 + p[2] / 3600) * 15


def dms(s):
    sign = -1 if s.strip().startswith('-') else 1
    p = [float(x) for x in s.replace('+', '').replace('-', '').split(':')]
    return sign * (p[0] + p[1] / 60 + (p[2] if len(p) > 2 else 0) / 3600)


def sep(ra1, de1, ra2, de2):
    a1, d1, a2, d2 = map(math.radians, (ra1, de1, ra2, de2))
    c = math.sin(d1) * math.sin(d2) + math.cos(d1) * math.cos(d2) * math.cos(a1 - a2)
    return math.degrees(math.acos(max(-1, min(1, c))))


# Measured distances in million light-years (Cepheids, tip of the red giant
# branch, surface brightness fluctuations), rounded. Local Group and nearby
# groups, where the redshift cannot give the distance.
NEAR = {
    'ESO056-115': 0.163, 'NGC0292': 0.2, 'NGC0224': 2.5, 'NGC0221': 2.5,
    'NGC0205': 2.7, 'NGC0598': 2.7, 'NGC0147': 2.5, 'NGC0185': 2.0,
    'NGC6822': 1.6, 'IC1613': 2.4, 'IC0010': 2.3, 'NGC3109': 4.3,
    'NGC0055': 6.5, 'NGC0300': 6.1, 'NGC0253': 11.4, 'NGC0247': 11.1,
    'NGC7793': 12.7, 'NGC3031': 11.8, 'NGC3034': 11.7, 'NGC2403': 10.4,
    'NGC3077': 12.5, 'NGC2366': 10.6, 'NGC1569': 10.9, 'IC0342': 10.7,
    'NGC5128': 12.4, 'NGC4945': 12.3, 'NGC5236': 15.0, 'NGC5253': 11.4,
    'NGC1313': 13.7, 'NGC4449': 12.5, 'NGC4214': 9.6, 'NGC4736': 16.0,
    'NGC4826': 17.0, 'NGC5457': 21.0, 'NGC5194': 28.0, 'NGC5195': 28.0,
    'NGC6946': 25.0, 'NGC4258': 24.0, 'NGC4594': 31.0, 'NGC2903': 30.0,
    'NGC3368': 35.0, 'NGC3351': 33.0, 'NGC3379': 35.0, 'NGC3623': 35.0,
    'NGC3627': 35.0, 'NGC3628': 35.0, 'NGC0628': 32.0, 'NGC5055': 29.0,
    'NGC1068': 47.0, 'NGC4486': 53.5, 'NGC4472': 55.0, 'NGC4649': 55.0,
    'NGC4374': 55.0, 'NGC4406': 55.0, 'NGC4321': 55.0, 'NGC4501': 55.0,
    'NGC3115': 32.0, 'NGC1316': 62.0, 'NGC1365': 56.0, 'NGC1399': 66.0,
    'NGC4697': 38.0, 'NGC1023': 36.0,
}

VIRGO = (187.706, 12.391, 54.0)  # RA, Dec of M87; distance in Mly

# name, RA, Dec, distance (ly), kind (0 star, 1 nebula, 2 star cluster),
# colour (0 blue-white, 1 white, 2 yellow, 3 orange, 4 red)
STARS = [
    ('Proxima Centauri', '14:29:42.9', '-62:40:46', 4.24, 0, 4),
    ('Alpha Centauri', '14:39:36.5', '-60:50:02', 4.37, 0, 2),
    ("Barnard's Star", '17:57:48.5', '+04:41:36', 5.96, 0, 4),
    ('Wolf 359', '10:56:28.9', '+07:00:53', 7.86, 0, 4),
    ('Lalande 21185', '11:03:20.2', '+35:58:12', 8.3, 0, 4),
    ('Sirius', '06:45:08.9', '-16:42:58', 8.6, 0, 1),
    ('Ross 154', '18:49:49.4', '-23:50:10', 9.7, 0, 4),
    ('Epsilon Eridani', '03:32:55.8', '-09:27:30', 10.5, 0, 3),
    ('Procyon', '07:39:18.1', '+05:13:30', 11.5, 0, 1),
    ('61 Cygni', '21:06:53.9', '+38:44:58', 11.4, 0, 3),
    ('Tau Ceti', '01:44:04.1', '-15:56:15', 11.9, 0, 2),
    ('Altair', '19:50:47.0', '+08:52:06', 16.7, 0, 1),
    ('Vega', '18:36:56.3', '+38:47:01', 25.0, 0, 0),
    ('Fomalhaut', '22:57:39.0', '-29:37:20', 25.1, 0, 1),
    ('Pollux', '07:45:18.9', '+28:01:34', 33.8, 0, 3),
    ('Arcturus', '14:15:39.7', '+19:10:57', 36.7, 0, 3),
    ('TRAPPIST-1', '23:06:29.4', '-05:02:29', 40.7, 0, 4),
    ('Capella', '05:16:41.4', '+45:59:53', 42.9, 0, 2),
    ('Castor', '07:34:35.9', '+31:53:18', 51.0, 0, 1),
    ('Aldebaran', '04:35:55.2', '+16:30:33', 65.0, 0, 3),
    ('Regulus', '10:08:22.3', '+11:58:02', 79.0, 0, 0),
    ('Achernar', '01:37:42.8', '-57:14:12', 139.0, 0, 0),
    ('Spica', '13:25:11.6', '-11:09:41', 250.0, 0, 0),
    ('Canopus', '06:23:57.1', '-52:41:44', 310.0, 0, 1),
    ('Polaris', '02:31:49.1', '+89:15:51', 433.0, 0, 2),
    ('Pleiades', '03:47:00.0', '+24:07:00', 444.0, 2, 0),
    ('Antares', '16:29:24.5', '-26:25:55', 550.0, 0, 4),
    ('Betelgeuse', '05:55:10.3', '+07:24:25', 550.0, 0, 4),
    ('Rigel', '05:14:32.3', '-08:12:06', 860.0, 0, 0),
    ('Orion Nebula', '05:35:17.3', '-05:23:28', 1344.0, 1, 4),
    ('Deneb', '20:41:25.9', '+45:16:49', 2600.0, 0, 1),
    ('Crab Nebula', '05:34:31.9', '+22:00:52', 6500.0, 1, 3),
    ('Eta Carinae', '10:45:03.6', '-59:41:04', 7500.0, 0, 3),
    ('Omega Centauri', '13:26:47.2', '-47:28:46', 17000.0, 2, 2),
]

# Black holes in and around the Milky Way:
# name, RA, Dec, distance (ly), mass (Suns)
HOLES_NEAR = [
    ('Sagittarius A*', '17:45:40.04', '-29:00:28.1', 26700, 4.3e6),
    ('Gaia BH1', '17:28:41.09', '-00:34:51.9', 1560, 9.6),
    ('Gaia BH3', '19:39:18.72', '+14:55:54.0', 1926, 33),
    ('A0620-00', '06:22:44.50', '-00:20:44.7', 3300, 6.6),
    ('Gaia BH2', '13:50:16.73', '-59:14:20.4', 3800, 8.9),
    ('XTE J1118+480', '11:18:10.80', '+48:02:12.6', 5600, 7.5),
    ('Cygnus X-1', '19:58:21.68', '+35:12:05.8', 7200, 21),
    ('V404 Cygni', '20:24:03.82', '+33:52:02.0', 7800, 9),
    ('MAXI J1820+070', '18:20:21.94', '+07:11:07.2', 9700, 8.5),
    ('GRO J1655-40', '16:54:00.14', '-39:50:44.9', 10400, 5.4),
    ('XTE J1550-564', '15:50:58.70', '-56:28:35.2', 14400, 9.1),
    ('Nova Muscae 1991', '11:26:26.60', '-68:40:32.0', 16000, 11),
    ('Omega Centauri black hole', '13:26:47.24', '-47:28:46.5', 17000, 8200),
    ('V4641 Sagittarii', '18:19:21.63', '-25:24:25.8', 20000, 6.4),
    ('4U 1543-47', '15:47:08.30', '-47:40:10.0', 24000, 9.4),
    ('GRS 1915+105', '19:15:11.55', '+10:56:44.8', 28000, 12),
    ('LMC X-1', '05:39:38.80', '-69:44:36.0', 160000, 10.9),
    ('LMC X-3', '05:38:56.60', '-64:05:03.0', 160000, 7),
    ('VFTS 243', '05:38:08.40', '-69:09:19.0', 160000, 9),
    ('M33 X-7', '01:33:34.13', '+30:32:11.3', 2700000, 15.7),
]

# Giant black holes in catalogue galaxies: name, host, mass (Suns)
HOLES_HOST = [
    ('M87*', 'NGC4486', 6.5e9),
    ('Andromeda black hole (M31*)', 'NGC0224', 1.4e8),
    ('M32 black hole', 'NGC0221', 2.5e6),
    ('M81*', 'NGC3031', 7e7),
    ('Sombrero black hole', 'NGC4594', 6.6e8),
    ('M106 black hole', 'NGC4258', 4e7),
    ('Centaurus A black hole', 'NGC5128', 5.5e7),
    ('NGC 4889 black hole', 'NGC4889', 2.1e10),
    ('NGC 1600 black hole', 'NGC1600', 1.7e10),
    ('NGC 3842 black hole', 'NGC3842', 9.7e9),
    ('M60 black hole', 'NGC4649', 4.5e9),
    ('M49 black hole', 'NGC4472', 2.5e9),
    ('M84 black hole', 'NGC4374', 9e8),
    ('NGC 3115 black hole', 'NGC3115', 9e8),
    ('NGC 1399 black hole', 'NGC1399', 9e8),
    ('NGC 1332 black hole', 'NGC1332', 6.6e8),
    ('M105 black hole', 'NGC3379', 4e8),
    ('NGC 4697 black hole', 'NGC4697', 2e8),
    ('NGC 1023 black hole', 'NGC1023', 4e7),
    ('NGC 4945 black hole', 'NGC4945', 1.4e6),
    ('M77 black hole', 'NGC1068', 8e6),
    ('M96 black hole', 'NGC3368', 8e6),
    ('NGC 1407 black hole', 'NGC1407', 4.5e9),
    ('NGC 4526 black hole', 'NGC4526', 4.5e8),
    ('NGC 4459 black hole', 'NGC4459', 7e7),
    ('NGC 4473 black hole', 'NGC4473', 9e7),
    ('NGC 821 black hole', 'NGC0821', 1.7e8),
    ('IC 1101 black hole', 'IC1101', 4e10),
]

# Far giants and quasars: name, RA, Dec, redshift, mass (Suns)
HOLES_FAR = [
    ('Cygnus A', '19:59:28.36', '+40:44:02.1', 0.0561, 2.5e9),
    ('Holmberg 15A black hole', '00:41:50.50', '-09:18:11.0', 0.055, 4.0e10),
    ('3C 273', '12:29:06.70', '+02:03:08.6', 0.158, 8.9e8),
    ('Abell 1201 black hole', '11:12:54.50', '+13:26:09.0', 0.169, 3.3e10),
    ('OJ 287', '08:54:48.87', '+20:06:30.6', 0.306, 1.8e10),
    ('TON 618', '12:28:24.97', '+31:28:37.7', 2.219, 4.1e10),
    ('S5 0014+81', '00:17:08.48', '+81:35:08.1', 3.366, 4.0e10),
    ('APM 08279+5255', '08:31:41.70', '+52:45:17.5', 3.911, 1.0e10),
    ('J0529-4351', '05:29:15.80', '-43:51:52.0', 3.962, 1.7e10),
    ('SDSS J0100+2802', '01:00:13.02', '+28:02:25.8', 6.327, 1.2e10),
    ('ULAS J1120+0641', '11:20:01.48', '+06:41:24.3', 7.085, 2.0e9),
    ('ULAS J1342+0928', '13:42:08.10', '+09:28:38.6', 7.54, 8.0e8),
    ('J0313-1806', '03:13:43.84', '-18:06:36.4', 7.642, 1.6e9),
    ('GN-z11 black hole', '12:36:25.46', '+62:14:31.4', 10.6, 1.6e6),
]

# Galaxy clusters and far galaxies: name, RA (deg), Dec (deg), distance (Mly)
# or redshift, kind (0 cluster, 1 far galaxy)
MARKS = [
    ('Virgo Cluster', 187.7, 12.4, 54, None, 0),
    ('Fornax Cluster', 54.6, -35.4, 62, None, 0),
    ('Centaurus Cluster', 192.2, -41.3, 170, None, 0),
    ('Hydra Cluster', 159.2, -27.5, 190, None, 0),
    ('Norma Cluster (Great Attractor)', 243.6, -60.9, 220, None, 0),
    ('Perseus Cluster', 49.95, 41.5, 240, None, 0),
    ('Coma Cluster', 194.95, 27.98, 320, None, 0),
    ('Leo Cluster', 176.1, 19.8, 330, None, 0),
    ('Hercules Cluster', 241.3, 17.75, 500, None, 0),
    ('Shapley Supercluster', 202.0, -31.0, 650, None, 0),
    ('JADES-GS-z14-0', hms('03:32:19.9'), dms('-27:51:20'), None, 14.18, 1),
]


def q(s):
    return "'" + s.replace('\\', '\\\\').replace("'", "\\'") + "'"


def num(v):
    return f'{v:.6g}'


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    folder = sys.argv[1]
    rows = []
    for name in ('NGC.csv', 'addendum.csv'):
        with open(os.path.join(folder, name), encoding='utf-8') as fh:
            rows += list(csv.DictReader(fh, delimiter=';'))

    need = set(NEAR) | {h[1] for h in HOLES_HOST}
    found = {}
    out = []
    for r in rows:
        if r['Type'] != 'G' or not r['RadVel'] or not r['RA']:
            continue
        name = r['Name']
        ra, dec = hms(r['RA']), dms(r['Dec'])
        v = float(r['RadVel'])
        est = 1
        if name in NEAR:
            dist, est = NEAR[name], 0
        elif sep(ra, dec, VIRGO[0], VIRGO[1]) < 8 and v < 3000:
            # A cluster member: the cluster's distance, spread a little by
            # velocity so the cluster keeps some depth.
            dist = VIRGO[2] + (v - 1150) / H0 * MPC_MLY * 0.12
        elif v > 350:
            dist = cosmo(v / C)[0]
        else:
            continue
        mags = [float(r[k]) for k in ('B-Mag', 'V-Mag') if r[k]]
        mag = min(mags) if mags else 99.0
        major = float(r['MajAx']) if r['MajAx'] else 0.0
        minor = float(r['MinAx']) if r['MinAx'] else major
        ratio = min(1.0, minor / major) if major > 0 else 1.0
        diam = major / 60 * math.pi / 180 * dist * 1000  # thousand ly
        hub = r['Hubble']
        if hub.startswith('SB'):
            kind = 'B'
        elif hub.startswith('S0'):
            kind = 'L'
        elif hub.startswith('S'):
            kind = 'S'
        elif hub.startswith('E'):
            kind = 'E'
        elif hub.startswith('I'):
            kind = 'I'
        else:
            kind = 'U'
        common = r['Common names'].split(',')[0].strip()
        if name == 'NGC4486':
            common = 'Virgo A (M87)'
        messier = r['M'].lstrip('0')
        rec = dict(name=name, ra=ra, dec=dec, dist=dist, est=est, mag=mag,
                   diam=diam, ratio=ratio, pa=float(r['PosAng'] or 0),
                   kind=kind, common=common, m=messier)
        found[name] = rec
        out.append(rec)

    missing = sorted(need - set(found))
    if missing:
        sys.exit('missing in OpenNGC: ' + ', '.join(missing))

    def keep(rec):
        return rec['name'] in need or rec['common'] or rec['m']

    forced = [x for x in out if keep(x)]
    rest = sorted((x for x in out if not keep(x)), key=lambda x: x['mag'])
    chosen = forced + rest[:max(0, GALAXIES - len(forced))]
    chosen.sort(key=lambda x: x['dist'])

    lines = []
    for x in chosen:
        lines.append('|'.join([
            x['name'], x['m'], f"{x['ra']:.3f}", f"{x['dec']:.3f}",
            num(round(x['dist'], 3 if x['dist'] < 10 else 1)),
            num(round(x['diam'], 1)), x['kind'], str(x['est']),
            f"{x['pa']:.0f}", f"{x['ratio']:.2f}", x['common'],
        ]))

    d = []
    d.append('// GENERATED by tools/build_universe.py. Do not edit by hand.')
    d.append('//')
    d.append('// Galaxy data: OpenNGC by Mattia Verga and contributors,')
    d.append('// https://github.com/mattiaverga/OpenNGC, licence CC BY-SA 4.0.')
    d.append('// Distances are added by the build script (see its notes).')
    d.append('')
    d.append("import '../core/universe.dart';")
    d.append('')
    d.append('/// One galaxy per line: name|Messier|RA|Dec|distance (million ly)|')
    d.append('/// width (thousand ly)|type|distance is an estimate|position angle|')
    d.append('/// axis ratio|common name.')
    d.append("const String galaxyRows = '''")
    d.extend(lines)
    d.append("''';")
    d.append('')
    d.append('const List<StarRow> starRows = <StarRow>[')
    for n, ra, de, dist, kind, col in STARS:
        d.append(f'  StarRow({q(n)}, {hms(ra):.3f}, {dms(de):.3f}, {num(dist)}, {kind}, {col}),')
    d.append('];')
    d.append('')
    d.append('const List<HoleRow> holeRows = <HoleRow>[')
    for n, ra, de, dist, mass in HOLES_NEAR:
        d.append(f'  HoleRow({q(n)}, {hms(ra):.4f}, {dms(de):.4f}, {num(float(dist))}, 0, {num(float(mass))}, 0),')
    for n, host, mass in HOLES_HOST:
        g = found[host]
        d.append(f'  HoleRow({q(n)}, {g["ra"]:.4f}, {g["dec"]:.4f}, {num(g["dist"] * 1e6)}, 0, {num(float(mass))}, {g["est"]}),')
    for n, ra, de, z, mass in HOLES_FAR:
        dc, tl = cosmo(z)
        d.append(f'  HoleRow({q(n)}, {hms(ra):.4f}, {dms(de):.4f}, {num(round(dc, 0) * 1e6)}, {num(round(tl, 0) * 1e6)}, {num(float(mass))}, 1),')
    d.append('];')
    d.append('')
    d.append('const List<MarkRow> markRows = <MarkRow>[')
    for n, ra, de, dist, z, kind in MARKS:
        tl = 0.0
        if z is not None:
            dist, tl = cosmo(z)
        d.append(f'  MarkRow({q(n)}, {ra:.3f}, {de:.3f}, {num(round(dist, 0) * 1e6)}, {num(round(tl, 0) * 1e6)}, {kind}),')
    d.append('];')
    d.append('')

    here = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(here, '..', 'lib', 'data', 'universe_catalog.dart')
    with open(path, 'w', encoding='utf-8') as fh:
        fh.write('\n'.join(d))
    print('galaxies', len(chosen), 'stars', len(STARS), 'holes',
          len(HOLES_NEAR) + len(HOLES_HOST) + len(HOLES_FAR),
          'bytes', os.path.getsize(path))
    for z in (0.158, 2.219, 7.642, 14.18, 1100):
        print(z, [round(v) for v in cosmo(z)])


if __name__ == '__main__':
    main()
