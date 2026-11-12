/* Soft motion for the whole site: things fade up as they scroll into view and
   the header gets a shadow once the page moves. Switched off when the visitor
   asks for less motion (the page then shows everything at once). */
(function () {
  'use strict';
  var doc = document;
  var header = doc.querySelector('header.top');
  function onScroll() { if (header) header.classList.toggle('scrolled', (window.scrollY || 0) > 8); }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  if (!doc.documentElement.classList.contains('js')) return;
  var SEL = '.card,a.sc,.stat,details,.tl .m,.steps li,.opt,section.blk>h2,section.blk>.sub,.callout,.pn,.policy>h2';
  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); }
    });
  }, { rootMargin: '0px 0px -6% 0px', threshold: 0.05 });

  function scan() {
    var main = doc.querySelector('main'); if (!main) return;
    var seen = new Map();
    [].forEach.call(main.querySelectorAll(SEL), function (el) {
      if (el.classList.contains('rv') || el.closest('.journey')) return;
      var parent = el.parentNode, n = seen.get(parent) || 0;
      seen.set(parent, n + 1);
      el.style.setProperty('--d', Math.min(n * 0.06, 0.36) + 's');
      el.classList.add('rv');
      io.observe(el);
    });
  }
  scan();
  // Pages fill themselves in with scripts (lists, calendars): look again.
  var timer = 0, main = doc.querySelector('main');
  if (main && 'MutationObserver' in window) {
    new MutationObserver(function () { clearTimeout(timer); timer = setTimeout(scan, 80); })
      .observe(main, { childList: true, subtree: true });
  }

  var reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (reduceMotion) return;

  // 1. 3D Card Tilt & Dynamic Spotlight Glow on Hover
  doc.addEventListener('pointermove', function (e) {
    var card = e.target.closest('.pcard, a.sc');
    if (!card) return;
    var r = card.getBoundingClientRect();
    var x = e.clientX - r.left, y = e.clientY - r.top;
    card.style.setProperty('--mx', x.toFixed(0) + 'px');
    card.style.setProperty('--my', y.toFixed(0) + 'px');
    var rx = ((y / r.height) - 0.5) * -6;
    var ry = ((x / r.width) - 0.5) * 6;
    card.style.transform = 'perspective(640px) rotateX(' + rx.toFixed(2) + 'deg) rotateY(' + ry.toFixed(2) + 'deg) translateY(-2px)';
  }, { passive: true });

  doc.addEventListener('pointerout', function (e) {
    var card = e.target.closest('.pcard, a.sc');
    if (card && !card.contains(e.relatedTarget)) {
      card.style.transform = '';
    }
  }, { passive: true });

  // 2. Smooth Animated Progress & Atmosphere Bars on Scroll
  var barIO = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (!e.isIntersecting) return;
      var fill = e.target;
      var targetW = fill.getAttribute('data-w') || fill.style.width;
      fill.setAttribute('data-w', targetW);
      fill.style.width = '0%';
      requestAnimationFrame(function () {
        requestAnimationFrame(function () { fill.style.width = targetW; });
      });
      barIO.unobserve(fill);
    });
  }, { threshold: 0.1 });
  [].forEach.call(doc.querySelectorAll('.meter i, .progress i'), function (el) { barIO.observe(el); });

  // 3. Live Twinkling Starfield & Periodic Shooting Stars Background
  var cv = doc.createElement('canvas');
  cv.id = 'skyBgCanvas';
  cv.setAttribute('aria-hidden', 'true');
  doc.body.appendChild(cv);
  var ctx = cv.getContext('2d');
  var W = 0, H = 0, stars = [];
  function resize() {
    W = cv.width = window.innerWidth;
    H = cv.height = window.innerHeight;
  }
  resize();
  window.addEventListener('resize', resize, { passive: true });
  for (var i = 0; i < 85; i++) {
    stars.push({ x: Math.random(), y: Math.random(), r: 0.6 + Math.random() * 1.2, p: Math.random() * 6.28, s: 0.8 + Math.random() * 1.4 });
  }
  function drawSky(ts) {
    ctx.clearRect(0, 0, W, H);
    var t = (ts || 0) * 0.001;
    for (var i = 0; i < stars.length; i++) {
      var st = stars[i];
      var a = 0.2 + 0.6 * (0.5 + 0.5 * Math.sin(t * st.s + st.p));
      ctx.fillStyle = 'rgba(195,215,255,' + a.toFixed(2) + ')';
      ctx.beginPath();
      ctx.arc(st.x * W, st.y * H, st.r, 0, 6.28);
      ctx.fill();
    }
    // Periodic shooting star every ~7 seconds
    var cycle = (t % 7.5);
    if (cycle < 0.75) {
      var p = cycle / 0.75;
      var seed = Math.floor(t / 7.5);
      var sx = ((seed * 37 % 70) + 15) / 100 * W;
      var sy = ((seed * 53 % 35) + 6) / 100 * H;
      var dx = 220, dy = 110;
      var hx = sx + dx * p, hy = sy + dy * p;
      var tx = sx + dx * Math.max(0, p - 0.28), ty = sy + dy * Math.max(0, p - 0.28);
      var alpha = Math.sin(p * Math.PI);
      var g = ctx.createLinearGradient(tx, ty, hx, hy);
      g.addColorStop(0, 'rgba(160,200,255,0)');
      g.addColorStop(1, 'rgba(255,255,255,' + (alpha * 0.85).toFixed(2) + ')');
      ctx.strokeStyle = g;
      ctx.lineWidth = 1.8;
      ctx.beginPath();
      ctx.moveTo(tx, ty);
      ctx.lineTo(hx, hy);
      ctx.stroke();
    }
    requestAnimationFrame(drawSky);
  }
  requestAnimationFrame(drawSky);
})();

