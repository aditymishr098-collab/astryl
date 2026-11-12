/* Zoom and pan for the Moon and Mars surface maps: drag to move, pinch or the + and − buttons to
   zoom, and "Show on the map" on a landing site flies to it. Dots and labels keep their size. */
(function () {
  document.querySelectorAll('svg.surfmap').forEach(function (svg) {
    var wrap = svg.closest('.mapwrap'), W = 360, H = 180, v = { x: 0, y: 0, w: W, h: H }, anim = null;
    var dots = svg.querySelectorAll('.sdot'), texts = svg.querySelectorAll('text');
    var base = [].map.call(texts, function (t) { return +t.getAttribute('font-size') || 5; });
    function clamp() {
      v.w = Math.max(18, Math.min(W, v.w)); v.h = v.w / 2;
      v.x = Math.max(0, Math.min(W - v.w, v.x)); v.y = Math.max(0, Math.min(H - v.h, v.y));
    }
    function apply() {
      clamp();
      svg.setAttribute('viewBox', v.x.toFixed(2) + ' ' + v.y.toFixed(2) + ' ' + v.w.toFixed(2) + ' ' + v.h.toFixed(2));
      var k = v.w / W;
      dots.forEach(function (d) { d.setAttribute('r', (2.6 * Math.max(k, 0.12)).toFixed(2)); d.setAttribute('stroke-width', (1 * Math.max(k, 0.12)).toFixed(2)); });
      texts.forEach(function (t, i) { t.setAttribute('font-size', (base[i] * Math.max(k, 0.2)).toFixed(2)); });
    }
    function fly(to) {
      cancelAnimationFrame(anim);
      var from = { x: v.x, y: v.y, w: v.w }, t0 = performance.now();
      (function step(now) {
        var f = Math.min(1, (now - t0) / 450), e = f < 0.5 ? 2 * f * f : 1 - Math.pow(-2 * f + 2, 2) / 2;
        v.x = from.x + (to.x - from.x) * e; v.y = from.y + (to.y - from.y) * e; v.w = from.w + (to.w - from.w) * e;
        apply(); if (f < 1) anim = requestAnimationFrame(step);
      })(t0);
    }
    function zoomAt(cx, cy, factor) {
      var nw = Math.max(18, Math.min(W, v.w * factor));
      fly({ x: cx - (cx - v.x) * nw / v.w, y: cy - (cy - v.y) * nw / v.w, w: nw });
    }
    function toMap(e) { var r = svg.getBoundingClientRect(); return { x: v.x + (e.clientX - r.left) / r.width * v.w, y: v.y + (e.clientY - r.top) / r.height * v.h }; }
    // drag and pinch
    var pts = {}, start = null, moved = false;
    svg.addEventListener('pointerdown', function (e) { pts[e.pointerId] = { x: e.clientX, y: e.clientY }; start = { v: { x: v.x, y: v.y, w: v.w }, p: JSON.parse(JSON.stringify(pts)) }; moved = false; });
    svg.addEventListener('pointermove', function (e) {
      if (!pts[e.pointerId] || !start) return;
      pts[e.pointerId] = { x: e.clientX, y: e.clientY };
      var ids = Object.keys(pts), r = svg.getBoundingClientRect(), s = start.v.w / r.width;
      if (ids.length === 1 && start.p[ids[0]]) {
        var dx = e.clientX - start.p[ids[0]].x, dy = e.clientY - start.p[ids[0]].y;
        if (Math.abs(dx) + Math.abs(dy) > 4) moved = true;
        if (moved) { cancelAnimationFrame(anim); v.x = start.v.x - dx * s; v.y = start.v.y - dy * s; v.w = start.v.w; apply(); }
      } else if (ids.length === 2 && start.p[ids[0]] && start.p[ids[1]]) {
        var d0 = Math.hypot(start.p[ids[0]].x - start.p[ids[1]].x, start.p[ids[0]].y - start.p[ids[1]].y), d1 = Math.hypot(pts[ids[0]].x - pts[ids[1]].x, pts[ids[0]].y - pts[ids[1]].y);
        var mx = (start.p[ids[0]].x + start.p[ids[1]].x) / 2 - r.left, my = (start.p[ids[0]].y + start.p[ids[1]].y) / 2 - r.top;
        var cx = start.v.x + mx * s, cy = start.v.y + my * s, nw = start.v.w * d0 / Math.max(d1, 1);
        moved = true; cancelAnimationFrame(anim);
        v.w = Math.max(18, Math.min(W, nw)); v.x = cx - (cx - start.v.x) * v.w / start.v.w; v.y = cy - (cy - start.v.y) * v.w / start.v.w; apply();
      }
    });
    function up(e) { delete pts[e.pointerId]; start = Object.keys(pts).length ? { v: { x: v.x, y: v.y, w: v.w }, p: JSON.parse(JSON.stringify(pts)) } : null; }
    svg.addEventListener('pointerup', up); svg.addEventListener('pointercancel', up);
    svg.addEventListener('click', function (e) { if (moved) { e.preventDefault(); e.stopPropagation(); moved = false; } }, true);
    svg.addEventListener('wheel', function (e) { if (!e.ctrlKey && !e.metaKey && v.w >= W && e.deltaY > 0) return; e.preventDefault(); var p = toMap(e); zoomAt(p.x, p.y, e.deltaY < 0 ? 0.7 : 1.4); }, { passive: false });
    if (wrap) wrap.addEventListener('click', function (e) {
      var b = e.target.closest('[data-mz]'); if (!b) return;
      if (b.dataset.mz === 'all') fly({ x: 0, y: 0, w: W }); else zoomAt(v.x + v.w / 2, v.y + v.h / 2, b.dataset.mz === 'in' ? 0.5 : 2);
    });
    svg.zoomTo = function (id) {
      var a = svg.querySelector('[data-site="' + id + '"]'); if (!a) return false;
      var x = +a.dataset.x, y = +a.dataset.y, w = 40;
      fly({ x: x - w / 2, y: y - w / 4, w: w });
      dots.forEach(function (d) { d.classList.toggle('pick', d.parentNode === a); });
      return true;
    };
  });
  document.addEventListener('click', function (e) {
    var b = e.target.closest('[data-zoomto]'); if (!b) return;
    var id = b.dataset.zoomto;
    document.querySelectorAll('svg.surfmap').forEach(function (svg) { if (svg.zoomTo && svg.zoomTo(id)) svg.scrollIntoView({ behavior: 'smooth', block: 'center' }); });
  });
})();
