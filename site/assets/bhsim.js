/* Black hole animations for the black hole pages.
   #bhSim   a live black hole: light rays are traced through the curved space of a Schwarzschild
            black hole (once, when the view changes), then the hot disk turns in real time.
            The far side of the disk shows up above and below the shadow, as in real simulations.
   #bhFall  falling in: the astronaut's own clock next to the clock of someone watching from far away.
   #bhForm  how a heavy star becomes a black hole, step by step.
   Units: the black hole's mass M = 1, so the event horizon is at r = 2. */
(function () {
  var reduce = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;
  function hi() { return document.documentElement.lang === 'hi'; }
  function T(en, h) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + h + '</span>'; }
  function visible(el, cb) {
    if (!('IntersectionObserver' in window)) { cb(true); return; }
    new IntersectionObserver(function (es) { es.forEach(function (e) { cb(e.isIntersecting); }); }, { rootMargin: '100px' }).observe(el);
  }

  /* ------------------------------------------------------------ live black hole */
  function sim(box) {
    box.innerHTML = '<div class="bhstage"><canvas aria-label="Animated black hole with its glowing disk"></canvas></div>' +
      '<div class="bhctl"><button type="button" class="btn" data-a="play"></button>' +
      '<label class="bhtilt">' + T('View from above the disk', 'Disk के ऊपर से देखने का कोण') + ' <input type="range" min="2" max="60" value="9" aria-label="Viewing angle"><b></b></label></div>' +
      '<p class="note">' + T('Light from the far side of the disk is bent over the top and under the bottom of the black hole. The side turning towards you looks brighter. Worked out with real gravity, not drawn by hand.', 'Disk के पीछे वाले हिस्से की रोशनी मुड़कर ब्लैक होल के ऊपर और नीचे से दिखती है। जो हिस्सा आपकी ओर घूम रहा है वह ज़्यादा चमकीला दिखता है। यह असली gravity से गिना गया है, हाथ से बनाया नहीं।') + '</p>';
    var cv = box.querySelector('canvas'), ctx = cv.getContext('2d'), tilt = box.querySelector('input'), tiltV = box.querySelector('.bhtilt b');
    var small = Math.min(window.innerWidth, 900) < 600;
    var W = small ? 240 : 330, H = Math.round(W * 0.56);
    var off = document.createElement('canvas'); off.width = W; off.height = H;
    var octx = off.getContext('2d'), img = octx.createImageData(W, H), px = img.data;
    var N = W * H, R1 = new Float32Array(N), A1 = new Float32Array(N), R2 = new Float32Array(N), A2 = new Float32Array(N), BG = new Float32Array(N);
    var RIN = 6, ROUT = 18, FOV = 24; // disk from the last stable orbit (6 M) out to 18 M; half width of the view in M
    // a ring texture: streaks of brighter and darker gas
    var TW = 256, TH = 64, tex = new Float32Array(TW * TH);
    (function () {
      var s = 7; function r() { s = (s * 16807) % 2147483647; return s / 2147483647; }
      for (var k = 0; k < 90; k++) {
        var cy = r() * TH, cx = r() * TW, len = 20 + r() * 120, amp = 0.25 + r() * 0.6, wid = 0.6 + r() * 2.2;
        for (var y = 0; y < TH; y++) for (var dx = 0; dx < len; dx++) {
          var x = Math.floor(cx + dx) % TW, d = (y - cy) / wid, f = Math.exp(-d * d) * Math.sin(Math.PI * dx / len);
          tex[y * TW + x] += amp * f;
        }
      }
      for (var i = 0; i < tex.length; i++) tex[i] = 0.55 + Math.min(1.4, tex[i]) * 0.6;
    })();
    function trace(elev) {
      var th = elev * Math.PI / 180, cz = Math.sin(th), cyy = -Math.cos(th); // direction from black hole to camera
      var D = 60, h = 0.02;
      for (var j = 0; j < H; j++) for (var i = 0; i < W; i++) {
        var k = j * W + i;
        var x = (i + 0.5 - W / 2) / (W / 2) * FOV, y = -(j + 0.5 - H / 2) / (W / 2) * FOV;
        var b = Math.sqrt(x * x + y * y) || 1e-6;
        // e2: the direction of the pixel in the picture, in 3D
        var e2x = x / b, e2y = y / b * Math.sin(th), e2z = y / b * Math.cos(th);
        var u = 1 / D, w = Math.sqrt(Math.max(0, 1 / (b * b) - u * u * (1 - 2 * u))), phi = 0;
        var zPrev = cz, n = 0, hits = 0;
        R1[k] = 0; R2[k] = 0; BG[k] = -1;
        for (var s = 0; s < 3000; s++) {
          // RK4 for u'' = -u + 3u^2 (light in Schwarzschild space, M = 1)
          var k1u = w, k1w = -u + 3 * u * u;
          var u2 = u + h / 2 * k1u, w2 = w + h / 2 * k1w, k2u = w2, k2w = -u2 + 3 * u2 * u2;
          var u3 = u + h / 2 * k2u, w3 = w + h / 2 * k2w, k3u = w3, k3w = -u3 + 3 * u3 * u3;
          var u4 = u + h * k3u, w4 = w + h * k3w, k4u = w4, k4w = -u4 + 3 * u4 * u4;
          var un = u + h / 6 * (k1u + 2 * k2u + 2 * k3u + k4u), wn = w + h / 6 * (k1w + 2 * k2w + 2 * k3w + k4w);
          var phin = phi + h;
          var zn = Math.cos(phin) * cz + Math.sin(phin) * e2z;
          if (zn * zPrev < 0 && hits < 2) {
            var f = zPrev / (zPrev - zn), pc = phi + f * h, uc = u + f * (un - u), r = 1 / uc;
            if (r > RIN && r < ROUT) {
              var px3 = Math.sin(pc) * e2x, py3 = Math.cos(pc) * cyy + Math.sin(pc) * e2y;
              if (hits === 0) { R1[k] = r; A1[k] = Math.atan2(py3, px3); } else { R2[k] = r; A2[k] = Math.atan2(py3, px3); }
              hits++;
            }
          }
          u = un; w = wn; phi = phin; zPrev = zn;
          if (u > 0.5) { n = 1; break; } // fell into the horizon
          if (u < 1 / D && w < 0) { BG[k] = phi; break; } // flew away
        }
        if (n) BG[k] = -2;
      }
    }
    function star(x, y) { // a fixed random star field
      var gx = Math.floor(x * 2.2), gy = Math.floor(y * 2.2), hsh = Math.sin(gx * 127.1 + gy * 311.7) * 43758.5453;
      hsh -= Math.floor(hsh); return hsh > 0.985 ? (hsh - 0.985) * 66 : 0;
    }
    var bgCol = new Float32Array(N);
    function background() {
      for (var j = 0; j < H; j++) for (var i = 0; i < W; i++) {
        var k = j * W + i;
        if (BG[k] < 0) { bgCol[k] = 0; continue; }
        var x = (i + 0.5 - W / 2) / (W / 2) * FOV, y = -(j + 0.5 - H / 2) / (W / 2) * FOV, b2 = x * x + y * y;
        var m = 1 - 40 / Math.max(b2, 1); // lens: stars are pushed out around the shadow
        bgCol[k] = star(x * m + 40, y * m + 40);
      }
    }
    var elev = 9, t = 0, playing = !reduce, last = 0, on = true, dirty = true;
    function color(r, a, time, front) {
      var om = Math.pow(r, -1.5), ta = a - om * time;
      var tx = ((ta / (2 * Math.PI)) % 1 + 1) % 1, ty = (r - RIN) / (ROUT - RIN);
      var tv = tex[Math.floor(ty * (TH - 1)) * TW + Math.floor(tx * (TW - 1))];
      var temp = Math.pow(RIN / r, 0.75) * Math.pow(Math.max(0, 1 - Math.sqrt(RIN / r)) + 0.02, 0.25) * 1.9;
      // the gas moves anticlockwise seen from above: the side coming towards the camera is brighter
      var v = 1 / Math.sqrt(r - 2), los = -Math.cos(a) * Math.cos(elev * Math.PI / 180) * v;
      var g = Math.sqrt(1 - 3 / r) / (1 - los);
      var I = temp * tv * Math.pow(g, 3) * (front ? 1 : 0.75);
      I *= Math.min(1, (ROUT - r) / 4); // soft outer edge
      return I;
    }
    function paint() {
      for (var k = 0; k < N; k++) {
        var I = 0;
        if (R1[k]) I += color(R1[k], A1[k], t, true);
        if (R2[k]) I += color(R2[k], A2[k], t, false) * 0.5;
        var o = k * 4, s = bgCol[k] * 120;
        // hot gas colours: deep red to orange to white
        var rr = Math.min(255, I * 360), gg = Math.min(255, Math.pow(I, 1.35) * 250), bb = Math.min(255, Math.pow(I, 2.4) * 190);
        px[o] = Math.min(255, rr + s); px[o + 1] = Math.min(255, gg + s); px[o + 2] = Math.min(255, bb + s * 1.1); px[o + 3] = 255;
      }
      octx.putImageData(img, 0, 0);
      var cw = cv.clientWidth, chh = Math.round(cw * H / W), dpr = Math.min(2, window.devicePixelRatio || 1);
      if (cv.width !== Math.round(cw * dpr)) { cv.width = Math.round(cw * dpr); cv.height = Math.round(chh * dpr); }
      ctx.imageSmoothingEnabled = true; ctx.imageSmoothingQuality = 'high';
      ctx.globalCompositeOperation = 'source-over';
      ctx.drawImage(off, 0, 0, cv.width, cv.height);
      // a soft glow on top
      ctx.globalCompositeOperation = 'lighter'; ctx.globalAlpha = 0.35; ctx.filter = 'blur(' + Math.round(cv.width / 90) + 'px)';
      ctx.drawImage(off, 0, 0, cv.width, cv.height);
      ctx.filter = 'none'; ctx.globalAlpha = 1; ctx.globalCompositeOperation = 'source-over';
    }
    function rebuild() { trace(elev); background(); dirty = false; paint(); }
    function loop(now) {
      if (on && playing) { if (last) t += Math.min(0.05, (now - last) / 1000) * 22; paint(); }
      last = now; requestAnimationFrame(loop);
    }
    var tm = null;
    tilt.oninput = function () { elev = +tilt.value; tiltV.textContent = elev + '°'; clearTimeout(tm); tm = setTimeout(rebuild, 120); };
    tiltV.textContent = elev + '°';
    var pb = box.querySelector('[data-a=play]');
    function pbl() { pb.innerHTML = playing ? '❚❚ ' + T('Pause', 'रोकें') : '▶ ' + T('Play', 'चलाएँ'); }
    pb.onclick = function () { playing = !playing; pbl(); };
    pbl();
    visible(box, function (v) { on = v; if (v && dirty) rebuild(); });
    window.addEventListener('resize', function () { paint(); });
    requestAnimationFrame(loop);
  }

  /* ------------------------------------------------------------ falling in */
  function fall(box) {
    var kinds = { small: { en: 'A 10-Sun black hole', hi: '10 सूरज वाला ब्लैक होल', rip: 3.2, horizonKm: 30 }, big: { en: 'Sagittarius A* (4.3 million Suns)', hi: 'Sagittarius A* (43 लाख सूरज)', rip: 0.25, horizonKm: 12.7e6 } };
    box.innerHTML = '<div class="tabs" role="tablist"><button type="button" class="on" data-k="small">' + T(kinds.small.en, kinds.small.hi) + '</button><button type="button" data-k="big">' + T(kinds.big.en, kinds.big.hi) + '</button></div>' +
      '<div class="bhfall"><figure><canvas data-v="me"></canvas><figcaption>' + T('What the astronaut sees and feels', 'यात्री को क्या दिखता और महसूस होता है') + '<br><b data-c="me"></b></figcaption></figure>' +
      '<figure><canvas data-v="far"></canvas><figcaption>' + T('What a friend far away sees', 'दूर बैठे दोस्त को क्या दिखता है') + '<br><b data-c="far"></b></figcaption></figure></div>' +
      '<div class="bhctl"><button type="button" class="btn primary" data-a="go">▶ ' + T('Fall in', 'अंदर गिरें') + '</button><span class="note" data-s></span></div>' +
      '<p class="note">' + T('A drawing to show the idea, worked out from Einstein\'s equations for a fall that starts at rest 5 horizon-sizes away. The far-away friend never sees the astronaut cross: the picture slows, turns red and fades.', 'विचार दिखाने के लिए चित्र, Einstein के समीकरणों से गिना हुआ, जिसमें गिरना horizon से 5 गुना दूरी पर रुकी हालत से शुरू होता है। दूर बैठा दोस्त यात्री को कभी पार होते नहीं देखता: तस्वीर धीमी होती है, लाल पड़ती है और धुँधली हो जाती है।') + '</p>';
    var kind = 'small', run = false, t0 = 0;
    var cvs = { me: box.querySelector('[data-v=me]'), far: box.querySelector('[data-v=far]') };
    // radial fall from rest at r0 (in horizon units, horizon = 1): proper time tau and far-away time t
    var r0 = 5, tab = [];
    (function () {
      var M = 0.5, E = Math.sqrt(1 - 1 / r0), tF = 0;
      for (var e = 0; e <= Math.PI; e += Math.PI / 4000) {
        var r = r0 / 2 * (1 + Math.cos(e)), tau = Math.sqrt(r0 * r0 * r0 / (8 * M)) * (e + Math.sin(e));
        if (tab.length) {
          var p = tab[tab.length - 1], dtau = tau - p.tau;
          if (r > 1.0005) tF += dtau * E / (1 - 1 / r); else tF = Infinity;
        }
        tab.push({ r: r, tau: tau, t: tF });
      }
    })();
    var TAU_END = tab[tab.length - 1].tau, TAU_H = 0;
    for (var q = 0; q < tab.length; q++) if (tab[q].r <= 1) { TAU_H = tab[q].tau; break; }
    function atTau(tau) { var lo = 0, hi2 = tab.length - 1; while (hi2 - lo > 1) { var m = (lo + hi2) >> 1; if (tab[m].tau < tau) lo = m; else hi2 = m; } return tab[lo]; }
    function atT(t) { for (var i = 1; i < tab.length; i++) if (tab[i].t >= t) return tab[i - 1]; return tab[tab.length - 1]; }
    function setup(c) { var w = c.clientWidth, dpr = Math.min(2, window.devicePixelRatio || 1); if (c.width !== Math.round(w * dpr)) { c.width = Math.round(w * dpr); c.height = Math.round(w * 0.75 * dpr); } return c.getContext('2d'); }
    function scene(c, r, opts) {
      var g = setup(c), W = c.width, H = c.height, cx = W / 2, cy = H * 0.5, sc = H * 0.4 / r0;
      g.fillStyle = '#03050b'; g.fillRect(0, 0, W, H);
      for (var i = 0; i < 60; i++) { var sx = (Math.sin(i * 91.7) * 0.5 + 0.5) * W, sy = (Math.sin(i * 47.3) * 0.5 + 0.5) * H; g.fillStyle = 'rgba(255,255,255,' + (0.25 + (i % 5) * 0.12) + ')'; g.fillRect(sx, sy, 1.5, 1.5); }
      // the black hole: shadow, photon ring, horizon
      var hr = sc * 1, bx = cx - H * 0.05, by = cy + H * 0.33;
      var glow = g.createRadialGradient(bx, by, hr * 1.2, bx, by, hr * 3.4); glow.addColorStop(0, 'rgba(255,160,60,.55)'); glow.addColorStop(1, 'rgba(255,120,30,0)');
      g.fillStyle = glow; g.beginPath(); g.arc(bx, by, hr * 3.4, 0, 7); g.fill();
      g.fillStyle = '#000'; g.beginPath(); g.arc(bx, by, hr * 1.3, 0, 7); g.fill();
      g.strokeStyle = 'rgba(255,215,160,.8)'; g.lineWidth = Math.max(1, W / 300); g.beginPath(); g.arc(bx, by, hr * 1.3, 0, 7); g.stroke();
      g.setLineDash([4, 5]); g.strokeStyle = 'rgba(160,190,255,.6)'; g.beginPath(); g.arc(bx, by, hr, 0, 7); g.stroke(); g.setLineDash([]);
      // the astronaut: a small capsule falling straight down onto the hole
      if (opts.gone) return;
      var ay = by - r * sc, stretch = opts.stretch, len = W * 0.035 * stretch, wid = W * 0.022 / Math.sqrt(stretch);
      g.save(); g.globalAlpha = opts.alpha;
      g.fillStyle = opts.col; g.beginPath();
      g.ellipse(bx, ay - len / 2, wid, len / 2 + wid * 0.4, 0, 0, 7); g.fill();
      g.fillStyle = 'rgba(160,220,255,' + 0.9 * opts.alpha + ')'; g.beginPath(); g.arc(bx, ay - len * 0.75, wid * 0.5, 0, 7); g.fill();
      g.restore();
    }
    function clock(s) { var m = Math.floor(s / 60), x = Math.floor(s % 60); return (m < 10 ? '0' : '') + m + ':' + (x < 10 ? '0' : '') + x; }
    function frame(now) {
      var k = kinds[kind];
      var el = run ? (now - t0) / 1000 : 0, tau = el * 1.6; // the astronaut's clock (seconds of animation)
      var S = TAU_END / 9; // 9 seconds of animation from the start to the centre
      var tauU = Math.min(tau / 1.6 / 9 * TAU_END, TAU_END), p = atTau(tauU);
      var stretch = Math.min(6, 1 + Math.pow(k.rip / Math.max(p.r, 0.05), 3) * 0.6);
      var ripped = p.r < k.rip * 0.6 && kind === 'small';
      scene(cvs.me, p.r, { stretch: stretch, alpha: 1, col: ripped ? '#ff9f6b' : '#e9eef7', gone: tauU >= TAU_END });
      var meTxt;
      if (tauU >= TAU_END) meTxt = T('Reached the centre', 'केंद्र तक पहुँचा');
      else if (p.r <= 1) meTxt = T('Inside: no way back', 'अंदर: वापसी नहीं');
      else if (ripped) meTxt = T('Stretched apart before the horizon', 'horizon से पहले ही खिंचकर टूटा');
      else meTxt = T('Distance: ', 'दूरी: ') + (p.r).toFixed(2) + T(' horizons', ' horizon');
      box.querySelector('[data-c=me]').innerHTML = '⏱ ' + clock(tauU / S * 10) + ' · ' + meTxt;
      // far-away view: the same animation seconds, but in far-away time
      var tFar = tauU, pf = atT(tFar), red = Math.sqrt(Math.max(0, 1 - 1 / pf.r));
      var col = 'rgb(' + Math.round(233) + ',' + Math.round(80 + 158 * red) + ',' + Math.round(60 + 187 * red * red) + ')';
      scene(cvs.far, pf.r, { stretch: 1, alpha: Math.max(0.04, Math.pow(red, 0.8)), col: col });
      var slow = red > 0.001 ? (1 / red) : Infinity;
      box.querySelector('[data-c=far]').innerHTML = '⏱ ' + clock(pf.tau / S * 10) + ' · ' + (slow > 50 ? T('almost frozen, very red', 'लगभग जमा हुआ, बहुत लाल') : T('clock looks ', 'घड़ी ') + slow.toFixed(1) + T('× slower', '× धीमी दिखती'));
      box.querySelector('[data-s]').innerHTML = kind === 'small' ? T('Horizon: about 60 km across. The pull on feet and head differs so much that a person is torn apart before reaching it.', 'Horizon: लगभग 60 km चौड़ा। पैरों और सिर पर खिंचाव में इतना फ़र्क है कि इंसान उस तक पहुँचने से पहले टूट जाता है।') : T('Horizon: about 25 million km across. Crossing it feels like nothing at all; the stretching only comes much deeper.', 'Horizon: लगभग 2.5 करोड़ km चौड़ा। इसे पार करना कुछ महसूस नहीं होता; खिंचाव बहुत गहराई में जाकर आता है।');
      if (run && tauU >= TAU_END && el > 12) run = false;
      if (run) requestAnimationFrame(frame);
    }
    box.querySelector('[data-a=go]').onclick = function () { run = true; t0 = performance.now(); requestAnimationFrame(frame); };
    box.querySelectorAll('[data-k]').forEach(function (b) { b.onclick = function () { kind = b.dataset.k; box.querySelectorAll('[data-k]').forEach(function (x) { x.classList.toggle('on', x === b); }); run = false; frame(performance.now()); }; });
    window.addEventListener('resize', function () { if (!run) frame(performance.now()); });
    frame(performance.now());
  }

  /* ------------------------------------------------------------ how a star becomes a black hole */
  function form(box) {
    var steps = [
      ['A star more than about 20 times heavier than the Sun burns its fuel fast, in a few million years.', 'सूरज से लगभग 20 गुना से ज़्यादा भारी तारा अपना ईंधन तेज़ी से, कुछ लाख साल में जला देता है।'],
      ['It makes heavier and heavier elements in its core, until the core is iron. Iron gives no more energy.', 'यह अपने केंद्र में भारी से भारी तत्व बनाता है, जब तक केंद्र लोहा न बन जाए। लोहे से और ऊर्जा नहीं मिलती।'],
      ['With nothing holding it up, the core collapses in less than a second.', 'सहारा न रहने पर केंद्र एक सेकंड से भी कम में ढह जाता है।'],
      ['The outer layers blast away in a supernova, for a while brighter than a whole galaxy. (Some very heavy stars may collapse with no big explosion.)', 'बाहरी परतें supernova में उड़ जाती हैं, कुछ समय के लिए पूरी galaxy से ज़्यादा चमकीली। (कुछ बहुत भारी तारे शायद बिना बड़े धमाके के ही ढह जाते हैं।)'],
      ['The squeezed core is so heavy that nothing can stop it: a black hole is born, a few to tens of times the Sun\'s mass.', 'दबा हुआ केंद्र इतना भारी है कि कुछ उसे रोक नहीं सकता: एक ब्लैक होल जन्म लेता है, सूरज से कुछ से लेकर दसियों गुना भारी।']
    ];
    box.innerHTML = '<canvas aria-label="A heavy star turning into a black hole"></canvas><p class="bhstep"></p><div class="bhctl"><button type="button" class="btn" data-a="prev">‹</button><span class="bhdots"></span><button type="button" class="btn" data-a="next">›</button><button type="button" class="btn primary" data-a="play">▶ ' + T('Play', 'चलाएँ') + '</button></div>';
    var cv = box.querySelector('canvas'), st = 0, t = 0, auto = false, last = 0, on = true;
    var dots = box.querySelector('.bhdots');
    dots.innerHTML = steps.map(function (_, i) { return '<i data-i="' + i + '"></i>'; }).join('');
    function show() {
      box.querySelector('.bhstep').innerHTML = '<b>' + (st + 1) + '/5</b> ' + T(steps[st][0], steps[st][1]);
      dots.querySelectorAll('i').forEach(function (d, i) { d.classList.toggle('on', i === st); });
      t = 0;
    }
    var parts = []; for (var i = 0; i < 160; i++) parts.push({ a: Math.random() * 6.283, v: 0.5 + Math.random(), s: 0.5 + Math.random() * 1.5 });
    function draw(dt) {
      var dpr = Math.min(2, window.devicePixelRatio || 1), w = cv.clientWidth;
      if (cv.width !== Math.round(w * dpr)) { cv.width = Math.round(w * dpr); cv.height = Math.round(w * 0.5 * dpr); }
      var g = cv.getContext('2d'), W = cv.width, H = cv.height, cx = W / 2, cy = H / 2, R = H * 0.36;
      t += dt;
      g.fillStyle = '#03050b'; g.fillRect(0, 0, W, H);
      for (var k = 0; k < 70; k++) { g.fillStyle = 'rgba(255,255,255,.5)'; g.fillRect((Math.sin(k * 12.9) * 0.5 + 0.5) * W, (Math.sin(k * 78.2) * 0.5 + 0.5) * H, 1.4, 1.4); }
      function ball(r, c1, c2, glowA) {
        var gr = g.createRadialGradient(cx, cy, r * 0.2, cx, cy, r * (1 + glowA)); gr.addColorStop(0, c1); gr.addColorStop(1 / (1 + glowA), c2); gr.addColorStop(1, 'rgba(0,0,0,0)');
        g.fillStyle = gr; g.beginPath(); g.arc(cx, cy, r * (1 + glowA), 0, 7); g.fill();
      }
      var pulse = 1 + Math.sin(t * 2) * 0.015;
      if (st === 0) ball(R * pulse, '#f4f8ff', '#7fa8ff', 0.5);
      else if (st === 1) {
        ball(R * pulse, '#ffd9a8', '#ff8a3d', 0.4);
        var lay = [['#ffe9a0', .75], ['#ffb46a', .55], ['#e06a3a', .38], ['#9a9aa8', .2]];
        lay.forEach(function (l) { g.fillStyle = l[0]; g.globalAlpha = 0.55; g.beginPath(); g.arc(cx, cy, R * l[1], 0, 7); g.fill(); });
        g.globalAlpha = 1; g.fillStyle = '#ddd'; g.font = Math.round(H * 0.05) + 'px DM Sans,sans-serif'; g.textAlign = 'center'; g.fillText('Fe', cx, cy + H * 0.018);
      } else if (st === 2) {
        var f = Math.min(1, t / 1.2), rc = R * 0.2 * (1 - f * 0.85);
        ball(R, 'rgba(255,170,90,.6)', 'rgba(255,110,50,.35)', 0.35);
        g.fillStyle = '#c9cbd6'; g.beginPath(); g.arc(cx, cy, Math.max(2, rc), 0, 7); g.fill();
        for (var a = 0; a < 16; a++) { var an = a / 16 * 6.283; g.strokeStyle = 'rgba(200,220,255,.5)'; g.beginPath(); g.moveTo(cx + Math.cos(an) * R * 0.5, cy + Math.sin(an) * R * 0.5); g.lineTo(cx + Math.cos(an) * R * (0.5 - 0.25 * f), cy + Math.sin(an) * R * (0.5 - 0.25 * f)); g.stroke(); }
      } else if (st === 3) {
        var e = Math.min(1, t / 2.5), flash = Math.max(0, 1 - t / 0.6);
        if (flash > 0) { g.fillStyle = 'rgba(255,255,255,' + flash + ')'; g.fillRect(0, 0, W, H); }
        parts.forEach(function (p) {
          var d = R * (0.2 + e * 2.4 * p.v);
          g.fillStyle = 'hsla(' + (20 + p.v * 30) + ',100%,' + (60 + p.s * 10) + '%,' + (1 - e * 0.6) + ')';
          g.beginPath(); g.arc(cx + Math.cos(p.a) * d, cy + Math.sin(p.a) * d * 0.9, p.s * W / 400, 0, 7); g.fill();
        });
        g.fillStyle = '#fff'; g.beginPath(); g.arc(cx, cy, W / 200, 0, 7); g.fill();
      } else {
        // a faint shell of gas still spreading, and the new black hole with a little disk
        parts.forEach(function (p) { var d = R * (2.4 + 0.15 * Math.sin(t * 0.3 + p.a)) * p.v; g.fillStyle = 'rgba(255,140,100,.18)'; g.beginPath(); g.arc(cx + Math.cos(p.a) * d, cy + Math.sin(p.a) * d * 0.9, p.s * W / 350, 0, 7); g.fill(); });
        var hr = R * 0.32;
        var gl = g.createRadialGradient(cx, cy, hr, cx, cy, hr * 3); gl.addColorStop(0, 'rgba(255,150,60,.45)'); gl.addColorStop(1, 'rgba(255,120,40,0)'); g.fillStyle = gl; g.beginPath(); g.arc(cx, cy, hr * 3, 0, 7); g.fill();
        for (var j = 0; j < 40; j++) { var aa = j / 40 * 6.283 + t * 1.2, rr = hr * (1.7 + (j % 4) * 0.25); g.fillStyle = 'rgba(255,' + (150 + (j % 3) * 30) + ',70,.75)'; g.beginPath(); g.ellipse(cx + Math.cos(aa) * rr, cy + Math.sin(aa) * rr * 0.28, W / 260, W / 420, 0, 0, 7); g.fill(); }
        g.fillStyle = '#000'; g.beginPath(); g.arc(cx, cy, hr, 0, 7); g.fill();
        g.strokeStyle = 'rgba(255,210,150,.9)'; g.lineWidth = Math.max(1, W / 400); g.beginPath(); g.arc(cx, cy, hr * 1.05, 0, 7); g.stroke();
      }
    }
    function loop(now) {
      var dt = last ? Math.min(0.05, (now - last) / 1000) : 0; last = now;
      if (on) { draw(reduce ? 0 : dt); if (auto && t > 3.2) { if (st < 4) { st++; show(); } else { auto = false; box.querySelector('[data-a=play]').innerHTML = '▶ ' + T('Play', 'चलाएँ'); } } }
      requestAnimationFrame(loop);
    }
    box.querySelector('[data-a=prev]').onclick = function () { if (st > 0) { st--; show(); } };
    box.querySelector('[data-a=next]').onclick = function () { if (st < 4) { st++; show(); } };
    box.querySelector('[data-a=play]').onclick = function () { auto = true; st = 0; show(); this.innerHTML = '❚❚'; };
    dots.onclick = function (e) { var d = e.target.closest('i'); if (d) { st = +d.dataset.i; show(); } };
    visible(box, function (v) { on = v; });
    show(); requestAnimationFrame(loop);
  }

  var a = document.getElementById('bhSim'); if (a) sim(a);
  var b = document.getElementById('bhFall'); if (b) fall(b);
  var c = document.getElementById('bhForm'); if (c) form(c);
})();