/* Tap a real photo (in a caption box) to see it big; tap again or press Esc to close. */
(function () {
  var box = null;
  function close() { if (box) { box.remove(); box = null; } }
  document.addEventListener('click', function (e) {
    var im = e.target.closest('.sphoto img, .mphoto img');
    if (!im || box) return;
    box = document.createElement('div'); box.className = 'lightbox'; box.setAttribute('role', 'dialog');
    var big = new Image(); big.src = im.currentSrc || im.src; big.alt = im.alt;
    box.appendChild(big); box.onclick = close; document.body.appendChild(box);
  });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') close(); });
})();

/* First visit only: a short trip at warp speed (about a second), then the page. Skippable, and
   never shown when the visitor has asked for less motion. */
(function () {
  var K = 'astryl-intro-seen';
  try { if (localStorage.getItem(K)) return; localStorage.setItem(K, '1'); } catch (e) { return; }
  if ((window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches) || /bot|crawl|spider|lighthouse|headless/i.test(navigator.userAgent)) return;
  var box = document.createElement('div'); box.className = 'intro'; box.setAttribute('aria-hidden', 'true');
  box.innerHTML = '<canvas></canvas><div class="ilogo">✦ Astryl</div><button type="button" class="iskip">Skip ›</button>';
  document.body.appendChild(box);
  var cv = box.querySelector('canvas'), g = cv.getContext('2d'), dpr = Math.min(2, window.devicePixelRatio || 1), W, H, stars = [], t0 = performance.now(), done = false;
  function size() { W = cv.width = innerWidth * dpr; H = cv.height = innerHeight * dpr; }
  size();
  for (var i = 0; i < 420; i++) stars.push({ x: (Math.random() - 0.5) * 2, y: (Math.random() - 0.5) * 2, z: Math.random() });
  function end() { if (done) return; done = true; box.classList.add('out'); setTimeout(function () { box.remove(); }, 500); }
  box.querySelector('.iskip').onclick = end;
  (function frame(now) {
    if (done) return;
    var t = (now - t0) / 1000, speed = t < 0.9 ? 0.4 + t * 2.2 : Math.max(0.2, 2.4 - (t - 0.9) * 3);
    g.fillStyle = 'rgba(2,3,10,.35)'; g.fillRect(0, 0, W, H);
    var cx = W / 2, cy = H / 2, f = Math.min(W, H) * 0.6;
    stars.forEach(function (s) {
      var z0 = s.z; s.z -= speed * 0.016; if (s.z <= 0.02) { s.z = 1; s.x = (Math.random() - 0.5) * 2; s.y = (Math.random() - 0.5) * 2; return; }
      var x1 = cx + s.x / z0 * f, y1 = cy + s.y / z0 * f, x2 = cx + s.x / s.z * f, y2 = cy + s.y / s.z * f, b = 1 - s.z;
      g.strokeStyle = 'rgba(' + (180 + 75 * b | 0) + ',' + (200 + 55 * b | 0) + ',255,' + (0.3 + 0.7 * b).toFixed(2) + ')'; g.lineWidth = (0.6 + 1.8 * b) * dpr;
      g.beginPath(); g.moveTo(x1, y1); g.lineTo(x2, y2); g.stroke();
    });
    if (t > 0.7) box.classList.add('show');
    if (t > 1.7) end();
    requestAnimationFrame(frame);
  })(t0);
})();
