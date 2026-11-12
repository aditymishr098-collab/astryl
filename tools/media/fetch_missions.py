#!/usr/bin/env python3
"""Second batch of real photos (run once on a GitHub runner), into data/photos/space:
spacecraft, the famous pictures they took, the space station, landing sites, global maps of the
Moon and Mars, and two deep-sky objects for the telescope simulator.

Same rules as fetch_space.py: exact Wikimedia Commons titles first, then a Commons search; only
free licences (public domain, CC0, CC BY, CC BY-SA, and India's GODL), with credit. No photos of
people. A report goes to data/photos/space/report-missions.json.
"""
import io, json, os, sys, time, urllib.parse, urllib.request
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fetch_space as fs  # noqa: E402

Image.MAX_IMAGE_PIXELS = None
fs.OK = fs.OK + ('godl',)

# id: (titles, search, width)
WANT = {
    # spacecraft
    'sc-sputnik': (['File:Sputnik asm.jpg', 'File:Sputnik 1.jpg'], 'Sputnik 1 replica satellite', 900),
    'sc-vostok': (['File:Vostok spacecraft.jpg', 'File:Vostok 1 capsule.jpg'], 'Vostok spacecraft capsule museum', 900),
    'sc-apollo11': (['File:Apollo 11 Lunar Module Eagle in landing configuration in lunar orbit from the Command and Service Module Columbia.jpg'], 'Apollo 11 Lunar Module Eagle lunar orbit', 900),
    'sc-viking': (['File:Viking Lander Model.jpg', 'File:Viking lander model.jpg'], 'Viking lander model NASA', 900),
    'sc-voyager': (['File:Voyager spacecraft.jpg', 'File:Voyager spacecraft model.png'], 'Voyager spacecraft NASA illustration', 900),
    'sc-hubble': (['File:HST-SM4.jpeg', 'File:Hubble 01.jpg'], 'Hubble Space Telescope in orbit servicing mission', 900),
    'sc-cassini': (['File:Cassini Saturn Orbit Insertion.jpg'], 'Cassini spacecraft Saturn orbit insertion', 900),
    'sc-curiosity': (['File:PIA16239 High-Resolution Self-Portrait by Curiosity Rover Arm Camera.jpg', 'File:Curiosity Self-Portrait at \'Big Sky\' Drilling Site.jpg'], 'Curiosity rover self-portrait Mars', 900),
    'sc-mangalyaan': (['File:Mars Orbiter Mission - India - ArtistsConcept.jpg', 'File:Mars Orbiter Mission Spacecraft.jpg'], 'Mars Orbiter Mission spacecraft Mangalyaan', 900),
    'sc-rosetta': (['File:Rosetta spacecraft model.png', 'File:Rosetta and Philae at comet (11206660686).jpg'], 'Rosetta spacecraft comet ESA', 900),
    'sc-newhorizons': (['File:New Horizons Transparent.png', 'File:New Horizons 1.jpg'], 'New Horizons spacecraft illustration', 900),
    'sc-perseverance': (['File:Perseverance-Selfie-at-Rochette-Horizontal-V2.gif', 'File:PIA24542-MarsPerseveranceRover-Selfie-20210406.jpg'], 'Perseverance rover selfie Ingenuity', 900),
    'sc-jwst': (['File:JWST spacecraft model 2.png', 'File:James Webb Space Telescope 2009 top.jpg'], 'James Webb Space Telescope spacecraft model', 900),
    'sc-chandrayaan3': (['File:Chandrayaan-3 Vikram Lander.jpg', 'File:Chandrayaan-3 Lander and Rover.jpg'], 'Chandrayaan-3 Vikram lander', 900),
    'sc-aditya': (['File:Aditya-L1 spacecraft.jpg'], 'Aditya-L1 spacecraft', 900),
    'sc-iss': (['File:International Space Station after undocking of STS-132.jpg', 'File:ISS-56 International Space Station fly-around (05).jpg'], 'International Space Station from Space Shuttle', 1000),
    # pictures they took
    'pic-apollo11': (['File:Apollo 11 bootprint.jpg', 'File:Aldrin Apollo 11 bootprint.jpg'], 'Apollo 11 bootprint lunar soil', 900),
    'pic-earthrise': (['File:NASA-Apollo8-Dec24-Earthrise.jpg'], 'Earthrise Apollo 8', 900),
    'pic-viking': (['File:Mars Viking 11h017.png', 'File:Viking 1 first image.jpg'], 'first photograph surface of Mars Viking 1', 900),
    'pic-paleblue': (['File:Pale Blue Dot.png', 'File:PIA23645-Earth-PaleBlueDot-6Bkm-Voyager1-orig19900214.jpg'], 'Pale Blue Dot Voyager 1', 900),
    'pic-voyager-jupiter': (['File:Jupiter from Voyager 1 PIA02855 max res.jpg', 'File:Great Red Spot From Voyager 1.jpg'], 'Jupiter Great Red Spot Voyager 1', 900),
    'pic-huygens': (['File:Huygens surface color.jpg', 'File:Huygens surface color sr.jpg'], 'Huygens probe surface of Titan', 900),
    'pic-cassini-earth': (['File:PIA17171 The Day the Earth Smiled.jpg', 'File:Saturn eclipse.jpg'], 'Saturn backlit Cassini Day the Earth Smiled', 1000),
    'pic-curiosity': (['File:PIA19912-MarsCuriosityRover-MountSharp-20150923.jpg', 'File:Mount Sharp, Mars.jpg'], 'Curiosity Mount Sharp layered rocks', 1000),
    'pic-mangalyaan': (['File:Mars Orbiter Mission - first image of Mars.jpg', 'File:Mars full disc image by Mars Orbiter Mission.jpg'], 'Mars Orbiter Mission full disc Mars image', 900),
    'pic-rosetta': (['File:Comet 67P on 19 September 2014 NavCam mosaic.jpg'], 'Comet 67P Churyumov Gerasimenko NavCam mosaic', 900),
    'pic-pluto': (['File:Pluto in True Color - High-Res.jpg', 'File:Nh-pluto-in-true-color 2x JPEG.jpg'], 'Pluto true color New Horizons', 900),
    'pic-ingenuity': (['File:PIA24542-MarsPerseveranceRover-Ingenuity-20210405.jpg', 'File:Ingenuity helicopter on Mars.jpg'], 'Ingenuity helicopter Mars Perseverance image', 900),
    'pic-chandrayaan3': (['File:Chandrayaan-3 Vikram lander imaged by Pragyan rover.jpg'], 'Vikram lander image by Pragyan rover', 900),
    'pic-aditya': (['File:Aditya-L1 SUIT full disk images of the Sun.jpg'], 'Aditya-L1 SUIT Sun full disk', 900),
    # space station
    'iss-india-night': (['File:ISS-30 India at night.jpg'], 'India at night from the International Space Station', 1000),
    'iss-trail': (['File:ISS over Teide.jpg', 'File:ISS Trail.jpg'], 'International Space Station trail long exposure night sky', 1000),
    'iss-cupola': (['File:ISS-26 Cupola view.jpg'], 'International Space Station Cupola view of Earth', 900),
    # landing sites, from orbit
    'site-apollo11': (['File:Apollo 11 landing site LRO 2012.jpg', 'File:Apollo 11 landing site, LRO.jpg'], 'Apollo 11 landing site Lunar Reconnaissance Orbiter', 900),
    'site-apollo17': (['File:Apollo 17 landing site LRO 2011.jpg'], 'Apollo 17 landing site Lunar Reconnaissance Orbiter', 900),
    'site-chandrayaan3': (['File:Chandrayaan-3 landing site LRO.png'], 'Chandrayaan-3 landing site Lunar Reconnaissance Orbiter', 900),
    'site-change4': (['File:Chang\'e 4 landing site LRO.png'], 'Chang\'e 4 landing site LRO', 900),
    'site-curiosity': (['File:Curiosity\'s landing site imaged by HiRISE.jpg'], 'Curiosity rover from orbit HiRISE', 900),
    'site-perseverance': (['File:PIA24487-MarsPerseveranceRover-LandingSite-20210223.jpg'], 'Perseverance landing site HiRISE', 900),
    'site-jezero': (['File:Jezero Crater, Mars - Perseverance landing site.jpg'], 'Jezero crater delta Mars', 900),
    # global maps
    'map-moon': (['File:Moon LRO WAC global mosaic.jpg', 'File:Lunar Reconnaissance Orbiter WAC global mosaic.jpg', 'File:Moon map mrd.jpg'], 'Moon global mosaic LRO WAC equirectangular', 2400),
    'map-mars': (['File:Mars Viking MDIM21 ClrMosaic global 1km.jpg', 'File:Mars Viking MDIM21 ClrMosaic 232m.jpg', 'File:Mars map.jpg'], 'Mars Viking MDIM color global mosaic', 2400),
    # deep sky for the telescope
    'ds-m42': (['File:Orion Nebula - Hubble 2006 mosaic 18000.jpg'], 'Orion Nebula Hubble mosaic', 1000),
    'ds-m45': (['File:Pleiades large.jpg', 'File:Pleiades Spitzer big.jpg'], 'Pleiades star cluster', 1000),
}


