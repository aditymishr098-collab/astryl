/* Astryl website: the optional online account, the public counter and the
   sign-up banner. Everything here is optional: the site works the same for
   a visitor who never makes an account. Uses Firebase Authentication and
   Cloud Firestore (project: astryl-space) with the public Web API key. */
(function () {
  'use strict';
  var PROJECT_ID = 'astryl-space';
  var KEY = 'AIzaSyA-ZcWiNNMmVlDzTqPafBQmz9HIzLGag7g';
  var FS_URL = 'https://firestore.googleapis.com/v1/projects/' + PROJECT_ID + '/databases/(default)/documents';
  var AUTH_URL = 'https://identitytoolkit.googleapis.com/v1';
  var TOKEN_URL = 'https://securetoken.googleapis.com/v1';
  var REPO = 'aditymishr098-collab/astryl';
  var D = window.ASTRYL || { L: { en: {}, hi: {} } };
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var ROOT = document.body.dataset.root || '';

  var BANK = {"largest":{"a":"jupiter","pool":["mercury","venus","earth","mars","saturn","uranus","neptune"]},"smallest":{"a":"mercury","pool":["venus","earth","mars","jupiter","saturn","uranus","neptune"]},"hottest":{"a":"venus","pool":["mercury","earth","mars","jupiter","saturn","uranus","neptune"]},"coldest":{"a":"neptune","pool":["mercury","venus","earth","mars","jupiter","saturn","uranus"]},"mostMoons":{"a":"saturn","pool":["mercury","venus","earth","mars","jupiter","uranus","neptune"]},"breathable":{"a":"earth","pool":["mercury","venus","mars","jupiter","saturn","uranus","neptune"]},"closest":{"a":"mercury","pool":["venus","earth","mars","jupiter","saturn","uranus","neptune"]},"farthest":{"a":"neptune","pool":["mercury","venus","earth","mars","jupiter","saturn","uranus"]},"star":{"a":"sun","pool":["mercury","venus","earth","mars","jupiter","saturn","uranus","neptune"]},"dwarf":{"a":"pluto","pool":["mercury","venus","earth","mars","jupiter","saturn","uranus","neptune"]},"moonVisited":{"a":"moon","pool":["io","europa","ganymede","callisto","titan","enceladus","triton"]},"strongestGravity":{"a":"jupiter","pool":["mercury","venus","earth","mars","saturn","uranus","neptune"]},"shortestDay":{"a":"jupiter","pool":["mercury","venus","earth","mars","saturn","uranus","neptune"]},"longestDay":{"a":"mercury","pool":["venus","earth","mars","jupiter","saturn","uranus","neptune"]},"largestMoon":{"a":"ganymede","pool":["moon","io","europa","callisto","titan","enceladus","triton"]},"smallestMoon":{"a":"enceladus","pool":["moon","io","europa","ganymede","callisto","titan","triton"]},"thickAirMoon":{"a":"titan","pool":["moon","io","europa","ganymede","callisto","enceladus","triton"]},"geyserMoon":{"a":"enceladus","pool":["moon","io","ganymede","callisto","titan","triton"]},"volcanicMoon":{"a":"io","pool":["moon","europa","ganymede","callisto","titan","enceladus","triton"]},"backwardsMoon":{"a":"triton","pool":["moon","io","europa","ganymede","callisto","titan","enceladus"]},"biggestRocky":{"a":"earth","pool":["mercury","venus","mars"]},"coldestRocky":{"a":"mars","pool":["mercury","venus","earth"]},"highestPressure":{"a":"venus","pool":["mercury","earth","mars","jupiter","saturn","uranus","neptune"]},"secondLargest":{"a":"saturn","pool":["mercury","venus","earth","mars","jupiter","uranus","neptune"]},"longestYear":{"a":"neptune","pool":["mercury","venus","earth","mars","jupiter","saturn","uranus"]},"shortestYear":{"a":"mercury","pool":["venus","earth","mars","jupiter","saturn","uranus","neptune"]},"smallestGiant":{"a":"neptune","pool":["jupiter","saturn","uranus"]},"rockyLongestYear":{"a":"mars","pool":["mercury","venus","earth"]},"fastestMoon":{"a":"enceladus","pool":["moon","io","europa","ganymede","callisto","titan","triton"]},"slowestMoon":{"a":"moon","pool":["io","europa","ganymede","callisto","titan","enceladus","triton"]},"strongestMoonGravity":{"a":"io","pool":["moon","europa","ganymede","callisto","titan","enceladus","triton"]},"coldestMoon":{"a":"triton","pool":["moon","io","europa","ganymede","callisto","titan","enceladus"]},"secondLargestMoon":{"a":"titan","pool":["moon","io","europa","ganymede","callisto","enceladus","triton"]}};
  var KIND_KEYS = Object.keys(BANK);
  var EASY = KIND_KEYS.slice(0, 11), MEDIUM = KIND_KEYS.slice(11, 23), HARD = KIND_KEYS.slice(23);

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
      statsDownloads: 'APK downloads', statsCountries: 'Top countries',
      statsNote: 'Active means people who chose to be counted. Downloads are counted by GitHub.',
      webNote: 'On this website your language, theme and quiz scores sync. Sharing your location is only in the app.',
      loading: 'Loading…', showPassword: 'Show password',
      statsViews: 'Page views (30 days)',
      boardTitle: 'Daily 5', boardIntro: 'The same 5 questions for everybody, every day (UTC). Right answers and speed make your score.',
      boardLogin: 'Log in to play today\'s 5 and join the leaderboard.', boardPlay: 'Play today\'s 5', boardTimerNote: 'The clock starts when you press play.',
      boardQ: 'Question {n} of 5', boardSubmitting: 'Checking your answers…', boardDone: 'Today\'s result', boardPoints: '{p} points', boardRight: '{c} of 5 right',
      boardTime: '{s} s', boardRank: 'Your rank today: {r} of {n}', boardRankAll: 'All-time rank: {r}', boardToday: 'Today', boardAll: 'All time', boardEmpty: 'Nobody yet. Be the first.',
      boardHidden: 'You are hidden from the leaderboard. You can change this in your account.', boardBack: 'Come back tomorrow for 5 new questions.',
      boardTitleLb: 'Leaderboard', boardDays: '{d} days', boardErr: 'Could not reach the server. Try again in a moment.', boardReview: 'Your answers', boardYours: 'You',
      boardShow: 'Show me on the leaderboard', boardShowNote: 'Shows only your username and score. On by default; switch it off to hide.',
      welcomeTitle: 'Welcome to Astryl', welcomeSub: 'Make a free account to keep your favourites, quiz scores and rank in step between the app and this website. Or just look around.', welcomeSkip: 'Continue without account',
      webIntro: 'Optional. A username and a password, no e-mail. Your favourites, quiz scores and settings then follow you between the Astryl app and this website.'
    },
    hi: {
      bannerLater: 'अभी नहीं', statsTitle: 'Astryl आँकड़ों में', statsRegistered: 'खाते', statsActive: 'Active users (30 दिन)',
      statsDownloads: 'APK downloads', statsCountries: 'शीर्ष देश',
      statsNote: 'Active यानी वे लोग जिन्होंने गिने जाना चुना है। Downloads की गिनती GitHub करता है।',
      webNote: 'इस website पर आपकी भाषा, theme और quiz scores sync होते हैं। Location साझा करना सिर्फ़ app में है।',
      loading: 'Loading…', showPassword: 'Password दिखाएँ',
      statsViews: 'Page views (30 दिन)',
      boardTitle: 'Daily 5', boardIntro: 'हर दिन सबके लिए वही 5 सवाल (UTC)। सही जवाब और तेज़ी से आपका score बनता है।',
      boardLogin: 'आज के 5 खेलने और leaderboard में आने के लिए log in कीजिए।', boardPlay: 'आज के 5 खेलिए', boardTimerNote: 'Play दबाते ही घड़ी चालू हो जाती है।',
      boardQ: 'सवाल {n} / 5', boardSubmitting: 'जवाब जाँचे जा रहे हैं…', boardDone: 'आज का नतीजा', boardPoints: '{p} अंक', boardRight: '5 में से {c} सही',
      boardTime: '{s} सेकंड', boardRank: 'आज आपकी रैंक: {r} / {n}', boardRankAll: 'कुल रैंक: {r}', boardToday: 'आज', boardAll: 'कुल', boardEmpty: 'अभी कोई नहीं। पहले आप बनिए।',
      boardHidden: 'आप leaderboard से छिपे हैं। इसे अपने खाते में बदल सकते हैं।', boardBack: 'कल 5 नए सवालों के लिए आइए।',
      boardTitleLb: 'Leaderboard', boardDays: '{d} दिन', boardErr: 'Server से संपर्क नहीं हो पाया। थोड़ी देर में फिर कोशिश कीजिए।', boardReview: 'आपके जवाब', boardYours: 'आप',
      boardShow: 'मुझे leaderboard में दिखाएँ', boardShowNote: 'सिर्फ़ आपका username और score दिखता है। डिफ़ॉल्ट रूप से चालू; छिपने के लिए बंद कीजिए।',
      welcomeTitle: 'Astryl में स्वागत है', welcomeSub: 'मुफ़्त खाता बनाइए, ताकि आपके favourites, quiz scores और rank app और इस website में एक जैसे रहें। या बस घूमकर देखिए।', welcomeSkip: 'बिना खाते के आगे बढ़ें',
      webIntro: 'ज़रूरी नहीं। बस एक username और password, e-mail नहीं। फिर आपके favourites, quiz scores और settings Astryl app और इस website के बीच आपके साथ चलते हैं।'
    }
  };
  function w(key) { return (W[lang()] || W.en)[key] || W.en[key] || key; }
  function esc(s) { return String(s).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function onLang(fn) {
    new MutationObserver(fn).observe(document.documentElement, { attributes: true, attributeFilter: ['lang'] });
  }
  function fail(code, status) { var e = new Error(code); e.code = code; e.status = status || 0; return e; }

  /* ---------- helpers matching Dart AccountService ---------- */
  var NAME_RE = /^[a-z0-9_]{3,20}$/, CODE_ALPHA = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  function normCode(s) { return String(s || '').toUpperCase().split('').filter(function (c) { return CODE_ALPHA.indexOf(c) >= 0; }).join(''); }
  function fmtCode(s) { var c = normCode(s); return c.length === 16 ? c.slice(0, 4) + '-' + c.slice(4, 8) + '-' + c.slice(8, 12) + '-' + c.slice(12) : s; }
  function makeCode() {
    var a = new Uint8Array(16); (window.crypto || window.msCrypto).getRandomValues(a);
    var s = '';
    for (var i = 0; i < 16; i++) s += CODE_ALPHA[a[i] % CODE_ALPHA.length];
    return fmtCode(s);
  }
  function imul32(a, b) { return Math.imul(a, b) >>> 0; }
  function mix32(h) {
    var x = h >>> 0;
    x = imul32(x ^ (x >>> 16), 0x85ebca6b);
    x = imul32(x ^ (x >>> 13), 0xc2b2ae35);
    return (x ^ (x >>> 16)) >>> 0;
  }
  function utf8Bytes(str) { return new TextEncoder().encode(str); }
  function hashCodeHex(raw) {
    var clean = normCode(raw), bytes = utf8Bytes('astryl-recovery:' + clean);
    var seeds = [0x811c9dc5, 0x9e3779b9, 0x243f6a88, 0xb7e15162];
    for (var s = 0; s < seeds.length; s++) {
      var h = seeds[s] >>> 0;
      for (var i = 0; i < bytes.length; i++) {
        h = (h ^ ((bytes[i] + s * 31 + i) & 0xff)) >>> 0;
        h = imul32(h, 0x01000193);
      }
      seeds[s] = mix32(h);
    }
    return seeds.map(function (v) { return ('00000000' + (v >>> 0).toString(16)).slice(-8); }).join('');
  }
  function wrapSecret(secret, rawCode) {
    var clean = normCode(rawCode), kb = utf8Bytes('astryl-wrap:' + clean);
    var state = 0x811c9dc5;
    for (var k = 0; k < kb.length; k++) state = imul32(state ^ kb[k], 0x01000193);
    state = mix32(state);
    var plain = utf8Bytes(secret), out = '';
    for (var i = 0; i < plain.length; i++) {
      state = (state + 0x6d2b79f5) >>> 0;
      var mask = mix32(state) & 0xff;
      out += ('0' + ((plain[i] ^ mask) & 0xff).toString(16)).slice(-2);
    }
    return out;
  }
  function unwrapSecret(hexCipher, rawCode) {
    if (!hexCipher || hexCipher.length % 2 !== 0) return null;
    var clean = normCode(rawCode), kb = utf8Bytes('astryl-wrap:' + clean);
    var state = 0x811c9dc5;
    for (var k = 0; k < kb.length; k++) state = imul32(state ^ kb[k], 0x01000193);
    state = mix32(state);
    var bytes = new Uint8Array(hexCipher.length / 2);
    for (var i = 0; i < hexCipher.length; i += 2) {
      var b = parseInt(hexCipher.slice(i, i + 2), 16);
      if (isNaN(b)) return null;
      state = (state + 0x6d2b79f5) >>> 0;
      bytes[i / 2] = (b ^ (mix32(state) & 0xff)) & 0xff;
    }
    try { return new TextDecoder().decode(bytes); } catch (e) { return null; }
  }
  function uidFromToken(tk) {
    try {
      var p = JSON.parse(atob(tk.split('.')[1].replace(/-/g, '+').replace(/_/g, '/')));
      return p.user_id || p.sub || '';
    } catch (e) { throw fail('bad_token', 401); }
  }
  function toFsVal(v) {
    if (v === null || v === undefined) return { nullValue: null };
    if (typeof v === 'boolean') return { booleanValue: v };
    if (typeof v === 'number') return Number.isInteger(v) ? { integerValue: String(v) } : { doubleValue: v };
    if (typeof v === 'string') return { stringValue: v };
    return { stringValue: JSON.stringify(v) };
  }
  function toFsFields(obj) {
    var f = {};
    for (var k in obj) if (Object.prototype.hasOwnProperty.call(obj, k)) f[k] = toFsVal(obj[k]);
    return { fields: f };
  }
  function fromFsVal(raw) {
    if (!raw) return null;
    if ('stringValue' in raw) return raw.stringValue;
    if ('booleanValue' in raw) return !!raw.booleanValue;
    if ('integerValue' in raw) return parseInt(raw.integerValue, 10) || 0;
    if ('doubleValue' in raw) return Number(raw.doubleValue) || 0;
    return null;
  }
  function fromFsDoc(doc) {
    var out = {}, f = (doc && doc.fields) || {};
    for (var k in f) out[k] = fromFsVal(f[k]);
    return out;
  }
  function http(method, url, body, bearer) {
    var h = { 'Content-Type': 'application/json' };
    if (bearer) h['Authorization'] = 'Bearer ' + bearer;
    var opts = { method: method, headers: h };
    if (body !== undefined && body !== null) opts.body = JSON.stringify(body);
    return fetch(url, opts).then(function (r) {
      return r.json().catch(function () { return {}; }).then(function (j) { return { status: r.status, json: j }; });
    }, function () { throw fail('offline'); });
  }
  function getDoc(path, tk) {
    return http('GET', FS_URL + '/' + path + '?key=' + KEY, null, tk).then(function (r) {
      if (r.status === 404) return null;
      if (r.status === 401 || r.status === 403) throw fail('bad_token', r.status);
      if (r.status !== 200) throw fail('server_error', r.status);
      return fromFsDoc(r.json);
    });
  }
  function setDoc(path, fields, tk, mask) {
    var u = FS_URL + '/' + path + '?key=' + KEY;
    if (mask && mask.length) u += '&' + mask.map(function (m) { return 'updateMask.fieldPaths=' + encodeURIComponent(m); }).join('&');
    return http('PATCH', u, toFsFields(fields), tk).then(function (r) {
      if (r.status === 401 || r.status === 403) throw fail('bad_token', r.status);
      if (r.status < 200 || r.status >= 300) throw fail('server_error', r.status);
      return fromFsDoc(r.json);
    });
  }
  function delDoc(path, tk) { return http('DELETE', FS_URL + '/' + path + '?key=' + KEY, null, tk); }
  function packAuth(j) {
    var exp = parseInt(j.expiresIn || j.expires_in || '3600', 10) || 3600;
    return {
      access_token: j.idToken || j.id_token,
      refresh_token: j.refreshToken || j.refresh_token,
      expires_at: Math.floor(Date.now() / 1000) + exp,
      user_id: j.localId || j.user_id || ''
    };
  }
  function signInFb(username, password) {
    return http('POST', AUTH_URL + '/accounts:signInWithPassword?key=' + KEY, {
      email: username + '@users.astryl.space', password: password, returnSecureToken: true
    }).then(function (r) {
      if (r.status !== 200) {
        var msg = (r.json && r.json.error && r.json.error.message) || '';
        if (msg.indexOf('TOO_MANY_ATTEMPTS') >= 0) throw fail('rate_limited', 429);
        throw fail('bad_login', 401);
      }
      return r.json;
    });
  }

  /* ---------- deterministic Daily 5 questions ---------- */
  function todayUtc() { return new Date().toISOString().slice(0, 10); }
  function mulberry32(seed) {
    var a = seed >>> 0;
    return function () {
      a = (a + 0x6d2b79f5) >>> 0;
      var t = a;
      t = imul32(t ^ (t >>> 15), t | 1);
      t = (t ^ (t + imul32(t ^ (t >>> 7), t | 61))) >>> 0;
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
  }
  function shuffled(list, rnd) {
    var a = list.slice();
    for (var i = a.length - 1; i > 0; i--) {
      var j = Math.floor(rnd() * (i + 1)), tmp = a[i];
      a[i] = a[j]; a[j] = tmp;
    }
    return a;
  }
  function dailyQuestions(day) {
    var seed = parseInt(hashCodeHex(day).slice(0, 8), 16) >>> 0;
    var rnd = mulberry32(seed);
    var kinds = shuffled(shuffled(EASY, rnd).slice(0, 2).concat(shuffled(MEDIUM, rnd).slice(0, 2), shuffled(HARD, rnd).slice(0, 1)), rnd);
    return kinds.map(function (k) {
      var q = BANK[k];
      return { k: k, o: shuffled([q.a].concat(shuffled(q.pool, rnd).slice(0, 3)), rnd), a: q.a };
    });
  }
  function dailyPoints(correct, ms) {
    var speed = Math.max(0, 1 - ms / 120000);
    return correct * 100 + Math.round(correct * 20 * speed);
  }

  /* ---------- Firebase action router ---------- */
  function api(action, body, tk) {
    body = body || {};
    if (action === 'signup') {
      var u = String(body.username || '').trim().toLowerCase(), pw = String(body.password || '');
      if (!NAME_RE.test(u)) return Promise.reject(fail('bad_username', 400));
      if (pw.length < 8 || pw.length > 72) return Promise.reject(fail('bad_password', 400));
      return getDoc('usernames/' + u).then(function (ex) {
        if (ex) throw fail('username_taken', 409);
        return http('POST', AUTH_URL + '/accounts:signUp?key=' + KEY, { email: u + '@users.astryl.space', password: pw, returnSecureToken: true });
      }).then(function (r) {
        if (r.status !== 200) {
          var m = (r.json && r.json.error && r.json.error.message) || '';
          if (m.indexOf('EMAIL_EXISTS') >= 0) throw fail('username_taken', 409);
          throw fail('create_failed', 500);
        }
        var idTk = r.json.idToken, uid = r.json.localId, code = makeCode(), nowIso = new Date().toISOString();
        return Promise.all([
          setDoc('usernames/' + u, { uid: uid, createdAt: nowIso }, idTk),
          setDoc('profiles/' + uid, {
            username: u, consentVersion: 1, countMe: !!body.countMe, shareCountry: !!body.shareCountry,
            shareLocation: false, showOnBoard: body.showOnBoard !== false, country: body.shareCountry && body.country ? body.country : '',
            lastSeen: nowIso, createdAt: nowIso
          }, idTk),
          setDoc('recovery/' + uid, { codeHash: hashCodeHex(code), cipher: wrapSecret(pw, code), usesLeft: 3, username: u }, idTk),
          setDoc('user_data/' + uid, { dataJson: '{}', updatedMs: 0, pw: pw }, idTk)
        ]).then(function () {
          getDoc('stats/global').then(function (st) {
            var reg = ((st && st.registered) || 0) + 1;
            return setDoc('stats/global', { registered: reg }, null, ['registered']);
          }).catch(function () {});
          return { session: packAuth(r.json), username: u, code: code };
        });
      });
    }
    if (action === 'login') {
      var lu = String(body.username || '').trim().toLowerCase(), lpw = String(body.password || '');
      return signInFb(lu, lpw).then(function (aj) {
        var idTk = aj.idToken, uid = aj.localId;
        setDoc('profiles/' + uid, { username: lu, lastSeen: new Date().toISOString() }, idTk, ['username', 'lastSeen']).catch(function () {});
        setDoc('user_data/' + uid, { pw: lpw }, idTk, ['pw']).catch(function () {});
        return { session: packAuth(aj), username: lu };
      });
    }
    if (action === 'refresh') {
      return http('POST', TOKEN_URL + '/token?key=' + KEY, { grant_type: 'refresh_token', refresh_token: body.refresh_token }).then(function (r) {
        if (r.status !== 200) throw fail('bad_token', 401);
        return { session: packAuth(r.json) };
      });
    }
    if (action === 'recover') {
      var ru = String(body.username || '').trim().toLowerCase(), rc = normCode(body.code), npw = String(body.password || '');
      var targetUid = '', recDoc = null;
      return getDoc('usernames/' + ru).then(function (ud) {
        if (!ud || !ud.uid) throw fail('bad_recovery', 401);
        targetUid = ud.uid;
        return getDoc('recovery/' + targetUid);
      }).then(function (rd) {
        if (!rd || rd.codeHash !== hashCodeHex(rc)) throw fail('bad_recovery', 401);
        if ((rd.usesLeft || 0) <= 0) throw fail('code_used_up', 401);
        recDoc = rd;
        var oldPw = unwrapSecret(rd.cipher || '', rc);
        if (!oldPw) throw fail('bad_recovery', 401);
        return signInFb(ru, oldPw);
      }).then(function (signedIn) {
        return http('POST', AUTH_URL + '/accounts:update?key=' + KEY, { idToken: signedIn.idToken, password: npw, returnSecureToken: true }).then(function (upd) {
          if (upd.status !== 200) throw fail('update_failed', 500);
          var fTk = upd.json.idToken || signedIn.idToken, left = (recDoc.usesLeft || 1) - 1;
          var authObj = upd.json.idToken ? upd.json : signedIn;
          return Promise.all([
            setDoc('recovery/' + targetUid, { codeHash: hashCodeHex(rc), cipher: wrapSecret(npw, rc), usesLeft: left, username: ru }, fTk),
            setDoc('user_data/' + targetUid, { pw: npw }, fTk, ['pw'])
          ]).then(function () { return { session: packAuth(authObj), username: ru, usesLeft: left }; });
        });
      });
    }
    if (action === 'newcode') {
      var nuid = uidFromToken(tk), nc = makeCode();
      return Promise.all([getDoc('user_data/' + nuid, tk), getDoc('profiles/' + nuid, tk)]).then(function (arr) {
        var pw = (arr[0] && arr[0].pw) || '', un = (arr[1] && arr[1].username) || '';
        return setDoc('recovery/' + nuid, { codeHash: hashCodeHex(nc), cipher: wrapSecret(pw, nc), usesLeft: 3, username: un }, tk);
      }).then(function () { return { code: nc }; });
    }
    if (action === 'pull') {
      var puid = uidFromToken(tk);
      return Promise.all([getDoc('profiles/' + puid, tk), getDoc('user_data/' + puid, tk)]).then(function (arr) {
        var prof = arr[0], uData = arr[1];
        if (!prof) throw fail('no_profile', 404);
        var parsed = null;
        if (uData && uData.dataJson && uData.dataJson !== '{}') {
          try { parsed = JSON.parse(uData.dataJson); } catch (e) { parsed = null; }
        }
        return {
          data: parsed, updatedMs: (uData && uData.updatedMs) || 0, username: prof.username || '',
          prefs: { countMe: !!prof.countMe, shareCountry: !!prof.shareCountry, shareLocation: !!prof.shareLocation, showOnBoard: prof.showOnBoard !== false }
        };
      });
    }
    if (action === 'push') {
      var huid = uidFromToken(tk), nowMs = Date.now(), enc = JSON.stringify(body.data || {});
      return setDoc('user_data/' + huid, { dataJson: enc, updatedMs: nowMs }, tk, ['dataJson', 'updatedMs']).then(function () { return { updatedMs: nowMs }; });
    }
    if (action === 'prefs') {
      var fuid = uidFromToken(tk);
      var flds = { countMe: !!body.countMe, shareCountry: !!body.shareCountry, shareLocation: false, country: body.shareCountry && body.country ? body.country : '' };
      var msk = ['countMe', 'shareCountry', 'shareLocation', 'country'];
      if (typeof body.showOnBoard === 'boolean') { flds.showOnBoard = body.showOnBoard; msk.push('showOnBoard'); }
      return setDoc('profiles/' + fuid, flds, tk, msk).then(function () { return { ok: true }; });
    }
    if (action === 'delete') {
      var duid = uidFromToken(tk);
      return getDoc('profiles/' + duid, tk).then(function (prof) {
        var un = (prof && prof.username) || '';
        return signInFb(un, String(body.password || '')).then(function (si) {
          var aTk = si.idToken || tk;
          return Promise.all([
            delDoc('user_data/' + duid, aTk), delDoc('recovery/' + duid, aTk), delDoc('profiles/' + duid, aTk),
            un ? delDoc('usernames/' + un, aTk) : Promise.resolve()
          ]).then(function () { return http('POST', AUTH_URL + '/accounts:delete?key=' + KEY, { idToken: aTk }); });
        });
      }).then(function () { return { ok: true }; });
    }
    if (action === 'ping') {
      var day = todayUtc(), dev = String(body.device || 'anon');
      return setDoc('pings/' + day + '_' + dev, { day: day, device: dev, country: body.country || '', ts: Date.now() }).then(function () {
        return getDoc('stats/global').then(function (st) {
          var act = ((st && st.active_30d) || 0) + 1;
          return setDoc('stats/global', { active_30d: act, active_today: act }, null, ['active_30d', 'active_today']);
        }).catch(function () {});
      }).then(function () { return { ok: true }; });
    }
    if (action === 'visit') {
      var vday = todayUtc();
      return getDoc('stats/global').then(function (st) {
        var v = ((st && st.views_30d) || 0) + 1;
        return setDoc('stats/global', { views_30d: v }, null, ['views_30d']);
      }).then(function () { return { ok: true }; }).catch(function () { return { ok: true }; });
    }
    if (action === 'stats') {
      return getDoc('stats/global').then(function (st) {
        st = st || {};
        var countries = [];
        if (st.countriesJson) { try { countries = JSON.parse(st.countriesJson); } catch (e) {} }
        if (!st.registered && !st.views_30d) {
          setDoc('stats/global', { registered: 1, active_today: 1, active_7d: 1, active_30d: 1, views_30d: 1 }, null).catch(function () {});
        }
        return {
          registered: st.registered || 0, active_today: st.active_today || 0,
          active_7d: st.active_7d || 0, active_30d: st.active_30d || 0,
          views_30d: st.views_30d || 0, countries: countries
        };
      });
    }
    if (action === 'daily_start') {
      var qUid = uidFromToken(tk), qDay = todayUtc(), qs = dailyQuestions(qDay), runId = qDay + '_' + qUid;
      return getDoc('daily_runs/' + runId, tk).then(function (run) {
        if (!run) {
          var sess = getSession();
          var init = { uid: qUid, username: (sess && sess.username) || '', day: qDay, startedAtMs: Date.now(), finishedAtMs: 0, correct: 0, ms: 0, points: 0, showOnBoard: getPrefs().showOnBoard !== false };
          return setDoc('daily_runs/' + runId, init, tk).then(function () { return init; });
        }
        return run;
      }).then(function (run) {
        if (run.finishedAtMs && run.finishedAtMs > 0) {
          return { day: qDay, done: true, correct: run.correct || 0, ms: run.ms || 0, points: run.points || 0, questions: qs };
        }
        return { day: qDay, done: false, elapsedMs: Math.max(0, Date.now() - (run.startedAtMs || Date.now())), questions: qs.map(function (q) { return { k: q.k, o: q.o }; }) };
      });
    }
    if (action === 'daily_submit') {
      var sUid = uidFromToken(tk), sDay = todayUtc(), sQs = dailyQuestions(sDay), sRunId = sDay + '_' + sUid;
      var ans = body.answers || [];
      return getDoc('daily_runs/' + sRunId, tk).then(function (run) {
        if (!run) throw fail('not_started', 404);
        if (run.finishedAtMs && run.finishedAtMs > 0) throw fail('already_done', 409);
        var corr = 0;
        sQs.forEach(function (q, i) { if (ans[i] === q.a) corr++; });
        var ms = Math.min(1800000, Math.max(3000, Date.now() - (run.startedAtMs || Date.now())));
        var pts = dailyPoints(corr, ms);
        var sess = getSession();
        return setDoc('daily_runs/' + sRunId, {
          uid: sUid, username: (sess && sess.username) || run.username || '', day: sDay,
          startedAtMs: run.startedAtMs || Date.now(), finishedAtMs: Date.now(),
          correct: corr, ms: ms, points: pts, showOnBoard: getPrefs().showOnBoard !== false
        }, tk).then(function () {
          return { day: sDay, correct: corr, ms: ms, points: pts, answers: sQs.map(function (q) { return q.a; }) };
        });
      });
    }
    if (action === 'board') {
      var bDay = todayUtc(), myUid = null;
      if (tk) { try { myUid = uidFromToken(tk); } catch (e) { myUid = null; } }
      return http('GET', FS_URL + '/daily_runs?pageSize=200&key=' + KEY).then(function (r) {
        var docs = (r.json && r.json.documents) ? r.json.documents.map(fromFsDoc) : [];
        var finished = docs.filter(function (d) { return d.finishedAtMs && d.finishedAtMs > 0 && d.showOnBoard !== false && d.username; });
        var todayList = finished.filter(function (d) { return d.day === bDay; }).sort(function (a, b) { return (b.points - a.points) || (a.ms - b.ms); });
        var byUser = {};
        finished.forEach(function (d) {
          var u = d.username;
          if (!byUser[u]) byUser[u] = { u: u, p: 0, d: 0, uid: d.uid };
          byUser[u].p += (d.points || 0);
          byUser[u].d += 1;
        });
        var allList = Object.keys(byUser).map(function (u) { return byUser[u]; }).sort(function (a, b) { return b.p - a.p; });
        var meToday = null, meAll = null;
        if (myUid) {
          var myTodayDoc = docs.find(function (d) { return d.uid === myUid && d.day === bDay && d.finishedAtMs > 0; });
          if (myTodayDoc) {
            var rIdx = todayList.findIndex(function (x) { return x.uid === myUid; });
            meToday = { rank: rIdx >= 0 ? rIdx + 1 : 1, points: myTodayDoc.points };
          }
          var aIdx = allList.findIndex(function (x) { return x.uid === myUid; });
          if (aIdx >= 0) meAll = { rank: aIdx + 1, points: allList[aIdx].p };
        }
        return {
          today: todayList.slice(0, 20).map(function (d) { return { u: d.username, p: d.points, c: d.correct, ms: d.ms }; }),
          all: allList.slice(0, 20).map(function (d) { return { u: d.u, p: d.p, d: d.d }; }),
          players_today: todayList.length,
          me_today: meToday,
          me_all: meAll
        };
      });
    }
    return Promise.reject(fail('unknown_action', 400));
  }

  function errText(e) {
    var map = { offline: 'acctErrOffline', username_taken: 'acctErrTaken', bad_username: 'acctErrUsername', bad_password: 'acctErrPassword',
      bad_login: 'acctErrLogin', bad_recovery: 'acctErrRecovery', code_used_up: 'acctErrUsedUp', locked: 'acctErrLocked', rate_limited: 'acctErrRate' };
    return t(map[e && e.code] || 'acctErrGeneric');
  }

  /* ---------- what is kept in this browser ---------- */
  function getSession() { try { return JSON.parse(store.get('astryl-session') || 'null'); } catch (e) { return null; } }
  function setSession(s) { store.set('astryl-session', JSON.stringify(s)); store.set('astryl-gate', '1'); }
  function clearSession() { store.del('astryl-session'); }
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
      var lc = store.get('astryl-lang'), th = store.get('astryl-theme');
      if (remoteWins) {
        if ((remote.locale === 'en' || remote.locale === 'hi') && remote.locale !== (lc || '')) { store.set('astryl-lang', remote.locale); reload = true; }
        if (remote.theme === 'dark' || remote.theme === 'light') {
          if (remote.theme !== th) { store.set('astryl-theme', remote.theme); reload = true; }
        } else if (remote.theme === 'system' && th) { store.del('astryl-theme'); reload = true; }
      } else {
        if (lc) merged.locale = lc;
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
      '<div class="gate-card"><button class="btn gate-lang" id="gateLang" type="button"></button>' +
      '<h1 id="gateTitle"></h1><p class="sub" id="gateSub"></p>' +
      '<div id="acct"></div>' +
      '<p class="gate-skip"><button class="btn" id="gateSkip" type="button"></button></p></div>';
    document.body.appendChild(el); gateEl = el; document.body.classList.add('gate-open');
    function paint() {
      $('#gateTitle').textContent = w('welcomeTitle'); $('#gateSub').textContent = w('welcomeSub');
      $('#gateSkip').textContent = w('welcomeSkip') + ' →';
      $('#gateLang').textContent = lang() === 'hi' ? 'English' : 'हिन्दी';
    }
    paint(); onLang(paint);
    $('#gateSkip').addEventListener('click', function () { closeGate(true); });
    $('#gateLang').addEventListener('click', function () { var b = $('#langBtn'); if (b) b.click(); });
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
  function draw() {
    var root = $('#acct'); if (!root) return;
    var s = getSession(), h = '';
    if (s && !ui.code && gateEl) { closeGate(true); }
    if (ui.code) {
      h = '<h2>' + esc(t('acctCodeTitle')) + '</h2><p>' + esc(t('acctCodeWarn')) + '</p>' + codeCard(ui.code) +
        check('saved', t('acctCodeSaved'), '', ui.saved) +
        '<p><button class="btn primary" type="button" data-act="codeDone"' + (ui.saved ? '' : ' disabled') + '>' + esc(t('acctContinue')) + '</button></p>';
    } else if (s) {
      var p = getPrefs();
      h = '<div class="card"><b>' + esc(t('acctLoggedInAs', { name: s.username })) + '</b></div>' +
        '<div class="card">' + check('syncOn', t('acctSync'), t('acctSyncNote'), p.syncOn) +
        '<p><button class="btn" type="button" data-act="syncNow"' + (syncing || !p.syncOn ? ' disabled' : '') + '>' + esc(t('acctSyncNow')) + '</button> <span class="note">' +
        esc({ syncing: t('acctSyncing'), ok: t('acctSyncOk'), failed: t('acctSyncFailed') }[syncStatus] || '') + '</span></p></div>' +
        '<h3>' + esc(t('acctOptionalTitle')) + '</h3><div class="card">' +
        check('showOnBoard', w('boardShow'), w('boardShowNote'), p.showOnBoard) + check('countMe', t('acctCountMe'), t('acctCountMeNote'), p.countMe) + check('shareCountry', t('acctShareCountry'), t('acctShareCountryNote'), p.shareCountry) + '</div>' +
        '<p class="note">' + esc(w('webNote')) + '</p>' +
        (ui.newCode ? '<div class="card"><h3>' + esc(t('acctCodeTitle')) + '</h3><p>' + esc(t('acctCodeWarn')) + '</p>' + codeCard(ui.newCode) + '</div>' : '') +
        '<div class="btns"><button class="btn" type="button" data-act="newCode">' + esc(t('acctNewCode')) + '</button><button class="btn" type="button" data-act="logout">' + esc(t('acctLogOut')) + '</button></div>' +
        '<p class="note">' + esc(t('acctNewCodeNote')) + '</p>' +
        '<div class="card danger"><h3>' + esc(t('acctDelete')) + '</h3><p>' + esc(t('acctDeleteNote')) + '</p>' +
        (ui.del ? '<p>' + esc(t('acctDeleteConfirmBody')) + '</p>' + field('delpass', t('acctPassword'), 'password', '', 'current-password') +
          '<p><button class="btn danger-btn" type="button" data-act="delete"' + (ui.busy ? ' disabled' : '') + '>' + esc(t('acctDeleteButton')) + '</button> <button class="btn" type="button" data-act="delCancel">' + esc(t('cancel')) + '</button></p>'
          : '<p><button class="btn danger-btn" type="button" data-act="delAsk">' + esc(t('acctDelete')) + '</button></p>') +
        (ui.delMsg ? '<p class="no">' + esc(ui.delMsg) + '</p>' : '') + '</div>';
    } else {
      var create = ui.mode === 'create', recover = ui.mode === 'recover';
      h = gateEl ? '' : '<p class="sub">' + esc(w('webIntro')) + '</p>';
      if (!recover) h += '<div class="tabs"><button type="button" class="' + (create ? 'on' : '') + '" data-act="mode:create">' + esc(t('acctTabCreate')) + '</button><button type="button" class="' + (!create ? 'on' : '') + '" data-act="mode:login">' + esc(t('acctTabLogin')) + '</button></div>';
      else h += '<h2>' + esc(t('acctRecoverTitle')) + '</h2>';
      h += field('user', t('acctUsername'), 'text', create || recover ? t('acctUsernameHint') : '', 'username');
      if (recover) h += field('code', t('acctRecoverCode'), 'text', 'XXXX-XXXX-XXXX-XXXX');
      h += field('pass', recover ? t('acctRecoverNewPassword') : t('acctPassword'), pwType(), create || recover ? t('acctPasswordHint') : '', create || recover ? 'new-password' : 'current-password');
      if (create) h += field('pass2', t('acctPasswordAgain'), pwType(), '', 'new-password');
      h += check('show', w('showPassword'), '', ui.show);
      if (create) {
        h += check('consent', t('acctConsent'), '', !!ui.f.consent) + '<p><a href="' + ROOT + 'privacy.html" target="_blank" rel="noopener">' + esc(t('acctReadPolicy')) + '</a></p>' +
          '<h3>' + esc(t('acctOptionalTitle')) + '</h3>' + check('showOnBoard', w('boardShow'), w('boardShowNote'), ui.f.showOnBoard !== false) + check('countMe', t('acctCountMe'), t('acctCountMeNote'), !!ui.f.countMe) + check('shareCountry', t('acctShareCountry'), t('acctShareCountryNote'), !!ui.f.shareCountry) +
          '<p class="note">' + esc(w('webNote')) + '</p>';
      }
      if (ui.err) h += '<p class="no">' + esc(ui.err) + '</p>';
      h += '<p><button class="btn primary" type="button" data-act="submit"' + (ui.busy || (create && !ui.f.consent) ? ' disabled' : '') + '>' + esc(create ? t('acctTabCreate') : recover ? t('acctRecoverButton') : t('acctTabLogin')) + '</button></p>';
      if (ui.mode === 'login') h += '<p><a href="#" data-act="mode:recover">' + esc(t('acctForgot')) + '</a></p>';
      if (recover) h += '<p><a href="#" data-act="mode:login">' + esc(t('acctBackToLogin')) + '</a></p>';
    }
    if (ui.notice) h = '<p class="ok"><b>' + esc(ui.notice) + '</b></p>' + h;
    root.innerHTML = h;
  }
  function saveFields() {
    var root = $('#acct'); if (!root) return;
    Array.prototype.forEach.call(root.querySelectorAll('input[data-f]'), function (el) { ui.f[el.dataset.f] = el.value; });
  }
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
    run().then(function () { ui.busy = false; draw(); if (ui.mode === 'create' && getSession()) sync(); ping(); }, function (e) { ui.busy = false; ui.err = errText(e); draw(); });
  }
  function onClick(e) {
    var el = e.target.closest ? e.target.closest('[data-act]') : null;
    if (!el || !$('#acct') || !$('#acct').contains(el)) return;
    var act = el.dataset.act; e.preventDefault();
    saveFields(); ui.notice = '';
    if (act.indexOf('mode:') === 0) { ui.mode = act.slice(5); ui.err = ''; ui.f.pass = ''; ui.f.pass2 = ''; return draw(); }
    if (act === 'submit') return submit();
    if (act === 'copy') {
      var txt = ui.code || ui.newCode || '';
      try { navigator.clipboard.writeText(txt); el.textContent = t('acctCopied'); } catch (x) { var r = document.createRange(); r.selectNodeContents($('#codeText')); var sel = getSelection(); sel.removeAllRanges(); sel.addRange(r); }
      return;
    }
    if (act === 'codeDone') { ui.code = null; return draw(); }
    if (act === 'syncNow') return void sync();
    if (act === 'newCode') return void token().then(function (k) { return api('newcode', {}, k); }).then(function (j) { ui.newCode = fmtCode(j.code); draw(); }, function (x) { ui.delMsg = errText(x); draw(); });
    if (act === 'logout') { clearSession(); ui.newCode = null; ui.del = false; ui.mode = 'login'; return draw(); }
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
    root.addEventListener('change', onChange);
    root.addEventListener('input', function (e) { if (e.target.dataset && e.target.dataset.f) ui.f[e.target.dataset.f] = e.target.value; });
    root.addEventListener('keydown', function (e) { if (e.key === 'Enter' && e.target.dataset && e.target.dataset.f && !ui.code && !getSession()) { e.preventDefault(); submit(); } });
    draw(); onLang(draw);
    if (getSession()) sync();
  }

  /* ---------- the public counter ---------- */
  function statsBlock() {
    var box = $('#stats'); if (!box || !window.fetch) return;
    var data = {};
    function paint() {
      var n = function (v) { return v === undefined ? '–' : Number(v).toLocaleString(lang() === 'hi' ? 'hi-IN' : 'en-US'); };
      var h = '<div class="stat"><b>' + n(data.registered) + '</b><span>' + esc(w('statsRegistered')) + '</span></div><div class="stat"><b>' + n(data.active) + '</b><span>' + esc(w('statsActive')) + '</span></div><div class="stat"><b>' + n(data.views) + '</b><span>' + esc(w('statsViews')) + '</span></div><div class="stat"><b>' + n(data.downloads) + '</b><span>' + esc(w('statsDownloads')) + '</span></div>';
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
    api('stats').then(function (j) {
      data.registered = j.registered; data.active = j.active_30d; data.views = j.views_30d; data.countries = j.countries; paint();
    }).catch(function () {});
    fetch('https://api.github.com/repos/' + REPO + '/releases?per_page=100').then(function (r) { return r.ok ? r.json() : Promise.reject(); }).then(function (rs) {
      var total = 0;
      rs.forEach(function (r) { (r.assets || []).forEach(function (a) { if (/\.apk$/i.test(a.name)) total += a.download_count || 0; }); });
      data.downloads = total; paint();
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
    var d = { phase: 'idle', qs: [], i: 0, picked: [], startAt: 0, result: null, answers: null, board: null, tab: 'today', err: '', busy: false }, tick = null;
    function me() { return getSession(); }
    function loadBoard() {
      var go = function (k) { return api('board', {}, k); };
      (me() ? token().then(go, function () { return go(); }) : go()).then(function (j) {
        d.board = j;
        if (j.me_today && d.phase === 'idle') return start();
        draw();
      }, function () { d.board = null; draw(); });
    }
    function board() {
      var b = d.board, h = '<h3>' + esc(w('boardTitleLb')) + '</h3><div class="tabs"><button type="button" class="' + (d.tab === 'today' ? 'on' : '') + '" data-dl="tab:today">' + esc(w('boardToday')) + '</button><button type="button" class="' + (d.tab === 'all' ? 'on' : '') + '" data-dl="tab:all">' + esc(w('boardAll')) + '</button></div>';
      if (!b) return h + '<p class="note">' + esc(w('loading')) + '</p>';
      var rows = d.tab === 'today' ? b.today : b.all, mine = me() ? me().username : '';
      if (!rows.length) h += '<p class="note">' + esc(w('boardEmpty')) + '</p>';
      else {
        h += '<ol class="lb">';
        rows.forEach(function (r) {
          var sub = d.tab === 'today' ? fill(w('boardRight'), { c: r.c }) + ' · ' + fill(w('boardTime'), { s: sec(r.ms) }) : fill(w('boardDays'), { d: r.d });
          h += '<li' + (r.u === mine ? ' class="me"' : '') + '><span class="nm">' + esc(r.u) + (r.u === mine ? ' (' + esc(w('boardYours')) + ')' : '') + '<small>' + esc(sub) + '</small></span><b>' + r.p + '</b></li>';
        });
        h += '</ol>';
      }
      var m = d.tab === 'today' ? b.me_today : b.me_all;
      if (m) h += '<p class="note"><b>' + esc(d.tab === 'today' ? fill(w('boardRank'), { r: m.rank, n: b.players_today }) : fill(w('boardRankAll'), { r: m.rank })) + '</b></p>';
      if (me() && !getPrefs().showOnBoard) h += '<p class="note">' + esc(w('boardHidden')) + '</p>';
      return h;
    }
    function review() {
      var h = '<h3>' + esc(w('boardReview')) + '</h3>';
      d.qs.forEach(function (q, i) {
        var right = d.answers && d.answers[i], mine = d.picked[i];
        h += '<div class="card"><b>' + esc(qText(q.k)) + '</b><p>' + (right ? '<span class="' + (mine === right ? 'ok' : 'no') + '">' + esc(mine ? bodyName(mine) : '–') + '</span>' + (mine !== right ? ' → <b>' + esc(bodyName(right)) + '</b>' : '') : '') + '</p></div>';
      });
      return h;
    }
    function resultCard() {
      var r = d.result;
      return '<div class="card" style="text-align:center"><h3>' + esc(w('boardDone')) + '</h3><div class="life">' + r.points + '</div><p>' + esc(fill(w('boardRight'), { c: r.correct }) + ' · ' + fill(w('boardTime'), { s: sec(r.ms) })) + '</p><p class="note">' + esc(w('boardBack')) + '</p></div>';
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
      else if (d.phase === 'done') h += resultCard() + review();
      h += board();
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
        if (j.done) { d.phase = 'done'; d.result = { points: j.points, correct: j.correct, ms: j.ms }; d.answers = j.questions.map(function (q) { return q.a; }); d.picked = []; }
        else { d.phase = 'play'; d.startAt = Date.now() - (j.elapsedMs || 0); }
        draw(); loadBoard();
      }, function (e) { d.busy = false; d.err = errText(e); draw(); });
    }
    function submit() {
      d.phase = 'check'; draw();
      token().then(function (k) { return api('daily_submit', { answers: d.picked }, k); }).then(function (j) {
        d.result = j; d.answers = j.answers; d.phase = 'done'; draw(); loadBoard();
      }, function (e) { d.phase = 'idle'; d.err = e && e.code === 'already_done' ? '' : errText(e); draw(); loadBoard(); });
    }
    root.addEventListener('click', function (e) {
      var el = e.target.closest('[data-dl]'); if (!el) return;
      var a = el.dataset.dl;
      if (a === 'play') return start();
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

  welcome(); accountPage(); dailyPage(); statsBlock(); ping(); track();
  if (getSession() && !$('#acct')) sync();
})();
