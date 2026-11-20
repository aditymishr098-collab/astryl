/* "How we move through space": four canvas scenes with real speeds and directions.
   Scene 0: the planets' paths as the Sun moves round the Milky Way.
   Scene 1: the Sun's orbit round the Milky Way (top view) and its bobbing through the disk.
   Scene 2: the Milky Way and Andromeda.
   Scene 3: where everything is heading, on the real sky (ESO panorama in galactic coordinates).
   Runs in the browser only; nothing is sent anywhere. */
(function () {
  var cv = document.getElementById('jyCv');
  if (!cv) return;
  var ctx = cv.getContext('2d');
  function $(id) { return document.getElementById(id); }
  var info = $('jyInfo'), timeEl = $('jyTime'), speedsEl = $('jySpeeds'), playBtn = $('jyPlay'), nowBtn = $('jyNow'), trueBtn = $('jyTrue');
  var reduce = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;
  var playing = !reduce, scene = 0, W = 0, H = 0, DPR = 1, onScreen = true;
  var TAU = Math.PI * 2, DEG = Math.PI / 180;
  var KMS_KPC_MYR = 1.0227e-3; // 1 km/s in kiloparsecs per million years

  /* ---------- live counters ---------- */
  var t0 = Date.now();
  function fmtKm(x) { return Math.round(x).toLocaleString('en-US'); }
  function counters() {
    var s = (Date.now() - t0) / 1000;
    var set = function (id, v) { var e = $(id); if (e) e.textContent = fmtKm(v); };
    set('jyKmSun', s * 29.78); set('jyKmGal', s * 230); set('jyKmCmb', s * 369.8); set('jyKmAnd', s * 110);
  }
  setInterval(counters, 250); counters();

  /* ---------- background stars ---------- */
  var seed = 7;
  function rnd() { seed = (seed * 16807) % 2147483647; return seed / 2147483647; }
  function gauss() { return Math.sqrt(-2 * Math.log(rnd() + 1e-9)) * Math.cos(TAU * rnd()); }
  var bg = [];
  for (var i = 0; i < 260; i++) bg.push([rnd(), rnd(), rnd() * 1.2 + 0.3, rnd()]);
  function stars(alpha) {
    for (var i = 0; i < bg.length; i++) {
      var s = bg[i];
      ctx.globalAlpha = alpha * (0.35 + 0.65 * s[3]);
      ctx.fillStyle = '#fff';
      ctx.fillRect(s[0] * W, s[1] * H, s[2] * DPR, s[2] * DPR);
    }
    ctx.globalAlpha = 1;
  }

  function resize() {
    DPR = Math.min(window.devicePixelRatio || 1, 2);
    W = Math.max(1, Math.round(cv.clientWidth * DPR));
    H = Math.max(1, Math.round(cv.clientHeight * DPR));
    cv.width = W; cv.height = H;
  }
  window.addEventListener('resize', resize);

  function label(text, x, y, color, size, align) {
    ctx.font = '600 ' + Math.round((size || 13) * DPR) + 'px "DM Sans",system-ui,sans-serif';
    ctx.textAlign = align || 'left';
    ctx.textBaseline = 'middle';
    ctx.lineWidth = 3 * DPR; ctx.strokeStyle = 'rgba(3,5,10,.85)';
    ctx.strokeText(text, x, y);
    ctx.fillStyle = color || '#e8edf7';
    ctx.fillText(text, x, y);
  }
  function small() { return W < 700 * DPR; }
  function foot(long, short) { label(small() ? short : long, 12 * DPR, H - 16 * DPR, '#9aa6bc', 12); }
  function arrow(x1, y1, x2, y2, color, wdt) {
    var a = Math.atan2(y2 - y1, x2 - x1), h = 10 * DPR;
    ctx.strokeStyle = color; ctx.fillStyle = color; ctx.lineWidth = (wdt || 2) * DPR;
    ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(x2, y2);
    ctx.lineTo(x2 - h * Math.cos(a - 0.45), y2 - h * Math.sin(a - 0.45));
    ctx.lineTo(x2 - h * Math.cos(a + 0.45), y2 - h * Math.sin(a + 0.45));
    ctx.closePath(); ctx.fill();
  }
  function glow(x, y, r, color) {
    var g = ctx.createRadialGradient(x, y, 0, x, y, r);
    g.addColorStop(0, color); g.addColorStop(1, 'rgba(0,0,0,0)');
    ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y, r, 0, TAU); ctx.fill();
  }

  /* =========================================================
     Scene 0: the planets' paths while the Sun moves
     ========================================================= */
  // circular orbits; mean longitude at J2000 (deg) and period (years)
  var PL = [
    ['Mercury', 0.387, 0.2408, 252.25, '#b8b2a8'], ['Venus', 0.723, 0.6152, 181.98, '#f1d9a0'],
    ['Earth', 1.0, 1.0, 100.46, '#5ea8ff'], ['Mars', 1.524, 1.881, 355.45, '#ff7a4d'],
    ['Jupiter', 5.203, 11.86, 34.40, '#e6b98c'], ['Saturn', 9.537, 29.46, 49.94, '#f2d58a']];
  // direction of the Sun's motion round the Galaxy (towards Cygnus, l = 90°, b = 0°) in ecliptic coordinates:
  // ecliptic latitude 59.6°, longitude 347.3°
  var D = [0.4943, -0.1114, 0.8620];
  var Z = [0, 0, 1];
  function sub(a, b) { return [a[0] - b[0], a[1] - b[1], a[2] - b[2]]; }
  function dot(a, b) { return a[0] * b[0] + a[1] * b[1] + a[2] * b[2]; }
  function scl(a, k) { return [a[0] * k, a[1] * k, a[2] * k]; }
  function nrm(a) { var l = Math.sqrt(dot(a, a)); return scl(a, 1 / l); }
  function crs(a, b) { return [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]]; }
  var E1 = nrm(D), E2 = nrm(sub(Z, scl(E1, dot(Z, E1)))), E3 = crs(E1, E2); // travel frame
  var yrNow = (Date.now() - Date.UTC(2000, 0, 1, 12)) / 3.15576e10;
  var s0 = { t: 0, speed: 2, trueMode: false, trails: null, last: 0, yaw: -0.35, pitch: 0.18 };
  var AU_PER_YR = 48.5; // 230 km/s for one year, in astronomical units

  function s0rad(a) { return s0.trueMode ? a : Math.sqrt(a); }
  function s0fwd() { return s0.trueMode ? AU_PER_YR : 2.4; }
  function planetWorld(i, t) {
    var p = PL[i], th = (p[3] + 360 * (yrNow + t) / p[2]) * DEG, r = s0rad(p[1]);
    var o = [r * Math.cos(th), r * Math.sin(th), 0];
    var s = scl(D, s0fwd() * t);
    return [o[0] + s[0], o[1] + s[1], o[2] + s[2]];
  }
  function s0reset() {
    s0.trails = PL.map(function () { return []; });
    s0.last = s0.t;
    for (var i = 0; i < PL.length; i++) s0.trails[i].push(planetWorld(i, s0.t));
  }
  function s0step(dt) {
    var t1 = s0.t + dt;
    for (var i = 0; i < PL.length; i++) {
      var step = PL[i][2] / 70, tr = s0.trails[i], tl = s0.last;
      var n = Math.min(400, Math.ceil((t1 - tl) / step));
      for (var k = 1; k <= n; k++) tr.push(planetWorld(i, tl + (t1 - tl) * k / n));
      if (tr.length > 1600) tr.splice(0, tr.length - 1600);
    }
    s0.t = t1; s0.last = t1;
  }
  function s0proj(w, sun, sc, cx, cy) {
    var r = sub(w, sun);
    var x = dot(r, E1), y = dot(r, E2), z = dot(r, E3);
    // user rotation: yaw about the travel axis' perpendicular, then pitch
    var cy1 = Math.cos(s0.yaw), sy1 = Math.sin(s0.yaw);
    var x1 = x * cy1 - z * sy1, z1 = x * sy1 + z * cy1;
    var cp = Math.cos(s0.pitch), sp = Math.sin(s0.pitch);
    var y1 = y * cp - z1 * sp, z2 = y * sp + z1 * cp;
    var f = 1 / (1 + z2 * 0.012);
    return [cx + x1 * sc * f, cy - y1 * sc * f, z2];
  }
  function drawScene0() {
    if (g3) {
      g3.draw();
      timeEl.textContent = '+' + s0.t.toFixed(1) + ' years';
      return;
    }
    ctx.fillStyle = '#03050a'; ctx.fillRect(0, 0, W, H);
    stars(0.7);
    var sun = scl(D, s0fwd() * s0.t);
    var visible = s0.trueMode ? 4 : 6;
    var maxR = s0rad(PL[visible - 1][1]);
    var portrait = H > W * 1.1;
    var sc = (portrait ? W * 0.4 : Math.min(W, H) * (s0.trueMode ? 0.3 : 0.33)) / maxR;
    var cx = W * (portrait ? 0.58 : 0.64), cy = H * 0.5;
    for (var i = 0; i < visible; i++) {
      var tr = s0.trails[i], col = PL[i][4];
      ctx.lineWidth = 1.6 * DPR; ctx.strokeStyle = col;
      var prev = null;
      for (var k = 0; k < tr.length; k++) {
        var p = s0proj(tr[k], sun, sc, cx, cy);
        if (prev && p[0] > -50 && prev[0] > -50) {
          ctx.globalAlpha = 0.15 + 0.85 * k / tr.length;
          ctx.beginPath(); ctx.moveTo(prev[0], prev[1]); ctx.lineTo(p[0], p[1]); ctx.stroke();
        }
        prev = p;
      }
      ctx.globalAlpha = 1;
    }
    var sp = s0proj(sun, sun, sc, cx, cy);
    glow(sp[0], sp[1], 34 * DPR, 'rgba(255,200,80,.55)');
    ctx.fillStyle = '#ffd36b'; ctx.beginPath(); ctx.arc(sp[0], sp[1], 6 * DPR, 0, TAU); ctx.fill();
    label('Sun', sp[0] + 10 * DPR, sp[1] + 14 * DPR, '#ffd36b');
    for (var j = 0; j < visible; j++) {
      var pp = s0proj(planetWorld(j, s0.t), sun, sc, cx, cy);
      ctx.fillStyle = PL[j][4]; ctx.beginPath(); ctx.arc(pp[0], pp[1], (j > 3 ? 4.5 : 3.2) * DPR, 0, TAU); ctx.fill();
      label(PL[j][0], pp[0] + 7 * DPR, pp[1] - 9 * DPR, PL[j][4], 12);
    }
    var tip = s0proj(scl(D, s0fwd() * s0.t + maxR * 1.25), sun, sc, cx, cy);
    arrow(sp[0], sp[1], tip[0], tip[1], 'rgba(0,224,255,.9)', 2);
    var tipx = Math.max(8 * DPR, Math.min(tip[0], W - 8 * DPR));
    label(small() ? 'Towards Cygnus · 230 km/s' : 'Towards Cygnus · 230 km/s round the Milky Way', tipx, tip[1] - 22 * DPR, '#7fe8ff', 12, tipx > W * 0.6 ? 'right' : 'left');
    if (s0.trueMode) foot('True proportions: the Sun moves about 48 times the Earth–Sun distance every year', 'True proportions: almost straight lines');
    else foot('Squeezed so you can see the spirals (distances and forward motion not to scale)', 'Squeezed to show the spirals (not to scale)');
    timeEl.textContent = '+' + s0.t.toFixed(1) + ' years';
  }


  /* ---------- Scene 0 in real 3D (three.js), when the browser can do it ----------
     The same paths as the flat drawing, seen in 3D: x is the direction the Sun travels (towards Cygnus),
     y is the part of the ecliptic's north that is at right angles to it. The tilted disk is the planets'
     orbit plane, the faint grid the plane of the Milky Way, and the arc the 60° between path and orbits. */
  function make3d() {
    if (!window.THREE || !THREE.OrbitControls) return null;
    var ok = false; try { var tc = document.createElement('canvas'); ok = !!(tc.getContext('webgl') || tc.getContext('experimental-webgl')); } catch (e) { }
    if (!ok) return null;
    var renderer; try { renderer = new THREE.WebGLRenderer({ antialias: true }); } catch (e) { return null; }
    var wrap = cv.parentNode, el = renderer.domElement;
    el.className = 'jy3d'; el.setAttribute('aria-hidden', 'true');
    wrap.appendChild(el);
    var labels = document.createElement('div'); labels.className = 'jy3l'; wrap.appendChild(labels);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
    renderer.outputEncoding = THREE.sRGBEncoding;
    var scene3 = new THREE.Scene(), cam = new THREE.PerspectiveCamera(42, 1.6, 0.05, 4000);
    var ctl = new THREE.OrbitControls(cam, el);
    ctl.enablePan = false; ctl.minDistance = 4; ctl.maxDistance = 120;
    scene3.add(new THREE.AmbientLight(0x505a78, 0.45));
    scene3.add(new THREE.PointLight(0xfff2dc, 1.5, 0, 0));
    function tf(v) { return new THREE.Vector3(dot(v, E1), dot(v, E2), dot(v, E3)); }
    var root = (document.body.getAttribute('data-root') || '');
    var loader = new THREE.TextureLoader();
    function tex(n) { var t = loader.load(root + 'img/textures/' + n + '.webp'); t.encoding = THREE.sRGBEncoding; return t; }

    // stars far away
    (function () {
      var n = 2500, pos = new Float32Array(n * 3);
      for (var i = 0; i < n; i++) { var u = rnd() * 2 - 1, t = rnd() * TAU, q = Math.sqrt(1 - u * u); pos[i * 3] = q * Math.cos(t) * 1500; pos[i * 3 + 1] = u * 1500; pos[i * 3 + 2] = q * Math.sin(t) * 1500; }
      var g = new THREE.BufferGeometry(); g.setAttribute('position', new THREE.BufferAttribute(pos, 3));
      scene3.add(new THREE.Points(g, new THREE.PointsMaterial({ color: 0xdfe6ff, size: 1.4, sizeAttenuation: false, transparent: true, opacity: 0.75 })));
    })();

    var sun = new THREE.Mesh(new THREE.SphereGeometry(0.55, 40, 28), new THREE.MeshBasicMaterial({ map: tex('sun') }));
    scene3.add(sun);
    (function () {
      var c = document.createElement('canvas'); c.width = c.height = 128; var x = c.getContext('2d');
      var g = x.createRadialGradient(64, 64, 0, 64, 64, 64);
      g.addColorStop(0, 'rgba(255,225,160,.9)'); g.addColorStop(0.3, 'rgba(255,190,90,.3)'); g.addColorStop(1, 'rgba(255,150,40,0)');
      x.fillStyle = g; x.fillRect(0, 0, 128, 128);
      var sp = new THREE.Sprite(new THREE.SpriteMaterial({ map: new THREE.CanvasTexture(c), blending: THREE.AdditiveBlending, depthWrite: false, transparent: true }));
      sp.scale.set(4.2, 4.2, 1); scene3.add(sp);
    })();

    var NAMES = ['mercury', 'venus', 'earth', 'mars', 'jupiter', 'saturn'], RAD = [0.13, 0.19, 0.2, 0.15, 0.42, 0.37];
    var balls = [], lines = [], MAXP = 1600;
    PL.forEach(function (p, i) {
      var m = new THREE.Mesh(new THREE.SphereGeometry(RAD[i], 24, 16), new THREE.MeshStandardMaterial({ map: tex(NAMES[i]), roughness: 1 }));
      scene3.add(m); balls.push(m);
      var g = new THREE.BufferGeometry();
      g.setAttribute('position', new THREE.BufferAttribute(new Float32Array(MAXP * 3), 3));
      g.setAttribute('color', new THREE.BufferAttribute(new Float32Array(MAXP * 3), 3));
      var ln = new THREE.Line(g, new THREE.LineBasicMaterial({ vertexColors: true, transparent: true, opacity: 0.95, blending: THREE.AdditiveBlending, depthWrite: false }));
      ln.frustumCulled = false; scene3.add(ln); lines.push(ln);
    });

    // the planets' orbit plane, the Milky Way's plane, the direction of travel and the 60° between them
    var nE = tf(Z).normalize(), group = new THREE.Group(); scene3.add(group);
    var disk = new THREE.Mesh(new THREE.CircleGeometry(1, 96), new THREE.MeshBasicMaterial({ color: 0xE7C27A, transparent: true, opacity: 0.07, side: THREE.DoubleSide, depthWrite: false }));
    disk.quaternion.setFromUnitVectors(new THREE.Vector3(0, 0, 1), nE); group.add(disk);
    var rim = new THREE.LineLoop(new THREE.BufferGeometry().setFromPoints(new THREE.Path().absarc(0, 0, 1, 0, TAU).getPoints(120).map(function (q) { return new THREE.Vector3(q.x, q.y, 0); })), new THREE.LineBasicMaterial({ color: 0xE7C27A, transparent: true, opacity: 0.3 }));
    rim.quaternion.copy(disk.quaternion); group.add(rim);
    // galactic north pole (RA 192.86°, Dec 27.13°) in ecliptic coordinates, then in the travel frame
    var ra = 192.85948 * DEG, de = 27.12825 * DEG, ob = 23.4393 * DEG, ex = Math.cos(de) * Math.cos(ra), ey = Math.cos(de) * Math.sin(ra), ez = Math.sin(de);
    var nG = tf([ex, ey * Math.cos(ob) + ez * Math.sin(ob), -ey * Math.sin(ob) + ez * Math.cos(ob)]).normalize();
    var grid = new THREE.GridHelper(400, 40, 0x6f8cff, 0x6f8cff); grid.material.transparent = true; grid.material.opacity = 0.07; grid.material.depthWrite = false;
    grid.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), nG); scene3.add(grid);
    var arrow3 = new THREE.ArrowHelper(new THREE.Vector3(1, 0, 0), new THREE.Vector3(0, 0, 0), 1, 0x00e0ff, 0.6, 0.3); scene3.add(arrow3);
    var arc = new THREE.Line(new THREE.BufferGeometry(), new THREE.LineBasicMaterial({ color: 0x7fe8ff, transparent: true, opacity: 0.8 })); scene3.add(arc);

    function lab(cls) { var d = document.createElement('div'); d.className = 'jy3lab' + (cls ? ' ' + cls : ''); labels.appendChild(d); return d; }
    var Lsun = lab('sun'), Lpl = PL.map(function (p) { var d = lab(); d.textContent = p[0]; d.style.color = p[4]; return d; }), Ldir = lab('dir'), Lang = lab('ang'), Lgal = lab('gal');
    Lsun.textContent = 'Sun'; Lang.textContent = '60°'; Lgal.textContent = 'Plane of the Milky Way';

    var Wc = 0, Hc = 0, scaleK = 1, lastMode = null, v3 = new THREE.Vector3();
    function size() {
      var w = wrap.clientWidth, h = cv.clientHeight;
      if (w === Wc && h === Hc) return; Wc = w; Hc = h;
      renderer.setSize(w, h); cam.aspect = w / h; cam.fov = w < 640 ? 55 : 42; cam.updateProjectionMatrix();
    }
    function place(d, p) {
      v3.copy(p).project(cam);
      var vis = v3.z < 1 && Math.abs(v3.x) < 1.02 && Math.abs(v3.y) < 1.02;
      d.style.display = vis ? '' : 'none';
      if (vis) d.style.transform = 'translate(' + ((v3.x + 1) / 2 * Wc).toFixed(1) + 'px,' + ((1 - v3.y) / 2 * Hc).toFixed(1) + 'px)';
    }
    function setMode() {
      var visible = s0.trueMode ? 4 : 6, maxR = s0rad(PL[visible - 1][1]);
      scaleK = 9 / maxR;
      var R = maxR * scaleK * 1.08;
      disk.scale.setScalar(R); rim.scale.setScalar(R);
      arrow3.setLength(R * 1.2, 0.7, 0.35);
      // the 60° arc from the orbit plane up to the direction of travel
      var x = new THREE.Vector3(1, 0, 0), pr = x.clone().sub(nE.clone().multiplyScalar(x.dot(nE))).normalize(), pts = [];
      for (var i = 0; i <= 40; i++) pts.push(pr.clone().lerp(x, i / 40).normalize().multiplyScalar(R * 0.62));
      arc.geometry.dispose(); arc.geometry = new THREE.BufferGeometry().setFromPoints(pts); arc.userData.mid = pts[20].clone().multiplyScalar(1.12);
      balls.forEach(function (b, i) { b.visible = lines[i].visible = Lpl[i].hidden = i < visible; Lpl[i].hidden = i >= visible; });
      cam.position.set(-R * 0.75, R * 0.55, R * 2.0); ctl.target.set(-R * 0.05, 0, 0); ctl.update();
      lastMode = s0.trueMode;
    }
    var api = {
      el: el,
      show: function (on) { el.style.display = labels.style.display = on ? '' : 'none'; if (on) api.draw(); },
      draw: function () {
        size();
        if (lastMode !== s0.trueMode) setMode();
        var sunW = scl(D, s0fwd() * s0.t);
        for (var i = 0; i < PL.length; i++) {
          var tr = s0.trails[i], n = Math.min(tr.length, MAXP), st = tr.length - n, ps = lines[i].geometry.attributes.position, cs = lines[i].geometry.attributes.color;
          var col = new THREE.Color(PL[i][4]);
          for (var k = 0; k < n; k++) {
            var q = tf(sub(tr[st + k], sunW));
            ps.setXYZ(k, q.x * scaleK, q.y * scaleK, q.z * scaleK);
            var f = 0.08 + 0.92 * Math.pow(k / n, 1.6);
            cs.setXYZ(k, col.r * f, col.g * f, col.b * f);
          }
          ps.needsUpdate = cs.needsUpdate = true; lines[i].geometry.setDrawRange(0, n);
          var now = tf(sub(planetWorld(i, s0.t), sunW)).multiplyScalar(scaleK);
          balls[i].position.copy(now); balls[i].rotation.y += 0.02;
          place(Lpl[i], now.clone().add(new THREE.Vector3(0, RAD[i] + 0.35, 0)));
        }
        sun.rotation.y += 0.004;
        renderer.render(scene3, cam);
        place(Lsun, new THREE.Vector3(0, -0.95, 0));
        var tip = new THREE.Vector3(1, 0, 0).multiplyScalar(arrow3.line.scale.y + 0.9);
        Ldir.textContent = Wc < 640 ? 'Towards Cygnus · 230 km/s' : 'Towards Cygnus · 230 km/s round the Milky Way';
        place(Ldir, tip);
        if (Ldir.style.display !== 'none') Ldir.style.transform += ' translate(-100%,-20px)';
        place(Lang, arc.userData.mid || new THREE.Vector3());
        place(Lgal, new THREE.Vector3(-arrow3.line.scale.y * 1.1, 0, 0).add(nG.clone().multiplyScalar(-0.6)));
      }
    };
    ctl.addEventListener('change', function () { if (!playing && scene === 0) api.draw(); });
    window.addEventListener('resize', function () { if (scene === 0) api.draw(); });
    return api;
  }

  /* =========================================================
     Scene 1: the Sun round the Milky Way
     ========================================================= */
  var R0 = 8.18; // kpc, distance of the Sun from the centre (GRAVITY 2019)
  var VSUN = 230; // km/s
  var PAT = 25 * KMS_KPC_MYR; // spiral pattern speed, rad per Myr (estimates vary)
  var BAR = 40 * KMS_KPC_MYR; // bar pattern speed
  var s1 = { t: 0, speed: 5, pts: null, arms: null };
  function vrot(r) { return VSUN * (1 - Math.exp(-r / 1.1)); }
  // four main arms (log spirals, pitch 12°) plus the short Orion Spur where the Sun is
  var ARMS = [[0.0, 'Perseus'], [Math.PI / 2, 'Scutum–Centaurus'], [Math.PI, 'Sagittarius–Carina'], [3 * Math.PI / 2, 'Norma–Outer']];
  var KP = Math.tan(12 * DEG);
  function armXY(a0, r) { var th = a0 + Math.log(r / 3.6) / KP; return [r * Math.sin(th), r * Math.cos(th)]; }
  function s1build() {
    var pts = [];
    for (var i = 0; i < 2600; i++) {
      var r, ph, kind = rnd();
      if (kind < 0.42) { // arm stars
        var a = ARMS[Math.floor(rnd() * 4)][0];
        r = 3.6 + Math.pow(rnd(), 0.8) * 12.5;
        var xy = armXY(a, r);
        ph = Math.atan2(xy[0], xy[1]) + gauss() * 0.07; r += gauss() * 0.35;
        pts.push([Math.abs(r), ph, 0, rnd() < 0.3 ? '#9fc4ff' : '#dfe8ff']);
      } else if (kind < 0.84) { // disk
        r = -2.6 * Math.log(1 - rnd() * 0.995); ph = rnd() * TAU;
        if (r > 17) r = 17 * rnd();
        pts.push([r, ph, 0, rnd() < 0.5 ? '#f3e6c8' : '#cfd8ea']);
      } else { // bar and bulge: turn with the bar
        var u = gauss() * 3.2, v = gauss() * 0.9, ang = 27 * DEG;
        var x = u * Math.cos(ang) - v * Math.sin(ang), y = u * Math.sin(ang) + v * Math.cos(ang);
        pts.push([Math.sqrt(x * x + y * y), Math.atan2(x, y), 1, '#ffd9a0']);
      }
    }
    s1.pts = pts;
    // the arm glow, drawn once
    var c = document.createElement('canvas'); c.width = c.height = 900;
    var g = c.getContext('2d'), k = 900 / 36; // 36 kpc across
    g.globalCompositeOperation = 'lighter';
    ARMS.forEach(function (am) {
      for (var r = 3.6; r < 16.5; r += 0.05) {
        var p = armXY(am[0], r), x = 450 + p[0] * k, y = 450 + p[1] * k, rad = (0.9 + r * 0.05) * k;
        var gr = g.createRadialGradient(x, y, 0, x, y, rad);
        gr.addColorStop(0, 'rgba(120,150,255,0.05)'); gr.addColorStop(1, 'rgba(0,0,0,0)');
        g.fillStyle = gr; g.beginPath(); g.arc(x, y, rad, 0, TAU); g.fill();
      }
    });
    var core = g.createRadialGradient(450, 450, 0, 450, 450, 5 * k);
    core.addColorStop(0, 'rgba(255,214,150,0.55)'); core.addColorStop(1, 'rgba(0,0,0,0)');
    g.fillStyle = core; g.beginPath(); g.arc(450, 450, 5 * k, 0, TAU); g.fill();
    s1.arms = c;
  }
  // the Sun bobs through the disk; amplitude and period are rough (about 70 million years per full swing)
  var ZAMP = 230, ZPER = 70, ZPH = Math.asin(65 / 230);
  function drawScene1() {
    ctx.fillStyle = '#03050a'; ctx.fillRect(0, 0, W, H);
    stars(0.45);
    var t = s1.t, sc = Math.min(W, H) * 0.47 / 16.5, cx = W * 0.5, cy = small() ? H * 0.4 : H * 0.47;
    // the galaxy turns clockwise seen from galactic north
    ctx.save(); ctx.translate(cx, cy); ctx.rotate(PAT * t);
    var sz = 36 * sc; ctx.globalCompositeOperation = 'lighter';
    ctx.drawImage(s1.arms, -sz / 2, -sz / 2, sz, sz);
    ctx.restore(); ctx.globalCompositeOperation = 'source-over';
    for (var i = 0; i < s1.pts.length; i++) {
      var p = s1.pts[i], om = p[2] ? BAR : vrot(p[0]) * KMS_KPC_MYR / Math.max(p[0], 0.2);
      var ph = p[1] - om * t;
      var x = cx + p[0] * Math.sin(ph) * sc, y = cy + p[0] * Math.cos(ph) * sc;
      ctx.fillStyle = p[3]; ctx.globalAlpha = 0.75;
      ctx.fillRect(x, y, 1.3 * DPR, 1.3 * DPR);
    }
    ctx.globalAlpha = 1;
    // the Sun's orbit
    ctx.setLineDash([4 * DPR, 6 * DPR]); ctx.strokeStyle = 'rgba(255,211,107,.45)'; ctx.lineWidth = 1.2 * DPR;
    ctx.beginPath(); ctx.arc(cx, cy, R0 * sc, 0, TAU); ctx.stroke(); ctx.setLineDash([]);
    var om0 = VSUN * KMS_KPC_MYR / R0, ps = -om0 * t; // the Sun starts at the bottom and moves clockwise
    var sx = cx + R0 * Math.sin(ps) * sc, sy = cy + R0 * Math.cos(ps) * sc;
    glow(sx, sy, 22 * DPR, 'rgba(255,200,80,.7)');
    ctx.fillStyle = '#ffd36b'; ctx.beginPath(); ctx.arc(sx, sy, 5 * DPR, 0, TAU); ctx.fill();
    var tx = -Math.cos(ps), ty = Math.sin(ps); // direction of motion (clockwise on screen)
    arrow(sx, sy, sx + tx * 48 * DPR, sy + ty * 48 * DPR, 'rgba(0,224,255,.95)', 2);
    label('Sun (you are here)', sx + 12 * DPR, sy + 18 * DPR, '#ffd36b', 13);
    label('Galactic centre · Sagittarius A*', cx, cy - 16 * DPR, '#ffe2b0', 12, 'center');
    label('26,700 light years', cx + (sx - cx) * 0.5 + 8 * DPR, cy + (sy - cy) * 0.5, '#9aa6bc', 11);
    ctx.strokeStyle = 'rgba(154,166,188,.35)'; ctx.lineWidth = 1 * DPR; ctx.beginPath(); ctx.moveTo(cx, cy); ctx.lineTo(sx, sy); ctx.stroke();
    foot('Seen from above. Arms are a model; the speeds are real.', 'Seen from above · arms are a model');
    // side view inset: bobbing through the disk
    var iw = small() ? W - 24 * DPR : Math.min(W * 0.42, 330 * DPR), ih = 92 * DPR, ix = W - iw - 12 * DPR, iy = small() ? H - ih - 40 * DPR : 12 * DPR;
    ctx.fillStyle = 'rgba(16,22,34,.88)'; ctx.strokeStyle = '#263042'; ctx.lineWidth = 1 * DPR;
    ctx.beginPath(); ctx.rect(ix, iy, iw, ih); ctx.fill(); ctx.stroke();
    var midY = iy + ih * 0.56, zs = (ih * 0.3) / ZAMP;
    ctx.fillStyle = 'rgba(160,180,230,.18)'; ctx.fillRect(ix + 6 * DPR, midY - 500 * zs * 0.25, iw - 12 * DPR, 500 * zs * 0.5);
    ctx.strokeStyle = 'rgba(255,211,107,.85)'; ctx.lineWidth = 1.5 * DPR; ctx.beginPath();
    for (var k = 0; k <= 120; k++) {
      var tt = t - 100 + k * (200 / 120), zz = ZAMP * Math.sin(TAU * tt / ZPER + ZPH);
      var px = ix + 6 * DPR + (iw - 12 * DPR) * k / 120, py = midY - zz * zs;
      if (k === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py);
    }
    ctx.stroke();
    var zn = ZAMP * Math.sin(TAU * t / ZPER + ZPH);
    ctx.fillStyle = '#ffd36b'; ctx.beginPath(); ctx.arc(ix + iw / 2, midY - zn * zs, 3.5 * DPR, 0, TAU); ctx.fill();
    label(small() ? 'Side view: up and down through the disk' : 'Side view: the Sun rises and sinks through the disk', ix + 8 * DPR, iy + 13 * DPR, '#e8edf7', 11);
    var my = Math.round(t), lap = (om0 * t / TAU) * 100;
    var ev = '';
    if (t < -4400 && t > -4600) ev = ' · the Earth was forming, about 20 laps ago';
    else if (t < -520 && t > -560) ev = ' · the first animals with shells appear';
    else if (t < -60 && t > -72) ev = ' · 66 million years ago the dinosaurs died out';
    else if (t > 215 && t < 235) ev = ' · one more lap: back where we are now';
    else if (t < -215 && t > -245) ev = ' · about when the first dinosaurs lived: one lap ago';
    timeEl.textContent = (my >= 0 ? '+' : '−') + Math.abs(my).toLocaleString('en-US') + ' million years · ' + Math.abs(lap).toFixed(0) + '% of a lap' + ev;
  }

  /* =========================================================
     Scene 2: the Milky Way and Andromeda
     ========================================================= */
  var m31 = new Image(), m31ok = false, m31c = null;
  m31.onload = function () {
    // fade the photo's edges so it sits in the dark sky without a box
    var c = document.createElement('canvas'); c.width = m31.width; c.height = m31.height;
    var g = c.getContext('2d'); g.drawImage(m31, 0, 0);
    g.globalCompositeOperation = 'destination-in';
    g.translate(c.width / 2, c.height / 2); g.scale(1, c.height / c.width);
    var r = c.width * 0.5, gr = g.createRadialGradient(0, 0, r * 0.25, 0, 0, r);
    gr.addColorStop(0, 'rgba(0,0,0,1)'); gr.addColorStop(1, 'rgba(0,0,0,0)');
    g.fillStyle = gr; g.beginPath(); g.arc(0, 0, r, 0, TAU); g.fill();
    m31c = c; m31ok = true;
  };
  var s2 = { t: 0 };
  function drawScene2() {
    ctx.fillStyle = '#03050a'; ctx.fillRect(0, 0, W, H);
    stars(0.8);
    if (!s1.arms) s1build();
    var portrait = H > W * 1.1;
    var ax = portrait ? W * 0.5 : W * 0.25, ay = portrait ? H * 0.72 : H * 0.5;
    var bx = portrait ? W * 0.5 : W * 0.76, by = portrait ? H * 0.26 : H * 0.46;
    var gsz = Math.min(W, H) * (portrait ? 0.5 : 0.44);
    // Milky Way (our model, seen tilted)
    ctx.save(); ctx.translate(ax, ay); ctx.scale(1, 0.55); ctx.rotate(s2.t * 0.02);
    ctx.globalCompositeOperation = 'lighter'; ctx.drawImage(s1.arms, -gsz / 2, -gsz / 2, gsz, gsz);
    ctx.restore(); ctx.globalCompositeOperation = 'source-over';
    label('Milky Way (us)', ax, ay + gsz * 0.33, '#e8edf7', 14, 'center');
    // Andromeda (real photo)
    var asz = gsz * 1.15;
    if (m31ok) {
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      var iw = asz, ih = asz * m31.height / m31.width;
      ctx.drawImage(m31c, bx - iw / 2, by - ih / 2, iw, ih);
      ctx.restore();
    } else glow(bx, by, asz * 0.3, 'rgba(220,200,255,.35)');
    label('Andromeda', bx, by + asz * 0.36, '#e8edf7', 14, 'center');
    // satellites
    var lx = ax + gsz * 0.42, ly = ay + gsz * 0.18;
    glow(lx, ly, 14 * DPR, 'rgba(200,220,255,.6)'); label('LMC', lx + 14 * DPR, ly, '#9aa6bc', 11);
    var mx = bx - asz * 0.42, my = by - asz * 0.2;
    glow(mx, my, 12 * DPR, 'rgba(200,220,255,.6)'); label('M33', mx - 14 * DPR, my, '#9aa6bc', 11, 'right');
    // distance and approach
    var dx = bx - ax, dy = by - ay, L = Math.sqrt(dx * dx + dy * dy), ux = dx / L, uy = dy / L;
    var pulse = (s2.t * 0.25) % 1;
    ctx.setLineDash([5 * DPR, 7 * DPR]); ctx.strokeStyle = 'rgba(154,166,188,.5)'; ctx.lineWidth = 1 * DPR;
    ctx.beginPath(); ctx.moveTo(ax + ux * gsz * 0.3, ay + uy * gsz * 0.3); ctx.lineTo(bx - ux * asz * 0.3, by - uy * asz * 0.3); ctx.stroke(); ctx.setLineDash([]);
    var mxp = (ax + bx) / 2, myp = (ay + by) / 2;
    arrow(mxp - ux * (30 + pulse * 20) * DPR, myp - uy * (30 + pulse * 20) * DPR, mxp - ux * (8 + pulse * 20) * DPR, myp - uy * (8 + pulse * 20) * DPR, 'rgba(0,224,255,.9)', 2);
    arrow(mxp + ux * (30 + pulse * 20) * DPR, myp + uy * (30 + pulse * 20) * DPR, mxp + ux * (8 + pulse * 20) * DPR, myp + uy * (8 + pulse * 20) * DPR, 'rgba(0,224,255,.9)', 2);
    if (portrait) { label('2.5 million light years', mxp + 12 * DPR, myp - 9 * DPR, '#7fe8ff', 12); label('closing at about 110 km/s', mxp + 12 * DPR, myp + 9 * DPR, '#7fe8ff', 12); }
    else label('2.5 million light years · closing at about 110 km/s', mxp, myp - 18 * DPR, '#7fe8ff', 12, 'center');
    foot('Sizes and distance not to scale', 'Not to scale');
    timeEl.textContent = 'Andromeda is about 2.5 million light years away';
  }

  /* =========================================================
     Scene 3: where everything is heading, on the real sky
     ========================================================= */
  var sky = new Image(), skyok = false;
  sky.onload = function () { skyok = true; };
  // galactic longitude, latitude, label, speed, constellation, colour
  var HEAD = [
    [90, 0, 'Our path round the Milky Way', '230 km/s', 'Cygnus', '#00e0ff'],
    [57, 22, 'Sun among the nearby stars', 'about 20 km/s', 'Hercules', '#9fc4ff'],
    [264.0, 48.3, 'Sun against the Big Bang’s afterglow', '370 km/s', 'Crater', '#ffd36b'],
    [276, 30, 'Whole Local Group against the afterglow', 'about 620 km/s', 'Hydra', '#ff9b6b'],
    [307, 9, 'Great Attractor (roughly)', 'pulls on us all', 'Centaurus', '#ff6ad5'],
    [121.2, -21.6, 'Andromeda', 'closing at 110 km/s', 'Andromeda', '#c9b8ff'],
    [0, 0, 'Galactic centre', '26,700 light years', 'Sagittarius', '#ffe2b0']];
  var s3 = { t: 0 };
  function drawScene3() {
    ctx.fillStyle = '#03050a'; ctx.fillRect(0, 0, W, H);
    var mw = W, mh = W / 2, lc = 0;
    if (mh > H) { mh = H; mw = H * 2; }
    if (small()) { mw = W * 360 / 245; mh = mw / 2; lc = 12; } // show galactic longitude -110°..135° on narrow screens
    var ox = W / 2 - mw / 2 + mw * lc / 360, oy = (H - mh) / 2;
    if (skyok) ctx.drawImage(sky, ox, oy, mw, mh); else stars(0.8);
    function xy(l, b) { var L = ((l + 180) % 360 + 360) % 360 - 180; return [ox + mw * (0.5 - L / 360), oy + mh * (0.5 - b / 180)]; }
    var pulse = (Math.sin(s3.t * 2.2) + 1) / 2;
    var sm = small();
    for (var i = 0; i < HEAD.length; i++) {
      var h = HEAD[i], p = xy(h[0], h[1]);
      ctx.strokeStyle = h[5]; ctx.lineWidth = 2 * DPR;
      ctx.globalAlpha = 0.4 + 0.6 * pulse;
      ctx.beginPath(); ctx.arc(p[0], p[1], (9 + pulse * 6) * DPR, 0, TAU); ctx.stroke();
      ctx.globalAlpha = 1;
      ctx.fillStyle = h[5]; ctx.beginPath(); ctx.arc(p[0], p[1], 3.5 * DPR, 0, TAU); ctx.fill();
      var right = p[0] > W * 0.7, up = (i % 2 === 0) ? -1 : 1;
      if (sm) label(String(i + 1), p[0] + 12 * DPR, p[1] - 12 * DPR, h[5], 12);
      else label(h[2], p[0] + (right ? -14 : 14) * DPR, p[1] + up * 14 * DPR, h[5], 12.5, right ? 'right' : 'left');
      if (!sm) label(h[3] + ' · ' + h[4], p[0] + (right ? -14 : 14) * DPR, p[1] + up * 14 * DPR + 15 * DPR, '#c3cbe0', 11, right ? 'right' : 'left');
    }
    foot('The whole sky in galactic coordinates · photo ESO/S. Brunier', 'Whole sky · photo ESO/S. Brunier');
    timeEl.textContent = 'Every arrow here is a real measured direction';
  }

  /* ---------- scenes, controls ---------- */
  var SCENES = [
    { speeds: [[0.5, '½ year/s'], [2, '2 years/s'], [10, '10 years/s']], def: 2, draw: drawScene0, step: function (dt) { s0step(dt * s0.speed); },
      text: '<h2>The planets come along for the ride</h2><p>The Sun carries every planet with it at about 230 km/s round the Milky Way. The planets’ orbits are tilted about 60° to that path, so each planet traces a stretched spiral. Drag to turn the view; the gold disk is the planets’ orbit plane and the faint grid is the plane of the Milky Way.</p>' },
    { speeds: [[-20, '◀ 20 million years/s'], [1, '1 million years/s'], [5, '5 million years/s'], [20, '20 million years/s']], def: 5, draw: drawScene1, step: function (dt) { s1.t += dt * s1.speed; },
      text: '<h2>One lap takes about 225 million years</h2><p>The Sun is about 26,700 light years from the centre and moves at about 230 km/s, clockwise as seen from above. Stars nearer the centre take less time for a lap, so the disk slowly shears. Since the Earth formed, the Sun has gone round about 20 times.</p>' },
    { speeds: [], def: 0, draw: drawScene2, step: function (dt) { s2.t += dt; },
      text: '<h2>Will we hit Andromeda?</h2><p>Andromeda and the Milky Way are falling towards each other at about 110 km/s. For years the forecast was a crash in about 4.5 billion years. A 2025 study with Hubble and Gaia data found only about a 2% chance of a head-on crash in the next 4 to 5 billion years, and about a 50% chance that the two merge within 10 billion years.</p>' },
    { speeds: [], def: 0, draw: drawScene3, step: function (dt) { s3.t += dt; },
      text: '<h2>Where are we all going?</h2><p>Measured against the afterglow of the Big Bang (the cosmic microwave background), the Sun moves at 370 km/s towards the constellation Crater, and our whole Local Group of galaxies at about 620 km/s towards Hydra and Centaurus, drawn by the Great Attractor and the mass beyond it.</p><ol class="jylegend">' + HEAD.map(function (h) { return '<li><b style="color:' + h[5] + '">' + h[2] + '</b>: ' + h[3] + ', towards ' + h[4] + '</li>'; }).join('') + '</ol>' }];

  // jump to moments in the Sun's past and future
  var MOMENTS = [[-4500, 'Earth forms'], [-541, 'First animals with shells'], [-230, 'First dinosaurs'], [-66, 'Dinosaurs die out'], [0, 'Today'], [225, 'One lap from now']];
  var momentsEl = document.createElement('div'); momentsEl.className = 'umchips jymoments'; momentsEl.setAttribute('role', 'group'); momentsEl.setAttribute('aria-label', 'Jump to a moment');
  MOMENTS.forEach(function (m) {
    var b = document.createElement('button'); b.type = 'button';
    b.innerHTML = '<b>' + (m[0] === 0 ? 'Now' : (m[0] < 0 ? '−' : '+') + (Math.abs(m[0]) >= 1000 ? (Math.abs(m[0]) / 1000) + ' billion' : Math.abs(m[0]) + ' million') + ' yr') + '</b> ' + m[1];
    b.addEventListener('click', function () { s1.t = m[0]; if (playing) togglePlay(); frame(); });
    momentsEl.appendChild(b);
  });
  speedsEl.parentNode.insertBefore(momentsEl, speedsEl.nextSibling);

  function setSpeed(v) {
    if (scene === 0) s0.speed = v; else if (scene === 1) s1.speed = v;
    renderSpeeds();
  }
  function renderSpeeds() {
    var sc = SCENES[scene], cur = scene === 0 ? s0.speed : s1.speed;
    speedsEl.innerHTML = '';
    sc.speeds.forEach(function (sp) {
      var b = document.createElement('button'); b.type = 'button'; b.textContent = sp[1];
      if (sp[0] === cur) b.className = 'on';
      b.setAttribute('aria-pressed', sp[0] === cur ? 'true' : 'false');
      b.addEventListener('click', function () { setSpeed(sp[0]); if (!playing) togglePlay(); });
      speedsEl.appendChild(b);
    });
    speedsEl.hidden = !sc.speeds.length;
  }
  function setScene(i) {
    scene = i;
    document.querySelectorAll('[data-scene]').forEach(function (b) {
      var on = +b.getAttribute('data-scene') === i;
      b.classList.toggle('on', on); b.setAttribute('aria-pressed', on ? 'true' : 'false');
    });
    info.innerHTML = SCENES[i].text;
    if (g3) g3.show(i === 0);
    trueBtn.hidden = i !== 0; nowBtn.hidden = i > 1; momentsEl.hidden = i !== 1;
    if (i === 1 && !s1.pts) s1build();
    if (i === 2 && !m31.src) m31.src = (document.body.getAttribute('data-root') || '') + 'img/space/gx-andromeda.webp';
    if (i === 3 && !sky.src) sky.src = (document.body.getAttribute('data-root') || '') + 'img/space/gx-milkyway.webp';
    cv.setAttribute('aria-label', ['The planets’ spiral paths as the Sun moves', 'The Sun’s orbit round the Milky Way', 'The Milky Way and the Andromeda galaxy', 'Where we are heading, on a map of the whole sky'][i]);
    renderSpeeds(); frame();
  }
  function togglePlay() {
    playing = !playing;
    playBtn.textContent = playing ? '❚❚ Pause' : '▶ Play';
    playBtn.setAttribute('aria-pressed', playing ? 'false' : 'true');
    if (playing) { last = 0; requestAnimationFrame(loop); }
  }
  document.querySelectorAll('[data-scene]').forEach(function (b) {
    b.addEventListener('click', function () { setScene(+b.getAttribute('data-scene')); });
  });
  playBtn.addEventListener('click', togglePlay);
  nowBtn.addEventListener('click', function () { if (scene === 0) { s0.t = 0; s0reset(); } else { s1.t = 0; } frame(); });
  trueBtn.addEventListener('click', function () {
    s0.trueMode = !s0.trueMode;
    trueBtn.textContent = s0.trueMode ? 'Show squeezed' : 'Show true proportions';
    trueBtn.setAttribute('aria-pressed', s0.trueMode ? 'true' : 'false');
    s0reset(); frame();
  });

  // drag to turn the view in scene 0
  var drag = null;
  cv.addEventListener('pointerdown', function (e) { if (scene !== 0) return; drag = [e.clientX, e.clientY, s0.yaw, s0.pitch]; cv.setPointerCapture(e.pointerId); });
  cv.addEventListener('pointermove', function (e) {
    if (!drag) return;
    s0.yaw = drag[2] + (e.clientX - drag[0]) * 0.008;
    s0.pitch = Math.max(-1.4, Math.min(1.4, drag[3] + (e.clientY - drag[1]) * 0.008));
    if (!playing) frame();
  });
  cv.addEventListener('pointerup', function () { drag = null; });
  cv.addEventListener('pointercancel', function () { drag = null; });
  cv.addEventListener('keydown', function (e) {
    if (scene !== 0) return;
    if (e.key === 'ArrowLeft') s0.yaw -= 0.1; else if (e.key === 'ArrowRight') s0.yaw += 0.1;
    else if (e.key === 'ArrowUp') s0.pitch = Math.max(-1.4, s0.pitch - 0.1); else if (e.key === 'ArrowDown') s0.pitch = Math.min(1.4, s0.pitch + 0.1);
    else return;
    e.preventDefault(); if (!playing) frame();
  });

  function frame() { if (!W) resize(); SCENES[scene].draw(); }
  var last = 0;
  function loop(ts) {
    if (!playing) return;
    if (onScreen && !document.hidden) {
      var dt = last ? Math.min(0.05, (ts - last) / 1000) : 0;
      last = ts;
      SCENES[scene].step(dt);
      frame();
    } else last = 0;
    requestAnimationFrame(loop);
  }
  if ('IntersectionObserver' in window) {
    new IntersectionObserver(function (en) { onScreen = en[0].isIntersecting; }).observe(cv);
  }
  resize(); s0reset();
  var g3 = make3d();
  document.querySelectorAll('[data-jygo]').forEach(function (b) {
    b.addEventListener('click', function () {
      setScene(+b.getAttribute('data-jygo'));
      var top = cv.getBoundingClientRect().top + window.scrollY - 90;
      window.scrollTo({ top: top, behavior: reduce ? 'auto' : 'smooth' });
    });
  });

  /* ---------- your own speeds: the Earth's spin where you are, and its speed round the Sun today ---------- */
  var A = window.ASTRYL || {}, cities = A.cities || [], citySel = $('jyCity');
  function earthSpeedToday() {
    // Kepler: eccentricity 0.0167, perihelion about 3 January; vis-viva gives the speed
    var d = (Date.now() - Date.UTC(2026, 0, 3, 17)) / 86400000, M = TAU * d / 365.2596, e = 0.0167, E = M;
    for (var k = 0; k < 6; k++) E = M + e * Math.sin(E);
    var r = 1 - e * Math.cos(E);
    return 29.7847 * Math.sqrt(2 / r - 1);
  }
  function mine() {
    var id = citySel ? citySel.value : '', c = cities.filter(function (x) { return x[0] === id; })[0];
    var spin = c ? 1674.4 * Math.cos(c[3] * DEG) : 1674.4;
    var e1 = $('jySpin'), e2 = $('jySpinNote'), e3 = $('jyOrbit'), e4 = $('jyOrbitNote');
    if (e1) e1.textContent = Math.round(spin).toLocaleString('en-US') + ' km/h';
    if (e2) e2.textContent = c ? 'You in ' + c[1] + ', carried east by the Earth’s spin' : 'At the equator. Pick your city to see your own speed';
    var v = earthSpeedToday();
    if (e3) e3.textContent = v.toFixed(2) + ' km/s';
    if (e4) e4.textContent = 'Earth round the Sun today (' + Math.round(v * 3600).toLocaleString('en-US') + ' km/h). Fastest in early January, slowest in early July';
  }
  if (citySel && cities.length) {
    var saved = ''; try { saved = JSON.parse(localStorage.getItem('astryl-city') || '""'); } catch (e) { }
    citySel.innerHTML = '<option value="">Choose your city</option>' + cities.slice().sort(function (a, b) { return a[1] < b[1] ? -1 : 1; }).map(function (c) { return '<option value="' + c[0] + '">' + c[1] + ', ' + c[2] + '</option>'; }).join('');
    if (saved) citySel.value = saved;
    citySel.addEventListener('change', function () { try { if (citySel.value) localStorage.setItem('astryl-city', JSON.stringify(citySel.value)); } catch (e) { } mine(); });
  }
  mine();
  var shareBtn = $('jyShare');
  if (shareBtn) shareBtn.addEventListener('click', function () {
    var km = Math.round((Date.now() - t0) / 1000 * 230);
    var text = 'Since I opened this page I have travelled ' + km.toLocaleString('en-US') + ' km round the Milky Way, without leaving my chair.';
    var url = location.href.split('#')[0];
    if (navigator.share) navigator.share({ title: document.title, text: text, url: url }).catch(function () { });
    else if (navigator.clipboard) navigator.clipboard.writeText(text + ' ' + url).then(function () { var o = shareBtn.textContent; shareBtn.textContent = '✓ Copied'; setTimeout(function () { shareBtn.textContent = o; }, 2000); }).catch(function () { });
  });
  playBtn.textContent = playing ? '❚❚ Pause' : '▶ Play';
  setScene(0);
  if (playing) requestAnimationFrame(loop);
})();
