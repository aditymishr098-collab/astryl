/* Astryl: "The journey", one continuous 3D flight outwards, from the Sun and its planets
   to the stars around us, the Milky Way, the Local Group and the flow towards the Great Attractor.
   Built with three.js only when the visitor presses Play.

   One frame of reference for everything: galactic coordinates in light years with the Sun at the
   origin; x points to the centre of the Milky Way, y the way the Sun goes round it (towards Cygnus),
   z to the galaxy's north pole. The camera "zooms" by scaling the world: z10 is log10 of the size of
   the view in light years. Each level fades in and out over its own range of sizes.
   Real directions and distances; sizes of planets and galaxies are drawn larger so they can be seen. */
(function () {
  'use strict';
  var box = document.getElementById('jyJourney');
  if (!box) return;
  var playBtn = box.querySelector('[data-jj=play]'), ctlBtn = box.querySelector('[data-jj=play2]');
  var DEG = Math.PI / 180, TAU = Math.PI * 2;
  var reduce = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;

  function webgl() { try { var c = document.createElement('canvas'); return !!(c.getContext('webgl') || c.getContext('experimental-webgl')); } catch (e) { return false; } }
  if (!window.THREE || !webgl()) { box.classList.add('nogl'); return; }

  // galactic longitude/latitude (degrees) and distance (light years) to x, y, z
  function gal(l, b, d) { l *= DEG; b *= DEG; return new THREE.Vector3(d * Math.cos(b) * Math.cos(l), d * Math.cos(b) * Math.sin(l), d * Math.sin(b)); }
  var seed = 3; function rnd() { seed = (seed * 16807) % 2147483647; return seed / 2147483647; }
  function gauss() { return (rnd() + rnd() + rnd() + rnd() - 2) / 2; }
  function smooth(a, b, x) { var t = Math.max(0, Math.min(1, (x - a) / (b - a))); return t * t * (3 - 2 * t); }
  function win(z, a, b, c, d) { return smooth(a, b, z) * (1 - smooth(c, d, z)); }

  // the chapters: size of the view (log10 light years), where to look, and the caption
  var CH = [
    { z: -3.75, look: [0, 0, 0], cap: 'Our <b>Solar System</b>', sub: 'The planets follow the Sun at 230 km/s. Their orbits are tilted about 60° to its path.' },
    { z: 1.55, look: [0, 0, 0], cap: 'Our Sun, with <b>countless others</b>', sub: 'Every star near us is moving too. Together they all go round the Milky Way.' },
    { z: 5.0, look: [13000, 0, 0], cap: 'The <b>Milky Way</b>', sub: 'We are 26,000 light years from the centre. One lap takes about 230 million years.' },
    { z: 6.6, look: [600000, 900000, -400000], cap: 'The <b>Local Group</b>', sub: 'Andromeda, 2.5 million light years away, is coming towards us at about 110 km/s.' },
    { z: 8.65, look: [50e6, -60e6, 12e6], cap: 'Drifting towards the <b>Great Attractor</b>', sub: 'Our whole Local Group moves at about 600 km/s, with thousands of galaxies flowing the same way.' },
    { z: 9.35, look: [120e6, -150e6, 80e6], cap: 'And beyond: <b>the unknown</b>', sub: 'Farther still, the Shapley Supercluster pulls on all of us. The universe we can see is 93 billion light years across.' }
  ];
  var HOLD = 4.8, MOVE = 3.6; // seconds on each chapter and between chapters

  var started = false, api = null;
  function start() {
    if (started) { if (api) api.toggle(); return; }
    started = true; box.classList.add('on');
    api = build();
  }
  if (playBtn) playBtn.addEventListener('click', start);
  if (ctlBtn) ctlBtn.addEventListener('click', start);

  function build() {
    var stage = box.querySelector('.jjstage');
    var renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
    renderer.outputEncoding = THREE.sRGBEncoding;
    var cv = renderer.domElement; cv.className = 'jjcv'; cv.setAttribute('aria-hidden', 'true');
    stage.insertBefore(cv, stage.firstChild);
    var scene = new THREE.Scene();
    var camera = new THREE.PerspectiveCamera(50, 1.6, 0.01, 5000);
    var VIEW = 30; // the camera sits about this far from what it looks at, in scene units

    var capEl = box.querySelector('.jjcap'), subEl = box.querySelector('.jjsub'), dots = box.querySelector('.jjdots'), bar = box.querySelector('.jjbar i');
    var labelBox = box.querySelector('.jjlabels');

    function dotTex(soft) {
      var c = document.createElement('canvas'); c.width = c.height = 64; var x = c.getContext('2d');
      var g = x.createRadialGradient(32, 32, 0, 32, 32, 32);
      g.addColorStop(0, 'rgba(255,255,255,1)'); g.addColorStop(soft ? 0.25 : 0.4, 'rgba(255,255,255,' + (soft ? 0.45 : 0.9) + ')'); g.addColorStop(1, 'rgba(255,255,255,0)');
      x.fillStyle = g; x.fillRect(0, 0, 64, 64); return new THREE.CanvasTexture(c);
    }
    var DOT = dotTex(false), GLOW = dotTex(true);
    function points(pos, col, size, opacity, glow) {
      var g = new THREE.BufferGeometry();
      g.setAttribute('position', new THREE.BufferAttribute(pos, 3));
      g.setAttribute('color', new THREE.BufferAttribute(col, 3));
      var m = new THREE.PointsMaterial({ size: size, map: glow ? GLOW : DOT, vertexColors: true, transparent: true, opacity: opacity, depthWrite: false, blending: THREE.AdditiveBlending, sizeAttenuation: false });
      var p = new THREE.Points(g, m); p.frustumCulled = false; return p;
    }
    function label(text, cls) { var d = document.createElement('div'); d.className = 'jjl' + (cls ? ' ' + cls : ''); d.textContent = text; labelBox.appendChild(d); return d; }

    // far background stars, always there
    (function () {
      var n = 1800, pos = new Float32Array(n * 3), col = new Float32Array(n * 3);
      for (var i = 0; i < n; i++) { var u = rnd() * 2 - 1, t = rnd() * TAU, q = Math.sqrt(1 - u * u); pos.set([q * Math.cos(t) * 2000, q * Math.sin(t) * 2000, u * 2000], i * 3); var c = 0.35 + rnd() * 0.4; col.set([c, c, c * 1.05], i * 3); }
      scene.add(points(pos, col, 1.6, 0.8));
    })();

    var levels = [];
    function level(group, unit, a, b, c, d) { scene.add(group); var L = { g: group, unit: unit, w: [a, b, c, d], mats: [], labels: [] }; levels.push(L); return L; }
    function track(L, obj) { obj.traverse(function (o) { if (o.material) { o.material.transparent = true; o.material.userData.base = o.material.opacity; L.mats.push(o.material); } }); L.g.add(obj); }

    /* ---------- level 1: the Solar System, the planets' spiral paths behind the moving Sun (units: AU, shown squeezed) */
    var AU = 1.581e-5;
    var SOL = level(new THREE.Group(), AU, -9, -8, -3.6, -2.9);
    var nE = gal(96.38, 29.81, 1).normalize(); // the ecliptic's north pole in galactic coordinates
    var eA = new THREE.Vector3(0, 0, 1).cross(nE).normalize(), eB = nE.clone().cross(eA).normalize();
    var PLN = [['Mercury', 0.62, 0.24, '#b9b2a7', 0.09], ['Venus', 0.85, 0.615, '#e8c98c', 0.13], ['Earth', 1.0, 1.0, '#6fa8ff', 0.14], ['Mars', 1.23, 1.88, '#ff7a4d', 0.11], ['Jupiter', 2.28, 11.86, '#e2b98a', 0.28], ['Saturn', 3.09, 29.46, '#e9d29a', 0.25]];
    var SUNV = 0.9; // squeezed AU per year, so the spiral is easy to see
    var sunMesh = new THREE.Mesh(new THREE.SphereGeometry(0.22, 32, 24), new THREE.MeshBasicMaterial({ color: 0xffd27a }));
    track(SOL, sunMesh);
    var sunGlow = new THREE.Sprite(new THREE.SpriteMaterial({ map: GLOW, color: 0xffc860, blending: THREE.AdditiveBlending, depthWrite: false, transparent: true, opacity: 0.9 }));
    sunGlow.scale.set(1.6, 1.6, 1); track(SOL, sunGlow);
    var trails = [], balls = [];
    PLN.forEach(function (p) {
      var n = 900, g = new THREE.BufferGeometry();
      g.setAttribute('position', new THREE.BufferAttribute(new Float32Array(n * 3), 3));
      g.setAttribute('color', new THREE.BufferAttribute(new Float32Array(n * 3), 3));
      var ln = new THREE.Line(g, new THREE.LineBasicMaterial({ vertexColors: true, transparent: true, opacity: 1, blending: THREE.AdditiveBlending, depthWrite: false }));
      ln.frustumCulled = false; track(SOL, ln); trails.push(ln);
      var b = new THREE.Mesh(new THREE.SphereGeometry(p[4] * 0.5, 16, 12), new THREE.MeshBasicMaterial({ color: p[3] }));
      track(SOL, b); balls.push(b);
    });
    var solLabels = PLN.map(function (p) { return label(p[0]); }); var sunLab = label('Sun', 'sun');
    SOL.labels = solLabels.concat([sunLab]);
    function planetAt(i, t) { // squeezed AU, relative to where the Sun is now
      var p = PLN[i], a = (t / p[2]) * TAU + i * 1.7;
      return eA.clone().multiplyScalar(Math.cos(a) * p[1]).add(eB.clone().multiplyScalar(Math.sin(a) * p[1]));
    }
    function updateSolar(t) {
      for (var i = 0; i < PLN.length; i++) {
        var ln = trails[i], ps = ln.geometry.attributes.position, cs = ln.geometry.attributes.color, n = ps.count, span = Math.min(40, PLN[i][2] * 2.2), col = new THREE.Color(PLN[i][3]);
        for (var k = 0; k < n; k++) {
          var dt = span * (1 - k / (n - 1)), q = planetAt(i, t - dt);
          ps.setXYZ(k, q.x, q.y - SUNV * dt, q.z);
          var f = Math.pow(k / (n - 1), 1.5); cs.setXYZ(k, col.r * f, col.g * f, col.b * f);
        }
        ps.needsUpdate = cs.needsUpdate = true;
        balls[i].position.copy(planetAt(i, t));
      }
    }

    /* ---------- level 2: the stars around us, each moving, all drifting round the galaxy together (units: light years) */
    var NEAR = level(new THREE.Group(), 1, -4.2, -3.2, 3.3, 4.1);
    var NS = 2600, nPos = new Float32Array(NS * 3), nCol = new Float32Array(NS * 3), nVel = [];
    for (var i = 0; i < NS; i++) {
      var r = 6 + Math.pow(rnd(), 0.6) * 260, th = rnd() * TAU, z = gauss() * 50;
      nPos.set([Math.cos(th) * r, Math.sin(th) * r, z], i * 3);
      var k = rnd(), c = k < 0.7 ? [1, 0.62, 0.42] : k < 0.9 ? [1, 0.9, 0.72] : [0.72, 0.82, 1];
      var br = 0.45 + rnd() * 0.55; nCol.set([c[0] * br, c[1] * br, c[2] * br], i * 3);
      nVel.push(new THREE.Vector3(gauss() * 0.35, 1 + gauss() * 0.35, gauss() * 0.2)); // relative drift, mostly along the galaxy's spin
    }
    var nearPts = points(nPos, nCol, 3.2, 1); track(NEAR, nearPts);
    // short trails behind each star, showing which way it moves
    var trPos = new Float32Array(NS * 6), trCol = new Float32Array(NS * 6);
    var trG = new THREE.BufferGeometry(); trG.setAttribute('position', new THREE.BufferAttribute(trPos, 3)); trG.setAttribute('color', new THREE.BufferAttribute(trCol, 3));
    var nearTr = new THREE.LineSegments(trG, new THREE.LineBasicMaterial({ vertexColors: true, transparent: true, opacity: 0.55, blending: THREE.AdditiveBlending, depthWrite: false }));
    nearTr.frustumCulled = false; track(NEAR, nearTr);
    var NAMED = [['Alpha Centauri', 315.7, -0.7, 4.37], ['Sirius', 227.2, -8.9, 8.6], ['Procyon', 213.7, 13.0, 11.5], ['Altair', 47.7, -8.9, 16.7], ['Vega', 67.4, 19.2, 25], ['Arcturus', 15.1, 69.1, 36.7]];
    var namedPos = NAMED.map(function (s) { return gal(s[1], s[2], s[3]); });
    var namedPts = (function () { var p = new Float32Array(NAMED.length * 3), c = new Float32Array(NAMED.length * 3); namedPos.forEach(function (v, i) { p.set([v.x, v.y, v.z], i * 3); c.set([1, 0.95, 0.85], i * 3); }); return points(p, c, 6, 1, true); })();
    track(NEAR, namedPts);
    var nearLabels = NAMED.map(function (s) { return label(s[0], 'star'); }); var youLab = label('Sun (you are here)', 'you');
    NEAR.labels = nearLabels.concat([youLab]);
    var sunDot = points(new Float32Array([0, 0, 0]), new Float32Array([1, 0.85, 0.5]), 9, 1, true); track(NEAR, sunDot);
    function updateNear(t) {
      for (var i = 0; i < NS; i++) {
        var v = nVel[i], x = nPos[i * 3], y = nPos[i * 3 + 1], zz = nPos[i * 3 + 2], L = 7 + 4 * Math.sin(i);
        trPos.set([x, y, zz, x - v.x * L, y - v.y * L, zz - v.z * L], i * 6);
        trCol.set([nCol[i * 3] * 0.8, nCol[i * 3 + 1] * 0.8, nCol[i * 3 + 2] * 0.8, 0, 0, 0], i * 6);
      }
      trG.attributes.position.needsUpdate = trG.attributes.color.needsUpdate = true;
    }

    /* ---------- level 3: the Milky Way (units: light years; the centre 26,000 ly away along +x) */
    function galaxy(n, R, arms, tiltQ, warmCore) {
      var pos = new Float32Array(n * 3), col = new Float32Array(n * 3);
      for (var i = 0; i < n; i++) {
        var bulge = rnd() < 0.18, x, y, z, c;
        if (bulge) { var rr = Math.abs(gauss()) * R * 0.12; var a0 = rnd() * TAU; x = Math.cos(a0) * rr * 1.6; y = Math.sin(a0) * rr; z = gauss() * R * 0.05; c = [1, 0.82, 0.55]; }
        else {
          var arm = Math.floor(rnd() * arms), rad = R * (0.12 + Math.pow(rnd(), 0.75) * 0.88);
          var ang = arm * TAU / arms + Math.log(rad / (R * 0.12)) * 2.4 + gauss() * 0.32;
          x = Math.cos(ang) * rad; y = Math.sin(ang) * rad; z = gauss() * R * 0.015;
          c = rnd() < 0.55 ? [0.62, 0.74, 1] : [1, 0.86, 0.7];
          if (rnd() < 0.04) c = [1, 0.45, 0.6]; // star-forming regions
        }
        var v = new THREE.Vector3(x, y, z); if (tiltQ) v.applyQuaternion(tiltQ);
        pos.set([v.x, v.y, v.z], i * 3); var b = 0.25 + rnd() * 0.5; col.set([c[0] * b, c[1] * b, c[2] * b], i * 3);
      }
      var g = new THREE.Group(); g.add(points(pos, col, warmCore ? 1.8 : 1.6, 0.42));
      var core = new THREE.Sprite(new THREE.SpriteMaterial({ map: GLOW, color: 0xffd9a0, blending: THREE.AdditiveBlending, depthWrite: false, transparent: true, opacity: 0.85 }));
      core.scale.set(R * 0.45, R * 0.45, 1); core.material.opacity = 0.6; g.add(core);
      return g;
    }
    var MW = level(new THREE.Group(), 1, 2.6, 3.6, 7.6, 8.2);
    var mwDisk = galaxy(42000, 50000, 4, null, true);
    var mwSpin = new THREE.Group(); mwSpin.add(mwDisk); mwSpin.position.set(26000, 0, 0); track(MW, mwSpin);
    var mwSun = points(new Float32Array([0, 0, 0]), new Float32Array([1, 0.9, 0.5]), 9, 1, true); track(MW, mwSun);
    var mwLab = label('Sun', 'you'), mwCen = label('Centre: Sagittarius A*', 'star');
    MW.labels = [mwLab, mwCen];

    /* ---------- level 4: the Local Group */
    var LG = level(new THREE.Group(), 1, 5.6, 6.2, 8.0, 8.6);
    var m31 = gal(121.17, -21.57, 2.5e6), m33 = gal(133.61, -31.33, 2.73e6), lmc = gal(280.47, -32.89, 160000), smc = gal(302.8, -44.3, 200000);
    var tq = new THREE.Quaternion().setFromEuler(new THREE.Euler(1.1, 0.4, 0.2));
    var andromeda = galaxy(16000, 380000, 2, tq, true); andromeda.position.copy(m31); track(LG, andromeda);
    var tri = galaxy(4000, 140000, 2, new THREE.Quaternion().setFromEuler(new THREE.Euler(0.6, -0.5, 0)), false); tri.position.copy(m33); track(LG, tri);
    var dw = (function () { var arr = [lmc, smc], n = 40; for (var i = 0; i < n; i++) arr.push(gal(rnd() * 360, gauss() * 50, 2e5 + rnd() * 2.6e6)); var p = new Float32Array(arr.length * 3), c = new Float32Array(arr.length * 3); arr.forEach(function (v, i) { p.set([v.x, v.y, v.z], i * 3); c.set([0.75, 0.8, 1], i * 3); }); return points(p, c, 3, 0.9, true); })();
    track(LG, dw);
    var arrowLG = new THREE.ArrowHelper(m31.clone().negate().normalize(), m31.clone().multiplyScalar(0.82), 3.2e5, 0x7fe8ff, 1.1e5, 6e4); track(LG, arrowLG);
    var lgLabels = [label('Andromeda (M31)', 'star'), label('Triangulum (M33)', 'star'), label('Milky Way', 'you')];
    LG.labels = lgLabels;

    /* ---------- level 5: galaxies flowing towards the Great Attractor (units: light years) */
    var GAp = gal(307, 9, 2.0e8), SHp = gal(312, 31, 6.5e8);
    var FL = level(new THREE.Group(), 1, 7.4, 7.9, 99, 100);
    var FILS = [], BENDS = [], FLEN = [];
    for (var fi = 0; fi < 34; fi++) { var u0 = rnd() * 2 - 1, t0 = rnd() * TAU, q0 = Math.sqrt(1 - u0 * u0); FILS.push(new THREE.Vector3(q0 * Math.cos(t0), q0 * Math.sin(t0), u0)); BENDS.push(new THREE.Vector3(gauss(), gauss(), gauss()).normalize()); FLEN.push(1.5e8 + rnd() * 3.2e8); }
    var NF = 7000, fPos = new Float32Array(NF * 3), fCol = new Float32Array(NF * 3), fBase = [];
    for (i = 0; i < NF; i++) {
      // galaxies along filaments that run into the attractor, plus a scatter
      var fil = Math.floor(rnd() * 34), dir = FILS[fil], bend = BENDS[fil];
      var s = rnd(), p = GAp.clone().add(dir.clone().multiplyScalar(s * FLEN[fil])).add(bend.clone().multiplyScalar(s * s * FLEN[fil] * 0.45)).add(new THREE.Vector3(gauss(), gauss(), gauss()).multiplyScalar(1.4e7 + s * 3.2e7));
      if (rnd() < 0.25) p = new THREE.Vector3(gauss(), gauss(), gauss()).multiplyScalar(3.2e8).add(GAp.clone().multiplyScalar(0.5));
      fBase.push(p); fPos.set([p.x, p.y, p.z], i * 3);
      var w = rnd(); var cc = w < 0.6 ? [0.8, 0.85, 1] : [1, 0.85, 0.7]; var bb = 0.3 + rnd() * 0.7; fCol.set([cc[0] * bb, cc[1] * bb, cc[2] * bb], i * 3);
    }
    var flowPts = points(fPos, fCol, 2.0, 0.75); track(FL, flowPts);
    // streak lines showing the flow
    var NL = 900, lPos = new Float32Array(NL * 6), lCol = new Float32Array(NL * 6);
    var lG = new THREE.BufferGeometry(); lG.setAttribute('position', new THREE.BufferAttribute(lPos, 3)); lG.setAttribute('color', new THREE.BufferAttribute(lCol, 3));
    var flowLines = new THREE.LineSegments(lG, new THREE.LineBasicMaterial({ vertexColors: true, transparent: true, opacity: 0.7, blending: THREE.AdditiveBlending, depthWrite: false }));
    flowLines.frustumCulled = false; track(FL, flowLines);
    var gaGlow = new THREE.Sprite(new THREE.SpriteMaterial({ map: GLOW, color: 0xffd08a, blending: THREE.AdditiveBlending, depthWrite: false, transparent: true, opacity: 0.8 })); gaGlow.scale.set(9e7, 9e7, 1); gaGlow.position.copy(GAp); track(FL, gaGlow);
    var shGlow = new THREE.Sprite(new THREE.SpriteMaterial({ map: GLOW, color: 0xffb070, blending: THREE.AdditiveBlending, depthWrite: false, transparent: true, opacity: 0.7 })); shGlow.scale.set(1.6e8, 1.6e8, 1); shGlow.position.copy(SHp); track(FL, shGlow);
    CH[3].look = m31.clone().multiplyScalar(0.45).toArray(); CH[4].look = GAp.clone().multiplyScalar(0.45).toArray(); CH[5].look = SHp.clone().multiplyScalar(0.35).toArray();
    var hereDot = points(new Float32Array([0, 0, 0]), new Float32Array([0.5, 0.9, 1]), 9, 1, true); track(FL, hereDot);
    var flLabels = [label('Great Attractor · about 200 million light years', 'star'), label('Shapley Supercluster · about 650 million light years', 'star'), label('Us: Local Group', 'you')];
    FL.labels = flLabels;
    function updateFlow(t) {
      for (var j = 0; j < NL; j++) {
        var b = fBase[j * 7], toGA = GAp.clone().sub(b), d = toGA.length(); toGA.normalize();
        var ph = ((t * 0.18 + j * 0.137) % 1), L = 1.4e7 + d * 0.06;
        var a0 = b.clone().add(toGA.clone().multiplyScalar(ph * L)), a1 = a0.clone().sub(toGA.clone().multiplyScalar(L * 0.7));
        lPos.set([a0.x, a0.y, a0.z, a1.x, a1.y, a1.z], j * 6);
        var f = Math.sin(ph * Math.PI); lCol.set([0.55 * f, 0.85 * f, 1 * f, 0, 0, 0], j * 6);
      }
      lG.attributes.position.needsUpdate = lG.attributes.color.needsUpdate = true;
    }

    /* ---------- camera, time line and drawing */
    var W = 0, H = 0;
    function resize() {
      var w = stage.clientWidth, h = stage.clientHeight;
      if (w === W && h === H) return; W = w; H = h;
      renderer.setSize(w, h); camera.aspect = w / h; camera.fov = w < h ? 64 : 50; camera.updateProjectionMatrix();
    }
    var T = 0, playing = true, yaw = -0.6, pitch = 0.32, userYaw = 0, userPitch = 0, last = 0;
    var total = CH.length * HOLD + (CH.length - 1) * MOVE;
    function chapterAt(t) { // returns [index, blend 0..1 to next]
      var seg = HOLD + MOVE, i = Math.min(CH.length - 1, Math.floor(t / seg)), r = t - i * seg;
      if (i >= CH.length - 1) return [CH.length - 1, 0];
      return [i, r < HOLD ? 0 : (r - HOLD) / MOVE];
    }
    function ease(x) { return x < 0.5 ? 4 * x * x * x : 1 - Math.pow(-2 * x + 2, 3) / 2; }
    var look = new THREE.Vector3(), la = new THREE.Vector3(), lb = new THREE.Vector3(), v3 = new THREE.Vector3(), curCh = -1;
    CH.forEach(function (c, i) { var b = document.createElement('button'); b.type = 'button'; b.setAttribute('aria-label', 'Go to part ' + (i + 1)); b.addEventListener('click', function () { T = i * (HOLD + MOVE) + 0.01; if (!playing) draw(); }); dots.appendChild(b); });

    // drag to look around; the flight carries on
    var drag = null;
    cv.addEventListener('pointerdown', function (e) { drag = [e.clientX, e.clientY]; cv.setPointerCapture(e.pointerId); });
    cv.addEventListener('pointermove', function (e) { if (!drag) return; userYaw -= (e.clientX - drag[0]) * 0.006; userPitch = Math.max(-1.1, Math.min(1.1, userPitch + (e.clientY - drag[1]) * 0.005)); drag = [e.clientX, e.clientY]; if (!playing) draw(); });
    cv.addEventListener('pointerup', function () { drag = null; }); cv.addEventListener('pointercancel', function () { drag = null; });

    function place(el, p) {
      v3.copy(p).project(camera);
      var vis = v3.z < 1 && Math.abs(v3.x) < 0.98 && Math.abs(v3.y) < 0.95;
      el.style.display = vis ? '' : 'none';
      if (vis) el.style.transform = 'translate(' + ((v3.x + 1) / 2 * W).toFixed(1) + 'px,' + ((1 - v3.y) / 2 * H).toFixed(1) + 'px)';
    }
    function draw() {
      resize();
      var ch = chapterAt(Math.min(T, total)), i = ch[0], k = ease(ch[1]), A = CH[i], B = CH[Math.min(i + 1, CH.length - 1)];
      var z10 = A.z + (B.z - A.z) * k;
      la.fromArray(A.look); lb.fromArray(B.look);
      // the view slides to the next centre only once it is wide enough to hold both
      look.copy(la).lerp(lb, smooth(0.25, 0.95, ch[1]));
      var size = Math.pow(10, z10), s = VIEW / size; // scene units per light year
      var showCh = ch[1] > 0.55 ? i + 1 : i;
      if (showCh !== curCh) {
        curCh = showCh; capEl.innerHTML = CH[curCh].cap; subEl.textContent = CH[curCh].sub;
        Array.prototype.forEach.call(dots.children, function (d, j) { d.classList.toggle('on', j === curCh); });
        box.querySelector('.jjtext').classList.remove('in'); void box.querySelector('.jjtext').offsetWidth; box.querySelector('.jjtext').classList.add('in');
      }
      bar.style.width = (Math.min(1, T / total) * 100).toFixed(2) + '%';
      // every level: scaled about the point we look at, and faded by the size of the view
      levels.forEach(function (L) {
        var op = win(z10, L.w[0], L.w[1], L.w[2], L.w[3]);
        L.g.visible = op > 0.01;
        L.mats.forEach(function (m) { m.opacity = (m.userData.base == null ? 1 : m.userData.base) * op; });
        L.g.scale.setScalar(s * L.unit);
        L.g.position.copy(look).multiplyScalar(-s);
        L.labels.forEach(function (el) { el.style.opacity = op > 0.6 ? Math.min(1, (op - 0.6) * 2.5) : 0; });
      });
      // a slow turn so the 3D shows, plus the visitor's own drag
      var yw = yaw + T * 0.035 + userYaw, pt = pitch + userPitch + (i >= 2 ? 0.25 : 0) * smooth(1.2, 3.6, z10);
      camera.position.set(Math.cos(pt) * Math.cos(yw) * VIEW, Math.cos(pt) * Math.sin(yw) * VIEW, Math.sin(pt) * VIEW);
      camera.up.set(0, 0, 1); camera.lookAt(0, 0, 0);
      updateSolar(T * 0.9); if (NEAR.g.visible) updateNear(T); if (FL.g.visible) updateFlow(T);
      mwSpin.rotation.z = -T * 0.02;
      var grow = 1 + 4.5 * smooth(5.4, 6.6, z10); mwSpin.scale.setScalar(grow); // drawn bigger once it is tiny
      renderer.render(scene, camera);
      // labels follow their objects
      function at(L, local) { return local.clone().multiplyScalar(s * L.unit).add(L.g.position); }
      if (SOL.g.visible) { PLN.forEach(function (p, j) { place(solLabels[j], at(SOL, balls[j].position).add(new THREE.Vector3(0, 0, 0.6))); }); place(sunLab, at(SOL, new THREE.Vector3(0, 0, -0.5))); }
      if (NEAR.g.visible) { namedPos.forEach(function (p, j) { place(nearLabels[j], at(NEAR, p)); }); place(youLab, at(NEAR, new THREE.Vector3())); }
      if (MW.g.visible) { place(mwLab, at(MW, new THREE.Vector3())); place(mwCen, at(MW, new THREE.Vector3(26000, 0, 0))); if (z10 > 5.7) mwLab.style.display = mwCen.style.display = 'none'; }
      if (LG.g.visible) { place(lgLabels[0], at(LG, m31)); place(lgLabels[1], at(LG, m33)); place(lgLabels[2], at(LG, new THREE.Vector3(26000, 0, 0))); }
      if (FL.g.visible) { place(flLabels[0], at(FL, GAp)); place(flLabels[1], at(FL, SHp)); place(flLabels[2], at(FL, new THREE.Vector3())); }
      levels.forEach(function (L) { if (!L.g.visible) L.labels.forEach(function (el) { el.style.display = 'none'; }); });
    }
    var onScreen = true;
    if ('IntersectionObserver' in window) new IntersectionObserver(function (e) { onScreen = e[0].isIntersecting; if (onScreen) kick(); }).observe(stage);
    var running = false;
    function kick() { if (!running && playing && onScreen && !document.hidden) { running = true; last = 0; requestAnimationFrame(loop); } }
    function loop(now) {
      if (!playing || !onScreen || document.hidden) { running = false; return; }
      var dt = last ? Math.min(0.1, (now - last) / 1000) : 0; last = now;
      T += dt; if (T > total + 3) T = 0; // start again after the last chapter
      draw(); requestAnimationFrame(loop);
    }
    document.addEventListener('visibilitychange', kick);
    window.addEventListener('resize', function () { if (!playing) draw(); });
    function setBtn() { if (ctlBtn) ctlBtn.innerHTML = playing ? '❚❚ Pause' : '▶ Play'; }
    setBtn(); draw(); kick();
    return { toggle: function () { playing = !playing; setBtn(); if (playing) kick(); } };
  }
})();
