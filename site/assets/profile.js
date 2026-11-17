/* A person's public Astryl page: profile.html?u=username. Shows what they shared in the
   community and, if they show themselves on the leaderboard, their Space Points and quiz badges. */
(function () {
  var box = document.getElementById('prof');
  if (!box) return;
  var ACCT = window.ASTRYL_ACCT, C = window.ASTRYL_COMMUNITY || { photoKinds: [], postKinds: [] };
  var URL_ = 'https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/community';
  var root = document.body.getAttribute('data-root') || '';
  function esc(x) { return String(x == null ? '' : x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function num(v) { return Number(v || 0).toLocaleString('en-GB'); }
  var LEVELS = [[0, '🧑‍🚀', 'Cadet'], [200, '✈️', 'Pilot'], [600, '🧭', 'Navigator'], [1500, '👩‍🚀', 'Astronaut'], [3500, '🚀', 'Commander'], [7000, '🌌', 'Galaxy Explorer']];
  // the same badges as the Quiz page
  var BADGES = [['photo', '📷', 'Photo expert: 10/10 photos'], ['cons', '⭐', 'Star gazer: 10/10 constellations'], ['stars', '🌟', 'Star expert: 10/10 stars'], ['missions', '🛰️', 'Space historian: 10/10'], ['hl', '⚖️', 'Sharp eye: 10/10 bigger or smaller'], ['est', '🎯', 'Great guesser: 40+ points'], ['easy', '🪐', 'Planets, easy: 10/10'], ['medium', '🌍', 'Planets, medium: 10/10'], ['hard', '🔥', 'Planets, hard: 10/10']];
  var HUES = [210, 260, 330, 20, 45, 150, 180, 290];
  function hue(n) { var h = 0; for (var i = 0; i < n.length; i++) h = (h * 31 + n.charCodeAt(i)) >>> 0; return HUES[h % HUES.length]; }
  function ago(s) {
    var d = (new Date(s).getTime() - Date.now()) / 1000, a = Math.abs(d);
    try {
      var rt = new Intl.RelativeTimeFormat('en', { numeric: 'auto' });
      if (a < 3600) return rt.format(Math.round(d / 60), 'minute');
      if (a < 86400) return rt.format(Math.round(d / 3600), 'hour');
      if (a < 86400 * 30) return rt.format(Math.round(d / 86400), 'day');
    } catch (e) { }
    return new Date(s).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
  }
  function kind(list, k) { return list.filter(function (x) { return x[0] === k; })[0]; }
  function level(p) { var l = LEVELS[0]; LEVELS.forEach(function (x) { if (p >= x[0]) l = x; }); return l; }
  function token() { var s = ACCT && ACCT.session && ACCT.session(); return s ? ACCT.token().catch(function () { return null; }) : Promise.resolve(null); }

  var u = (new URLSearchParams(location.search).get('u') || '').trim().toLowerCase();
  if (!u) { var s = ACCT && ACCT.session && ACCT.session(); if (s && s.username) u = s.username; }
  if (!/^[a-z0-9_]{3,20}$/.test(u)) {
    box.innerHTML = '<h1 class="sr-only">Profile</h1><div class="cmempty"><div class="cmeic">👤</div><p>No one to show. Open a profile by tapping a name in the community or on a leaderboard.</p><a class="btn primary" href="' + root + 'community.html">Open the community</a></div>';
    return;
  }
  box.innerHTML = '<div class="card post sk"></div><div class="cgal">' + '<div class="cph sk"></div>'.repeat(3) + '</div>';
  token().then(function (tok) {
    var h = { 'Content-Type': 'application/json' }; if (tok) h['x-astryl-token'] = tok;
    return fetch(URL_, { method: 'POST', headers: h, body: JSON.stringify({ action: 'profile', u: u }) });
  }).then(function (r) { return r.json().then(function (j) { if (!r.ok) throw new Error(j.error || 'error'); return j; }); }).then(draw).catch(function (e) {
    box.innerHTML = '<h1 class="sr-only">Profile</h1><div class="cmempty"><div class="cmeic">🔭</div><p>' + (e.message === 'no_user' ? 'There is no Astryl account called “' + esc(u) + '”.' : 'Could not load this profile. Please try again.') + '</p><a class="btn" href="' + root + 'community.html">Back to the community</a></div>';
  });

  function draw(p) {
    document.title = p.u + ' · Astryl';
    var since = new Date(p.since + '-01T00:00:00Z').toLocaleDateString('en-GB', { month: 'long', year: 'numeric' });
    var q = p.quiz, lv = q ? level(q.points) : null;
    var h = '<section class="prhead card"><span class="cav prav" style="--h:' + hue(p.u) + '" aria-hidden="true">' + esc(p.u.charAt(0).toUpperCase()) + '</span><div class="prwho"><h1 data-un="' + esc(p.u) + '">' + esc(p.u) + '</h1><p class="acuser">@' + esc(p.u) + '</p>' +
      '<p class="note">On Astryl since ' + esc(since) + (lv ? ' · ' + lv[1] + ' ' + lv[2] : '') + '</p>' +
      '<div class="prnums"><span><b>' + num(p.photos.length) + '</b> photos</span><span><b>' + num(p.questions.length) + '</b> questions</span><span><b>' + num(p.answers.length) + '</b> answers</span>' + (q ? '<span><b>' + num(q.points) + '</b> Space Points</span>' : '') + '</div>' +
      (p.mine ? '<p class="note">This is your public page. Everyone can see your photos and posts here.' + (q ? '' : ' Your points are hidden because you are not shown on the leaderboard.') + '</p>' : '') + '</div></section>';
    if (q) {
      h += '<section class="blk"><h2>🏅 Quiz badges</h2><p class="note">A badge for every ranked round answered 10 out of 10 (40 points or more in best guess). ' + num(q.rounds) + ' ranked rounds played.</p><div class="rbadges prbadges">' +
        BADGES.map(function (b) { var on = q.badges.indexOf(b[0]) >= 0; return '<span class="' + (on ? 'on' : '') + '" title="' + (on ? 'Earned' : 'Not yet') + '">' + b[1] + ' ' + esc(b[2]) + (on ? '' : ' <small>· not yet</small>') + '</span>'; }).join('') + '</div></section>';
    }
    h += '<section class="blk"><h2>📷 Sky photos</h2>' + (p.photos.length ? '<div class="cgal">' + p.photos.map(function (ph) {
      var k = kind(C.photoKinds, ph.kind);
      return '<figure class="cph"><a class="cphimg" href="' + root + 'community.html#gallery"><img src="' + URL_ + '?action=img&size=thumb&id=' + encodeURIComponent(ph.id) + '" alt="' + esc(ph.title) + '" loading="lazy"></a><figcaption><span class="ckind" aria-hidden="true">' + (k ? k[1] : '') + '</span><b>' + esc(ph.title) + '</b><small>⭐ ' + num(ph.stars) + ' · ' + ago(ph.at) + '</small></figcaption></figure>';
    }).join('') + '</div>' : '<p class="note">No photos shared yet.</p>') + '</section>';
    h += '<section class="blk"><h2>❓ Questions</h2>' + (p.questions.length ? p.questions.map(function (x) {
      var k = kind(C.postKinds, x.kind);
      return '<a class="card post prpost" href="' + root + 'community.html#talk"><header class="ph">' + (k ? '<span class="pbadge pb-' + esc(x.kind) + '">' + k[1] + ' ' + esc(k[2]) + '</span>' : '') + '<small class="note">' + ago(x.at) + ' · 💬 ' + num(x.replies) + ' ' + (x.replies === 1 ? 'answer' : 'answers') + '</small></header><p class="pb">' + esc(x.body) + '</p></a>';
    }).join('') : '<p class="note">No questions yet.</p>') + '</section>';
    h += '<section class="blk"><h2>💬 Answers</h2>' + (p.answers.length ? p.answers.map(function (x) {
      return '<a class="card post prpost" href="' + root + 'community.html#talk"><p class="note">↩ To: “' + esc(String(x.q).slice(0, 120)) + (String(x.q).length > 120 ? '…' : '') + '”</p><p class="pb">' + esc(x.body) + '</p><small class="note">' + ago(x.at) + '</small></a>';
    }).join('') : '<p class="note">No answers yet.</p>') + '</section>';
    box.innerHTML = h;
  }
})();
