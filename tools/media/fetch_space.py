#!/usr/bin/env python3
"""Downloads the deep-space photos once, into data/photos/space (run on a GitHub runner).

Each picture has a list of exact Wikimedia Commons titles to try, then a Commons search as a
fallback. Only free licences are kept (public domain, CC0, CC BY, CC BY-SA), with their credit.
A report goes to data/photos/space/report.json so every choice can be checked by eye.
"""
import io, json, os, time, urllib.parse, urllib.request
from PIL import Image

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
OUT = os.path.join(ROOT, 'data', 'photos', 'space')
UA = {'User-Agent': 'AstrylBot/1.0 (https://astryl.space; github.com/aditymishr098-collab/astryl)'}
API = 'https://commons.wikimedia.org/w/api.php?'

WANT = {
    'bh-m87': (['File:Black hole - Messier 87 crop max res.jpg', 'File:Black hole - Messier 87.jpg'], 'Event Horizon Telescope M87 black hole'),
    'bh-sgra': (['File:EHT Saggitarius A black hole.tif'], 'Event Horizon Telescope Sagittarius A* black hole'),
    'bh-sgra-pol': (['File:A view of the Milky Way supermassive black hole Sagittarius A* in polarised light (eso2406a).jpg'], 'Sagittarius A* polarised light EHT'),
    'bh-m87-jet': (['File:M87 jet.jpg', 'File:Messier 87 Hubble WikiSky.jpg'], 'M87 jet Hubble'),
    'bh-cygx1': (['File:Cygnus X-1.png', 'File:Cygnus X-1 artist impression.jpg'], 'Cygnus X-1 black hole illustration'),
    'bh-sgra-multi': (['File:Multiwavelength View of Sagittarius A* (51657196986).jpg'], 'Sagittarius A* Chandra galactic center'),
    'bh-crab': (['File:Crab Nebula.jpg'], 'Crab Nebula Hubble mosaic'),
    'gx-andromeda': (['File:Andromeda Galaxy (with h-alpha).jpg', 'File:Andromeda Galaxy 560mm FL.jpg'], 'Andromeda Galaxy'),
    'gx-sombrero': (['File:M104 ngc4594 sombrero galaxy hi-res.jpg'], 'Sombrero Galaxy Hubble'),
    'gx-whirlpool': (['File:Messier51 sRGB.jpg'], 'Whirlpool Galaxy Hubble'),
    'gx-udf': (['File:Hubble ultra deep field high rez edit1.jpg', 'File:Hubble ultra deep field.jpg'], 'Hubble Ultra Deep Field'),
    'gx-webb': (["File:Webb's First Deep Field.jpg"], 'Webb First Deep Field SMACS 0723'),
    'gx-milkyway': (['File:ESO - Milky Way.jpg'], 'Milky Way panorama ESO'),
    'gx-antennae': (['File:Antennae galaxies xl.jpg', 'File:Antennae Galaxies reloaded.jpg'], 'Antennae Galaxies Hubble'),
    'gx-lmc': (['File:Large.mc.arp.750pix.jpg'], 'Large Magellanic Cloud'),
    'nb-pillars': (['File:Pillars of Creation (NIRCam Image).jpg'], 'Pillars of Creation Webb NIRCam'),
    'nb-cliffs': (["File:NASA’s Webb Reveals Cosmic Cliffs, Glittering Landscape of Star Birth.jpg"], 'Cosmic Cliffs Carina Nebula Webb'),
    'sun-sdo': (["File:The Sun by the Atmospheric Imaging Assembly of NASA's Solar Dynamics Observatory - 20100819.jpg"], 'Sun Solar Dynamics Observatory AIA'),
    'sun-eclipse': (['File:Solar eclipse 1999 4 NR.jpg', 'File:Total Solar Eclipse 8-21-17.jpg'], 'total solar eclipse corona'),
    'moon-eclipse': (['File:Lunar eclipse October 8 2014 California Alfredo Garcia Jr mideclipse.JPG'], 'total lunar eclipse blood moon'),
}
OK = ('public domain', 'pd', 'cc0', 'cc by', 'cc-by')


def get(url):
    err = None
    for attempt in range(3):
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=90) as r:
                return r.read()
        except Exception as e:  # noqa: BLE001
            err = e
            time.sleep(2 + attempt * 3)
    raise err


def info(title):
    q = API + urllib.parse.urlencode({'action': 'query', 'titles': title, 'prop': 'imageinfo',
                                      'iiprop': 'url|extmetadata|size|mime', 'iiurlwidth': 1400, 'format': 'json'})
    page = next(iter(json.loads(get(q))['query']['pages'].values()))
    if 'imageinfo' not in page:
        return None
    ii = page['imageinfo'][0]
    m = ii.get('extmetadata', {})
    v = lambda k: (m.get(k, {}).get('value') or '').strip()
    return {'title': page['title'], 'licence': v('LicenseShortName'), 'artist': v('Artist')[:300], 'credit': v('Credit')[:300],
            'desc': v('ImageDescription')[:300], 'page': ii.get('descriptionurl', ''), 'thumb': ii.get('thumburl'), 'w': ii.get('width'), 'mime': ii.get('mime')}


def search(q):
    r = json.loads(get(API + urllib.parse.urlencode({'action': 'query', 'list': 'search', 'srsearch': q, 'srnamespace': 6, 'srlimit': 8, 'format': 'json'})))
    return [x['title'] for x in r['query']['search']]


def free(i):
    lic = i['licence'].lower()
    bad = any(x in lic for x in ('-nc', ' nc', '-nd', ' nd', 'fair use', 'non-free'))
    return any(k in lic for k in OK) and not bad


def main():
    os.makedirs(OUT, exist_ok=True)
    report, credits = {}, {}
    for key, (titles, query) in WANT.items():
        tried = []
        pick = None
        try:
            cands = list(titles)
            for t in cands + ['?search']:
                if t == '?search':
                    cands = search(query)
                    for s in cands:
                        if s in titles:
                            continue
                        i = info(s)
                        time.sleep(0.5)
                        if i and free(i) and (i['w'] or 0) >= 700 and (i['mime'] or '').split('/')[-1] in ('jpeg', 'png', 'tiff', 'webp'):
                            pick = i
                            break
                        tried.append({'title': s, 'licence': i and i['licence']})
                    break
                i = info(t)
                time.sleep(0.5)
                if i and free(i):
                    pick = i
                    break
                tried.append({'title': t, 'licence': i and i['licence'], 'missing': i is None})
            if not pick:
                report[key] = {'error': 'nothing free found', 'tried': tried}
                continue
            img = Image.open(io.BytesIO(get(pick['thumb']))).convert('RGB')
            img.thumbnail((1400, 1400))
            path = os.path.join(OUT, key + '.webp')
            img.save(path, 'WEBP', quality=80, method=6)
            report[key] = {**{k: pick[k] for k in ('title', 'licence', 'artist', 'credit', 'desc', 'page')}, 'pixels': img.size, 'bytes': os.path.getsize(path), 'tried': tried}
            credits[key] = {k: pick[k] for k in ('title', 'licence', 'artist', 'credit', 'page')}
        except Exception as e:  # noqa: BLE001
            report[key] = {'error': str(e)[:300], 'tried': tried}
        time.sleep(1)
    json.dump(credits, open(os.path.join(OUT, 'credits.json'), 'w'), indent=1, ensure_ascii=False, sort_keys=True)
    json.dump(report, open(os.path.join(OUT, 'report.json'), 'w'), indent=1, ensure_ascii=False, sort_keys=True)


if __name__ == '__main__':
    main()
