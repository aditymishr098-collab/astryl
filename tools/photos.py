"""Planet photos for the website (NASA, public domain) and the surface maps (Solar System Scope, CC BY 4.0).

The files themselves were fetched once by tools/media/fetch_media.py into data/photos and data/textures.
The Moon's picture is drawn here from its surface map (made from NASA LRO data)."""
import html
import json
import re

import numpy as np
from PIL import Image

import site_data

PHOTOS = site_data.DATA / 'photos'
TEXTURES = site_data.DATA / 'textures'


def clean(text):
    text = re.sub(r'<[^>]+>', '', text or '')
    text = html.unescape(re.sub(r'\s+', ' ', text)).strip()
    text = re.sub(r'\s*\(see [^)]*\)?', '', text)
    text = re.sub(r'^.*?taken by either .*$', 'NASA / Apollo 17 crew', text) if 'Apollo 17' in text else text
    return text[:140]


def credits():
    raw = json.loads((PHOTOS / 'credits.json').read_text(encoding='utf-8'))
    out = {k: (clean(v.get('artist', '')) or 'NASA') + ' · public domain' for k, v in raw.items()}
    out['moon'] = 'Drawn from NASA LRO data; map by Solar System Scope (CC BY 4.0)'
    return out


def moon_picture(size=600):
    """An orthographic view of the near side, lit from the front, from the Moon's surface map."""
    tex = np.asarray(Image.open(TEXTURES / 'moon.webp').convert('RGB')).astype(np.float32)
    h, w = tex.shape[:2]
    ys, xs = np.mgrid[0:size, 0:size]
    nx = (xs + 0.5) / size * 2 - 1
    ny = (ys + 0.5) / size * 2 - 1
    r2 = nx * nx + ny * ny
    inside = r2 < 1
    nz = np.sqrt(np.clip(1 - r2, 0, 1))
    lat = np.arcsin(np.clip(ny, -1, 1))
    lon = np.arctan2(nx, nz)
    v = np.clip(((lat / np.pi + 0.5) * h).astype(int), 0, h - 1)
    u = (((lon / (2 * np.pi)) + 0.5) * w).astype(int) % w
    img = tex[v, u] * (0.55 + 0.45 * nz)[..., None]
    out = np.zeros((size, size, 3), np.float32)
    out[inside] = img[inside]
    return Image.fromarray(np.clip(out, 0, 255).astype(np.uint8))


def build(out_dir):
    """Writes img/planets/<id>.webp (600 px) and <id>-s.webp (160 px) and img/textures/*.webp."""
    pdir = out_dir / 'img' / 'planets'
    tdir = out_dir / 'img' / 'textures'
    pdir.mkdir(parents=True, exist_ok=True)
    tdir.mkdir(parents=True, exist_ok=True)
    have = set()
    for f in PHOTOS.glob('*.webp'):
        img = Image.open(f).convert('RGB')
        save(img, pdir, f.stem)
        have.add(f.stem)
    save(moon_picture(), pdir, 'moon')
    have.add('moon')
    for f in TEXTURES.glob('*.webp'):
        (tdir / f.name).write_bytes(f.read_bytes())
    return have


def transparent(img):
    """Space around the body becomes see-through, so the picture also suits the light theme."""
    a = np.asarray(img.convert('RGB')).astype(np.int16)
    m = a.max(axis=2)
    alpha = np.clip((m - 10) * 14, 0, 255).astype(np.uint8)
    # keep dark spots inside the disc: only pixels connected to the border are cleared
    from PIL import ImageDraw
    # a black frame around the picture joins the four corners, so all the space is found
    padded = np.pad((m > 22).astype(np.uint8) * 255, 2)
    filled = Image.fromarray(padded).copy()
    ImageDraw.floodfill(filled, (0, 0), 128)
    outside = (np.asarray(filled) == 128)[2:-2, 2:-2]
    final = np.where(outside, alpha, 255).astype(np.uint8)
    rgba = img.convert('RGBA'); rgba.putalpha(Image.fromarray(final))
    return rgba


def save(img, folder, name):
    img = transparent(img)
    big = img.copy(); big.thumbnail((600, 600))
    big.save(folder / f'{name}.webp', 'WEBP', quality=82, method=6)
    small = img.copy(); small.thumbnail((160, 160))
    small.save(folder / f'{name}-s.webp', 'WEBP', quality=80, method=6)
