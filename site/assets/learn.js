/* Deep space quiz, Black holes 101 progress and the badge. All progress stays in this browser (localStorage). */
(function () {
  var KEY = 'astryl-bh101', BEST = 'astryl-ds-best-';
  function $(id) { return document.getElementById(id); }
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + hi + '</span>'; }
  function get(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } }
  function set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { } }
  function done() { var a = get(KEY, []); return Array.isArray(a) ? a : []; }

  // a lesson page counts as read once it has been open for a few seconds
  var m = location.pathname.match(/black-holes\/([a-z0-9-]+)\.html$/);
  if (m) {
    setTimeout(function () { var a = done(); if (a.indexOf(m[1]) < 0) { a.push(m[1]); set(KEY, a); } }, 4000);
  }

  function badge() {
    var el = $('badge'); if (!el) return;
    var total = +el.getAttribute('data-total'), n = done().filter(function (s) { return (el.getAttribute('data-slugs') || '').split(',').indexOf(s) >= 0; }).length;
    var best = get(BEST + 'bh', 0), ok = n >= total && best >= 4;
    el.classList.toggle('on', ok);
    var st = $('badgeState');
    if (st) st.innerHTML = ok ? bi('Unlocked. You read every lesson and scored ' + best + '/5 on the quiz.', 'Unlock हो गया। आपने हर पाठ पढ़ा और quiz में ' + best + '/5 अंक पाए।')
      : bi('Locked. Read all ' + total + ' lessons (' + n + ' done) and score 4 or more out of 5 on the Black hole quiz' + (best ? ' (best so far ' + best + '/5)' : '') + '.', 'Locked। सभी ' + total + ' पाठ पढ़िए (' + n + ' हो चुके) और Black hole quiz में 5 में से 4 या ज़्यादा अंक लाइए' + (best ? ' (अब तक सबसे अच्छा ' + best + '/5)' : '') + '।');
  }

  function path() {
    var list = $('pathList'); if (!list) return;
    var d = done(), items = list.querySelectorAll('li'), n = 0;
    for (var i = 0; i < items.length; i++) {
      var ok = d.indexOf(items[i].getAttribute('data-slug')) >= 0; if (ok) n++;
      items[i].classList.toggle('done', ok);
    }
    $('pathBar').style.width = (n / items.length * 100) + '%';
    $('pathCount').innerHTML = bi(n + ' of ' + items.length + ' lessons read', items.length + ' में से ' + n + ' पाठ पढ़े');
    var r = $('pathReset'); if (r) r.onclick = function () { set(KEY, []); path(); badge(); };
  }

  function quiz() {
    var box = $('dsq'); if (!box) return;
    var data = JSON.parse($('dsqData').textContent), setName = 'bh', picked = [], idx = 0, score = 0;
    function shuffle(a) { for (var i = a.length - 1; i > 0; i--) { var j = Math.floor(Math.random() * (i + 1)), t = a[i]; a[i] = a[j]; a[j] = t; } return a; }
    function start(name) {
      setName = name;
      picked = shuffle(data.filter(function (q) { return name === 'all' || q.s === name; })).slice(0, 5);
      idx = 0; score = 0; render();
      var tabs = document.querySelectorAll('#dsqTabs button');
      for (var i = 0; i < tabs.length; i++) tabs[i].classList.toggle('primary', tabs[i].getAttribute('data-set') === name);
    }
    function render() {
      if (idx >= picked.length) {
        var key = BEST + setName, best = get(key, 0), nb = score > best;
        if (nb) set(key, score);
        box.innerHTML = '<div class="card"><h2>' + bi('You scored ' + score + ' out of ' + picked.length, picked.length + ' में से आपके ' + score + ' अंक') + '</h2><p>' + bi(nb ? 'A new best for this set!' : 'Your best for this set is ' + Math.max(best, score) + '/5.', nb ? 'इस set का नया सबसे अच्छा स्कोर!' : 'इस set का आपका सबसे अच्छा स्कोर ' + Math.max(best, score) + '/5 है।') + '</p><div class="row"><button class="btn primary" type="button" id="dsqAgain">' + bi('Play again', 'फिर खेलिए') + '</button></div></div>';
        $('dsqAgain').onclick = function () { start(setName); }; badge(); return;
      }
      var q = picked[idx], h = '<div class="card"><p class="note">' + bi('Question ' + (idx + 1) + ' of ' + picked.length, 'सवाल ' + (idx + 1) + ' / ' + picked.length) + '</p><h2 style="margin-top:.2em">' + bi(q.q[0], q.q[1]) + '</h2><div class="opts">';
      q.o.forEach(function (o, i) { h += '<button class="opt" type="button" data-i="' + i + '">' + bi(o[0], o[1]) + '</button>'; });
      h += '</div><div id="dsqFb"></div></div>'; box.innerHTML = h;
      var bs = box.querySelectorAll('.opt');
      for (var i = 0; i < bs.length; i++) bs[i].onclick = function () {
        var c = +this.getAttribute('data-i'), all = box.querySelectorAll('.opt');
        for (var k = 0; k < all.length; k++) { all[k].disabled = true; if (k === q.a) all[k].classList.add('right'); }
        if (c === q.a) score++; else this.classList.add('wrong');
        $('dsqFb').innerHTML = '<p><b>' + (c === q.a ? bi('Correct.', 'सही।') : bi('Not quite.', 'लगभग।')) + '</b> ' + bi(q.e[0], q.e[1]) + '</p><div class="row"><button class="btn primary" type="button" id="dsqNext">' + (idx + 1 < picked.length ? bi('Next', 'आगे') + ' →' : bi('See score', 'स्कोर देखें')) + '</button></div>';
        $('dsqNext').onclick = function () { idx++; render(); };
      };
    }
    var tabs = document.querySelectorAll('#dsqTabs button');
    for (var i = 0; i < tabs.length; i++) tabs[i].onclick = function () { start(this.getAttribute('data-set')); };
    start(location.hash === '#galaxies' ? 'gx' : 'bh');
  }

  document.addEventListener('DOMContentLoaded', function () { path(); quiz(); badge(); });
})();
