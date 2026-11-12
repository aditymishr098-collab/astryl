/* Quiz rounds and Space Points. Logged in, a round is checked by Astryl's server ("quiz" function) and
   earns points for the Space Points leaderboard; without an account the same rounds are practice.
   The questions come from assets/quiz-bank.js (tools/quizbank.py). */
(function () {
  var box = document.getElementById('rounds');
  var QB = window.ASTRYL_QB, API = window.ASTRYL_API, ACCT = window.ASTRYL_ACCT;
  if (!box || !QB || !API) return;
  var URL = 'https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/quiz';
  var ORDER = ['photo', 'cons', 'missions', 'hl', 'est', 'easy', 'medium', 'hard'];
  var LEVELS = [[0, '🧑‍🚀', 'Cadet', 'कैडेट'], [200, '✈️', 'Pilot', 'पायलट'], [600, '🧭', 'Navigator', 'नेविगेटर'], [1500, '👩‍🚀', 'Astronaut', 'अंतरिक्ष यात्री'], [3500, '🚀', 'Commander', 'कमांडर'], [7000, '🌌', 'Galaxy Explorer', 'गैलेक्सी खोजी']];
  var BADGES = [['photo', '📷', 'Photo expert: 10/10 photos', 'फ़ोटो उस्ताद: 10/10 तस्वीरें'], ['cons', '⭐', 'Star gazer: 10/10 constellations', 'तारा-दर्शक: 10/10 नक्षत्र'], ['missions', '🛰️', 'Space historian: 10/10', 'अंतरिक्ष इतिहासकार: 10/10'], ['hl', '⚖️', 'Sharp eye: 10/10 bigger or smaller', 'तेज़ नज़र: बड़ा-छोटा 10/10'], ['est', '🎯', 'Great guesser: 40+ points', 'शानदार अंदाज़ा: 40+ points']];
  var root = document.body.getAttribute('data-root') || '';
  function hi() { return API.lang() === 'hi'; }
  function L(p) { return p ? (hi() ? p[1] : p[0]) : ''; }
  function esc(x) { return String(x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function get(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } }
  function set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { } }
  function n(v) { return Number(v).toLocaleString(hi() ? 'hi-IN' : 'en-US'); }
  function rnd(a) { return a[Math.floor(Math.random() * a.length)]; }
  function shuffle(a) { a = a.slice(); for (var i = a.length - 1; i > 0; i--) { var j = Math.floor(Math.random() * (i + 1)); var x = a[i]; a[i] = a[j]; a[j] = x; } return a; }
  function session() { return ACCT && ACCT.session && ACCT.session(); }
  function call(action, body, auth) {
    var go = function (tok) {
      var h = { 'Content-Type': 'application/json' }; if (tok) h['x-astryl-token'] = tok;
      return fetch(URL, { method: 'POST', headers: h, body: JSON.stringify(Object.assign({ action: action }, body || {})) }).then(function (r) {
        return r.json().catch(function () { return {}; }).then(function (j) { if (!r.ok) throw new Error((j && j.error) || 'server_error'); return j; });
      });
    };
    if (auth && ACCT && session()) return ACCT.token().then(go);
    return go(null);
  }
  function levelOf(p) { var l = LEVELS[0], next = null; for (var i = 0; i < LEVELS.length; i++) { if (p >= LEVELS[i][0]) l = LEVELS[i]; else { next = LEVELS[i]; break; } } return { l: l, next: next }; }
  function closeness(g, it) {
    var a = Number(it.a);
    if (!isFinite(g)) return 0;
    if (it.log) { if (g <= 0) return 0; var r = Math.max(g / a, a / g); return r <= 1.1 ? 10 : r <= 1.25 ? 8 : r <= 1.5 ? 6 : r <= 2 ? 4 : r <= 3 ? 2 : 0; }
    var d = Math.abs(g - a) / (it.max - it.min); return d <= 0.02 ? 10 : d <= 0.05 ? 8 : d <= 0.1 ? 6 : d <= 0.2 ? 4 : d <= 0.3 ? 2 : 0;
  }
  function item(kind, id) { var list = QB[kind].items; for (var i = 0; i < list.length; i++) if (list[i].id === id) return list[i]; return null; }
  function label(kind, key, it) {
    if (kind === 'cons') return L(QB.cons.names[key]);
    if (kind === 'missions') return L(it.o[+key]);
    return API.bname(key);
  }
  function question(kind, it) {
    if (it.qk) return API.t(it.qk);
    if (kind === 'photo') return hi() ? 'यह कौन-सी दुनिया है?' : 'Which world is this?';
    if (kind === 'cons') return hi() ? 'यह कौन-सा नक्षत्र है? (उत्तर ऊपर, पूर्व बाएँ)' : 'Which constellation is this? (north up, east left)';
    return L(it.q);
  }
  function explain(kind, it, answer) {
    if (it.ex) return L(it.ex);
    if (kind === 'cons') return (hi() ? 'यह ' : 'This is ') + L(QB.cons.names[answer]) + ' (' + answer + ').' + (hi() ? ' नक्षत्रों के page पर इसका पूरा नक्शा देखिए।' : ' See it on the constellations page.');
    var cap = answer.charAt(0).toUpperCase() + answer.slice(1), f = API.t('fact' + cap + '1');
    return API.bname(answer) + (f && f.indexOf('fact') !== 0 ? ': ' + f : '');
  }
  function fmtVal(v) {
    var a = Math.abs(v);
    return a >= 100 ? n(Math.round(v)) : a >= 10 ? (Math.round(v * 10) / 10).toLocaleString(hi() ? 'hi-IN' : 'en-US') : (Math.round(v * 100) / 100).toLocaleString(hi() ? 'hi-IN' : 'en-US');
  }
  function sliderToVal(it, s) { var f = s / 1000; return it.log ? Math.pow(10, Math.log10(it.min) + f * (Math.log10(it.max) - Math.log10(it.min))) : it.min + f * (it.max - it.min); }

  /* ---------- state ---------- */
  var S = { view: 'home', board: null, tab: 'week', points: get('astryl-points', null) };
  var R = null; // the round being played

  function homeHtml() {
    var me = session(), pts = S.points, h = '';
    if (me && pts) {
      var lv = levelOf(pts.total), prog = lv.next ? (pts.total - lv.l[0]) / (lv.next[0] - lv.l[0]) : 1;
      h += '<div class="card ptscard"><div class="ptshead"><span class="ptslv">' + lv.l[1] + '</span><div><b>' + esc(L([lv.l[2], lv.l[3]])) + '</b><br><small>' + n(pts.total) + ' ' + (hi() ? 'Space Points कुल' : 'Space Points in all') + ' · ' + n(pts.week || 0) + ' ' + (hi() ? 'इस हफ़्ते' : 'this week') + '</small></div></div>' +
        '<div class="progress"><i style="width:' + Math.round(prog * 100) + '%"></i></div><p class="note" style="margin:6px 0 0">' + (lv.next ? (hi() ? lv.next[1] + ' ' + lv.next[3] + ' तक ' + n(lv.next[0] - pts.total) + ' points और' : n(lv.next[0] - pts.total) + ' more points to ' + lv.next[1] + ' ' + lv.next[2]) : (hi() ? 'सबसे ऊँचा level!' : 'Top level!')) + '</p></div>';
    } else if (me) {
      h += '<div class="card ptscard"><b>🧑‍🚀 ' + (hi() ? 'हर round से Space Points कमाइए' : 'Earn Space Points with every round') + '</b><p class="note" style="margin:4px 0 0">' + (hi() ? 'हर सही जवाब 10 points, पूरे सही round पर 5 बोनस। हर तरह के round के रोज़ पहले 5 round गिने जाते हैं।' : 'Each right answer is 10 points, plus 5 for a perfect round. The first 5 rounds of each kind count every day.') + '</p></div>';
    } else {
      h += '<div class="card ptscard"><b>🏆 ' + (hi() ? 'Leaderboard में आइए' : 'Get on the leaderboard') + '</b><p class="note" style="margin:4px 0 8px">' + (hi() ? 'बिना खाते के ये rounds अभ्यास हैं। Log in करके हर सही जवाब पर Space Points कमाइए।' : 'Without an account these rounds are practice. Log in to earn Space Points for every right answer.') + '</p><a class="btn primary" href="' + root + 'account.html?mode=login">' + (hi() ? 'Log in / खाता बनाएँ' : 'Log in / Create account') + '</a></div>';
    }
    h += '<div class="grid rounds">';
    ORDER.forEach(function (k) {
      var r = QB[k]; if (!r) return;
      h += '<button type="button" class="card roundcard" data-round="' + k + '"><span class="ric">' + r.icon + '</span><b>' + esc(L(r.name)) + '</b><small>' + esc(L(r.desc)) + '</small><small class="rn">' + r.n + (hi() ? ' सवाल' : ' questions') + '</small></button>';
    });
    var mis = get('astryl-mistakes', []);
    h += '<button type="button" class="card roundcard" data-round="mistakes"' + (mis.length ? '' : ' disabled') + '><span class="ric">🔁</span><b>' + (hi() ? 'मेरी ग़लतियाँ' : 'My mistakes') + '</b><small>' + (mis.length ? (hi() ? mis.length + ' सवाल दोबारा करें' : 'Try ' + mis.length + ' questions again') : (hi() ? 'अभी कोई नहीं' : 'None yet')) + '</small><small class="rn">' + (hi() ? 'अभ्यास' : 'practice') + '</small></button></div>';
    var got = get('astryl-rbadges', {});
    h += '<div class="card" style="margin-top:14px"><b>🏅 ' + (hi() ? 'Round badges' : 'Round badges') + '</b><div class="rbadges">' + BADGES.map(function (b) { return '<span class="' + (got[b[0]] ? 'on' : '') + '">' + b[1] + ' ' + esc(L([b[2], b[3]])) + '</span>'; }).join('') + '</div></div>';
    h += boardHtml();
    return h;
  }
  function boardHtml() {
    var b = S.board, h = '<div class="card" style="margin-top:14px"><h3 style="margin:0 0 8px">🏆 ' + (hi() ? 'Space Points leaderboard' : 'Space Points leaderboard') + '</h3><div class="tabs"><button type="button" class="' + (S.tab === 'week' ? 'on' : '') + '" data-tab="week">' + (hi() ? 'इस हफ़्ते' : 'This week') + '</button><button type="button" class="' + (S.tab === 'all' ? 'on' : '') + '" data-tab="all">' + (hi() ? 'अब तक' : 'All time') + '</button></div>';
    if (!b) return h + '<p class="note">' + (hi() ? 'Load हो रहा है…' : 'Loading…') + '</p></div>';
    var rows = (S.tab === 'week' ? b.week : b.all) || [], mine = session() ? session().username : '';
    if (!rows.length) h += '<p class="note">' + (hi() ? 'अभी कोई नहीं। पहले बनिए!' : 'Nobody yet. Be the first!') + '</p>';
    else h += '<ol class="lb">' + rows.map(function (r) { var lv = levelOf(S.tab === 'all' ? r.p : 0); return '<li' + (r.u === mine ? ' class="me"' : '') + '><span class="nm">' + (S.tab === 'all' ? lv.l[1] + ' ' : '') + esc(r.u) + '</span><b>' + n(r.p) + '</b></li>'; }).join('') + '</ol>';
    if (b.me) { var rk = S.tab === 'week' ? b.me.rank_week : b.me.rank_all; if (rk) h += '<p class="note"><b>' + (hi() ? 'आपका rank: ' + rk : 'Your rank: ' + rk) + '</b></p>'; }
    return h + '</div>';
  }
  function loadBoard() {
    call('board', {}, true).then(function (j) {
      S.board = j;
      if (j && j.me) { S.points = { total: j.me.total || 0, week: j.me.week || 0 }; set('astryl-points', S.points); }
      if (S.view === 'home') draw();
    }).catch(function () { S.board = { week: [], all: [] }; if (S.view === 'home') draw(); });
  }

  /* ---------- playing ---------- */
  function start(kind) {
    var practice = kind === 'mistakes' || !session();
    if (kind === 'mistakes') {
      var mis = shuffle(get('astryl-mistakes', [])).slice(0, 10);
      R = { kind: 'mistakes', practice: true, qs: mis.map(function (m) { var it = item(m.k, m.id); return it ? { kind: m.k, it: it, keys: keysFor(m.k, it) } : null; }).filter(Boolean), i: 0, answers: [], total: 0 };
      if (!R.qs.length) return;
      S.view = 'play'; draw(); return;
    }
    if (practice) {
      R = { kind: kind, practice: true, qs: shuffle(QB[kind].items).slice(0, QB[kind].n).map(function (it) { return { kind: kind, it: it, keys: keysFor(kind, it) }; }), i: 0, answers: [], total: 0 };
      S.view = 'play'; draw(); return;
    }
    S.view = 'loading'; draw();
    call('start', { kind: kind }, true).then(function (j) {
      R = { kind: kind, practice: false, run: j.run, qs: j.questions.map(function (q) { return { kind: kind, it: item(kind, q.id), keys: q.keys }; }), i: 0, answers: [], total: 0, t0: Date.now() };
      S.view = 'play'; draw();
    }).catch(function (e) {
      // offline or a server problem: play it as practice
      R = { kind: kind, practice: true, note: e.message === 'rate_limited' ? 'rate' : 'offline', qs: shuffle(QB[kind].items).slice(0, QB[kind].n).map(function (it) { return { kind: kind, it: it, keys: keysFor(kind, it) }; }), i: 0, answers: [], total: 0 };
      S.view = 'play'; draw();
    });
  }
  function keysFor(kind, it) {
    if (it.o) return kind === 'missions' ? shuffle(['0', '1', '2', '3']) : shuffle(it.o);
    if (it.pool) {
      var pool = it.pool === '*' ? QB[kind].items.map(function (x) { return x.a; }).filter(function (x) { return x !== it.a; }) : it.pool;
      return shuffle([it.a].concat(shuffle(pool).slice(0, 3)));
    }
    return [];
  }
  function rightOf(q) { return q.kind === 'missions' ? '0' : q.it.a; }
  function playHtml() {
    var q = R.qs[R.i], it = q.it, done = R.answers.length > R.i, ans = done ? R.answers[R.i] : null, h = '';
    h += '<div class="rhead"><span class="note">' + esc(L(QB[q.kind].name)) + ' · ' + (R.i + 1) + '/' + R.qs.length + (R.practice ? ' · ' + (hi() ? 'अभ्यास' : 'practice') : ' · 🏆 ' + n(R.total) + ' pts') + '</span><button type="button" class="linkbtn" data-act="quit">' + (hi() ? 'छोड़ें' : 'Quit') + '</button></div>';
    h += '<div class="progress" style="margin:6px 0 12px"><i style="width:' + Math.round((R.i + (done ? 1 : 0)) / R.qs.length * 100) + '%"></i></div>';
    if (R.note === 'offline' && R.i === 0) h += '<p class="note">⚠️ ' + (hi() ? 'Server तक नहीं पहुँच पाए, इसलिए यह round अभ्यास है।' : 'Could not reach the server, so this round is practice.') + '</p>';
    if (R.note === 'rate' && R.i === 0) h += '<p class="note">⚠️ ' + (hi() ? 'एक घंटे में बहुत सारे rounds; यह round अभ्यास है।' : 'Too many rounds in an hour; this one is practice.') + '</p>';
    h += '<h2 class="rq">' + esc(question(q.kind, it)) + '</h2>';
    if (it.img) h += '<div class="rimg"><img src="' + root + it.img + '" alt="?" width="300" height="300"></div>';
    if (it.svg) h += '<div class="rsvg">' + it.svg + '</div>';
    if (q.kind === 'est') {
      var s = ans ? ans.slider : 500, v = sliderToVal(it, s);
      h += '<div class="est"><input type="range" min="0" max="1000" step="1" value="' + s + '" id="estR"' + (done ? ' disabled' : '') + ' aria-label="Your guess"><div class="estv"><b id="estV">' + fmtVal(v) + '</b> ' + esc(L(it.unit)) + '</div>';
      if (!done) h += '<button type="button" class="btn primary" data-act="lock">' + (hi() ? 'यही मेरा अंदाज़ा' : 'Lock in my guess') + '</button>';
      h += '</div>';
      if (done) h += '<p><b class="' + (ans.s >= 6 ? 'ok' : 'no') + '">' + (hi() ? 'सही जवाब: ' : 'The answer: ') + fmtVal(it.a) + ' ' + esc(L(it.unit)) + ' · +' + ans.s + ' pts</b></p>';
    } else {
      q.keys.forEach(function (k) {
        var cls = done ? (k === rightOf(q) || k === String(ans.a) ? ' right' : (k === ans.pick ? ' wrong' : '')) : '';
        h += '<button type="button" class="opt' + cls + '" data-pick="' + esc(k) + '"' + (done ? ' disabled' : '') + '>' + esc(label(q.kind, k, it)) + '</button>';
      });
      if (done) h += '<p><b class="' + (ans.ok ? 'ok' : 'no') + '">' + (ans.ok ? (hi() ? '✅ सही!' : '✅ Right!') : (hi() ? '❌ सही जवाब: ' : '❌ The answer: ') + esc(label(q.kind, String(ans.a), it))) + '</b>' + (ans.fast ? ' <small class="note">' + (hi() ? '(बहुत तेज़, points नहीं)' : '(too fast, no points)') + '</small>' : '') + '</p>';
    }
    if (done) h += '<div class="card rex">💡 ' + esc(explain(q.kind, it, q.kind === 'est' ? '' : String(ans.a))) + '</div><button type="button" class="btn primary" data-act="next">' + (R.i + 1 < R.qs.length ? (hi() ? 'अगला →' : 'Next →') : (hi() ? 'नतीजा देखें' : 'See the result')) + '</button>';
    return h;
  }
  function record(q, ans) {
    var mis = get('astryl-mistakes', []), key = q.kind + '|' + q.it.id;
    mis = mis.filter(function (m) { return m.k + '|' + m.id !== key; });
    if (!ans.ok) mis.unshift({ k: q.kind, id: q.it.id });
    set('astryl-mistakes', mis.slice(0, 60));
  }
  function answer(pick) {
    var q = R.qs[R.i];
    if (R.answers.length > R.i || R.busy) return;
    var local = function () {
      var a = q.kind === 'missions' ? '0' : q.it.a, ok, s;
      if (q.kind === 'est') { s = closeness(pick.v, q.it); ok = s >= 6; } else { ok = pick === String(a); s = ok ? 10 : 0; }
      return { ok: ok, a: q.kind === 'missions' ? '0' : a, s: s };
    };
    var finish = function (res) {
      var ans = { pick: q.kind === 'est' ? null : pick, slider: q.kind === 'est' ? pick.s : null, ok: res.ok, a: res.a, s: res.s, fast: res.fast };
      R.answers[R.i] = ans; R.total += res.s; R.busy = false; record(q, ans); draw();
    };
    if (R.practice) { finish(local()); return; }
    R.busy = true;
    call('answer', { run: R.run, i: R.i, pick: q.kind === 'est' ? pick.v : pick }, true).then(finish).catch(function () { R.practice = true; R.note = 'offline'; finish(local()); });
  }
  function endHtml() {
    var right = R.answers.filter(function (a) { return a.ok; }).length, h = '<div class="card" style="text-align:center"><div class="life">' + (R.kind === 'est' ? n(R.total) + ' pts' : right + ' / ' + R.qs.length) + '</div>';
    if (R.result) {
      var res = R.result, lv = levelOf(res.total);
      h += '<p><b class="ok">+' + n(res.points) + ' Space Points</b>' + (res.perfect ? ' · ' + (hi() ? 'पूरा सही! +5 बोनस' : 'perfect round! +5 bonus') : '') + '</p>';
      if (res.capped) h += '<p class="note">' + (hi() ? 'आज इस तरह के 5 rounds गिने जा चुके हैं; कल फिर points मिलेंगे।' : 'Five rounds of this kind already counted today; points again tomorrow.') + '</p>';
      h += '<p>' + lv.l[1] + ' <b>' + esc(L([lv.l[2], lv.l[3]])) + '</b> · ' + n(res.total) + ' ' + (hi() ? 'कुल' : 'in all') + '</p>';
    } else if (R.finishing) h += '<p class="note">⏳</p>';
    else if (R.practice) h += '<p class="note">' + (session() ? (hi() ? 'यह अभ्यास round था।' : 'This was a practice round.') : (hi() ? 'अभ्यास round। <a href="' + root + 'account.html?mode=login">Log in</a> करके points कमाइए।' : 'Practice round. <a href="' + root + 'account.html?mode=login">Log in</a> to earn points.')) + '</p>';
    h += '<div class="btns" style="justify-content:center"><button type="button" class="btn primary" data-act="again">' + (hi() ? 'फिर से खेलें' : 'Play again') + '</button><button type="button" class="btn" data-act="home">' + (hi() ? 'सभी rounds' : 'All rounds') + '</button></div></div>';
    return h;
  }
  function end() {
    S.view = 'end';
    var right = R.answers.filter(function (a) { return a.ok; }).length;
    if (R.kind !== 'mistakes') {
      var got = get('astryl-rbadges', {});
      if ((R.kind === 'est' && R.total >= 40) || (R.kind !== 'est' && right === R.qs.length && R.qs.length >= 10)) { got[R.kind] = Date.now(); set('astryl-rbadges', got); }
    }
    if (!R.practice) {
      R.finishing = true;
      call('finish', { run: R.run }, true).then(function (j) {
        R.result = j; R.finishing = false; S.points = { total: j.total, week: j.week }; set('astryl-points', S.points); draw(); loadBoard();
      }).catch(function () { R.finishing = false; R.practice = true; draw(); });
    }
    draw();
  }

  function draw() {
    if (S.view === 'home') box.innerHTML = homeHtml();
    else if (S.view === 'loading') box.innerHTML = '<p class="note">⏳ ' + (hi() ? 'Round तैयार हो रहा है…' : 'Getting the round ready…') + '</p>';
    else if (S.view === 'play') box.innerHTML = playHtml();
    else if (S.view === 'end') box.innerHTML = endHtml();
    var r = document.getElementById('estR');
    if (r) r.oninput = function () { document.getElementById('estV').textContent = fmtVal(sliderToVal(R.qs[R.i].it, +r.value)); };
  }
  box.addEventListener('click', function (e) {
    var el = e.target.closest('[data-round],[data-pick],[data-act],[data-tab]'); if (!el) return;
    if (el.dataset.round) { start(el.dataset.round); box.scrollIntoView({ block: 'start', behavior: 'smooth' }); }
    else if (el.dataset.tab) { S.tab = el.dataset.tab; draw(); }
    else if (el.dataset.pick !== undefined) answer(el.dataset.pick);
    else if (el.dataset.act === 'lock') { var s = +document.getElementById('estR').value; answer({ s: s, v: sliderToVal(R.qs[R.i].it, s) }); }
    else if (el.dataset.act === 'next') { if (R.i + 1 < R.qs.length) { R.i++; draw(); } else end(); }
    else if (el.dataset.act === 'quit' || el.dataset.act === 'home') { S.view = 'home'; R = null; draw(); }
    else if (el.dataset.act === 'again') start(R.kind);
  });
  API.onRender(draw);
  draw(); loadBoard();
  window.ASTRYL_ROUNDS = { closeness: closeness, levelOf: levelOf };
})();