def info(title, width):
    q = fs.API + urllib.parse.urlencode({'action': 'query', 'titles': title, 'prop': 'imageinfo',
                                         'iiprop': 'url|extmetadata|size|mime', 'iiurlwidth': width, 'format': 'json'})
    page = next(iter(json.loads(fs.get(q))['query']['pages'].values()))
    if 'imageinfo' not in page:
        return None
    ii = page['imageinfo'][0]
    m = ii.get('extmetadata', {})
    v = lambda k: (m.get(k, {}).get('value') or '').strip()
    return {'title': page['title'], 'licence': v('LicenseShortName'), 'artist': v('Artist')[:500], 'credit': v('Credit')[:300],
            'desc': v('ImageDescription')[:300], 'page': ii.get('descriptionurl', ''), 'thumb': ii.get('thumburl') or ii.get('url'), 'w': ii.get('width'), 'mime': ii.get('mime')}


def main():
    os.makedirs(fs.OUT, exist_ok=True)
    report = {}
    cp = os.path.join(fs.OUT, 'credits.json')
    credits = json.load(open(cp)) if os.path.exists(cp) else {}
    for key, (titles, query, width) in WANT.items():
        tried, pick = [], None
        try:
            for t in titles:
                i = info(t, width); time.sleep(0.5)
                if i and fs.free(i):
                    pick = i; break
                tried.append({'title': t, 'licence': i and i['licence'], 'missing': i is None})
            if not pick and query:
                for s in fs.search(query):
                    if s in titles:
                        continue
                    i = info(s, width); time.sleep(0.5)
                    ok_type = (i or {}).get('mime', '').split('/')[-1] in ('jpeg', 'png', 'tiff', 'webp', 'gif')
                    if i and fs.free(i) and (i['w'] or 0) >= 500 and ok_type:
                        pick = i; break
                    tried.append({'title': s, 'licence': i and i['licence']})
            if not pick:
                report[key] = {'error': 'nothing free found', 'tried': tried}
                continue
            img = Image.open(io.BytesIO(fs.get(pick['thumb'])))
            img.seek(0)
            img = img.convert('RGBA' if img.mode in ('RGBA', 'LA', 'P') else 'RGB')
            img.thumbnail((width, width))
            path = os.path.join(fs.OUT, key + '.webp')
            img.save(path, 'WEBP', quality=80, method=6)
            report[key] = {**{k: pick[k] for k in ('title', 'licence', 'artist', 'credit', 'desc', 'page')}, 'pixels': img.size, 'bytes': os.path.getsize(path), 'tried': tried}
            credits[key] = {k: pick[k] for k in ('title', 'licence', 'artist', 'credit', 'page')}
        except Exception as e:  # noqa: BLE001
            report[key] = {'error': str(e)[:300], 'tried': tried}
        time.sleep(1)
    json.dump(credits, open(cp, 'w'), indent=1, ensure_ascii=False, sort_keys=True)
    json.dump(report, open(os.path.join(fs.OUT, 'report-missions.json'), 'w'), indent=1, ensure_ascii=False, sort_keys=True)


if __name__ == '__main__':
    main()
