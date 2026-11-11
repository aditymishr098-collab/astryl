#!/usr/bin/env python3
"""Exports the website's lessons to assets/learn/learn.json for the app's Learn section.

The lessons are written once, for the website (tools/deepspace.py, galaxies.py, students.py, universe.py,
learn.py). This script reads the built pages in site/ and the structured lists, and writes plain blocks
in English and Hindi that the app shows offline. Run it after tools/build_site.py.
"""
import html
import json
import re
import sys
from html.parser import HTMLParser
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tools'))

SKIP_TAGS = {'svg', 'script', 'style', 'button', 'canvas', 'nav', 'header', 'footer', 'select', 'input', 'noscript', 'figure'}
BLOCKS = {'h1', 'h2', 'h3', 'p', 'li', 'td', 'th', 'small', 'b'}


class Lesson(HTMLParser):
    """Turns the main part of a page into [{t: kind, en, hi}] blocks."""

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.blocks = []
        self.stack = []
        self.skip = 0
        self.lang = []
        self.cur = None
        self.in_callout = 0
        self.row = None
        self.cards = 0

    def start_block(self, kind):
        self.flush()
        self.cur = {'t': kind, 'en': '', 'hi': ''}

    def flush(self):
        c = self.cur
        if c and (c['en'].strip() or c['hi'].strip()):
            c['en'] = re.sub(r'\s+', ' ', c['en']).strip()
            c['hi'] = re.sub(r'\s+', ' ', c['hi']).strip() or c['en']
            if not c['en']:
                c['en'] = c['hi']
            if self.row is not None and c['t'] in ('td', 'th'):
                self.row.append(c)
            else:
                self.blocks.append(c)
        self.cur = None

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        cls = a.get('class', '') or ''
        if self.skip or tag in SKIP_TAGS:
            if tag not in ('br', 'img', 'input', 'meta', 'link'):
                self.skip += 1
            return
        if tag in ('br', 'img'):
            return
        self.stack.append((tag, cls))
        if tag == 'span' and 't' in cls.split():
            self.lang.append(a.get('lang', 'en'))
        elif tag == 'span':
            self.lang.append(None)
        if 'callout' in cls:
            self.in_callout += 1
            self.start_block('callout')
        elif tag == 'tr':
            self.flush()
            self.row = []
        elif tag in ('h1', 'h2', 'h3', 'li', 'td', 'th') or (tag == 'p' and not self.in_callout):
            kind = 'lead' if (tag == 'p' and 'sub' in cls) else ('p' if tag == 'p' else tag)
            if not (self.in_callout and tag == 'li'):
                self.start_block(kind)
            elif self.cur is not None:
                self.cur['en'] += ' • '
                self.cur['hi'] += ' • '

    def handle_endtag(self, tag):
        if self.skip:
            if tag not in ('br', 'img', 'input', 'meta', 'link'):
                self.skip -= 1
            return
        if not self.stack:
            return
        # pop to the matching tag
        while self.stack:
            t, cls = self.stack.pop()
            if t == 'span':
                self.lang.pop()
            if t == tag:
                break
        if tag == 'div' and self.in_callout and 'callout' in cls:
            self.flush()
            self.in_callout -= 1
        elif tag == 'tr':
            self.flush()
            if self.row:
                self.blocks.append({'t': 'row', 'cells': [{'en': c['en'], 'hi': c['hi']} for c in self.row], 'head': any(c['t'] == 'th' for c in self.row)})
            self.row = None
        elif tag in ('h1', 'h2', 'h3', 'li', 'td', 'th') or (tag == 'p' and not self.in_callout):
            if not self.in_callout:
                self.flush()

    def handle_data(self, data):
        if self.skip or self.cur is None:
            return
        lang = next((x for x in reversed(self.lang) if x is not None), None)
        if lang in (None, 'en'):
            self.cur['en'] += data
        if lang in (None, 'hi'):
            self.cur['hi'] += data


