/* Home page: a live Earth (real map, real day and night for this moment, the space station where it
   really is), a live line with numbers that keep moving, "Today in space", the account line, the
   quick quiz and "Surprise me". Everything is worked out in the browser. */
(function () {
  var API = window.ASTRYL_API, D = window.ASTRYL, ACCT = window.ASTRYL_ACCT;
  if (!API || !D) return;
  var root = document.body.getAttribute('data-root') || '';
  var reduce = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;
  var CITYKEY = 'astryl-city', DEG = Math.PI / 180, OBL = 23.4393 * DEG, WGS_A = 6378.137, WGS_F = 1 / 298.257223563, E2 = WGS_F * (2 - WGS_F);
  function hi() { return API.lang() === 'hi'; }
  function T(en, h) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + h + '</span>'; }
  function esc(x) { return String(x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function n360(a) { return ((a % 360) + 360) % 360; }
  function num(v, d) { return Number(v).toLocaleString(hi() ? 'hi-IN' : 'en-US', { maximumFractionDigits: d || 0 }); }
  function get(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } }
  function set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { } }

  /* ---------- the Sun and the space station ---------- */
  function jd(ms) { return ms / 86400000 + 2440587.5; }
  function gmst(ms) { return n360(280.46061837 + 360.98564736629 * (jd(ms) - 2451545)); }
  function subsolar(ms) {
    var l = API.sunLon(ms) * DEG, ra = n360(Math.atan2(Math.sin(l) * Math.cos(OBL), Math.cos(l)) / DEG), dec = Math.asin(Math.sin(OBL) * Math.sin(l)) / DEG;
    return { lat: dec, lon: n360(ra - gmst(ms) + 180) - 180 };
  }
  var sat = null;
  function issGeo(ms) {
    if (!sat) return null;
    var p = sat.at(ms); if (!p) return null;
    var th = gmst(ms) * DEG, c = Math.cos(th), s = Math.sin(th), x = p.x * c + p.y * s, y = -p.x * s + p.y * c, z = p.z;
    var lon = Math.atan2(y, x) / DEG, r = Math.sqrt(x * x + y * y), lat = Math.atan2(z, r * (1 - E2)), h = 0;
    for (var i = 0; i < 5; i++) { var n = WGS_A / Math.sqrt(1 - E2 * Math.sin(lat) * Math.sin(lat)); h = r / Math.cos(lat) - n; lat = Math.atan2(z, r * (1 - E2 * n / (n + h))); }
    return { lat: lat / DEG, lon: lon, h: h, v: Math.sqrt(p.vx * p.vx + p.vy * p.vy + p.vz * p.vz) * 3600 };
  }
  function loadIss() {
    if (!window.Sgp4) return;
    var c = get('astryl-tle-iss', null);
    function use(t) { try { sat = new Sgp4(t.line1, t.line2); return true; } catch (e) { return false; } }
    if (c && c.line1 && use(c) && Date.now() - c.fetchedMs < 12 * 3600000) return;
    fetch('https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/daily?what=tle&sat=iss').then(function (r) { if (!r.ok) throw 0; return r.json(); }).then(function (j) {
      var t = { line1: String(j.line1 || ''), line2: String(j.line2 || ''), fetchedMs: Date.now() };
      if (/^1 25544/.test(t.line1) && /^2 25544/.test(t.line2) && use(t)) set('astryl-tle-iss', t);
    }).catch(function () { });
  }

  /* ---------- the live Earth ---------- */
  function globe(cv) {
    var N = Math.min(480, Math.round((cv.clientWidth || 300) * Math.min(2, window.devicePixelRatio || 1)));
    cv.width = N; cv.height = N;
    var ctx = cv.getContext('2d'), img = ctx.createImageData(N, N), px = img.data;
    var tex = null, TW = 0, TH = 0, tilt = 18 * DEG, spin = 0, last = 0, on = true;
    var R = N * 0.44, cx = N / 2, cy = N / 2;
    // per pixel: latitude, longitude offset from the centre of the view, and whether it is on the disc
    var LAT = new Float32Array(N * N), DLON = new Float32Array(N * N), SINL = new Float32Array(N * N), COSL = new Float32Array(N * N), EDGE = new Float32Array(N * N), IN = new Uint8Array(N * N);
    for (var j = 0; j < N; j++) for (var i = 0; i < N; i++) {
      var k = j * N + i, x = (i + 0.5 - cx) / R, y = (cy - j - 0.5) / R, rr = x * x + y * y;
      if (rr >= 1) continue;
      var z = Math.sqrt(1 - rr), y2 = y * Math.cos(tilt) + z * Math.sin(tilt), z2 = -y * Math.sin(tilt) + z * Math.cos(tilt);
      LAT[k] = Math.asin(y2); DLON[k] = Math.atan2(x, z2); SINL[k] = Math.sin(LAT[k]); COSL[k] = Math.cos(LAT[k]); EDGE[k] = z; IN[k] = 1;
    }
    var im = new Image(); im.decoding = 'async';
    im.onload = function () {
      var oc = document.createElement('canvas'); TW = oc.width = Math.min(1440, im.naturalWidth); TH = oc.height = Math.round(TW / 2);
      var g = oc.getContext('2d'); g.drawImage(im, 0, 0, TW, TH); tex = g.getImageData(0, 0, TW, TH).data; draw(performance.now());
    };
    im.src = root + 'img/space/map-earth.webp';
    function draw(now) {
      if (!tex) return;
      var ms = Date.now(), sun = subsolar(ms), sd = sun.lat * DEG, ssin = Math.sin(sd), scos = Math.cos(sd);
      var lon0 = (n360(spin + 180) - 180) * DEG;
      for (var k = 0; k < N * N; k++) {
        var o = k * 4;
        if (!IN[k]) { px[o + 3] = 0; continue; }
        var lon = lon0 + DLON[k], u = ((lon / (2 * Math.PI) + 0.5) % 1 + 1) % 1, v = 0.5 - LAT[k] / Math.PI;
        var t = ((v * TH | 0) * TW + (u * TW | 0)) * 4;
        var light = SINL[k] * ssin + COSL[k] * scos * Math.cos(lon - sun.lon * DEG); // the Sun's height there
        var day = Math.max(0, Math.min(1, (light + 0.1) / 0.2)), shade = 0.26 + 0.74 * day, rim = 0.55 + 0.45 * EDGE[k];
        px[o] = tex[t] * shade * rim + (1 - day) * 4; px[o + 1] = tex[t + 1] * shade * rim + (1 - day) * 12; px[o + 2] = tex[t + 2] * shade * rim + (1 - day) * 34; px[o + 3] = 255;
      }
      ctx.clearRect(0, 0, N, N);
      // a thin blue glow of air around the Earth
      var g = ctx.createRadialGradient(cx, cy, R * 0.98, cx, cy, R * 1.12); g.addColorStop(0, 'rgba(110,170,255,.45)'); g.addColorStop(1, 'rgba(110,170,255,0)');
      ctx.fillStyle = g; ctx.beginPath(); ctx.arc(cx, cy, R * 1.12, 0, 7); ctx.fill();
      var tmp = draw.tmp || (draw.tmp = document.createElement('canvas')); tmp.width = N; tmp.height = N; tmp.getContext('2d').putImageData(img, 0, 0);
      ctx.drawImage(tmp, 0, 0);
      // the space station and its path for the next 45 minutes
      var p = issGeo(ms);
      if (p) {
        function proj(la, lo) {
          var l = la * DEG, d = lo * DEG - lon0, x = Math.cos(l) * Math.sin(d), y = Math.sin(l), z = Math.cos(l) * Math.cos(d);
          var y2 = y * Math.cos(tilt) - z * Math.sin(tilt), z2 = y * Math.sin(tilt) + z * Math.cos(tilt), s = 1 + p.h / 6371;
          return { x: cx + x * R * s, y: cy - y2 * R * s, front: z2 > -0.05 };
        }
        ctx.strokeStyle = 'rgba(255,214,120,.75)'; ctx.lineWidth = Math.max(1, N / 260); ctx.setLineDash([N / 90, N / 120]); ctx.beginPath();
        var started = false;
        for (var m = 0; m <= 45; m += 1.5) { var q = issGeo(ms + m * 60000); if (!q) continue; var a = proj(q.lat, q.lon); if (!a.front) { started = false; continue; } if (!started) { ctx.moveTo(a.x, a.y); started = true; } else ctx.lineTo(a.x, a.y); }
        ctx.stroke(); ctx.setLineDash([]);
        var s0 = proj(p.lat, p.lon);
        if (s0.front) {
          var pulse = reduce ? 1 : 1 + 0.35 * Math.sin(now / 300);
          ctx.fillStyle = 'rgba(255,214,120,.3)'; ctx.beginPath(); ctx.arc(s0.x, s0.y, N / 34 * pulse, 0, 7); ctx.fill();
          ctx.fillStyle = '#ffd678'; ctx.beginPath(); ctx.arc(s0.x, s0.y, N / 95, 0, 7); ctx.fill();
        }
      }
    }
    function loop(now) {
      if (on && !document.hidden && now - last > 33) { if (last && !reduce) spin -= Math.min(0.1, (now - last) / 1000) * 8; draw(now); last = now; }
      requestAnimationFrame(loop);
    }
    if ('IntersectionObserver' in window) new IntersectionObserver(function (es) { on = es[0].isIntersecting; }).observe(cv);
    spin = subsolar(Date.now()).lon + 55; // start with the sunlit side and the day-night line in view
    requestAnimationFrame(loop);
  }

  /* ---------- the live line ---------- */
  function liveBar(el) {
    var v1 = (D.spacecraft || []).filter(function (s) { return s.id === 'voyager1'; })[0];
    function tick() {
      var ms = Date.now(), h = '', p = issGeo(ms);
      if (p) h += '<span>🛰 ' + T('Space station now above ', 'अंतरिक्ष स्टेशन अभी ') + Math.abs(p.lat).toFixed(1) + '°' + (p.lat >= 0 ? 'N' : 'S') + ' ' + Math.abs(p.lon).toFixed(1) + '°' + (p.lon >= 0 ? 'E' : 'W') + T(', at ', ' के ऊपर, ') + num(p.v) + ' km/h</span>';
      if (v1) h += '<span>🚀 Voyager 1: ' + num(v1.anchorAu * 149597870.7 + (ms - v1.anchor) / 1000 * v1.speed) + ' km ' + T('from the Sun and still going', 'सूरज से, और अब भी आगे जा रहा') + '</span>';
      el.innerHTML = h;
    }
    tick(); setInterval(tick, reduce ? 5000 : 200);
  }

  /* ---------- today in space ---------- */
  function today(el) {
    var ms = Date.now(), cards = [];
    var e = (D.eclipses || []).filter(function (x) { return Date.parse(x[1]) > ms; })[0];
    var TY = { total: ['Total', 'पूर्ण'], annular: ['Annular', 'वलयाकार'], partial: ['Partial', 'आंशिक'], penumbral: ['Penumbral', 'उपछाया'] };
    if (e) {
      var d = new Date(e[1]), days = Math.ceil((d - ms) / 86400000);
      cards.push(['🌑', T('Next eclipse', 'अगला ग्रहण'), T(TY[e[3]][0] + (e[2] ? ' lunar' : ' solar') + ' eclipse', TY[e[3]][1] + (e[2] ? ' चंद्र' : ' सूर्य') + ' ग्रहण'),
        d.toLocaleDateString(hi() ? 'hi-IN' : 'en-GB', { day: 'numeric', month: 'long', year: 'numeric' }) + ' · ' + T('in ' + days + ' days', days + ' दिन में'), 'sky-events/' + e[0] + '.html']);
    }
    var y = new Date().getFullYear(), best = null;
    (D.meteors || []).forEach(function (m) { [y, y + 1].forEach(function (yy) { var t = Date.UTC(yy, m[1] - 1, m[2]); if (t > ms - 86400000 && (!best || t < best.t)) best = { t: t, m: m }; }); });
    if (best) {
      var nm = { quadrantids: 'Quadrantids', lyrids: 'Lyrids', etaAquariids: 'Eta Aquariids', perseids: 'Perseids', orionids: 'Orionids', leonids: 'Leonids', geminids: 'Geminids', ursids: 'Ursids' }[best.m[0]] || best.m[0];
      var dd = Math.max(0, Math.ceil((best.t - ms) / 86400000));
      cards.push(['☄️', T('Next meteor shower', 'अगला उल्कापात'), esc(nm), T('Peak ', 'चरम ') + new Date(best.t).toLocaleDateString(hi() ? 'hi-IN' : 'en-GB', { day: 'numeric', month: 'long' }) + ' · ' + T('up to ' + best.m[3] + ' an hour', 'घंटे में ' + best.m[3] + ' तक') + (dd <= 1 ? ' · ' + T('tonight!', 'आज रात!') : ''),
        'sky-events/' + best.m[0].replace(/[A-Z]/g, function (c) { return '-' + c.toLowerCase(); }) + '.html']);
    }
    var ph = API.moonPhase ? API.moonPhase(ms) : null;
    if (ph && isFinite(ph.lit)) cards.push(['🌙', T('The Moon tonight', 'आज रात चाँद'), num(ph.lit * (ph.lit <= 1 ? 100 : 1)) + '% ' + T('lit', 'रोशन'), T('Phases, rise and set for your city', 'आपके शहर के लिए कलाएँ, उगना और डूबना'), 'sky.html']);
    cards.push(['🛰️', T('Space station', 'अंतरिक्ष स्टेशन'), T('When can I see it?', 'मुझे कब दिखेगा?'), T('Passes over your city, worked out live', 'आपके शहर के ऊपर से गुज़रना, live गिना हुआ'), 'iss.html']);
    el.innerHTML = cards.map(function (c) { return '<a class="tcard" href="' + root + c[4] + '"><span class="ti">' + c[0] + '</span><small>' + c[1] + '</small><b>' + c[2] + '</b><span class="tn">' + c[3] + '</span></a>'; }).join('');
  }

  /* ---------- the account line ---------- */
  function acct(el) {
    var s = ACCT && ACCT.session && ACCT.session();
    if (!s || !s.username) return;
    var pts = get('astryl-points', null);
    el.innerHTML = '👋 ' + T('Welcome back, ', 'फिर से स्वागत है, ') + '<b>' + esc(s.username) + '</b>' + (pts && pts.total ? ' · ⭐ ' + num(pts.total) + ' Space Points' : '') +
      ' · <a href="' + root + 'quiz.html">' + T('Play today’s Daily 5', 'आज का Daily 5 खेलिए') + ' →</a>';
  }

  /* ---------- quick quiz ---------- */
  function quiz(box) {
    box.addEventListener('click', function (e) {
      var b = e.target.closest('button.opt'); if (!b || box.classList.contains('done')) return;
      box.classList.add('done');
      box.querySelectorAll('button.opt').forEach(function (x) { x.disabled = true; if (x.dataset.ok) x.classList.add('right'); });
      if (!b.dataset.ok) b.classList.add('wrong');
      box.querySelector('.qres').innerHTML = (b.dataset.ok ? '✅ ' + T('Right!', 'सही!') : '❌ ' + T('It is Jupiter.', 'यह बृहस्पति है।')) + ' ' + T('The Great Red Spot is a storm wider than Earth that has raged for at least 190 years.', 'Great Red Spot पृथ्वी से चौड़ा एक तूफ़ान है, जो कम से कम 190 साल से चल रहा है।') +
        '<br><a class="btn primary" style="margin-top:10px" href="' + root + 'quiz.html">' + T('Play 10 more', '10 और खेलिए') + ' →</a>';
    });
  }

  /* ---------- surprise me ---------- */
  function surprise(box) {
    var list = window.ASTRYL_SURPRISE || [], last = -1, out = box.querySelector('.sres');
    box.querySelector('button').addEventListener('click', function () {
      if (!list.length) return;
      var i; do { i = Math.floor(Math.random() * list.length); } while (i === last && list.length > 1); last = i;
      var x = list[i];
      out.innerHTML = '<a class="spick" href="' + root + x.u + '"><img src="' + root + x.img + '" alt="" loading="lazy"><span><b>' + T(esc(x.t[0]), esc(x.t[1])) + '</b><small>' + T(esc(x.d[0]), esc(x.d[1])) + '</small><em>' + T('Open', 'खोलिए') + ' →</em></span></a>';
    });
  }

  loadIss();
  var cv = document.getElementById('heroGlobe'); if (cv) globe(cv);
  var lb = document.getElementById('liveBar'); if (lb) liveBar(lb);
  var td = document.getElementById('today'); if (td) API.onRender(function () { today(td); });
  var al = document.getElementById('acctLine'); if (al) API.onRender(function () { acct(al); });
  var qz = document.getElementById('homeQuiz'); if (qz) quiz(qz);
  var sp = document.getElementById('surprise'); if (sp) surprise(sp);

  /* Astryl Community card: the newest photo and the newest question */
  var cm = document.getElementById('homeCmLatest');
  if (cm) {
    var CM = 'https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/community';
    var ask = function (action) { return fetch(CM, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ action: action }) }).then(function (r) { return r.ok ? r.json() : {}; }).catch(function () { return {}; }); };
    Promise.all([ask('photos'), ask('posts')]).then(function (r) {
      var ph = r[0] && r[0].photos && r[0].photos[0], po = r[1] && r[1].posts && r[1].posts[0], h = '';
      if (ph && /^[0-9a-f-]{36}$/.test(ph.id)) h += '<a href="' + root + 'community.html#gallery"><img src="' + CM + '?action=img&size=thumb&id=' + ph.id + '" alt="" loading="lazy"><span><b>' + esc(ph.title) + '</b><small>📷 ' + esc(ph.by) + '</small></span></a>';
      if (po) h += '<a href="' + root + 'community.html#talk"><span style="font-size:1.6rem">💬</span><span><b>' + esc(String(po.body).slice(0, 110)) + (String(po.body).length > 110 ? '…' : '') + '</b><small>' + esc(po.by) + (po.replies && po.replies.length ? ' · ' + po.replies.length + ' ' + (hi() ? 'जवाब' : (po.replies.length === 1 ? 'answer' : 'answers')) : '') + '</small></span></a>';
      cm.innerHTML = h;
    });
  }
})();
