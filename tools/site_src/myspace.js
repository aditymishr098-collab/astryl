/* My space: your favourites, scores, streak, badges, Black holes 101 progress and what to read next. */
(function () {
  var box = document.getElementById('mySpace'), ME = window.ASTRYL_ME, API = window.ASTRYL_API;
  if (!box || !ME) return;
  var ACCT = window.ASTRYL_ACCT, root = ME.root;
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + hi + '</span>'; }
  function esc(x) { return String(x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function num(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : (parseInt(JSON.parse(v), 10) || 0); } catch (e) { return d; } }
  function list(k) { try { var v = JSON.parse(localStorage.getItem(k) || '[]'); return Array.isArray(v) ? v : []; } catch (e) { return []; } }
  var BH = ['what-is-a-black-hole', 'how-black-holes-form', 'event-horizon-and-singularity', 'falling-into-a-black-hole', 'how-we-see-black-holes', 'famous-black-holes', 'black-hole-myths-and-big-questions'];
  var stats = null, statsTried = false;

  function name(id) {
    if (id.indexOf('mission:') === 0 || id.indexOf('craft:') === 0) return esc(id.split(':')[1].replace(/-/g, ' '));
    return API && API.bname ? esc(API.bname(id)) : esc(id);
  }
  function favHref(id) {
    if (id.indexOf('mission:') === 0) return root + 'missions.html';
    if (id.indexOf('craft:') === 0) return root + 'spacecraft.html';
    return root + 'body/' + id + '.html';
  }
  function card(title, inner) { return '<div class="card mycard"><h2>' + title + '</h2>' + inner + '</div>'; }
  function bar(n, of) { return '<div class="pbar"><i style="width:' + Math.round(n / Math.max(of, 1) * 100) + '%"></i></div>'; }
  function score(label, v, of) { return '<div class="stat"><b>' + (v ? v + '/' + of : '–') + '</b><span>' + label + '</span></div>'; }

  function draw() {
    var s = ACCT && ACCT.session(), p = ACCT ? ACCT.prefs() : {}, h = '';
    // who
    if (s) h += '<p class="sub">' + bi('Logged in as <b>' + esc(s.username) + '</b>. ', '<b>' + esc(s.username) + '</b> के रूप में login. ') +
      (p.syncOn ? bi('Favourites, scores and Black holes 101 progress are synced with your account and the app.', 'Favourites, scores और Black holes 101 की progress आपके खाते और app के साथ sync हैं।')
        : bi('Sync is off, so this is only what this browser knows. <a href="' + root + 'account.html">Turn it on</a>.', 'Sync बंद है, इसलिए यहाँ सिर्फ़ इस browser का data है। <a href="' + root + 'account.html">चालू करें</a>।')) + '</p>';
    else h += '<p class="sub">' + bi('Everything here is kept in this browser. <a href="' + root + 'account.html">Make a free account</a> to have it on every device and in the app.', 'यहाँ सब कुछ इसी browser में रखा है। हर device और app में पाने के लिए <a href="' + root + 'account.html">मुफ़्त खाता बनाइए</a>।') + '</p>';

    // your city tonight, the calendar and what you have seen
    var SKY = window.ASTRYL_SKY, c = SKY && SKY.city();
    if (SKY) {
      var pk = SKY.picker(draw);
      h += card('🌆 ' + (c ? bi('Tonight in ' + esc(c.name), 'आज रात ' + esc(c.name) + ' में') : bi('Tonight in your city', 'आज रात आपके शहर में')),
        (c ? SKY.tonightHtml(c) + '<details class="more-city"><summary>' + bi('Change city', 'शहर बदलें') + '</summary>' + pk.html + '</details>' : '<p>' + bi('Choose your city for sunset, moonrise, the planets you can see and whether each eclipse is visible from there.', 'सूर्यास्त, चंद्रोदय, दिखने वाले ग्रह और कौन-सा ग्रहण वहाँ से दिखेगा, यह जानने के लिए अपना शहर चुनिए।') + '</p>' + pk.html));
      var cal = SKY.calendarHtml(c, root);
      h += '<div id="calendar"></div>' + card('📅 ' + bi('Coming up in the sky', 'आसमान में आगे क्या है'), cal.html);
      h += card('👀 ' + bi('I\'ve seen it', 'मैंने देखा'), SKY.seenHtml());
    }

    // next for you
    var next = ME.nextFor(3, 'my-space.html'), read = ME.read(), nRead = Object.keys(read).length;
    var nh = next.length ? '<div class="sc-grid">' + next.map(function (x) { return '<a class="sc" href="' + root + x[0] + '"><span class="ic">' + x[1] + '</span><span><b>' + bi(x[2], x[3]) + '</b></span><span class="go">→</span></a>'; }).join('') + '</div>'
      : '<p>' + bi('You have read every page on the reading list. Wow!', 'आपने reading list का हर page पढ़ लिया। वाह!') + '</p>';
    h += card('🧭 ' + bi('Next for you', 'आपके लिए अगला'), nh + '<p class="note">' + bi(nRead + ' pages read so far. Pages count as read after a few seconds on them; this list stays in this browser only.', 'अब तक ' + nRead + ' pages पढ़े। कोई page कुछ seconds खुला रहने पर पढ़ा माना जाता है; यह list सिर्फ़ इसी browser में रहती है।') + '</p>');

    // favourites
    var favs = ME.favs(), fh = favs.length ? '<div class="favlist">' + favs.map(function (id) { return '<span class="favitem"><a href="' + favHref(id) + '">★ ' + name(id) + '</a><button type="button" data-unfav="' + esc(id) + '" aria-label="Remove">×</button></span>'; }).join('') + '</div>'
      : '<p>' + bi('No favourites yet. Tap ☆ <b>Add to My space</b> on any <a href="' + root + 'planets.html">planet or moon</a>.', 'अभी कोई favourite नहीं। किसी भी <a href="' + root + 'planets.html">ग्रह या चाँद</a> पर ☆ <b>My space में जोड़ें</b> दबाइए।') + '</p>';
    h += card('⭐ ' + bi('Favourites', 'Favourites'), fh);

    // scores
    var sh = '<h3>' + bi('Planet quiz', 'ग्रहों की quiz') + '</h3><div class="stats">' +
      score(bi('Easy', 'आसान'), num('astryl-best-easy', 0), 10) + score(bi('Medium', 'मध्यम'), num('astryl-best-medium', 0), 10) + score(bi('Hard', 'कठिन'), num('astryl-best-hard', 0), 10) + '</div>' +
      '<h3>' + bi('Black hole and galaxy quiz', 'ब्लैक होल और galaxy quiz') + '</h3><div class="stats">' +
      score(bi('Black holes', 'ब्लैक होल'), num('astryl-ds-best-bh', 0), 5) + score(bi('Galaxies', 'Galaxies'), num('astryl-ds-best-gx', 0), 5) + score(bi('Mixed', 'मिला-जुला'), num('astryl-ds-best-all', 0), 5) + '</div>' +
      '<p><a class="btn" href="' + root + 'quiz.html">' + bi('Play a quiz', 'Quiz खेलिए') + '</a> <a class="btn" href="' + root + 'deep-space-quiz.html">' + bi('Deep space quiz', 'Deep space quiz') + '</a></p>';
    h += card('🏅 ' + bi('Best scores', 'सबसे अच्छे score'), sh);

    // black holes 101
    var done = list('astryl-bh101').filter(function (x) { return BH.indexOf(x) >= 0; }).length, bhBest = num('astryl-ds-best-bh', 0), explorer = done >= BH.length && bhBest >= 4;
    h += card('⚫ ' + bi('Black holes 101', 'Black holes 101'), bar(done, BH.length) + '<p>' + bi(done + ' of ' + BH.length + ' lessons read', BH.length + ' में से ' + done + ' पाठ पढ़े') + '</p><p><a class="btn" href="' + root + 'black-holes-101.html">' + bi(done ? 'Continue' : 'Start', done ? 'आगे पढ़िए' : 'शुरू कीजिए') + '</a></p>');

    // streak and badges
    var x = stats && stats.me_stats, bh = '';
    if (s && x) bh += '<p><b>' + (x.streak > 0 ? '🔥 ' + bi(x.streak + '-day Daily 5 streak', x.streak + ' दिन की Daily 5 streak') : bi('No Daily 5 streak right now.', 'अभी कोई Daily 5 streak नहीं।')) + '</b>' + (x.best ? ' · ' + bi('best ' + x.best, 'सबसे लंबी ' + x.best) : '') + '</p>';
    else if (s && !statsTried) bh += '<p class="note">' + bi('Loading your Daily 5 streak…', 'आपकी Daily 5 streak आ रही है…') + '</p>';
    else if (!s) bh += '<p class="note">' + bi('Daily 5 streaks and badges need an account.', 'Daily 5 की streak और badges के लिए खाता चाहिए।') + '</p>';
    var hard = num('astryl-best-hard', 0);
    var badges = [
      ['⚫', 'Black hole explorer', 'ब्लैक होल explorer', explorer],
      ['📚', 'Read 10 pages', '10 pages पढ़े', nRead >= 10],
      ['📖', 'Read 25 pages', '25 pages पढ़े', nRead >= 25],
      ['🧠', 'Planet quiz: hard 10/10', 'ग्रह quiz: कठिन 10/10', hard >= 10],
      ['⭐', 'First favourite', 'पहला favourite', favs.length >= 1]
    ];
    if (SKY) {
      var sn = Object.keys(SKY.seen()).length;
      badges.push(['👀', 'Seen 5 things', '5 चीज़ें देखीं', sn >= 5], ['🔭', 'Seen 10 things', '10 चीज़ें देखीं', sn >= 10], ['🌌', 'Seen them all', 'सब देख लिया', sn >= SKY.things.length]);
    }
    if (x) badges = badges.concat([
      ['🚀', 'First Daily 5', 'पहला Daily 5', x.plays >= 1], ['🔥', '3-day streak', '3 दिन की streak', x.best >= 3], ['🔥', '7-day streak', '7 दिन की streak', x.best >= 7],
      ['🏆', '30-day streak', '30 दिन की streak', x.best >= 30], ['🎯', 'Perfect 5 of 5', '5 में से 5 सही', x.perfect >= 1], ['🪐', '10 Daily 5 runs', '10 Daily 5', x.plays >= 10]
    ]);
    var got = badges.filter(function (b) { return b[3]; }).length;
    bh += '<div class="badges">' + badges.map(function (b) { return '<span class="' + (b[3] ? 'on' : 'off') + '">' + b[0] + ' ' + bi(b[1], b[2]) + '</span>'; }).join('') + '</div><p class="note">' + bi(got + ' of ' + badges.length + ' badges', badges.length + ' में से ' + got + ' badges') + '</p>';
    h += card('🎖️ ' + bi('Streak and badges', 'Streak और badges'), bh);

    h += '<p class="note">' + bi('Want a fresh start with the reading list? This clears which pages you have read, in this browser only.', 'Reading list नए सिरे से शुरू करनी है? इससे सिर्फ़ इस browser में पढ़े गए pages की list मिटेगी।') + ' <button class="btn" type="button" id="myReset">' + bi('Clear', 'मिटाएँ') + '</button></p>';
    box.innerHTML = h;
    if (SKY) { pk.wire(box); cal.wire(box.querySelector('#calendar').nextElementSibling); }
    if (location.hash === '#calendar' && !scrolled) { scrolled = true; var cEl = document.getElementById('calendar'); if (cEl) cEl.scrollIntoView(); }
  }
  var scrolled = false;

  box.addEventListener('click', function (e) {
    var sv = e.target.closest('[data-seen]');
    if (sv && window.ASTRYL_SKY) { window.ASTRYL_SKY.toggleSeen(sv.getAttribute('data-seen')); draw(); return; }
    var u = e.target.closest('[data-unfav]');
    if (u) { ME.toggleFav(u.getAttribute('data-unfav')); draw(); return; }
    if (e.target.closest('#myReset')) {
      try { localStorage.removeItem('astryl-read'); } catch (err) { }
      draw();
    }
  });

  draw();
  if (window.ASTRYL_SKY) window.ASTRYL_SKY.autoLocate(draw);
  if (ACCT && ACCT.session()) {
    ACCT.token().then(function (k) { return ACCT.api('board', {}, k); }).then(function (j) { stats = j; }, function () { }).then(function () { statsTried = true; draw(); });
    if (ACCT.prefs().syncOn) ACCT.sync().then(draw);
  }
})();
