/* Personal bits that work on every page: which pages you have read, your favourites and
   what to read next. Everything stays in this browser (localStorage). Favourites also travel
   with your account when sync is on (see account.js); the reading list never leaves the browser. */
(function () {
  var READ = 'astryl-read', FAVS = 'astryl-favs', MAX_FAVS = 60;
  function get(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } }
  function set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { } }
  function changed() { try { document.dispatchEvent(new Event('astryl-change')); } catch (e) { } }
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + hi + '</span>'; }
  var root = (document.body && document.body.getAttribute('data-root')) || '';

  /* This page's path from the site root, e.g. "black-holes/famous-black-holes.html". */
  function here() {
    var c = document.querySelector('link[rel="canonical"]'), p = '';
    try { p = c ? new URL(c.href).pathname : location.pathname; } catch (e) { p = location.pathname; }
    p = p.replace(/^\/+/, '');
    return p || 'index.html';
  }

  /* A suggested order to read the site in. "Next for you" is the first pages here you have not read. */
  var PATH = [
    ['planets.html', '🪐', 'Planets and moons', 'ग्रह और चाँद'],
    ['solar-system.html', '☀️', 'Solar System 3D', '3D सौरमंडल'],
    ['sky.html', '🌙', 'Moon calendar', 'चाँद का calendar'],
    ['you.html', '🎂', 'Your birthday sky', 'आपके जन्मदिन का आसमान'],
    ['sky-events.html', '🌑', 'Eclipses and meteor showers', 'ग्रहण और उल्कापात'],
    ['learn/moon-phases.html', '🌓', 'Phases of the Moon', 'चाँद की कलाएँ'],
    ['learn/eclipses.html', '🎓', 'How eclipses work', 'ग्रहण कैसे होते हैं'],
    ['compare.html', '⚖️', 'Compare planets', 'ग्रहों की तुलना'],
    ['constellations.html', '✨', 'Constellations', 'तारामंडल'],
    ['black-holes/what-is-a-black-hole.html', '⚫', 'What is a black hole?', 'ब्लैक होल क्या है?'],
    ['black-holes/how-black-holes-form.html', '💥', 'How black holes form', 'ब्लैक होल कैसे बनते हैं'],
    ['black-holes/event-horizon-and-singularity.html', '🕳️', 'Event horizon and singularity', 'Event horizon और singularity'],
    ['black-holes/falling-into-a-black-hole.html', '🌀', 'Falling into a black hole', 'ब्लैक होल में गिरना'],
    ['black-holes/how-we-see-black-holes.html', '🔭', 'How we see black holes', 'हम ब्लैक होल कैसे देखते हैं'],
    ['black-holes/famous-black-holes.html', '⭐', 'Famous black holes', 'मशहूर ब्लैक होल'],
    ['black-holes/black-hole-myths-and-big-questions.html', '❓', 'Myths and big questions', 'मिथक और बड़े सवाल'],
    ['black-hole-lab.html', '🧪', 'Black hole lab', 'ब्लैक होल lab'],
    ['galaxies/what-is-a-galaxy.html', '🌌', 'What is a galaxy?', 'Galaxy क्या है?'],
    ['galaxies/the-milky-way.html', '🌠', 'The Milky Way', 'आकाशगंगा'],
    ['galaxies/andromeda-galaxy.html', '🌀', 'The Andromeda Galaxy', 'एंड्रोमेडा galaxy'],
    ['galaxies/types-of-galaxies.html', '🔷', 'Types of galaxies', 'Galaxy के प्रकार'],
    ['galaxies/the-local-group.html', '🏘️', 'The Local Group', 'स्थानीय समूह'],
    ['galaxies/galaxy-formation-and-collisions.html', '💫', 'Galaxy formation and collisions', 'Galaxy का बनना और टकराना'],
    ['galaxies/galaxies-you-can-see.html', '👀', 'Galaxies you can see', 'जो galaxies आप देख सकते हैं'],
    ['universe-map.html', '🗺️', 'Universe map', 'ब्रह्मांड का नक्शा'],
    ['cosmic-scale.html', '📏', 'Scale of the universe', 'ब्रह्मांड का पैमाना'],
    ['universe-timeline.html', '⏳', 'Timeline of the universe', 'ब्रह्मांड की timeline'],
    ['missions.html', '🚀', 'Space missions', 'अंतरिक्ष मिशन'],
    ['spacecraft.html', '🛰️', 'Spacecraft', 'अंतरिक्ष यान'],
    ['maps.html', '🗺️', 'Surface maps', 'सतह के नक्शे'],
    ['glossary.html', '📖', 'Space glossary', 'अंतरिक्ष शब्दकोश'],
    ['quiz.html', '❓', 'Planet quiz', 'ग्रहों की quiz'],
    ['deep-space-quiz.html', '🧠', 'Black hole and galaxy quiz', 'ब्लैक होल और galaxy quiz']
  ];
  var SKIP = { 'index.html': 1, 'account.html': 1, 'my-space.html': 1, 'privacy.html': 1, 'get.html': 1, '404.html': 1 };

  function read() { var r = get(READ, {}); return r && typeof r === 'object' && !Array.isArray(r) ? r : {}; }
  function favs() { var f = get(FAVS, []); return Array.isArray(f) ? f.filter(function (x) { return typeof x === 'string'; }) : []; }
  function setFavs(list, quiet) { set(FAVS, list.slice(-MAX_FAVS)); if (!quiet) changed(); }
  function isFav(id) { return favs().indexOf(id) >= 0; }
  function toggleFav(id) {
    var f = favs(), i = f.indexOf(id);
    if (i >= 0) f.splice(i, 1); else f.push(id);
    setFavs(f); return i < 0;
  }
  function nextFor(n, skip) {
    var r = read(), out = [];
    for (var i = 0; i < PATH.length && out.length < n; i++) if (!r[PATH[i][0]] && PATH[i][0] !== skip) out.push(PATH[i]);
    return out;
  }

  /* 1. Count this page as read once it has been open for a few seconds. */
  var me = here();
  if (!SKIP[me]) setTimeout(function () { var r = read(); if (!r[me]) { r[me] = Date.now(); set(READ, r); } }, 4000);

  /* 2. The star button on planet and moon pages. */
  function drawFav(btn) {
    var on = isFav(btn.getAttribute('data-fav'));
    btn.classList.toggle('on', on);
    btn.setAttribute('aria-pressed', on ? 'true' : 'false');
    btn.innerHTML = (on ? '★ ' : '☆ ') + (on ? bi('In My space', 'My space में') : bi('Add to My space', 'My space में जोड़ें'));
  }
  Array.prototype.forEach.call(document.querySelectorAll('[data-fav]'), function (btn) {
    drawFav(btn);
    btn.addEventListener('click', function () { toggleFav(btn.getAttribute('data-fav')); drawFav(btn); });
  });

  /* 3. "Keep exploring": pages you have read get a tick and move to the end. */
  Array.prototype.forEach.call(document.querySelectorAll('.sc-grid'), function (grid) {
    var cards = Array.prototype.slice.call(grid.querySelectorAll('a.sc')), r = read(), first = true;
    if (!cards.length) return;
    cards.forEach(function (a) {
      var href = a.getAttribute('href') || '', path = '';
      try { path = new URL(a.href).pathname.replace(/^\/+/, ''); } catch (e) { path = href; }
      if (r[path]) { a.classList.add('read'); grid.appendChild(a); }
    });
    cards.forEach(function (a) {
      if (a.classList.contains('read')) {
        var go = a.querySelector('.go'); if (go) go.textContent = '✓';
      } else if (first) {
        first = false; a.classList.add('next');
        var b = a.querySelector('b'); if (b) b.insertAdjacentHTML('beforebegin', '<small class="nexttag">' + bi('Next for you', 'आपके लिए अगला') + '</small>');
      }
    });
  });

  /* 4. Short quizzes on the student pages. */
  document.addEventListener('click', function (e) {
    var b = e.target.closest('.mq .opt'); if (!b) return;
    var box = b.closest('.mq'); if (box.classList.contains('done')) return;
    var right = +box.getAttribute('data-right'), opts = box.querySelectorAll('.opt'), ok = +b.getAttribute('data-i') === right;
    box.classList.add('done');
    opts[right].classList.add('right'); if (!ok) b.classList.add('wrong');
    var fb = box.querySelector('.mqfb'); if (fb) fb.innerHTML = ok ? '✅ ' + bi('Right!', 'सही!') : '❌ ' + bi('Not quite. The right answer is marked in green.', 'नहीं। सही जवाब हरे रंग में है।');
  });

  window.ASTRYL_ME = { read: read, favs: favs, setFavs: setFavs, toggleFav: toggleFav, isFav: isFav, nextFor: nextFor, path: PATH, root: root, here: here };
})();
