"""My space: a personal dashboard (logic in site_src/myspace.js), and the star list for the birthday sky."""
import json
import re

from dskit import Kit
from umap import CATALOG


def birthday_stars():
    """Nearby stars and star clusters by distance, from the Universe map catalogue: [[name, light-years]]."""
    src = CATALOG.read_text(encoding='utf-8')
    rows = [[m.group(1).replace("\\'", "'"), float(m.group(2))]
            for m in re.finditer(r"StarRow\('((?:[^'\\]|\\.)*)', [-\d.]+, [-\d.]+, ([\d.e+]+), (\d), \d\)", src) if m.group(3) != '1']
    rows.sort(key=lambda r: r[1])
    assert len(rows) > 25
    return json.dumps(rows, ensure_ascii=False, separators=(',', ':'))


def build(h):
    k = Kit(h)
    bt = k.bt
    v = h['asset_v']()
    body = f'''<section class="blk"><h1>{bt("My space", "My space")}</h1>
<div id="mySpace"><noscript><p>{bt("My space needs JavaScript.", "My space को JavaScript चाहिए।")}</p></noscript></div></section>'''
    html = h['shell']('My space', 'My space', 'myspace', body,
                      'Your favourite planets and moons, quiz scores, streak, badges, Black holes 101 progress and what to read next on Astryl.',
                      canonical='my-space.html',
                      extra_head=f'<meta name="robots" content="noindex"><script defer src="assets/tonight.js?v={v}"></script><script defer src="assets/myspace.js?v={v}"></script>')
    h['write']('my-space.html', html)
    return []
