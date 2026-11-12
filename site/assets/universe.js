/* Universe map: the planets (now), nearby stars, black holes and 3,600 real galaxies in one 3D space.
   The same data and maths as the Astryl app (lib/core/universe.dart). Runs in the browser only; nothing is sent anywhere. */
(function () {
  var U = window.ASTRYL_UNI, A = window.ASTRYL, API = window.ASTRYL_API, cv = document.getElementById('umCv');
  if (!U || !cv || !API) return;
  var ctx = cv.getContext('2d');
  var AU_LY = 63241.077, EDGE = 46.5e9, R0 = 26700, GYEAR = 230e6, OTURN = 250e6, MAXD = 2e11, OBL = 23.4392911 * Math.PI / 180, KM_AU = 149597870.7;
  var E1 = [-0.0548755604, -0.8734370902, -0.4838350155], E2 = [0.4941094279, -0.4448296300, 0.7469822445], E3 = [-0.8676661490, -0.1980763734, 0.4559837762];
  function $(id) { return document.getElementById(id); }
  function rad(d) { return d * Math.PI / 180; }
  function eq(ra, dec, d) { var a = rad(ra), b = rad(dec); return [d * Math.cos(b) * Math.cos(a), d * Math.cos(b) * Math.sin(a), d * Math.sin(b)]; }
  function dot(a, b) { return a[0] * b[0] + a[1] * b[1] + a[2] * b[2]; }
  function cross(a, b) { return [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]]; }
  function unit(a) { var l = Math.sqrt(dot(a, a)) || 1; return [a[0] / l, a[1] / l, a[2] / l]; }
  function rot(v, ax, ang) { var c = Math.cos(ang), s = Math.sin(ang), x = cross(ax, v), k = dot(ax, v) * (1 - c); return [v[0] * c + x[0] * s + ax[0] * k, v[1] * c + x[1] * s + ax[1] * k, v[2] * c + x[2] * s + ax[2] * k]; }
  function ecl(p) { var c = Math.cos(OBL), s = Math.sin(OBL); return [p.x, p.y * c - p.z * s, p.y * s + p.z * c]; }
  var GC = eq(266.4168, -29.0078, R0), ECLN = ecl({ x: 0, y: 0, z: 1 });
  function turn(p, years) {
    if (!years) return p;
    var v = rot([p[0] - GC[0], p[1] - GC[1], p[2] - GC[2]], E3, -2 * Math.PI * years / GYEAR);
    return [GC[0] + v[0], GC[1] + v[1], GC[2] + v[2]];
  }
  function lcg(seed) { var s = seed >>> 0; return function () { s = (Math.imul(s, 1664525) + 1013904223) >>> 0; return (s + 0.5) / 4294967296; }; }
  function gauss(r) { return Math.sqrt(-2 * Math.log(r())) * Math.cos(2 * Math.PI * r()); }

  /* ---------- the things on the map ---------- */
  var KIND = { sun: 0, planet: 1, star: 2, nebula: 3, scl: 4, hole: 5, mw: 6, galaxy: 7, gcl: 8 };
  var bodies = [], galaxies = [], others = [];
  function add(o) { bodies.push(o); (o.k === KIND.galaxy ? galaxies : others).push(o); return o; }
  var SUN = add({ k: KIND.sun, id: 'sun', name: 'Sun', p: [0, 0, 0], r: 0.00465 / AU_LY, inMW: true, rank: 0 });
  var YEAR = { mercury: 87.969, venus: 224.701, earth: 365.256, mars: 686.98, jupiter: 4332.59, saturn: 10759.22, uranus: 30688.5, neptune: 60182 };
  var COLOR = {};
  (A && A.bodies || []).forEach(function (b) { COLOR[b.id] = b.color; });
  Object.keys(YEAR).forEach(function (id) { add({ k: KIND.planet, id: id, name: id, p: [0, 0, 0], r: 0.0005 / AU_LY, inMW: true, rank: 1, year: YEAR[id] }); });
  U.s.forEach(function (s) { add({ k: s[4] === 1 ? KIND.nebula : (s[4] === 2 ? KIND.scl : KIND.star), id: s[0], name: s[0], p: eq(s[1], s[2], s[3]), r: s[4] === 0 ? 0.0002 : 10, d: s[3], inMW: true, rank: 2, tint: s[5] }); });
  U.h.forEach(function (h) { add({ k: KIND.hole, id: h[0], name: h[0], p: eq(h[1], h[2], h[3]), r: h[5] * 2.95 / 9.4607e12, d: h[3], light: h[4], mass: h[5], est: h[6] === 1, inMW: h[3] < 60000, rank: 2 }); });
  var MW = add({ k: KIND.mw, id: 'milkyway', name: 'Milky Way', p: GC, r: 50000, d: R0, inMW: true, rank: 0, shape: 'B' });
  U.g.split('\n').forEach(function (line) {
    var f = line.split('|'); if (f.length < 11) return;
    var d = parseFloat(f[4]) * 1e6, w = parseFloat(f[5]) * 1e3, m = /^(NGC|IC)0*(\d+)(.*)$/.exec(f[0]), cat = m ? m[1] + ' ' + m[2] + m[3] : f[0], ms = f[1] ? 'M' + f[1] : '';
    add({ k: KIND.galaxy, id: f[0], name: f[10] || (ms ? ms + ' (' + cat + ')' : cat), p: eq(parseFloat(f[2]), parseFloat(f[3]), d), r: Math.max(w / 2, 1500), d: d, est: f[7] === '1', rank: f[10] ? 3 : (ms ? 4 : 9), shape: f[6], pa: parseFloat(f[8]), ratio: parseFloat(f[9]), find: (f[10] + ' ' + ms + ' ' + cat + ' ' + f[0]).toLowerCase() });
  });
  U.m.forEach(function (m) { add({ k: m[5] === 0 ? KIND.gcl : KIND.galaxy, id: m[0], name: m[0], p: eq(m[1], m[2], m[3]), r: m[5] === 0 ? 5e6 : 3000, d: m[3], light: m[4], est: m[5] === 1, rank: m[5] === 0 ? 3 : 2, shape: 'U', pa: 0, ratio: 1 }); });
  bodies.forEach(function (b) { if (!b.find) b.find = b.name.toLowerCase(); });

  /* the Milky Way as points: a model with the real size, a bar and four trailing arms */
  var cloud = (function () {
    var r = lcg(7), a = [], b = [], c = [], g = [];
    function put(x, y, z, k) { a.push(x); b.push(y); c.push(z); g.push(k); }
    var i, ba = rad(27), k = Math.tan(rad(12.5));
    for (i = 0; i < 520; i++) put(gauss(r) * 2800, gauss(r) * 2800, gauss(r) * 1700, 0);
    for (i = 0; i < 320; i++) { var al = gauss(r) * 6500, ac = gauss(r) * 1300; put(-al * Math.cos(ba) - ac * Math.sin(ba), -al * Math.sin(ba) + ac * Math.cos(ba), gauss(r) * 700, 0); }
    for (var arm = 0; arm < 4; arm++) for (i = 0; i < 560; i++) { var rr = 9000 + r() * 42000, an = arm * Math.PI / 2 + 0.6 + Math.log(rr / 9000) / k, sp = 900 + rr * 0.035; put(rr * Math.cos(an) + gauss(r) * sp, rr * Math.sin(an) + gauss(r) * sp, gauss(r) * 450, 1); }
    for (i = 0; i < 700; i++) { var rd = -13000 * Math.log(r()); if (rd > 55000) continue; var th = r() * 2 * Math.PI; put(rd * Math.cos(th), rd * Math.sin(th), gauss(r) * 600, 2); }
    return { a: a, b: b, c: c, g: g };
  })();
  var templates = {};
  function template(shape) {
    if (templates[shape]) return templates[shape];
    var r = lcg(11 + shape.charCodeAt(0)), x = [], y = [], z = [], i;
    function put(a, b, c) { x.push(a); y.push(b); z.push(c); }
    if (shape === 'E') for (i = 0; i < 220; i++) put(gauss(r) * 0.33, gauss(r) * 0.33, gauss(r) * 0.33);
    else if (shape === 'L') for (i = 0; i < 220; i++) { var s = i < 90 ? 0.14 : 0.36; put(gauss(r) * s, gauss(r) * s, gauss(r) * 0.05); }
    else if (shape === 'I') for (i = 0; i < 180; i++) put((i % 3 - 1) * 0.25 + gauss(r) * 0.25, gauss(r) * 0.3, gauss(r) * 0.12);
    else {
      for (i = 0; i < 60; i++) put(gauss(r) * 0.09, gauss(r) * 0.09, gauss(r) * 0.05);
      if (shape === 'B') for (i = 0; i < 40; i++) put(gauss(r) * 0.2, gauss(r) * 0.04, gauss(r) * 0.02);
      var k = Math.tan(rad(15));
      for (var arm = 0; arm < 2; arm++) for (i = 0; i < 90; i++) { var rr = 0.18 + r() * 0.8, an = arm * Math.PI + Math.log(rr / 0.18) / k, sp = 0.03 + rr * 0.05; put(rr * Math.cos(an) + gauss(r) * sp, rr * Math.sin(an) + gauss(r) * sp, gauss(r) * 0.015); }
    }
    return (templates[shape] = { x: x, y: y, z: z });
  }
  function axes(b) {
    if (b.ax) return b.ax;
    var d = unit(b.p), ra = Math.atan2(d[1], d[0]), dec = Math.asin(Math.max(-1, Math.min(1, d[2])));
    var east = [-Math.sin(ra), Math.cos(ra), 0], north = [-Math.sin(dec) * Math.cos(ra), -Math.sin(dec) * Math.sin(ra), Math.cos(dec)], pa = rad(b.pa || 0);
    var major = [0, 1, 2].map(function (i) { return north[i] * Math.cos(pa) + east[i] * Math.sin(pa); });
    var minor = [0, 1, 2].map(function (i) { return east[i] * Math.cos(pa) - north[i] * Math.sin(pa); });
    var tilt = Math.acos(Math.max(0.05, Math.min(1, b.ratio || 1)));
    var normal = unit([0, 1, 2].map(function (i) { return d[i] * Math.cos(tilt) + minor[i] * Math.sin(tilt); }));
    return (b.ax = [major, unit(cross(normal, major)), normal]);
  }

  /* ---------- state ---------- */
  var LEVELS = [['solar', 0.0011, 'Solar System', 'सौर मंडल'], ['stars', 45, 'Nearby stars', 'पास के तारे'], ['mw', 190000, 'Milky Way', 'आकाशगंगा'], ['local', 6.5e6, 'Local Group', 'स्थानीय समूह'], ['gal', 3.2e8, 'Galaxies', 'आकाशगंगाएँ'], ['uni', 1.4e11, 'Universe', 'ब्रह्मांड']];
  var SPEEDS = [[1 / (365.25 * 86400), 'Real time', 'असली समय'], [1 / 365.25, '1 day/s', '1 दिन/से'], [1, '1 year/s', '1 साल/से'], [1e6, '1 million years/s', '10 लाख साल/से'], [25e6, '25 million years/s', '2.5 करोड़ साल/से']];
  var NOW = Date.now(), S = { focus: SUN, sel: null, yaw: 0.7, pitch: 0.45, logD: Math.log10(0.0011), years: 0, speed: 0, fly: null };
  var still = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var W = 0, H = 0, hits = [], dirty = true, lastT = 0, sinceDraw = 0, sinceHud = 0;
  function levelOf(d) { return d < 0.3 ? 0 : d < 20000 ? 1 : d < 1.2e6 ? 2 : d < 4e7 ? 3 : d < 6e9 ? 4 : 5; }
  function planetAt(b, years) {
    var ms = NOW + years * 365.25 * 86400000, lo = Date.UTC(1800, 0, 1), hi = Date.UTC(2050, 11, 31), inside = Math.min(hi, Math.max(lo, ms));
    var q = ecl(API.helio(b.id, inside)), p = [q[0] / AU_LY, q[1] / AU_LY, q[2] / AU_LY], extra = (ms - inside) / (365.25 * 86400000);
    if (extra) { var t = extra * 365.25 / b.year; p = rot(p, ECLN, 2 * Math.PI * (t - Math.floor(t))); }
    return p;
  }
  function posOf(b) {
    if (b.k === KIND.planet) { var s = turn([0, 0, 0], S.years), o = planetAt(b, SPEEDS[S.speed][0] > 50 ? 0 : S.years); return [s[0] + o[0], s[1] + o[1], s[2] + o[2]]; }
    return b.inMW ? turn(b.p, S.years) : b.p;
  }
  function focusPos() {
    var to = posOf(S.focus), f = S.fly;
    if (!f) return to;
    var t = Math.max(0, Math.min(1, (f.t - 0.25) / 0.5)), s = t * t * (3 - 2 * t);
    return [f.from[0] + (to[0] - f.from[0]) * s, f.from[1] + (to[1] - f.from[1]) * s, f.from[2] + (to[2] - f.from[2]) * s];
  }
  function minLog(b) {
    var d = b.k === KIND.sun ? 3e-6 : b.k === KIND.planet ? 2e-6 : b.k === KIND.hole ? b.r * 4 : b.k === KIND.star ? 0.02 : (b.k === KIND.nebula || b.k === KIND.scl) ? 20 : b.k === KIND.gcl ? 2e6 : b.r * 0.6;
    return Math.log10(d);
  }
  function viewDist(b) {
    return b.k === KIND.sun ? 0.0011 : b.k === KIND.planet ? 6e-5 : b.k === KIND.star ? 9 : (b.k === KIND.nebula || b.k === KIND.scl) ? 120 : b.k === KIND.hole ? b.r * 12 : b.k === KIND.mw ? 190000 : b.k === KIND.gcl ? 4e7 : Math.max(b.r * 4.5, 20000);
  }
  function flyTo(b, dist) {
    var from = focusPos(), to = posOf(b), toLog = Math.max(Math.log10(dist || viewDist(b)), minLog(b));
    S.focus = b;
    if (still) { S.fly = null; S.logD = toLog; }
    else {
      var travel = Math.sqrt(Math.pow(to[0] - from[0], 2) + Math.pow(to[1] - from[1], 2) + Math.pow(to[2] - from[2], 2)), mid = (S.logD + toLog) / 2;
      if (travel > 0 && Math.log10(travel * 1.3) > Math.max(S.logD, toLog)) mid = Math.log10(travel * 1.3);
      mid = Math.min(mid, Math.log10(MAXD));
      S.fly = { t: 0, from: from, a: S.logD, b: toLog, mid: mid, secs: mid - Math.min(S.logD, toLog) > 2 ? 2.4 : 1.3 };
    }
    dirty = true; hud();
  }

  /* ---------- words and numbers ---------- */
  function lang() { return API.lang ? API.lang() : 'en'; }
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + (hi || en) + '</span>'; }
  function num(x, loc) { var a = Math.abs(x), d = a >= 100 ? 0 : a >= 10 ? 1 : 2; return x.toLocaleString(loc, { maximumFractionDigits: d }); }
  function both(x, en, hi) { return bi(num(x, 'en-US') + ' ' + en, num(x, 'hi-IN') + ' ' + (hi || en)); }
  function lenText(ly) {
    if (ly < 0.01) { var au = ly * AU_LY; if (au < 0.01) { var km = au * KM_AU; return km >= 1e6 ? both(km / 1e6, 'million km', 'मिलियन किमी') : both(km, 'km', 'किमी'); } return both(au, 'AU'); }
    if (ly < 1000) return both(ly, 'light-years', 'प्रकाश-वर्ष');
    if (ly < 1e6) return both(ly / 1e3, 'thousand light-years', 'हज़ार प्रकाश-वर्ष');
    if (ly < 1e9) return both(ly / 1e6, 'million light-years', 'मिलियन प्रकाश-वर्ष');
    return both(ly / 1e9, 'billion light-years', 'अरब प्रकाश-वर्ष');
  }
  function yearsText(y) {
    if (y < 1) return both(y * 365.25, 'days', 'दिन');
    if (y < 1000) return both(y, 'years', 'साल');
    if (y < 1e6) return both(y / 1e3, 'thousand years', 'हज़ार साल');
    if (y < 1e9) return both(y / 1e6, 'million years', 'मिलियन साल');
    return both(y / 1e9, 'billion years', 'अरब साल');
  }
  function massText(m) { return m < 1e6 ? both(m, 'Suns', 'सूर्य') : m < 1e9 ? both(m / 1e6, 'million Suns', 'मिलियन सूर्य') : both(m / 1e9, 'billion Suns', 'अरब सूर्य'); }
  function kmText(km) { return km >= 1e9 ? both(km / 1e9, 'billion km', 'अरब किमी') : km >= 1e6 ? both(km / 1e6, 'million km', 'मिलियन किमी') : both(km, 'km', 'किमी'); }
  function nameOf(b, plain) {
    if (b.k === KIND.sun || b.k === KIND.planet) return API.bname ? API.bname(b.id) : b.id;
    if (b.k === KIND.mw) return plain ? (lang() === 'hi' ? 'आकाशगंगा' : 'Milky Way') : bi('Milky Way', 'आकाशगंगा (मिल्की वे)');
    return plain ? b.name : esc(b.name);
  }
  function esc(x) { return String(x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  var SHAPE = { S: ['Spiral galaxy', 'सर्पिल आकाशगंगा'], B: ['Barred spiral galaxy', 'दंड-सर्पिल आकाशगंगा'], E: ['Elliptical galaxy', 'दीर्घवृत्ताकार आकाशगंगा'], L: ['Lenticular galaxy', 'लेंसाकार आकाशगंगा'], I: ['Irregular galaxy', 'अनियमित आकाशगंगा'], U: ['Galaxy', 'आकाशगंगा'] };
  function kindOf(b) {
    switch (b.k) {
      case KIND.sun: case KIND.star: return bi('Star', 'तारा');
      case KIND.planet: return bi('Planet', 'ग्रह');
      case KIND.nebula: return bi('Nebula', 'नीहारिका');
      case KIND.scl: return bi('Star cluster', 'तारा समूह');
      case KIND.hole: return bi('Black hole', 'ब्लैक होल');
      case KIND.gcl: return bi('Cluster of galaxies', 'आकाशगंगाओं का समूह');
      default: var s = SHAPE[b.shape] || SHAPE.U; return bi(s[0], s[1]);
    }
  }

  /* ---------- drawing ---------- */
  var cam = {}, sx = 0, sy = 0, depth = 0;
  function project(x, y, z) {
    var vx = x - cam.bx, vy = y - cam.by, vz = z - cam.bz, d = vx * cam.f[0] + vy * cam.f[1] + vz * cam.f[2];
    if (d <= cam.dist * 1e-3) return false;
    depth = d; sx = cam.cx + cam.focal * (vx * cam.r[0] + vy * cam.r[1] + vz * cam.r[2]) / d; sy = cam.cy - cam.focal * (vx * cam.u[0] + vy * cam.u[1] + vz * cam.u[2]) / d;
    return true;
  }
  function projAt(p) { return project(p[0] - cam.fp[0], p[1] - cam.fp[1], p[2] - cam.fp[2]); }
  var TINT = ['#bfd4ff', '#f4f6ff', '#fff1c4', '#ffc98a', '#ff9e80'], orbits = {};
  function orbit(b) {
    if (orbits[b.id]) return orbits[b.id];
    var out = [], base = Math.min(Date.UTC(2050, 11, 31), NOW), per = b.year * 86400000;
    for (var i = 0; i < 96; i++) { var ms = base + per * i / 96; while (ms > Date.UTC(2050, 11, 31)) ms -= per; var q = ecl(API.helio(b.id, ms)); out.push([q[0] / AU_LY, q[1] / AU_LY, q[2] / AU_LY]); }
    return (orbits[b.id] = out);
  }
  function ring(x, y, r) { ctx.strokeStyle = '#8fb4ff'; ctx.lineWidth = 1.4; ctx.beginPath(); ctx.arc(x, y, r, 0, 6.2832); ctx.stroke(); }
  function hit(b, x, y, reach) { hits.push([b, x, y, reach]); }
  function draw() {
    var dpr = Math.min(window.devicePixelRatio || 1, 2), rect = cv.getBoundingClientRect();
    W = rect.width; H = rect.height;
    if (!W || !H) return;
    if (cv.width !== Math.round(W * dpr) || cv.height !== Math.round(H * dpr)) { cv.width = Math.round(W * dpr); cv.height = Math.round(H * dpr); }
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    ctx.fillStyle = '#03050a'; ctx.fillRect(0, 0, W, H);
    hits = [];
    var D = Math.pow(10, S.logD), cp = Math.cos(S.pitch), sp = Math.sin(S.pitch), dir = [cp * Math.cos(S.yaw), cp * Math.sin(S.yaw), sp];
    cam.dist = D; cam.cx = W / 2; cam.cy = H / 2; cam.focal = Math.min(W, H) * 0.9;
    cam.bx = dir[0] * D; cam.by = dir[1] * D; cam.bz = dir[2] * D;
    cam.f = [-dir[0], -dir[1], -dir[2]]; cam.r = unit(cross(cam.f, [0, 0, 1])); cam.u = unit(cross(cam.r, cam.f)); cam.fp = focusPos();
    var labels = [], fp = cam.fp, i, b, px, near, rx, ry, rz, chosen;

    // Milky Way
    var ang = -2 * Math.PI * S.years / GYEAR, ca = Math.cos(ang), sa = Math.sin(ang), g = [GC[0] - fp[0], GC[1] - fp[1], GC[2] - fp[2]];
    var seen = projAt(GC), spread = seen ? cam.focal * 50000 / depth : 1000, pw = spread < 40 ? 1 : spread < 200 ? 1.4 : 1.8, alpha = spread < 12 ? 0.35 : 0.6;
    var cols = ['rgba(255,221,166,' + alpha + ')', 'rgba(169,198,255,' + alpha + ')', 'rgba(216,222,236,' + alpha * 0.6 + ')'];
    for (var grp = 0; grp < 3; grp++) {
      ctx.fillStyle = cols[grp];
      for (i = 0; i < cloud.a.length; i++) {
        if (cloud.g[i] !== grp) continue;
        var a = cloud.a[i] * ca - cloud.b[i] * sa, bb = cloud.a[i] * sa + cloud.b[i] * ca, c = cloud.c[i];
        if (!project(g[0] + E1[0] * a + E2[0] * bb + E3[0] * c, g[1] + E1[1] * a + E2[1] * bb + E3[1] * c, g[2] + E1[2] * a + E2[2] * bb + E3[2] * c)) continue;
        if (sx < -4 || sy < -4 || sx > W + 4 || sy > H + 4) continue;
        ctx.fillRect(sx - pw / 2, sy - pw / 2, pw, pw);
      }
    }

    // galaxies
    var fade = Math.max(0.3, Math.min(1, (S.logD - 2.5) / 2.5)), sprites = [];
    ctx.fillStyle = 'rgba(203,216,245,' + (0.75 * fade) + ')';
    for (i = 0; i < galaxies.length; i++) {
      b = galaxies[i]; rx = b.p[0] - fp[0]; ry = b.p[1] - fp[1]; rz = b.p[2] - fp[2];
      if (!project(rx, ry, rz)) continue;
      if (sx < -30 || sy < -30 || sx > W + 30 || sy > H + 30) continue;
      px = cam.focal * b.r / depth; near = Math.sqrt(rx * rx + ry * ry + rz * rz) / D; chosen = b === S.sel;
      if (px >= 5 && sprites.length < 48) sprites.push([b, px]); else ctx.fillRect(sx - 0.9, sy - 0.9, 1.8, 1.8);
      if (near <= 60 || px >= 1.2 || chosen) hit(b, sx, sy, Math.min(px, 60));
      if (chosen) ring(sx, sy, Math.max(px, 6) + 5);
      if (chosen || (b.rank <= 4 && near <= 3.2 && (near >= 0.02 || b === S.focus))) labels.push([nameOf(b, true), sx + Math.min(px, 40) + 5, sy, b.rank, near, chosen]);
    }
    var spin = 2 * Math.PI * S.years / OTURN, cs = Math.cos(spin), sn = Math.sin(spin);
    sprites.forEach(function (sp2) {
      var gx = sp2[0], t = template(gx.shape), ax = axes(gx), M = ax[0], N = ax[1], Z = ax[2], r = gx.r, ox = gx.p[0] - fp[0], oy = gx.p[1] - fp[1], oz = gx.p[2] - fp[2];
      var warm = gx.shape === 'E' || gx.shape === 'L', w = Math.max(1.3, Math.min(3.2, sp2[1] / 28)), flat = gx.shape === 'E' ? Math.max(0.4, Math.min(1, gx.ratio)) : 1;
      ctx.fillStyle = warm ? 'rgba(255,227,181,0.8)' : 'rgba(196,214,255,0.8)';
      for (var j = 0; j < t.x.length; j++) {
        var x = (t.x[j] * cs - t.y[j] * sn) * r, y = (t.x[j] * sn + t.y[j] * cs) * r, z = t.z[j] * r * flat;
        if (project(ox + M[0] * x + N[0] * y + Z[0] * z, oy + M[1] * x + N[1] * y + Z[1] * z, oz + M[2] * x + N[2] * y + Z[2] * z)) ctx.fillRect(sx - w / 2, sy - w / 2, w, w);
      }
    });

    // planets, stars, black holes, clusters
    var sunPos = posOf(SUN), showPlanets = D < 0.02;
    if (showPlanets) {
      ctx.strokeStyle = 'rgba(94,114,153,0.7)'; ctx.lineWidth = 1;
      others.forEach(function (o) {
        if (o.k !== KIND.planet) return;
        var pts = orbit(o), started = false; ctx.beginPath();
        for (var j = 0; j <= pts.length; j++) { var q = pts[j % pts.length]; if (!projAt([sunPos[0] + q[0], sunPos[1] + q[1], sunPos[2] + q[2]])) { started = false; continue; } if (started) ctx.lineTo(sx, sy); else { ctx.moveTo(sx, sy); started = true; } }
        ctx.stroke();
      });
    }
    for (i = 0; i < others.length; i++) {
      b = others[i]; var isFocus = b === S.focus; chosen = b === S.sel;
      if (b.k === KIND.planet && !showPlanets) continue;
      if (b.k === KIND.mw) {
        if (D < 20000 || !projAt(GC)) continue;
        px = cam.focal * b.r / depth; hit(b, sx, sy, Math.min(px * 0.6, 50));
        if (chosen) ring(sx, sy, Math.max(px, 6) + 5);
        labels.push([nameOf(b, true), sx + Math.min(px, 30) + 6, sy, 0, 0, chosen]); continue;
      }
      var p = posOf(b); rx = p[0] - fp[0]; ry = p[1] - fp[1]; rz = p[2] - fp[2];
      if (!project(rx, ry, rz)) continue;
      if (sx < -40 || sy < -40 || sx > W + 40 || sy > H + 40) continue;
      near = Math.sqrt(rx * rx + ry * ry + rz * rz) / D; px = cam.focal * b.r / depth;
      var x0 = sx, y0 = sy, radius = 2, tappable = true, wants = near <= 3.2 && (near >= 0.02 || isFocus);
      if (b.k === KIND.sun) {
        if (D > 3000 && !isFocus && !chosen) continue;
        radius = Math.max(px, D < 0.02 ? 5 : 2.6);
        ctx.fillStyle = 'rgba(255,210,122,0.18)'; ctx.beginPath(); ctx.arc(x0, y0, radius * 2.4, 0, 6.2832); ctx.fill();
        ctx.fillStyle = '#ffe9a8'; ctx.beginPath(); ctx.arc(x0, y0, radius, 0, 6.2832); ctx.fill(); wants = D < 3000;
      } else if (b.k === KIND.planet) {
        radius = 3.2; ctx.fillStyle = COLOR[b.id] || '#9ab'; ctx.beginPath(); ctx.arc(x0, y0, radius, 0, 6.2832); ctx.fill(); wants = true;
      } else if (b.k === KIND.star || b.k === KIND.nebula || b.k === KIND.scl) {
        if (D > 250000 && !isFocus && !chosen) continue;
        var close = near <= 40; radius = close ? 2.4 : 1.3; ctx.fillStyle = TINT[b.tint] || TINT[1];
        if (b.k !== KIND.star && close) { ctx.globalAlpha = 0.16; ctx.beginPath(); ctx.arc(x0, y0, Math.max(px, 5), 0, 6.2832); ctx.fill(); }
        ctx.globalAlpha = close ? 1 : 0.55; ctx.beginPath(); ctx.arc(x0, y0, radius, 0, 6.2832); ctx.fill(); ctx.globalAlpha = 1; tappable = close || chosen;
      } else if (b.k === KIND.hole) {
        var far = near > 60 || !(b.inMW ? D <= 400000 : ((b.light > 0 && D > 1e9) || D < 2e7));
        if (far && !isFocus && !chosen) continue;
        if (px > 3.5) {
          ctx.strokeStyle = 'rgba(255,180,94,0.5)'; ctx.lineWidth = Math.max(px * 0.5, 1.5); ctx.beginPath(); ctx.arc(x0, y0, px * 2.6, 0, 6.2832); ctx.stroke(); radius = px;
        } else radius = 3.4;
        ctx.fillStyle = '#000'; ctx.beginPath(); ctx.arc(x0, y0, radius, 0, 6.2832); ctx.fill();
        ctx.strokeStyle = '#ffb45e'; ctx.lineWidth = 1.4; ctx.beginPath(); ctx.arc(x0, y0, radius, 0, 6.2832); ctx.stroke();
        wants = wants && near <= 2.2;
      } else if (b.k === KIND.gcl) {
        if (near > 12 || D < 2e6) continue;
        radius = Math.max(px, 6); ctx.strokeStyle = 'rgba(154,166,188,0.35)'; ctx.lineWidth = 1; ctx.beginPath(); ctx.arc(x0, y0, radius, 0, 6.2832); ctx.stroke(); radius = Math.min(radius, 26);
      }
      if (tappable) hit(b, x0, y0, Math.min(radius, 40));
      if (chosen) ring(x0, y0, Math.min(radius, 200) + 5);
      if (chosen || wants) labels.push([nameOf(b, true), x0 + Math.min(radius, 40) + 5, y0, b.rank, near, chosen]);
    }

    // the edge of the observable universe: a ball around us
    if (D >= 3e9) {
      var cx3 = fp[0] + cam.bx, cy3 = fp[1] + cam.by, cz3 = fp[2] + cam.bz, dc = Math.sqrt(cx3 * cx3 + cy3 * cy3 + cz3 * cz3);
      if (dc > EDGE * 1.02 && projAt([0, 0, 0])) {
        var er = cam.focal * EDGE / Math.sqrt(dc * dc - EDGE * EDGE);
        ctx.strokeStyle = 'rgba(143,180,255,0.55)'; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.arc(sx, sy, er, 0, 6.2832); ctx.stroke();
        labels.push([lang() === 'hi' ? 'दिखने वाले ब्रह्मांड का किनारा' : 'Edge of the observable universe', sx - 90, sy - er - 16, 0, 0, false]);
      }
    }

    // names
    labels.sort(function (p1, p2) { return p1[5] !== p2[5] ? (p1[5] ? -1 : 1) : p1[3] !== p2[3] ? p1[3] - p2[3] : p1[4] - p2[4]; });
    var taken = []; ctx.textBaseline = 'middle'; ctx.shadowColor = '#03050a'; ctx.shadowBlur = 4;
    for (i = 0; i < labels.length && taken.length < 16; i++) {
      var L = labels[i]; ctx.font = (L[5] ? '700' : '500') + ' 12px "DM Sans",system-ui,sans-serif';
      var tw = Math.min(ctx.measureText(L[0]).width, 220), lx = Math.max(4, Math.min(L[1], W - 4 - tw)), ly = Math.max(10, Math.min(L[2], H - 10)), box = [lx - 3, ly - 10, lx + tw + 3, ly + 10], free = true;
      for (var q2 = 0; q2 < taken.length; q2++) { var o2 = taken[q2]; if (box[0] < o2[2] && box[2] > o2[0] && box[1] < o2[3] && box[3] > o2[1]) { free = false; break; } }
      if (!free && !L[5]) continue;
      taken.push(box); ctx.fillStyle = L[5] ? '#e8edf7' : 'rgba(232,237,247,0.82)'; ctx.fillText(L[0], lx, ly, 220);
    }
    ctx.shadowBlur = 0;
    scaleBar(D);
  }

  /* A scale bar in the corner: a round length that fits about a fifth of the screen. */
  function plainText(html) { var m = html.match(lang() === 'hi' ? /lang="hi">([^<]*)/ : /lang="en">([^<]*)/); return m ? m[1] : html.replace(/<[^>]+>/g, ''); }
  function scaleBar(D) {
    // a round number in the unit the label will use (km, AU, light-years, thousand, million or billion light-years)
    var perPx = D / cam.focal, want = perPx * Math.min(W * 0.22, 160);
    var unit = want < 0.01 ? (want * AU_LY < 0.01 ? 1 / (AU_LY * KM_AU) : 1 / AU_LY) : want < 1000 ? 1 : want < 1e6 ? 1e3 : want < 1e9 ? 1e6 : 1e9;
    if (unit === 1 / (AU_LY * KM_AU) && want * AU_LY * KM_AU >= 1e6) unit = 1e6 / (AU_LY * KM_AU);
    var inUnit = want / unit, p10 = Math.pow(10, Math.floor(Math.log10(inUnit))), len = ([5, 2, 1].map(function (k) { return k * p10; }).filter(function (v) { return v <= inUnit; })[0] || p10) * unit;
    var px = len / perPx, x = 14, y = H - 16;
    ctx.strokeStyle = 'rgba(232,237,247,.8)'; ctx.lineWidth = 2; ctx.beginPath();
    ctx.moveTo(x, y - 5); ctx.lineTo(x, y); ctx.lineTo(x + px, y); ctx.lineTo(x + px, y - 5); ctx.stroke();
    ctx.fillStyle = 'rgba(232,237,247,.9)'; ctx.font = '600 11px "DM Sans",system-ui,sans-serif'; ctx.textBaseline = 'bottom';
    ctx.fillText(plainText(lenText(len)), x, y - 7);
  }

  /* ---------- page parts ---------- */
  function hud() {
    var D = Math.pow(10, S.logD), lv = levelOf(D);
    Array.prototype.forEach.call(document.querySelectorAll('#umLevels button'), function (b, i) { b.classList.toggle('on', i === lv); });
    Array.prototype.forEach.call(document.querySelectorAll('#umSpeeds button'), function (b, i) { b.classList.toggle('on', i === S.speed); });
    var width = W ? D * W / (Math.min(W, H) * 0.9) : D;
    $('umScale').innerHTML = bi('Screen width ≈ ', 'स्क्रीन की चौड़ाई ≈ ') + lenText(width);
    var t = S.years < 0.5 / 365.25 ? bi('Now', 'अभी') : bi('', 'अब से ') + yearsText(S.years) + bi(' from now', ' बाद');
    if (S.speed > 0) t += ' · ' + bi('Sped up: in real time this motion is far too slow to see.', 'तेज़ किया गया: असली समय में यह चाल इतनी धीमी है कि दिखती नहीं।');
    $('umTime').innerHTML = t;
  }
  function info() {
    var box = $('umInfo'), b = S.sel;
    if (!b) { box.hidden = true; return; }
    var rows = [];
    function row(en, hi, v) { rows.push('<div class="umrow"><span>' + bi(en, hi) + '</span><b>' + v + '</b></div>'); }
    function distRows() {
      if (b.light) { row('Its light travelled for', 'इसकी रोशनी ने सफ़र किया', yearsText(b.light)); row('Distance today', 'आज की दूरी', lenText(b.d)); }
      else row('Distance from Earth', 'पृथ्वी से दूरी', lenText(b.d));
    }
    if (b.k === KIND.sun || (b.k === KIND.planet && b.id !== 'earth')) {
      var e = API.helio('earth', NOW), q = b.k === KIND.sun ? { x: 0, y: 0, z: 0 } : API.helio(b.id, NOW);
      row('Distance from Earth', 'पृथ्वी से दूरी', kmText(Math.sqrt(Math.pow(q.x - e.x, 2) + Math.pow(q.y - e.y, 2) + Math.pow(q.z - e.z, 2)) * KM_AU));
    } else if (b.k === KIND.hole) { distRows(); row('Mass', 'द्रव्यमान', massText(b.mass)); row('Horizon radius', 'घटना क्षितिज की त्रिज्या', kmText(b.mass * 2.95)); }
    else if (b.k === KIND.mw || b.k === KIND.galaxy) { distRows(); if (b.k === KIND.mw || b.r > 1500) row('Width', 'चौड़ाई', lenText(b.r * 2)); }
    else if (b.k !== KIND.planet) row('Distance from Earth', 'पृथ्वी से दूरी', lenText(b.d));
    box.innerHTML = '<div class="umhead"><div><h3>' + nameOf(b) + '</h3><p>' + kindOf(b) + '</p></div><button type="button" class="umx" id="umClose" aria-label="Close">×</button></div>' + rows.join('') +
      (b.est ? '<p class="note">' + bi('Distance estimated from its redshift.', 'दूरी इसके रेडशिफ़्ट से आँकी गई है।') + '</p>' : '') +
      (b !== S.focus ? '<button type="button" class="btn primary" id="umFly">🚀 ' + bi('Fly here', 'यहाँ उड़ें') + '</button>' : '');
    box.hidden = false;
    $('umClose').onclick = function () { S.sel = null; info(); dirty = true; };
    if ($('umFly')) $('umFly').onclick = function () { flyTo(b); info(); };
  }
  function search() {
    var q = $('umFind').value.trim().toLowerCase(), list = $('umFound');
    if (!q) { list.innerHTML = ''; list.hidden = true; return; }
    var out = bodies.filter(function (b) { return b.find.indexOf(q) >= 0 || ((b.k <= KIND.planet || b.k === KIND.mw) && nameOf(b, true).toLowerCase().indexOf(q) >= 0); });
    out.sort(function (a, b) { return a.rank - b.rank; });
    out = out.slice(0, 30);
    list.innerHTML = out.length ? out.map(function (b) { return '<button type="button" data-i="' + bodies.indexOf(b) + '"><b>' + nameOf(b) + '</b><span>' + kindOf(b) + '</span></button>'; }).join('') : '<p class="note">' + bi('Nothing found', 'कुछ नहीं मिला') + '</p>';
    list.hidden = false;
  }

  $('umLevels').innerHTML = LEVELS.map(function (l, i) { return '<button type="button" data-i="' + i + '">' + bi(l[2], l[3]) + '</button>'; }).join('');
  $('umSpeeds').innerHTML = SPEEDS.map(function (s, i) { return '<button type="button" data-i="' + i + '">' + bi(s[1], s[2]) + '</button>'; }).join('');
  $('umLevels').addEventListener('click', function (e) {
    var b = e.target.closest('button'); if (!b) return;
    var i = +b.getAttribute('data-i'); flyTo(i >= 2 && i <= 4 ? MW : SUN, LEVELS[i][1]);
  });
  $('umSpeeds').addEventListener('click', function (e) { var b = e.target.closest('button'); if (!b) return; S.speed = +b.getAttribute('data-i'); dirty = true; hud(); });
  $('umNow').addEventListener('click', function () { S.years = 0; S.speed = 0; dirty = true; hud(); });
  $('umFind').addEventListener('input', search);
  $('umFound').addEventListener('click', function (e) {
    var b = e.target.closest('button'); if (!b) return;
    var body = bodies[+b.getAttribute('data-i')]; S.sel = body; $('umFind').value = ''; search(); flyTo(body); info();
    cv.scrollIntoView({ block: 'nearest' });
  });

  /* ---------- full screen ---------- */
  var sect = cv.closest('.umap'), fullBtn = $('umFull');
  function setFull(on) {
    sect.classList.toggle('umfull', on); document.documentElement.classList.toggle('umlock', on);
    fullBtn.textContent = on ? '✕' : '⛶'; fullBtn.setAttribute('aria-label', on ? 'Exit full screen' : 'Full screen');
    if (on && sect.requestFullscreen && !document.fullscreenElement) sect.requestFullscreen().catch(function () {});
    if (!on && document.fullscreenElement) document.exitFullscreen().catch(function () {});
    dirty = true; setTimeout(function () { dirty = true; }, 250);
  }
  fullBtn.addEventListener('click', function () { setFull(!sect.classList.contains('umfull')); });
  document.addEventListener('fullscreenchange', function () { if (!document.fullscreenElement && sect.classList.contains('umfull')) setFull(false); });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape' && sect.classList.contains('umfull')) setFull(false); });

  /* ---------- guided tour ---------- */
  function find(word) { for (var i = 0; i < bodies.length; i++) if (bodies[i].find.indexOf(word) >= 0) return bodies[i]; return null; }
  var TOUR = [
    [SUN, LEVELS[0][1], 'Home: the Sun and the eight planets, where they are right now. Light from the Sun takes about 4 hours to reach Neptune.', 'घर: सूरज और आठों ग्रह, अभी जहाँ हैं वहीं। सूरज की रोशनी को नेपच्यून तक पहुँचने में लगभग 4 घंटे लगते हैं।'],
    [find('proxima centauri'), 6, 'Proxima Centauri, the nearest star: 4.2 light-years away. Its light left it more than four years ago.', 'प्रॉक्सिमा सेंटॉरी, सबसे पास का तारा: 4.2 प्रकाश-वर्ष दूर। इसकी रोशनी चार साल से ज़्यादा पहले चली थी।'],
    [SUN, LEVELS[1][1], 'Our neighbourhood: every star here is within about 50 light-years. In the night sky most bright stars are this close.', 'हमारा मोहल्ला: यहाँ हर तारा लगभग 50 प्रकाश-वर्ष के अंदर है। रात के आसमान के ज़्यादातर चमकीले तारे इतने ही पास हैं।'],
    [MW, LEVELS[2][1], 'The Milky Way: about 100,000 light-years across, with a few hundred billion stars. The Sun is 26,700 light-years from its centre.', 'आकाशगंगा (Milky Way): लगभग 1 लाख प्रकाश-वर्ष चौड़ी, कुछ सौ अरब तारों वाली। सूरज इसके केंद्र से 26,700 प्रकाश-वर्ष दूर है।'],
    [find('andromeda galaxy'), null, 'Andromeda, 2.5 million light-years away: the farthest thing you can see with your own eyes. It may merge with the Milky Way, perhaps in about 8 billion years.', 'एंड्रोमेडा, 25 लाख प्रकाश-वर्ष दूर: सबसे दूर की चीज़ जो आप अपनी आँखों से देख सकते हैं। शायद लगभग 8 अरब साल बाद यह हमारी आकाशगंगा से मिल सकती है।'],
    [MW, LEVELS[3][1], 'The Local Group: the Milky Way, Andromeda and about 80 smaller galaxies, held together by gravity.', 'स्थानीय समूह: आकाशगंगा, एंड्रोमेडा और लगभग 80 छोटी आकाशगंगाएँ, गुरुत्व से बँधी हुई।'],
    [find('virgo cluster'), null, 'The Virgo Cluster: over a thousand galaxies, about 54 million light-years away. Its giant galaxy M87 holds the first black hole ever photographed.', 'कन्या (Virgo) समूह: हज़ार से ज़्यादा आकाशगंगाएँ, लगभग 5.4 करोड़ प्रकाश-वर्ष दूर। इसकी विशाल आकाशगंगा M87 में वह ब्लैक होल है जिसकी पहली तस्वीर ली गई।'],
    [SUN, LEVELS[5][1], 'The edge of what we can see: 46.5 billion light-years in every direction. Beyond it, light has not had time to reach us yet.', 'जितना हम देख सकते हैं उसका किनारा: हर दिशा में 46.5 अरब प्रकाश-वर्ष। उसके आगे की रोशनी अभी तक हम तक नहीं पहुँची।']
  ].filter(function (st) { return st[0]; });
  var tour = { on: false, i: 0, timer: 0 }, tourBox = $('umTour'), tourBtn = $('umTourBtn');
  function tourShow() {
    var st = TOUR[tour.i];
    tourBox.innerHTML = '<div class="umtourtxt"><b>' + (tour.i + 1) + '/' + TOUR.length + '</b> ' + bi(st[2], st[3]) + '</div><div class="umtourbtns"><button type="button" class="btn" id="umTourPrev"' + (tour.i ? '' : ' disabled') + '>‹</button><button type="button" class="btn" id="umTourNext">' + (tour.i < TOUR.length - 1 ? '›' : '✓') + '</button><button type="button" class="btn" id="umTourStop" aria-label="Stop the tour">✕</button></div>';
    tourBox.hidden = false;
    $('umTourPrev').onclick = function () { tourGo(tour.i - 1); };
    $('umTourNext').onclick = function () { if (tour.i < TOUR.length - 1) tourGo(tour.i + 1); else tourStop(); };
    $('umTourStop').onclick = tourStop;
  }
  function tourGo(i) {
    clearTimeout(tour.timer); tour.i = Math.max(0, Math.min(TOUR.length - 1, i)); var st = TOUR[tour.i];
    S.sel = null; info(); flyTo(st[0], st[1] || undefined); tourShow();
    if (!still) tour.timer = setTimeout(function () { if (tour.on && tour.i < TOUR.length - 1) tourGo(tour.i + 1); }, 9000);
  }
  function tourStop() { tour.on = false; clearTimeout(tour.timer); tourBox.hidden = true; tourBtn.classList.remove('on'); }
  tourBtn.addEventListener('click', function () { if (tour.on) { tourStop(); return; } tour.on = true; tourBtn.classList.add('on'); tourGo(0); });
  API.onRender && API.onRender(function () { if (tour.on) tourShow(); });

  /* ---------- touch, mouse, keys ---------- */
  var ptrs = {}, moved = 0, pinch0 = 0, log0 = 0;
  function count() { return Object.keys(ptrs).length; }
  function gap() { var k = Object.keys(ptrs), a = ptrs[k[0]], b = ptrs[k[1]]; return Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2)) || 1; }
  function zoom(logD) { S.logD = Math.max(minLog(S.focus), Math.min(Math.log10(MAXD), logD)); dirty = true; hud(); }
  cv.addEventListener('pointerdown', function (e) {
    cv.setPointerCapture(e.pointerId); ptrs[e.pointerId] = { x: e.clientX, y: e.clientY };
    if (count() === 1) moved = 0;
    if (count() === 2) { pinch0 = gap(); log0 = S.logD; }
    S.fly = null; clearTimeout(tour.timer);
  });
  cv.addEventListener('pointermove', function (e) {
    var p = ptrs[e.pointerId]; if (!p) return;
    var dx = e.clientX - p.x, dy = e.clientY - p.y; p.x = e.clientX; p.y = e.clientY; moved += Math.abs(dx) + Math.abs(dy);
    if (count() === 1) { S.yaw -= dx * 0.008; S.pitch = Math.max(-1.5, Math.min(1.5, S.pitch + dy * 0.006)); dirty = true; }
    else if (count() === 2) zoom(log0 - Math.log10(gap() / pinch0));
  });
  function up(e) {
    var had = count(), p = ptrs[e.pointerId]; delete ptrs[e.pointerId];
    if (e.type === 'pointerup' && had === 1 && p && moved < 8) {
      var r = cv.getBoundingClientRect(), x = e.clientX - r.left, y = e.clientY - r.top, best = null, score = Infinity;
      hits.forEach(function (h) { var d = Math.sqrt(Math.pow(h[1] - x, 2) + Math.pow(h[2] - y, 2)); if (d > Math.max(h[3] + 8, 22)) return; var s = d + h[0].rank * 1.5; if (s < score) { score = s; best = h[0]; } });
      S.sel = best; info(); dirty = true;
    }
  }
  cv.addEventListener('pointerup', up); cv.addEventListener('pointercancel', up);
  cv.addEventListener('wheel', function (e) { e.preventDefault(); S.fly = null; zoom(S.logD + e.deltaY * 0.0012); }, { passive: false });
  cv.addEventListener('keydown', function (e) {
    var k = e.key;
    if (k === '+' || k === '=') zoom(S.logD - 0.15); else if (k === '-') zoom(S.logD + 0.15);
    else if (k === 'ArrowLeft') { S.yaw += 0.08; dirty = true; } else if (k === 'ArrowRight') { S.yaw -= 0.08; dirty = true; }
    else if (k === 'ArrowUp') { S.pitch = Math.min(1.5, S.pitch + 0.06); dirty = true; } else if (k === 'ArrowDown') { S.pitch = Math.max(-1.5, S.pitch - 0.06); dirty = true; }
    else return;
    e.preventDefault();
  });
  $('umIn').addEventListener('click', function () { S.fly = null; zoom(S.logD - 0.3); });
  $('umOut').addEventListener('click', function () { S.fly = null; zoom(S.logD + 0.3); });
  window.addEventListener('resize', function () { dirty = true; });

  function frame(t) {
    var dt = Math.min((t - lastT) / 1000 || 0, 0.1); lastT = t;
    S.years += dt * SPEEDS[S.speed][0];
    var go = dirty || S.speed > 0;
    if (S.fly) {
      var f = S.fly; f.t += dt / f.secs;
      if (f.t >= 1) { S.logD = f.b; S.fly = null; hud(); }
      else { var e = f.t * f.t * (3 - 2 * f.t), ctl = 2 * f.mid - (f.a + f.b) / 2; S.logD = (1 - e) * (1 - e) * f.a + 2 * e * (1 - e) * ctl + e * e * f.b; }
      go = true;
    }
    sinceDraw += dt; sinceHud += dt;
    if (go || sinceDraw >= 1) { sinceDraw = 0; dirty = false; draw(); }
    if (sinceHud >= 0.25 && (S.speed > 0 || S.fly)) { sinceHud = 0; hud(); }
    window.requestAnimationFrame(frame);
  }
  if (API.onRender) API.onRender(function () { dirty = true; });
  draw(); hud(); window.requestAnimationFrame(frame);
  window.ASTRYL_UMAP = { state: S, bodies: bodies, flyTo: flyTo, hits: function () { return hits; } };
})();
