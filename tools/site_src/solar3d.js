/* Astryl: the Solar System in real 3D (WebGL, three.js) for the Solar System page.
   app.js keeps the date, the planet buttons and the numbers; this file only draws.
   Positions come from the same maths as the rest of the site (app.js helio and moonEcl).
   Distances are squeezed and worlds enlarged so that everything fits on one screen.
   If the browser has no WebGL, start() returns null and the page keeps the flat drawing. */
(function () {
  'use strict';
  var D2R = Math.PI / 180;
  // moons drawn around their planet: distance in planet radii (squeezed) and orbit period in days (minus = backwards)
  var MOONS = {
    moon: {p: 'earth', k: 2.4, days: 27.32},
    io: {p: 'jupiter', k: 1.55, days: 1.769}, europa: {p: 'jupiter', k: 1.95, days: 3.551},
    ganymede: {p: 'jupiter', k: 2.45, days: 7.155}, callisto: {p: 'jupiter', k: 3.1, days: 16.689},
    enceladus: {p: 'saturn', k: 2.65, days: 1.370}, titan: {p: 'saturn', k: 4.0, days: 15.945},
    triton: {p: 'neptune', k: 1.9, days: -5.877}
  };
  var TEX = {sun: 1, mercury: 1, venus: 1, earth: 1, moon: 1, mars: 1, jupiter: 1, saturn: 1, uranus: 1, neptune: 1};
  var TILT = {venus: 177.4, uranus: 97.8};
  var RETRO = {venus: 1, uranus: 1};
  var PLANETS = ['mercury', 'venus', 'earth', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto'];

  function webgl() {
    try { var c = document.createElement('canvas'); return !!(window.WebGLRenderingContext && (c.getContext('webgl') || c.getContext('experimental-webgl'))); }
    catch (e) { return false; }
  }

  function start(o) {
    if (!window.THREE || !THREE.OrbitControls || !webgl()) return null;
    var stage = o.stage, byId = o.byId;
    var renderer;
    try { renderer = new THREE.WebGLRenderer({antialias: true, powerPreference: 'high-performance'}); }
    catch (e) { return null; }
    var cv = renderer.domElement;
    cv.className = 's3-canvas';
    cv.setAttribute('aria-label', 'The Solar System in 3D. Drag to turn, pinch or scroll to zoom, tap a planet to fly to it.');
    o.canvas.style.display = 'none';
    o.canvas.parentNode.insertBefore(cv, o.canvas.nextSibling);
    var labelBox = document.createElement('div'); labelBox.className = 's3-labels';
    cv.parentNode.insertBefore(labelBox, cv.nextSibling);

    renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
    renderer.outputEncoding = THREE.sRGBEncoding;
    var scene = new THREE.Scene();
    var camera = new THREE.PerspectiveCamera(45, 1.5, 0.05, 6000);
    var HOME = new THREE.Vector3(0, 125, 215);
    camera.position.copy(HOME);
    var controls = new THREE.OrbitControls(camera, cv);
    controls.enableDamping = true; controls.dampingFactor = 0.08;
    controls.minDistance = 0.8; controls.maxDistance = 1000; controls.enablePan = false;
    scene.add(new THREE.AmbientLight(0x404a66, 0.35));
    scene.add(new THREE.PointLight(0xfff4e0, 1.6, 0, 0));

    // background stars: a random field and a denser band along the Milky Way
    (function () {
      var n = 6000, pos = new Float32Array(n * 3), col = new Float32Array(n * 3), seed = 7;
      function rnd() { seed = (seed * 16807) % 2147483647; return seed / 2147483647; }
      var tilt = new THREE.Matrix4().makeRotationX(60.2 * D2R), v = new THREE.Vector3();
      for (var i = 0; i < n; i++) {
        if (i < 3800) { var u = rnd() * 2 - 1, t = rnd() * Math.PI * 2, s = Math.sqrt(1 - u * u); v.set(s * Math.cos(t), u, s * Math.sin(t)); }
        else { var th = rnd() * Math.PI * 2, h = (rnd() + rnd() + rnd() - 1.5) * 0.16; v.set(Math.cos(th), h, Math.sin(th)).normalize().applyMatrix4(tilt); }
        v.multiplyScalar(2000); pos[i * 3] = v.x; pos[i * 3 + 1] = v.y; pos[i * 3 + 2] = v.z;
        var c = 0.55 + rnd() * 0.45, warm = rnd();
        col[i * 3] = c; col[i * 3 + 1] = c * (warm > 0.8 ? 0.9 : 1); col[i * 3 + 2] = c * (warm > 0.8 ? 0.78 : warm < 0.2 ? 1 : 0.95);
      }
      var g = new THREE.BufferGeometry();
      g.setAttribute('position', new THREE.BufferAttribute(pos, 3));
      g.setAttribute('color', new THREE.BufferAttribute(col, 3));
      scene.add(new THREE.Points(g, new THREE.PointsMaterial({size: 1.6, sizeAttenuation: false, vertexColors: true, transparent: true, opacity: 0.9})));
    })();

    // shown distance grows with the square root of the real one, so Mercury and Pluto both fit
    function place(h, out) {
      var r = Math.sqrt(h.x * h.x + h.y * h.y + h.z * h.z) || 1e-9, k = 26 * Math.sqrt(r) / r;
      return out.set(h.x * k, h.z * k, -h.y * k);
    }
    function radius(id) {
      if (id === 'sun') return 7;
      var b = byId[id]; return Math.max(0.2, 0.9 * Math.pow(b.diam / 12756, 0.55));
    }

    var loader = new THREE.TextureLoader(), V = o.v ? '?v=' + o.v : '';
    function texture(name) { var t = loader.load('img/textures/' + name + '.webp' + V); t.encoding = THREE.sRGBEncoding; t.anisotropy = 4; return t; }

    var objs = {}, pick = [];
    ['sun'].concat(PLANETS, Object.keys(MOONS)).forEach(function (id) {
      var b = byId[id]; if (!b) return;
      var r = radius(id), holder = new THREE.Group(), spin = new THREE.Group(), seg = id === 'sun' ? 64 : 40;
      var mat;
      if (id === 'sun') mat = new THREE.MeshBasicMaterial({map: texture('sun')});
      else if (TEX[id]) mat = new THREE.MeshStandardMaterial({map: texture(id), roughness: 1, metalness: 0});
      else mat = new THREE.MeshStandardMaterial({color: new THREE.Color(b.colors ? b.colors[0] : b.color).convertSRGBToLinear(), roughness: 1, metalness: 0});
      var mesh = new THREE.Mesh(new THREE.SphereGeometry(r, seg, Math.round(seg * 0.7)), mat);
      mesh.userData.id = id;
      spin.add(mesh); holder.add(spin);
      holder.rotation.z = -(TILT[id] != null ? TILT[id] : (b.tilt || 0)) * D2R;
      scene.add(holder); pick.push(mesh);
      var lab = document.createElement('button'); lab.type = 'button'; lab.className = 's3-label'; lab.textContent = o.name(id);
      lab.addEventListener('click', function () { o.pick(id); });
      labelBox.appendChild(lab);
      objs[id] = {holder: holder, spin: spin, r: r, label: lab, moon: !!MOONS[id], pos: holder.position};
      if (id === 'saturn') {
        var g = new THREE.RingGeometry(r * 1.24, r * 2.27, 128, 1), p = g.attributes.position, uv = g.attributes.uv, w = new THREE.Vector3();
        for (var i = 0; i < p.count; i++) { w.fromBufferAttribute(p, i); uv.setXY(i, (w.length() - r * 1.24) / (r * 1.03), 0.5); }
        var rt = loader.load('img/textures/saturn_ring.webp' + V); rt.encoding = THREE.sRGBEncoding;
        var ring = new THREE.Mesh(g, new THREE.MeshStandardMaterial({map: rt, side: THREE.DoubleSide, transparent: true, roughness: 1, depthWrite: false}));
        ring.rotation.x = -Math.PI / 2; ring.renderOrder = 2; holder.add(ring);
      }
    });
    // the Sun's glow
    (function () {
      var c = document.createElement('canvas'); c.width = c.height = 256; var x = c.getContext('2d');
      var gr = x.createRadialGradient(128, 128, 0, 128, 128, 128);
      gr.addColorStop(0, 'rgba(255,236,190,.85)'); gr.addColorStop(0.22, 'rgba(255,200,110,.35)'); gr.addColorStop(0.5, 'rgba(255,160,60,.08)'); gr.addColorStop(1, 'rgba(255,140,40,0)');
      x.fillStyle = gr; x.fillRect(0, 0, 256, 256);
      var sp = new THREE.Sprite(new THREE.SpriteMaterial({map: new THREE.CanvasTexture(c), blending: THREE.AdditiveBlending, depthWrite: false, transparent: true}));
      sp.scale.set(46, 46, 1); scene.add(sp);
    })();

    // orbits, drawn from the real elements around the shown date (redrawn when the date moves far)
    var orbits = {}, orbitsAt = null, tmpV = new THREE.Vector3();
    function drawOrbits(ms) {
      var T = (ms / 86400000 + 2440587.5 - 2451545) / 36525;
      PLANETS.forEach(function (id) {
        var el = o.orbits && o.orbits[id]; if (!el) return;
        // the whole ellipse from the orbital elements for this date
        var a = el[0] + el[1] * T, e = el[2] + el[3] * T, inc = (el[4] + el[5] * T) * D2R;
        var peri = el[8] + el[9] * T, node = (el[10] + el[11] * T) * D2R, w = peri * D2R - node;
        var cw = Math.cos(w), sw = Math.sin(w), cn = Math.cos(node), sn = Math.sin(node), ci = Math.cos(inc), si = Math.sin(inc), pts = [];
        for (var i = 0; i <= 240; i++) {
          var E = i / 240 * Math.PI * 2, xp = a * (Math.cos(E) - e), yp = a * Math.sqrt(1 - e * e) * Math.sin(E);
          pts.push(place({x: (cw * cn - sw * sn * ci) * xp + (-sw * cn - cw * sn * ci) * yp, y: (cw * sn + sw * cn * ci) * xp + (-sw * sn + cw * cn * ci) * yp, z: (sw * si) * xp + (cw * si) * yp}, new THREE.Vector3()));
        }
        if (orbits[id]) { scene.remove(orbits[id]); orbits[id].geometry.dispose(); }
        orbits[id] = new THREE.Line(new THREE.BufferGeometry().setFromPoints(pts), new THREE.LineBasicMaterial({color: 0xE7C27A, transparent: true, opacity: 0.16}));
        scene.add(orbits[id]);
      });
      orbitsAt = ms;
    }

    // where everything is at a given moment
    function setTime(ms) {
      if (orbitsAt == null || Math.abs(ms - orbitsAt) > 3650 * 86400000) drawOrbits(ms);
      PLANETS.forEach(function (id) { if (objs[id]) place(o.helio(id, ms), objs[id].pos); });
      var days = ms / 86400000;
      Object.keys(MOONS).forEach(function (id) {
        var m = MOONS[id], ob = objs[id], par = objs[m.p]; if (!ob || !par) return;
        var a;
        if (id === 'moon' && o.moonEcl) a = o.moonEcl(ms).lon * D2R;
        else a = (days / m.days) * Math.PI * 2;
        var d = par.r * m.k + (id === 'moon' ? 0.3 : 0);
        ob.pos.set(par.pos.x + Math.cos(a) * d, par.pos.y, par.pos.z - Math.sin(a) * d);
      });
      var hours = ms / 3600000;
      Object.keys(objs).forEach(function (id) {
        var b = byId[id], day = Math.abs(b.day || 24);
        objs[id].spin.rotation.y = ((RETRO[id] ? -1 : 1) * (hours / day) * Math.PI * 2) % (Math.PI * 2);
      });
    }

    // flying to a chosen world, and following it while time runs
    var sel = 'sun', fly = 1, from = new THREE.Vector3(), camFrom = new THREE.Vector3(), off = new THREE.Vector3();
    function focus(id) {
      sel = id; fly = 0; from.copy(controls.target); camFrom.copy(camera.position);
      if (id === 'sun' || !objs[id]) off.copy(HOME);
      else {
        var d = objs[id].r * (id === 'saturn' ? 7 : objs[id].moon ? 9 : 6);
        off.copy(camera.position).sub(controls.target).normalize().multiplyScalar(d);
        off.y = Math.max(off.y, d * 0.28);
      }
      Object.keys(objs).forEach(function (k) { objs[k].label.classList.toggle('on', k === id); });
    }
    function ease(t) { return t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2; }

    var ray = new THREE.Raycaster(), mouse = new THREE.Vector2(), down = null;
    cv.addEventListener('pointerdown', function (e) { down = [e.clientX, e.clientY]; });
    cv.addEventListener('pointerup', function (e) {
      if (!down || Math.hypot(e.clientX - down[0], e.clientY - down[1]) > 6) return;
      var rc = cv.getBoundingClientRect();
      mouse.set((e.clientX - rc.left) / rc.width * 2 - 1, -((e.clientY - rc.top) / rc.height) * 2 + 1);
      ray.setFromCamera(mouse, camera);
      var hit = ray.intersectObjects(pick)[0]; if (hit) o.pick(hit.object.userData.id);
    });

    var W = 0, H = 0;
    function resize() {
      var w = stage.clientWidth || 600, h = Math.round(w < 700 ? w * 1.15 : w * 820 / 1280);
      if (w === W && h === H) return; W = w; H = h;
      renderer.setSize(w, h); camera.aspect = w / h; camera.fov = w < 700 ? 62 : 45; camera.updateProjectionMatrix();
    }
    resize();
    if (window.ResizeObserver) new ResizeObserver(resize).observe(stage); else window.addEventListener('resize', resize);

    // draw only while the scene is on screen and the tab is open
    var onScreen = true, running = false, last = 0, want = null, wantSel = 'sun', first = true, passed = null;
    if (window.IntersectionObserver) new IntersectionObserver(function (en) { onScreen = en[0].isIntersecting; kick(); }).observe(cv);
    document.addEventListener('visibilitychange', kick);
    function kick() { if (!running && onScreen && !document.hidden) { running = true; last = 0; requestAnimationFrame(frame); } }

    var tp = new THREE.Vector3();
    function frame(now) {
      if (!onScreen || document.hidden) { running = false; return; }
      var dt = last ? Math.min(0.1, (now - last) / 1000) : 0; last = now;
      if (want != null) setTime(want);
      if (wantSel !== sel) focus(wantSel);
      if (sel !== 'sun' && objs[sel]) {
        tp.copy(objs[sel].pos);
        if (fly < 1) { fly = Math.min(1, fly + dt / 1.6); var k = ease(fly); controls.target.lerpVectors(from, tp, k); camera.position.lerpVectors(camFrom, tmpV.copy(tp).add(off), k); }
        else { tmpV.copy(tp).sub(controls.target); controls.target.add(tmpV); camera.position.add(tmpV); }
      } else if (fly < 1) {
        fly = Math.min(1, fly + dt / 1.6); var k2 = ease(fly);
        controls.target.lerpVectors(from, tp.set(0, 0, 0), k2); camera.position.lerpVectors(camFrom, off, k2);
      }
      controls.update();
      renderer.render(scene, camera);
      Object.keys(objs).forEach(function (id) {
        var ob = objs[id]; tmpV.copy(ob.pos); tmpV.y += ob.r; tmpV.project(camera);
        var vis = tmpV.z < 1 && Math.abs(tmpV.x) < 1.05 && Math.abs(tmpV.y) < 1.05;
        if (vis && ob.moon) vis = id === sel || camera.position.distanceTo(ob.pos) < ob.r * 60;
        ob.label.style.display = vis ? '' : 'none';
        if (vis) ob.label.style.transform = 'translate(' + ((tmpV.x + 1) / 2 * W).toFixed(1) + 'px,' + ((1 - tmpV.y) / 2 * H).toFixed(1) + 'px) translate(-50%,-135%)';
      });
      requestAnimationFrame(frame);
    }
    kick();

    return {
      // called by app.js whenever the date or the chosen world changes
      update: function (ms, selected) {
        want = ms;
        selected = selected || 'sun';
        // open on the whole system; fly only when the visitor picks another world
        if (first) { first = false; passed = selected; setTime(ms); }
        else if (selected !== passed) { passed = selected; wantSel = selected; }
        kick();
      },
      labels: function () { Object.keys(objs).forEach(function (id) { objs[id].label.textContent = o.name(id); }); }
    };
  }

  window.ASTRYL_SOLAR3D = {start: start};
})();
