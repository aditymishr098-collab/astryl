/* Astryl website: the optional online account, the public counter and the
   sign-up banner. Everything here is optional: the site works the same for
   a visitor who never makes an account. The only key used is the public
   (publishable) one; the database is reachable only through the "account"
   function, which checks who is asking. */
(function () {
  'use strict';
  var API = 'https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/account';
  var KEY = 'sb_publishable_2q49HssjpFg-5dnCRVBCSw_4O3cY8yH';
  var REPO = 'aditymishr098-collab/astryl';
  var D = window.ASTRYL || { L: { en: {}, hi: {} } };
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var ROOT = document.body.dataset.root || '';

  var store = {
    get: function (k) { try { return localStorage.getItem(k); } catch (e) { return null; } },
    set: function (k, v) { try { localStorage.setItem(k, v); } catch (e) {} },
    del: function (k) { try { localStorage.removeItem(k); } catch (e) {} }
  };
  function lang() { return document.documentElement.lang === 'hi' ? 'hi' : 'en'; }
  function t(key, params) {
    var s = (D.L[lang()] && D.L[lang()][key]) || D.L.en[key] || key;
    if (params) for (var k in params) s = s.split('{' + k + '}').join(params[k]);
    return s;
  }
  var W = {
    en: {
      bannerLater: 'Not now', statsTitle: 'Astryl in numbers', statsRegistered: 'Accounts', statsActive: 'Active users (30 days)',
      statsCountries: 'Top countries',
      statsNote: 'Active means people who chose to be counted.',
      webNote: 'Your language, theme, quiz scores, lessons read and the things you have seen sync with your account.',
      loading: 'Loading…', showPassword: 'Show password',
      statsViews: 'Page views (30 days)', statsVisitors: 'Visitors (30 days)',
      barLocText: 'Share your approximate place (about 10 km) so we can see where Astryl is used? Only a rounded point is added to a count; nothing else is sent and it is not tied to you.', barLocYes: 'Share', barLocNo: 'No thanks', barClose: 'Close', barNews: 'News',
      boardTitle: 'Daily 5', boardIntro: 'The same 5 questions for everybody, every day (UTC). Right answers and speed make your score.',
      boardLogin: 'Log in to play today\'s 5 and join the leaderboard.', boardPlay: 'Play today\'s 5', boardTimerNote: 'The clock starts when you press play.',
      boardQ: 'Question {n} of 5', boardSubmitting: 'Checking your answers…', boardDone: 'Today\'s result', boardPoints: '{p} points', boardRight: '{c} of 5 right',
      boardTime: '{s} s', boardRank: 'Your rank today: {r} of {n}', boardRankAll: 'All-time rank: {r}', boardToday: 'Today', boardAll: 'All time', boardEmpty: 'Nobody yet. Be the first.',
      boardHidden: 'You are hidden from the leaderboard. You can change this in your account.', boardBack: 'Come back tomorrow for 5 new questions.',
      boardTitleLb: 'Leaderboard', boardDays: '{d} days', boardErr: 'Could not reach the server. Try again in a moment.', boardReview: 'Your answers', boardYours: 'You',
      boardShow: 'Show me on the leaderboard', boardShowNote: 'Shows only your username and score. On by default; switch it off to hide.',
      boardShare: 'Share as a picture', boardShareText: 'I scored {p} points on today\'s Astryl Daily 5!',
      boardWeek: 'This week', boardRankWeek: 'Your rank this week: {r}', streakNow: '{n}-day streak', streakNone: 'No streak yet. Play today to start one.', streakBest: 'Best: {n}',
      badgesTitle: 'Badges', bdFirst: 'First run', bdS3: '3-day streak', bdS7: '7-day streak', bdS30: '30-day streak', bdPerfect: 'Perfect 5 of 5', bdP10: '10 runs', bdP50: '50 runs',
      welcomeTitle: 'Welcome to Astryl', welcomeSub: 'Make a free account to keep your favourites, quiz scores and rank on every device. Or just look around.', welcomeSkip: 'Continue without account',
      avatarChoose: 'Choose a photo', avatarChange: 'Change photo', avatarRemove: 'Remove photo', avatarNote: 'Shown only on your own profile (not on the leaderboard). A small square picture, saved in your Astryl account.', avatarFail: 'The photo could not be saved. Try a different picture.',
      webIntro: 'Optional. A username and a password, no e-mail. Your favourites, quiz scores and settings then follow you on every device.'
    },
    hi: {
      bannerLater: 'अभी नहीं', statsTitle: 'Astryl आँकड़ों में', statsRegistered: 'खाते', statsActive: 'Active users (30 दिन)',
      statsCountries: 'शीर्ष देश',
      statsNote: 'Active यानी वे लोग जिन्होंने गिने जाना चुना है।',
      webNote: 'आपकी भाषा, theme, quiz scores, पढ़े हुए पाठ और जो चीज़ें आपने देखी हैं, आपके खाते के साथ sync होते हैं।',
      loading: 'Loading…', showPassword: 'Password दिखाएँ',
      statsViews: 'Page views (30 दिन)', statsVisitors: 'Visitors (30 दिन)',
      barLocText: 'क्या आप अपनी अनुमानित जगह (लगभग 10 km) बताएँगे, ताकि हम देख सकें कि Astryl कहाँ इस्तेमाल होता है? गिनती में सिर्फ़ एक गोल किया हुआ बिंदु जुड़ता है; और कुछ नहीं जाता और यह आपसे जुड़ा नहीं होता।', barLocYes: 'बताएँ', barLocNo: 'अभी नहीं', barClose: 'बंद करें', barNews: 'ख़बर',
      boardTitle: 'Daily 5', boardIntro: 'हर दिन सबके लिए वही 5 सवाल (UTC)। सही जवाब और तेज़ी से आपका score बनता है।',
      boardLogin: 'आज के 5 खेलने और leaderboard में आने के लिए log in कीजिए।', boardPlay: 'आज के 5 खेलिए', boardTimerNote: 'Play दबाते ही घड़ी चालू हो जाती है।',
      boardQ: 'सवाल {n} / 5', boardSubmitting: 'जवाब जाँचे जा रहे हैं…', boardDone: 'आज का नतीजा', boardPoints: '{p} अंक', boardRight: '5 में से {c} सही',
      boardTime: '{s} सेकंड', boardRank: 'आज आपकी रैंक: {r} / {n}', boardRankAll: 'कुल रैंक: {r}', boardToday: 'आज', boardAll: 'कुल', boardEmpty: 'अभी कोई नहीं। पहले आप बनिए।',
      boardHidden: 'आप leaderboard से छिपे हैं। इसे अपने खाते में बदल सकते हैं।', boardBack: 'कल 5 नए सवालों के लिए आइए।',
      boardTitleLb: 'Leaderboard', boardDays: '{d} दिन', boardErr: 'Server से संपर्क नहीं हो पाया। थोड़ी देर में फिर कोशिश कीजिए।', boardReview: 'आपके जवाब', boardYours: 'आप',
      boardShow: 'मुझे leaderboard में दिखाएँ', boardShowNote: 'सिर्फ़ आपका username और score दिखता है। डिफ़ॉल्ट रूप से चालू; छिपने के लिए बंद कीजिए।',
      boardShare: 'तस्वीर बनाकर share करें', boardShareText: 'मैंने आज Astryl के Daily 5 में {p} अंक लिए!',
      boardWeek: 'इस हफ़्ते', boardRankWeek: 'इस हफ़्ते आपकी रैंक: {r}', streakNow: '{n} दिन की streak', streakNone: 'अभी कोई streak नहीं। आज खेलकर शुरू कीजिए।', streakBest: 'सबसे लंबी: {n}',
      badgesTitle: 'Badges', bdFirst: 'पहला खेल', bdS3: '3 दिन की streak', bdS7: '7 दिन की streak', bdS30: '30 दिन की streak', bdPerfect: '5 में से 5 सही', bdP10: '10 खेल', bdP50: '50 खेल',
      welcomeTitle: 'Astryl में स्वागत है', welcomeSub: 'मुफ़्त खाता बनाइए, ताकि आपके favourites, quiz scores और rank हर device पर साथ रहें। या बस घूमकर देखिए।', welcomeSkip: 'बिना खाते के आगे बढ़ें',
      avatarChoose: 'फ़ोटो चुनें', avatarChange: 'फ़ोटो बदलें', avatarRemove: 'फ़ोटो हटाएँ', avatarNote: 'सिर्फ़ आपकी अपनी profile पर दिखती है (leaderboard पर नहीं)। एक छोटी चौकोर तस्वीर, आपके Astryl account में सेव होती है।', avatarFail: 'फ़ोटो सेव नहीं हो सकी। कोई दूसरी तस्वीर आज़माइए।',
      webIntro: 'ज़रूरी नहीं। बस एक username और password, e-mail नहीं। फिर आपके favourites, quiz scores और settings हर device पर आपके साथ चलते हैं।'
    }
  };
  function w(key) { return (W[lang()] || W.en)[key] || W.en[key] || key; }
  function esc(s) { return String(s).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function onLang(fn) {
    new MutationObserver(fn).observe(document.documentElement, { attributes: true, attributeFilter: ['lang'] });
  }
  function fail(code, status) { var e = new Error(code); e.code = code; e.status = status || 0; return e; }

  /* ---------- the function ---------- */
  function api(action, body, token) {
    var h = { 'Content-Type': 'application/json', 'apikey': KEY };
    if (token) h['x-astryl-token'] = token;
    var p;
    try {
      p = fetch(API, { method: 'POST', headers: h, body: JSON.stringify(Object.assign({}, body || {}, { action: action })) });
    } catch (e) { return Promise.reject(fail('offline')); }
    return p.then(function (r) {
      return r.json().catch(function () { return {}; }).then(function (j) {
        if (r.ok) return j;
        throw fail((j && j.error) || 'server_error', r.status);
      });
    }, function () { throw fail('offline'); });
  }
  function errText(e) {
    var map = { offline: 'acctErrOffline', username_taken: 'acctErrTaken', bad_username: 'acctErrUsername', bad_password: 'acctErrPassword',
      bad_login: 'acctErrLogin', bad_recovery: 'acctErrRecovery', code_used_up: 'acctErrUsedUp', locked: 'acctErrLocked', rate_limited: 'acctErrRate' };
    return t(map[e && e.code] || 'acctErrGeneric');
  }

  /* ---------- what is kept in this browser ---------- */
  function getSession() { try { return JSON.parse(store.get('astryl-session') || 'null'); } catch (e) { return null; } }
  function setSession(s) { store.set('astryl-session', JSON.stringify(s)); store.set('astryl-gate', '1'); }
  function clearSession() { store.del('astryl-session'); store.del('astryl-avatar'); }
  function getPrefs() {
    var p = {};
    try { p = JSON.parse(store.get('astryl-acct') || '{}') || {}; } catch (e) {}
    return { syncOn: p.syncOn !== false, showOnBoard: p.showOnBoard !== false, countMe: p.countMe === true, shareCountry: p.shareCountry === true, syncedMs: p.syncedMs || 0, lastPing: p.lastPing || 0 };
  }
  function setPrefs(p) { store.set('astryl-acct', JSON.stringify(p)); }
  function patchPrefs(o) { var p = Object.assign(getPrefs(), o); setPrefs(p); return p; }
  function deviceId() {
    var id = store.get('astryl-device');
    if (!id || !/^[A-Za-z0-9-]{8,64}$/.test(id)) {
      var a = new Uint8Array(16); (window.crypto || window.msCrypto).getRandomValues(a);
      id = Array.prototype.map.call(a, function (b) { return ('0' + b.toString(16)).slice(-2); }).join('');
      store.set('astryl-device', id);
    }
    return id;
  }
  function country() {
    var m = /[-_]([A-Za-z]{2})$/.exec(navigator.language || '');
    return m ? m[1].toUpperCase() : null;
  }
  function toSession(j, username) {
    var s = j && j.session;
    if (!s || !s.access_token) throw fail('server_error');
    return { access: s.access_token, refresh: s.refresh_token, expiresAt: s.expires_at || (Date.now() / 1000 + 3000), username: username };
  }
  function token() {
    var s = getSession();
    if (!s) return Promise.reject(fail('no_token'));
    if (s.expiresAt - 60 > Date.now() / 1000) return Promise.resolve(s.access);
    return api('refresh', { refresh_token: s.refresh }).then(function (j) {
      var n = toSession(j, s.username); setSession(n); return n.access;
    }, function (e) { if (e.status === 401) clearSession(); throw e; });
  }

  /* ---------- sync: language, theme and quiz scores ---------- */
  var LEVELS = ['easy', 'medium', 'hard'];
  function canon(v) {
    if (Array.isArray(v)) return '[' + v.map(canon).join(',') + ']';
    if (v && typeof v === 'object') return '{' + Object.keys(v).sort().map(function (k) { return JSON.stringify(k) + ':' + canon(v[k]); }).join(',') + '}';
    return JSON.stringify(v);
  }
  var syncing = false, syncStatus = 'idle';
  function sync() {
    var p = getPrefs();
    if (!getSession() || !p.syncOn || syncing) return Promise.resolve(false);
    syncing = true; syncStatus = 'syncing'; redraw();
    var tk, reload = false;
    return token().then(function (k) { tk = k; return api('pull', {}, k); }).then(function (res) {
      if (res.prefs && typeof res.prefs.showOnBoard === 'boolean') patchPrefs({ showOnBoard: res.prefs.showOnBoard });
      var remote = res.data && typeof res.data === 'object' && !Array.isArray(res.data) ? res.data : null;
      var remoteWins = !!remote && (res.updatedMs || 0) > p.syncedMs;
      var merged = Object.assign({ v: 1 }, remote || {});
      var rb = (remote && remote.quizBests) || {}, mb = {};
      LEVELS.concat(Object.keys(rb)).forEach(function (l) {
        var local = parseInt(store.get('astryl-best-' + l) || '0', 10) || 0, far = parseInt(rb[l], 10) || 0, best = Math.max(local, far);
        if (best > 0) mb[l] = best;
        if (best > local && LEVELS.indexOf(l) >= 0) store.set('astryl-best-' + l, String(best));
      });
      merged.quizBests = mb;
      mergeWeb(merged, remote, remoteWins);
      var lc = store.get('astryl-lang'), th = store.get('astryl-theme');
      if (remoteWins) {
        if ((remote.locale === 'en' || remote.locale === 'hi') && (!lc || lc === 'en' || lc === 'hi') && remote.locale !== (lc || '')) { store.set('astryl-lang', remote.locale); reload = true; }
        if (remote.theme === 'dark' || remote.theme === 'light') {
          if (remote.theme !== th) { store.set('astryl-theme', remote.theme); reload = true; }
        } else if (remote.theme === 'system' && th) { store.del('astryl-theme'); reload = true; }
      } else {
        if (lc === 'en' || lc === 'hi') merged.locale = lc;
        if (th) merged.theme = th;
      }
      var done = function (ms) {
        patchPrefs({ syncedMs: ms });
        syncStatus = 'ok';
        if (reload) { location.reload(); }
      };
      if (!remote || canon(remote) !== canon(merged)) {
        return api('push', { data: merged }, tk).then(function (r) { done(r.updatedMs || Date.now()); return true; });
      }
      done(res.updatedMs || 0); return true;
    }).catch(function () { syncStatus = 'failed'; return false; }).then(function (ok) { syncing = false; redraw(); return ok; });
  }
  /* Favourites and website progress (the "web" part, which other clients keep
     but does not use). Best scores and lessons read are joined, so nothing is lost either way. */
  function readJson(k, d) { try { var v = store.get(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } }
  function mergeWeb(merged, remote, remoteWins) {
    var localFav = readJson('astryl-favs', []), remoteFav = remote && Array.isArray(remote.favorites) ? remote.favorites : [];
    if (!Array.isArray(localFav)) localFav = [];
    var fav = [];
    // When the account is newer, its favourites are added to this browser's; otherwise this
    // browser's list wins, so a star removed here stays removed.
    (remoteWins || !p0().syncedMs ? remoteFav.concat(localFav) : localFav).forEach(function (f) { if (typeof f === 'string' && fav.indexOf(f) < 0) fav.push(f); });
    fav = fav.slice(-60);
    merged.favorites = fav;
    store.set('astryl-favs', JSON.stringify(fav));
    var rw = remote && remote.web && typeof remote.web === 'object' ? remote.web : {}, web = { ds: {}, bh101: [] };
    // Deep space quiz bests: kept as quizBests "ds-bh", "ds-gx", "ds-all".
    var qb = merged.quizBests || (merged.quizBests = {});
    ['bh', 'gx', 'all'].forEach(function (k) {
      var local = parseInt(readJson('astryl-ds-best-' + k, 0), 10) || 0, far = Math.max(parseInt(rw.ds && rw.ds[k], 10) || 0, parseInt(qb['ds-' + k], 10) || 0), best = Math.max(local, far);
      if (best > 0) { web.ds[k] = best; qb['ds-' + k] = best; }
      if (best > local) store.set('astryl-ds-best-' + k, JSON.stringify(best));
    });
    // Lessons read, kept as "group/slug" (blackholes/what-is-a-black-hole).
    // Reading is never undone, so both sides are joined.
    var read = readJson('astryl-read', {}), lessons = [];
    if (!read || typeof read !== 'object' || Array.isArray(read)) read = {};
    var bh = readJson('astryl-bh101', []);
    if (!Array.isArray(bh)) bh = [];
    function addLesson(k) { if (typeof k === 'string' && /^(blackholes|galaxies|students)\/[a-z0-9-]{2,60}$/.test(k) && lessons.indexOf(k) < 0) lessons.push(k); }
    Object.keys(read).forEach(function (path) {
      var m = path.match(/^(black-holes|galaxies|learn)\/([a-z0-9-]+)\.html$/);
      if (m) addLesson(LESSON_GROUP[m[1]] + '/' + m[2]);
    });
    (Array.isArray(rw.bh101) ? rw.bh101 : []).concat(bh).forEach(function (x) { if (typeof x === 'string') addLesson('blackholes/' + x); });
    (remote && Array.isArray(remote.lessons) ? remote.lessons : []).forEach(addLesson);
    var readChanged = false;
    lessons.forEach(function (k) {
      var g = k.split('/')[0], slug = k.split('/')[1], path = LESSON_PATH[g] + '/' + slug + '.html';
      if (!read[path]) { read[path] = Date.now(); readChanged = true; }
      if (g === 'blackholes') web.bh101.push(slug);
    });
    web.bh101 = web.bh101.filter(function (x, i, a) { return a.indexOf(x) === i; });
    if (readChanged) store.set('astryl-read', JSON.stringify(read));
    store.set('astryl-bh101', JSON.stringify(web.bh101));
    merged.lessons = lessons;
    // Things seen with your own eyes, joined across devices, keeping the first date.
    var seenL = readJson('astryl-seen', {}), seenR = {}, seenM = {};
    if (!seenL || typeof seenL !== 'object' || Array.isArray(seenL)) seenL = {};
    [rw.seen, remote && remote.seen].forEach(function (src) {
      if (!src || typeof src !== 'object' || Array.isArray(src)) return;
      Object.keys(src).forEach(function (k) { var v = parseInt(src[k], 10) || 0; if (v && (!seenR[k] || v < seenR[k])) seenR[k] = v; });
    });
    Object.keys(seenR).concat(Object.keys(seenL)).forEach(function (k) {
      var a = parseInt(seenL[k], 10) || 0, b = seenR[k] || 0, v = a && b ? Math.min(a, b) : (a || b);
      if (v && /^[a-z]{2,20}$/.test(k)) seenM[k] = v;
    });
    // ...unless this browser is newer and a tick was taken away here.
    if (!remoteWins && p0().syncedMs) { Object.keys(seenM).forEach(function (k) { if (!seenL[k]) delete seenM[k]; }); }
    store.set('astryl-seen', JSON.stringify(seenM));
    merged.seen = seenM;
    web.seen = seenM;
    merged.web = web;
    // The city is shared between devices (same city list). The newer side wins.
    // A city chosen in this browser always stays; the synced city is only used when none is chosen here.
    // Only cities from the built-in list are sent back.
    var lcity = readJson('astryl-city', ''), rcity = remote && typeof remote.city === 'string' ? remote.city : '';
    var appIds = (window.ASTRYL && window.ASTRYL.cities || []).map(function (c) { return c[0]; });
    if (!lcity && rcity && appIds.indexOf(rcity) >= 0) store.set('astryl-city', JSON.stringify(rcity));
    else if (typeof lcity === 'string' && appIds.indexOf(lcity) >= 0) merged.city = lcity;
  }
  var LESSON_GROUP = { 'black-holes': 'blackholes', galaxies: 'galaxies', learn: 'students' }, LESSON_PATH = { blackholes: 'black-holes', galaxies: 'galaxies', students: 'learn' };
  function p0() { return getPrefs(); }
  window.ASTRYL_ACCT = { api: api, token: token, session: getSession, prefs: getPrefs, sync: sync, status: function () { return syncStatus; } };
  var timer = null;
  document.addEventListener('astryl-change', function () {
    if (!getSession() || !getPrefs().syncOn) return;
    clearTimeout(timer); timer = setTimeout(sync, 3000);
  });

  /* ---------- anonymous active-user count (only if switched on) ---------- */
  function ping() {
    var p = getPrefs();
    if (!p.countMe || Date.now() - p.lastPing < 4 * 3600 * 1000) return;
    api('ping', { device: deviceId(), country: p.shareCountry ? country() : null }).then(function () { patchPrefs({ lastPing: Date.now() }); }, function () {});
  }

  /* ---------- welcome: create an account, log in, or carry on without ---------- */
  var gateEl = null;
  function closeGate(remember) {
    if (remember) store.set('astryl-gate', '1');
    if (!gateEl) return;
    try { document.dispatchEvent(new Event('astryl-gate-closed')); } catch (e) {}
    var g = gateEl; gateEl = null;
    document.body.classList.remove('gate-open');
    g.classList.add('out');
    setTimeout(function () { if (g.parentNode) g.parentNode.removeChild(g); }, 400);
  }
  function welcome() {
    var page = document.body.dataset.page;
    if (page === 'account' || page === 'get' || $('#acct') || getSession() || store.get('astryl-gate') === '1') return;
    if (navigator.webdriver && !/[?&]gate=1/.test(location.search)) return;
    var el = document.createElement('div');
    el.className = 'gate'; el.setAttribute('role', 'dialog'); el.setAttribute('aria-modal', 'true'); el.setAttribute('aria-labelledby', 'gateTitle');
    el.innerHTML = '<div class="gate-art" aria-hidden="true"><i></i><i></i><i></i><b></b></div>' +
      '<div class="gate-card">' +
      '<h1 id="gateTitle"></h1><p class="sub" id="gateSub"></p>' +
      '<div id="acct"></div>' +
      '<p class="gate-skip"><button class="btn" id="gateSkip" type="button"></button></p></div>';
    document.body.appendChild(el); gateEl = el; document.body.classList.add('gate-open');
    function paint() {
      $('#gateTitle').textContent = w('welcomeTitle'); $('#gateSub').textContent = w('welcomeSub');
      $('#gateSkip').textContent = w('welcomeSkip') + ' →';
    }
    paint(); onLang(paint);
    $('#gateSkip').addEventListener('click', function () { closeGate(true); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape' && gateEl) closeGate(true); });
  }


  /* ---------- page views: counted, never tied to a person ---------- */
  function track() {
    try {
      if (navigator.doNotTrack === '1' || window.doNotTrack === '1' || navigator.globalPrivacyControl) return;
      if (navigator.webdriver || location.protocol === 'file:' || /^(localhost|127\.)/.test(location.hostname)) return;
    } catch (e) { return; }
    var page = (location.pathname.replace(/^\/+/, '') || 'index.html').slice(0, 60);
    var ref = '';
    try { var u = new URL(document.referrer); if (u.hostname && u.hostname !== location.hostname) ref = u.hostname.replace(/^www\./, '').slice(0, 80); } catch (e) {}
    var wd = window.innerWidth || 1000;
    api('visit', { page: page, lang: lang(), ref: ref, device: wd < 640 ? 's' : wd < 1024 ? 'm' : 'l' }).catch(function () {});
  }

  /* ---------- notices at the bottom: news from the team, and the place question ---------- */
  var barEl = null, newsItem = null;
  function barAllowed() {
    try {
      if (navigator.doNotTrack === '1' || window.doNotTrack === '1' || navigator.globalPrivacyControl) return false;
      if (/[?&]bar=1/.test(location.search)) return !!window.fetch;
      if (location.protocol === 'file:' || /^(localhost|127\.)/.test(location.hostname) || navigator.webdriver) return false;
    } catch (e) { return false; }
    return !!window.fetch;
  }
  function drawBar() {
    if (!barEl) { barEl = document.createElement('div'); barEl.className = 'sitebar'; barEl.setAttribute('role', 'region'); barEl.setAttribute('aria-label', 'Notices'); document.body.appendChild(barEl); }
    var h = '';
    if (newsItem) {
      var hi = lang() === 'hi', ti = (hi && newsItem.title_hi) || newsItem.title_en || '', bo = (hi && newsItem.body_hi) || newsItem.body_en || '';
      h += '<div class="bar"><div><b>' + esc(w('barNews')) + ': ' + esc(ti) + '</b><span>' + esc(bo) + '</span></div><button type="button" class="btn" data-bar="newsClose">' + esc(w('barClose')) + '</button></div>';
    }
    if (askPlace) {
      h += '<div class="bar"><div><span>' + esc(w('barLocText')) + '</span></div><div class="btns"><button type="button" class="btn primary" data-bar="locYes">' + esc(w('barLocYes')) + '</button><button type="button" class="btn" data-bar="locNo">' + esc(w('barLocNo')) + '</button></div></div>';
    }
    barEl.innerHTML = h;
    barEl.style.display = h ? '' : 'none';
  }
  var askPlace = false;
  function notices() {
    if (!barAllowed()) return;
    var passedGate = !!getSession() || store.get('astryl-gate') === '1';
    if (!passedGate) { document.addEventListener('astryl-gate-closed', notices, { once: true }); return; }
    askPlace = !store.get('astryl-loc') && !!navigator.geolocation;
    document.addEventListener('click', function (e) {
      var b = e.target.closest ? e.target.closest('[data-bar]') : null; if (!b) return;
      var act = b.dataset.bar;
      if (act === 'newsClose') { if (newsItem) store.set('astryl-news-seen', String(newsItem.id)); newsItem = null; return drawBar(); }
      if (act === 'locNo') { store.set('astryl-loc', 'no'); askPlace = false; return drawBar(); }
      if (act === 'locYes') {
        askPlace = false; drawBar();
        try {
          navigator.geolocation.getCurrentPosition(function (pos) {
            store.set('astryl-loc', 'yes');
            api('place', { lat: pos.coords.latitude, lon: pos.coords.longitude }).catch(function () {});
          }, function () { store.set('astryl-loc', 'no'); }, { timeout: 12000, maximumAge: 600000 });
        } catch (x) { store.set('astryl-loc', 'no'); }
      }
    });
    api('news').then(function (j) {
      var items = (j && j.items) || [], seen = parseInt(store.get('astryl-news-seen') || '0', 10) || 0;
      newsItem = items.length && items[0].id > seen ? items[0] : null;
      drawBar();
    }, function () { drawBar(); });
    drawBar(); onLang(drawBar);
  }

  /* ---------- account page ---------- */
  var ui = { notice: '', mode: 'create', err: '', busy: false, code: null, saved: false, show: false, f: {}, newCode: null, del: false, delMsg: '' };
  function redraw() { if ($('#acct')) draw(); }
  function field(id, label, type, hint, extra) {
    return '<label class="fld"><span>' + esc(label) + '</span><input id="f_' + id + '" data-f="' + id + '" type="' + type + '" value="' + esc(ui.f[id] || '') + '" autocomplete="' + (extra || 'off') + '" autocapitalize="off" autocorrect="off" spellcheck="false"' + (ui.busy ? ' disabled' : '') + '>' + (hint ? '<small>' + esc(hint) + '</small>' : '') + '</label>';
  }
  function check(id, label, note, on) {
    return '<label class="chk"><input type="checkbox" data-c="' + id + '"' + (on ? ' checked' : '') + (ui.busy ? ' disabled' : '') + '><span><b>' + esc(label) + '</b>' + (note ? '<small>' + esc(note) + '</small>' : '') + '</span></label>';
  }
  function pwType() { return ui.show ? 'text' : 'password'; }
  function codeCard(code) {
    return '<div class="codebox"><div class="code" id="codeText">' + esc(code) + '</div><button class="btn" type="button" data-act="copy">' + esc(t('acctCopy')) + '</button></div>';
  }
  /* ---------- profile photo ---------- */
  function getAvatar() { var a = store.get('astryl-avatar') || ''; return /^[A-Za-z0-9+/]+={0,2}$/.test(a) ? a : ''; }
  function avatarImg(cls) { var a = getAvatar(); return a ? '<img class="' + cls + '" alt="" src="data:image/jpeg;base64,' + a + '">' : ''; }
  function fetchAvatar() {
    if (!getSession()) return;
    token().then(function (k) { return api('avatar_get', {}, k); }).then(function (j) {
      var a = j && typeof j.image === 'string' ? j.image : '';
      if (a) store.set('astryl-avatar', a); else store.del('astryl-avatar');
      navAccount(); redraw();
    }, function () {});
  }
  /* A centred 256 x 256 JPEG of the picked file, as base64 text. */
  function squarePhoto(file) {
    return new Promise(function (resolve, reject) {
      var url = URL.createObjectURL(file), img = new Image();
      img.onload = function () {
        try {
          var side = Math.min(img.naturalWidth, img.naturalHeight), c = document.createElement('canvas');
          c.width = 256; c.height = 256;
          c.getContext('2d').drawImage(img, (img.naturalWidth - side) / 2, (img.naturalHeight - side) / 2, side, side, 0, 0, 256, 256);
          var q = 0.82, out = '';
          while (q >= 0.4) {
            out = c.toDataURL('image/jpeg', q).split(',')[1] || '';
            if (out.length <= 60000) break;
            q -= 0.1;
          }
          URL.revokeObjectURL(url);
          if (!out || out.length > 65000) reject(fail('bad_image')); else resolve(out);
        } catch (e) { URL.revokeObjectURL(url); reject(fail('bad_image')); }
      };
      img.onerror = function () { URL.revokeObjectURL(url); reject(fail('bad_image')); };
      img.src = url;
    });
  }
  function pickPhoto(file) {
    if (!file) return;
    ui.busy = true; ui.delMsg = ''; draw();
    squarePhoto(file).then(function (b64) {
      return token().then(function (k) { return api('avatar_set', { image: b64 }, k); }).then(function () { store.set('astryl-avatar', b64); });
    }).then(function () { ui.busy = false; navAccount(); draw(); }, function () { ui.busy = false; ui.delMsg = w('avatarFail'); draw(); });
  }
  /* The header shows the name of the person who is logged in. */
  function navAccount() {
    var el = $('#acctNav'); if (!el) return;
    var s = getSession();
    if (s && s.username) el.innerHTML = '<a class="btn primary" href="' + (document.body.dataset.root || '') + 'account.html">' + (getAvatar() ? avatarImg('navpic') : '\uD83D\uDC64 ') + esc(s.username) + '</a>';
  }
  function draw() {
    navAccount();
    var root = $('#acct'); if (!root) return;
    var s = getSession(), h = '';
    if (s && !ui.code && gateEl) { closeGate(true); }
    if (ui.code) {
      h = '<h2>' + esc(t('acctCodeTitle')) + '</h2><p>' + esc(t('acctCodeWarn')) + '</p>' + codeCard(ui.code) +
        check('saved', t('acctCodeSaved'), '', ui.saved) +
        '<p><button class="btn primary" type="button" data-act="codeDone"' + (ui.saved ? '' : ' disabled') + '>' + esc(t('acctContinue')) + '</button></p>';
    } else if (s) {
      h = dashboard(s);
    } else if (gateEl) {
      h = authForm();
    } else {
      h = '<div class="acsplit">' + authArt() + '<div class="acside"><div class="card acform">' + authForm() + '</div></div></div>';
    }
    if (ui.notice) h = '<p class="ok acnotice"><b>' + esc(ui.notice) + '</b></p>' + h;
    root.innerHTML = h;
    // the entrance animation plays once, not on every redraw
    if (!gateEl) { root.classList.toggle('acx-in', !ui.drawn); ui.drawn = true; }
    pwMeter(); userCheck();
  }

  /* ---------- the parts of the account page ---------- */
  var BENEFITS = [['🔄', 'Everything in sync', 'Favourites, quiz scores and settings follow you to every device you log in on.'],
    ['🗓️', 'Daily 5 and leaderboards', 'Five new questions every day, a streak to keep and a place on the leaderboard.'],
    ['👥', 'Join the community', 'Share your sky photos, ask questions and answer other space lovers.'],
    ['🔒', 'No e-mail needed', 'Just a username and a password. A recovery code replaces “forgot password”.']];
  function authArt() {
    return '<div class="acart"><div class="acorbs" aria-hidden="true"><i></i><i></i><i></i></div><div class="acarttx"><span class="aceyebrow">✨ Astryl account</span>' +
      '<h1>Your universe, <span class="grad">everywhere.</span></h1><p class="sub">Optional and free. Keep your space journey on every device.</p><ul class="acben">' +
      BENEFITS.map(function (x, i) { return '<li style="--i:' + i + '"><span class="acbic" aria-hidden="true">' + x[0] + '</span><div><b>' + esc(x[1]) + '</b><small>' + esc(x[2]) + '</small></div></li>'; }).join('') + '</ul></div></div>';
  }
  function pwField(id, label, hint, ac) {
    return '<label class="fld pw"><span>' + esc(label) + '</span><span class="pwbox"><input id="f_' + id + '" data-f="' + id + '" type="' + pwType() + '" value="' + esc(ui.f[id] || '') + '" autocomplete="' + ac + '" autocapitalize="off" autocorrect="off" spellcheck="false"' + (ui.busy ? ' disabled' : '') + '>' +
      '<button type="button" class="eye" data-act="eye" aria-label="' + (ui.show ? 'Hide password' : 'Show password') + '" aria-pressed="' + ui.show + '">' + (ui.show ? '🙈' : '👁️') + '</button></span>' + (hint ? '<small>' + esc(hint) + '</small>' : '') + '</label>';
  }
  function authForm() {
    var create = ui.mode === 'create', recover = ui.mode === 'recover', h = '';
    if (!recover) h += '<div class="actabs" role="tablist"><span class="acind' + (create ? '' : ' r') + '" aria-hidden="true"></span><button type="button" role="tab" aria-selected="' + create + '" class="' + (create ? 'on' : '') + '" data-act="mode:create">' + esc(t('acctTabCreate')) + '</button><button type="button" role="tab" aria-selected="' + !create + '" class="' + (!create ? 'on' : '') + '" data-act="mode:login">' + esc(t('acctTabLogin')) + '</button></div>';
    h += '<h2 class="acformt">' + (create ? 'Create your free account' : recover ? esc(t('acctRecoverTitle')) : 'Welcome back 👋') + '</h2>';
    h += field('user', t('acctUsername'), 'text', create || recover ? t('acctUsernameHint') : '', 'username');
    if (create) h += '<small class="ucheck" id="uCheck" aria-live="polite"></small>';
    if (recover) h += field('code', t('acctRecoverCode'), 'text', 'XXXX-XXXX-XXXX-XXXX');
    h += pwField('pass', recover ? t('acctRecoverNewPassword') : t('acctPassword'), create || recover ? t('acctPasswordHint') : '', create || recover ? 'new-password' : 'current-password');
    if (create || recover) h += '<div class="pwmeter" aria-hidden="true"><i id="pwBar"></i></div><small class="note" id="pwText" aria-live="polite"></small>';
    if (create) h += pwField('pass2', t('acctPasswordAgain'), '', 'new-password');
    if (create) h += check('consent', t('acctConsent'), '', !!ui.f.consent) + '<p class="note"><a href="' + ROOT + 'privacy.html" target="_blank" rel="noopener">' + esc(t('acctReadPolicy')) + ' ↗</a> · By creating an account you agree to the <a href="' + ROOT + 'terms.html" target="_blank" rel="noopener">Terms and Conditions ↗</a></p>';
    if (ui.err) h += '<p class="no acerr">' + esc(ui.err) + '</p>';
    h += '<button class="btn primary acgo" type="button" data-act="submit"' + (ui.busy || (create && !ui.f.consent) ? ' disabled' : '') + '>' + (ui.busy ? '<span class="spin" aria-hidden="true"></span>' : '') + esc(create ? t('acctTabCreate') : recover ? t('acctRecoverButton') : t('acctTabLogin')) + ' →</button>';
    if (ui.mode === 'login') h += '<p class="note acalt"><a href="#" data-act="mode:recover">' + esc(t('acctForgot')) + '</a></p>';
    if (recover) h += '<p class="note acalt"><a href="#" data-act="mode:login">← ' + esc(t('acctBackToLogin')) + '</a></p>';
    return h;
  }
  function toggle(id, label, note, on) {
    return '<label class="tgl"><span class="tgltx"><b>' + esc(label) + '</b>' + (note ? '<small>' + esc(note) + '</small>' : '') + '</span><input type="checkbox" role="switch" data-c="' + id + '"' + (on ? ' checked' : '') + (ui.busy ? ' disabled' : '') + '><span class="tglsw" aria-hidden="true"></span></label>';
  }
  var LEVELS = [[0, '🧑‍🚀', 'Cadet'], [200, '✈️', 'Pilot'], [600, '🧭', 'Navigator'], [1500, '👩‍🚀', 'Astronaut'], [3500, '🚀', 'Commander'], [7000, '🌌', 'Galaxy Explorer']];
  function levelOf(p) { var l = LEVELS[0], next = null; LEVELS.forEach(function (x, i) { if (p >= x[0]) { l = x; next = LEVELS[i + 1] || null; } }); return { l: l, next: next }; }
  function num(v) { return v == null ? '–' : Number(v).toLocaleString('en-GB'); }
  function dashboard(s) {
    var p = getPrefs(), st = ui.stats || {}, pts = st.points, lv = typeof pts === 'number' ? levelOf(pts) : null;
    var prog = lv && lv.next ? Math.round((pts - lv.l[0]) / (lv.next[0] - lv.l[0]) * 100) : 100;
    var photoLabel = esc(w(getAvatar() ? 'avatarChange' : 'avatarChoose'));
    var pic = getAvatar() ? avatarImg('acpic') : '<span class="acpic ph" aria-hidden="true">' + esc(s.username.charAt(0).toUpperCase()) + '</span>';
    var h = '<section class="acbanner"><div class="acaurora" aria-hidden="true"></div><div class="acbin">' +
      '<div class="acpicwrap">' + pic + '<label class="acpicbtn" for="photoIn" title="' + photoLabel + '"><span aria-hidden="true">📷</span><span class="sr-only">' + photoLabel + '</span></label><input id="photoIn" type="file" accept="image/*" hidden></div>' +
      '<div class="acwho"><span class="aceyebrow">' + (lv ? lv.l[1] + ' ' + esc(lv.l[2]) : '🧑‍🚀 Space explorer') + '</span><h1>' + esc(s.username) + '</h1>' +
      '<div class="acchips"><span><b>' + num(pts) + '</b> Space Points</span><span>🔥 <b>' + num(st.streak) + '</b> day streak</span><span>📷 <b>' + num(st.photos) + '</b> photos</span><span>❓ <b>' + num(st.questions) + '</b> questions</span></div>' +
      (lv && lv.next ? '<div class="aclv"><div class="aclvbar"><i style="width:' + prog + '%"></i></div><small>' + num(lv.next[0] - pts) + ' points to ' + lv.next[1] + ' ' + esc(lv.next[2]) + '</small></div>' : '') +
      (getAvatar() ? '<button class="linkbtn acpicdel" type="button" data-act="photoDel">' + esc(w('avatarRemove')) + '</button>' : '') +
      '</div><div class="acquick"><a class="btn primary" href="' + ROOT + 'profile.html?u=' + encodeURIComponent(s.username) + '">👤 My profile</a><a class="btn" href="' + ROOT + 'my-space.html">⭐ My space</a><a class="btn" href="' + ROOT + 'quiz.html#daily">🗓️ Daily 5</a></div></div></section>';
    if (ui.delMsg && !ui.del) h += '<p class="note">' + esc(ui.delMsg) + '</p>';
    h += '<div class="acgrid">';
    h += '<section class="card accard" style="--i:0"><h2><span class="acic" aria-hidden="true">🔄</span> Sync</h2>' + toggle('syncOn', t('acctSync'), 'Favourites, quiz scores, theme, city and birth date are kept in your account and shared between your devices.', p.syncOn) +
      '<div class="acrow"><button class="btn" type="button" data-act="syncNow"' + (syncing || !p.syncOn ? ' disabled' : '') + '>' + (syncing ? '<span class="spin" aria-hidden="true"></span>' : '↻ ') + esc(t('acctSyncNow')) + '</button><span class="acstat ' + (syncStatus || '') + '">' + esc({ syncing: t('acctSyncing'), ok: '✓ ' + t('acctSyncOk'), failed: t('acctSyncFailed') }[syncStatus] || '') + '</span></div></section>';
    h += '<section class="card accard" style="--i:1"><h2><span class="acic" aria-hidden="true">🛡️</span> Privacy</h2><p class="note">Optional. All off until you switch them on, except the leaderboard.</p>' +
      toggle('showOnBoard', w('boardShow'), w('boardShowNote'), p.showOnBoard) + toggle('countMe', t('acctCountMe'), t('acctCountMeNote'), p.countMe) + toggle('shareCountry', t('acctShareCountry'), t('acctShareCountryNote'), p.shareCountry) + '</section>';
    h += '<section class="card accard" style="--i:2"><h2><span class="acic" aria-hidden="true">🔑</span> Security</h2><p>Your recovery code lets you set a new password if you forget it. It works three times.</p>' +
      (ui.newCode ? '<div class="acnew"><b>' + esc(t('acctCodeTitle')) + '</b><p class="note">' + esc(t('acctCodeWarn')) + '</p>' + codeCard(ui.newCode) + '</div>' : '') +
      '<div class="acrow"><button class="btn" type="button" data-act="newCode">🔁 ' + esc(t('acctNewCode')) + '</button></div><p class="note">' + esc(t('acctNewCodeNote')) + '</p></section>';
    h += '<section class="card accard" style="--i:3"><h2><span class="acic" aria-hidden="true">🚪</span> Session</h2><p>Logged in as <b>' + esc(s.username) + '</b> on this browser.</p>' +
      (ui.ren ? '<div class="acren"><p class="note">Your username is also your login name. Your photos, posts and points stay with you. You can change it once every 30 days, and the link to your old profile page stops working.</p>' +
        field('newuser', 'New username', 'text', '3 to 20: small letters, numbers and _', 'username') + field('renpass', 'Your password, to confirm', 'password', '', 'current-password') +
        (ui.renMsg ? '<p class="no" role="alert">' + esc(ui.renMsg) + '</p>' : '') +
        '<div class="acrow"><button class="btn primary" type="button" data-act="renSave"' + (ui.busy ? ' disabled' : '') + '>' + (ui.busy ? '<span class="spin" aria-hidden="true"></span>' : '') + 'Save new username</button><button class="btn" type="button" data-act="renCancel">' + esc(t('cancel')) + '</button></div></div>'
        : (ui.renOk ? '<p class="ok" role="status">✓ ' + esc(ui.renOk) + '</p>' : '') + '<div class="acrow"><button class="btn" type="button" data-act="renAsk">✏️ Change username</button><button class="btn" type="button" data-act="logout">' + esc(t('acctLogOut')) + '</button></div>') + '</section>';
    h += '</div>';
    h += '<section class="card danger acdanger"><div><h2>⚠️ Danger zone</h2><p>' + esc(t('acctDeleteNote')) + '</p></div><div class="acdz">' +
      (ui.del ? '<p>' + esc(t('acctDeleteConfirmBody')) + '</p>' + field('delpass', t('acctPassword'), 'password', '', 'current-password') +
        '<div class="acrow"><button class="btn danger-btn" type="button" data-act="delete"' + (ui.busy ? ' disabled' : '') + '>' + esc(t('acctDeleteButton')) + '</button><button class="btn" type="button" data-act="delCancel">' + esc(t('cancel')) + '</button></div>'
        : '<button class="btn danger-btn" type="button" data-act="delAsk">🗑️ ' + esc(t('acctDelete')) + '</button>') +
      (ui.delMsg && ui.del ? '<p class="no">' + esc(ui.delMsg) + '</p>' : '') + '</div></section>';
    return h;
  }
  /* password strength, shown under a new password */
  function pwMeter() {
    var bar = $('#pwBar'), txt = $('#pwText'), inp = $('#f_pass'); if (!bar || !inp || !txt) return;
    var v = inp.value, sc = 0;
    if (v.length >= 8) sc++; if (v.length >= 12) sc++; if (/[a-z]/.test(v) && /[A-Z]/.test(v)) sc++; if (/\d/.test(v)) sc++; if (/[^A-Za-z0-9]/.test(v)) sc++;
    var lv = !v ? 0 : v.length < 8 ? 1 : sc <= 2 ? 2 : sc <= 3 ? 3 : 4;
    bar.style.width = (lv * 25) + '%'; bar.className = 'pw' + lv;
    txt.textContent = ['', 'Too short: at least 8 characters', 'Weak: add numbers or symbols', 'Good', 'Strong 💪'][lv];
  }
  /* is the username free? (asked a moment after typing stops) */
  var ucTimer = null, ucLast = '', ucText = '', ucCls = 'ucheck';
  function userCheck(typed) {
    var el = $('#uCheck'), inp = $('#f_user'); if (!el || !inp) return;
    var v = inp.value.trim().toLowerCase();
    function show(txt, cls) { ucText = txt; ucCls = 'ucheck ' + (cls || ''); el.textContent = txt; el.className = ucCls; }
    if (!typed && v === ucLast) { el.textContent = ucText; el.className = ucCls; return; }
    clearTimeout(ucTimer); ucLast = v;
    if (!v) return show('');
    if (!/^[a-z0-9_]{3,20}$/.test(v)) return show('3 to 20 letters (a to z), digits or _', 'no');
    show('Checking…');
    ucTimer = setTimeout(function () {
      api('check', { username: v }).then(function (j) {
        if ((($('#f_user') || {}).value || '').trim().toLowerCase() !== v) return;
        var e2 = $('#uCheck'); el = e2 || el;
        show(j && j.available ? '✓ “' + v + '” is free' : '✗ “' + v + '” is taken', j && j.available ? 'ok' : 'no');
      }, function () { show(''); });
    }, 450);
  }
  function loadStats() {
    var s = getSession(); if (!s || ui.statsLoading) return;
    ui.statsLoading = true;
    token().then(function (k) {
      return Promise.all([
        fetch('https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/community', { method: 'POST', headers: { 'Content-Type': 'application/json', 'x-astryl-token': k }, body: JSON.stringify({ action: 'profile', u: s.username }) }).then(function (r) { return r.ok ? r.json() : {}; }).catch(function () { return {}; }),
        api('board', {}, k).catch(function () { return {}; })
      ]);
    }).then(function (r) {
      var pr = r[0] || {}, bd = r[1] || {};
      ui.stats = { points: pr.quiz ? pr.quiz.points : null, photos: pr.photos ? pr.photos.length : null, questions: pr.questions ? pr.questions.length : null, streak: bd.me_stats ? bd.me_stats.streak : 0 };
      if ($('#acct') && getSession()) draw();
    }, function () { });
  }
  function saveFields() {
    var root = $('#acct'); if (!root) return;
    Array.prototype.forEach.call(root.querySelectorAll('input[data-f]'), function (el) { ui.f[el.dataset.f] = el.value; });
  }
  var NAME_RE = /^[a-z0-9_]{3,20}$/, CODE_ALPHA = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  function normCode(s) { return String(s || '').toUpperCase().split('').filter(function (c) { return CODE_ALPHA.indexOf(c) >= 0; }).join(''); }
  function fmtCode(s) { var c = normCode(s); return c.length === 16 ? c.slice(0, 4) + '-' + c.slice(4, 8) + '-' + c.slice(8, 12) + '-' + c.slice(12) : s; }
  function submit() {
    saveFields();
    var f = ui.f, name = String(f.user || '').trim().toLowerCase(), pass = f.pass || '';
    ui.err = '';
    if (!NAME_RE.test(name)) { ui.err = t('acctErrUsername'); return draw(); }
    var run;
    if (ui.mode === 'create') {
      if (pass.length < 8 || pass.length > 72) { ui.err = t('acctErrPassword'); return draw(); }
      if (pass !== f.pass2) { ui.err = t('acctErrMismatch'); return draw(); }
      run = function () {
        return api('signup', { username: name, password: pass, consent: true, consentVersion: 1, showOnBoard: f.showOnBoard !== false, countMe: !!f.countMe, shareCountry: !!f.shareCountry, shareLocation: false, country: f.shareCountry ? country() : null }).then(function (j) {
          setSession(toSession(j, name)); patchPrefs({ showOnBoard: f.showOnBoard !== false, countMe: !!f.countMe, shareCountry: !!f.shareCountry, syncedMs: 0 });
          ui.code = fmtCode(j.code || ''); ui.saved = false; ui.f = {};
        });
      };
    } else if (ui.mode === 'login') {
      if (!pass) { ui.err = t('acctErrLogin'); return draw(); }
      run = function () { return api('login', { username: name, password: pass }).then(function (j) { setSession(toSession(j, name)); patchPrefs({ syncedMs: 0 }); ui.f = {}; return sync(); }); };
    } else {
      if (normCode(f.code).length !== 16) { ui.err = t('acctErrCode'); return draw(); }
      if (pass.length < 8 || pass.length > 72) { ui.err = t('acctErrPassword'); return draw(); }
      run = function () {
        return api('recover', { username: name, code: normCode(f.code), password: pass }).then(function (j) {
          setSession(toSession(j, name)); patchPrefs({ syncedMs: 0 }); ui.f = {}; ui.mode = 'login';
          ui.err = ''; var left = j.usesLeft; ui.notice = t('acctRecovered', { count: left });
          return sync();
        });
      };
    }
    ui.busy = true; draw();
    run().then(function () { ui.busy = false; ui.drawn = false; draw(); if (ui.mode === 'create' && getSession()) sync(); ping(); loadStats(); }, function (e) { ui.busy = false; ui.err = errText(e); draw(); });
  }
  function onClick(e) {
    var el = e.target.closest ? e.target.closest('[data-act]') : null;
    if (!el || !$('#acct') || !$('#acct').contains(el)) return;
    var act = el.dataset.act; e.preventDefault();
    saveFields(); ui.notice = '';
    if (act.indexOf('mode:') === 0) { ui.mode = act.slice(5); ui.err = ''; ui.f.pass = ''; ui.f.pass2 = ''; return draw(); }
    if (act === 'submit') return submit();
    if (act === 'eye') { ui.show = !ui.show; draw(); var pf = $('#f_pass'); if (pf) pf.focus(); return; }
    if (act === 'copy') {
      var txt = ui.code || ui.newCode || '';
      try { navigator.clipboard.writeText(txt); el.textContent = t('acctCopied'); } catch (x) { var r = document.createRange(); r.selectNodeContents($('#codeText')); var sel = getSelection(); sel.removeAllRanges(); sel.addRange(r); }
      return;
    }
    if (act === 'codeDone') { ui.code = null; return draw(); }
    if (act === 'photoDel') return void token().then(function (k) { return api('avatar_delete', {}, k); }).then(function () { store.del('astryl-avatar'); navAccount(); draw(); }, function (x) { ui.delMsg = errText(x); draw(); });
    if (act === 'syncNow') return void sync();
    if (act === 'newCode') return void token().then(function (k) { return api('newcode', {}, k); }).then(function (j) { ui.newCode = fmtCode(j.code); draw(); }, function (x) { ui.delMsg = errText(x); draw(); });
    if (act === 'logout') { clearSession(); ui.newCode = null; ui.del = false; ui.mode = 'login'; ui.stats = null; ui.statsLoading = false; ui.drawn = false; return draw(); }
    if (act === 'renAsk') { ui.ren = true; ui.renMsg = ''; ui.renOk = ''; draw(); var nf = $('#f_newuser'); if (nf) nf.focus(); return; }
    if (act === 'renCancel') { ui.ren = false; ui.renMsg = ''; ui.f.newuser = ''; ui.f.renpass = ''; return draw(); }
    if (act === 'renSave') {
      var nu = String(ui.f.newuser || '').trim().toLowerCase(), rp = ui.f.renpass || '';
      if (!/^[a-z0-9_]{3,20}$/.test(nu)) { ui.renMsg = t('acctErrUsername'); return draw(); }
      if (!rp) { ui.renMsg = 'Please type your password to confirm.'; return draw(); }
      ui.busy = true; ui.renMsg = ''; draw();
      return void token().then(function (k) {
        return fetch(API.replace(/account$/, 'rename'), { method: 'POST', headers: { 'Content-Type': 'application/json', 'apikey': KEY, 'x-astryl-token': k }, body: JSON.stringify({ username: nu, password: rp }) })
          .then(function (r) { return r.json().catch(function () { return {}; }).then(function (j) { if (!r.ok) { var x = fail(j.error || 'server_error', r.status); x.next = j.next; throw x; } return j; }); }, function () { throw fail('offline'); });
      }).then(function (j) {
        var old = getSession();
        if (j.session) setSession(toSession(j, j.username)); else if (old) { old.username = j.username; setSession(old); }
        ui.busy = false; ui.ren = false; ui.f.newuser = ''; ui.f.renpass = ''; ui.renOk = 'Your username is now ' + j.username + '.'; ui.stats = null; navAccount(); draw(); loadStats();
      }, function (x) {
        ui.busy = false;
        ui.renMsg = x.code === 'too_soon' ? 'You changed your username a short time ago. You can change it again on ' + new Date(x.next).toLocaleDateString('en-GB', { day: 'numeric', month: 'long', year: 'numeric' }) + '.'
          : x.code === 'same_username' ? 'That is already your username.' : x.code === 'bad_login' ? 'That password is not right.' : errText(x);
        draw();
      });
    }
    if (act === 'delAsk') { ui.del = true; ui.delMsg = ''; return draw(); }
    if (act === 'delCancel') { ui.del = false; ui.delMsg = ''; ui.f.delpass = ''; return draw(); }
    if (act === 'delete') {
      var pw = ui.f.delpass || ''; if (!pw) return;
      ui.busy = true; ui.delMsg = ''; draw();
      return void token().then(function (k) { return api('delete', { password: pw }, k); }).then(function () {
        clearSession(); ui.busy = false; ui.del = false; ui.f = {}; ui.mode = 'create'; ui.err = ''; ui.notice = t('acctDeleted'); draw();
      }, function (x) { ui.busy = false; ui.delMsg = errText(x); draw(); });
    }
  }
  function onChange(e) {
    var c = e.target.dataset && e.target.dataset.c; if (!c) return;
    var on = e.target.checked, s = getSession();
    saveFields();
    if (c === 'show') { ui.show = on; return draw(); }
    if (c === 'saved') { ui.saved = on; return draw(); }
    if (!s) { ui.f[c] = on; return draw(); }
    if (c === 'syncOn') { patchPrefs({ syncOn: on }); draw(); if (on) sync(); return; }
    if (c === 'showOnBoard') {
      patchPrefs({ showOnBoard: on }); draw();
      var q = getPrefs();
      token().then(function (k) { return api('prefs', { showOnBoard: on, countMe: q.countMe, shareCountry: q.shareCountry, shareLocation: false, country: q.shareCountry ? country() : null }, k); }).catch(function () {});
      return;
    }
    if (c === 'countMe' || c === 'shareCountry') {
      var p = patchPrefs((function () { var o = {}; o[c] = on; o.lastPing = 0; return o; })());
      draw();
      token().then(function (k) { return api('prefs', { countMe: p.countMe, shareCountry: p.shareCountry, shareLocation: false, country: p.shareCountry ? country() : null }, k); }).then(function () { ping(); }, function () {});
    }
  }
  function accountPage() {
    var root = $('#acct'); if (!root) return;
    root.addEventListener('click', onClick);
    root.addEventListener('change', function (e) { if (e.target && e.target.id === 'photoIn') { var f = e.target.files && e.target.files[0]; e.target.value = ''; return pickPhoto(f); } onChange(e); });
    root.addEventListener('input', function (e) { if (e.target.dataset && e.target.dataset.f) ui.f[e.target.dataset.f] = e.target.value; if (e.target.id === 'f_pass') pwMeter(); if (e.target.id === 'f_user') userCheck(true); });
    root.addEventListener('keydown', function (e) { if (e.key === 'Enter' && e.target.dataset && e.target.dataset.f && !ui.code && !getSession()) { e.preventDefault(); submit(); } });
    if (/[?&]mode=login/.test(location.search) && !getSession()) ui.mode = 'login';
    draw(); onLang(draw);
    if (getSession()) { sync(); loadStats(); }
  }

  /* ---------- the public counter ---------- */
  function statsBlock() {
    var box = $('#stats'); if (!box || !window.fetch) return;
    var data = {};
    function paint() {
      var n = function (v) { return v === undefined ? '–' : Number(v).toLocaleString(lang() === 'hi' ? 'hi-IN' : 'en-US'); };
      // accounts and active users are shown once there are enough of them to be meaningful
      var big = (data.registered || 0) >= 100;
      var h = (big ? '<div class="stat"><b>' + n(data.registered) + '</b><span>' + esc(w('statsRegistered')) + '</span></div><div class="stat"><b>' + n(data.active) + '</b><span>' + esc(w('statsActive')) + '</span></div>' : '') + '<div class="stat"><b>' + n(data.visitors) + '</b><span>' + esc(w('statsVisitors')) + '</span></div><div class="stat"><b>' + n(data.views) + '</b><span>' + esc(w('statsViews')) + '</span></div>';
      box.innerHTML = h;
      var c = $('#statsCountries');
      if (c) {
        var list = data.countries || [], dn = null;
        try { dn = new Intl.DisplayNames([lang()], { type: 'region' }); } catch (e) {}
        c.innerHTML = list.length ? '<b>' + esc(w('statsCountries')) + ':</b> ' + list.map(function (x) { var nm = x.c; try { if (dn) nm = dn.of(x.c) || x.c; } catch (e) {} return esc(nm) + ' ' + esc(x.n); }).join(' · ') : '';
      }
      var note = $('#statsNote'); if (note) note.textContent = w('statsNote');
    }
    paint(); onLang(paint);
    fetch(API + '?action=stats', { headers: { apikey: KEY } }).then(function (r) { return r.ok ? r.json() : Promise.reject(); }).then(function (j) {
      data.registered = j.registered; data.active = j.active_30d; data.views = j.views_30d; data.visitors = j.visitors_30d; data.countries = j.countries; paint();
    }).catch(function () {});
  }

  /* ---------- Daily 5 and the leaderboard ---------- */
  var NAMES = { mercury: 'planetMercury', venus: 'planetVenus', earth: 'planetEarth', mars: 'planetMars', jupiter: 'planetJupiter', saturn: 'planetSaturn', uranus: 'planetUranus', neptune: 'planetNeptune', sun: 'bodySun', moon: 'bodyMoon', pluto: 'bodyPluto', io: 'moonIo', europa: 'moonEuropa', ganymede: 'moonGanymede', callisto: 'moonCallisto', titan: 'moonTitan', enceladus: 'moonEnceladus', triton: 'moonTriton' };
  function bodyName(id) { return t(NAMES[id] || id); }
  function qText(k) { return t('q' + k.charAt(0).toUpperCase() + k.slice(1)); }
  function sec(ms) { return (Math.round(ms / 100) / 10).toFixed(1); }
  function fill(str, o) { for (var k in o) str = str.split('{' + k + '}').join(o[k]); return str; }
  function dailyPage() {
    var root = $('#daily'); if (!root) return;
    var d = { phase: 'idle', qs: [], i: 0, picked: [], startAt: 0, result: null, answers: null, board: null, tab: 'today', err: '', busy: false, showAns: false }, tick = null;
    function me() { return getSession(); }
    function loadBoard() {
      var go = function (k) { return api('board', {}, k); };
      (me() ? token().then(go, function () { return go(); }) : go()).then(function (j) {
        d.board = j;
        // Already played today: fetch the review (this does not start a run).
        if (j.me_today && d.phase === 'idle') return start();
        draw();
      }, function () { d.board = null; draw(); });
    }
    function board() {
      var b = d.board, h = '<h3>' + esc(w('boardTitleLb')) + '</h3><div class="tabs"><button type="button" class="' + (d.tab === 'today' ? 'on' : '') + '" data-dl="tab:today">' + esc(w('boardToday')) + '</button><button type="button" class="' + (d.tab === 'week' ? 'on' : '') + '" data-dl="tab:week">' + esc(w('boardWeek')) + '</button><button type="button" class="' + (d.tab === 'all' ? 'on' : '') + '" data-dl="tab:all">' + esc(w('boardAll')) + '</button></div>';
      if (!b) return h + '<p class="note">' + esc(w('loading')) + '</p>';
      var rows = (d.tab === 'today' ? b.today : (d.tab === 'week' ? b.week : b.all)) || [], mine = me() ? me().username : '';
      if (!rows.length) h += '<p class="note">' + esc(w('boardEmpty')) + '</p>';
      else {
        h += '<ol class="lb">';
        rows.forEach(function (r) {
          var sub = d.tab === 'today' ? fill(w('boardRight'), { c: r.c }) + ' · ' + fill(w('boardTime'), { s: sec(r.ms) }) : fill(w('boardDays'), { d: r.d });
          h += '<li' + (r.u === mine ? ' class="me"' : '') + '><span class="nm"><a class="plink" href="' + ROOT + 'profile.html?u=' + encodeURIComponent(r.u) + '">' + esc(r.u) + '</a>' + (r.u === mine ? ' (' + esc(w('boardYours')) + ')' : '') + '<small>' + esc(sub) + '</small></span><b>' + r.p + '</b></li>';
        });
        h += '</ol>';
      }
      var m = d.tab === 'today' ? b.me_today : (d.tab === 'week' ? b.me_week : b.me_all);
      if (m) h += '<p class="note"><b>' + esc(d.tab === 'today' ? fill(w('boardRank'), { r: m.rank, n: b.players_today }) : (d.tab === 'week' ? fill(w('boardRankWeek'), { r: m.rank }) : fill(w('boardRankAll'), { r: m.rank }))) + '</b></p>';
      if (me() && !getPrefs().showOnBoard) h += '<p class="note">' + esc(w('boardHidden')) + '</p>';
      return h;
    }
    var BADGES = [['bdFirst', '🚀', function (x) { return x.plays >= 1; }], ['bdS3', '🔥', function (x) { return x.best >= 3; }], ['bdS7', '🔥', function (x) { return x.best >= 7; }],
      ['bdS30', '🏆', function (x) { return x.best >= 30; }], ['bdPerfect', '⭐', function (x) { return x.perfect >= 1; }], ['bdP10', '🪐', function (x) { return x.plays >= 10; }], ['bdP50', '🌌', function (x) { return x.plays >= 50; }]];
    function streakPanel() {
      var x = d.board && d.board.me_stats;
      if (!me() || !x) return '';
      var h = '<div class="card"><h3>' + esc(x.streak > 0 ? '🔥 ' + fill(w('streakNow'), { n: x.streak }) : w('streakNone')) + '</h3>' + (x.best > 0 ? '<p class="note">' + esc(fill(w('streakBest'), { n: x.best })) + '</p>' : '');
      h += '<h3>' + esc(w('badgesTitle')) + '</h3><div class="badges">';
      BADGES.forEach(function (b) { h += '<span class="' + (b[2](x) ? 'on' : 'off') + '">' + b[1] + ' ' + esc(w(b[0])) + '</span>'; });
      return h + '</div></div>';
    }
    function review() {
      var h = '<h3>' + esc(w('boardReview')) + '</h3>';
      d.qs.forEach(function (q, i) {
        var right = d.answers && d.answers[i], mine = d.picked[i];
        var line = !right ? '' : !mine ? 'Answer: <b>' + esc(bodyName(right)) + '</b>'
          : mine === right ? '<span class="ok">✓ ' + esc(bodyName(mine)) + '</span>'
          : '<span class="no">✗ ' + esc(bodyName(mine)) + '</span> → <b>' + esc(bodyName(right)) + '</b>';
        h += '<div class="card"><b>' + esc(qText(q.k)) + '</b><p>' + line + '</p></div>';
      });
      return h;
    }
    function resultCard() {
      var r = d.result;
      return '<div class="card" style="text-align:center"><h3>' + esc(w('boardDone')) + '</h3><div class="life">' + r.points + '</div><p>' + esc(fill(w('boardRight'), { c: r.correct }) + ' · ' + fill(w('boardTime'), { s: sec(r.ms) })) + '</p><p><button class="btn" type="button" data-dl="share">' + esc(w('boardShare')) + '</button></p><p class="note">' + esc(w('boardBack')) + '</p></div>';
    }
    /* A square picture of today's result, shared with the phone's share sheet or saved as a file. */
    function sharePicture() {
      var r = d.result; if (!r) return;
      var c = document.createElement('canvas'); c.width = 1080; c.height = 1080;
      var x = c.getContext('2d'), g = x.createLinearGradient(0, 0, 0, 1080);
      g.addColorStop(0, '#06080e'); g.addColorStop(1, '#101a3a'); x.fillStyle = g; x.fillRect(0, 0, 1080, 1080);
      var seed = 7; function rnd() { seed = (seed * 16807) % 2147483647; return seed / 2147483647; }
      for (var i = 0; i < 90; i++) { x.fillStyle = 'rgba(220,230,255,' + (0.25 + rnd() * 0.6).toFixed(2) + ')'; x.beginPath(); x.arc(rnd() * 1080, rnd() * 1080, 1 + rnd() * 2, 0, 7); x.fill(); }
      x.textAlign = 'center'; x.fillStyle = '#7aa2ff'; x.font = '700 60px "Space Grotesk",sans-serif'; x.fillText('Astryl · Daily 5', 540, 170);
      x.fillStyle = '#f0f4ff'; x.font = '700 260px "Space Grotesk",sans-serif'; x.fillText(String(r.points), 540, 520);
      x.fillStyle = '#a0b0d6'; x.font = '500 54px "DM Sans",sans-serif'; x.fillText(w('boardPoints').replace('{p}', '').trim() || 'points', 540, 600);
      if (d.picked.length === 5 && d.answers) {
        for (var k = 0; k < 5; k++) { x.fillStyle = d.picked[k] === d.answers[k] ? '#3ddc97' : '#ff6b6b'; x.beginPath(); if (x.roundRect) x.roundRect(150 + k * 156, 680, 120, 120, 22); else x.rect(150 + k * 156, 680, 120, 120); x.fill(); }
      }
      x.fillStyle = '#f0f4ff'; x.font = '600 58px "DM Sans",sans-serif'; x.fillText(fill(w('boardRight'), { c: r.correct }) + ' · ' + fill(w('boardTime'), { s: sec(r.ms) }), 540, 890);
      x.fillStyle = '#a0b0d6'; x.font = '500 44px "DM Sans",sans-serif'; x.fillText('astryl.space/quiz', 540, 990);
      var text = fill(w('boardShareText'), { p: r.points }) + ' https://astryl.space/quiz.html';
      c.toBlob(function (blob) {
        if (!blob) return;
        var file; try { file = new File([blob], 'astryl-daily-5.png', { type: 'image/png' }); } catch (e) { file = null; }
        if (file && navigator.canShare && navigator.canShare({ files: [file] })) { navigator.share({ files: [file], text: text }).catch(function () {}); return; }
        var a = document.createElement('a'); a.href = URL.createObjectURL(blob); a.download = 'astryl-daily-5.png'; document.body.appendChild(a); a.click(); a.remove();
      }, 'image/png');
    }
    function draw() {
      var h = '<h2>' + esc(w('boardTitle')) + '</h2><p class="sub">' + esc(w('boardIntro')) + '</p>';
      if (d.err) h += '<p class="no">' + esc(d.err) + '</p>';
      if (!me()) h += '<div class="card"><p>' + esc(w('boardLogin')) + '</p><p><a class="btn primary" href="' + ROOT + 'account.html">' + esc(t('acctTabLogin')) + ' / ' + esc(t('acctTabCreate')) + '</a></p></div>';
      else if (d.phase === 'idle') h += '<div class="card"><p><button class="btn primary" type="button" data-dl="play"' + (d.busy ? ' disabled' : '') + '>' + esc(w('boardPlay')) + '</button></p><p class="note">' + esc(w('boardTimerNote')) + '</p></div>';
      else if (d.phase === 'play') {
        var q = d.qs[d.i];
        h += '<div class="card"><p class="note">' + esc(fill(w('boardQ'), { n: d.i + 1 })) + ' · <span id="dlClock"></span></p><div class="progress"><i style="width:' + (d.i / 5 * 100) + '%"></i></div><h3>' + esc(qText(q.k)) + '</h3>';
        q.o.forEach(function (id) { h += '<button type="button" class="opt" data-dl="pick:' + id + '"' + (d.busy ? ' disabled' : '') + '>' + esc(bodyName(id)) + '</button>'; });
        h += '</div>';
      } else if (d.phase === 'check') h += '<div class="card"><p>' + esc(w('boardSubmitting')) + '</p></div>';
      else if (d.phase === 'done') h += resultCard() + '<p class="ansbtn"><button type="button" class="btn" data-dl="answers" aria-expanded="' + d.showAns + '">' + (d.showAns ? '🙈 Hide today\'s answers' : '👀 See today\'s answers') + '</button></p>' + (d.showAns ? review() : '');
      h += streakPanel() + board();
      root.innerHTML = h;
      clock();
    }
    function clock() {
      var el = $('#dlClock'); if (!el) return;
      el.textContent = fill(w('boardTime'), { s: sec(Date.now() - d.startAt) });
    }
    function start() {
      d.err = ''; d.busy = true; draw();
      token().then(function (k) { return api('daily_start', {}, k); }).then(function (j) {
        d.busy = false; d.qs = j.questions; d.i = 0; d.picked = [];
        if (j.done) { d.phase = 'done'; d.result = { points: j.points, correct: j.correct, ms: j.ms }; d.answers = j.questions.map(function (q) { return q.a; }); d.picked = Array.isArray(j.picks) ? j.picks : []; d.showAns = false; }
        else { d.phase = 'play'; d.startAt = Date.now() - (j.elapsedMs || 0); }
        draw(); loadBoard();
      }, function (e) { d.busy = false; d.err = errText(e); draw(); });
    }
    function submit() {
      d.phase = 'check'; draw();
      token().then(function (k) { return api('daily_submit', { answers: d.picked }, k); }).then(function (j) {
        d.result = j; d.answers = j.answers; d.phase = 'done'; d.showAns = false; draw(); loadBoard();
      }, function (e) { d.phase = 'idle'; d.err = e && e.code === 'already_done' ? '' : errText(e); draw(); loadBoard(); });
    }
    root.addEventListener('click', function (e) {
      var el = e.target.closest('[data-dl]'); if (!el) return;
      var a = el.dataset.dl;
      if (a === 'play') return start();
      if (a === 'share') return sharePicture();
      if (a === 'answers') { d.showAns = !d.showAns; return draw(); }
      if (a.indexOf('tab:') === 0) { d.tab = a.slice(4); return draw(); }
      if (a.indexOf('pick:') === 0 && d.phase === 'play') {
        d.picked.push(a.slice(5));
        if (d.picked.length >= d.qs.length) return submit();
        d.i++; draw();
      }
    });
    tick = setInterval(clock, 500);
    draw(); loadBoard(); onLang(draw);
  }

  navAccount(); welcome(); accountPage(); dailyPage(); statsBlock(); ping(); track(); notices();
  if (getSession()) fetchAvatar();
  if (getSession() && !$('#acct')) sync();
})();
