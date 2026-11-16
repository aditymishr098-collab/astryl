/* The Astryl blog: comments from readers (no account needed), comment counts on the list,
   and the "time machine to the future" calculator in the time travel post. */
(function () {
  var URL_ = 'https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/community';
  function esc(x) { return String(x == null ? '' : x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function get(k, d) { try { var v = localStorage.getItem(k); return v == null ? d : v; } catch (e) { return d; } }
  function set(k, v) { try { localStorage.setItem(k, v); } catch (e) { } }
  // the same random browser id the community page uses (lets people delete their own comment)
  function device() { var d = get('astryl-device', ''); if (!d) { d = ''; for (var i = 0; i < 24; i++) d += 'abcdefghijklmnopqrstuvwxyz0123456789'[Math.floor(Math.random() * 36)]; set('astryl-device', d); } return d; }
  function call(action, body) {
    return fetch(URL_, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(Object.assign({ action: action }, body || {})) })
      .then(function (r) { return r.json().then(function (j) { if (!r.ok) throw new Error(j.error || 'error'); return j; }); });
  }
  var HUES = [210, 260, 330, 20, 45, 150, 180, 290];
  function hue(n) { var h = 0; for (var i = 0; i < n.length; i++) h = (h * 31 + n.charCodeAt(i)) >>> 0; return HUES[h % HUES.length]; }
  function ago(s) {
    var d = (new Date(s).getTime() - Date.now()) / 1000, a = Math.abs(d);
    try {
      var rt = new Intl.RelativeTimeFormat('en', { numeric: 'auto' });
      if (a < 60) return 'just now';
      if (a < 3600) return rt.format(Math.round(d / 60), 'minute');
      if (a < 86400) return rt.format(Math.round(d / 3600), 'hour');
      if (a < 86400 * 30) return rt.format(Math.round(d / 86400), 'day');
    } catch (e) { }
    return new Date(s).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
  }
  var ERR = {
    too_short: 'Please write a little more.', too_long: 'Please keep it under 1,000 characters.', no_links: 'Links and web addresses are not allowed in comments.',
    slow_down: 'Please wait a minute before posting again.', day_limit: 'You have reached today’s comment limit. Please come back tomorrow.', busy: 'Lots of people are commenting right now. Please try again in a minute.'
  };
  var REASONS = [['rude', '😠 Rude or hurtful'], ['spam', '📢 Spam or advertising'], ['personal', '🔒 Shares personal details'], ['offtopic', '🌍 Not about the post'], ['other', '❔ Something else']];

  /* ---------- comment counts on the list of posts ---------- */
  var cc = document.querySelectorAll('[data-cc]');
  if (cc.length) call('blog_counts').then(function (j) {
    cc.forEach(function (el) { var n = j.counts[el.getAttribute('data-cc')] || 0; el.textContent = '💬 ' + n + (n === 1 ? ' comment' : ' comments'); });
  }).catch(function () { });

  /* ---------- comments under a post ---------- */
  var sec = document.getElementById('comments'), box = document.getElementById('blogComments');
  if (sec && box) {
    var slug = sec.getAttribute('data-slug'), list = [];
    function item(c) {
      var nm = c.name || 'Guest';
      return '<li class="bcm" data-id="' + esc(c.id) + '"><span class="cav" style="--h:' + hue(nm) + '" aria-hidden="true">' + esc(nm.charAt(0).toUpperCase()) + '</span><div class="bcmb"><p class="bcmh"><b>' + esc(nm) + '</b> <small class="note">' + ago(c.at) + '</small></p><p class="bcmt">' + esc(c.body).replace(/\n/g, '<br>') + '</p>' +
        '<div class="bcma">' + (c.mine ? '<button type="button" class="linkbtn" data-a="del">🗑 Delete</button>' : '<button type="button" class="linkbtn" data-a="rep">⚑ Report</button>') + '</div></div></li>';
    }
    function draw() {
      box.innerHTML = '<form class="card bcform" novalidate><label>Your name <small class="note">(optional)</small><input name="name" maxlength="30" autocomplete="nickname" placeholder="Guest" value="' + esc(get('astryl-blog-name', '')) + '"></label>' +
        '<label>Your comment<textarea name="body" rows="4" maxlength="1000" required placeholder="What do you think? Questions are welcome too."></textarea></label>' +
        '<label class="bchp" aria-hidden="true">Leave this empty<input name="website" tabindex="-1" autocomplete="off"></label>' +
        '<div class="bcfoot"><small class="note"><span data-n>0</span>/1000 · Please be kind. No links. Comments appear right away; reported ones are checked by a moderator.</small><button class="btn primary" type="submit">Post comment</button></div><p class="bcerr no" role="alert" hidden></p></form>' +
        '<p class="note" data-count></p><ol class="bclist">' + list.map(item).join('') + '</ol>';
      box.querySelector('[data-count]').textContent = list.length ? list.length + (list.length === 1 ? ' comment' : ' comments') : 'No comments yet. Be the first!';
    }
    function load() {
      call('blog_comments', { slug: slug, device: device() }).then(function (j) { list = j.comments; draw(); })
        .catch(function () { box.innerHTML = '<p class="no">Could not load the comments. Please try again later.</p>'; });
    }
    box.addEventListener('input', function (e) { if (e.target.name === 'body') box.querySelector('[data-n]').textContent = e.target.value.length; });
    box.addEventListener('submit', function (e) {
      e.preventDefault();
      var f = e.target, btn = f.querySelector('button[type=submit]'), err = f.querySelector('.bcerr');
      var body = f.body.value.trim(), name = f.name.value.trim();
      err.hidden = true;
      if (body.length < 2) { err.textContent = ERR.too_short; err.hidden = false; return; }
      if (/(https?:|www\.)/i.test(body)) { err.textContent = ERR.no_links; err.hidden = false; return; }
      btn.disabled = true; btn.textContent = 'Posting…';
      set('astryl-blog-name', name);
      call('blog_comment', { slug: slug, name: name, body: body, website: f.website.value, device: device() }).then(function (j) {
        if (j.id) list.push({ id: j.id, name: j.name, body: j.body, at: j.at, mine: true });
        draw();
        var last = box.querySelector('.bclist li:last-child'); if (last) { last.classList.add('new'); last.scrollIntoView({ block: 'nearest', behavior: 'smooth' }); }
      }).catch(function (x) { err.textContent = ERR[x.message] || 'Could not post the comment. Please try again.'; err.hidden = false; btn.disabled = false; btn.textContent = 'Post comment'; });
    });
    box.addEventListener('click', function (e) {
      var b = e.target.closest('[data-a]'); if (!b) return;
      var li = b.closest('.bcm'), id = li.getAttribute('data-id'), a = b.getAttribute('data-a');
      if (a === 'del') {
        if (b.getAttribute('data-sure') !== '1') { b.setAttribute('data-sure', '1'); b.textContent = '🗑 Tap again to delete'; return; }
        li.style.opacity = '.4';
        call('blog_delete', { id: id, device: device() }).then(function () { list = list.filter(function (c) { return c.id !== id; }); draw(); }).catch(function () { li.style.opacity = ''; });
      } else if (a === 'rep') {
        var m = li.querySelector('.bcrep');
        if (m) { m.remove(); return; }
        li.querySelector('.bcmb').insertAdjacentHTML('beforeend', '<div class="bcrep card"><p><b>Why are you reporting this comment?</b></p>' + REASONS.map(function (r) { return '<button type="button" class="btn" data-a="why" data-r="' + r[0] + '">' + r[1] + '</button>'; }).join('') + '</div>');
      } else if (a === 'why') {
        var rep = li.querySelector('.bcrep');
        rep.innerHTML = '<p class="note">⏳ Sending…</p>';
        call('blog_report', { id: id, reason: b.getAttribute('data-r'), device: device() }).then(function () { rep.innerHTML = '<p class="ok">✓ Thank you. A moderator will look at it.</p>'; })
          .catch(function () { rep.innerHTML = '<p class="no">Could not send the report. Please try again.</p>'; });
      }
    });
    load();
  }

  /* ---------- the time machine calculator ---------- */
  var tt = document.getElementById('ttCalc');
  if (tt) {
    var beta = 0.99, years = 5;
    function fmtN(n) { return n >= 1e6 ? (n / 1e6).toLocaleString('en-GB', { maximumFractionDigits: 2 }) + ' million' : n.toLocaleString('en-GB', { maximumFractionDigits: n < 10 ? 2 : 0 }); }
    function upd() {
      var g = 1 / Math.sqrt(1 - beta * beta), e = years * g;
      tt.querySelector('#ttY').textContent = years;
      tt.querySelector('#ttG').textContent = fmtN(g);
      tt.querySelector('#ttE').textContent = fmtN(e) + ' years';
      tt.querySelector('#ttA').textContent = e < 1e6 ? String(new Date().getFullYear() + Math.round(e)) : 'far, far future';
      tt.querySelectorAll('[data-b]').forEach(function (b) { b.classList.toggle('on', +b.getAttribute('data-b') === beta); b.setAttribute('aria-pressed', +b.getAttribute('data-b') === beta); });
    }
    tt.addEventListener('click', function (e) { var b = e.target.closest('[data-b]'); if (b) { beta = +b.getAttribute('data-b'); upd(); } });
    tt.querySelector('input').addEventListener('input', function (e) { years = +e.target.value; upd(); });
    upd();
  }
})();
