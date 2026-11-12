/* The space station over your city: where it is now (map with day and night), and when it flies
   over the chosen city in the next 10 days, with the passes you can see with your own eyes marked.
   The orbit data (TLE) comes from Astryl's server (which keeps a copy from wheretheiss.at or
   Celestrak) and is kept in this browser; all the maths (SGP4) runs here. Nothing about you is sent. */
(function () {
  var box = document.getElementById('issApp');
  var SKY = window.ASTRYL_SKY, API = window.ASTRYL_API, Sgp4 = window.Sgp4;
  if (!box || !SKY || !API || !Sgp4) return;
  var FEED = 'https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/daily?what=tle&sat=iss';
  var DIRECT = 'https://api.wheretheiss.at/v1/satellites/25544/tles';
  var CACHE = 'astryl-tle-iss', ONLY = 'astryl-iss-only', DEG = Math.PI / 180, OBL = 23.4393 * DEG;
  var WGS_A = 6378.137, WGS_F = 1 / 298.257223563, E2 = WGS_F * (2 - WGS_F);
  var LAND = JSON.parse((document.getElementById('issLand') || { textContent: '[]' }).textContent);
  function get(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } }
  function set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { } }
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + hi + '</span>'; }
  function hi() { return API.lang() === 'hi'; }
  function esc(x) { return String(x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function n360(a) { return ((a % 360) + 360) % 360; }
  function time(ms) { return new Date(ms).toLocaleTimeString(hi() ? 'hi-IN' : 'en-GB', { hour: '2-digit', minute: '2-digit' }); }
  function date(ms) { return new Date(ms).toLocaleDateString(hi() ? 'hi-IN' : 'en-GB', { weekday: 'short', day: 'numeric', month: 'short' }); }
  var DIRS = [['N', 'उ'], ['NE', 'उ-पू'], ['E', 'पू'], ['SE', 'द-पू'], ['S', 'द'], ['SW', 'द-प'], ['W', 'प'], ['NW', 'उ-प']];
  var DIRL = [['north', 'उत्तर'], ['north-east', 'उत्तर-पूर्व'], ['east', 'पूर्व'], ['south-east', 'दक्षिण-पूर्व'], ['south', 'दक्षिण'], ['south-west', 'दक्षिण-पश्चिम'], ['west', 'पश्चिम'], ['north-west', 'उत्तर-पश्चिम']];
  function dirI(az) { return Math.round(n360(az) / 45) % 8; }

  /* ---------- maths (same as the app's lib/core/iss.dart) ---------- */
  function jd(ms) { return ms / 86400000 + 2440587.5; }
  function gmst(ms) { return n360(280.46061837 + 360.98564736629 * (jd(ms) - 2451545)); }
  function ecef(p, ms) { var th = gmst(ms) * DEG, c = Math.cos(th), s = Math.sin(th); return { x: p.x * c + p.y * s, y: -p.x * s + p.y * c, z: p.z }; }
  function geo(e) {
    var lon = Math.atan2(e.y, e.x) / DEG, r = Math.sqrt(e.x * e.x + e.y * e.y), lat = Math.atan2(e.z, r * (1 - E2)), h = 0;
    for (var i = 0; i < 6; i++) { var n = WGS_A / Math.sqrt(1 - E2 * Math.sin(lat) * Math.sin(lat)); h = r / Math.cos(lat) - n; lat = Math.atan2(e.z, r * (1 - E2 * n / (n + h))); }
    return { lat: lat / DEG, lon: lon, h: h };
  }
  function look(e, la0, lo0) {
    var la = la0 * DEG, lo = lo0 * DEG, n = WGS_A / Math.sqrt(1 - E2 * Math.sin(la) * Math.sin(la));
    var rx = e.x - n * Math.cos(la) * Math.cos(lo), ry = e.y - n * Math.cos(la) * Math.sin(lo), rz = e.z - n * (1 - E2) * Math.sin(la);
    var east = -Math.sin(lo) * rx + Math.cos(lo) * ry, north = -Math.sin(la) * Math.cos(lo) * rx - Math.sin(la) * Math.sin(lo) * ry + Math.cos(la) * rz;
    var up = Math.cos(la) * Math.cos(lo) * rx + Math.cos(la) * Math.sin(lo) * ry + Math.sin(la) * rz, range = Math.sqrt(east * east + north * north + up * up);
    return { el: Math.asin(up / range) / DEG, az: n360(Math.atan2(east, north) / DEG), range: range };
  }
  function sunEq(ms) {
    var l = API.sunLon(ms) * DEG;
    return { ra: n360(Math.atan2(Math.sin(l) * Math.cos(OBL), Math.cos(l)) / DEG), dec: Math.asin(Math.sin(OBL) * Math.sin(l)) / DEG };
  }
  function sunlit(p, ms) {
    var s = sunEq(ms), ra = s.ra * DEG, de = s.dec * DEG, sx = Math.cos(de) * Math.cos(ra), sy = Math.cos(de) * Math.sin(ra), sz = Math.sin(de);
    var along = p.x * sx + p.y * sy + p.z * sz;
    if (along >= 0) return true;
    var px = p.x - along * sx, py = p.y - along * sy, pz = p.z - along * sz;
    return Math.sqrt(px * px + py * py + pz * pz) > Sgp4.RE;
  }
  function sunAlt(ms, c) { return SKY.altAz('sun', ms, c).alt; }
  function subsolar(ms) { var s = sunEq(ms), lon = s.ra - gmst(ms); return { lat: s.dec, lon: n360(lon + 180) - 180 }; }

  function passes(sat, from, c, days) {
    function el(ms) { var p = sat.at(ms); return p ? look(ecef(p, ms), c.lat, c.lon).el : -90; }
    function az(ms) { return look(ecef(sat.at(ms), ms), c.lat, c.lon).az; }
    function cross(a, b) { var up = el(a) > 0, lo = a, hi2 = b; for (var i = 0; i < 18; i++) { var m = Math.floor((lo + hi2) / 2); if ((el(m) > 0) === up) lo = m; else hi2 = m; } return hi2; }
    var step = 30000, end = from + days * 86400000, out = [], t = from, above = el(t) > 0, rise = above ? t : null;
    while (t < end) {
      var nx = t + step, na = el(nx) > 0;
      if (!above && na) rise = cross(t, nx);
      else if (above && !na && rise !== null) {
        var setT = cross(t, nx), peak = rise, pe = -90, vis = 0, visStart = null, visEnd = null;
        for (var ms = rise; ms <= setT; ms += 10000) {
          var e = el(ms); if (e > pe) { pe = e; peak = ms; }
          var p = sat.at(ms);
          if (e > 5 && p && sunAlt(ms, c) < -6 && sunlit(p, ms)) { vis += 10; if (visStart === null) visStart = ms; visEnd = ms; }
        }
        if (pe >= 10) out.push({ rise: rise, set: setT, peak: peak, max: pe, az0: az(Math.min(rise + 1000, setT)), azP: az(peak), az1: az(Math.max(setT - 1000, rise)), visible: vis >= 30, vs: visStart, ve: visEnd, day: sunAlt(peak, c) > -6, lit: sunlit(sat.at(peak), peak) });
        rise = null;
      }
      above = na; t = nx;
    }
    return out;
  }

  /* ---------- orbit data ---------- */
  var sat = null, tle = null, loading = false, failed = false;
  function useTle(t) { try { sat = new Sgp4(t.line1, t.line2); tle = t; return true; } catch (e) { return false; } }
  function fetchJson(url) { return fetch(url, { cache: 'no-cache' }).then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); }); }
  function loadTle(done) {
    var c = get(CACHE, null);
    if (c && c.line1 && useTle(c) && Date.now() - c.fetchedMs < 6 * 3600000) return done();
    loading = true; failed = false;
    fetchJson(FEED).catch(function () { return fetchJson(DIRECT); }).then(function (j) {
      var t = { line1: String(j.line1 || ''), line2: String(j.line2 || ''), fetchedMs: Date.now() };
      if (!/^1 25544/.test(t.line1) || !/^2 25544/.test(t.line2) || !useTle(t)) throw new Error('bad');
      set(CACHE, t);
    }).catch(function () { failed = !sat; }).then(function () { loading = false; done(); });
  }

  /* ---------- drawing ---------- */
  var list = [], listFor = '', timer = null;
  function mapSvg(ms, c) {
    var W = 720, H = 360, X = function (lon) { return (lon + 180) / 360 * W; }, Y = function (lat) { return (90 - lat) / 180 * H; };
    var s = '<svg class="issmap" viewBox="0 0 ' + W + ' ' + H + '" role="img" aria-label="Map of the space station’s path"><rect width="' + W + '" height="' + H + '" class="sea"/>';
    LAND.forEach(function (shape) {
      s += '<polygon class="land" points="' + shape.split(' ').map(function (pt) { var q = pt.split(','); return X(+q[0]).toFixed(1) + ',' + Y(+q[1]).toFixed(1); }).join(' ') + '"/>';
    });
    // night side: for each longitude the latitude of the day-night line, then the dark part
    var sun = subsolar(ms), dec = Math.abs(sun.lat) < 0.01 ? (sun.lat < 0 ? -0.01 : 0.01) : sun.lat, pts = [];
    for (var lon = -180; lon <= 180; lon += 4) pts.push(X(lon).toFixed(1) + ',' + Y(Math.atan(-Math.cos((lon - sun.lon) * DEG) / Math.tan(dec * DEG)) / DEG).toFixed(1));
    s += '<polygon class="night" points="' + pts.join(' ') + ' ' + (dec > 0 ? W + ',' + H + ' 0,' + H : W + ',0 0,0') + '"/>';
    for (var g = -60; g <= 60; g += 30) s += '<line class="grid" x1="0" x2="' + W + '" y1="' + Y(g) + '" y2="' + Y(g) + '"/>';
    // path: 45 minutes back and 95 ahead, split where it wraps around the edge
    var seg = [], prev = null, path = '';
    for (var m = -45; m <= 95; m += 1) {
      var p = sat.at(ms + m * 60000); if (!p) continue;
      var gq = geo(ecef(p, ms + m * 60000));
      if (prev !== null && Math.abs(gq.lon - prev) > 180) { path += '<polyline class="trk" points="' + seg.join(' ') + '"/>'; seg = []; }
      seg.push(X(gq.lon).toFixed(1) + ',' + Y(gq.lat).toFixed(1)); prev = gq.lon;
    }
    s += path + '<polyline class="trk" points="' + seg.join(' ') + '"/>';
    s += '<circle class="sun" cx="' + X(sun.lon) + '" cy="' + Y(sun.lat) + '" r="7"/>';
    if (c) s += '<circle class="me" cx="' + X(c.lon) + '" cy="' + Y(c.lat) + '" r="5"/>';
    var now = geo(ecef(sat.at(ms), ms));
    s += '<g class="iss"><circle cx="' + X(now.lon) + '" cy="' + Y(now.lat) + '" r="9"/><text x="' + X(now.lon) + '" y="' + (Y(now.lat) + 5) + '" text-anchor="middle">🛰</text></g>';
    return s + '</svg>';
  }
  function liveHtml(ms, c) {
    var p = sat.at(ms); if (!p) return '';
    var e = ecef(p, ms), g = geo(e), speed = Math.sqrt(p.vx * p.vx + p.vy * p.vy + p.vz * p.vz) * 3600, lit = sunlit(p, ms);
    var h = '<div class="stats issstats"><div><b>' + Math.abs(g.lat).toFixed(1) + '°' + (g.lat >= 0 ? 'N' : 'S') + ' ' + Math.abs(g.lon).toFixed(1) + '°' + (g.lon >= 0 ? 'E' : 'W') + '</b><small>' + bi('right below it', 'ठीक नीचे') + '</small></div>' +
      '<div><b>' + Math.round(g.h) + ' km</b><small>' + bi('height', 'ऊँचाई') + '</small></div><div><b>' + Math.round(speed).toLocaleString('en-US') + ' km/h</b><small>' + bi('speed', 'रफ़्तार') + '</small></div>' +
      '<div><b>' + (lit ? '☀️' : '🌑') + '</b><small>' + (lit ? bi('in sunlight', 'धूप में') : bi('in Earth’s shadow', 'पृथ्वी की छाया में')) + '</small></div>';
    if (c) {
      var lk = look(e, c.lat, c.lon);
      h += '<div><b>' + (lk.el > 0 ? Math.round(lk.el) + '° ' + bi(DIRL[dirI(lk.az)][0], DIRL[dirI(lk.az)][1]) : Math.round(lk.range).toLocaleString('en-US') + ' km') + '</b><small>' + (lk.el > 0 ? bi('above you now!', 'अभी आपके ऊपर!') : bi('away from ' + esc(c.name), esc(c.name) + ' से दूर')) + '</small></div>';
    }
    return h + '</div>';
  }
  function dur(ms) { var m = Math.floor(ms / 60000), s = Math.round(ms / 1000) % 60; return m + ' min' + (s ? ' ' + s + ' s' : ''); }
  function countdown(ms) {
    var d = Math.max(0, ms), hh = Math.floor(d / 3600000), mm = Math.floor(d / 60000) % 60, ss = Math.floor(d / 1000) % 60;
    return (hh ? hh + ' h ' : '') + mm + ' min ' + (hh ? '' : ss + ' s');
  }
  function passHtml(c, now) {
    var only = !!get(ONLY, true), shown = list.filter(function (x) { return x.set > now && (!only || x.visible); }), nextVis = list.filter(function (x) { return x.visible && x.set > now; })[0];
    var h = '';
    if (nextVis) {
      var a = nextVis.vs || nextVis.rise;
      h += '<div class="issnext"><p class="big">' + (a <= now ? '👀 ' + bi('Look up now!', 'अभी ऊपर देखिए!') : '⏳ <span id="issCount">' + countdown(a - now) + '</span>') + '</p><p>' +
        bi('Next pass you can see: <b>' + date(a) + ', ' + time(a) + '</b>, from the ' + DIRL[dirI(nextVis.az0)][0] + ', up to ' + Math.round(nextVis.max) + '° high.', 'अगली दिखने वाली उड़ान: <b>' + date(a) + ', ' + time(a) + '</b>, ' + DIRL[dirI(nextVis.az0)][1] + ' से, ' + Math.round(nextVis.max) + '° ऊँचाई तक।') + '</p></div>';
    } else h += '<p class="issnext">' + bi('No pass you can see with your eyes in the next 10 days. The station is only visible when your sky is dark and it is still in sunlight, so there are quiet weeks. The passes in daylight are below.', 'अगले 10 दिनों में आँखों से दिखने वाली कोई उड़ान नहीं। Station तभी दिखता है जब आपका आसमान अँधेरा हो और station पर अभी धूप पड़ रही हो, इसलिए कुछ हफ़्ते खाली जाते हैं। दिन वाली उड़ानें नीचे हैं।') + '</p>';
    h += '<label class="chk"><input type="checkbox" id="issOnly"' + (only ? ' checked' : '') + '> ' + bi('Only passes I can see', 'सिर्फ़ दिखने वाली उड़ानें') + '</label>';
    if (only && !shown.length && list.length) { only = false; }
    var rows = (only ? shown : list.filter(function (x) { return x.set > now; })).slice(0, 25);
    h += '<ul class="passes">';
    rows.forEach(function (x, i) {
      var tag = x.visible ? '<span class="vis">✨ ' + bi('visible', 'दिखेगा') + '</span>' : '<span class="nv">' + (x.day ? bi('sky too bright', 'आसमान बहुत उजला') : !x.lit ? bi('in Earth\u2019s shadow', 'पृथ्वी की छाया में') : bi('too low', 'बहुत नीचे')) + '</span>';
      var bright = x.visible ? (x.max >= 60 ? bi('very bright, almost overhead', 'बहुत चमकीला, लगभग सिर के ऊपर') : x.max >= 30 ? bi('bright', 'चमकीला') : bi('low, near the horizon', 'नीचे, क्षितिज के पास')) : '';
      h += '<li class="' + (x.visible ? 'on' : '') + '"><div><b>' + date(x.rise) + ' · ' + time(x.visible && x.vs ? x.vs : x.rise) + '</b> ' + tag + '<br><small>' +
        bi('From ' + DIRS[dirI(x.az0)][0] + ' to ' + DIRS[dirI(x.az1)][0] + ', highest ' + Math.round(x.max) + '° (' + DIRS[dirI(x.azP)][0] + ') at ' + time(x.peak) + ', ' + dur(x.set - x.rise),
          DIRS[dirI(x.az0)][1] + ' से ' + DIRS[dirI(x.az1)][1] + ', सबसे ऊँचा ' + Math.round(x.max) + '° (' + DIRS[dirI(x.azP)][1] + ') ' + time(x.peak) + ' पर, ' + dur(x.set - x.rise)) +
        (bright ? ' · ' + bright : '') + '</small></div>' + (x.visible ? '<button class="btn" type="button" data-ics="' + list.indexOf(x) + '" aria-label="Add to calendar">📅</button>' : '') + '</li>';
    });
    return h + '</ul>';
  }
  function ics(x) {
    function st(ms) { return new Date(ms).toISOString().replace(/[-:]/g, '').replace(/\.\d+/, ''); }
    var a = x.vs || x.rise, b = Math.max(x.ve || x.set, a + 60000), t = hi() ? 'अंतरिक्ष स्टेशन (ISS) दिखेगा' : 'Space station (ISS) pass';
    var d = (hi() ? DIRL[dirI(x.az0)][1] + ' से, ' + Math.round(x.max) + '° तक' : 'From the ' + DIRL[dirI(x.az0)][0] + ', up to ' + Math.round(x.max) + '° high');
    return ['BEGIN:VCALENDAR', 'VERSION:2.0', 'PRODID:-//Astryl//astryl.space//EN', 'BEGIN:VEVENT', 'UID:iss-' + st(x.rise) + '@astryl.space', 'DTSTAMP:' + st(Date.now()), 'DTSTART:' + st(a), 'DTEND:' + st(b),
      'SUMMARY:' + t, 'DESCRIPTION:' + d + '. https://astryl.space/iss.html', 'BEGIN:VALARM', 'TRIGGER:-PT10M', 'ACTION:DISPLAY', 'DESCRIPTION:' + t, 'END:VALARM', 'END:VEVENT', 'END:VCALENDAR'].join('\r\n');
  }

  function draw() {
    var c = SKY.city(), now = Date.now();
    if (!sat) {
      box.innerHTML = loading ? '<p>⏳ ' + bi('Getting the station’s orbit…', 'Station की कक्षा का data आ रहा है…') + '</p>' :
        '<p class="no">' + bi('Could not get the orbit data right now. Please check your internet and try again.', 'अभी कक्षा का data नहीं मिल पाया। कृपया internet देखकर फिर कोशिश कीजिए।') + ' <button class="btn" type="button" data-retry>' + bi('Try again', 'फिर कोशिश करें') + '</button></p>';
      var r = box.querySelector('[data-retry]'); if (r) r.onclick = function () { loadTle(draw); draw(); };
      return;
    }
    var key = c ? c.lat.toFixed(3) + ',' + c.lon.toFixed(3) + ',' + tle.line1 : '';
    if (c && key !== listFor) { list = passes(sat, now, c, 10); listFor = key; }
    var h = '<div class="issL"><div id="issMap">' + mapSvg(now, c) + '</div><p class="note">🛰 ' + bi('the station', 'station') + ' · <span class="dot me"></span> ' + bi('you', 'आप') + ' · ☀️ ' + bi('Sun overhead', 'सूरज सिर के ऊपर') + ' · ' + bi('shaded part: night', 'छायादार हिस्सा: रात') + '</p><div id="issLive">' + liveHtml(now, c) + '</div></div>';
    if (!c) { var p = SKY.picker(draw); box.innerHTML = h + '<h2>' + bi('When can I see it?', 'मैं इसे कब देख सकता हूँ?') + '</h2><p>' + bi('Choose your city to see when the station flies over you.', 'Station आपके ऊपर से कब गुज़रेगा, यह देखने के लिए अपना शहर चुनिए।') + '</p>' + p.html; p.wire(box); return; }
    h += '<div class="issR"><h2>' + bi('Passes over ', 'ऊपर से उड़ानें: ') + esc(c.name) + '</h2><p class="cityline">📍 <b>' + esc(c.name) + '</b> <button class="linkbtn" type="button" data-change>' + bi('change', 'बदलें') + '</button></p><div id="issPasses">' + passHtml(c, now) + '</div>';
    var age = Math.round((now - (tle.fetchedMs || now)) / 3600000), seen = SKY.seen().iss;
    h += '<p class="note">' + bi('Times are in this device’s time zone. Orbit data ' + (age < 1 ? 'fresh' : age + ' h old') + '; the station sometimes changes its orbit, so check again on the day.', 'समय इस device के time zone में हैं। कक्षा का data ' + (age < 1 ? 'ताज़ा' : age + ' घंटे पुराना') + '; station कभी-कभी अपनी कक्षा बदलता है, इसलिए उसी दिन फिर देख लीजिए।') + '</p>' +
      '<p><button class="btn" type="button" data-seen>' + (seen ? '✅ ' + bi('You have seen the ISS', 'आपने ISS देख लिया है') : '👀 ' + bi('I saw it!', 'मैंने देख लिया!')) + '</button></p>';
    box.innerHTML = '<div class="issgrid">' + h + '</div></div>';
    box.querySelector('[data-change]').onclick = function () { SKY.setCity(''); listFor = ''; draw(); };
    box.querySelector('[data-seen]').onclick = function () { SKY.toggleSeen('iss'); draw(); };
    wire(c);
  }
  function wire(c) {
    var o = document.getElementById('issOnly');
    if (o) o.onchange = function () { set(ONLY, o.checked); document.getElementById('issPasses').innerHTML = passHtml(c, Date.now()); wire(c); };
    var ul = box.querySelector('.passes');
    if (ul) ul.onclick = function (e) {
      var b = e.target.closest('[data-ics]'); if (!b) return;
      var x = list[+b.getAttribute('data-ics')], blob = new Blob([ics(x)], { type: 'text/calendar' }), a = document.createElement('a');
      a.href = URL.createObjectURL(blob); a.download = 'astryl-iss-pass.ics'; document.body.appendChild(a); a.click(); a.remove();
    };
  }
  function tick() {
    if (!sat || document.hidden) return;
    var c = SKY.city(), now = Date.now(), m = document.getElementById('issMap'), l = document.getElementById('issLive'), k = document.getElementById('issCount');
    if (l) l.innerHTML = liveHtml(now, c);
    if (m && Math.floor(now / 1000) % 5 === 0) m.innerHTML = mapSvg(now, c);
    if (k) {
      var nv = list.filter(function (x) { return x.visible && x.set > now; })[0];
      if (nv) { var a = nv.vs || nv.rise; if (a > now) k.textContent = countdown(a - now); else draw(); }
    }
  }
  loadTle(draw); draw();
  SKY.autoLocate(function () { listFor = ''; draw(); });
  API.onRender && API.onRender(draw);
  clearInterval(timer); timer = setInterval(tick, 1000);
  window.ASTRYL_ISS = { passes: passes, look: look, geo: geo, ecef: ecef, sunlit: sunlit };
})();
