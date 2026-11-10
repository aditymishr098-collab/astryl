/* Astryl website: language, theme, and the interactive pages.
   All the maths below is a port of the app's own Dart code (lib/core), so the
   website and the app agree. Nothing is sent anywhere. */
(function () {
  'use strict';
  var D = window.ASTRYL;
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var $$ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };
  var store = {
    get: function (k) { try { return localStorage.getItem(k); } catch (e) { return null; } },
    set: function (k, v) { try { localStorage.setItem(k, v); } catch (e) {} }
  };

  /* ---------- language and theme ---------- */
  var lang = store.get('astryl-lang') || ((navigator.language || 'en').slice(0, 2) === 'hi' ? 'hi' : 'en');
  if (lang !== 'hi') lang = 'en';
  var page = document.body.dataset.page || '';
  var renderers = [];

  function t(key, params) {
    var s = (D.L[lang] && D.L[lang][key]) || D.L.en[key] || key;
    if (params) for (var k in params) s = s.split('{' + k + '}').join(params[k]);
    return s;
  }
  function fmt(n, dec) {
    return Number(n).toLocaleString(lang === 'hi' ? 'hi-IN' : 'en-US', { maximumFractionDigits: dec || 0, minimumFractionDigits: 0 });
  }
  function setLang(l) {
    lang = l;
    document.documentElement.lang = l;
    store.set('astryl-lang', l);
    var b = $('#langBtn'); if (b) b.textContent = l === 'hi' ? 'English' : 'हिन्दी';
    renderers.forEach(function (f) { f(); });
    changed();
  }
  function changed() { try { document.dispatchEvent(new Event('astryl-change')); } catch (e) {} }
  function onRender(f) { renderers.push(f); f(); }

  var theme = store.get('astryl-theme') || 'dark';
  function isDark() { return theme !== 'light'; }
  function applyTheme() {
    if (isDark()) document.documentElement.setAttribute('data-theme', 'dark');
    else document.documentElement.removeAttribute('data-theme');
    var b = $('#themeBtn'); if (b) b.textContent = isDark() ? '☀' : '☾';
  }
  applyTheme();
  document.addEventListener('click', function (e) {
    if (e.target.id === 'langBtn') setLang(lang === 'hi' ? 'en' : 'hi');
    if (e.target.id === 'themeBtn') {
      theme = isDark() ? 'light' : 'dark'; store.set('astryl-theme', theme); applyTheme(); changed();
    }
  });

  /* ---------- body helpers ---------- */
  var byId = {}; D.bodies.forEach(function (b) { byId[b.id] = b; });
  var NAME = { mercury: 'planetMercury', venus: 'planetVenus', earth: 'planetEarth', mars: 'planetMars', jupiter: 'planetJupiter', saturn: 'planetSaturn', uranus: 'planetUranus', neptune: 'planetNeptune', sun: 'bodySun', moon: 'bodyMoon', pluto: 'bodyPluto', io: 'moonIo', europa: 'moonEuropa', ganymede: 'moonGanymede', callisto: 'moonCallisto', titan: 'moonTitan', enceladus: 'moonEnceladus', triton: 'moonTriton' };
  function bname(id) { return t(NAME[id] || id); }
  var planets = D.bodies.filter(function (b) { return b.kind === 'planet'; });
  var moonsAll = D.bodies.filter(function (b) { return b.kind === 'moon'; });
  var EARTH_G = 9.8;
  function relG(b) { return b.g / EARTH_G; }

  var PT = {
    diameter: function (b) { return t('valueKm', { value: fmt(b.diam) }); },
    gravity: function (b) { return fmt(b.g, 1) + ' m/s² (' + fmt(relG(b), 2) + ' g)'; },
    temp: function (b) { return fmt(b.temp) + ' °C'; },
    day: function (b) { return b.day > 48 ? t('valueDays', { value: fmt(b.day / 24, 1) }) : t('valueHours', { value: fmt(b.day, 1) }); },
    year: function (b) { if (b.year <= 0) return '–'; return b.year > 1000 ? t('valueYears', { value: fmt(b.year / 365.25, 1) }) : t('valueDays', { value: fmt(b.year, 1) }); },
    distance: function (b) { if (b.kind === 'star') return '–'; var f = b.kind === 'moon' ? byId[b.parent] : b; return t('valueMillionKm', { value: fmt(f.dist, 1) }); },
    pressure: function (b) { if (b.bar === null) return t('noSurface'); if (b.bar === 0) return '≈ 0 bar'; if (b.bar < 0.001) return '< 0.001 bar'; return fmt(b.bar, 3) + ' bar'; },
    duration: function (sec) {
      if (sec < 60) return t('valueSeconds', { value: fmt(sec, 1) });
      var m = sec / 60; if (m < 60) return t('valueMinutes', { value: fmt(m, m < 10 ? 1 : 0) });
      var h = m / 60; if (h < 48) return t('valueHours', { value: fmt(h, 1) });
      var d = h / 24; if (d < 730) return t('valueDays', { value: fmt(d) });
      var y = d / 365.25; return t('valueYears', { value: fmt(y, y < 100 ? 1 : 0) });
    },
    km: function (km) { return km < 1e6 ? t('valueKm', { value: fmt(km) }) : km < 1e9 ? t('valueMillionKm', { value: fmt(km / 1e6, 1) }) : t('valueBillionKm', { value: fmt(km / 1e9, 2) }); }
  };

  /* ---------- orbits (port of lib/core/orbits.dart and sky.dart) ---------- */
  var KM_AU = 149597870.7, C_KMS = 299792.458;
  function rad(d) { return d * Math.PI / 180; }
  function deg(r) { return r * 180 / Math.PI; }
  function esc(x) { return String(x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function n360(d) { return ((d % 360) + 360) % 360; }
  var MIN = Date.UTC(1800, 0, 1), MAX = Date.UTC(2050, 11, 31);
  function clampMs(ms) { return Math.min(MAX, Math.max(MIN, ms)); }
  function jd(ms) { return ms / 86400000 + 2440587.5; }
  function helio(id, ms) {
    var el = D.orbits[id], T = (jd(clampMs(ms)) - 2451545) / 36525;
    var a = el[0] + el[1] * T, e = el[2] + el[3] * T, inc = rad(el[4] + el[5] * T);
    var l = el[6] + el[7] * T, peri = el[8] + el[9] * T, node = rad(el[10] + el[11] * T);
    var omega = rad(peri) - node, m = n360(l - peri); if (m > 180) m -= 360; m = rad(m);
    var E = m + e * Math.sin(m);
    for (var k = 0; k < 10; k++) { var d = (E - e * Math.sin(E) - m) / (1 - e * Math.cos(E)); E -= d; if (Math.abs(d) < 1e-10) break; }
    var xp = a * (Math.cos(E) - e), yp = a * Math.sqrt(1 - e * e) * Math.sin(E);
    var cw = Math.cos(omega), sw = Math.sin(omega), cn = Math.cos(node), sn = Math.sin(node), ci = Math.cos(inc), si = Math.sin(inc);
    return { x: (cw * cn - sw * sn * ci) * xp + (-sw * cn - cw * sn * ci) * yp, y: (cw * sn + sw * cn * ci) * xp + (-sw * sn + cw * cn * ci) * yp, z: (sw * si) * xp + (cw * si) * yp };
  }
  function distFromEarthKm(id, ms) {
    var e = helio('earth', ms);
    if (id === 'sun') return Math.sqrt(e.x * e.x + e.y * e.y + e.z * e.z) * KM_AU;
    var p = helio(id, ms), dx = p.x - e.x, dy = p.y - e.y, dz = p.z - e.z;
    return Math.sqrt(dx * dx + dy * dy + dz * dz) * KM_AU;
  }
  function sunLon(ms) { var e = helio('earth', clampMs(ms)); return n360(deg(Math.atan2(-e.y, -e.x))); }
  function moonEcl(ms) {
    var d = jd(ms) - 2451543.5, n = n360(125.1228 - 0.0529538083 * d), inc = 5.1454, w = n360(318.0634 + 0.1643573223 * d), a = 60.2666, e = 0.0549, m = n360(115.3654 + 13.0649929509 * d);
    var mr = rad(m), ecc = mr + e * Math.sin(mr) * (1 + e * Math.cos(mr));
    for (var k = 0; k < 8; k++) ecc -= (ecc - e * Math.sin(ecc) - mr) / (1 - e * Math.cos(ecc));
    var xv = a * (Math.cos(ecc) - e), yv = a * Math.sqrt(1 - e * e) * Math.sin(ecc), v = deg(Math.atan2(yv, xv)), r = Math.sqrt(xv * xv + yv * yv);
    var nr = rad(n), vw = rad(v + w), ir = rad(inc);
    var xh = r * (Math.cos(nr) * Math.cos(vw) - Math.sin(nr) * Math.sin(vw) * Math.cos(ir));
    var yh = r * (Math.sin(nr) * Math.cos(vw) + Math.cos(nr) * Math.sin(vw) * Math.cos(ir));
    var zh = r * (Math.sin(vw) * Math.sin(ir));
    var lon = deg(Math.atan2(yh, xh)), lat = deg(Math.atan2(zh, Math.sqrt(xh * xh + yh * yh)));
    var ms_ = rad(356.047 + 0.9856002585 * d), ws = 282.9404 + 4.70935e-5 * d, ls = deg(ms_) + ws, lm = m + w + n, dd = rad(lm - ls), f = rad(lm - n), mm = mr;
    lon += -1.274 * Math.sin(mm - 2 * dd) + 0.658 * Math.sin(2 * dd) - 0.186 * Math.sin(ms_) - 0.059 * Math.sin(2 * mm - 2 * dd) - 0.057 * Math.sin(mm - 2 * dd + ms_) + 0.053 * Math.sin(mm + 2 * dd) + 0.046 * Math.sin(2 * dd - ms_) + 0.041 * Math.sin(mm - ms_) - 0.035 * Math.sin(dd) - 0.031 * Math.sin(mm + ms_) - 0.015 * Math.sin(2 * f - 2 * dd) + 0.011 * Math.sin(mm - 4 * dd);
    lat += -0.173 * Math.sin(f - 2 * dd) - 0.055 * Math.sin(mm - f - 2 * dd) - 0.046 * Math.sin(mm + f - 2 * dd) + 0.033 * Math.sin(f + 2 * dd) + 0.017 * Math.sin(2 * mm + f);
    lon -= 0.01397 * (jd(ms) - 2451545) / 365.25;
    return { lon: n360(lon), lat: lat };
  }
  function moonPhase(ms) {
    var m = moonEcl(ms), s = sunLon(ms), age = n360(m.lon - s), cosE = Math.cos(rad(m.lat)) * Math.cos(rad(m.lon - s));
    return { age: age, lit: (1 - cosE) / 2 };
  }
  function phaseIndex(age) { var a = n360(age); return a < 10 || a >= 350 ? 0 : a < 80 ? 1 : a < 100 ? 2 : a < 170 ? 3 : a < 190 ? 4 : a < 260 ? 5 : a < 280 ? 6 : 7; }
  var PHASE = ['phaseNew', 'phaseWaxingCrescent', 'phaseFirstQuarter', 'phaseWaxingGibbous', 'phaseFull', 'phaseWaningGibbous', 'phaseLastQuarter', 'phaseWaningCrescent'];
  function nextPhase(fromMs, target) {
    function gap(x) { var g = n360(moonPhase(x).age - target); return g > 180 ? g - 360 : g; }
    var a = fromMs, ga = gap(a);
    for (var i = 0; i < 140; i++) {
      var b = a + 6 * 3600000, gb = gap(b);
      if (ga < 0 && gb >= 0) { var lo = a, hi = b; for (var k = 0; k < 20; k++) { var mid = lo + (hi - lo) / 2; if (gap(mid) < 0) lo = mid; else hi = mid; } return lo + (hi - lo) / 2; }
      a = b; ga = gb;
    }
    return fromMs;
  }
  function moonSvg(age, size) {
    var R = 20, c = Math.cos(rad(age)), wan = age > 180, a2 = wan ? 360 - age : age, cc = Math.cos(rad(a2)), rx = Math.abs(cc) * R;
    var sweep = cc > 0 ? 0 : 1;
    var lit = '<path d="M0,-' + R + ' A' + R + ',' + R + ' 0 0 1 0,' + R + ' A' + rx.toFixed(2) + ',' + R + ' 0 0 ' + sweep + ' 0,-' + R + 'Z" fill="#e9e6da" transform="' + (wan ? 'scale(-1,1)' : '') + '"/>';
    return '<svg viewBox="-22 -22 44 44" width="' + size + '" height="' + size + '"><circle r="' + R + '" fill="#2a2f4a"/>' + lit + '<circle r="' + R + '" fill="none" stroke="#5b6390" stroke-width=".6"/></svg>';
  }
  function dateText(ms, opts) { return new Date(ms).toLocaleDateString(lang === 'hi' ? 'hi-IN' : 'en-GB', opts || { day: 'numeric', month: 'short', year: 'numeric' }); }

  /* ---------- latest release (home, get-the-app) ---------- */
  function release() {
    var btns = $$('.dl-btn'); if (!btns.length || !window.fetch) return;
    fetch('https://api.github.com/repos/aditymishr098-collab/astryl/releases?per_page=60').then(function (r) { return r.ok ? r.json() : Promise.reject(); }).then(function (list) {
      list = (list || []).filter(function (r) { return !r.draft && !r.prerelease; });
      var j = list[0]; if (!j) return;
      var apk = (j.assets || []).filter(function (a) { return /\.apk$/i.test(a.name); })[0];
      btns.forEach(function (b) { if (apk) b.href = apk.browser_download_url; });
      $$('.ver').forEach(function (v) { v.textContent = j.tag_name + (apk ? ' · ' + (apk.size / 1048576).toFixed(0) + ' MB' : ''); });
      var total = 0;
      list.forEach(function (r) { (r.assets || []).forEach(function (a) { if (/\.apk$/i.test(a.name)) total += a.download_count || 0; }); });
      relCard(j, apk, total);
    }).catch(function () { var c = $('#relCard'); if (c) c.style.display = 'none'; });
  }
  /* The "latest version" card on the download page. */
  function relCard(j, apk, total) {
    var box = $('#relCard'); if (!box) return;
    function plain(md) {
      return String(md || '').replace(/\r/g, '').split('\n').map(function (l) { return l.replace(/^#+\s*/, '').replace(/\*\*/g, '').replace(/`/g, '').replace(/^\*\s+/, '• ').replace(/\s*in https?:\/\/\S+$/, '').trim(); })
        .filter(function (l) { return l && !/^Full Changelog/i.test(l) && !/^What's Changed$/i.test(l); }).slice(0, 12).join('\n');
    }
    onRender(function () {
      var hi = lang === 'hi', when = new Date(j.published_at || j.created_at).toLocaleDateString(hi ? 'hi-IN' : 'en-GB', { day: 'numeric', month: 'long', year: 'numeric' });
      var hash = apk && apk.digest ? String(apk.digest).replace(/^sha256:/, '') : '';
      var h = '<h3>' + (hi ? 'नया version ' : 'Latest version ') + esc(j.tag_name) + '</h3><p class="note">' + (hi ? 'जारी: ' : 'Released ') + esc(when) + (apk ? ' · ' + (apk.size / 1048576).toFixed(0) + ' MB' : '') + ' · ' + (hi ? 'सभी versions के कुल download: ' : 'Downloads, all versions: ') + total.toLocaleString(hi ? 'hi-IN' : 'en-GB') + '</p>';
      if (hash) h += '<p><b>SHA-256</b><br><code style="word-break:break-all">' + esc(hash) + '</code></p><p class="note">' + (hi ? 'Download के बाद जाँचने के लिए: ' : 'To check your download: ') + '<code>sha256sum ' + esc(apk.name) + '</code></p>';
      var notes = plain(j.body);
      if (notes) h += '<details><summary><b>' + (hi ? 'इस version में नया क्या है' : 'What is new in this version') + '</b></summary><pre style="white-space:pre-wrap;font:inherit;margin:.6em 0 0">' + esc(notes) + '</pre></details>';
      h += '<p><a href="' + esc(j.html_url) + '">' + (hi ? 'GitHub पर पूरा release' : 'Full release on GitHub') + ' →</a></p>';
      box.innerHTML = h;
    });
  }

  /* ---------- page: home ---------- */
  function homeFact() {
    var box = $('#dailyFact'); if (!box) return;
    var d = new Date(), days = Math.floor((Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()) - Date.UTC(2020, 0, 1)) / 86400000);
    var total = D.factIds.length * 2, n = ((days % total) + total) % total, id = D.factIds[n % D.factIds.length], idx = Math.floor(n / D.factIds.length);
    onRender(function () {
      box.innerHTML = '<h3>' + t('factTitle') + '</h3><p style="color:var(--text)"><b>' + bname(id) + '.</b> ' + t('fact' + id.charAt(0).toUpperCase() + id.slice(1) + (idx + 1)) + '</p>';
    });
  }
  function homeMoon() {
    var box = $('#homeMoon'); if (!box) return;
    onRender(function () {
      var ms = Date.now(), p = moonPhase(ms);
      box.innerHTML = moonSvg(p.age, 56) + '<div><b>' + t(PHASE[phaseIndex(p.age)]) + '</b><br><span class="note">' + t('illuminated', { percent: fmt(p.lit * 100) }) + '</span></div>';
    });
  }

  /* ---------- page: planets (search) ---------- */
  function planetsPage() {
    var q = $('#q'); if (!q) return;
    q.addEventListener('input', function () {
      var s = q.value.trim().toLowerCase();
      $$('[data-search]').forEach(function (c) {
        var id = c.dataset.id, hay = (c.dataset.search + ' ' + t(NAME[id]).toLowerCase());
        c.classList.toggle('hide', !!s && hay.indexOf(s) < 0);
      });
    });
  }

  /* ---------- page: compare ---------- */
  function comparePage() {
    var a = $('#cmpA'), b = $('#cmpB'), out = $('#cmpOut'); if (!a) return;
    function fill() {
      var va = a.value || 'earth', vb = b.value || 'mars';
      [a, b].forEach(function (s, i) {
        s.innerHTML = D.bodies.map(function (x) { return '<option value="' + x.id + '">' + bname(x.id) + '</option>'; }).join('');
        s.value = i ? vb : va;
      });
      draw();
    }
    function draw() {
      var x = byId[a.value], y = byId[b.value];
      var rows = [['diameter', 'diameter', PT.diameter], ['gravity', 'gravity', PT.gravity], ['avgTemp', 'avgTemp', PT.temp], ['dayLength', 'dayLength', PT.day], ['yearLength', 'yearLength', PT.year], ['moons', 'moonsShort', function (z) { return fmt(z.moons); }], ['distance', 'distance', PT.distance], ['pressure', 'pressure', PT.pressure], ['oxygen', 'oxygen', function (z) { return fmt(oxy(z), 2) + '%'; }]];
      var h = '<table class="cmp cols"><tr><th></th><th>' + bname(x.id) + '</th><th>' + bname(y.id) + '</th></tr>';
      rows.forEach(function (r) { h += '<tr><td>' + t(r[0]) + '</td><td class="w">' + r[2](x) + '</td><td class="w">' + r[2](y) + '</td></tr>'; });
      h += '</table>';
      var big = x.diam >= y.diam ? x : y, small = big === x ? y : x;
      if (x.id !== y.id) {
        var times = big.diam / small.diam;
        h += '<p class="callout" style="margin-top:16px">' + (times < 1.05 ? t('sizeSimilar', { a: bname(x.id), b: bname(y.id) }) : t('sizeTimes', { big: bname(big.id), times: fmt(times, 1), small: bname(small.id) })) + '</p>';
      }
      out.innerHTML = h;
    }
    a.addEventListener('change', draw); b.addEventListener('change', draw);
    a.value = 'earth'; b.value = 'mars'; onRender(fill);
  }
  function oxy(b) { if (b.thin) return 0; for (var i = 0; i < b.atm.length; i++) if (b.atm[i][0] === 'o2') return b.atm[i][1]; return 0; }

  /* ---------- page: you (weight, jump, age, birthday) ---------- */
  function youPage() {
    var w = $('#kg'); if (!w) return;
    var jump = $('#cm'), birth = $('#birth'), out = $('#wOut'), ageOut = $('#ageOut'), bdOut = $('#bdOut');
    function weights() {
      var kg = parseFloat(w.value) || 0, cm = parseFloat(jump.value) || 0;
      var h = '<div class="grid sm">';
      D.bodies.forEach(function (b) {
        var jh = relG(b) > 0 ? cm / relG(b) : 0;
        h += '<div class="card"><h3>' + bname(b.id) + '</h3><div class="life" style="font-size:1.6rem">' + fmt(kg * b.g / EARTH_G, 1) + ' kg</div><p>' + t('gravityTimes', { factor: fmt(relG(b), 2) }) + '</p>' + (b.hasSurface ? '<p>' + t('jumpHigh', { height: jumpText(jh) }) + '</p>' : '') + '</div>';
      });
      out.innerHTML = h + '</div>';
    }
    function jumpText(cm) { return cm >= 100 ? t('valueM', { value: fmt(cm / 100, 1) }) : t('valueCm', { value: fmt(cm) }); }
    function age() {
      if (!birth.value) { ageOut.innerHTML = ''; bdOut.innerHTML = ''; return; }
      var p = birth.value.split('-').map(Number), b = Date.UTC(p[0], p[1] - 1, p[2], 12), now = Date.now(), days = (now - b) / 86400000;
      if (days < 0) { ageOut.innerHTML = ''; bdOut.innerHTML = ''; return; }
      var secs = (now - b) / 1000, solM = secs * 29.78 / 1e6, galB = secs * 220 / 1e9, fMoons = secs / (29.53059 * 86400);
      var hi = lang === 'hi';
      var nextPl = planets[0], minD = 999999, nextTurn = 1;
      planets.forEach(function (pl) {
        var yrs = days / pl.year, next = Math.ceil((Math.floor(yrs) + 1) * pl.year - days);
        if (next < minD) { minD = next; nextPl = pl; nextTurn = Math.floor(yrs) + 1; }
      });
      var h = '<div class="card" style="margin:14px 0;border-color:var(--accent)"><h3>🚀 ' + (hi ? 'आपका लाइव अंतरिक्ष सफ़र (जन्म से अब तक)' : 'Your live cosmic journey since birth') + '</h3>' +
        '<div class="stats"><div class="stat"><b>' + fmt(solM, 2) + (hi ? ' मिलियन किमी' : ' million km') + '</b><span>' + (hi ? 'सूर्य की परिक्रमा (29.78 km/s)' : 'Around the Sun (29.78 km/s)') + '</span></div>' +
        '<div class="stat"><b>' + fmt(galB, 3) + (hi ? ' अरब किमी' : ' billion km') + '</b><span>' + (hi ? 'आकाशगंगा (Milky Way) में सफ़र' : 'Through the Milky Way (220 km/s)') + '</span></div>' +
        '<div class="stat"><b>' + fmt(fMoons, 1) + '</b><span>' + (hi ? 'चाँद की परिक्रमाएँ' : 'Lunar orbits') + '</span></div>' +
        '<div class="stat"><b>' + bname(nextPl.id) + ' (' + fmt(minD) + 'd)</b><span>' + (hi ? 'अगला अंतरिक्ष जन्मदिन (वर्ष ' + nextTurn + ')' : 'Next space birthday (turn ' + nextTurn + ')') + '</span></div></div></div>';
      h += '<h2>' + t('ageTitle') + '</h2><div class="grid sm">';
      planets.forEach(function (pl) { var yrs = days / pl.year, next = Math.ceil((Math.floor(yrs) + 1) * pl.year - days); h += '<div class="card"><h3>' + bname(pl.id) + '</h3><div class="life" style="font-size:1.6rem">' + fmt(yrs, 1) + '</div><div class="progress" style="margin:8px 0"><i style="width:' + ((yrs % 1) * 100).toFixed(0) + '%;background:' + pl.color + '"></i></div><p>' + t('nextBirthday', { days: fmt(next) }) + '</p></div>'; });
      ageOut.innerHTML = h + '</div>';
      var ph = moonPhase(b), bh = '<h2>' + t('birthdayTitle') + '</h2><div class="card pcard">' + moonSvg(ph.age, 64) + '<div><b>' + t('birthdayMoon') + '</b><br>' + t(PHASE[phaseIndex(ph.age)]) + ' · ' + t('illuminated', { percent: fmt(ph.lit * 100) }) + '</div></div>';
      bh += '<p>' + t('birthdayDaysOld', { count: fmt(Math.floor(days)) }) + '</p><h3>' + t('birthdayMilestones') + '</h3><div class="grid sm">';
      var ms = D.milestones.map(function (d) { return { d: d, date: b + d * 86400000 }; });
      ms.push({ d: null, date: b + 1e9 * 1000 });
      ms.sort(function (x, y) { return x.date - y.date; });
      ms.forEach(function (m) { bh += '<div class="card"><b>' + (m.d === null ? t('birthdayBillion') : t('birthdayDayN', { count: fmt(m.d) })) + '</b><p>' + dateText(m.date) + (m.date < now ? ' · ' + t('birthdayPassed') : '') + '</p></div>'; });
      bdOut.innerHTML = bh + '</div><p class="note">' + t('birthdayNote') + '</p>';
    }
    [w, jump].forEach(function (i) { i.addEventListener('input', weights); });
    birth.addEventListener('change', age);
    onRender(function () { weights(); age(); });
  }

  /* ---------- page: quiz (port of lib/core/quiz.dart) ---------- */
  var KINDS = {
    easy: ['largest', 'smallest', 'hottest', 'coldest', 'mostMoons', 'breathable', 'closest', 'farthest', 'star', 'dwarf', 'moonVisited'],
    medium: ['strongestGravity', 'shortestDay', 'longestDay', 'largestMoon', 'smallestMoon', 'thickAirMoon', 'geyserMoon', 'volcanicMoon', 'backwardsMoon', 'biggestRocky', 'coldestRocky', 'highestPressure'],
    hard: ['secondLargest', 'longestYear', 'shortestYear', 'smallestGiant', 'rockyLongestYear', 'fastestMoon', 'slowestMoon', 'strongestMoonGravity', 'coldestMoon', 'secondLargestMoon']
  };
  function pick(list, f, max) { var best = list[0]; list.slice(1).forEach(function (b) { if (max === false ? f(b) < f(best) : f(b) > f(best)) best = b; }); return best; }
  var rocky = planets.filter(function (p) { return p.order <= 4; }), giants = planets.filter(function (p) { return p.order >= 5; });
  function bar(b) { return b.bar || 0; }
  function answerFor(k) {
    var byD = function (a, b) { return b.diam - a.diam; };
    switch (k) {
      case 'largest': return pick(planets, function (p) { return p.diam; });
      case 'smallest': return pick(planets, function (p) { return p.diam; }, false);
      case 'hottest': return pick(planets, function (p) { return p.temp; });
      case 'coldest': return pick(planets, function (p) { return p.temp; }, false);
      case 'mostMoons': return pick(planets, function (p) { return p.moons; });
      case 'breathable': return byId.earth;
      case 'closest': return pick(planets, function (p) { return p.dist; }, false);
      case 'farthest': return pick(planets, function (p) { return p.dist; });
      case 'star': return byId.sun;
      case 'dwarf': return byId.pluto;
      case 'moonVisited': return byId.moon;
      case 'strongestGravity': return pick(planets, function (p) { return p.g; });
      case 'shortestDay': return pick(planets, function (p) { return p.day; }, false);
      case 'longestDay': return pick(planets, function (p) { return p.day; });
      case 'largestMoon': return pick(moonsAll, function (p) { return p.diam; });
      case 'smallestMoon': return pick(moonsAll, function (p) { return p.diam; }, false);
      case 'thickAirMoon': return pick(moonsAll, bar);
      case 'geyserMoon': return byId.enceladus;
      case 'volcanicMoon': return byId.io;
      case 'backwardsMoon': return byId.triton;
      case 'biggestRocky': return pick(rocky, function (p) { return p.diam; });
      case 'coldestRocky': return pick(rocky, function (p) { return p.temp; }, false);
      case 'highestPressure': return pick(planets.filter(function (p) { return p.hasSurface; }), bar);
      case 'secondLargest': return planets.slice().sort(byD)[1];
      case 'longestYear': return pick(planets, function (p) { return p.year; });
      case 'shortestYear': return pick(planets, function (p) { return p.year; }, false);
      case 'smallestGiant': return pick(giants, function (p) { return p.diam; }, false);
      case 'rockyLongestYear': return pick(rocky, function (p) { return p.year; });
      case 'fastestMoon': return pick(moonsAll, function (p) { return p.year; }, false);
      case 'slowestMoon': return pick(moonsAll, function (p) { return p.year; });
      case 'strongestMoonGravity': return pick(moonsAll, function (p) { return p.g; });
      case 'coldestMoon': return pick(moonsAll, function (p) { return p.temp; }, false);
      case 'secondLargestMoon': return moonsAll.slice().sort(byD)[1];
    }
  }
  var MOONQ = ['biggestRocky_', 'largestMoon', 'smallestMoon', 'thickAirMoon', 'volcanicMoon', 'backwardsMoon', 'moonVisited', 'fastestMoon', 'slowestMoon', 'strongestMoonGravity', 'coldestMoon', 'secondLargestMoon'];
  function distractors(k) {
    if (['biggestRocky', 'coldestRocky', 'rockyLongestYear'].indexOf(k) >= 0) return rocky;
    if (k === 'smallestGiant') return giants;
    if (MOONQ.indexOf(k) >= 0) return moonsAll;
    if (k === 'geyserMoon') return moonsAll.filter(function (b) { return b.id !== 'europa'; });
    return planets;
  }
  function shuffle(a) { for (var i = a.length - 1; i > 0; i--) { var j = Math.floor(Math.random() * (i + 1)); var x = a[i]; a[i] = a[j]; a[j] = x; } return a; }
  function quizPage() {
    var root = $('#quiz'); if (!root) return;
    var level = null, qs = [], i = 0, score = 0, picked = null, done = false;
    var used5050 = false, usedHint = false, hiddenIds = {}, showHint = false, history = [];
    var isBlitz = false, blitzLives = 3, blitzCombo = 0, blitzMaxCombo = 0, blitzSec = 60, blitzPts = 0, blitzTimer = null;

    function qkey(k) { return 'q' + k.charAt(0).toUpperCase() + k.slice(1); }
    function best(l) { return parseInt(store.get('astryl-best-' + l) || '0', 10); }
    function streakCount() { return parseInt(store.get('astryl-streak') || '0', 10); }
    function gamesPlayed() { return parseInt(store.get('astryl-games') || '0', 10); }
    function bumpStreak() {
      var now = new Date();
      var today = now.getUTCFullYear() * 10000 + (now.getUTCMonth() + 1) * 100 + now.getUTCDate();
      var yestDate = new Date(now.getTime() - 86400000);
      var yest = yestDate.getUTCFullYear() * 10000 + (yestDate.getUTCMonth() + 1) * 100 + yestDate.getUTCDate();
      var last = parseInt(store.get('astryl-streak-day') || '0', 10);
      var s = streakCount();
      if (last === today) { if (s < 1) s = 1; }
      else if (last === yest) s = s + 1;
      else s = 1;
      store.set('astryl-streak', String(s));
      store.set('astryl-streak-day', String(today));
      store.set('astryl-games', String(gamesPlayed() + 1));
    }
    function stopBlitzTimer() { if (blitzTimer) { clearInterval(blitzTimer); blitzTimer = null; } }

    function start(l) {
      stopBlitzTimer();
      level = l; isBlitz = (l === 'blitz'); i = 0; score = 0; picked = null; done = false;
      used5050 = false; usedHint = false; hiddenIds = {}; showHint = false; history = [];
      if (isBlitz) {
        blitzLives = 3; blitzCombo = 0; blitzMaxCombo = 0; blitzSec = 60; blitzPts = 0;
        var allK = KINDS.easy.concat(KINDS.medium).concat(KINDS.hard);
        qs = shuffle(allK.slice()).map(function (k) {
          var ans = answerFor(k), others = shuffle(distractors(k).filter(function (p) { return p.id !== ans.id; })).slice(0, 3);
          return { k: k, ans: ans, opts: shuffle([ans].concat(others)) };
        });
        blitzTimer = setInterval(function () {
          if (done) { stopBlitzTimer(); return; }
          blitzSec--;
          if (blitzSec <= 0) { blitzSec = 0; done = true; bumpStreak(); stopBlitzTimer(); }
          draw();
        }, 1000);
      } else {
        qs = shuffle(KINDS[l].slice()).slice(0, 10).map(function (k) {
          var ans = answerFor(k), others = shuffle(distractors(k).filter(function (p) { return p.id !== ans.id; })).slice(0, 3);
          return { k: k, ans: ans, opts: shuffle([ans].concat(others)) };
        });
      }
      draw();
    }

    function explainBody(b) {
      var capId = b.id.charAt(0).toUpperCase() + b.id.slice(1);
      var f1 = t('fact' + capId + '1');
      if (f1 === 'fact' + capId + '1') f1 = '';
      var stats = bname(b.id) + ' — Diameter: ' + fmt(b.diam) + ' km · Gravity: ' + fmt(b.g, 1) + ' m/s² · Temp: ' + b.temp + '°C · Moons: ' + b.moons;
      return f1 ? (stats + '<br><span class="note">' + f1 + '</span>') : stats;
    }

    function hintBody(b) {
      var kindDesc = b.kind === 'star' ? 'Central star of the Solar System' : (b.kind === 'moon' ? 'Natural moon orbiting a planet' : (b.kind === 'dwarf' ? 'Dwarf planet in the Kuiper Belt' : (b.order <= 4 ? 'Inner rocky planet' : 'Outer giant planet')));
      return '💡 Clue: ' + kindDesc + ' · Diameter ' + fmt(b.diam) + ' km · Mean temp ' + b.temp + '°C';
    }

    function draw() {
      var h = '';
      var st = streakCount(), gp = gamesPlayed(), bb = best('blitz'), eb = best('easy'), mb = best('medium'), hb = best('hard');
      if (!level) {
        h += '<div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px;margin-bottom:14px">' +
          '<p class="sub" style="margin:0">' + t('quizIntro') + '</p>' +
          '<span class="badge" style="font-size:14px;padding:6px 14px;background:rgba(255,138,71,0.16);border:1px solid rgba(255,138,71,0.45);border-radius:999px;color:#ff9b60;font-weight:700">🔥 ' + st + ' day streak</span></div>';
        // 60s Blitz Survival card
        h += '<div class="card" style="margin-bottom:16px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;border:1px solid rgba(255,138,71,0.4)">' +
          '<div><h3 style="margin:0 0 4px">⚡ 60s Blitz Survival (3 ❤️)</h3><p class="note" style="margin:0">60 seconds · 3 lives · 2x/3x Combo Multiplier' + (bb > 0 ? ' · <b>Best: ' + bb + ' pts</b>' : '') + '</p></div>' +
          '<button class="btn primary" data-lv="blitz">Play Blitz ⚡</button></div>';
        // Space Badges / Achievements card
        var badges = [
          { ic: '🚀', nm: 'First Launch', ok: gp >= 1 || eb > 0 || mb > 0 || hb > 0 },
          { ic: '🔥', nm: '3-Day Streak', ok: st >= 3 },
          { ic: '🪐', nm: 'Solar Master (10/10)', ok: eb >= 10 || mb >= 10 || hb >= 10 },
          { ic: '⚡', nm: 'Blitz Ace (500+)', ok: bb >= 500 },
          { ic: '👑', nm: 'Hard Legend (8+/10)', ok: hb >= 8 }
        ];
        h += '<div class="card" style="margin-bottom:18px"><b style="font-size:14px;display:block;margin-bottom:10px">🏅 Space Badges & Achievements</b><div style="display:flex;flex-wrap:wrap;gap:8px">';
        badges.forEach(function (b) {
          h += '<span style="padding:5px 12px;border-radius:999px;font-size:12.5px;font-weight:600;border:1px solid ' + (b.ok ? 'rgba(92,200,255,0.5)' : 'var(--border)') + ';background:' + (b.ok ? 'rgba(92,200,255,0.12)' : 'transparent') + ';opacity:' + (b.ok ? '1' : '0.45') + '">' + b.ic + ' ' + b.nm + '</span>';
        });
        h += '</div></div>';
        h += '<p><b>' + t('quizChoose') + '</b></p><div class="grid">';
        ['easy', 'medium', 'hard'].forEach(function (l) {
          h += '<button class="card" data-lv="' + l + '" style="text-align:left;cursor:pointer;font:inherit;color:var(--text)"><h3>' + t('level' + l.charAt(0).toUpperCase() + l.slice(1)) + '</h3><p>' + t('level' + l.charAt(0).toUpperCase() + l.slice(1) + 'Hint') + '</p><p>' + t('quizBest', { score: best(l) + '/10' }) + '</p></button>';
        });
        root.innerHTML = h + '</div>'; return;
      }
      if (done) {
        stopBlitzTimer();
        var cmpVal = isBlitz ? blitzPts : score;
        var nb = cmpVal > best(level);
        if (nb) { store.set('astryl-best-' + level, String(cmpVal)); changed(); }
        var gridStr = history.map(function (ok) { return ok ? '🟩' : '🟥'; }).join(' ');
        root.innerHTML = '<div class="card" style="text-align:center">' +
          '<div class="life">' + (isBlitz ? (blitzPts + ' pts') : (score + ' / ' + qs.length)) + '</div>' +
          '<p>' + (isBlitz ? (score + ' correct · Max combo ' + blitzMaxCombo + 'x') : t('quizScore', { score: score, total: qs.length })) + '</p>' +
          '<p>' + (nb ? '<b class="ok">' + t('quizNewBest') + '</b>' : t('quizBest', { score: best(level) + (isBlitz ? ' pts' : '/10') })) + '</p>' +
          (gridStr ? '<div style="margin:14px auto;padding:10px 16px;display:inline-block;border-radius:12px;background:rgba(255,255,255,0.04);letter-spacing:2px;font-size:18px">' + gridStr + '</div>' : '') +
          '<div style="display:flex;justify-content:center;gap:10px;flex-wrap:wrap;margin-top:14px">' +
          '<button class="btn" id="shareQuiz">📤 Copy / Share Score Card</button>' +
          '<button class="btn primary" id="again">' + t('quizAgain') + '</button></div></div>';
        return;
      }
      var q = qs[i];
      var mult = blitzCombo >= 5 ? 3 : (blitzCombo >= 3 ? 2 : 1);
      var hearts = '❤️'.repeat(Math.max(0, blitzLives)) + '🖤'.repeat(Math.max(0, 3 - blitzLives));
      h = '<div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:8px">' +
        '<p class="note" style="margin:0">' + (isBlitz ? ('⚡ Question #' + (i + 1)) : t('quizProgress', { current: i + 1, total: qs.length })) + '</p>' +
        (isBlitz ? ('<div style="font-weight:700;font-size:13.5px">' + hearts + (mult > 1 ? ' <span style="color:#ff9b60">🔥 ' + mult + 'x</span>' : '') + ' · ⏱ ' + blitzSec + 's · ' + blitzPts + ' pts</div>') : '') +
        '</div>' +
        '<div class="progress" style="margin:8px 0 14px"><i style="width:' + (isBlitz ? (blitzSec / 60 * 100) : ((i + (picked ? 1 : 0)) / qs.length * 100)) + '%"></i></div>';
      // Visual Mystery World Header + Lifelines bar
      h += '<div class="card" style="padding:10px 14px;margin-bottom:14px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px">' +
        '<div style="display:flex;align-items:center;gap:10px">' +
        (picked ? ('<span class="dot" style="width:28px;height:28px;border-radius:50%;display:inline-block;background:' + q.ans.c1 + '"></span><b>' + bname(q.ans.id) + '</b>') : '<span style="width:32px;height:32px;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;background:rgba(92,200,255,0.18);border:1px solid rgba(92,200,255,0.45);font-weight:800">?</span><span class="note">Identify the Cosmic World</span>') +
        '</div><div style="display:flex;gap:8px">' +
        '<button class="btn" id="life50" style="padding:5px 12px;font-size:12.5px"' + (used5050 || picked ? ' disabled' : '') + '>50:50</button>' +
        '<button class="btn" id="lifeHint" style="padding:5px 12px;font-size:12.5px"' + (usedHint || picked ? ' disabled' : '') + '>💡 Hint</button>' +
        '</div></div>';
      if (showHint) {
        h += '<div class="card" style="padding:10px 14px;margin-bottom:12px;border:1px solid rgba(92,200,255,0.4);background:rgba(92,200,255,0.09);font-size:13.5px">' + hintBody(q.ans) + '</div>';
      }
      h += '<h2>' + t(qkey(q.k)) + '</h2>';
      q.opts.forEach(function (o) {
        if (hiddenIds[o.id]) return;
        var cls = picked ? (o.id === q.ans.id ? ' right' : (o.id === picked ? ' wrong' : '')) : '';
        h += '<button class="opt' + cls + '" data-id="' + o.id + '"' + (picked ? ' disabled' : '') + '>' + bname(o.id) + '</button>';
      });
      if (picked) {
        h += '<p><b class="' + (picked === q.ans.id ? 'ok' : 'no') + '">' + (picked === q.ans.id ? t('quizCorrect') : t('quizWrong', { answer: bname(q.ans.id) })) + '</b></p>' +
          '<div class="card" style="margin:10px 0 14px;padding:12px 14px;font-size:13.5px;border-left:3px solid var(--accent)"><b>🔬 Cosmic Insight (Why?)</b><br>' + explainBody(q.ans) + '</div>' +
          '<button class="btn primary" id="next">' + ((i + 1 === qs.length || (isBlitz && blitzLives <= 0)) ? t('quizSeeResult') : t('quizNext')) + '</button>';
      }
      root.innerHTML = h;
    }

    root.addEventListener('click', function (e) {
      var el = e.target.closest('[data-lv],[data-id],#next,#again,#life50,#lifeHint,#shareQuiz'); if (!el) return;
      if (el.dataset.lv) start(el.dataset.lv);
      else if (el.id === 'again') { stopBlitzTimer(); level = null; draw(); }
      else if (el.id === 'life50' && !used5050 && !picked) {
        used5050 = true;
        var wrong = shuffle(qs[i].opts.filter(function (o) { return o.id !== qs[i].ans.id; })).slice(0, 2);
        wrong.forEach(function (w) { hiddenIds[w.id] = true; });
        draw();
      }
      else if (el.id === 'lifeHint' && !usedHint && !picked) {
        usedHint = true; showHint = true; draw();
      }
      else if (el.id === 'shareQuiz') {
        var grid = history.map(function (ok) { return ok ? '🟩' : '🟥'; }).join('');
        var txt = '🪐 Astryl Space Quiz (' + (isBlitz ? ('60s Blitz: ' + blitzPts + ' pts') : (level + ': ' + score + '/' + qs.length)) + ')\n' + grid + '\nPlay at https://astryl.space/quiz/';
        if (navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(txt);
          el.textContent = '✅ Copied to Clipboard!';
        }
      }
      else if (el.id === 'next') {
        if (isBlitz && blitzLives <= 0) { done = true; bumpStreak(); stopBlitzTimer(); }
        else if (i + 1 < qs.length) { i++; picked = null; hiddenIds = {}; showHint = false; }
        else { done = true; bumpStreak(); stopBlitzTimer(); }
        draw();
      }
      else if (el.dataset.id && !picked) {
        picked = el.dataset.id;
        var ok = (picked === qs[i].ans.id);
        history.push(ok);
        if (ok) {
          score++;
          if (isBlitz) {
            blitzCombo++;
            if (blitzCombo > blitzMaxCombo) blitzMaxCombo = blitzCombo;
            var m = blitzCombo >= 5 ? 3 : (blitzCombo >= 3 ? 2 : 1);
            blitzPts += 100 * m;
          }
        } else if (isBlitz) {
          blitzCombo = 0;
          blitzLives--;
          if (blitzLives <= 0) stopBlitzTimer();
        }
        draw();
      }
    });
    onRender(draw);
  }

  /* ---------- page: solar system (NASA Eyes 3D live explorer) ---------- */
  function solarPage() {
    var cv = $('#solar'); if (!cv) return;
    var ctx = cv.getContext('2d'), day = $('#solDay'), lab = $('#solDate'), playBtn = $('#solPlay'), todayBtn = $('#solToday');
    var chipsBox = $('#solChips'), backBtn = $('#solBack'), telBox = $('#solTelemetry');
    var ms = Date.now(), playing = false, last = 0;
    var yaw = -0.65, pitch = 0.52, zoom = 1.0, targetZoom = 1.0;
    var selected = 'earth', camX = 0, camY = 0, targetX = 0, targetY = 0;
    var dragging = false, lx = 0, ly = 0, hitList = [];
    var stars = [];
    for (var si = 0; si < 160; si++) stars.push({ x: Math.random(), y: Math.random(), r: 0.7 + Math.random() * 1.4, p: Math.random() * 6.28 });

    cv.width = 1280; cv.height = 820; cv.style.width = '100%'; cv.style.borderRadius = '18px'; cv.style.cursor = 'grab';

    var ORBIT_C = { mercury: '#b0b5c4', venus: '#e8b668', earth: '#4da3ff', mars: '#e56b4e', jupiter: '#d99a62', saturn: '#dfc07c', uranus: '#73d4e0', neptune: '#4d7bff', pluto: '#a68d7c' };
    var MOONS = {
      earth: [{ id: 'moon', r: 0.42, p: 27.32, c: '#d2d6e0', sz: 4.5 }],
      jupiter: [
        { id: 'io', r: 0.36, p: 1.769, c: '#f2c94c', sz: 4 },
        { id: 'europa', r: 0.50, p: 3.551, c: '#bce0fd', sz: 3.8 },
        { id: 'ganymede', r: 0.66, p: 7.155, c: '#b8a99a', sz: 5 },
        { id: 'callisto', r: 0.84, p: 16.689, c: '#8c8275', sz: 4.5 }
      ],
      saturn: [
        { id: 'enceladus', r: 0.44, p: 1.370, c: '#e8f6ff', sz: 3.6 },
        { id: 'titan', r: 0.76, p: 15.945, c: '#e8a850', sz: 5.2 }
      ],
      neptune: [{ id: 'triton', r: 0.54, p: -5.877, c: '#b5d6e8', sz: 4.2 }]
    };

    function compR(au) { return Math.pow(au, 0.44) * 3.1; }
    function worldPos(id, tMs) {
      if (id === 'sun') return { x: 0, y: 0, z: 0 };
      var b = byId[id];
      if (b && b.kind === 'moon') {
        var par = worldPos(b.parent, tMs), mlist = MOONS[b.parent] || [];
        var m = mlist.filter(function (x) { return x.id === id; })[0] || { r: 0.45, p: b.year || 10 };
        var ang = ((tMs / 86400000) / m.p) * Math.PI * 2;
        return { x: par.x + Math.cos(ang) * m.r, y: par.y + Math.sin(ang) * m.r, z: 0 };
      }
      var h = helio(id, tMs), au = Math.sqrt(h.x * h.x + h.y * h.y), ang2 = Math.atan2(h.y, h.x), r = compR(au);
      return { x: Math.cos(ang2) * r, y: Math.sin(ang2) * r, z: 0 };
    }
    function proj(wx, wy, wz, W, H, sc) {
      var dx = wx - camX, dy = wy - camY, dz = wz;
      var cy = Math.cos(yaw), sy = Math.sin(yaw), cp = Math.cos(pitch), sp = Math.sin(pitch);
      var x1 = dx * cy - dy * sy, y1 = dx * sy + dy * cy;
      var z2 = y1 * cp - dz * sp, y2 = y1 * sp + dz * cp;
      var fov = 24, d = fov + z2; if (d < 1.2) return null;
      var p = (fov / d) * sc;
      return { x: W / 2 + x1 * p, y: H / 2 - y2 * p, p: p / sc, depth: d };
    }

    function renderChips() {
      if (!chipsBox) return;
      var order = ['sun', 'mercury', 'venus', 'earth', 'moon', 'mars', 'jupiter', 'io', 'europa', 'ganymede', 'callisto', 'saturn', 'titan', 'enceladus', 'uranus', 'neptune', 'triton', 'pluto'];
      chipsBox.innerHTML = order.map(function (id) {
        var b = byId[id]; if (!b) return '';
        var on = selected === id ? ' on' : '';
        return '<button class="eyes-chip' + on + '" data-pick="' + id + '"><i style="background:' + b.color + '"></i>' + bname(id) + '</button>';
      }).join('');
    }

    function renderTelemetry() {
      if (!telBox) return;
      var b = byId[selected] || byId.earth, now = ms;
      var dEarth = selected === 'earth' ? 0 : distFromEarthKm(selected === 'moon' ? 'moon' : (b.kind === 'moon' ? b.parent : selected), now);
      if (selected === 'moon') dEarth = 384400;
      var dSun = selected === 'sun' ? 0 : (b.dist * 1e6);
      var ox = oxy(b);
      var sub = b.kind === 'star' ? t('kindStar') : (b.id === 'pluto' ? t('kindDwarf') : (b.kind === 'moon' ? t('moonOf', { planet: bname(b.parent) }) : t('planetOrder', { n: b.order })));
      telBox.innerHTML =
        '<div class="eyes-tel-head">' +
          '<div class="eyes-dot" style="background:radial-gradient(circle at 32% 30%,' + b.colors[2] + ',' + b.colors[0] + ' 60%,' + b.colors[1] + ')"></div>' +
          '<div style="flex:1"><div class="eyes-live-tag">● ' + (lang === 'hi' ? 'लाइव टेलीमेट्री' : 'LIVE TELEMETRY') + '</div><h3 style="margin:2px 0 0">' + bname(b.id) + '</h3><small class="note">' + sub + '</small></div>' +
          '<a class="btn primary" href="body/' + b.id + '.html">' + t('openDetails') + ' →</a>' +
        '</div>' +
        '<div class="stats" style="margin-top:12px">' +
          '<div class="stat"><b>' + PT.diameter(b) + '</b><span>' + t('diameter') + '</span></div>' +
          '<div class="stat"><b>' + PT.gravity(b) + '</b><span>' + t('gravity') + '</span></div>' +
          '<div class="stat"><b>' + PT.temp(b) + '</b><span>' + t('avgTempShort') + '</span></div>' +
          '<div class="stat"><b>' + (selected === 'earth' ? '0 km' : PT.km(dEarth)) + '</b><span>' + t('distanceFromEarth') + '</span></div>' +
          '<div class="stat"><b>' + (selected === 'sun' ? '0 km' : PT.km(dSun)) + '</b><span>' + t('distance') + '</span></div>' +
          '<div class="stat"><b>' + fmt(ox, 2) + '%</b><span>' + t('oxygen') + '</span></div>' +
        '</div>';
      if (backBtn) backBtn.style.display = selected !== 'sun' ? 'inline-flex' : 'none';
    }

    function selectBody(id) {
      selected = id;
      var b = byId[id];
      targetZoom = id === 'sun' ? 1.0 : (b && b.kind === 'moon' ? 2.6 : 1.85);
      renderChips();
      renderTelemetry();
    }

    function drawFrame(ts) {
      var W = cv.width, H = cv.height;
      var tp = worldPos(selected, ms);
      targetX = tp.x; targetY = tp.y;
      camX += (targetX - camX) * 0.14;
      camY += (targetY - camY) * 0.14;
      zoom += (targetZoom - zoom) * 0.14;

      var sc = Math.min(W, H) * 0.048 * zoom;
      ctx.clearRect(0, 0, W, H);
      var bg = ctx.createRadialGradient(W * 0.5, H * 0.45, 20, W * 0.5, H * 0.5, W * 0.7);
      bg.addColorStop(0, '#0c1328'); bg.addColorStop(0.6, '#060914'); bg.addColorStop(1, '#03050b');
      ctx.fillStyle = bg; ctx.fillRect(0, 0, W, H);

      // Twinkling stars
      var sec = (ts || Date.now()) * 0.001;
      stars.forEach(function (s) {
        var al = 0.25 + 0.55 * (0.5 + 0.5 * Math.sin(sec * 1.8 + s.p));
        ctx.fillStyle = 'rgba(215,228,255,' + al.toFixed(2) + ')';
        ctx.beginPath(); ctx.arc(s.x * W, s.y * H, s.r, 0, 7); ctx.fill();
      });

      // Planet orbit rings
      planets.concat([byId.pluto]).forEach(function (p) {
        var a = D.orbits[p.id][0], r = compR(a), col = ORBIT_C[p.id] || '#8899cc';
        var isSel = selected === p.id || (byId[selected] && byId[selected].parent === p.id);
        ctx.strokeStyle = col; ctx.globalAlpha = isSel ? 0.68 : 0.26; ctx.lineWidth = isSel ? 2.4 : 1.4;
        ctx.beginPath();
        var started = false;
        for (var i = 0; i <= 96; i++) {
          var ang = (i / 96) * Math.PI * 2;
          var pt = proj(Math.cos(ang) * r, Math.sin(ang) * r, 0, W, H, sc);
          if (!pt) continue;
          if (!started) { ctx.moveTo(pt.x, pt.y); started = true; } else ctx.lineTo(pt.x, pt.y);
        }
        ctx.stroke();
      });
      ctx.globalAlpha = 1;

      // Moon orbit rings around focused parent or Earth/Jupiter/Saturn
      Object.keys(MOONS).forEach(function (pid) {
        var show = selected === pid || (byId[selected] && byId[selected].parent === pid) || zoom > 1.35;
        if (!show) return;
        var par = worldPos(pid, ms);
        MOONS[pid].forEach(function (m) {
          ctx.strokeStyle = m.c; ctx.globalAlpha = 0.38; ctx.lineWidth = 1.2;
          ctx.beginPath();
          var st = false;
          for (var j = 0; j <= 48; j++) {
            var a2 = (j / 48) * Math.PI * 2;
            var pt2 = proj(par.x + Math.cos(a2) * m.r, par.y + Math.sin(a2) * m.r, 0, W, H, sc);
            if (!pt2) continue;
            if (!st) { ctx.moveTo(pt2.x, pt2.y); st = true; } else ctx.lineTo(pt2.x, pt2.y);
          }
          ctx.stroke();
        });
      });
      ctx.globalAlpha = 1;

      // Collect bodies to depth-sort
      var drawables = [];
      var sunP = proj(0, 0, 0, W, H, sc);
      if (sunP) drawables.push({ id: 'sun', b: byId.sun, pt: sunP, rad: 22 * sunP.p });
      planets.concat([byId.pluto]).forEach(function (p) {
        var wp = worldPos(p.id, ms), pt = proj(wp.x, wp.y, wp.z, W, H, sc);
        if (!pt) return;
        var baseR = p.id === 'jupiter' || p.id === 'saturn' ? 14 : (p.id === 'uranus' || p.id === 'neptune' ? 11 : (p.id === 'pluto' ? 6.5 : 8.8));
        drawables.push({ id: p.id, b: p, pt: pt, rad: Math.max(4.5, baseR * pt.p * Math.pow(zoom, 0.25)) });
      });
      Object.keys(MOONS).forEach(function (pid) {
        var show = selected === pid || (byId[selected] && byId[selected].parent === pid) || zoom > 1.45;
        if (!show) return;
        MOONS[pid].forEach(function (m) {
          var wp = worldPos(m.id, ms), pt = proj(wp.x, wp.y, wp.z, W, H, sc);
          if (pt) drawables.push({ id: m.id, b: byId[m.id], pt: pt, rad: Math.max(3.2, m.sz * pt.p * Math.pow(zoom, 0.35)), isMoon: true });
        });
      });

      drawables.sort(function (a, b) { return b.pt.depth - a.pt.depth; });
      hitList = [];

      drawables.forEach(function (d) {
        var x = d.pt.x, y = d.pt.y, r = d.rad, b = d.b;
        hitList.push({ id: d.id, x: x, y: y, r: Math.max(16, r + 8) });
        if (d.id === 'sun') {
          var sg = ctx.createRadialGradient(x, y, r * 0.1, x, y, r * 2.6);
          sg.addColorStop(0, '#fff7d6'); sg.addColorStop(0.35, '#ffb838'); sg.addColorStop(1, 'rgba(255,140,20,0)');
          ctx.fillStyle = sg; ctx.beginPath(); ctx.arc(x, y, r * 2.6, 0, 7); ctx.fill();
        }
        if (d.id === 'saturn') {
          ctx.strokeStyle = 'rgba(230,208,155,0.82)'; ctx.lineWidth = Math.max(2, r * 0.26);
          ctx.beginPath(); ctx.ellipse(x, y, r * 2.1, r * 0.65, -0.28, 0, 7); ctx.stroke();
        }
        var pg = ctx.createRadialGradient(x - r * 0.32, y - r * 0.32, r * 0.1, x, y, r);
        pg.addColorStop(0, b.colors[2]); pg.addColorStop(0.55, b.colors[0]); pg.addColorStop(1, b.colors[1]);
        ctx.fillStyle = pg; ctx.beginPath(); ctx.arc(x, y, r, 0, 7); ctx.fill();

        if (selected === d.id) {
          ctx.strokeStyle = '#7ce2ff'; ctx.lineWidth = 2.2;
          ctx.beginPath(); ctx.arc(x, y, r + 6, 0, 7); ctx.stroke();
        }
        ctx.font = (d.isMoon ? '500 18px' : '600 22px') + ' "DM Sans",sans-serif';
        ctx.fillStyle = selected === d.id ? '#7ce2ff' : 'rgba(235,240,255,0.92)';
        ctx.fillText(bname(d.id), x + r + 7, y + 6);
      });

      lab.textContent = dateText(ms);
      if (playing || Math.abs(targetX - camX) > 0.002 || Math.abs(targetY - camY) > 0.002 || Math.abs(targetZoom - zoom) > 0.002) {
        requestAnimationFrame(loop);
      }
    }

    function loop(ts) {
      if (playing) {
        if (last) {
          ms += (ts - last) / 1000 * 18 * 86400000;
          if (ms > MAX) ms = MIN;
          day.value = Math.max(day.min, Math.min(day.max, Math.round((ms - Date.now()) / 86400000)));
        }
        last = ts;
      }
      drawFrame(ts);
    }

    // Pointer interaction: drag to rotate 3D camera, click a body to fly to it
    var downX = 0, downY = 0;
    cv.addEventListener('pointerdown', function (e) {
      dragging = true; lx = downX = e.clientX; ly = downY = e.clientY;
      cv.setPointerCapture(e.pointerId); cv.style.cursor = 'grabbing';
    });
    cv.addEventListener('pointermove', function (e) {
      if (!dragging) return;
      var dx = e.clientX - lx, dy = e.clientY - ly;
      lx = e.clientX; ly = e.clientY;
      yaw -= dx * 0.007;
      pitch = Math.max(0.12, Math.min(1.42, pitch + dy * 0.006));
      drawFrame();
    });
    cv.addEventListener('pointerup', function (e) {
      if (!dragging) return;
      dragging = false; cv.style.cursor = 'grab';
      if (Math.hypot(e.clientX - downX, e.clientY - downY) < 6) {
        var rect = cv.getBoundingClientRect();
        var cx = (e.clientX - rect.left) * (cv.width / rect.width);
        var cy = (e.clientY - rect.top) * (cv.height / rect.height);
        for (var i = hitList.length - 1; i >= 0; i--) {
          var h = hitList[i];
          if (Math.hypot(cx - h.x, cy - h.y) <= h.r) {
            selectBody(h.id); requestAnimationFrame(loop); break;
          }
        }
      }
    });
    cv.addEventListener('wheel', function (e) {
      e.preventDefault();
      targetZoom = Math.max(0.55, Math.min(3.5, targetZoom * (e.deltaY < 0 ? 1.12 : 0.9)));
      requestAnimationFrame(loop);
    }, { passive: false });

    if (chipsBox) chipsBox.addEventListener('click', function (e) {
      var btn = e.target.closest('[data-pick]');
      if (btn) { selectBody(btn.dataset.pick); requestAnimationFrame(loop); }
    });
    if (backBtn) backBtn.addEventListener('click', function () { selectBody('sun'); requestAnimationFrame(loop); });

    function setMs(v) { ms = Math.min(MAX, Math.max(MIN, v)); day.value = Math.round((ms - Date.now()) / 86400000); renderTelemetry(); drawFrame(); }
    day.addEventListener('input', function () { ms = Date.now() + parseInt(day.value, 10) * 86400000; renderTelemetry(); drawFrame(); });
    playBtn.addEventListener('click', function () { playing = !playing; playBtn.textContent = playing ? t('pause') : t('play'); if (playing) { last = 0; requestAnimationFrame(loop); } });
    todayBtn.addEventListener('click', function () { playing = false; playBtn.textContent = t('play'); setMs(Date.now()); });
    $('#solMonthBack').addEventListener('click', function () { setMs(ms - 30 * 86400000); });
    $('#solMonthFwd').addEventListener('click', function () { setMs(ms + 30 * 86400000); });

    var tbl = $('#solTable');
    onRender(function () {
      playBtn.textContent = playing ? t('pause') : t('play');
      todayBtn.textContent = t('today');
      renderChips();
      renderTelemetry();
      drawFrame();
      var now = Date.now(), h = '<table class="cmp cols"><tr><th></th><th>' + t('distanceFromEarth') + '</th><th>' + t('lightTime') + '</th></tr>';
      planets.filter(function (p) { return p.id !== 'earth'; }).concat([byId.sun]).forEach(function (p) { var km = distFromEarthKm(p.id, now); h += '<tr><td>' + bname(p.id) + '</td><td class="w">' + PT.km(km) + '</td><td>' + PT.duration(km / C_KMS) + '</td></tr>'; });
      tbl.innerHTML = h + '</table>';
    });
  }

  /* ---------- page: sky (moon today, calendar, meteor showers) ---------- */
  /* Which planets can be seen tonight: from how far each one is from the Sun in the sky. */
  function tonightPlanets() {
    var box = $('#planetsTonight'); if (!box) return;
    var ids = ['mercury', 'venus', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune'];
    onRender(function () {
      var ms = Date.now(), hi = lang === 'hi', e = helio('earth', ms), sl = sunLon(ms);
      var rows = ids.map(function (id) {
        var p = helio(id, ms), lon = n360(deg(Math.atan2(p.y - e.y, p.x - e.x))), diff = n360(lon - sl), el = diff > 180 ? 360 - diff : diff;
        var evening = diff < 180, msg, cls = '';
        if (el < 12) { msg = hi ? 'सूर्य के बहुत पास, नहीं दिखेगा' : 'Too close to the Sun to see'; cls = 'no'; }
        else if (el > 165) { msg = hi ? 'सामने (opposition): रात भर आसमान में' : 'Opposite the Sun: up all night'; cls = 'ok'; }
        else if (evening) { msg = el < 40 ? (hi ? 'शाम का आसमान, सूर्यास्त के बाद पश्चिम में' : 'Evening sky, low in the west after sunset') : (hi ? 'शाम का आसमान' : 'Evening sky'); cls = 'ok'; }
        else { msg = el < 40 ? (hi ? 'सुबह का आसमान, सूर्योदय से पहले पूर्व में' : 'Morning sky, low in the east before sunrise') : (hi ? 'सुबह का आसमान' : 'Morning sky'); }
        return '<li><span class="nm"><b>' + esc(bname(id)) + '</b><small>' + esc(msg) + '</small></span><b class="' + cls + '">' + Math.round(el) + '°</b></li>';
      });
      box.innerHTML = '<p class="sub" style="margin-top:0">' + (hi ? 'हर ग्रह सूर्य से कितने अंश दूर है (दाईं ओर)। ज़्यादा दूरी का मतलब है अँधेरे आसमान में बेहतर दिखना। मोटा अनुमान, किसी भी जगह के लिए।' : 'How far each planet is from the Sun in the sky (right). More distance means a darker sky to see it in. A rough guide, the same for any place.') + '</p><ol class="lb plain">' + rows.join('') + '</ol><p class="note">' + (hi ? 'बृहस्पति और शनि के चाँदों की आज की स्थिति उनके पेज पर देखिए।' : 'See where the moons of Jupiter and Saturn are tonight on their pages.') + ' <a href="body/jupiter.html">' + bname('jupiter') + '</a> · <a href="body/saturn.html">' + bname('saturn') + '</a></p>';
    });
  }
  function skyPage() {
    var box = $('#moonNow'); if (!box) return;
    tonightPlanets();
    var view = new Date(); view = new Date(view.getFullYear(), view.getMonth(), 1);
    function draw() {
      var now = Date.now(), p = moonPhase(now), nf = nextPhase(now, 180), nn = nextPhase(now, 0);
      box.innerHTML = '<div class="pcard">' + moonSvg(p.age, 110) + '<div><h2 style="margin:0">' + t(PHASE[phaseIndex(p.age)]) + '</h2><p>' + t('illuminated', { percent: fmt(p.lit * 100) }) + '</p><p>' + t('nextFull') + ': <b>' + dateText(nf) + '</b><br>' + t('nextNew') + ': <b>' + dateText(nn) + '</b></p></div></div>';
      // month
      var y = view.getFullYear(), m = view.getMonth(), days = new Date(y, m + 1, 0).getDate(), first = (new Date(y, m, 1).getDay() + 6) % 7;
      $('#calTitle').textContent = view.toLocaleDateString(lang === 'hi' ? 'hi-IN' : 'en-GB', { month: 'long', year: 'numeric' });
      var wk = lang === 'hi' ? ['सो', 'मं', 'बु', 'गु', 'शु', 'श', 'र'] : ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
      var h = wk.map(function (x) { return '<div class="h">' + x + '</div>'; }).join('');
      for (var i = 0; i < first; i++) h += '<div></div>';
      var td = new Date();
      for (var d = 1; d <= days; d++) { var pp = moonPhase(new Date(y, m, d, 12).getTime()); h += '<div class="d' + (td.getFullYear() === y && td.getMonth() === m && td.getDate() === d ? ' today' : '') + '">' + d + moonSvg(pp.age, 34) + '</div>'; }
      $('#calGrid').innerHTML = h;
      // main phases this month
      var from = new Date(y, m, 1).getTime(), to = new Date(y, m + 1, 1).getTime(), ev = [], tt = from;
      while (tt < to && ev.length < 8) { var kind = (Math.floor(moonPhase(tt).age / 90) + 1) % 4, at = nextPhase(tt, kind * 90); if (at >= to) break; ev.push({ k: kind, at: at }); tt = at + 3600000; }
      var names = ['phaseNew', 'phaseFirstQuarter', 'phaseFull', 'phaseLastQuarter'];
      $('#calPhases').innerHTML = '<h3>' + t('keyMoonDates') + '</h3>' + ev.map(function (e) { return '<div class="bar-row"><span class="n">' + t(names[e.k]) + '</span><span>' + dateText(e.at, { weekday: 'short', day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' }) + '</span></div>'; }).join('');
      // meteor showers
      var yr = new Date().getFullYear(), list = [];
      D.meteors.forEach(function (s) { [yr, yr + 1].forEach(function (Y) { var peak = new Date(Y, s[1] - 1, s[2], 23).getTime(); if (peak > now - 86400000 && peak < now + 366 * 86400000) list.push({ id: s[0], at: peak, rate: s[3] }); }); });
      list.sort(function (a, b) { return a.at - b.at; });
      $('#showers').innerHTML = list.map(function (s) { var lit = moonPhase(s.at).lit; return '<div class="card"><h3>' + t('eventMeteorShower', { shower: t('shower' + s.id.charAt(0).toUpperCase() + s.id.slice(1)) }) + '</h3><p><b>' + dateText(s.at, { day: 'numeric', month: 'long', year: 'numeric' }) + '</b></p><p>' + t('eventMeteorDesc', { rate: s.rate, percent: fmt(lit * 100) }) + '</p></div>'; }).join('');
    }
    $('#calPrev').addEventListener('click', function () { view = new Date(view.getFullYear(), view.getMonth() - 1, 1); draw(); });
    $('#calNext').addEventListener('click', function () { view = new Date(view.getFullYear(), view.getMonth() + 1, 1); draw(); });
    onRender(draw);
  }

  /* ---------- page: spacecraft (port of lib/core/spacecraft.dart) ---------- */
  function spacecraftPage() {
    var box = $('#craft'); if (!box) return;
    function distKm(s, now) {
      if (s.kind === 'probe') return s.anchorAu * KM_AU + (now - s.anchor) / 1000 * s.speed;
      if (s.kind === 'mars') return distFromEarthKm('mars', now);
      return s.fixedKm;
    }
    function draw() {
      var now = Date.now(), h = '';
      D.spacecraft.forEach(function (s) {
        var km = distKm(s, now);
        h += '<div class="card"><h3>' + s.name + '</h3><p style="color:var(--text)">' + t('spacecraft' + s.id.charAt(0).toUpperCase() + s.id.slice(1)) + '</p><div class="stats" style="margin-top:10px">' +
          '<div class="stat"><b>' + (s.kind === 'lowOrbit' ? PT.km(km) : PT.km(km)) + '</b><span>' + (s.kind === 'lowOrbit' ? t('spacecraftAltitude') : t('spacecraftDistance')) + '</span></div>' +
          (s.kind === 'lowOrbit' ? '' : '<div class="stat"><b>' + t('valueAu', { value: fmt(km / KM_AU, 2) }) + '</b><span>' + t('spacecraftInAu') + '</span></div>') +
          (s.kind === 'probe' ? '<div class="stat"><b>' + t('valueKmS', { value: fmt(s.speed, 1) }) + '</b><span>' + t('spacecraftSpeed') + '</span></div>' : '') +
          '<div class="stat"><b>' + PT.duration(km / C_KMS) + '</b><span>' + t('spacecraftSignal') + '</span></div></div></div>';
      });
      box.innerHTML = h;
    }
    onRender(draw); setInterval(draw, 5000);
  }

  /* ---------- page: a body (distance, interior cutaway, telescope zoom, moon orbits) ---------- */
  function bodyPage() {
    var box = $('#travel');
    if (box) {
      onRender(function () {
        var km = distFromEarthKm(box.dataset.body, Date.now());
        box.innerHTML = '<div class="stats"><div class="stat"><b>' + PT.km(km) + '</b><span>' + t('distanceFromEarth') + '</span></div><div class="stat"><b>' + PT.duration(km / C_KMS) + '</b><span>' + t('lightTime') + '</span></div><div class="stat"><b>' + PT.duration(km / (60000 / 3600)) + '</b><span>' + t('bySpacecraft') + '</span></div><div class="stat"><b>' + PT.duration(km / 100 * 3600) + '</b><span>' + t('byCar') + '</span></div></div>';
      });
    }

    // 1. Interactive Interior Cutaway
    var cutBox = $('#cutawaySim');
    if (cutBox) {
      var id = cutBox.dataset.body, b = byId[id] || byId.earth, pickedIdx = 0;
      function getLayers(bid) {
        var hi = lang === 'hi';
        if (bid === 'sun') return [
          { n: hi ? 'केंद्र (Core)' : 'Core', r: 0.28, c: '#fff5cc', d: hi ? '1.5 करोड़ °C — परमाणु संलयन (Nuclear fusion) यहाँ हाइड्रोजन को हीलियम में बदलता है।' : '15 million °C — nuclear fusion turns hydrogen into helium here.' },
          { n: hi ? 'विकिरण क्षेत्र (Radiative Zone)' : 'Radiative Zone', r: 0.68, c: '#ffae34', d: hi ? 'फ़ोटॉन को इस घनी परत से बाहर निकलने में लाखों साल लग जाते हैं।' : 'Photons take over 100,000 years to bounce through this dense plasma layer.' },
          { n: hi ? 'संवहन क्षेत्र और प्रकाशमंडल' : 'Convection Zone & Photosphere', r: 1.0, c: '#e85d1a', d: hi ? 'उबलते प्लाज़्मा की धाराएँ गर्मी को सतह (5,500 °C) तक लाती हैं।' : 'Boiling plasma currents carry heat to the 5,500 °C visible surface.' }
        ];
        if (bid === 'jupiter' || bid === 'saturn') return [
          { n: hi ? 'चट्टानी और बर्फीला केंद्र' : 'Rocky & Icy Core', r: 0.22, c: '#9b7e6b', d: hi ? 'पृथ्वी से कई गुना भारी अति-उच्च दबाव वाला गर्म केंद्र।' : 'Dense, super-heated core many times heavier than Earth.' },
          { n: hi ? 'धात्विक हाइड्रोजन (Metallic H₂)' : 'Liquid Metallic Hydrogen', r: 0.68, c: '#5c85d6', d: hi ? 'इतना दबाव कि हाइड्रोजन बिजली के सुचालक तरल धातु में बदल जाती है।' : 'Extreme pressure squeezes hydrogen into an electrically conductive liquid metal.' },
          { n: hi ? 'गैसीय वायुमंडल और बादल' : 'Molecular Hydrogen & Clouds', r: 1.0, c: b.colors[0], d: hi ? 'अमोनिया और हाइड्रोजन के तेज़ तूफ़ानी बादलों की बाहरी परत।' : 'Swirling ammonia cloud bands and deep hydrogen-helium atmosphere.' }
        ];
        if (bid === 'uranus' || bid === 'neptune') return [
          { n: hi ? 'चट्टानी केंद्र (Silicate Core)' : 'Silicate-Nickel Core', r: 0.25, c: '#7d746d', d: hi ? 'लोहे और सिलिकेट चट्टानों का छोटा ठोस केंद्र।' : 'Compact rocky core of iron, nickel and silicate rock.' },
          { n: hi ? 'गर्म बर्फीला मेंटल (Icy Mantle)' : 'Superionic Water-Ammonia Mantle', r: 0.78, c: '#3898b8', d: hi ? 'पानी, अमोनिया और मीथेन का उच्च-दबाव वाला गर्म महासागर।' : 'Hot, dense fluid of water, ammonia and methane ices under immense pressure.' },
          { n: hi ? 'मीथेन-हाइड्रोजन वायुमंडल' : 'Hydrogen-Methane Atmosphere', r: 1.0, c: b.colors[0], d: hi ? 'मीथेन गैस लाल रोशनी सोखकर इसे नीला/फ़िरोज़ी रंग देती है।' : 'Methane gas absorbs red light, giving the world its cyan/azure colour.' }
        ];
        if (['europa', 'enceladus', 'ganymede', 'callisto', 'titan', 'triton', 'pluto'].indexOf(bid) >= 0) return [
          { n: hi ? 'चट्टानी केंद्र (Rocky Core)' : 'Rocky Silicate Core', r: 0.52, c: '#8f7968', d: hi ? 'चट्टान और धातु का भीतरी भाग जो ज्वारीय खिंचाव से गर्म रहता है।' : 'Silicate rock interior warmed by tidal flexing and radioactive decay.' },
          { n: hi ? 'बर्फ़ के नीचे तरल महासागर' : 'Subsurface Liquid Ocean', r: 0.84, c: '#2980b9', d: hi ? 'बर्फ़ की पपड़ी के नीचे गहरा खारा समुद्र — जीवन की संभावना!' : 'Deep global ocean of liquid water beneath the frozen crust.' },
          { n: hi ? 'बर्फीली पपड़ी (Icy Crust)' : 'Frozen Ice Shell', r: 1.0, c: b.colors[2], d: hi ? 'दरारों और गीज़र वाली ठोस बर्फ़ की बाहरी सतह।' : 'Hard water-ice shell criss-crossed by ridges, fractures and geysers.' }
        ];
        return [
          { n: hi ? 'धात्विक केंद्र (Metallic Core)' : 'Iron-Nickel Core', r: bid === 'mercury' ? 0.75 : 0.38, c: '#f5b041', d: hi ? 'लोहे और निकल का भारी केंद्र जो चुंबकीय क्षेत्र बनाता है।' : 'Dense iron-nickel core at thousands of degrees Celsius.' },
          { n: hi ? 'सिलिकेट मेंटल (Mantle)' : 'Silicate Mantle', r: 0.88, c: '#d35400', d: hi ? 'गर्म और सघन चट्टानों की मोटी परत।' : 'Thick shell of hot, dense silicate rock beneath the crust.' },
          { n: hi ? 'बाहरी पपड़ी (Crust)' : 'Outer Crust', r: 1.0, c: b.colors[0], d: hi ? 'क्रेटर, पहाड़ों और घाटियों वाली बाहरी ठोस सतह।' : 'Solid outer surface of craters, plains, mountains and valleys.' }
        ];
      }
      function drawCutaway() {
        var layers = getLayers(id);
        if (pickedIdx >= layers.length) pickedIdx = 0;
        var svg = '<svg viewBox="-120 -120 240 240" width="210" height="210" style="flex-shrink:0;cursor:pointer">';
        for (var i = layers.length - 1; i >= 0; i--) {
          var L = layers[i], R = L.r * 100, sel = i === pickedIdx;
          svg += '<circle class="cut-layer" data-idx="' + i + '" r="' + R + '" fill="' + L.c + '" stroke="' + (sel ? '#fff' : 'rgba(0,0,0,0.35)') + '" stroke-width="' + (sel ? 3 : 1) + '"/>';
        }
        svg += '<line x1="0" y1="-102" x2="0" y2="102" stroke="rgba(255,255,255,0.25)" stroke-dasharray="3,3"/></svg>';
        var btns = layers.map(function (L, idx) {
          return '<button class="eyes-chip' + (idx === pickedIdx ? ' on' : '') + '" data-idx="' + idx + '"><i style="background:' + L.c + '"></i>' + L.n + '</button>';
        }).join('');
        var cur = layers[pickedIdx];
        cutBox.innerHTML = '<div class="sim-flex">' + svg + '<div style="flex:1"><div class="eyes-chips" style="margin-bottom:10px">' + btns + '</div><h3 style="margin:4px 0;color:var(--accent)">' + cur.n + '</h3><p style="margin:0;color:var(--text)">' + cur.d + '</p></div></div>';
      }
      cutBox.addEventListener('click', function (e) {
        var el = e.target.closest('[data-idx]');
        if (el) { pickedIdx = parseInt(el.dataset.idx, 10); drawCutaway(); }
      });
      onRender(drawCutaway);
    }

    // 2. Telescope Eyepiece Simulator (1x / 10x / 100x)
    var telSim = $('#telescopeSim');
    if (telSim) {
      var tid = telSim.dataset.body, tb = byId[tid] || byId.earth, mag = 1;
      function drawTel() {
        var hi = lang === 'hi';
        var r = mag === 1 ? 3.5 : (mag === 10 ? 14 : 44);
        if (tid === 'sun' || tid === 'moon') r = mag === 1 ? 16 : (mag === 10 ? 42 : 76);
        var ring = tid === 'saturn' && mag >= 10 ? '<ellipse rx="' + (r * 2.1) + '" ry="' + (r * 0.6) + '" fill="none" stroke="#dcc286" stroke-width="' + (mag === 100 ? 5 : 2) + '" transform="rotate(-20)"/>' : '';
        var jMoons = tid === 'jupiter' && mag >= 10 ? '<circle cx="' + (-r - 14) + '" cy="-6" r="2.2" fill="#ffe4a0"/><circle cx="' + (r + 12) + '" cy="5" r="2.2" fill="#d0ecff"/><circle cx="' + (r + 26) + '" cy="11" r="2.6" fill="#e0d4c0"/><circle cx="' + (-r - 30) + '" cy="-12" r="2.2" fill="#b8b0a4"/>' : '';
        var svg = '<svg viewBox="-100 -100 200 200" width="200" height="200" style="flex-shrink:0;border-radius:50%;background:#04060e;border:3px solid rgba(130,155,220,0.4);box-shadow:inset 0 0 28px #000">' +
          '<line x1="-95" y1="0" x2="-18" y2="0" stroke="rgba(120,170,255,0.22)"/><line x1="18" y1="0" x2="95" y2="0" stroke="rgba(120,170,255,0.22)"/>' +
          '<line x1="0" y1="-95" x2="0" y2="-18" stroke="rgba(120,170,255,0.22)"/><line x1="0" y1="18" x2="0" y2="95" stroke="rgba(120,170,255,0.22)"/>' +
          '<circle cx="-55" cy="-42" r="1" fill="#fff" opacity=".6"/><circle cx="48" cy="-50" r="1.2" fill="#fff" opacity=".5"/><circle cx="-40" cy="58" r="1" fill="#fff" opacity=".7"/>' +
          ring + '<circle r="' + r + '" fill="' + tb.colors[0] + '"/>' + jMoons +
          '<text x="0" y="84" text-anchor="middle" fill="#8fa8ff" font-size="11" font-weight="700">' + mag + 'x FOV</text></svg>';
        var desc = mag === 1
          ? (hi ? '1x नंगी आँख: रात के आसमान में यह एक चमकते तारे जैसा बिंदु दिखता है।' : '1x Naked eye: Appears as a steady point of light against the background stars.')
          : (mag === 10
            ? (hi ? '10x बाइनोक्युलर: एक छोटी डिस्क और प्रमुख चंद्रमा (जैसे बृहस्पति के 4 चंद्रमा) दिखने लगते हैं।' : '10x Binoculars: Resolves into a small disc; bright moons like Jupiter\'s Galilean moons appear as pinpoints.')
            : (hi ? '100x टेलिस्कोप: बादलों की पट्टियाँ, ध्रुवीय बर्फ़, क्रेटर या शनि के छल्ले साफ़ दिखाई देते हैं।' : '100x Backyard telescope: Cloud bands, polar caps, craters or Saturn\'s rings stand out clearly in the eyepiece.'));
        var btns = [1, 10, 100].map(function (m) {
          var lbl = m === 1 ? (hi ? '1x नंगी आँख' : '1x Naked eye') : (m === 10 ? (hi ? '10x बाइनोक्युलर' : '10x Binoculars') : (hi ? '100x टेलिस्कोप' : '100x Telescope'));
          return '<button class="eyes-chip' + (mag === m ? ' on' : '') + '" data-mag="' + m + '">' + lbl + '</button>';
        }).join('');
        telSim.innerHTML = '<div class="sim-flex">' + svg + '<div style="flex:1"><div class="eyes-chips" style="margin-bottom:10px">' + btns + '</div><p style="margin:6px 0 0;color:var(--text)">' + desc + '</p></div></div>';
      }
      telSim.addEventListener('click', function (e) {
        var btn = e.target.closest('[data-mag]');
        if (btn) { mag = parseInt(btn.dataset.mag, 10); drawTel(); }
      });
      onRender(drawTel);
    }
  }

  /* ---------- small API for cosmos.js (home page animation) ---------- */
  window.ASTRYL_API = { helio: helio, moonEcl: moonEcl, moonPhase: moonPhase, sunLon: sunLon, bname: bname, t: t, onRender: onRender, lang: function () { return lang; } };

  /* ---------- go ---------- */
  document.documentElement.lang = lang;
  var lb = $('#langBtn'); if (lb) lb.textContent = lang === 'hi' ? 'English' : 'हिन्दी';
  release(); homeFact(); homeMoon(); planetsPage(); comparePage(); youPage(); quizPage(); solarPage(); skyPage(); spacecraftPage(); bodyPage();
})();
