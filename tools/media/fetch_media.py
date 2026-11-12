#!/usr/bin/env python3
"""Downloads the planet photos and surface maps once, into data/photos and data/textures.

Run on a GitHub runner (the build machine has no access to these sites):
  - photos: NASA pictures on Wikimedia Commons; only public-domain files are kept, with their credit
  - surface maps: Solar System Scope (CC BY 4.0), made from NASA mission data
Everything is shrunk and saved as WebP. A report goes to data/photos/report.json.
"""
import io, json, os, sys, time, urllib.parse, urllib.request
from PIL import Image

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
SRC = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'sources.json')))
UA = {'User-Agent': 'AstrylBot/1.0 (https://astryl.space; github.com/aditymishr098-collab/astryl)'}
OK_LICENCES = ('public domain', 'pd-usgov', 'pd-usgov-nasa', 'pd')


def get(url):
    for attempt in range(3):
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=60) as r:
                return r.read()
        except Exception as e:  # noqa: BLE001
            err = e
            time.sleep(2 + attempt * 3)
    raise err


def photos(report):
    out = os.path.join(ROOT, 'data', 'photos'); os.makedirs(out, exist_ok=True)
    credits = {}
    for body, title in SRC['photos'].items():
        q = 'https://commons.wikimedia.org/w/api.php?' + urllib.parse.urlencode({
            'action': 'query', 'titles': title, 'prop': 'imageinfo', 'iiprop': 'url|extmetadata', 'iiurlwidth': 900, 'format': 'json'})
        try:
            pages = json.loads(get(q))['query']['pages']
            page = next(iter(pages.values()))
            info = page['imageinfo'][0]
            meta = info.get('extmetadata', {})
            lic = (meta.get('LicenseShortName', {}).get('value') or '').strip()
            artist = (meta.get('Artist', {}).get('value') or '').strip()
            credit = (meta.get('Credit', {}).get('value') or '').strip()
            entry = {'title': title, 'licence': lic, 'artist': artist[:300], 'credit': credit[:300], 'page': info.get('descriptionurl', '')}
            if not any(k in lic.lower() for k in OK_LICENCES):
                entry['skipped'] = 'not public domain'
                report[body] = entry
                continue
            img = Image.open(io.BytesIO(get(info['thumburl']))).convert('RGB')
            img.thumbnail((900, 900))
            img.save(os.path.join(out, body + '.webp'), 'WEBP', quality=82, method=6)
            entry['size'] = os.path.getsize(os.path.join(out, body + '.webp'))
            entry['pixels'] = img.size
            report[body] = entry
            credits[body] = {'licence': lic, 'artist': artist[:300], 'page': entry['page']}
        except Exception as e:  # noqa: BLE001
            report[body] = {'title': title, 'error': str(e)[:200]}
        time.sleep(1)
    json.dump(credits, open(os.path.join(out, 'credits.json'), 'w'), indent=1, ensure_ascii=False)


def textures(report):
    out = os.path.join(ROOT, 'data', 'textures'); os.makedirs(out, exist_ok=True)
    for body, name in SRC['textures'].items():
        try:
            img = Image.open(io.BytesIO(get('https://www.solarsystemscope.com/textures/download/' + name)))
            ring = body == 'saturn_ring'
            img = img.convert('RGBA' if ring else 'RGB')
            img = img.resize((1024, 64) if ring else (1024, 512), Image.LANCZOS)
            path = os.path.join(out, body + '.webp')
            img.save(path, 'WEBP', quality=80, method=6)
            report['texture:' + body] = {'size': os.path.getsize(path)}
        except Exception as e:  # noqa: BLE001
            report['texture:' + body] = {'error': str(e)[:200]}


if __name__ == '__main__':
    rep = {}
    photos(rep)
    textures(rep)
    os.makedirs(os.path.join(ROOT, 'data', 'photos'), exist_ok=True)
    json.dump(rep, open(os.path.join(ROOT, 'data', 'photos', 'report.json'), 'w'), indent=1, ensure_ascii=False)
    print(json.dumps(rep, indent=1, ensure_ascii=False))
    sys.exit(0)
