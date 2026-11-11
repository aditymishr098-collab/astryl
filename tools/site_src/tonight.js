/* Your city: tonight's sky (Sun and Moon times, which planets are up), the coming eclipses and meteor
   showers with calendar files, and the "I've seen it" list. Everything is worked out in the browser.
   The chosen city is kept in this browser and, with an account and sync on, in the account (the app
   uses the same city list). Times are shown in this device's time zone. */
(function () {
  var D = window.ASTRYL, API = window.ASTRYL_API;
  if (!D || !API || !D.cities) return;
  var KEY = 'astryl-city', SEEN = 'astryl-seen', DEG = Math.PI / 180, OBL = 23.4393 * DEG;
  function get(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } }
  function set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { } }
  function changed() { try { document.dispatchEvent(new Event('astryl-change')); } catch (e) { } }
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + hi + '</span>'; }
  function hi() { return API.lang() === 'hi'; }
  function n360(a) { return ((a % 360) + 360) % 360; }
  function esc(x) { return String(x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }

  /* ---------- city ---------- */
  var byId = {};
  D.cities.forEach(function (c) { byId[c[0]] = c; });
  function city() { var id = get(KEY, ''); return byId[id] ? { id: id, name: byId[id][1], country: byId[id][2], lat: byId[id][3], lon: byId[id][4] } : null; }
  function setCity(id) { if (byId[id]) { set(KEY, id); changed(); } }
  function nearest(lat, lon) {
    var best = null, bd = 1e9;
    D.cities.forEach(function (c) { var d = Math.pow(c[3] - lat, 2) + Math.pow((c[4] - lon) * Math.cos(lat * DEG), 2); if (d < bd) { bd = d; best = c[0]; } });
    return best;
  }
  function picker(onDone) {
    var cur = city(), opts = D.cities.slice().sort(function (a, b) { return a[1].localeCompare(b[1]); })
      .map(function (c) { return '<option value="' + c[0] + '"' + (cur && cur.id === c[0] ? ' selected' : '') + '>' + esc(c[1]) + ', ' + esc(c[2]) + '</option>'; }).join('');
    var h = '<div class="row citypick"><select aria-label="City"><option value="">' + (hi() ? 'अपना शहर चुनें…' : 'Choose your city…') + '</option>' + opts + '</select>' +
      (navigator.geolocation ? '<button class="btn" type="button" data-near>📍 ' + bi('Nearest to me', 'मेरे सबसे पास') + '</button>' : '') + '</div>' +
      '<p class="note">' + bi('Your location is only used once, in this browser, to pick the nearest city; it is not sent anywhere.', 'आपकी जगह सिर्फ़ एक बार, इसी browser में, सबसे पास का शहर चुनने के लिए इस्तेमाल होती है; कहीं भेजी नहीं जाती।') + '</p>';
    return { html: h, wire: function (root) {
      var sel = root.querySelector('.citypick select'), near = root.querySelector('[data-near]');
      if (sel) sel.addEventListener('change', function () { if (sel.value) { setCity(sel.value); onDone(); } });
      if (near) near.addEventListener('click', function () {
        navigator.geolocation.getCurrentPosition(function (p) { setCity(nearest(p.coords.latitude, p.coords.longitude)); onDone(); }, function () { }, { maximumAge: 600000, timeout: 10000 });
      });
    } };
  }

  /* ---------- sky maths ---------- */
  function jd(ms) { return ms / 86400000 + 2440587.5; }
  function eclToEq(lon, lat) {
    var l = lon * DEG, b = lat * DEG;
    var ra = Math.atan2(Math.sin(l) * Math.cos(OBL) - Math.tan(b) * Math.sin(OBL), Math.cos(l));
    var dec = Math.asin(Math.sin(b) * Math.cos(OBL) + Math.cos(b) * Math.sin(OBL) * Math.sin(l));
    return { ra: n360(ra / DEG), dec: dec / DEG };
  }
  function radec(id, ms) {
    if (id === 'sun') return eclToEq(API.sunLon(ms), 0);
    if (id === 'moon') { var m = API.moonEcl(ms); return eclToEq(m.lon, m.lat); }
    var e = API.helio('earth', ms), p = API.helio(id, ms), x = p.x - e.x, y = p.y - e.y, z = p.z - e.z;
    return eclToEq(n360(Math.atan2(y, x) / DEG), Math.atan2(z, Math.sqrt(x * x + y * y)) / DEG);
  }
  function altAz(id, ms, c) {
    var q = radec(id, ms), gmst = n360(280.46061837 + 360.98564736629 * (jd(ms) - 2451545));
    var H = (gmst + c.lon - q.ra) * DEG, la = c.lat * DEG, de = q.dec * DEG;
    var alt = Math.asin(Math.sin(la) * Math.sin(de) + Math.cos(la) * Math.cos(de) * Math.cos(H));
    var az = Math.atan2(-Math.sin(H), Math.tan(de) * Math.cos(la) - Math.sin(la) * Math.cos(H));
    return { alt: alt / DEG, az: n360(az / DEG) };
  }
  /* Times between [from] and [from + hours] when [id] crosses [h] degrees of height. */
  function crossings(id, c, from, hours, h) {
    var out = [], step = 10 * 60000, prev = altAz(id, from, c).alt - h;
    for (var t = from + step; t <= from + hours * 3600000; t += step) {
      var cur = altAz(id, t, c).alt - h;
      if ((prev < 0) !== (cur < 0)) out.push({ at: t - step + step * prev / (prev - cur), up: cur > 0 });
      prev = cur;
    }
    return out;
  }
  var DIRS = [['north', 'उत्तर'], ['north-east', 'उत्तर-पूर्व'], ['east', 'पूर्व'], ['south-east', 'दक्षिण-पूर्व'], ['south', 'दक्षिण'], ['south-west', 'दक्षिण-पश्चिम'], ['west', 'पश्चिम'], ['north-west', 'उत्तर-पश्चिम']];
  function dir(az) { return DIRS[Math.round(az / 45) % 8]; }
  function time(ms) { return new Date(ms).toLocaleTimeString(hi() ? 'hi-IN' : 'en-GB', { hour: '2-digit', minute: '2-digit' }); }
  function date(ms, opt) { return new Date(ms).toLocaleDateString(hi() ? 'hi-IN' : 'en-GB', opt || { weekday: 'short', day: 'numeric', month: 'short', year: 'numeric' }); }

  /* Tonight for city [c]: sunset, sunrise, moonrise/set, the Moon, and planets up after dark. */
  function tonight(c, now) {
    now = now || Date.now();
    var noon = new Date(now); noon.setHours(12, 0, 0, 0);
    var start = noon.getTime(), sun = crossings('sun', c, start, 24, -0.833), moon = crossings('moon', c, start - 12 * 3600000, 36, 0.125);
    var set = null, rise = null;
    sun.forEach(function (x) { if (!x.up && set === null) set = x.at; else if (x.up && set !== null && rise === null) rise = x.at; });
    var dark = crossings('sun', c, start, 24, -12), darkAt = null;
    dark.forEach(function (x) { if (!x.up && darkAt === null) darkAt = x.at; });
    // Look at the sky an hour after sunset (or at 21:00 where the Sun does not set or stays down).
    var look = set ? set + 3600000 : start + 9 * 3600000;
    var planets = ['mercury', 'venus', 'mars', 'jupiter', 'saturn'].map(function (id) {
      // best height during the evening and the night until sunrise
      var best = null, end = rise || look + 10 * 3600000;
      for (var t = look; t <= end; t += 30 * 60000) {
        var a = altAz(id, t, c), s = altAz('sun', t, c).alt;
        if (s < -6 && a.alt > 8 && (!best || a.alt > best.alt)) best = { alt: a.alt, az: a.az, at: t };
      }
      return best ? { id: id, alt: best.alt, az: best.az, at: best.at } : null;
    }).filter(Boolean);
    var mr = null, ms = null;
    moon.forEach(function (x) { if (x.at >= start - 6 * 3600000) { if (x.up && mr === null) mr = x.at; if (!x.up && ms === null) ms = x.at; } });
    return { set: set, rise: rise, dark: darkAt, moonRise: mr, moonSet: ms, phase: API.moonPhase(now), planets: planets };
  }

  function tonightHtml(c) {
    var t = tonight(c), h = '<div class="stats tn">';
    h += '<div class="stat"><b>' + (t.set ? time(t.set) : '–') + '</b><span>🌇 ' + bi('Sunset', 'सूर्यास्त') + '</span></div>';
    h += '<div class="stat"><b>' + (t.dark ? time(t.dark) : '–') + '</b><span>🌌 ' + bi('Dark enough', 'अँधेरा') + '</span></div>';
    h += '<div class="stat"><b>' + (t.rise ? time(t.rise) : '–') + '</b><span>🌅 ' + bi('Sunrise', 'सूर्योदय') + '</span></div>';
    h += '<div class="stat"><b>' + Math.round(t.phase.lit * 100) + '%</b><span>🌙 ' + bi('Moon lit', 'चाँद रोशन') + '</span></div>';
    h += '<div class="stat"><b>' + (t.moonRise ? time(t.moonRise) : '–') + '</b><span>' + bi('Moonrise', 'चंद्रोदय') + '</span></div>';
    h += '<div class="stat"><b>' + (t.moonSet ? time(t.moonSet) : '–') + '</b><span>' + bi('Moonset', 'चंद्रास्त') + '</span></div></div>';
    if (t.planets.length) {
      h += '<h3>' + bi('Planets you can see tonight', 'आज रात दिखने वाले ग्रह') + '</h3><ul class="tnlist">';
      t.planets.forEach(function (p) { var d = dir(p.az); h += '<li><b>' + API.bname(p.id) + '</b> ' + bi('best around ' + time(p.at) + ', ' + Math.round(p.alt) + '° high in the ' + d[0], time(p.at) + ' के आसपास सबसे अच्छा, ' + d[1] + ' में ' + Math.round(p.alt) + '° ऊँचा') + '</li>'; });
      h += '</ul>';
    } else h += '<p>' + bi('No bright planet is well placed tonight. The Moon and the stars are still worth a look.', 'आज रात कोई चमकीला ग्रह अच्छी जगह पर नहीं है। चाँद और तारे फिर भी देखने लायक हैं।') + '</p>';
    h += '<p class="note">' + bi('Times in this device’s time zone, for ' + esc(c.name) + '. Worked out in your browser.', esc(c.name) + ' के लिए, इस device के time zone में। आपके browser में ही निकाला गया।') + '</p>';
    return h;
  }

  /* ---------- the calendar ---------- */
  var SHOWER = { quadrantids: ['Quadrantids', 'क्वाड्रैंटिड'], lyrids: ['Lyrids', 'लिरिड'], etaAquariids: ['Eta Aquariids', 'ईटा एक्वेरिड'], perseids: ['Perseids', 'पर्सिड'], orionids: ['Orionids', 'ओरियोनिड'], leonids: ['Leonids', 'लियोनिड'], geminids: ['Geminids', 'जेमिनिड'], ursids: ['Ursids', 'उर्सिड'] };
  var ETYPE = { total: ['Total', 'पूर्ण'], annular: ['Annular', 'वलयाकार'], partial: ['Partial', 'आंशिक'], penumbral: ['Penumbral', 'उपछाया'] };
  function events(c, days) {
    var now = Date.now(), end = now + (days || 400) * 86400000, out = [], yr = new Date().getFullYear();
    (D.meteors || []).forEach(function (s) {
      [yr, yr + 1, yr + 2].forEach(function (Y) {
        var at = new Date(Y, s[1] - 1, s[2], 23).getTime();
        if (at > now - 86400000 && at < end) out.push({ kind: 'shower', id: s[0], at: at, rate: s[3], lit: API.moonPhase(at).lit });
      });
    });
    (D.eclipses || []).forEach(function (e) {
      var at = Date.parse(e[1]);
      if (at < now - 86400000 || at > end) return;
      var ev = { kind: e[2] ? 'lunar' : 'solar', id: e[0], at: at, type: e[3], mag: e[4] };
      if (e[2] && c) ev.up = altAz('moon', at, c).alt > 0;
      out.push(ev);
    });
    return out.sort(function (a, b) { return a.at - b.at; });
  }
  function evTitle(ev) {
    if (ev.kind === 'shower') { var n = SHOWER[ev.id] || [ev.id, ev.id]; return [n[0] + ' meteor shower', n[1] + ' उल्कापात']; }
    var t = ETYPE[ev.type] || ['', ''];
    return ev.kind === 'lunar' ? [t[0] + ' lunar eclipse', t[1] + ' चंद्र ग्रहण'] : [t[0] + ' solar eclipse', t[1] + ' सूर्य ग्रहण'];
  }
  function evPage(ev) { return ev.kind === 'shower' ? 'sky-events/' + ev.id.replace(/[A-Z]/g, function (m) { return '-' + m.toLowerCase(); }) + '.html' : 'sky-events/' + ev.id + '.html'; }
  function icsStamp(ms) { return new Date(ms).toISOString().replace(/[-:]/g, '').replace(/\.\d+/, ''); }
  function icsDate(ms) { var d = new Date(ms); return d.getFullYear() + ('0' + (d.getMonth() + 1)).slice(-2) + ('0' + d.getDate()).slice(-2); }
  function ics(list) {
    var L = ['BEGIN:VCALENDAR', 'VERSION:2.0', 'PRODID:-//Astryl//astryl.space//EN', 'CALSCALE:GREGORIAN'];
    list.forEach(function (ev) {
      var t = evTitle(ev)[hi() ? 1 : 0], url = 'https://astryl.space/' + evPage(ev);
      L.push('BEGIN:VEVENT', 'UID:' + ev.id + '-' + icsDate(ev.at) + '@astryl.space', 'DTSTAMP:' + icsStamp(Date.now()));
      if (ev.kind === 'shower') {
        var next = ev.at + 86400000;
        L.push('DTSTART;VALUE=DATE:' + icsDate(ev.at), 'DTEND;VALUE=DATE:' + icsDate(next));
      } else L.push('DTSTART:' + icsStamp(ev.at - 3600000), 'DTEND:' + icsStamp(ev.at + 3600000));
      L.push('SUMMARY:' + t.replace(/[,;]/g, ' '), 'DESCRIPTION:' + url, 'URL:' + url, 'END:VEVENT');
    });
    L.push('END:VCALENDAR');
    return L.join('\r\n') + '\r\n';
  }
  function download(name, text) {
    var blob = new Blob([text], { type: 'text/calendar' }), a = document.createElement('a');
    a.href = URL.createObjectURL(blob); a.download = name; document.body.appendChild(a); a.click(); a.remove();
  }
  function calendarHtml(c, root) {
    var list = events(c), h = '<ul class="evlist">';
    list.forEach(function (ev, i) {
      var tt = evTitle(ev), when = ev.kind === 'shower' ? date(ev.at) + ' · ' + bi('peak night', 'चरम रात') : date(ev.at) + ' · ' + time(ev.at), note = '';
      if (ev.kind === 'shower') note = bi('Up to ' + ev.rate + ' an hour in a dark sky; Moon ' + Math.round(ev.lit * 100) + '% lit', 'अँधेरे आसमान में घंटे में ' + ev.rate + ' तक; चाँद ' + Math.round(ev.lit * 100) + '% रोशन');
      else if (ev.kind === 'lunar' && c) note = ev.up ? '✅ ' + bi('The Moon is up in ' + esc(c.name) + ' at mid-eclipse', esc(c.name) + ' में ग्रहण के बीच चाँद ऊपर होगा') : '❌ ' + bi('The Moon is below the horizon in ' + esc(c.name), esc(c.name) + ' में चाँद क्षितिज के नीचे होगा');
      else if (ev.kind === 'solar') note = bi('See where it is visible', 'कहाँ दिखेगा देखें');
      h += '<li><div><a href="' + root + evPage(ev) + '"><b>' + (ev.kind === 'shower' ? '☄️ ' : ev.kind === 'lunar' ? '🌑 ' : '🌞 ') + bi(tt[0], tt[1]) + '</b></a><br><small>' + when + '</small>' + (note ? '<br><small class="note">' + note + '</small>' : '') + '</div><button class="btn" type="button" data-ics="' + i + '" aria-label="Add to calendar">📅</button></li>';
    });
    h += '</ul><p><button class="btn" type="button" data-ics="all">📅 ' + bi('Add all to my calendar', 'सब अपने calendar में जोड़ें') + '</button></p><p class="note">' + bi('The 📅 button saves a calendar file that your phone or computer calendar opens. No Google or other account is needed.', '📅 बटन एक calendar file save करता है जिसे आपके phone या computer का calendar खोल लेता है। Google या किसी और account की ज़रूरत नहीं।') + '</p>';
    return { html: h, wire: function (el) {
      el.addEventListener('click', function (e) {
        var b = e.target.closest('[data-ics]'); if (!b) return;
        var k = b.getAttribute('data-ics');
        if (k === 'all') download('astryl-sky-events.ics', ics(list)); else download(list[+k].id + '.ics', ics([list[+k]]));
      });
    } };
  }

  /* ---------- I've seen it ---------- */
  var THINGS = [
    ['moon', '🌙', 'The Moon', 'चाँद'], ['venus', '✨', 'Venus', 'शुक्र'], ['jupiter', '🪐', 'Jupiter', 'बृहस्पति'], ['saturn', '🪐', 'Saturn', 'शनि'],
    ['mars', '🔴', 'Mars', 'मंगल'], ['mercury', '☿️', 'Mercury', 'बुध'], ['iss', '🛰️', 'The space station (ISS)', 'अंतरिक्ष स्टेशन (ISS)'], ['meteor', '☄️', 'A shooting star', 'टूटता तारा'],
    ['orion', '⭐', 'Orion', 'ओरायन (मृग)'], ['bigdipper', '⭐', 'The Big Dipper (Saptarishi)', 'सप्तर्षि'], ['polaris', '🧭', 'Polaris, the Pole Star', 'ध्रुव तारा'], ['pleiades', '✨', 'The Pleiades (Krittika)', 'कृत्तिका (प्लीएडीज़)'],
    ['milkyway', '🌌', 'The Milky Way band', 'आकाशगंगा की पट्टी'], ['andromeda', '🌀', 'The Andromeda Galaxy', 'एंड्रोमेडा galaxy'], ['lunareclipse', '🌑', 'A lunar eclipse', 'चंद्र ग्रहण'], ['solareclipse', '🌞', 'A solar eclipse (safely!)', 'सूर्य ग्रहण (सुरक्षित तरीके से!)']
  ];
  function seen() { var s = get(SEEN, {}); return s && typeof s === 'object' && !Array.isArray(s) ? s : {}; }
  function toggleSeen(id) { var s = seen(); if (s[id]) delete s[id]; else s[id] = Date.now(); set(SEEN, s); changed(); }
  function seenHtml() {
    var s = seen(), n = THINGS.filter(function (x) { return s[x[0]]; }).length, h = '<div class="pbar"><i style="width:' + Math.round(n / THINGS.length * 100) + '%"></i></div><p>' + bi(n + ' of ' + THINGS.length + ' seen', THINGS.length + ' में से ' + n + ' देखे') + '</p><div class="seenlist">';
    THINGS.forEach(function (x) { h += '<button type="button" class="seen' + (s[x[0]] ? ' on' : '') + '" data-seen="' + x[0] + '" aria-pressed="' + (s[x[0]] ? 'true' : 'false') + '">' + (s[x[0]] ? '✅' : x[1]) + ' ' + bi(x[2], x[3]) + '</button>'; });
    return h + '</div><p class="note">' + bi('Tap what you have seen with your own eyes (binoculars count).', 'जो आपने अपनी आँखों से देखा है उस पर tap कीजिए (दूरबीन भी चलेगी)।') + '</p>';
  }

  /* ---------- home page card ---------- */
  function homeCard() {
    var box = document.getElementById('homeTonight'); if (!box) return;
    function draw() {
      var c = city();
      if (!c) { var p = picker(draw); box.innerHTML = '<p>' + bi('Choose your city to see sunset, moonrise and which planets are up tonight.', 'सूर्यास्त, चंद्रोदय और आज रात कौन-से ग्रह दिखेंगे, यह देखने के लिए अपना शहर चुनिए।') + '</p>' + p.html; p.wire(box); return; }
      box.innerHTML = '<p class="cityline">📍 <b>' + esc(c.name) + '</b> <button class="linkbtn" type="button" data-change>' + bi('change', 'बदलें') + '</button></p>' + tonightHtml(c) +
        '<p><a class="btn" href="my-space.html#calendar">📅 ' + bi('Eclipses and meteor showers', 'ग्रहण और उल्कापात') + '</a></p>';
      box.querySelector('[data-change]').onclick = function () { set(KEY, ''); draw(); };
    }
    draw(); API.onRender && API.onRender(draw);
  }
  homeCard();

  /* ---------- eclipse and meteor shower pages ---------- */
  function eventPage() {
    var loc = document.getElementById('evLocal'), tab = document.getElementById('evTable'), sh = document.getElementById('evShower');
    if (loc) {
      var at = Date.parse(loc.getAttribute('data-at')), lunar = loc.getAttribute('data-lunar') === '1';
      var draw = function () {
        var c = city(), h = '<p><b>' + date(at, { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }) + ', ' + time(at) + '</b> ' + bi('in this device\u2019s time', 'इस device के समय में') + '</p>';
        if (c) {
          var m = altAz(lunar ? 'moon' : 'sun', at, c), d = dir(m.az);
          if (lunar) h += m.alt > 0 ? '<p>✅ ' + bi('From ' + esc(c.name) + ' the Moon is ' + Math.round(m.alt) + '° high in the ' + d[0] + ' at mid-eclipse.', esc(c.name) + ' से ग्रहण के बीच चाँद ' + d[1] + ' में ' + Math.round(m.alt) + '° ऊँचा होगा।') + '</p>'
            : '<p>❌ ' + bi('From ' + esc(c.name) + ' the Moon is below the horizon at mid-eclipse, so this one cannot be seen there (except perhaps the start or end).', esc(c.name) + ' से ग्रहण के बीच चाँद क्षितिज के नीचे होगा, इसलिए यह वहाँ से नहीं दिखेगा (शायद शुरुआत या अंत छोड़कर)।') + '</p>';
          else h += m.alt > 0 ? '<p>' + bi('The Sun is up in ' + esc(c.name) + ' at that moment. Check the map description below to see if the eclipse reaches you.', 'उस समय ' + esc(c.name) + ' में सूरज ऊपर होगा। ग्रहण आप तक पहुँचेगा या नहीं, नीचे लिखी जगहें देखिए।') + '</p>'
            : '<p>❌ ' + bi('The Sun is below the horizon in ' + esc(c.name) + ' at that moment, so it cannot be seen there.', 'उस समय ' + esc(c.name) + ' में सूरज क्षितिज के नीचे होगा, इसलिए यह वहाँ से नहीं दिखेगा।') + '</p>';
          h += '<p class="note">📍 ' + esc(c.name) + ' · <button class="linkbtn" type="button" data-change>' + bi('change', 'बदलें') + '</button></p>';
          loc.innerHTML = h;
          loc.querySelector('[data-change]').onclick = function () { set(KEY, ''); draw(); };
        } else { var p = picker(draw); loc.innerHTML = h + p.html; p.wire(loc); }
      };
      draw();
    }
    if (tab) {
      var at2 = Date.parse(loc.getAttribute('data-at')), rows = JSON.parse(tab.getAttribute('data-cities')), th = '<table class="cols"><tr><th>' + bi('City', 'शहर') + '</th><th>' + bi('Local time', 'स्थानीय समय') + '</th><th>' + bi('Moon up?', 'चाँद ऊपर?') + '</th></tr>';
      rows.forEach(function (r) {
        var lt = '';
        try { lt = new Date(at2).toLocaleString(hi() ? 'hi-IN' : 'en-GB', { timeZone: r[3], day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' }); } catch (e) { lt = new Date(at2).toISOString().slice(11, 16) + ' UT'; }
        var up = altAz('moon', at2, { lat: r[1], lon: r[2] }).alt > 0;
        th += '<tr><td>' + esc(r[0]) + '</td><td>' + lt + '</td><td>' + (up ? '✅' : '❌') + '</td></tr>';
      });
      tab.innerHTML = th + '</table>';
    }
    if (sh) {
      var mo = +sh.getAttribute('data-month'), dy = +sh.getAttribute('data-day'), now = Date.now(), Y = new Date().getFullYear();
      var peak = new Date(Y, mo - 1, dy, 23).getTime(); if (peak < now - 86400000) peak = new Date(Y + 1, mo - 1, dy, 23).getTime();
      var lit = API.moonPhase(peak).lit;
      sh.innerHTML = '<p><b>' + bi('Next peak night: ', 'अगली चरम रात: ') + date(peak, { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }) + '</b></p><p>🌙 ' +
        bi('The Moon will be ' + Math.round(lit * 100) + '% lit that night' + (lit > 0.6 ? ', so only the brighter meteors will show.' : lit < 0.3 ? ', a good dark sky.' : '.'), 'उस रात चाँद ' + Math.round(lit * 100) + '% रोशन होगा' + (lit > 0.6 ? ', इसलिए सिर्फ़ चमकीली उल्काएँ दिखेंगी।' : lit < 0.3 ? ', अच्छा अँधेरा आसमान।' : '।')) + '</p>';
    }
  }
  eventPage();

  window.ASTRYL_SKY = { city: city, setCity: setCity, picker: picker, tonightHtml: tonightHtml, calendarHtml: calendarHtml, events: events, seenHtml: seenHtml, toggleSeen: toggleSeen, seen: seen, things: THINGS, altAz: altAz };
})();
