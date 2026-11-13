#!/usr/bin/env python3
"""Third batch of real photos (run once on a GitHub runner), into data/photos/space: stars,
how they are born, how they die (supernovae, neutron stars, white dwarfs, planetary nebulae).

Same rules as fetch_space.py: exact Wikimedia Commons titles first, then a Commons search; only
free licences (public domain, CC0, CC BY, CC BY-SA), with credit. A report goes to
data/photos/space/report-stars.json so every choice can be checked by eye.
"""
import io, json, os, sys, time, urllib.parse
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fetch_space as fs  # noqa: E402

Image.MAX_IMAGE_PIXELS = None

# id: (exact titles to try first, Commons search used if none of them is free)
WANT = {
    'st-hh211': (['File:HH 211 (NIRCam image).jpg', 'File:Webb captures outflow from infant star HH 211.jpg'], 'HH 211 Webb outflow young star'),
    'st-hh46': (['File:Herbig-Haro 46-47 (NIRCam Image).jpg', 'File:Herbig-Haro 46-47 NIRCam.png'], 'Herbig-Haro 46 47 Webb'),
    'st-rhooph': (['File:Rho Ophiuchi cloud complex (NIRCam Image).jpg', 'File:Rho Ophiuchi (NIRCam image).jpg'], 'Rho Ophiuchi Webb first anniversary'),
    'st-betelgeuse': (['File:Betelgeuse captured by ALMA.jpg', 'File:Betelgeuse star (Alpha Orionis).jpg'], 'Betelgeuse surface image ESO'),
    'st-antares': (['File:Antares VLTI map.jpg', 'File:Antares surface (VLTI).jpg'], 'Antares surface VLTI ESO'),
    'st-sn1987a': (['File:SN1987a Hubble 2017.jpg', 'File:Supernova 1987A.jpg', 'File:SN 1987A (NIRCam image).jpg'], 'SN 1987A Hubble'),
    'st-casa': (['File:Cassiopeia A (NIRCam image).jpg', 'File:Cassiopeia A (MIRI image).jpg', 'File:Cassiopeia A Spitzer Crop.jpg'], 'Cassiopeia A supernova remnant Webb'),
    'st-tycho': (['File:Tycho-supernova-xray.jpg', 'File:Tycho SNR.jpg'], 'Tycho supernova remnant Chandra'),
    'st-crabcore': (['File:Crab Nebula pulsar x-ray.jpg', 'File:Chandra image of the Crab Nebula.jpg'], 'Crab pulsar Chandra X-ray'),
    'st-vela': (['File:Vela Pulsar jet.jpg', 'File:Vela pulsar jet Chandra.jpg'], 'Vela pulsar Chandra'),
    'st-ring': (['File:Ring Nebula (NIRCam image).jpg', 'File:M57 The Ring Nebula.JPG'], 'Ring Nebula Webb'),
    'st-catseye': (['File:NGC6543.jpg', "File:Cat's Eye Nebula.jpg"], "Cat's Eye Nebula Hubble NGC 6543"),
    'st-southring': (['File:Southern Ring Nebula (NIRCam Image).jpg', 'File:NGC 3132 (NIRCam image).png'], 'Southern Ring Nebula Webb'),
    'st-siriusb': (['File:Sirius A and B Hubble photo.jpg'], 'Sirius B white dwarf Hubble'),
    'st-omegacen': (['File:Omega Centauri by ESO.jpg', 'File:Omega Centauri.jpg'], 'Omega Centauri globular cluster'),
    'st-polaris': (['File:Polaris alpha ursae minoris.jpg'], 'Polaris Hubble'),
    'st-proxima': (['File:New shot of Proxima Centauri, our nearest neighbour.jpg'], 'Proxima Centauri Hubble'),
    'st-orion': (['File:Orion Head to Toe.jpg', 'File:OrionCC.jpg', 'File:Orion 3008 huge.jpg'], 'Orion constellation photograph'),
    'st-etacar': (['File:Eta Carinae.jpg', 'File:Eta Carinae (2019).jpg'], 'Eta Carinae Hubble'),
    'st-wr124': (['File:WR 124 (NIRCam and MIRI composite image).jpg', 'File:WR 124 (NIRCam and MIRI image).jpg'], 'WR 124 Webb'),
    'st-sunsurface': (['File:DKIST-Sun-Image.jpg', 'File:Sun surface DKIST.jpg'], 'Inouye solar telescope sun surface granules'),
}
WIDTH = 1400


def main():
    os.makedirs(fs.OUT, exist_ok=True)
    report = {}
    cp = os.path.join(fs.OUT, 'credits.json')
    credits = json.load(open(cp)) if os.path.exists(cp) else {}
    for key, (titles, query) in WANT.items():
        if os.path.exists(os.path.join(fs.OUT, key + '.webp')):
            continue
        tried, pick = [], None
        try:
            for t in titles:
                i = fs.info(t); time.sleep(0.5)
                if i and fs.free(i):
                    pick = i; break
                tried.append({'title': t, 'licence': i and i['licence'], 'missing': i is None})
            if not pick and query:
                for s in fs.search(query):
                    if s in titles:
                        continue
                    i = fs.info(s); time.sleep(0.5)
                    ok_type = (i or {}).get('mime', '').split('/')[-1] in ('jpeg', 'png', 'tiff', 'webp')
                    if i and fs.free(i) and (i['w'] or 0) >= 600 and ok_type:
                        pick = i; break
                    tried.append({'title': s, 'licence': i and i['licence']})
            if not pick:
                report[key] = {'error': 'nothing free found', 'tried': tried}
                continue
            img = Image.open(io.BytesIO(fs.get(pick['thumb']))).convert('RGB')
            img.thumbnail((WIDTH, WIDTH))
            path = os.path.join(fs.OUT, key + '.webp')
            img.save(path, 'WEBP', quality=80, method=6)
            report[key] = {**{k: pick[k] for k in ('title', 'licence', 'artist', 'credit', 'desc', 'page')}, 'pixels': img.size, 'bytes': os.path.getsize(path), 'tried': tried}
            credits[key] = {k: pick[k] for k in ('title', 'licence', 'artist', 'credit', 'page')}
        except Exception as e:  # noqa: BLE001
            report[key] = {'error': str(e)[:300], 'tried': tried}
        time.sleep(1)
    json.dump(credits, open(cp, 'w'), indent=1, ensure_ascii=False, sort_keys=True)
    json.dump(report, open(os.path.join(fs.OUT, 'report-stars.json'), 'w'), indent=1, ensure_ascii=False, sort_keys=True)


if __name__ == '__main__':
    main()
