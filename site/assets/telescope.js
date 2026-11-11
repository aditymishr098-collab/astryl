/* Telescope and eyepiece simulator: magnification, true field of view, exit pupil and a picture of what fits in the eyepiece. */
(function () {
  var cv = document.getElementById('tsCv'); if (!cv) return;
  var ctx = cv.getContext('2d');
  function $(id) { return document.getElementById(id); }
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + hi + '</span>'; }
  function num(x, d) { return (+x).toLocaleString('en-US', { maximumFractionDigits: d === undefined ? 1 : d }); }
  // apparent sizes in arcminutes (typical)
  var TARGETS = {
    moon: { size: 31, en: 'The Moon', hi: 'चाँद' },
    jupiter: { size: 0.75, en: 'Jupiter and its moons', hi: 'बृहस्पति और उसके चाँद' },
    saturn: { size: 0.7, en: 'Saturn and its rings', hi: 'शनि और उसके छल्ले' },
    mars: { size: 0.25, en: 'Mars (close approach)', hi: 'मंगल (सबसे पास होने पर)' },
    orion: { size: 65, en: 'Orion Nebula (M42)', hi: 'ओरायन नीहारिका (M42)' },
    pleiades: { size: 110, en: 'Pleiades (M45)', hi: 'कृत्तिका (M45)' },
    andromeda: { size: 190, en: 'Andromeda Galaxy (M31)', hi: 'एंड्रोमेडा galaxy (M31)' }
  };

  function vals() {
    var D = Math.max(20, +$('tsAp').value || 0), F = Math.max(100, +$('tsFl').value || 0), e = Math.max(2, +$('tsEp').value || 0), a = Math.max(30, Math.min(110, +$('tsAf').value || 52)), bar = $('tsBar').checked ? 2 : 1;
    var mag = F * bar / e, tfov = a / mag * 60, exit = D / mag, maxMag = 2 * D, lim = 2.7 + 5 * Math.log10(D), res = 116 / D;
    return { D: D, F: F, e: e, a: a, bar: bar, mag: mag, tfov: tfov, exit: exit, maxMag: maxMag, lim: lim, res: res, fr: F / D };
  }

  function stats(v) {
    var warn = '';
    if (v.mag > v.maxMag) warn = '⚠️ ' + bi('Too much magnification: above about ' + num(v.maxMag, 0) + '× this telescope only shows a bigger blur. Use a longer eyepiece.', 'बहुत ज़्यादा ज़ूम: लगभग ' + num(v.maxMag, 0) + '× से ऊपर यह telescope सिर्फ़ बड़ा धुंधलापन दिखाता है। लंबा eyepiece लगाइए।');
    else if (v.exit > 7) warn = '⚠️ ' + bi('Exit pupil above 7 mm: more light than your eye can take in, so some is wasted. Use a shorter eyepiece.', 'Exit pupil 7 mm से ज़्यादा: आँख जितनी रोशनी ले सकती है उससे ज़्यादा, कुछ बेकार जाती है। छोटा eyepiece लगाइए।');
    $('tsStats').innerHTML = '<div class="stats">' +
      '<div class="stat"><b>' + num(v.mag, 0) + '×</b><span>' + bi('Magnification', 'आवर्धन (ज़ूम)') + '</span></div>' +
      '<div class="stat"><b>' + (v.tfov >= 60 ? num(v.tfov / 60, 2) + '°' : num(v.tfov, 1) + '′') + '</b><span>' + bi('True field of view', 'असली दृश्य-क्षेत्र') + '</span></div>' +
      '<div class="stat"><b>' + num(v.exit, 1) + ' mm</b><span>' + bi('Exit pupil', 'Exit pupil') + '</span></div>' +
      '<div class="stat"><b>' + num(v.maxMag, 0) + '×</b><span>' + bi('Highest useful magnification', 'सबसे ज़्यादा काम का ज़ूम') + '</span></div>' +
      '<div class="stat"><b>' + num(v.lim, 1) + '</b><span>' + bi('Faintest star (magnitude)', 'सबसे धुंधला तारा (magnitude)') + '</span></div>' +
      '<div class="stat"><b>' + num(v.res, 2) + '″</b><span>' + bi('Finest detail', 'सबसे बारीक detail') + '</span></div>' +
      '<div class="stat"><b>f/' + num(v.fr, 1) + '</b><span>' + bi('Focal ratio', 'Focal ratio') + '</span></div></div>' + (warn ? '<p class="no">' + warn + '</p>' : '');
  }

  function rnd(seed) { var s = seed; return function () { s = (s * 16807) % 2147483647; return s / 2147483647; }; }

  function draw() {
    var v = vals(), t = $('tsTarget').value, T = TARGETS[t], dpr = Math.min(window.devicePixelRatio || 1, 2), W = cv.clientWidth || 320;
    cv.width = W * dpr; cv.height = W * dpr; ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    var R = W / 2 - 6, cx = W / 2, cy = W / 2, k = (2 * R) / v.tfov; // pixels per arcminute
    ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, W);
    ctx.save(); ctx.beginPath(); ctx.arc(cx, cy, R, 0, 7); ctx.clip();
    ctx.fillStyle = '#04060c'; ctx.fillRect(0, 0, W, W);
    // background stars: more with a bigger telescope
    var r = rnd(7), n = Math.min(400, Math.round(30 * Math.pow(10, (v.lim - 9) * 0.25) * v.tfov / 60));
    for (var i = 0; i < n; i++) { ctx.fillStyle = 'rgba(220,228,255,' + (0.3 + r() * 0.6).toFixed(2) + ')'; ctx.fillRect(r() * W, r() * W, 1.2, 1.2); }
    var blur = v.mag > v.maxMag ? Math.min(8, (v.mag / v.maxMag - 1) * 6) : 0;
    ctx.filter = blur ? 'blur(' + blur.toFixed(1) + 'px)' : 'none';
    var s = T.size * k / 2; // radius in px
    if (t === 'moon') {
      ctx.fillStyle = '#d9d3bf'; ctx.beginPath(); ctx.arc(cx, cy, s, 0, 7); ctx.fill();
      var rc = rnd(3); for (var c = 0; c < 70; c++) { var a = rc() * 6.283, d = Math.sqrt(rc()) * s * 0.95, cr = s * (0.02 + rc() * 0.07); ctx.fillStyle = 'rgba(120,112,95,' + (0.25 + rc() * 0.35).toFixed(2) + ')'; ctx.beginPath(); ctx.arc(cx + Math.cos(a) * d, cy + Math.sin(a) * d, cr, 0, 7); ctx.fill(); }
      ctx.fillStyle = 'rgba(4,6,12,0.88)'; ctx.beginPath(); ctx.arc(cx, cy, s + 1, Math.PI / 2, Math.PI * 1.5); ctx.ellipse(cx, cy, s * 0.35, s + 1, 0, Math.PI * 1.5, Math.PI / 2, true); ctx.fill();
    } else if (t === 'jupiter') {
      var jr = Math.max(1.5, 0.37 * k / 2 * 1.0); // disc ~44 arcsec wide
      jr = Math.max(1.5, (44 / 60) * k / 2);
      ctx.fillStyle = '#e8d6b4'; ctx.beginPath(); ctx.arc(cx, cy, jr, 0, 7); ctx.fill();
      if (jr > 6) { ctx.fillStyle = 'rgba(160,110,70,.6)'; ctx.fillRect(cx - jr, cy - jr * 0.28, jr * 2, jr * 0.16); ctx.fillRect(cx - jr, cy + jr * 0.12, jr * 2, jr * 0.16); }
      [[-7.5, 0], [-4.4, 0.05], [3.0, -0.05], [12.5, 0.1]].forEach(function (m) { ctx.fillStyle = '#f4f0e0'; ctx.beginPath(); ctx.arc(cx + m[0] * k, cy + m[1] * k, Math.max(1, jr * 0.07), 0, 7); ctx.fill(); });
    } else if (t === 'saturn') {
      var sr = Math.max(1.2, (18 / 60) * k / 2);
      ctx.strokeStyle = '#d8c79d'; ctx.lineWidth = Math.max(1, sr * 0.35); ctx.beginPath(); ctx.ellipse(cx, cy, sr * 2.3, sr * 0.75, -0.25, 0, 7); ctx.stroke();
      ctx.fillStyle = '#e6d39f'; ctx.beginPath(); ctx.arc(cx, cy, sr, 0, 7); ctx.fill();
      ctx.fillStyle = '#f4f0e0'; ctx.beginPath(); ctx.arc(cx + 3.2 * k, cy - 0.3 * k, Math.max(1, sr * 0.12), 0, 7); ctx.fill();
    } else if (t === 'mars') {
      var mr = Math.max(1.2, (15 / 60) * k / 2);
      ctx.fillStyle = '#d7774a'; ctx.beginPath(); ctx.arc(cx, cy, mr, 0, 7); ctx.fill();
      if (mr > 5) { ctx.fillStyle = '#fff'; ctx.beginPath(); ctx.arc(cx, cy - mr * 0.8, mr * 0.22, 0, 7); ctx.fill(); }
    } else if (t === 'orion') {
      var g = ctx.createRadialGradient(cx, cy, 0, cx, cy, s); g.addColorStop(0, 'rgba(170,220,200,.75)'); g.addColorStop(0.5, 'rgba(110,160,170,.35)'); g.addColorStop(1, 'rgba(60,80,120,0)');
      ctx.fillStyle = g; ctx.beginPath(); ctx.ellipse(cx, cy, s, s * 0.85, 0.4, 0, 7); ctx.fill();
      [[0, 0], [0.12, 0.05], [-0.08, 0.1], [0.05, -0.12]].forEach(function (p) { ctx.fillStyle = '#fff'; ctx.beginPath(); ctx.arc(cx + p[0] * s * 0.2, cy + p[1] * s * 0.2, 1.4, 0, 7); ctx.fill(); });
    } else if (t === 'pleiades') {
      [[0, 0, 2.9], [-0.42, -0.25, 3.6], [0.35, 0.18, 3.7], [-0.15, 0.38, 3.9], [0.55, -0.3, 4.2], [-0.62, 0.15, 4.3], [0.1, -0.5, 5.1], [0.6, 0.45, 5.4], [-0.3, -0.6, 5.6]].forEach(function (p) {
        var rr = Math.max(1, 3.6 - 0.5 * p[2]); ctx.fillStyle = '#cfe0ff'; ctx.beginPath(); ctx.arc(cx + p[0] * s, cy + p[1] * s, rr, 0, 7); ctx.fill();
      });
    } else if (t === 'andromeda') {
      var ga = ctx.createRadialGradient(cx, cy, 0, cx, cy, s); ga.addColorStop(0, 'rgba(255,240,215,.85)'); ga.addColorStop(0.15, 'rgba(230,220,200,.45)'); ga.addColorStop(1, 'rgba(120,120,150,0)');
      ctx.save(); ctx.translate(cx, cy); ctx.rotate(-0.6); ctx.scale(1, 0.32); ctx.fillStyle = ga; ctx.beginPath(); ctx.arc(0, 0, s, 0, 7); ctx.fill(); ctx.restore();
    }
    ctx.filter = 'none'; ctx.restore();
    ctx.strokeStyle = '#3a4560'; ctx.lineWidth = 3; ctx.beginPath(); ctx.arc(cx, cy, R, 0, 7); ctx.stroke();
    var fits = T.size <= v.tfov;
    $('tsFit').innerHTML = fits ? '✅ ' + bi(T.en + ' fits in this field of view.', T.hi + ' इस दृश्य-क्षेत्र में पूरा आ जाता है।') : '↔️ ' + bi(T.en + ' is bigger than this field of view: you see only part of it. Try a longer eyepiece.', T.hi + ' इस दृश्य-क्षेत्र से बड़ा है: आपको इसका एक हिस्सा दिखता है। लंबा eyepiece आज़माइए।');
    stats(v);
  }

  $('tsScope').addEventListener('change', function () { var p = this.value.split(','); if (p.length === 2) { $('tsAp').value = p[0]; $('tsFl').value = p[1]; } draw(); });
  $('tsEyeP').addEventListener('change', function () { var p = this.value.split(','); if (p.length === 2) { $('tsEp').value = p[0]; $('tsAf').value = p[1]; } draw(); });
  ['tsAp', 'tsFl', 'tsEp', 'tsAf', 'tsBar', 'tsTarget'].forEach(function (id) { $(id).addEventListener('input', draw); $(id).addEventListener('change', draw); });
  window.addEventListener('resize', draw);
  draw();
})();
