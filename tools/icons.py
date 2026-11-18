"""One set of simple line icons, used instead of colour emoji.

Emoji look different on every phone and clash with the photos. At build time the emoji in page
text are swapped for <i class=icn data-i=NAME></i>; icons.js does the same for text the browser adds
later. Each icon is a 24 x 24 line drawing used as a CSS mask, so it takes the text colour.
User-written text (community posts, comments) keeps its emoji.
"""
import re
import urllib.parse

# name: SVG drawing (stroke paths on a 24 x 24 grid)
ICONS = {
    'users': '<circle cx="9" cy="8" r="3.5"/><path d="M2.5 20c.6-3.6 3.2-5.5 6.5-5.5s5.9 1.9 6.5 5.5"/><circle cx="17" cy="9" r="2.6"/><path d="M16.5 14.6c2.6.2 4.5 1.9 5 5"/>',
    'user': '<circle cx="12" cy="8" r="4"/><path d="M4 21c.8-4.2 4-6.5 8-6.5s7.2 2.3 8 6.5"/>',
    'camera': '<path d="M3 8.5A2 2 0 0 1 5 6.5h2.5L9 4h6l1.5 2.5H19a2 2 0 0 1 2 2V18a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><circle cx="12" cy="13" r="3.8"/>',
    'star': '<path d="M12 3l2.7 5.6 6.1.9-4.4 4.3 1 6.1L12 17l-5.4 2.9 1-6.1L3.2 9.5l6.1-.9z"/>',
    'sparkle': '<path d="M12 3c.6 4.3 2.7 6.4 7 7-4.3.6-6.4 2.7-7 7-.6-4.3-2.7-6.4-7-7 4.3-.6 6.4-2.7 7-7z"/><path d="M19 16.5c.2 1.4.9 2.1 2.3 2.3-1.4.2-2.1.9-2.3 2.3-.2-1.4-.9-2.1-2.3-2.3 1.4-.2 2.1-.9 2.3-2.3z"/>',
    'calendar': '<rect x="3.5" y="5" width="17" height="15.5" rx="2.5"/><path d="M3.5 10h17M8 3v4M16 3v4"/>',
    'moon': '<path d="M20 14.5A8.5 8.5 0 1 1 9.5 4a7 7 0 0 0 10.5 10.5z"/>',
    'galaxy': '<path d="M12 12c0-2.2 1.8-3.5 3.6-3.1 2.7.6 3.6 4.1 1.8 6.6-2.3 3.2-7.6 3.4-10.4.2C4.2 12.6 5 7.6 8.6 5.4 12 3.3 17.4 4 19.8 7.2"/><path d="M12 12c0 2.2-1.8 3.5-3.6 3.1"/>',
    'satellite': '<rect x="9" y="8.5" width="6" height="7" rx="1"/><path d="M9 12H6M15 12h3"/><rect x="1.5" y="9" width="4.5" height="6" rx=".6"/><rect x="18" y="9" width="4.5" height="6" rx=".6"/><path d="M12 8.5V5.5M10 4.5a3 3 0 0 1 4 0"/>',
    'planet': '<circle cx="12" cy="12" r="5.5"/><path d="M5.6 15.3C2.9 17.4 1.9 19.3 2.6 20c1.2 1.2 6.6-1.7 11.4-6.6s7.8-10.2 6.6-11.4c-.7-.7-2.6.3-4.7 3"/>',
    'comet': '<circle cx="16.5" cy="7.5" r="3.5"/><path d="M13.8 10.2L4 20M12.4 7.6L6 10M16.4 11.6L14 18"/>',
    'sunset': '<path d="M3 18h18M7 18a5 5 0 0 1 10 0M12 4v6M9.5 7.5L12 10l2.5-2.5M4.2 11.2l1.4 1.4M19.8 11.2l-1.4 1.4M5 21h14"/>',
    'sunrise': '<path d="M3 18h18M7 18a5 5 0 0 1 10 0M12 10V4M9.5 6.5L12 4l2.5 2.5M4.2 11.2l1.4 1.4M19.8 11.2l-1.4 1.4M5 21h14"/>',
    'school': '<path d="M2 9.5L12 5l10 4.5L12 14z"/><path d="M6 11.3v4.4c1.6 1.6 3.6 2.3 6 2.3s4.4-.7 6-2.3v-4.4M21 10v5"/>',
    'help': '<circle cx="12" cy="12" r="9"/><path d="M9.3 9.3a2.8 2.8 0 0 1 5.4 1c0 1.9-2.7 2.3-2.7 4"/><path d="M12 17.6v.1"/>',
    'hourglass': '<path d="M6.5 3h11M6.5 21h11M7.5 3c0 4.5 4.5 5.5 4.5 9s-4.5 4.5-4.5 9M16.5 3c0 4.5-4.5 5.5-4.5 9s4.5 4.5 4.5 9"/>',
    'clock': '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
    'sun': '<circle cx="12" cy="12" r="4.2"/><path d="M12 2.5v2.2M12 19.3v2.2M2.5 12h2.2M19.3 12h2.2M5.3 5.3l1.6 1.6M17.1 17.1l1.6 1.6M5.3 18.7l1.6-1.6M17.1 6.9l1.6-1.6"/>',
    'telescope': '<path d="M3.5 13.5l13-6.5 2 4-13 6.5z"/><path d="M16.5 7l1-.5 2 4-1 .5M10 15l-3 6M11.5 14.3L15 21M10.8 14.7V21"/>',
    'rocket': '<path d="M12 2.5c3.5 2.6 5 6.3 4.4 11.2L14 16.5h-4l-2.4-2.8C7 8.8 8.5 5.1 12 2.5z"/><circle cx="12" cy="9.5" r="1.8"/><path d="M8 13.5L5 16.5l3 1M16 13.5l3 3-3 1M10.5 19.5L12 22l1.5-2.5"/>',
    'scale': '<path d="M12 4v16M7 20h10M5 7h14M12 4l-1.5 3M12 4l1.5 3"/><path d="M5 7l-3 6.5a3 3 0 0 0 6 0zM19 7l-3 6.5a3 3 0 0 0 6 0z"/>',
    'search': '<circle cx="10.5" cy="10.5" r="6.5"/><path d="M15.5 15.5L21 21"/>',
    'blackhole': '<circle cx="12" cy="12" r="3.6" fill="#000"/><ellipse cx="12" cy="12" rx="10" ry="3.6"/><path d="M5 9.2A7.5 7.5 0 0 1 19 9.2"/>',
    'book': '<path d="M12 6.5C10 5 7 4.5 3 5v13.5c4-.5 7 0 9 1.5 2-1.5 5-2 9-1.5V5c-4-.5-7 0-9 1.5zM12 6.5V20"/>',
    'warning': '<path d="M12 3.5L2.5 20h19z"/><path d="M12 10v4.5M12 17.4v.1"/>',
    'target': '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5"/><circle cx="12" cy="12" r="1.2"/>',
    'brain': '<path d="M9 4.5A3 3 0 0 0 4.5 7a3 3 0 0 0-1 5 3 3 0 0 0 1.5 4.5A3 3 0 0 0 9 19.5a2.5 2.5 0 0 0 3-1V5.5a2.5 2.5 0 0 0-3-1zM15 4.5A3 3 0 0 1 19.5 7a3 3 0 0 1 1 5 3 3 0 0 1-1.5 4.5A3 3 0 0 1 15 19.5a2.5 2.5 0 0 1-3-1"/>',
    'eye': '<path d="M2 12s3.6-6.5 10-6.5S22 12 22 12s-3.6 6.5-10 6.5S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>',
    'ruler': '<rect x="2" y="8" width="20" height="8" rx="1.5"/><path d="M6 8v3M10 8v4M14 8v3M18 8v4"/>',
    'flame': '<path d="M12 21.5c4 0 6.5-2.6 6.5-6.3 0-4.2-3.4-6.2-4.4-10.7-2.6 1.6-3.6 4.2-3.3 6.5-1.3-.6-2-1.7-2.1-3.1C6.8 9.6 5.5 11.8 5.5 15.2c0 3.7 2.5 6.3 6.5 6.3z"/>',
    'flask': '<path d="M9.5 3h5M10.5 3v6L4.5 19a1.5 1.5 0 0 0 1.3 2h12.4a1.5 1.5 0 0 0 1.3-2l-6-10V3M7.5 14h9"/>',
    'chat': '<path d="M4 5h16a1 1 0 0 1 1 1v10a1 1 0 0 1-1 1h-9l-5 4v-4H4a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1z"/>',
    'map': '<path d="M3 6.5l6-2.5 6 2.5 6-2.5v13.5l-6 2.5-6-2.5-6 2.5zM9 4v13.5M15 6.5V20"/>',
    'compass': '<circle cx="12" cy="12" r="9"/><path d="M15.5 8.5l-2 5-5 2 2-5z"/>',
    'pin': '<path d="M12 21.5s-6.5-6-6.5-11.5a6.5 6.5 0 0 1 13 0c0 5.5-6.5 11.5-6.5 11.5z"/><circle cx="12" cy="10" r="2.4"/>',
    'bulb': '<path d="M9 17.5h6M10 21h4M8.5 14.5A6 6 0 1 1 15.5 14.5c-.7.6-1 1.5-1 2.5v.5h-5V17c0-1-.3-1.9-1-2.5z"/>',
    'pencil': '<path d="M4 20l1-4.5L15.5 5a2.1 2.1 0 0 1 3 3L8 18.5zM13.5 7l3 3"/>',
    'trophy': '<path d="M8 4h8v5a4 4 0 0 1-8 0zM8 6H4.5c0 3 1.5 4.5 3.7 4.8M16 6h3.5c0 3-1.5 4.5-3.7 4.8M12 13v4M8.5 20.5h7M9.5 17h5v3.5h-5z"/>',
    'medal': '<path d="M7.5 3h3l1.5 5 1.5-5h3l-3 7"/><circle cx="12" cy="15" r="5.5"/><path d="M12 12.4l.8 1.7 1.8.2-1.3 1.3.3 1.8-1.6-.9-1.6.9.3-1.8-1.3-1.3 1.8-.2z"/>',
    'lock': '<rect x="4.5" y="10.5" width="15" height="10" rx="2"/><path d="M8 10.5V7.5a4 4 0 0 1 8 0v3"/>',
    'key': '<circle cx="8" cy="15" r="4.5"/><path d="M11.2 11.8L20 3M17 6l2.5 2.5M14.5 8.5L16.5 10.5"/>',
    'shield': '<path d="M12 3l7.5 3v5.5c0 4.6-3.2 8.2-7.5 9.5-4.3-1.3-7.5-4.9-7.5-9.5V6z"/>',
    'trash': '<path d="M4 6.5h16M9.5 6.5V4h5v2.5M6 6.5l1 14h10l1-14M10 10.5v6M14 10.5v6"/>',
    'check': '<circle cx="12" cy="12" r="9"/><path d="M7.5 12.3l3 3 6-6.3"/>',
    'cross': '<circle cx="12" cy="12" r="9"/><path d="M8.8 8.8l6.4 6.4M15.2 8.8l-6.4 6.4"/>',
    'bolt': '<path d="M13 2.5L4.5 13.5H12l-1 8 8.5-11H12z"/>',
    'sync': '<path d="M20 11a8 8 0 0 0-14.5-4.5L4 8.5M4 13a8 8 0 0 0 14.5 4.5L20 15.5M4 4v4.5h4.5M20 20v-4.5h-4.5"/>',
    'door': '<path d="M5 21V4.5A1.5 1.5 0 0 1 6.5 3h8A1.5 1.5 0 0 1 16 4.5V21M3 21h18M12.5 12.5v.1M16 7h3v14"/>',
    'dice': '<rect x="3.5" y="3.5" width="17" height="17" rx="3.5"/><path d="M8.5 8.5v.1M15.5 15.5v.1M15.5 8.5v.1M8.5 15.5v.1M12 12v.1"/>',
    'note': '<path d="M6 3h9l4 4v14H6z"/><path d="M15 3v4h4M9 12h7M9 16h7"/>',
    'globe': '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c2.6 2.6 3.8 5.6 3.8 9s-1.2 6.4-3.8 9c-2.6-2.6-3.8-5.6-3.8-9S9.4 5.6 12 3z"/>',
    'pause': '<path d="M9 5v14M15 5v14"/>',
    'heart': '<path d="M12 20.5S3 15 3 8.8A4.8 4.8 0 0 1 12 6.5a4.8 4.8 0 0 1 9 2.3c0 6.2-9 11.7-9 11.7z"/>',
    'spiral': '<path d="M12 12a1.5 1.5 0 1 1 1.5 1.5 3 3 0 1 1-3-3 4.5 4.5 0 1 1 4.5 4.5A6 6 0 1 1 9 9"/>',
    'cake': '<path d="M4 20.5h16v-7a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2zM4 15.5c2.7 1.4 5.3 1.4 8 0 2.7 1.4 5.3 1.4 8 0M12 11.5V8M12 5.5v.1"/>',
    'chart': '<path d="M4 20V4M4 20h16M8 16v-4M12 16V8M16 16v-6"/>',
    'mail': '<rect x="3" y="5.5" width="18" height="13" rx="2"/><path d="M3.5 7l8.5 6 8.5-6"/>',
    'folder': '<path d="M3 6.5A1.5 1.5 0 0 1 4.5 5H9l2 2.5h8.5A1.5 1.5 0 0 1 21 9v9.5a1.5 1.5 0 0 1-1.5 1.5h-15A1.5 1.5 0 0 1 3 18.5z"/>',
    'flag': '<path d="M5 21V4M5 4h11l-2 4 2 4H5"/>',
    'image': '<rect x="3" y="4.5" width="18" height="15" rx="2"/><circle cx="8.5" cy="9.5" r="1.8"/><path d="M3.5 17l5-5 4 4 3-3 5 5"/>',
    'thermo': '<path d="M10 14V5a2 2 0 0 1 4 0v9a4 4 0 1 1-4 0z"/><path d="M12 10v6"/>',
    'film': '<rect x="3" y="4" width="18" height="16" rx="2"/><path d="M7 4v16M17 4v16M3 9h4M3 15h4M17 9h4M17 15h4"/>',
    'wave': '<path d="M3 16c3 0 3-3 6-3s3 3 6 3 3-3 6-3M3 10c3 0 3-3 6-3s3 3 6 3 3-3 6-3"/>',
    'share': '<path d="M12 15V3M7.5 7.5L12 3l4.5 4.5M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-7"/>',
    'puzzle': '<path d="M5 8h3a2 2 0 1 1 4 0h3v3a2 2 0 1 1 0 4v4H5v-4a2 2 0 1 0 0-4z"/>',
    'microscope': '<path d="M6 21h12M9 17h6M12 17v-3M9 5l3-2 4 7-3 2zM14.5 9.5A5 5 0 0 1 12 18"/>',
}

