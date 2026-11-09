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

  var theme = store.get('astryl-theme');
  function applyTheme() {
    if (theme) document.documentElement.setAttribute('data-theme', theme);
    var dark = theme ? theme === 'dark' : !(window.matchMedia && matchMedia('(prefers-color-scheme: light)').matches);
    var b = $('#themeBtn'); if (b) b.textContent = dark ? '☀' : '☾';
  }
  applyTheme();
  document.addEventListener('click', function (e) {
    if (e.target.id === 'langBtn') setLang(lang === 'hi' ? 'en' : 'hi');
    if (e.target.id === 'themeBtn') {
      var dark = document.documentElement.getAttribute('data-theme') ? document.documentElement.getAttribute('data-theme') === 'dark'
        : !(window.matchMedia && matchMedia('(prefers-color-scheme: light)').matches);
      theme = dark ? 'light' : 'dark'; store.set('astryl-theme', theme); applyTheme(); changed();
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
    fetch('https://api.github.com/repos/aditymishr098-collab/astryl/releases/latest').then(function (r) { return r.ok ? r.json() : Promise.reject(); }).then(function (j) {
      var apk = (j.assets || []).filter(function (a) { return /\.apk$/i.test(a.name); })[0];
      btns.forEach(function (b) { if (apk) b.href = apk.browser_download_url; });
      $$('.ver').forEach(function (v) { v.textContent = j.tag_name + (apk ? ' · ' + (apk.size / 1048576).toFixed(0) + ' MB' : ''); });
    }).catch(function () {});
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
      var h = '<h2>' + t('ageTitle') + '</h2><div class="grid sm">';
      planets.forEach(function (pl) { var yrs = days / pl.year, next = Math.ceil((Math.floor(yrs) + 1) * pl.year - days); h += '<div class="card"><h3>' + bname(pl.id) + '</h3><div class="life" style="font-size:1.6rem">' + fmt(yrs, 1) + '</div><p>' + t('nextBirthday', { days: fmt(next) }) + '</p></div>'; });
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
    function qkey(k) { return 'q' + k.charAt(0).toUpperCase() + k.slice(1); }
    function best(l) { return parseInt(store.get('astryl-best-' + l) || '0', 10); }
    function start(l) {
      level = l; i = 0; score = 0; picked = null; done = false;
      qs = shuffle(KINDS[l].slice()).slice(0, 10).map(function (k) {
        var ans = answerFor(k), others = shuffle(distractors(k).filter(function (p) { return p.id !== ans.id; })).slice(0, 3);
        return { k: k, ans: ans, opts: shuffle([ans].concat(others)) };
      });
      draw();
    }
    function draw() {
      var h = '';
      if (!level) {
        h = '<p class="sub">' + t('quizIntro') + '</p><p><b>' + t('quizChoose') + '</b></p><div class="grid">';
        ['easy', 'medium', 'hard'].forEach(function (l) {
          h += '<button class="card" data-lv="' + l + '" style="text-align:left;cursor:pointer;font:inherit;color:var(--text)"><h3>' + t('level' + l.charAt(0).toUpperCase() + l.slice(1)) + '</h3><p>' + t('level' + l.charAt(0).toUpperCase() + l.slice(1) + 'Hint') + '</p><p>' + t('quizBest', { score: best(l) + '/10' }) + '</p></button>';
        });
        root.innerHTML = h + '</div>'; return;
      }
      if (done) {
        var nb = score > best(level); if (nb) { store.set('astryl-best-' + level, String(score)); changed(); }
        root.innerHTML = '<div class="card" style="text-align:center"><div class="life">' + score + ' / ' + qs.length + '</div><p>' + t('quizScore', { score: score, total: qs.length }) + '</p><p>' + (nb ? '<b class="ok">' + t('quizNewBest') + '</b>' : t('quizBest', { score: best(level) + '/10' })) + '</p><button class="btn primary" id="again">' + t('quizAgain') + '</button></div>'; return;
      }
      var q = qs[i];
      h = '<p class="note">' + t('quizProgress', { current: i + 1, total: qs.length }) + '</p><div class="progress"><i style="width:' + ((i + (picked ? 1 : 0)) / qs.length * 100) + '%"></i></div><h2>' + t(qkey(q.k)) + '</h2>';
      q.opts.forEach(function (o) { var cls = picked ? (o.id === q.ans.id ? ' right' : (o.id === picked ? ' wrong' : '')) : ''; h += '<button class="opt' + cls + '" data-id="' + o.id + '"' + (picked ? ' disabled' : '') + '>' + bname(o.id) + '</button>'; });
      if (picked) h += '<p><b class="' + (picked === q.ans.id ? 'ok' : 'no') + '">' + (picked === q.ans.id ? t('quizCorrect') : t('quizWrong', { answer: bname(q.ans.id) })) + '</b></p><button class="btn primary" id="next">' + (i + 1 === qs.length ? t('quizSeeResult') : t('quizNext')) + '</button>';
      root.innerHTML = h;
    }
    root.addEventListener('click', function (e) {
      var el = e.target.closest('[data-lv],[data-id],#next,#again'); if (!el) return;
      if (el.dataset.lv) start(el.dataset.lv);
      else if (el.id === 'again') { level = null; draw(); }
      else if (el.id === 'next') { if (i + 1 < qs.length) { i++; picked = null; } else done = true; draw(); }
      else if (el.dataset.id && !picked) { picked = el.dataset.id; if (picked === qs[i].ans.id) score++; draw(); }
    });
    onRender(draw);
  }

  /* ---------- page: solar system (live positions) ---------- */
  function solarPage() {
    var cv = $('#solar'); if (!cv) return;
    var ctx = cv.getContext('2d'), day = $('#solDay'), lab = $('#solDate'), playBtn = $('#solPlay'), todayBtn = $('#solToday');
    var ms = Date.now(), playing = false, last = 0;
    var size = 640; cv.width = size * 2; cv.height = size * 2; cv.style.width = '100%'; cv.style.maxWidth = size + 'px'; cv.style.aspectRatio = '1';
    function draw() {
      var S = cv.width, c = S / 2, maxR = S / 2 - 40;
      ctx.clearRect(0, 0, S, S); ctx.fillStyle = '#05070f'; ctx.fillRect(0, 0, S, S);
      function rr(au) { return Math.sqrt(au / 40) * maxR; }
      ctx.lineWidth = 2; ctx.strokeStyle = 'rgba(150,160,210,.25)';
      planets.concat([byId.pluto]).forEach(function (p) { var a = D.orbits[p.id][0]; ctx.beginPath(); ctx.arc(c, c, rr(a), 0, 7); ctx.stroke(); });
      var g = ctx.createRadialGradient(c, c, 2, c, c, 34); g.addColorStop(0, '#fff3c4'); g.addColorStop(.4, '#ffb13b'); g.addColorStop(1, 'rgba(255,140,30,0)');
      ctx.fillStyle = g; ctx.beginPath(); ctx.arc(c, c, 34, 0, 7); ctx.fill();
      ctx.font = '600 26px "DM Sans",sans-serif'; ctx.textAlign = 'left';
      planets.concat([byId.pluto]).forEach(function (p) {
        var h = helio(p.id, ms), au = Math.sqrt(h.x * h.x + h.y * h.y), ang = Math.atan2(h.y, h.x), x = c + rr(au) * Math.cos(ang), y = c - rr(au) * Math.sin(ang);
        var rad_ = p.id === 'jupiter' || p.id === 'saturn' ? 13 : p.id === 'uranus' || p.id === 'neptune' ? 10 : p.id === 'pluto' ? 6 : 8;
        ctx.fillStyle = p.color; ctx.beginPath(); ctx.arc(x, y, rad_, 0, 7); ctx.fill();
        if (p.id === 'saturn') { ctx.strokeStyle = 'rgba(230,210,160,.8)'; ctx.lineWidth = 3; ctx.beginPath(); ctx.ellipse(x, y, 22, 7, -.3, 0, 7); ctx.stroke(); ctx.lineWidth = 2; }
        ctx.fillStyle = 'rgba(235,238,255,.9)'; var nm = bname(p.id), tw = ctx.measureText(nm).width; ctx.fillText(nm, x + rad_ + 6 + tw > S - 6 ? x - rad_ - 6 - tw : x + rad_ + 6, y + 8);
      });
      lab.textContent = dateText(ms);
    }
    function setMs(v) { ms = Math.min(MAX, Math.max(MIN, v)); day.value = Math.round((ms - Date.now()) / 86400000); draw(); }
    day.addEventListener('input', function () { ms = Date.now() + parseInt(day.value, 10) * 86400000; draw(); });
    playBtn.addEventListener('click', function () { playing = !playing; playBtn.textContent = playing ? t('pause') : t('play'); if (playing) { last = 0; requestAnimationFrame(tick); } });
    todayBtn.addEventListener('click', function () { playing = false; playBtn.textContent = t('play'); setMs(Date.now()); });
    function tick(ts) { if (!playing) return; if (last) { ms += (ts - last) / 1000 * 20 * 86400000; if (ms > MAX) ms = MIN; day.value = Math.max(day.min, Math.min(day.max, Math.round((ms - Date.now()) / 86400000))); draw(); } last = ts; requestAnimationFrame(tick); }
    onRender(function () { playBtn.textContent = playing ? t('pause') : t('play'); todayBtn.textContent = t('today'); draw(); });
    $('#solMonthBack').addEventListener('click', function () { setMs(ms - 30 * 86400000); });
    $('#solMonthFwd').addEventListener('click', function () { setMs(ms + 30 * 86400000); });
    // Distances from Earth today.
    var tbl = $('#solTable');
    onRender(function () {
      var now = Date.now(), h = '<table class="cmp cols"><tr><th></th><th>' + t('distanceFromEarth') + '</th><th>' + t('lightTime') + '</th></tr>';
      planets.filter(function (p) { return p.id !== 'earth'; }).concat([byId.sun]).forEach(function (p) { var km = distFromEarthKm(p.id, now); h += '<tr><td>' + bname(p.id) + '</td><td class="w">' + PT.km(km) + '</td><td>' + PT.duration(km / C_KMS) + '</td></tr>'; });
      tbl.innerHTML = h + '</table>';
    });
  }

  /* ---------- page: sky (moon today, calendar, meteor showers) ---------- */
  function skyPage() {
    var box = $('#moonNow'); if (!box) return;
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

  /* ---------- page: a body (distance from Earth today) ---------- */
  function bodyPage() {
    var box = $('#travel'); if (!box) return;
    onRender(function () {
      var km = distFromEarthKm(box.dataset.body, Date.now());
      box.innerHTML = '<div class="stats"><div class="stat"><b>' + PT.km(km) + '</b><span>' + t('distanceFromEarth') + '</span></div><div class="stat"><b>' + PT.duration(km / C_KMS) + '</b><span>' + t('lightTime') + '</span></div><div class="stat"><b>' + PT.duration(km / (60000 / 3600)) + '</b><span>' + t('bySpacecraft') + '</span></div><div class="stat"><b>' + PT.duration(km / 100 * 3600) + '</b><span>' + t('byCar') + '</span></div></div>';
    });
  }

  /* ---------- small API for cosmos.js (home page animation) ---------- */
  window.ASTRYL_API = { helio: helio, moonEcl: moonEcl, moonPhase: moonPhase, sunLon: sunLon, bname: bname, t: t, onRender: onRender, lang: function () { return lang; } };

  /* ---------- go ---------- */
  document.documentElement.lang = lang;
  var lb = $('#langBtn'); if (lb) lb.textContent = lang === 'hi' ? 'English' : 'हिन्दी';
  release(); homeFact(); homeMoon(); planetsPage(); comparePage(); youPage(); quizPage(); solarPage(); skyPage(); spacecraftPage(); bodyPage();
})();