def lesson_from(path):
    text = (ROOT / 'site' / path).read_text(encoding='utf-8')
    main = text[text.index('<main'):text.index('</main>')]
    # drop "Keep exploring" and the back link
    main = re.sub(r'<section class="blk"><h2>.{0,400}?Keep exploring.*?</section>', '', main, flags=re.S)
    main = re.sub(r'<p style="margin-top:20px">.*?</p>', '', main, count=1, flags=re.S)
    p = Lesson()
    p.feed(main)
    p.flush()
    blocks = [b for b in p.blocks if not (b.get('t') == 'p' and b['en'].startswith('↗'))]
    title = next(b for b in blocks if b['t'] == 'h1')
    lead = next((b for b in blocks if b['t'] == 'lead'), {'en': '', 'hi': ''})
    body = [b for b in blocks if b is not title and b is not lead]
    return {'id': path.split('/')[-1][:-5], 'title': {'en': title['en'], 'hi': title['hi']}, 'lead': {'en': lead['en'], 'hi': lead['hi']}, 'blocks': body}


def main():
    import students
    import universe
    import learn

    def group(gid, en, hi, folder, slugs, icon):
        return {'id': gid, 'title': {'en': en, 'hi': hi}, 'icon': icon, 'lessons': [lesson_from(f'{folder}/{s}.html') for s in slugs]}

    def order(hub, folder):
        text = (ROOT / 'site' / hub).read_text(encoding='utf-8')
        out = []
        for m in re.finditer(r'href="' + folder + r'/([a-z0-9-]+)\.html"', text):
            if m.group(1) not in out:
                out.append(m.group(1))
        return out

    bh_slugs = ['what-is-a-black-hole', 'how-black-holes-form', 'event-horizon-and-singularity', 'falling-into-a-black-hole', 'how-we-see-black-holes', 'famous-black-holes', 'black-hole-myths-and-big-questions']
    gx_slugs = ['what-is-a-galaxy', 'the-milky-way', 'andromeda-galaxy', 'types-of-galaxies', 'the-local-group', 'galaxy-formation-and-collisions', 'galaxies-you-can-see']
    assert sorted(bh_slugs) == sorted(order('black-holes.html', 'black-holes')), order('black-holes.html', 'black-holes')
    assert sorted(gx_slugs) == sorted(order('galaxies.html', 'galaxies')), order('galaxies.html', 'galaxies')
    st_slugs = [t[0] for t in students.TOPICS]
    data = {
        'version': 1,
        'groups': [
            group('blackholes', 'Black holes', 'ब्लैक होल', 'black-holes', bh_slugs, 'bh'),
            group('galaxies', 'Galaxies', 'Galaxies', 'galaxies', gx_slugs, 'gx'),
            group('students', 'For students', 'छात्रों के लिए', 'learn', st_slugs, 'school'),
        ],
        'glossary': [{'en': g[0], 'hi': g[1], 'den': g[2], 'dhi': g[3]} for g in universe.GLOSSARY],
        'timeline': [{'v': e[0], 'en': e[1], 'hi': e[2], 'den': e[3], 'dhi': e[4]} for e in universe.EVENTS],
        'future': [{'en': e[0], 'hi': e[1], 'den': e[2], 'dhi': e[3]} for e in universe.FUTURE],
        'scale': [{'en': s[0], 'hi': s[1], 'm': s[2], 'den': s[3], 'dhi': s[4]} for s in universe.SCALE],
        'quiz': [{'s': q['s'], 'q': {'en': q['q'][0], 'hi': q['q'][1]}, 'o': [{'en': o[0], 'hi': o[1]} for o in q['o']], 'a': q['a'], 'e': {'en': q['e'][0], 'hi': q['e'][1]}} for q in learn.QUESTIONS],
    }
    # the short quizzes of the student pages
    st = data['groups'][2]['lessons']
    for lesson, topic in zip(st, students.TOPICS):
        lesson['blocks'] = [b for b in lesson['blocks'] if not (b['t'] == 'h2' and b['en'] == 'Quick quiz')]
        lesson['quiz'] = [{'q': {'en': q[0], 'hi': q[1]}, 'o': [{'en': o[0], 'hi': o[1]} for o in q[2]], 'a': q[3]} for q in topic[6]]
    out = ROOT / 'assets' / 'learn' / 'learn.json'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(data, ensure_ascii=False, separators=(',', ':')), encoding='utf-8')
    n = sum(len(g['lessons']) for g in data['groups'])
    print('lessons', n, 'blocks', sum(len(l['blocks']) for g in data['groups'] for l in g['lessons']), 'bytes', out.stat().st_size)


if __name__ == '__main__':
    main()
