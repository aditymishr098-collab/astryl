"""Small helpers shared by the deep space page modules (black holes, galaxies, ...)."""


PUBLISHED = '2026-11-11'


def article_ld(site, title, desc, path, crumbs):
    """Article and breadcrumb data for search engines. crumbs: [(name, path)] from the home page down to this page."""
    url = f'{site}/{path}'
    return [
        {'@context': 'https://schema.org', '@type': 'Article', 'headline': title, 'description': desc, 'inLanguage': ['en', 'hi'], 'url': url,
         'mainEntityOfPage': url, 'image': f'{site}/img/og/{path.split("/")[-1][:-5]}.jpg', 'datePublished': PUBLISHED, 'dateModified': PUBLISHED,
         'author': {'@type': 'Organization', 'name': 'Astryl', 'url': site}, 'publisher': {'@type': 'Organization', 'name': 'Astryl', 'url': site}},
        {'@context': 'https://schema.org', '@type': 'BreadcrumbList',
         'itemListElement': [{'@type': 'ListItem', 'position': i + 1, 'name': n, 'item': f'{site}/{pth}'} for i, (n, pth) in enumerate(crumbs)]},
    ]


class Kit:
    def __init__(self, h):
        self.h = h
        self.bt = h['bt']
        self.shell = h['shell']
        self.fmt = h['fmt']
        self.bi = h['bi']
        self.site = h['SITE']

    def P(self, en, hi):
        return f'<p>{self.bt(en, hi)}</p>'

    def H2(self, en, hi):
        return f'<h2>{self.bt(en, hi)}</h2>'

    def callout(self, en, hi):
        return f'<div class="callout">{self.bt(en, hi)}</div>'

    def sec(self, *parts):
        return '<section class="blk prose">' + ''.join(parts) + '</section>'

    def card(self, te, th, be, bh):
        return f'<div class="card"><h3>{self.bt(te, th)}</h3><p>{self.bt(be, bh)}</p></div>'

    def grid(self, *cards, min_w=260):
        return f'<div class="grid" style="grid-template-columns:repeat(auto-fit,minmax({min_w}px,1fr))">' + ''.join(cards) + '</div>'

    def facts(self, rows):
        """rows: [(label_en, label_hi, value_en, value_hi)]"""
        return '<div class="stats">' + ''.join(
            f'<div class="stat"><b>{self.bt(ve, vh)}</b><span>{self.bt(le, lh)}</span></div>' for le, lh, ve, vh in rows) + '</div>'

    def table(self, head, rows, cols=False):
        """head: [(en, hi)], rows: [[(en, hi) or str, ...]]; a str is shown as is."""
        def cell(c, tag='td', cls=''):
            body = c if isinstance(c, str) else self.bt(*c)
            return f'<{tag}{cls}>{body}</{tag}>'
        th = ''.join(cell(c, 'th') for c in head)
        trs = ''.join('<tr>' + ''.join(cell(c, 'td', ' class="w"' if (i == len(r) - 1 and cols) else '') for i, c in enumerate(r)) + '</tr>' for r in rows)
        return f'<table class="cmp{" cols" if cols else ""}"><tr>{th}</tr>{trs}</table>'

    def keep_exploring(self, prefix, items):
        """A row of links to related pages and a share button. items: [(href, icon, en, hi)]"""
        bt = self.bt
        cards = ''.join(f'<a class="sc" href="{prefix}{h}"><span class="ic">{ic}</span><span><b>{bt(en, hi)}</b></span><span class="go">→</span></a>' for h, ic, en, hi in items)
        return (f'<section class="blk"><h2>{bt("Keep exploring", "आगे खोजिए")}</h2><div class="sc-grid" style="padding-top:6px">{cards}</div>'
                f'<p><button class="btn" type="button" data-share>↗ {bt("Share this page", "यह page share करें")}</button></p></section>')

    def note(self, en, hi):
        return f'<p class="note">{self.bt(en, hi)}</p>'


class Section:
    """A hub page plus ordered sub pages under one folder."""

    def __init__(self, kit, folder, hub_file, nav_key, hub_en, hub_hi, slugs):
        self.k, self.folder, self.hub_file, self.nav_key = kit, folder, hub_file, nav_key
        self.hub_en, self.hub_hi = hub_en, hub_hi
        self.slugs = slugs          # [(slug, en, hi, desc_en, desc_hi, icon)]
        self.idx = {s[0]: i for i, s in enumerate(slugs)}

    def pn(self, slug, last_link=None):
        bt = self.k.bt
        i = self.idx[slug]
        prev = self.slugs[i - 1] if i > 0 else None
        nxt = self.slugs[i + 1] if i + 1 < len(self.slugs) else None
        left = (f'<a class="btn" href="{prev[0]}.html">← {bt(prev[1], prev[2])}</a>' if prev
                else f'<a class="btn" href="../{self.hub_file}">← {bt(self.hub_en, self.hub_hi)}</a>')
        if nxt:
            right = f'<a class="btn primary" href="{nxt[0]}.html">{bt(nxt[1], nxt[2])} →</a>'
        elif last_link:
            right = f'<a class="btn primary" href="{last_link[0]}">{bt(last_link[1], last_link[2])} →</a>'
        else:
            right = '<span></span>'
        return f'<div class="pn">{left}{right}</div>'

    def head(self, en, hi, lead_en, lead_hi):
        bt = self.k.bt
        return (f'<p style="margin-top:20px"><a href="../{self.hub_file}">← {bt(self.hub_en, self.hub_hi)}</a></p>'
                f'<section class="blk"><h1>{bt(en, hi)}</h1><p class="sub">{bt(lead_en, lead_hi)}</p></section>')

    def page(self, slug, body, en, hi, desc, ld=None, related=None):
        k = self.k
        if related:
            body += k.keep_exploring('../', related)
        path = f'{self.folder}/{slug}.html'
        ld = ld or article_ld(k.site, en, desc, path, [('Astryl', ''), (self.hub_en, self.hub_file), (en, path)])
        html = k.shell(en, hi, self.nav_key, body, desc, depth=1, canonical=path, ld=ld)
        return {'file': f'{self.folder}/{slug}.html', 'html': html}

    def cards(self):
        bt = self.k.bt
        return ''.join(f'<a class="sc" href="{self.folder}/{s}.html"><span class="ic">{ic}</span><span><b>{bt(en, hi)}</b><small>{bt(de, dh)}</small></span><span class="go">→</span></a>'
                       for s, en, hi, de, dh, ic in self.slugs)
