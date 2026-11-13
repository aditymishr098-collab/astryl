/* Stars section: the life-cycle player and the tap-a-star card on the HR diagram. */
(function () {
  var API = window.ASTRYL_API;
  function hi() { return API && API.lang && API.lang() === 'hi'; }
  function esc(x) { return String(x == null ? '' : x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function $(id) { return document.getElementById(id); }
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---------- life cycle ---------- */
  var LIFE = window.ASTRYL_LIFE, box = $('lifecycle');
  // how each stage looks: size in px, colour, glow, extra class
  var LOOK = {
    nebula: [150, '#6b5bd6', 0, 'neb'], proto: [70, '#ff9a5a', 30, 'proto'], main: [70, '#fff1c9', 40, ''], mainb: [80, '#a9c4ff', 50, ''],
    giant: [190, '#ff7a3d', 50, ''], sgiant: [230, '#ff5a2a', 60, ''], wr: [90, '#cfe0ff', 60, 'wr'], pn: [26, '#ffffff', 30, 'pn'],
    wd: [18, '#f4f8ff', 26, ''], sn: [250, '#fffbe6', 120, 'sn'], remnant: [24, '#cfe0ff', 20, 'rem'], ns: [12, '#dfe9ff', 30, 'ns'], bh: [46, '#000000', 0, 'bh']
  };
  if (LIFE && box) {
    var path = 'low', i = 0, timer = null;
    function draw() {
      var st = LIFE[path][i], lk = LOOK[st[0]] || [60, '#fff', 20, ''];
      var star = $('lcStar'), ring = $('lcRing');
      star.className = 'lcstar ' + lk[3];
      star.style.width = star.style.height = lk[0] + 'px';
      star.style.background = lk[3] === 'bh' ? '#000' : 'radial-gradient(circle at 40% 38%, #fff 0%, ' + lk[1] + ' 45%, ' + lk[1] + '00 72%)';
      star.style.boxShadow = lk[2] ? '0 0 ' + lk[2] + 'px ' + Math.round(lk[2] / 3) + 'px ' + lk[1] + '88' : 'none';
      ring.className = 'lcring' + (lk[3] === 'pn' ? ' on pn' : lk[3] === 'rem' ? ' on rem' : lk[3] === 'bh' ? ' on bh' : '');
      $('lcStep').textContent = (hi() ? 'चरण ' : 'Stage ') + (i + 1) + ' / ' + LIFE[path].length;
      $('lcTitle').textContent = hi() ? st[2] : st[1];
      $('lcBody').textContent = hi() ? st[4] : st[3];
      $('lcTime').textContent = (hi() ? '⏱️ कितना समय: ' : '⏱️ How long: ') + (hi() ? st[6] : st[5]);
      var r = $('lcRange'); r.max = LIFE[path].length - 1; r.value = i;
      box.querySelectorAll('[data-path]').forEach(function (b) { b.classList.toggle('on', b.dataset.path === path); });
    }
    function stop() { if (timer) { clearInterval(timer); timer = null; } $('lcPlay').innerHTML = hi() ? '▶ चलाइए' : '▶ Play'; }
    function play() {
      if (timer) return stop();
      if (i >= LIFE[path].length - 1) i = 0;
      draw();
      $('lcPlay').innerHTML = hi() ? '⏸ रोकिए' : '⏸ Pause';
      timer = setInterval(function () { if (i >= LIFE[path].length - 1) return stop(); i++; draw(); }, reduce ? 4000 : 2600);
    }
    box.addEventListener('click', function (e) {
      var b = e.target.closest('[data-path]'); if (b) { stop(); path = b.dataset.path; i = 0; draw(); return; }
      if (e.target.closest('#lcPrev')) { stop(); i = Math.max(0, i - 1); draw(); }
      if (e.target.closest('#lcNext')) { stop(); i = Math.min(LIFE[path].length - 1, i + 1); draw(); }
      if (e.target.closest('#lcPlay')) play();
    });
    $('lcRange').addEventListener('input', function (e) { stop(); i = +e.target.value; draw(); });
    draw();
    if (API && API.onRender) API.onRender(draw);
  }

  /* ---------- HR diagram ---------- */
  var S = window.ASTRYL_STARS, card = $('hrCard');
  if (S && card) {
    function n(v) { return Number(v).toLocaleString(hi() ? 'hi-IN' : 'en-US', { maximumSignificantDigits: 4 }); }
    function show(id) {
      var s = S[id]; if (!s) return;
      var d = s.ly < 0.001 ? (hi() ? '8.3 प्रकाश-मिनट' : '8.3 light-minutes') : n(s.ly) + (hi() ? ' प्रकाश-वर्ष' : ' light-years');
      card.innerHTML = '<div class="hrhead"><span class="fsdot" style="--c:' + esc(s.c) + '"></span><div><h3>' + esc(hi() ? s.hi : s.en) + '</h3><p class="note">' + esc(hi() ? s.thi : s.ten) + '</p></div></div><p>' + esc(hi() ? s.nhi : s.nen) + '</p>' +
        '<dl class="fsdl"><div><dt>' + (hi() ? 'दूरी' : 'Distance') + '</dt><dd>' + d + '</dd></div><div><dt>' + (hi() ? 'सतह' : 'Surface') + '</dt><dd>' + n(s.t) + ' K</dd></div>' +
        '<div><dt>' + (hi() ? 'चौड़ाई' : 'Width') + '</dt><dd>' + n(s.r) + (hi() ? ' × सूर्य' : ' × Sun') + '</dd></div><div><dt>' + (hi() ? 'चमक' : 'Brightness') + '</dt><dd>' + n(s.l) + (hi() ? ' × सूर्य' : ' × Sun') + '</dd></div>' +
        '<div><dt>' + (hi() ? 'द्रव्यमान' : 'Mass') + '</dt><dd>' + n(s.m) + (hi() ? ' × सूर्य' : ' × Sun') + '</dd></div></dl>';
      document.querySelectorAll('.hrstar').forEach(function (g) { g.classList.toggle('on', g.dataset.star === id); });
    }
    var cur = 'sun';
    document.addEventListener('click', function (e) { var g = e.target.closest('.hrstar'); if (g) { cur = g.dataset.star; show(cur); } });
    document.addEventListener('keydown', function (e) { var g = e.target.closest && e.target.closest('.hrstar'); if (g && (e.key === 'Enter' || e.key === ' ')) { e.preventDefault(); cur = g.dataset.star; show(cur); } });
    show(cur);
    if (API && API.onRender) API.onRender(function () { show(cur); });
  }
})();
