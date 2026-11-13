/* Moderation for the Astryl Community (only for accounts listed as moderators on the server).
   Photos and posts go public at once; anything reported comes here (hidden after three reports).
   Keep it, or remove it for good. */
(function () {
  var ACCT = window.ASTRYL_ACCT, box = document.getElementById('mod');
  if (!box) return;
  var URL_ = 'https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/community';
  var root = document.body.getAttribute('data-root') || '';
  function esc(x) { return String(x == null ? '' : x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function call(action, body) {
    return ACCT.token().then(function (tok) {
      return fetch(URL_, { method: 'POST', headers: { 'Content-Type': 'application/json', 'x-astryl-token': tok }, body: JSON.stringify(Object.assign({ action: action }, body || {})) });
    }).then(function (r) { return r.json().then(function (j) { if (!r.ok) throw new Error(j.error || 'error'); return j; }); });
  }
  var WHY = { rude: '😠 rude', spam: '📢 spam', personal: '🔒 personal details', offtopic: '🌍 not about space', other: '❔ other', user: '❔ other' };
  function why(w) { var k = Object.keys(w || {}); return k.length ? '<p class="note">Reasons: ' + k.map(function (r) { return esc(WHY[r] || r) + ' ×' + w[r]; }).join(', ') + '</p>' : ''; }
  function when(s) { return new Date(s).toLocaleString('en-GB', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' }); }
  function draw(q) {
    var h = '<p class="note">' + q.photos.length + ' photos and ' + q.posts.length + ' posts reported. <button type="button" class="btn" data-m="reload">↻ Refresh</button></p>';
    h += '<h2>Photos</h2>' + (q.photos.length ? q.photos.map(function (p) {
      return '<div class="card mitem" data-k="photo" data-id="' + p.id + '"><img src="data:image/jpeg;base64,' + p.thumb + '" alt="" data-m="big"><div><b>' + esc(p.title) + '</b><br><small class="note">' + esc(p.kind) + (p.taken ? ' · ' + esc(p.taken) : '') + ' · by ' + esc(p.by) + ' · ' + when(p.at) + '</small>' +
        (p.status === 'approved' ? '<p class="no">⚠️ Still public, reported ' + p.reports + '×</p>' : '<p class="no">🙈 Hidden after ' + p.reports + ' reports</p>') + why(p.why) +
        '<div class="btns"><button type="button" class="btn primary" data-m="approve">✓ ' + (p.status === 'approved' ? 'Keep' : 'Show again') + '</button><button type="button" class="btn" data-m="remove">✕ Remove</button></div></div></div>';
    }).join('') : '<p class="note">Nothing to check.</p>');
    h += '<h2>Posts</h2>' + (q.posts.length ? q.posts.map(function (p) {
      return '<div class="card mitem" data-k="post" data-id="' + p.id + '"><div><small class="note">' + esc(p.kind) + ' · by <b>' + esc(p.by) + '</b> · ' + when(p.at) + '</small>' +
        (p.replyTo !== null ? '<p class="note">↩ Reply to: “' + esc(p.replyTo).slice(0, 140) + '”</p>' : '') + '<p class="mbody">' + esc(p.body).replace(/\n/g, '<br>') + '</p>' +
        (p.status === 'approved' ? '<p class="no">⚠️ Still public, reported ' + p.reports + '×</p>' : '<p class="no">🙈 Hidden after ' + p.reports + ' reports</p>') + why(p.why) +
        '<div class="btns"><button type="button" class="btn primary" data-m="approve">✓ ' + (p.status === 'approved' ? 'Keep' : 'Show again') + '</button><button type="button" class="btn" data-m="remove">✕ Remove</button></div></div></div>';
    }).join('') : '<p class="note">Nothing to check.</p>');
    box.innerHTML = h;
  }
  function load() {
    var s = ACCT && ACCT.session && ACCT.session();
    if (!s) { box.innerHTML = '<p>Please <a href="' + root + 'account.html?mode=login">log in</a> with your moderator account.</p>'; return; }
    box.innerHTML = '<p class="note">⏳ Loading…</p>';
    call('admin_queue').then(draw).catch(function (e) {
      box.innerHTML = e.message === 'not_admin' ? '<p class="no">This account is not a moderator.</p>' : '<p class="no">Could not load: ' + esc(e.message) + '</p>';
    });
  }
  box.addEventListener('click', function (e) {
    var b = e.target.closest('[data-m]'); if (!b) return;
    var m = b.dataset.m;
    if (m === 'reload') return load();
    var it = b.closest('.mitem');
    if (m === 'big') {
      call('admin_photo', { id: it.dataset.id }).then(function (j) { var lb = document.createElement('div'); lb.className = 'lightbox'; lb.innerHTML = '<img src="data:image/jpeg;base64,' + j.full + '" alt="">'; lb.onclick = function () { lb.remove(); }; document.body.appendChild(lb); });
      return;
    }
    it.style.opacity = '.4';
    call('admin_decide', { kind: it.dataset.k, id: it.dataset.id, verdict: m }).then(function () { it.remove(); }).catch(function (x) { it.style.opacity = ''; alertBox(it, x.message); });
  });
  function alertBox(it, msg) { it.insertAdjacentHTML('beforeend', '<p class="no">Failed: ' + esc(msg) + '</p>'); }
  load();
})();