# emoji -> icon. Emoji not listed keep their normal look.
EMOJI = {
    '👥': 'users', '👤': 'user', '🧑‍🚀': 'user', '👩‍🚀': 'user', '📷': 'camera', '⭐': 'star', '🌟': 'star', '★': None, '✨': 'sparkle', '💫': 'sparkle', '🌠': 'comet',
    '🗓️': 'calendar', '🗓': 'calendar', '📅': 'calendar', '🌙': 'moon', '🌔': 'moon', '🌓': 'moon', '🌗': 'moon', '🌑': 'moon', '🌌': 'galaxy', '🌀': 'spiral',
    '🛰️': 'satellite', '🛰': 'satellite', '📡': 'satellite', '🪐': 'planet', '🌍': 'globe', '☄️': 'comet', '🌇': 'sunset', '🌆': 'sunset', '🌅': 'sunrise',
    '🎓': 'school', '📚': 'book', '📖': 'book', '❓': 'help', '❔': 'help', '⏳': 'hourglass', '⏱': 'clock', '⏱️': 'clock', '🕒': 'clock', '☀️': 'sun', '☀': 'sun', '🌞': 'sun',
    '🔭': 'telescope', '🔬': 'microscope', '🚀': 'rocket', '✈️': 'rocket', '⚖️': 'scale', '🔍': 'search', '⚫': 'blackhole', '🕳️': 'blackhole', '⚠️': 'warning',
    '🧠': 'brain', '🎯': 'target', '🎲': 'dice', '👀': 'eye', '👁️': 'eye', '📏': 'ruler', '🔥': 'flame', '🧪': 'flask', '💬': 'chat', '🗺️': 'map', '🧭': 'compass',
    '📍': 'pin', '💡': 'bulb', '📝': 'note', '✏️': 'pencil', '🏆': 'trophy', '🏅': 'medal', '🎖️': 'medal', '👑': 'trophy', '🔒': 'lock', '🔑': 'key', '🛡️': 'shield',
    '🗑️': 'trash', '🗑': 'trash', '✅': 'check', '❌': 'cross', '💥': 'bolt', '⚡': 'bolt', '🔄': 'sync', '🔁': 'sync', '🚪': 'door', '⏸': 'pause', '❤️': 'heart',
    '🎂': 'cake', '📊': 'chart', '📬': 'mail', '🗂️': 'folder', '🚩': 'flag', '🖼️': 'image', '🌡️': 'thermo', '🎬': 'film', '📤': 'share', '🧩': 'puzzle', '🌫️': 'wave',
}
EMOJI = {k: v for k, v in EMOJI.items() if v}
TINT = {'check': 'var(--good)', 'cross': 'var(--bad)', 'warning': '#d97706', 'flame': '#ea580c', 'star': '#eab308'}

