window.ASTRYL_IC={"👥": "users", "👤": "user", "🧑‍🚀": "user", "👩‍🚀": "user", "📷": "camera", "⭐": "star", "🌟": "star", "✨": "sparkle", "💫": "sparkle", "🌠": "comet", "🗓️": "calendar", "🗓": "calendar", "📅": "calendar", "🌙": "moon", "🌔": "moon", "🌓": "moon", "🌗": "moon", "🌑": "moon", "🌌": "galaxy", "🌀": "spiral", "🛰️": "satellite", "🛰": "satellite", "📡": "satellite", "🪐": "planet", "🌍": "globe", "☄️": "comet", "🌇": "sunset", "🌆": "sunset", "🌅": "sunrise", "🎓": "school", "📚": "book", "📖": "book", "❓": "help", "❔": "help", "⏳": "hourglass", "⏱": "clock", "⏱️": "clock", "🕒": "clock", "☀️": "sun", "☀": "sun", "🌞": "sun", "🔭": "telescope", "🔬": "microscope", "🚀": "rocket", "✈️": "rocket", "⚖️": "scale", "🔍": "search", "⚫": "blackhole", "🕳️": "blackhole", "⚠️": "warning", "🧠": "brain", "🎯": "target", "🎲": "dice", "👀": "eye", "👁️": "eye", "📏": "ruler", "🔥": "flame", "🧪": "flask", "💬": "chat", "🗺️": "map", "🧭": "compass", "📍": "pin", "💡": "bulb", "📝": "note", "✏️": "pencil", "🏆": "trophy", "🏅": "medal", "🎖️": "medal", "👑": "trophy", "🔒": "lock", "🔑": "key", "🛡️": "shield", "🗑️": "trash", "🗑": "trash", "✅": "check", "❌": "cross", "💥": "bolt", "⚡": "bolt", "🔄": "sync", "🔁": "sync", "🚪": "door", "⏸": "pause", "❤️": "heart", "🎂": "cake", "📊": "chart", "📬": "mail", "🗂️": "folder", "🚩": "flag", "🖼️": "image", "🌡️": "thermo", "🎬": "film", "📤": "share", "🧩": "puzzle", "🌫️": "wave"};
/* Swaps colour emoji in text the browser adds (account page, quiz, community, ...) for the site's
   line icons, the same as the build does for page text. People's own posts and comments keep
   their emoji. window.ASTRYL_IC (emoji -> icon name) is written in front of this file at build. */
(function () {
  var MAP = window.ASTRYL_IC || {}, keys = Object.keys(MAP).sort(function (a, b) { return b.length - a.length; });
  if (!keys.length || !document.createTreeWalker) return;
  var RE = new RegExp('(' + keys.map(function (k) { return k.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); }).join('|') + ')\uFE0F?', 'g');
  var SKIP = 'script,style,textarea,input,option,select,title,svg,code,pre,[contenteditable],[data-noic],.pb,.bcmt,.mbody,.cph figcaption b,.prpost .pb';
  function swap(root) {
    if (!root || root.nodeType !== 1 && root.nodeType !== 3) return;
    var list = [];
    if (root.nodeType === 3) list.push(root);
    else {
      var w = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null);
      while (w.nextNode()) list.push(w.currentNode);
    }
    list.forEach(function (t) {
      var v = t.nodeValue; if (!v || !RE.test(v)) return; RE.lastIndex = 0;
      var p = t.parentElement; if (!p || p.closest(SKIP)) return;
      var frag = document.createDocumentFragment(), last = 0;
      v.replace(RE, function (m, e, i) {
        if (i > last) frag.appendChild(document.createTextNode(v.slice(last, i)));
        var ic = document.createElement('i'); ic.className = 'icn'; ic.setAttribute('data-i', MAP[e]); ic.setAttribute('aria-hidden', 'true');
        frag.appendChild(ic); last = i + m.length; return m;
      });
      if (last < v.length) frag.appendChild(document.createTextNode(v.slice(last)));
      p.replaceChild(frag, t);
    });
  }
  swap(document.body);
  if (window.MutationObserver) new MutationObserver(function (ms) {
    ms.forEach(function (m) { [].forEach.call(m.addedNodes, swap); if (m.type === 'characterData') swap(m.target); });
  }).observe(document.body, { childList: true, subtree: true, characterData: true });
})();
