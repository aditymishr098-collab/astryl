/* Astryl home page: a turning Milky Way, and a scroll journey from the galaxy
   to the Solar System (real positions for the chosen date) to Earth and Moon.
   The galaxy is an artist's impression. Planet, Sun and Moon positions use the
   same maths as the app (see app.js). Plain canvas, no libraries. */
(function () {
  'use strict';
  var API = window.ASTRYL_API, D = window.ASTRYL;
  if (!API || !D) return;
  var reduce = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;
  var small = Math.min(screen.width || 1000, window.innerWidth) < 700;
  var TAU = Math.PI * 2;

  function rng(seed) { var s = seed >>> 0; return function () { s = (s * 1664525 + 1013904223) >>> 0; return s / 4294967296; }; }
  function gauss(r) { return (r() + r() + r() + r() - 2) / 2; }
  function clamp(x, a, b) { return Math.min(b, Math.max(a, x)); }
  function smooth(a, b, x) { var t = clamp((x - a) / (b - a), 0, 1); return t * t * (3 - 2 * t); }
  function dpr() { return Math.min(window.devicePixelRatio || 1, small ? 1.5 : 2); }

  /* ---------- the galaxy picture, drawn once ---------- */
  var GAL = 1000, GR = GAL * 0.46, ARMS = 4, SUN_R = 0.56, SUN_A = 0.9;
  function armAngle(r, arm) { return arm * TAU / ARMS + Math.log(1 + r * 5) * 2.1; }
  function makeGalaxy() {
    var c = document.createElement('canvas'); c.width = c.height = GAL;
    var x = c.getContext('2d'), R = rng(7), mid = GAL / 2, i, n = small ? 7000 : 12000;
    x.fillStyle = 'rgba(0,0,0,0)'; x.clearRect(0, 0, GAL, GAL);
    x.globalCompositeOperation = 'lighter';
    var g = x.createRadialGradient(mid, mid, 0, mid, mid, GR * 0.34);
    g.addColorStop(0, 'rgba(255,224,170,.85)'); g.addColorStop(.35, 'rgba(255,190,120,.30)'); g.addColorStop(1, 'rgba(255,170,100,0)');
    x.fillStyle = g; x.fillRect(0, 0, GAL, GAL);
    for (i = 0; i < 260; i++) {                       /* soft glow along the arms */
      var r0 = Math.pow(R(), .7), a0 = armAngle(r0, Math.floor(R() * ARMS)) + gauss(R) * .35, rr = GR * r0;
      var px = mid + Math.cos(a0) * rr, py = mid + Math.sin(a0) * rr, sz = GR * (.05 + .08 * R());
      var gg = x.createRadialGradient(px, py, 0, px, py, sz);
      gg.addColorStop(0, 'rgba(120,150,255,.05)'); gg.addColorStop(1, 'rgba(120,150,255,0)');
      x.fillStyle = gg; x.fillRect(px - sz, py - sz, sz * 2, sz * 2);
    }
    for (i = 0; i < n; i++) {                         /* stars */
      var bulge = R() < .22, r, a, col;
      if (bulge) { r = Math.abs(gauss(R)) * .22; a = R() * TAU; col = [255, 225 + R() * 25 | 0, 170 + R() * 40 | 0]; }
      else { r = Math.pow(R(), .62); a = armAngle(r, Math.floor(R() * ARMS)) + gauss(R) * (.22 + .5 * r); var m = R(); col = m < .55 ? [165, 190, 255] : m < .85 ? [235, 235, 255] : [255, 215, 160]; }
      var d = GR * r, px2 = mid + Math.cos(a) * d, py2 = mid + Math.sin(a) * d, al = (.25 + R() * .6) * (bulge ? .9 : 1), sz2 = R() < .04 ? 2.2 : 1.1;
      x.fillStyle = 'rgba(' + col[0] + ',' + col[1] + ',' + col[2] + ',' + al.toFixed(2) + ')';
      x.fillRect(px2, py2, sz2, sz2);
    }
    return c;
  }
  var galaxy = null;
  function ensureGalaxy() { if (!galaxy) galaxy = makeGalaxy(); return galaxy; }

  /* galaxy drawn flat and tilted. (lx, ly) are in galaxy units, 0 = centre. */
  function galaxyMatrix(ctx, spin, tilt, flat) { ctx.rotate(tilt); ctx.scale(1, flat); ctx.rotate(spin); }
  function sunPoint(spin, tilt, flat, k) {
    var a = SUN_A + spin, lx = Math.cos(a) * SUN_R * GR * k, ly = Math.sin(a) * SUN_R * GR * k;
    var y2 = ly * flat, ct = Math.cos(tilt), st = Math.sin(tilt);
    return { x: lx * ct - y2 * st, y: lx * st + y2 * ct };
  }

  function fit(canvas) {
    var d = dpr(), w = canvas.clientWidth, h = canvas.clientHeight;
    if (!w || !h) return null;
    var bw = Math.round(w * d), bh = Math.round(h * d);
    if (canvas.width !== bw || canvas.height !== bh) { canvas.width = bw; canvas.height = bh; }
    var ctx = canvas.getContext('2d'); ctx.setTransform(d, 0, 0, d, 0, 0);
    return { ctx: ctx, w: w, h: h };
  }

  /* ---------- background stars (fixed, cheap) ---------- */
  var BG = (function () { var R = rng(99), a = [], i; for (i = 0; i < (small ? 110 : 220); i++) a.push([R(), R(), R() < .1 ? 1.6 : 1, .25 + R() * .6, R() * TAU]); return a; })();
  function drawBg(ctx, w, h, time, alpha, shift) {
    ctx.save(); ctx.globalAlpha = alpha;
    for (var i = 0; i < BG.length; i++) {
      var s = BG[i], tw = reduce ? 1 : .75 + .25 * Math.sin(time * 1.3 + s[4]);
      ctx.fillStyle = 'rgba(235,240,255,' + (s[3] * tw).toFixed(2) + ')';
      ctx.fillRect(s[0] * w, ((s[1] * h + shift * (.3 + s[2] * .2)) % h + h) % h, s[2], s[2]);
    }
    ctx.restore();
  }

  /* ---------- 1. hero ---------- */
  var heroCanvas = document.getElementById('galaxy');
  var heroOn = true, heroMouse = { x: 0, y: 0 }, heroT0 = performance.now();
  function drawHero(now) {
    var f = fit(heroCanvas); if (!f) return;
    var ctx = f.ctx, w = f.w, h = f.h, time = (now - heroT0) / 1000;
    ctx.clearRect(0, 0, w, h);
    drawBg(ctx, w, h, time, 1, 0);
    var wide = w > 820, size = Math.min(wide ? w * .62 : w * 1.25, h * 1.5), k = size / GAL;
    var cx = wide ? w * .66 : w * .5, cy = wide ? h * .5 : h * .8;
    var spin = reduce ? 0 : time * .035, tilt = -.38, flat = .5;
    cx += heroMouse.x * 14; cy += heroMouse.y * 9;
    ctx.save(); ctx.translate(cx, cy);
    ctx.save(); galaxyMatrix(ctx, spin, tilt, flat); ctx.globalAlpha = wide ? 1 : .8; ctx.drawImage(ensureGalaxy(), -GAL * k / 2, -GAL * k / 2, GAL * k, GAL * k); ctx.restore();
    var p = sunPoint(spin, tilt, flat, k);
    ctx.fillStyle = '#f2b84b'; ctx.beginPath(); ctx.arc(p.x, p.y, 3.2, 0, TAU); ctx.fill();
    ctx.strokeStyle = 'rgba(242,184,75,.55)'; ctx.lineWidth = 1; ctx.beginPath(); ctx.arc(p.x, p.y, 9 + (reduce ? 0 : 1.5 * Math.sin(time * 2)), 0, TAU); ctx.stroke();
    ctx.font = '600 12px "DM Sans",sans-serif'; ctx.fillStyle = '#f2b84b'; ctx.textAlign = 'left';
    ctx.fillText(API.t('cosmosHere'), p.x + 15, p.y + 4);
    ctx.restore();
  }
  function heroLoop(now) {
    if (heroOn && !document.hidden) drawHero(now);
    if (!reduce) requestAnimationFrame(heroLoop);
  }
  if (heroCanvas) {
    var box = heroCanvas.parentNode;
    if ('IntersectionObserver' in window) new IntersectionObserver(function (e) { heroOn = e[0].isIntersecting; if (heroOn && reduce) drawHero(performance.now()); }).observe(box);
    if (!reduce) box.addEventListener('pointermove', function (e) { var r = box.getBoundingClientRect(); heroMouse.x = (e.clientX - r.left) / r.width - .5; heroMouse.y = (e.clientY - r.top) / r.height - .5; });
    window.addEventListener('resize', function () { if (reduce) drawHero(performance.now()); });
    requestAnimationFrame(heroLoop);
  }

  /* ---------- 2. the journey ---------- */
  var jr = document.getElementById('journey'), jc = document.getElementById('cosmos');
  if (!jr || !jc) return;
  function sizeHeader() { var hd = document.querySelector('header.top'); if (hd) jr.style.setProperty('--hh', hd.offsetHeight + 'px'); }
  sizeHeader(); window.addEventListener('resize', sizeHeader);
  var caps = [].slice.call(jr.querySelectorAll('.cap')), dots = [].slice.call(jr.querySelectorAll('.jdots i'));
  var dateEl = document.getElementById('jDate'), phaseEl = document.getElementById('jPhase');
  var PL = ['mercury', 'venus', 'earth', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto'];
  var SZ = { mercury: 3, venus: 4.5, earth: 5, mars: 4, jupiter: 9, saturn: 8, uranus: 6, neptune: 6, pluto: 3 };
  var COL = {}; D.bodies.forEach(function (b) { COL[b.id] = b.color; });
  var FLAT = .74, AU_MAX = 40;
  var orbitPts = {};
  /* orbit shapes from the orbital elements (epoch values), one full turn */
  PL.forEach(function (id) {
    var el = D.orbits[id], a = el[0], e = el[2], inc = el[4] * Math.PI / 180, peri = el[8] * Math.PI / 180, node = el[10] * Math.PI / 180, om = peri - node, pts = [], n = 160;
    var cw = Math.cos(om), sw = Math.sin(om), cn = Math.cos(node), sn = Math.sin(node), ci = Math.cos(inc);
    for (var i = 0; i <= n; i++) {
      var E = TAU * i / n, xp = a * (Math.cos(E) - e), yp = a * Math.sqrt(1 - e * e) * Math.sin(E);
      var x = (cw * cn - sw * sn * ci) * xp + (-sw * cn - cw * sn * ci) * yp, y = (cw * sn + sw * cn * ci) * xp + (-sw * sn + cw * cn * ci) * yp;
      pts.push([Math.sqrt(x * x + y * y), Math.atan2(y, x)]);
    }
    orbitPts[id] = pts;
  });
  function rpx(rAu, maxR) { return maxR * Math.sqrt(Math.min(rAu, 60) / AU_MAX); }
  function pos(rAu, ang, maxR) { var r = rpx(rAu, maxR); return { x: Math.cos(ang) * r, y: -Math.sin(ang) * r * FLAT }; }

  var P = 0, queued = false, tick0 = performance.now(), nowMs = Date.now();
  function progress() {
    var r = jr.getBoundingClientRect(), total = r.height - window.innerHeight;
    return clamp(total > 0 ? -r.top / total : 0, 0, 1);
  }
  function lbl(ctx, text, x, y, align) {
    ctx.textAlign = align || 'left'; ctx.fillText(text, x, y);
  }
  function drawJourney() {
    queued = false;
    var f = fit(jc); if (!f) return;
    var ctx = f.ctx, w = f.w, h = f.h, time = (performance.now() - tick0) / 1000, p = P, cx = w / 2, cy = h / 2;
    ctx.clearRect(0, 0, w, h);
    var gAlpha = 1 - smooth(.14, .30, p), sAlpha = smooth(.26, .36, p) * (1 - smooth(.62, .72, p)), eAlpha = smooth(.64, .76, p);
    drawBg(ctx, w, h, time, 1, p * 400);

    /* stage 1: Milky Way, zooming to the Sun */
    if (gAlpha > .01) {
      var e = smooth(0, .32, p), k = Math.min(w, h) * 1.15 / GAL * (w > h ? .95 : 1.2), spin = .6, tilt = -.38, flat = .5;
      var m = sunPoint(spin, tilt, flat, k), z = Math.exp(Math.log(70) * e);
      ctx.save(); ctx.globalAlpha = gAlpha; ctx.translate(cx, cy); ctx.scale(z, z); ctx.translate(-m.x * e, -m.y * e);
      ctx.save(); galaxyMatrix(ctx, spin, tilt, flat); ctx.drawImage(ensureGalaxy(), -GAL * k / 2, -GAL * k / 2, GAL * k, GAL * k); ctx.restore();
      ctx.restore();
      var sx = cx + (m.x - m.x * e) * z, sy = cy + (m.y - m.y * e) * z;
      ctx.save(); ctx.globalAlpha = gAlpha; ctx.fillStyle = '#f2b84b'; ctx.beginPath(); ctx.arc(sx, sy, 3.5 + e * 6, 0, TAU); ctx.fill();
      ctx.strokeStyle = 'rgba(242,184,75,.6)'; ctx.beginPath(); ctx.arc(sx, sy, 11 + e * 8, 0, TAU); ctx.stroke();
      ctx.font = '600 13px "DM Sans",sans-serif'; ctx.fillStyle = '#f2b84b'; lbl(ctx, API.t('cosmosHere'), sx + 18 + e * 8, sy + 4); ctx.restore();
    }

    /* stage 2: Solar System, real positions; scrolling moves time forward */
    var sp = smooth(.34, .62, p), simMs = nowMs + sp * 3 * 365.25 * 86400000, maxR = Math.min(w * (small ? .4 : .5), h * .5) * .92;
    if (sAlpha > .01) {
      ctx.save(); ctx.globalAlpha = sAlpha; ctx.translate(cx, cy);
      ctx.lineWidth = 1; ctx.strokeStyle = 'rgba(160,175,230,.22)';
      PL.forEach(function (id) {
        var pts = orbitPts[id]; ctx.beginPath();
        for (var i = 0; i < pts.length; i++) { var q = pos(pts[i][0], pts[i][1], maxR); if (i) ctx.lineTo(q.x, q.y); else ctx.moveTo(q.x, q.y); }
        ctx.stroke();
      });
      var g = ctx.createRadialGradient(0, 0, 0, 0, 0, 34); g.addColorStop(0, 'rgba(255,240,200,1)'); g.addColorStop(.25, 'rgba(255,200,90,.9)'); g.addColorStop(1, 'rgba(255,170,60,0)');
      ctx.fillStyle = g; ctx.beginPath(); ctx.arc(0, 0, 34, 0, TAU); ctx.fill();
      ctx.font = '500 ' + (small ? 11 : 12.5) + 'px "DM Sans",sans-serif';
      PL.forEach(function (id) {
        var q = API.helio(id, simMs), r = Math.sqrt(q.x * q.x + q.y * q.y), s = pos(r, Math.atan2(q.y, q.x), maxR), sz = SZ[id];
        if (id === 'saturn') { ctx.strokeStyle = 'rgba(230,205,150,.7)'; ctx.beginPath(); ctx.ellipse(s.x, s.y, sz * 1.9, sz * .6, -.3, 0, TAU); ctx.stroke(); }
        ctx.fillStyle = COL[id] || '#ccc'; ctx.beginPath(); ctx.arc(s.x, s.y, sz, 0, TAU); ctx.fill();
        if (id === 'earth') { ctx.strokeStyle = 'rgba(255,255,255,.8)'; ctx.beginPath(); ctx.arc(s.x, s.y, sz + 3, 0, TAU); ctx.stroke(); }
        if (small && (id === 'mercury' || id === 'venus' || id === 'pluto')) return;
        ctx.fillStyle = 'rgba(235,240,255,.85)'; lbl(ctx, API.bname(id), s.x + sz + 6, s.y + 4);
      });
      ctx.restore();
    }
    if (dateEl) {
      var show = sAlpha > .05, txt = '';
      if (show) txt = sp < .005 ? API.t('cosmosToday') : new Date(simMs).toLocaleDateString(API.lang() === 'hi' ? 'hi-IN' : 'en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
      dateEl.textContent = txt; dateEl.style.opacity = show ? sAlpha : 0;
    }

    /* stage 3: Earth and Moon, today */
    if (eAlpha > .01) {
      var flatE = .62, ro = Math.min(w * .36, h * .34), ms = nowMs, mo = API.moonEcl(ms), sl = API.sunLon(ms) * Math.PI / 180, ml = mo.lon * Math.PI / 180;
      ctx.save(); ctx.globalAlpha = eAlpha; ctx.translate(cx, cy);
      var sdx = Math.cos(sl), sdy = -Math.sin(sl) * flatE;
      var sg = ctx.createRadialGradient(sdx * ro * 1.9, sdy * ro * 1.9, 0, sdx * ro * 1.9, sdy * ro * 1.9, ro * .9);
      sg.addColorStop(0, 'rgba(255,225,150,.55)'); sg.addColorStop(1, 'rgba(255,200,80,0)'); ctx.fillStyle = sg; ctx.fillRect(-w, -h, w * 2, h * 2);
      ctx.strokeStyle = 'rgba(160,175,230,.3)'; ctx.setLineDash([4, 6]); ctx.beginPath(); ctx.ellipse(0, 0, ro, ro * flatE, 0, 0, TAU); ctx.stroke(); ctx.setLineDash([]);
      var er = small ? 26 : 34, eg = ctx.createRadialGradient(sdx * er * .45, sdy * er * .45, er * .1, 0, 0, er);
      eg.addColorStop(0, '#7fb8ff'); eg.addColorStop(.6, '#2e63c9'); eg.addColorStop(1, '#0d1f55');
      ctx.fillStyle = eg; ctx.beginPath(); ctx.arc(0, 0, er, 0, TAU); ctx.fill();
      var mx = Math.cos(ml) * ro, my = -Math.sin(ml) * ro * flatE, mr = small ? 9 : 12;
      ctx.save(); ctx.translate(mx, my); ctx.fillStyle = '#2a2d40'; ctx.beginPath(); ctx.arc(0, 0, mr, 0, TAU); ctx.fill();
      ctx.beginPath(); ctx.arc(0, 0, mr, 0, TAU); ctx.clip(); ctx.fillStyle = '#ecebe4';
      ctx.beginPath(); ctx.arc(0, 0, mr, -Math.PI / 2 + Math.atan2(sdy, sdx) + Math.PI / 2 - Math.PI / 2, Math.atan2(sdy, sdx) + Math.PI / 2); ctx.fill();
      ctx.restore();
      ctx.font = '500 ' + (small ? 11 : 12.5) + 'px "DM Sans",sans-serif'; ctx.fillStyle = 'rgba(235,240,255,.9)';
      lbl(ctx, API.bname('earth'), 0, er + 18, 'center'); lbl(ctx, API.bname('moon'), mx, my - mr - 8, 'center');
      ctx.fillStyle = '#f2b84b'; lbl(ctx, '☀ ' + API.t('cosmosSun'), sdx * ro * 1.55, sdy * ro * 1.55, 'center');
      ctx.restore();
    }
    if (phaseEl) {
      var vis = eAlpha > .05; phaseEl.style.opacity = vis ? eAlpha : 0;
      if (vis) {
        var ph = API.moonPhase(nowMs), age = ph.age, c = Math.cos(age * Math.PI / 180), lit = Math.round(ph.lit * 100), dayN = Math.round(age / 360 * 29.53);
        var pc = phaseEl.querySelector('canvas'), pd = dpr(), S = 64;
        if (pc.width !== S * pd) { pc.width = pc.height = S * pd; }
        var px = pc.getContext('2d'); px.setTransform(pd, 0, 0, pd, 0, 0); px.clearRect(0, 0, S, S); px.translate(S / 2, S / 2);
        var rr = S / 2 - 3, flip = age > 180 ? -1 : 1;
        px.fillStyle = '#2a2d40'; px.beginPath(); px.arc(0, 0, rr, 0, TAU); px.fill();
        if (ph.lit > .01) { px.fillStyle = '#ecebe4'; px.beginPath(); px.arc(0, 0, rr, -Math.PI / 2, Math.PI / 2, flip < 0); px.fill(); }
        if (ph.lit > .01) { px.fillStyle = c > 0 ? '#2a2d40' : '#ecebe4'; px.beginPath(); px.ellipse(0, 0, Math.max(.01, Math.abs(c)) * rr, rr, 0, 0, TAU); px.fill(); }
        phaseEl.querySelector('span').textContent = API.t('cosmosMoon', { lit: lit, day: dayN });
      }
    }

    /* captions and dots */
    var stage = p < .3 ? 0 : p < .68 ? 1 : 2;
    caps.forEach(function (c2, i) { c2.classList.toggle('on', i === stage); });
    dots.forEach(function (d2, i) { d2.classList.toggle('on', i === stage); });
  }
  function queue() { if (!queued) { queued = true; requestAnimationFrame(drawJourney); } }
  var jOn = true;
  if ('IntersectionObserver' in window) new IntersectionObserver(function (e) { jOn = e[0].isIntersecting; if (jOn) { P = progress(); queue(); } }).observe(jr);
  window.addEventListener('scroll', function () { if (jOn) { P = progress(); queue(); } }, { passive: true });
  window.addEventListener('resize', function () { P = progress(); queue(); });
  document.addEventListener('astryl-change', queue);
  API.onRender(queue);
  P = progress(); queue();
  if (!reduce) (function loop() { if (jOn && !document.hidden && P > .3) queue(); setTimeout(function () { requestAnimationFrame(loop); }, 120); })();
})();
