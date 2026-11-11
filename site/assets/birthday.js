/* Birthday sky: where the planets were on the day you were born, how far the light of that day
   has travelled since, and a picture to share. Worked out in the browser; nothing is sent. */
(function () {
  var API = window.ASTRYL_API, input = document.getElementById('birth'), out = document.getElementById('bsOut'), dataEl = document.getElementById('bsStars');
  if (!API || !input || !out || !dataEl) return;
  var STARS = JSON.parse(dataEl.textContent);
  var LY_DAYS = 365.25, DEG = Math.PI / 180;
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + hi + '</span>'; }
  function hi() { return API.lang() === 'hi'; }
  function n360(a) { return ((a % 360) + 360) % 360; }
  function fmt(x, d) { return x.toLocaleString(hi() ? 'hi-IN' : 'en-US', { maximumFractionDigits: d || 0 }); }

  /* Constellations along the ecliptic (IAU boundaries), by ecliptic longitude where each begins. */
  var ZODIAC = [[0, 'Pisces', 'मीन'], [29.1, 'Aries', 'मेष'], [53.5, 'Taurus', 'वृषभ'], [90.4, 'Gemini', 'मिथुन'], [118.3, 'Cancer', 'कर्क'], [138.2, 'Leo', 'सिंह'], [174.2, 'Virgo', 'कन्या'],
    [218.0, 'Libra', 'तुला'], [241.1, 'Scorpius', 'वृश्चिक'], [247.7, 'Ophiuchus', 'सर्पधारी'], [266.3, 'Sagittarius', 'धनु'], [299.7, 'Capricornus', 'मकर'], [327.6, 'Aquarius', 'कुंभ'], [351.6, 'Pisces', 'मीन']];
  function constellation(lon) { var c = ZODIAC[0]; for (var i = 0; i < ZODIAC.length; i++) if (lon >= ZODIAC[i][0]) c = ZODIAC[i]; return c; }
  var PLANETS = ['mercury', 'venus', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune'];

  /* Each planet seen from Earth: its constellation and whether it was in the evening or morning sky. */
  function planetsOn(ms) {
    var e = API.helio('earth', ms), sunLon = n360(Math.atan2(-e.y, -e.x) / DEG);
    return PLANETS.map(function (id) {
      var p = API.helio(id, ms), x = p.x - e.x, y = p.y - e.y, z = p.z - e.z, lon = n360(Math.atan2(y, x) / DEG);
      var d = n360(lon - sunLon), elong = d > 180 ? 360 - d : d, when;
      // Within about 15 degrees of the Sun a planet is lost in its glare.
      if (elong < 15) when = ['lost in the Sun’s glare', 'सूरज की चमक में छिपा'];
      else if (d < 180) when = elong > 150 ? ['up all night', 'पूरी रात दिखा'] : ['in the evening sky', 'शाम के आसमान में'];
      else when = elong > 150 ? ['up all night', 'पूरी रात दिखा'] : ['in the morning sky', 'सुबह के आसमान में'];
      return { id: id, con: constellation(lon), when: when, dist: Math.sqrt(x * x + y * y + z * z) };
    });
  }

  /* How far the light of that day has gone, and which stars it has passed. */
  function light(ms) {
    var ly = (Date.now() - ms) / 86400000 / LY_DAYS, passed = [], next = null;
    STARS.forEach(function (s) { if (s[1] <= ly) passed.push(s); else if (!next || s[1] < next[1]) next = s; });
    return { ly: ly, passed: passed, last: passed.length ? passed[passed.length - 1] : null, next: next };
  }

  var cur = null;
  function draw() {
    if (!input.value) { out.innerHTML = ''; cur = null; return; }
    var p = input.value.split('-').map(Number), ms = Date.UTC(p[0], p[1] - 1, p[2], 12);
    if (!(ms < Date.now())) { out.innerHTML = ''; cur = null; return; }
    var pl = planetsOn(ms), lt = light(ms), ph = API.moonPhase(ms);
    cur = { ms: ms, pl: pl, lt: lt, ph: ph };
    var h = '<h2>' + bi('The planets on your birthday', 'आपके जन्मदिन पर ग्रह') + '</h2><div class="grid sm">';
    pl.forEach(function (x) {
      h += '<div class="card"><b>' + API.bname(x.id) + '</b><p>' + bi('in ' + x.con[1], x.con[2] + ' तारामंडल में') + '<br><small>' + bi(x.when[0], x.when[1]) + '</small></p></div>';
    });
    h += '</div><p class="note">' + bi('Constellations here are the real star patterns the planets stood in front of, seen from Earth. This is astronomy, not astrology: the zodiac signs of astrology are shifted from them by about one constellation.', 'यहाँ तारामंडल वे असली तारा-समूह हैं जिनके सामने ग्रह पृथ्वी से दिखे। यह खगोल-विज्ञान है, ज्योतिष नहीं: ज्योतिष की राशियाँ इनसे लगभग एक तारामंडल खिसकी हुई हैं।') + '</p>';

    h += '<h2>' + bi('How far your birthday light has travelled', 'आपके जन्मदिन की रोशनी कितनी दूर गई') + '</h2><div class="card">';
    h += '<p>' + bi('Light that left Earth on the day you were born is now <b>' + fmt(lt.ly, 1) + ' light-years</b> away.', 'जिस दिन आप पैदा हुए, उस दिन पृथ्वी से निकली रोशनी अब <b>' + fmt(lt.ly, 1) + ' प्रकाश-वर्ष</b> दूर है।') + '</p>';
    if (lt.last) h += '<p>🌟 ' + bi('It has already passed <b>' + lt.passed.length + '</b> of the stars on our list, the farthest so far is <b>' + lt.last[0] + '</b> (' + fmt(lt.last[1], 1) + ' light-years).', 'वह हमारी list के <b>' + lt.passed.length + '</b> तारों से आगे निकल चुकी है; अब तक सबसे दूर <b>' + lt.last[0] + '</b> (' + fmt(lt.last[1], 1) + ' प्रकाश-वर्ष)।') + '</p>';
    else h += '<p>' + bi('It has not reached even the nearest star yet.', 'वह अभी सबसे पास वाले तारे तक भी नहीं पहुँची।') + '</p>';
    if (lt.next) {
      var when = new Date(cur.ms + lt.next[1] * LY_DAYS * 86400000), y = when.getUTCFullYear();
      h += '<p>➡️ ' + bi('Next stop: <b>' + lt.next[0] + '</b>, reached in ' + y + '.', 'अगला पड़ाव: <b>' + lt.next[0] + '</b>, ' + y + ' में पहुँचेगी।') + '</p>';
    }
    if (lt.passed.length) h += '<p class="note">' + lt.passed.map(function (s) { return s[0]; }).join(' · ') + '</p>';
    h += '</div><p><button class="btn primary" type="button" id="bsShare">↗ ' + bi('Share my birthday sky', 'अपने जन्मदिन का आसमान share करें') + '</button></p>';
    out.innerHTML = h;
    document.getElementById('bsShare').onclick = share;
  }

  /* A 1080 × 1350 picture for WhatsApp or Instagram. */
  function share() {
    if (!cur) return;
    var H = hi(), c = document.createElement('canvas'); c.width = 1080; c.height = 1350;
    var x = c.getContext('2d'), g = x.createLinearGradient(0, 0, 0, 1350);
    g.addColorStop(0, '#05070d'); g.addColorStop(1, '#14204a'); x.fillStyle = g; x.fillRect(0, 0, 1080, 1350);
    var seed = 11; function rnd() { seed = (seed * 16807) % 2147483647; return seed / 2147483647; }
    for (var i = 0; i < 140; i++) { x.fillStyle = 'rgba(220,230,255,' + (0.2 + rnd() * 0.6).toFixed(2) + ')'; x.beginPath(); x.arc(rnd() * 1080, rnd() * 1350, 0.8 + rnd() * 2, 0, 7); x.fill(); }
    var sans = '"DM Sans","Noto Sans Devanagari",system-ui,sans-serif', head = '"Space Grotesk","Noto Sans Devanagari",system-ui,sans-serif';
    x.textAlign = 'center';
    x.fillStyle = '#7aa2ff'; x.font = '700 56px ' + head; x.fillText(H ? 'मेरे जन्मदिन का आसमान' : 'My birthday sky', 540, 130);
    var d = new Date(cur.ms);
    x.fillStyle = '#f0f4ff'; x.font = '600 50px ' + sans; x.fillText(d.toLocaleDateString(H ? 'hi-IN' : 'en-GB', { day: 'numeric', month: 'long', year: 'numeric', timeZone: 'UTC' }), 540, 205);
    // the Moon that day
    var mx = 540, my = 360, r = 95, age = cur.ph.age, lit = cur.ph.lit;
    x.fillStyle = '#1b2440'; x.beginPath(); x.arc(mx, my, r, 0, 7); x.fill();
    x.save(); x.beginPath(); x.arc(mx, my, r, 0, 7); x.clip();
    var waxing = n360(age) < 180, w = Math.abs(1 - 2 * lit) * r;
    // the lit half, then the terminator: a dark ellipse for a crescent, a lit one for gibbous
    x.fillStyle = '#f3ecd2'; x.beginPath(); x.arc(mx, my, r, -Math.PI / 2, Math.PI / 2, !waxing); x.closePath(); x.fill();
    x.fillStyle = lit < 0.5 ? '#1b2440' : '#f3ecd2'; x.beginPath(); x.ellipse(mx, my, w, r, 0, 0, 7); x.fill();
    x.restore();
    x.fillStyle = '#a0b0d6'; x.font = '500 38px ' + sans; x.fillText((H ? 'चाँद ' : 'Moon ') + Math.round(lit * 100) + '% ' + (H ? 'रोशन' : 'lit'), 540, 500);
    // planets
    x.textAlign = 'left'; x.font = '600 40px ' + sans;
    cur.pl.forEach(function (p, i) {
      var y = 590 + i * 62;
      x.fillStyle = '#f0f4ff'; x.fillText(API.bname(p.id), 150, y);
      x.fillStyle = '#9fb3e0'; x.fillText(H ? p.con[2] : p.con[1], 520, y);
    });
    // light
    x.textAlign = 'center'; x.fillStyle = '#ffd27a'; x.font = '700 44px ' + head;
    var lt = cur.lt, line = lt.last ? (H ? 'मेरे जन्म की रोशनी ' + lt.last[0] + ' तक पहुँच गई' : 'My birthday light has reached ' + lt.last[0]) : (H ? 'मेरे जन्म की रोशनी सफ़र में है' : 'My birthday light is on its way');
    x.fillText(line, 540, 1100, 980);
    x.fillStyle = '#f0f4ff'; x.font = '500 38px ' + sans; x.fillText(fmt(lt.ly, 1) + (H ? ' प्रकाश-वर्ष दूर' : ' light-years away'), 540, 1160);
    x.fillStyle = '#a0b0d6'; x.font = '500 36px ' + sans; x.fillText('astryl.space/you', 540, 1280);
    var text = (H ? 'मेरे जन्मदिन का आसमान: ' : 'My birthday sky: ') + 'https://astryl.space/you.html';
    c.toBlob(function (blob) {
      if (!blob) return;
      var file; try { file = new File([blob], 'my-birthday-sky.png', { type: 'image/png' }); } catch (e) { file = null; }
      if (file && navigator.canShare && navigator.canShare({ files: [file] })) { navigator.share({ files: [file], text: text }).catch(function () { }); return; }
      var a = document.createElement('a'); a.href = URL.createObjectURL(blob); a.download = 'my-birthday-sky.png'; document.body.appendChild(a); a.click(); a.remove();
    }, 'image/png');
  }

  input.addEventListener('change', draw);
  input.addEventListener('input', draw);
  if (API.onRender) API.onRender(draw);
  draw();
})();
