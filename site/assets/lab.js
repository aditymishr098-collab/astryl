/* Black hole lab: a lensing simulator and two calculators. Runs in the browser only; nothing is sent anywhere. */
(function () {
  var G = 6.674e-11, C = 2.99792458e8, HB = 1.054571817e-34, KB = 1.380649e-23, MS = 1.989e30, ME = 5.972e24, AU = 1.495978707e11, LY = 9.4607e15, YR = 3.15576e7;
  function $(id) { return document.getElementById(id); }
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + hi + '</span>'; }
  function grp(x, d) { return [x.toLocaleString('en-US', { maximumFractionDigits: d }), x.toLocaleString('hi-IN', { maximumFractionDigits: d })]; }
  function both(x, d, unEn, unHi) { var g = grp(x, d); return bi(g[0] + ' ' + unEn, g[1] + ' ' + (unHi || unEn)); }
  var SUP = { '-': '⁻', '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴', '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹' };
  function sci(x, d) {
    if (x === 0) return '0';
    var e = Math.floor(Math.log10(Math.abs(x))), m = x / Math.pow(10, e);
    if (parseFloat(m.toFixed(d)) >= 10) { m /= 10; e += 1; }
    if (Math.abs(e) < 4) return x.toLocaleString('en-US', { maximumFractionDigits: d });
    return m.toFixed(d) + ' × 10' + String(e).split('').map(function (c) { return SUP[c]; }).join('');
  }
  function length(m) {
    // metres -> text in both languages
    if (m < 1e-9) return bi(sci(m, 1) + ' m', sci(m, 1) + ' m');
    if (m < 1e-3) return bi(sci(m * 1e6, 1) + ' µm', sci(m * 1e6, 1) + ' µm');
    if (m < 1) return both(m * 1000, 1, 'mm');
    if (m < 1000) return both(m, 1, 'm');
    if (m < 1e9) return both(m / 1000, 1, 'km');
    if (m < 0.1 * AU) return both(m / 1e9, 1, 'million km', 'मिलियन km');
    if (m < 0.1 * LY) return both(m / AU, 1, 'AU');
    return both(m / LY, 2, 'light-years', 'प्रकाश-वर्ष');
  }
  function years(s) {
    var y = s / YR;
    if (y < 1) return bi(sci(s, 1) + ' seconds', sci(s, 1) + ' सेकंड');
    if (y < 1e6) return both(y, 0, 'years', 'साल');
    return bi(sci(y, 1) + ' years', sci(y, 1) + ' साल');
  }
  function put(id, html) { var e = $(id); if (e) e.innerHTML = html; }
  function row(en, hi, val) { return '<div class="stat"><b>' + val + '</b><span>' + bi(en, hi) + '</span></div>'; }

  /* ---------- 1. Schwarzschild calculator ---------- */
  var UNITS = { kg: 1, earth: ME, sun: MS };
  function calc() {
    var v = parseFloat($('cMass').value), u = $('cUnit').value;
    if (!(v > 0)) { put('cOut', '<p class="note">' + bi('Enter a mass above zero.', 'शून्य से बड़ा द्रव्यमान लिखिए।') + '</p>'); return; }
    var M = v * UNITS[u], rs = 2 * G * M / (C * C);
    var rho = 3 * Math.pow(C, 6) / (32 * Math.PI * Math.pow(G, 3) * M * M);
    var T = HB * Math.pow(C, 3) / (8 * Math.PI * G * M * KB);
    var tev = 5120 * Math.PI * G * G * Math.pow(M, 3) / (HB * Math.pow(C, 4));
    var tT = (T >= 1 && T < 1e6) ? both(T, 1, 'K') : bi(sci(T, 2) + ' K', sci(T, 2) + ' K');
    var out = row('Horizon radius', 'Horizon की त्रिज्या', length(rs)) + row('Horizon width', 'Horizon की चौड़ाई', length(2 * rs)) +
      row('Dark shadow width', 'गहरी परछाईं की चौड़ाई', length(2 * Math.sqrt(27) * G * M / (C * C))) +
      row('Average density inside', 'अंदर का औसत घनत्व', bi(sci(rho, 1) + ' kg/m³', sci(rho, 1) + ' kg/m³')) +
      row('Hawking temperature', 'Hawking temperature', tT) + row('Time to evaporate', 'ख़त्म होने में समय', years(tev));
    put('cOut', out);
    var s = M / MS, note = '';
    if (rs < 1e-15) note = bi('This is far smaller than an atomic nucleus.', 'यह परमाणु के नाभिक से भी बहुत छोटा है।');
    else if (s >= 1e9) note = bi('This is a quasar-class giant.', 'यह quasar स्तर का दानव है।');
    else if (s >= 1e5) note = bi('This is a supermassive black hole.', 'यह विशाल (supermassive) ब्लैक होल है।');
    else if (s >= 3) note = bi('This is a stellar-mass black hole, the kind a dying star can leave.', 'यह तारकीय ब्लैक होल है, जैसा मरता तारा छोड़ सकता है।');
    else note = bi('No known process makes a black hole this light today. This is a thought experiment.', 'आज कोई ज्ञात प्रक्रिया इतना हल्का ब्लैक होल नहीं बनाती। यह एक सोच का प्रयोग है।');
    put('cNote', note);
  }
  function preset(btn) {
    $('cMass').value = btn.getAttribute('data-v'); $('cUnit').value = btn.getAttribute('data-u'); calc();
  }

  /* ---------- 2. Time dilation ---------- */
  function dil() {
    var m = parseFloat($('dMass').value), x = Math.pow(10, parseFloat($('dX').value));
    if (!(m > 0)) { return; }
    var rs = 2 * G * m * MS / (C * C);
    var lg = x < 10 ? x.toFixed(2) : x < 1000 ? x.toFixed(1) : sci(x, 1);
    $('dXv').textContent = lg;
    var one = -Math.expm1(0.5 * Math.log1p(-1 / x)); // 1 - f
    var f = 1 - one, z = 1 / f - 1;
    var rate = f > 0.001 ? both(1 / f, f > 0.999 ? 10 : 3, 'hours', 'घंटे') : bi(sci(1 / f, 2) + ' hours', sci(1 / f, 2) + ' घंटे');
    var rate2 = one < 0.001 ? bi(sci(one * YR, 2) + ' s per year', sci(one * YR, 2) + ' सेकंड प्रति वर्ष') : '';
    put('dOut', row('Your distance from the centre', 'केंद्र से आपकी दूरी', length(rs * x)) +
      row('Your clock runs at', 'आपकी घड़ी की गति', bi((f * 100).toFixed(one < 0.001 ? 6 : 2) + '% of far-away time', (f * 100).toFixed(one < 0.001 ? 6 : 2) + '% दूर की घड़ी की गति का')) +
      row('1 hour for you is', 'आपका 1 घंटा बराबर', rate + ' ' + bi('far away', 'दूर की घड़ी के')) +
      row('Light from you is stretched by', 'आपकी रोशनी खिंचती है', (z < 1e-3 ? bi(sci(z * 100, 1) + '%', sci(z * 100, 1) + '%') : bi((z * 100).toLocaleString('en-US', { maximumFractionDigits: 2 }) + '%', (z * 100).toLocaleString('hi-IN', { maximumFractionDigits: 2 }) + '%'))) +
      (rate2 ? row('You fall behind by', 'आप पीछे रह जाते हैं', rate2) : ''));
    var msg = '';
    if (x < 1.05) msg = bi('Almost at the event horizon: seen from far away, your clock has nearly stopped.', 'लगभग event horizon पर: दूर से देखने पर आपकी घड़ी लगभग रुक गई है।');
    else if (Math.abs(x - 1.5) < 0.06) msg = bi('At 1.5 times the horizon radius light can circle the black hole (the photon sphere).', 'Horizon की त्रिज्या के 1.5 गुना पर रोशनी ब्लैक होल का चक्कर लगा सकती है (photon sphere)।');
    else if (x > 1e6) msg = bi('Far away the effect is tiny, but it is real: GPS satellites correct for it every day.', 'दूर यह असर बहुत छोटा है, पर असली है: GPS satellites रोज़ इसे सुधारते हैं।');
    put('dNote', msg);
  }
  function dpreset(btn) {
    $('dMass').value = btn.getAttribute('data-m'); $('dX').value = Math.log10(parseFloat(btn.getAttribute('data-x'))); dil();
  }

  /* ---------- 3. Lensing simulator ---------- */
  function sim() {
    var cv = $('simCv'); if (!cv || !cv.getContext) return;
    var ctx = cv.getContext('2d'), W = 480, H = 320;
    cv.width = W; cv.height = H;
    // background: stars and a few faint galaxies on a larger sheet
    var BW = 1400, BH = 1000, bg = document.createElement('canvas'); bg.width = BW; bg.height = BH;
    var b = bg.getContext('2d'), seed = 12345;
    function rnd() { seed = (seed * 1664525 + 1013904223) % 4294967296; return seed / 4294967296; }
    b.fillStyle = '#04060d'; b.fillRect(0, 0, BW, BH);
    for (var i = 0; i < 5200; i++) {
      var x = rnd() * BW, y = rnd() * BH, r = rnd(), a = 0.3 + rnd() * 0.7;
      b.fillStyle = r < 0.15 ? 'rgba(255,200,150,' + a + ')' : r < 0.3 ? 'rgba(170,200,255,' + a + ')' : 'rgba(255,255,255,' + a + ')';
      b.beginPath(); b.arc(x, y, r > 0.97 ? 2.6 : r > 0.85 ? 1.8 : 1.1, 0, 6.283); b.fill();
    }
    for (var g = 0; g < 60; g++) {
      var gx = rnd() * BW, gy = rnd() * BH, rot = rnd() * 3.14, len = 10 + rnd() * 22;
      var gr = b.createRadialGradient(gx, gy, 0, gx, gy, len);
      gr.addColorStop(0, 'rgba(255,230,190,.9)'); gr.addColorStop(.4, 'rgba(160,150,255,.45)'); gr.addColorStop(1, 'rgba(120,100,255,0)');
      b.save(); b.translate(gx, gy); b.rotate(rot); b.scale(1, .35); b.fillStyle = gr; b.beginPath(); b.arc(0, 0, len, 0, 6.283); b.fill(); b.restore();
    }
    var src = b.getImageData(0, 0, BW, BH).data, out = ctx.createImageData(W, H), od = out.data;
    var lens = { x: W * 0.5, y: H * 0.5 }, drag = false, R = 55, tick = 0, user = false;
    var reduce = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;
    var ox = (BW - W) / 2, oy = (BH - H) / 2;
    function draw() {
      var s2 = R * R, shadow = 0.38 * R, y, x, i = 0;
      for (y = 0; y < H; y++) {
        for (x = 0; x < W; x++, i += 4) {
          var dx = x - lens.x, dy = y - lens.y, d2 = dx * dx + dy * dy, sx, sy;
          if (d2 < shadow * shadow) { od[i] = 0; od[i + 1] = 0; od[i + 2] = 0; od[i + 3] = 255; continue; }
          var k = 1 - s2 / d2;                // point-lens: source = image - thetaE^2 * image / |image|^2
          sx = Math.round(lens.x + dx * k + ox); sy = Math.round(lens.y + dy * k + oy);
          if (sx < 0) sx = 0; else if (sx >= BW) sx = BW - 1; if (sy < 0) sy = 0; else if (sy >= BH) sy = BH - 1;
          var j = (sy * BW + sx) * 4; od[i] = src[j]; od[i + 1] = src[j + 1]; od[i + 2] = src[j + 2]; od[i + 3] = 255;
        }
      }
      ctx.putImageData(out, 0, 0);
      // thin ring marking the Einstein radius
      ctx.strokeStyle = 'rgba(255,190,110,.55)'; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.arc(lens.x, lens.y, R, 0, 6.283); ctx.stroke();
    }
    function pos(e) {
      var r = cv.getBoundingClientRect(); return { x: (e.clientX - r.left) * W / r.width, y: (e.clientY - r.top) * H / r.height };
    }
    cv.addEventListener('pointerdown', function (e) { drag = true; user = true; cv.setPointerCapture && cv.setPointerCapture(e.pointerId); var p = pos(e); lens.x = p.x; lens.y = p.y; draw(); });
    cv.addEventListener('pointermove', function (e) { if (!drag) return; var p = pos(e); lens.x = p.x; lens.y = p.y; draw(); });
    ['pointerup', 'pointercancel'].forEach(function (n) { cv.addEventListener(n, function () { drag = false; }); });
    $('simMass').addEventListener('input', function () { R = parseFloat(this.value); draw(); });
    $('simReset').addEventListener('click', function () { lens.x = W / 2; lens.y = H / 2; user = false; draw(); });
    function loop() {
      if (!user && !reduce && document.visibilityState === 'visible') { tick += 0.012; lens.x = W / 2 + Math.cos(tick) * W * 0.3; lens.y = H / 2 + Math.sin(tick * 1.3) * H * 0.22; draw(); }
      requestAnimationFrame(loop);
    }
    draw(); if (!reduce) loop();
  }

  document.addEventListener('DOMContentLoaded', function () {
    if ($('cMass')) {
      ['cMass', 'cUnit'].forEach(function (id) { $(id).addEventListener('input', calc); });
      document.querySelectorAll('[data-v]').forEach(function (b) { b.addEventListener('click', function () { preset(b); }); });
      calc();
    }
    if ($('dMass')) {
      ['dMass', 'dX'].forEach(function (id) { $(id).addEventListener('input', dil); });
      document.querySelectorAll('[data-x]').forEach(function (b) { b.addEventListener('click', function () { dpreset(b); }); });
      dil();
    }
    sim();
  });
})();
