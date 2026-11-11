#!/usr/bin/env python3
"""Makes site/assets/cities/<letter>.json from GeoNames' list of world cities (via github.com/lutangar/cities.json,
CC BY 4.0, GeoNames). The website loads one small file per first letter when someone searches for a city.

Usage: python3 tools/build_cities.py path/to/cities.json
"""
import json
import os
import sys
import unicodedata


def fold(s):
    s = unicodedata.normalize('NFKD', s)
    return ''.join(ch for ch in s if not unicodedata.combining(ch)).lower()


def main():
    rows = json.load(open(sys.argv[1], encoding='utf-8'))
    out = {}
    seen = set()
    for r in rows:
        name = r['name'].strip()
        if not name:
            continue
        lat, lon = round(float(r['lat']), 2), round(float(r['lng']), 2)
        key = (fold(name), r['country'], round(lat, 1), round(lon, 1))
        if key in seen:
            continue
        seen.add(key)
        first = fold(name)[:1]
        shard = first if 'a' <= first <= 'z' else '_'
        out.setdefault(shard, []).append([name, r['country'], lat, lon])
    here = os.path.dirname(os.path.abspath(__file__))
    folder = os.path.join(here, 'cities')
    os.makedirs(folder, exist_ok=True)
    total = 0
    for shard, items in out.items():
        items.sort(key=lambda x: (len(x[0]), x[0]))
        with open(os.path.join(folder, shard + '.json'), 'w', encoding='utf-8') as fh:
            json.dump(items, fh, ensure_ascii=False, separators=(',', ':'))
        total += len(items)
    print('cities', total, 'files', len(out))


if __name__ == '__main__':
    main()