_ORDER = sorted(EMOJI, key=len, reverse=True)
_RE = re.compile('(' + '|'.join(re.escape(e) for e in _ORDER) + ')️?')
_SKIP = ('script', 'style', 'title', 'textarea', 'svg', 'option', 'code', 'pre')


def tag(name):
    return f'<i class=icn data-i={name} aria-hidden=true></i>'


def css():
    out = ['.icn{display:inline-block;width:1.1em;height:1.1em;vertical-align:-.17em;background:currentColor;'
           '-webkit-mask:var(--m) center/contain no-repeat;mask:var(--m) center/contain no-repeat;flex:none}',
           'h1 .icn,h2 .icn,h3 .icn{color:var(--accent)}', '.btn.primary .icn,.cmvtabs .on .icn{color:inherit}', '.sc .ic .icn,.dccard small .icn{color:var(--accent)}']
    for name, body in ICONS.items():
        svg = ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#000" stroke-width="1.9" '
               f'stroke-linecap="round" stroke-linejoin="round">{body}</svg>')
        out.append(f'.icn[data-i={name}]{{--m:url("data:image/svg+xml,{urllib.parse.quote(svg, safe="")}")}}')
    for name, col in TINT.items():
        out.append(f'.icn[data-i={name}]{{color:{col}}}')
    return '\n'.join(out) + '\n'


def html(content):
    """Swap emoji in page text (not in tags, attributes, scripts or titles) for icons."""
    parts = re.split(r'(<[^>]+>)', content)
    skip, raw = 0, None
    for i, part in enumerate(parts):
        if raw:  # inside <script> or <style>: nothing counts until its closing tag
            if part.lower().startswith('</' + raw):
                raw = None
            continue
        if part.startswith('<'):
            m = re.match(r'<(/?)([a-zA-Z0-9]+)', part)
            if m:
                name = m.group(2).lower()
                if name in ('script', 'style') and not m.group(1):
                    raw = name
                elif name in _SKIP and not part.endswith('/>'):
                    skip = max(skip + (-1 if m.group(1) else 1), 0)
            continue
        if skip or not part:
            continue
        parts[i] = _RE.sub(lambda mm: tag(EMOJI[mm.group(1)]), part)
    return ''.join(parts)


def js_map():
    return {e: n for e, n in EMOJI.items()}
