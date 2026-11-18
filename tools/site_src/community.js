/* Astryl Community page: the sky photo gallery and the questions-and-answers board.
   Photos and posts appear at once. People can edit or delete their own, and report anything
   else (with a reason); reported items go to the moderator and are hidden after three reports.
   Talks to the "community" Edge Function. */
(function () {
  var API = window.ASTRYL_API, ACCT = window.ASTRYL_ACCT, C = window.ASTRYL_COMMUNITY;
  if (!API || !C) return;
  var URL_ = 'https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/community';
  var root = document.body.getAttribute('data-root') || '';
  function lang() { return API.lang ? API.lang() : 'en'; }
  function hi() { return lang() === 'hi'; }
  function T(en, h) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + h + '</span>'; }
  function L(p) { return hi() ? p[1] : p[0]; }
  function esc(x) { return String(x == null ? '' : x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function locale() { return { hi: 'hi-IN', es: 'es', pt: 'pt-BR', fr: 'fr', ar: 'ar' }[lang()] || 'en-GB'; }
  function num(v) { return Number(v || 0).toLocaleString(locale()); }
  function get(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } }
  function set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { } }
  function $(id) { return document.getElementById(id); }
  function session() { return ACCT && ACCT.session && ACCT.session(); }
  function device() { var d = get('astryl-device', ''); if (!d) { d = ''; for (var i = 0; i < 24; i++) d += 'abcdefghijklmnopqrstuvwxyz0123456789'[Math.floor(Math.random() * 36)]; set('astryl-device', d); } return d; }
  function call(action, body, needLogin) {
    var go = function (tok) {
      var h = { 'Content-Type': 'application/json' }; if (tok) h['x-astryl-token'] = tok;
      return fetch(URL_, { method: 'POST', headers: h, body: JSON.stringify(Object.assign({ action: action }, body || {})) }).then(function (r) {
        return r.json().catch(function () { return {}; }).then(function (j) { if (!r.ok) { var e = new Error(j.error || 'server_error'); e.code = j.error; throw e; } return j; });
      });
    };
    if (session()) return ACCT.token().then(go, function () { if (needLogin) throw new Error('no_token'); return go(null); });
    if (needLogin) return Promise.reject(Object.assign(new Error('no_token'), { code: 'no_token' }));
    return go(null);
  }
  var ERR = {
    no_token: ['Please log in first.', 'पहले log in कीजिए।'], too_short: ['That is too short.', 'यह बहुत छोटा है।'], too_long: ['That is too long.', 'यह बहुत लंबा है।'],
    no_links: ['Links are not allowed.', 'Links की अनुमति नहीं है।'], no_contacts: ['Phone numbers and e-mail addresses are not allowed. Never share them here.', 'फ़ोन नंबर और e-mail की अनुमति नहीं है। इन्हें यहाँ कभी न लिखें।'],
    photo_limit: ['You can send 3 photos a day.', 'आप दिन में 3 फ़ोटो भेज सकते हैं।'], post_limit: ['You can post 10 times a day.', 'आप दिन में 10 बार लिख सकते हैं।'],
    edit_limit: ['You can edit 20 times a day.', 'आप दिन में 20 बार बदलाव कर सकते हैं।'],
    too_big: ['The photo is too big.', 'फ़ोटो बहुत बड़ी है।'], not_jpeg: ['That file is not a photo we can use.', 'यह फ़ाइल ऐसी फ़ोटो नहीं जिसे हम इस्तेमाल कर सकें।']
  };
  function errText(e) { var m = ERR[e && (e.code || e.message)]; return m ? L(m) : (hi() ? 'कुछ गड़बड़ हुई, फिर कोशिश कीजिए।' : 'Something went wrong, please try again.'); }
  function loginBtn(en, h) { return '<a class="btn primary" href="' + root + 'account.html?mode=login">' + T(en, h) + '</a>'; }
  var REASONS = [['rude', '😠', 'Rude or hurtful', 'बुरा या चोट पहुँचाने वाला'], ['spam', '📢', 'Spam or advertising', 'Spam या विज्ञापन'], ['personal', '🔒', 'Shares personal details', 'निजी जानकारी है'], ['offtopic', '🌍', 'Not about space', 'अंतरिक्ष से जुड़ा नहीं'], ['other', '❔', 'Something else', 'कुछ और']];

  /* small helpers for people and time */
  var HUES = [210, 260, 330, 20, 45, 150, 180, 290];
  function avatar(name) {
    var n = String(name || '?'), h = 0; for (var i = 0; i < n.length; i++) h = (h * 31 + n.charCodeAt(i)) >>> 0;
    return '<span class="cav" style="--h:' + HUES[h % HUES.length] + '" aria-hidden="true">' + esc(n.charAt(0).toUpperCase() || '?') + '</span>';
  }
  function ago(s) {
    var t = new Date(s).getTime(); if (!t) return '';
    var d = (t - Date.now()) / 1000, a = Math.abs(d);
    try {
      var rt = new Intl.RelativeTimeFormat(locale(), { numeric: 'auto' });
      if (a < 60) return rt.format(0, 'second');
      if (a < 3600) return rt.format(Math.round(d / 60), 'minute');
      if (a < 86400) return rt.format(Math.round(d / 3600), 'hour');
      if (a < 86400 * 30) return rt.format(Math.round(d / 86400), 'day');
    } catch (e) { }
    return new Date(t).toLocaleDateString(locale(), { day: 'numeric', month: 'short', year: 'numeric' });
  }
  function who(name) { return '<a class="plink" href="' + root + 'profile.html?u=' + encodeURIComponent(name) + '">' + esc(name) + '</a>'; }
  function edited(x) { return x.edited ? ' · <i>' + T('edited', 'बदला गया') + '</i>' : ''; }
  function kindOf(list, k) { return list.filter(function (p) { return p[0] === k; })[0]; }

  var H = null, G = null, P = null;
  var tab = /talk/.test(location.hash) ? 'talk' : 'gallery';
  var gView = get('astryl-cm-view', 0) || (window.matchMedia && matchMedia('(max-width:620px)').matches ? 1 : 2), gMoreBusy = false;
  var gKind = 'all', gSort = 'new', pFilter = 'all', reply = null, editing = null;

  /* ---------- hero numbers and tabs ---------- */
  function drawTop() {
    var n = H && H.numbers, box = $('cmNums');
    if (box) box.innerHTML = n ? [[n.photos, '📷', 'photos', 'फ़ोटो'], [n.questions, '❓', 'questions', 'सवाल'], [n.answers, '💬', 'answers', 'जवाब']].map(function (x) {
      return '<span><b>' + num(x[0]) + '</b> ' + x[1] + ' ' + T(x[2], x[3]) + '</span>';
    }).join('') : '';
    var a = $('cmAdmin'); if (a) a.hidden = !(H && H.admin);
    var me = $('cmMe'), ss = session(); if (me) { me.hidden = !(ss && ss.username); if (ss && ss.username) me.href = root + 'profile.html?u=' + encodeURIComponent(ss.username); }
    document.querySelectorAll('[data-tab]').forEach(function (b) { var on = b.dataset.tab === tab; b.classList.toggle('on', on); b.setAttribute('aria-selected', on ? 'true' : 'false'); });
    var g = $('gallery'), t = $('talk'); if (g) g.hidden = tab !== 'gallery'; if (t) t.hidden = tab !== 'talk';
  }
  function setTab(t, scroll) {
    tab = t; drawTop();
    try { history.replaceState(null, '', '#' + t); } catch (e) { }
    if (scroll) { var bar = $('cmTabs'); if (bar) window.scrollTo({ top: bar.getBoundingClientRect().top + window.scrollY - 70, behavior: 'smooth' }); }
  }

  /* ---------- gallery ---------- */
  function drawGallery() {
    var box = $('cmGallery'); if (!box) return;
    var h = '<div class="cmbar"><div class="chips" role="group">' + [['all', '✨', 'All', 'सब']].concat(C.photoKinds).map(function (k) {
      var lab = k[0] === 'all' ? T(k[2], k[3]) : T(esc(k[2]).replace(/ \(.*\)$/, ''), esc(k[3]).replace(/ \(.*\)$/, ''));
      return '<button type="button" class="chip' + (gKind === k[0] ? ' on' : '') + '" data-gkind="' + k[0] + '">' + k[1] + ' ' + lab + '</button>';
    }).join('') + '</div><div class="seg cmview" role="group" aria-label="Layout"><button type="button" data-gview="1" class="' + (gView === 1 ? 'on' : '') + '" aria-label="One big photo per row">▮</button><button type="button" data-gview="2" class="' + (gView === 2 ? 'on' : '') + '" aria-label="Two photos per row">▮▮</button></div><div class="seg"><button type="button" data-gsort="new" class="' + (gSort === 'new' ? 'on' : '') + '">🕒 ' + T('Newest', 'नई') + '</button><button type="button" data-gsort="top" class="' + (gSort === 'top' ? 'on' : '') + '">⭐ ' + T('Most stars', 'सबसे ज़्यादा ⭐') + '</button></div></div>';
    h += '<div id="cmUpBox"></div>';
    if (G && G.pending) h += '<p class="note">⏳ ' + num(G.pending) + ' ' + T('of your photos are hidden after reports, waiting for the moderator.', 'आपकी फ़ोटो शिकायतों के बाद छिपी हैं, moderator का इंतज़ार कर रही हैं।') + '</p>';
    if (!G) h += '<div class="cgal">' + '<div class="cph sk"></div>'.repeat(6) + '</div>';
    else {
      var list = G.photos.filter(function (p) { return gKind === 'all' || p.kind === gKind; });
      if (gSort === 'top') list = list.slice().sort(function (a, b) { return (b.stars - a.stars) || (a.at < b.at ? 1 : -1); });
      if (!list.length) h += empty('📷', G.photos.length ? T('No photos of this kind yet.', 'इस तरह की कोई फ़ोटो अभी नहीं।') : T('No photos yet. Be the first to share the sky!', 'अभी कोई फ़ोटो नहीं। आसमान बाँटने वाले पहले आप बनिए!'), 'photo');
      else h += '<div class="cgal' + (gView === 1 ? ' one' : '') + '">' + list.map(photoCard).join('') + '</div>' +
        (G.more ? '<div class="cmmore"><button type="button" class="btn" data-more>' + (gMoreBusy ? '⏳ ' : '') + T('Show more photos', 'और फ़ोटो') + '</button></div>' : '');
    }
    box.innerHTML = h;
    layoutGallery();
  }
  /* Photos keep their own shape: each card spans as many 8 px grid rows as its height needs. */
  function layoutGallery() {
    var g = document.querySelector('#cmGallery .cgal'); if (!g || !g.children.length) return;
    [].forEach.call(g.querySelectorAll('img:not([data-lw])'), function (im) { im.setAttribute('data-lw', '1'); if (!im.complete) im.addEventListener('load', function () { clearTimeout(layT); layT = setTimeout(layoutGallery, 60); }); });
    [].forEach.call(g.children, function (c) {
      var im = c.querySelector('img'), r = im && Number(im.getAttribute('data-r')) || 1;
      var w = c.getBoundingClientRect().width, cap = c.querySelector('figcaption');
      var hgt = w / r + (cap ? cap.getBoundingClientRect().height : 0);
      c.style.gridRowEnd = 'span ' + Math.ceil((hgt + 14) / 8);
    });
  }
  var layT = null; window.addEventListener('resize', function () { clearTimeout(layT); layT = setTimeout(layoutGallery, 120); });
  function loadMore() {
    if (!G || !G.more || gMoreBusy) return;
    var last = G.photos[G.photos.length - 1]; gMoreBusy = true; drawGallery();
    call('photos', { before: last.at }).then(function (j) {
      gMoreBusy = false; if (j && Array.isArray(j.photos)) { G.photos = G.photos.concat(j.photos); G.more = !!j.more; } drawGallery();
    }).catch(function () { gMoreBusy = false; drawGallery(); });
  }
  function photoCard(p) {
    var k = kindOf(C.photoKinds, p.kind);
    return '<figure class="cph" data-pid="' + esc(p.id) + '"><button type="button" class="cphimg" data-open="' + esc(p.id) + '" aria-label="' + esc(p.title) + '"><img src="' + URL_ + '?action=img&size=thumb&id=' + encodeURIComponent(p.id) + '" alt="' + esc(p.title) + '" loading="lazy" data-r="' + ratio(p) + '" style="aspect-ratio:' + ratio(p) + '"></button>' +
      '<figcaption><span class="ckind">' + (k ? k[1] : '') + '</span><b>' + esc(p.title) + '</b><small>' + avatar(p.by) + who(p.by) + ' · ' + ago(p.at) + '</small>' +
      '<span class="cact"><button type="button" class="star' + (p.starred ? ' on' : '') + '" data-star="' + esc(p.id) + '" aria-label="' + (hi() ? 'Star दें' : 'Give a star') + '">⭐ ' + num(p.stars) + '</button>' + menu('photo', p) + '</span></figcaption></figure>';
  }
  function empty(icon, text, what) {
    var btn = session() ? '<button type="button" class="btn primary" data-new="' + what + '">' + (what === 'photo' ? '📷 ' + T('Share a photo', 'फ़ोटो भेजिए') : '❓ ' + T('Ask a question', 'सवाल पूछिए')) + '</button>'
      : loginBtn('Log in to take part', 'हिस्सा लेने के लिए log in कीजिए');
    return '<div class="cmempty"><div class="cmeic">' + icon + '</div><p>' + text + '</p>' + btn + '</div>';
  }
  function ratio(p) { var r = p.w && p.h ? p.w / p.h : 1; return Math.max(0.5, Math.min(2.2, r)).toFixed(3); }
  function photoById(id) { return G && G.photos.filter(function (p) { return p.id === id; })[0]; }
  function shownList() {
    var list = G ? G.photos.filter(function (p) { return gKind === 'all' || p.kind === gKind; }) : [];
    if (gSort === 'top') list = list.slice().sort(function (a, b) { return (b.stars - a.stars) || (a.at < b.at ? 1 : -1); });
    return list;
  }
  function openPhoto(id) {
    var p = photoById(id); if (!p) return;
    var old = document.querySelector('.cmlb'); if (old) old.remove();
    var list = shownList(), at = list.indexOf(p), k = kindOf(C.photoKinds, p.kind);
    var box = document.createElement('div'); box.className = 'lightbox cmlb'; box.setAttribute('role', 'dialog'); box.setAttribute('aria-label', p.title); box.tabIndex = -1;
    box.innerHTML = '<div class="cmlbin"><div class="cmlbimg"><img src="' + URL_ + '?action=img&size=full&id=' + encodeURIComponent(p.id) + '" alt="' + esc(p.title) + '">' +
      (at > 0 ? '<button type="button" class="cmlbnav prev" data-go="' + esc(list[at - 1].id) + '" aria-label="Previous photo">‹</button>' : '') +
      (at >= 0 && at < list.length - 1 ? '<button type="button" class="cmlbnav next" data-go="' + esc(list[at + 1].id) + '" aria-label="Next photo">›</button>' : '') + '</div>' +
      '<div class="cmlbcap" data-pid="' + esc(p.id) + '"><b>' + esc(p.title) + '</b><small>' + (k ? k[1] + ' ' + esc(L([k[2], k[3]])) : '') + (p.taken ? ' · 📍 ' + esc(p.taken) : '') + (list.length > 1 && at >= 0 ? ' · ' + (at + 1) + ' / ' + list.length : '') + '</small><small>' + avatar(p.by) + who(p.by) + ' · ' + ago(p.at) + edited(p) + '</small>' +
      '<span class="cact"><button type="button" class="star' + (p.starred ? ' on' : '') + '" data-star="' + esc(p.id) + '">⭐ ' + num(p.stars) + '</button>' + menu('photo', p) + '</span></div>' +
      '<button type="button" class="cmlbx" aria-label="Close">✕</button></div>';
    function close() { box.remove(); document.removeEventListener('keydown', key); }
    function key(e) {
      if (e.key === 'Escape') close();
      else if (e.key === 'ArrowLeft' && at > 0) openPhoto(list[at - 1].id);
      else if (e.key === 'ArrowRight' && at < list.length - 1) openPhoto(list[at + 1].id);
    }
    box.addEventListener('click', function (e) {
      var g = e.target.closest('[data-go]'); if (g) { document.removeEventListener('keydown', key); openPhoto(g.dataset.go); return; }
      if (e.target === box || e.target.closest('.cmlbx')) close();
    });
    var x0 = null;
    box.addEventListener('touchstart', function (e) { x0 = e.touches[0].clientX; }, { passive: true });
    box.addEventListener('touchend', function (e) {
      if (x0 === null) return; var dx = e.changedTouches[0].clientX - x0; x0 = null;
      if (Math.abs(dx) < 50) return;
      var n = dx < 0 ? at + 1 : at - 1; if (n >= 0 && n < list.length) { document.removeEventListener('keydown', key); openPhoto(list[n].id); }
    });
    document.addEventListener('keydown', key);
    document.body.appendChild(box); box.focus();
  }

  /* ---------- the ⋯ menu: edit and delete your own, report anybody else's ---------- */
  function menu(kind, x) {
    var items = x.mine
      ? '<button type="button" data-edit="' + kind + ':' + esc(x.id) + '">✏️ ' + T('Edit', 'बदलिए') + '</button><button type="button" class="danger" data-del="' + kind + ':' + esc(x.id) + '">🗑️ ' + T('Delete', 'हटाइए') + '</button>'
      : '<button type="button" data-rep="' + kind + ':' + esc(x.id) + '">🚩 ' + T('Report', 'शिकायत करें') + '</button>';
    return '<details class="cmenu"><summary aria-label="' + (hi() ? 'और विकल्प' : 'More options') + '">⋯</summary><div class="cmenup">' + items + '</div></details>';
  }
  function closeMenus(except) { document.querySelectorAll('details.cmenu[open]').forEach(function (d) { if (d !== except) d.open = false; }); }
  function reportBox(el, kind, id) {
    var holder = el.closest('figcaption, .cmlbcap, .post, .rep');
    var old = holder.querySelector('.cmrep'); if (old) { old.remove(); return; }
    holder.insertAdjacentHTML('beforeend', '<div class="cmrep"><b>' + T('Why are you reporting this?', 'आप शिकायत क्यों कर रहे हैं?') + '</b><div class="chips">' + REASONS.map(function (r) {
      return '<button type="button" class="chip" data-reason="' + r[0] + '" data-k="' + kind + '" data-id="' + esc(id) + '">' + r[1] + ' ' + T(r[2], r[3]) + '</button>';
    }).join('') + '</div><button type="button" class="linkbtn" data-repcancel>' + T('Cancel', 'रद्द करें') + '</button></div>');
  }
  function sure(el, label) {
    if (el.dataset.sure) return true;
    el.dataset.sure = '1'; el.dataset.old = el.innerHTML; el.innerHTML = label;
    setTimeout(function () { if (el.isConnected) { delete el.dataset.sure; el.innerHTML = el.dataset.old; } }, 4000);
    return false;
  }

  /* ---------- questions and answers ---------- */
  function composer(parent) {
    var kinds = C.postKinds.map(function (k) { return '<button type="button" class="chip' + (k[0] === 'question' ? ' on' : '') + '" data-pk="' + k[0] + '">' + k[1] + ' ' + T(esc(k[2]), esc(k[3])) + '</button>'; }).join('');
    return '<div class="pform' + (parent ? ' isreply' : ' card') + '">' + (parent ? '' : '<div class="chips pkinds">' + kinds + '</div>') +
      '<div class="pwrap">' + (session() ? avatar(session().username || '?') : '') + '<textarea class="pbody" maxlength="600" rows="' + (parent ? 2 : 3) + '" placeholder="' + (parent ? (hi() ? 'अपना जवाब लिखिए…' : 'Write your answer…') : (hi() ? 'अंतरिक्ष के बारे में कुछ भी पूछिए…' : 'Ask anything about space…')) + '"></textarea></div>' +
      '<div class="pfoot"><small class="note">' + T('No links, phone numbers, e-mail or address.', 'कोई link, फ़ोन नंबर, e-mail या पता नहीं।') + ' <span class="pcount">0/600</span></small>' +
      '<span class="btns">' + (parent ? '<button type="button" class="btn" data-reply="' + esc(parent) + '">' + T('Cancel', 'रद्द करें') + '</button>' : '') + '<button type="button" class="btn primary" data-psend="' + esc(parent || '') + '">' + (parent ? T('Answer', 'जवाब दीजिए') : T('Post', 'भेजिए')) + '</button></span></div><p class="cmerr no"></p></div>';
  }
  function drawPosts() {
    var box = $('cmPosts'); if (!box) return;
    var h = session() ? composer('') : '<div class="card cmjoin">' + avatar('?') + '<p>' + T('Log in to ask a question, answer others or tell everyone what you saw.', 'सवाल पूछने, दूसरों को जवाब देने या सबको बताने के लिए कि आपने क्या देखा, log in कीजिए।') + '</p>' + loginBtn('Log in', 'Log in करें') + '</div>';
    h += '<div class="cmbar"><div class="seg">' + [['all', 'All', 'सब'], ['open', 'Not answered yet', 'बिना जवाब']].concat(session() ? [['mine', 'Mine', 'मेरे']] : []).map(function (f) {
      return '<button type="button" data-pf="' + f[0] + '" class="' + (pFilter === f[0] ? 'on' : '') + '">' + T(f[1], f[2]) + '</button>';
    }).join('') + '</div></div>';
    if (P && P.pending) h += '<p class="note">⏳ ' + num(P.pending) + ' ' + T('of your posts are hidden after reports, waiting for the moderator.', 'आपकी posts शिकायतों के बाद छिपी हैं, moderator का इंतज़ार कर रही हैं।') + '</p>';
    if (!P) h += '<div class="card post sk"></div><div class="card post sk"></div>';
    else {
      var list = P.posts.filter(function (p) { return pFilter === 'all' || (pFilter === 'open' ? !p.replies.length : p.mine || p.replies.some(function (r) { return r.mine; })); });
      if (!list.length) h += empty('💬', P.posts.length ? T('Nothing here yet.', 'यहाँ अभी कुछ नहीं।') : T('No questions yet. Start the conversation!', 'अभी कोई सवाल नहीं। बातचीत शुरू कीजिए!'), 'post');
      else h += '<div class="cmplist">' + list.map(postCard).join('') + '</div>';
    }
    box.innerHTML = h;
  }
  function body(x, kind) {
    if (editing === kind + ':' + x.id) return '<div class="cmedit"><textarea class="ebody" maxlength="600" rows="3">' + esc(x.body) + '</textarea><div class="btns"><button type="button" class="btn primary" data-esave="post:' + esc(x.id) + '">' + T('Save', 'सहेजिए') + '</button><button type="button" class="btn" data-ecancel>' + T('Cancel', 'रद्द करें') + '</button></div><p class="cmerr no"></p></div>';
    return '<p class="pb">' + esc(x.body).replace(/\n/g, '<br>') + '</p>';
  }
  function postCard(p) {
    var k = kindOf(C.postKinds, p.kind);
    return '<article class="card post" data-pid="' + esc(p.id) + '"><header class="ph">' + avatar(p.by) + '<span class="pwho"><b>' + who(p.by) + '</b><small>' + ago(p.at) + edited(p) + '</small></span>' +
      (k ? '<span class="pbadge pb-' + esc(p.kind) + '">' + k[1] + ' ' + T(esc(k[2]), esc(k[3])) + '</span>' : '') + menu('post', p) + '</header>' + body(p, 'post') +
      '<div class="pact">' + (session() ? '<button type="button" class="linkbtn" data-reply="' + esc(p.id) + '">↩ ' + T('Answer', 'जवाब दीजिए') + '</button>' : '') + '<span class="note">💬 ' + num(p.replies.length) + ' ' + T(p.replies.length === 1 ? 'answer' : 'answers', 'जवाब') + '</span></div>' +
      (p.replies.length ? '<div class="replies">' + p.replies.map(function (r) {
        return '<div class="rep" data-pid="' + esc(r.id) + '"><header class="ph">' + avatar(r.by) + '<span class="pwho"><b>' + who(r.by) + '</b><small>' + ago(r.at) + edited(r) + '</small></span>' + menu('post', r) + '</header>' + body(r, 'post') + '</div>';
      }).join('') + '</div>' : '') +
      (reply === p.id ? composer(p.id) : '') + '</article>';
  }
  function findPost(id) {
    var hit = null; (P ? P.posts : []).forEach(function (p) { if (p.id === id) hit = p; p.replies.forEach(function (r) { if (r.id === id) hit = r; }); });
    return hit;
  }
  function editPhoto(el, id) {
    var p = photoById(id); if (!p) return;
    var holder = el.closest('figcaption, .cmlbcap');
    if (holder.querySelector('.cmedit')) return;
    holder.insertAdjacentHTML('beforeend', '<div class="cmedit"><label>' + T('Title', 'शीर्षक') + '<input type="text" class="etitle" maxlength="80" value="' + esc(p.title) + '"></label><label>' + T('Where and when', 'कहाँ और कब') + '<input type="text" class="etaken" maxlength="60" value="' + esc(p.taken || '') + '"></label><div class="btns"><button type="button" class="btn primary" data-esave="photo:' + esc(id) + '">' + T('Save', 'सहेजिए') + '</button><button type="button" class="btn" data-ecancel>' + T('Cancel', 'रद्द करें') + '</button></div><p class="cmerr no"></p></div>');
  }

  /* ---------- one click handler for the whole page ---------- */
  document.addEventListener('click', function (e) {
    var t = e.target, x;
    if (!t.closest('details.cmenu')) closeMenus(); else if (t.closest('summary')) closeMenus(t.closest('details.cmenu'));
    if ((x = t.closest('[data-tab]'))) { setTab(x.dataset.tab, true); return; }
    if ((x = t.closest('[data-new]'))) { newThing(x.dataset.new); return; }
    if (t.closest('#cmFab')) { $('cmFabMenu').hidden = !$('cmFabMenu').hidden; return; }
    if (!t.closest('#cmFabMenu') && $('cmFabMenu')) $('cmFabMenu').hidden = true;
    if ((x = t.closest('[data-gkind]'))) { gKind = x.dataset.gkind; drawGallery(); return; }
    if ((x = t.closest('[data-gsort]'))) { gSort = x.dataset.gsort; drawGallery(); return; }
    if ((x = t.closest('[data-pf]'))) { pFilter = x.dataset.pf; drawPosts(); return; }
    if ((x = t.closest('[data-open]'))) { openPhoto(x.dataset.open); return; }
    if ((x = t.closest('[data-gview]'))) { gView = +x.dataset.gview; set('astryl-cm-view', gView); drawGallery(); return; }
    if (t.closest('[data-more]')) { loadMore(); return; }
    if ((x = t.closest('[data-pk]'))) { x.parentNode.querySelectorAll('.chip').forEach(function (c) { c.classList.toggle('on', c === x); }); return; }
    if (t.closest('#cmCancel')) { $('cmUpBox').innerHTML = ''; upFile = null; return; }
    if ((x = t.closest('#cmSend'))) { sendPhoto(x); return; }
    if ((x = t.closest('[data-star]'))) { star(x); return; }
    if ((x = t.closest('[data-rep]'))) { var q = x.dataset.rep.split(':'); closeMenus(); reportBox(x, q[0], q[1]); return; }
    if (t.closest('[data-repcancel]')) { t.closest('.cmrep').remove(); return; }
    if ((x = t.closest('[data-reason]'))) {
      var box = x.closest('.cmrep'); box.innerHTML = '⏳';
      call('report', { kind: x.dataset.k, id: x.dataset.id, device: device(), reason: x.dataset.reason }).then(function () {
        box.innerHTML = '<span class="ok">✓ ' + T('Thank you. The moderator will look at it.', 'धन्यवाद। Moderator इसे देखेंगे।') + '</span>';
      }).catch(function (er) { box.innerHTML = '<span class="no">' + esc(errText(er)) + '</span>'; });
      return;
    }
    if ((x = t.closest('[data-del]'))) {
      var d = x.dataset.del.split(':');
      if (!sure(x, '⚠️ ' + T('Tap again to delete', 'हटाने के लिए फिर tap कीजिए'))) return;
      call('mine_delete', { kind: d[0], id: d[1] }, true).then(function () {
        var lb = document.querySelector('.cmlb'); if (lb) lb.remove();
        if (d[0] === 'photo') loadGallery(); else loadPosts(); loadHome();
      });
      return;
    }
    if ((x = t.closest('[data-edit]'))) {
      var ed = x.dataset.edit.split(':'); closeMenus();
      if (ed[0] === 'photo') editPhoto(x, ed[1]); else { editing = x.dataset.edit; drawPosts(); var ta = document.querySelector('.ebody'); if (ta) ta.focus(); }
      return;
    }
    if (t.closest('[data-ecancel]')) { var ce = t.closest('.cmedit'); editing = null; if (ce.closest('figcaption, .cmlbcap')) ce.remove(); else drawPosts(); return; }
    if ((x = t.closest('[data-esave]'))) { saveEdit(x); return; }
    if ((x = t.closest('[data-reply]'))) { reply = reply === x.dataset.reply ? null : x.dataset.reply; drawPosts(); var rt = document.querySelector('.isreply textarea'); if (rt) rt.focus(); return; }
    if ((x = t.closest('[data-psend]'))) { sendPost(x); return; }
  });
  document.addEventListener('input', function (e) {
    if (!e.target.matches('.pbody')) return;
    var c = e.target.closest('.pform').querySelector('.pcount'); if (c) c.textContent = e.target.value.length + '/600';
  });
  function newThing(what) {
    if (!session()) { location.href = root + 'account.html?mode=login'; return; }
    if (what === 'photo') { setTab('gallery', false); upForm(); }
    else { setTab('talk', false); var ta = document.querySelector('#cmPosts .pbody'); if (ta) { ta.scrollIntoView({ behavior: 'smooth', block: 'center' }); ta.focus(); } }
    var m = $('cmFabMenu'); if (m) m.hidden = true;
  }
  function sendPhoto(btn) {
    var err = $('cmUpErr'); err.textContent = '';
    if (!upFile) { err.textContent = hi() ? 'पहले फ़ोटो चुनिए।' : 'Choose a photo first.'; return; }
    if (!$('cmOwn').checked) { err.textContent = hi() ? 'कृपया पुष्टि कीजिए कि फ़ोटो आपकी खींची है।' : 'Please confirm that you took the photo.'; return; }
    btn.disabled = true; btn.textContent = '⏳';
    Promise.all([shrink(upFile, 1600, 0.85), shrink(upFile, 480, 0.8)]).then(function (r) {
      return call('upload', { own: true, title: $('cmTitle').value, kind: $('cmKind').value, taken: $('cmTaken').value, full: r[0].b64, thumb: r[1].b64, w: r[0].w, h: r[0].h }, true);
    }).then(function () {
      $('cmUpBox').innerHTML = '<p class="ok cmdone">✓ ' + T('Thank you! Your photo is now in the gallery.', 'धन्यवाद! आपकी फ़ोटो अब gallery में है।') + '</p>'; upFile = null; loadGallery(); loadHome();
    }).catch(function (x) { btn.disabled = false; btn.innerHTML = T('Share it', 'भेजिए'); err.textContent = errText(x); });
  }
  function star(st) {
    if (!session()) { st.insertAdjacentHTML('afterend', ' <small class="note">' + T('Log in to give stars.', 'Stars देने के लिए log in कीजिए।') + '</small>'); return; }
    call('star', { id: st.dataset.star }, true).then(function (j) {
      var p = photoById(st.dataset.star); if (p) { p.starred = j.on; p.stars = j.stars; }
      document.querySelectorAll('[data-star="' + st.dataset.star + '"]').forEach(function (b) { b.classList.toggle('on', j.on); b.textContent = '⭐ ' + num(j.stars); });
    }).catch(function () { });
  }
  function saveEdit(btn) {
    var q = btn.dataset.esave.split(':'), box = btn.closest('.cmedit'), err = box.querySelector('.cmerr');
    var data = q[0] === 'photo' ? { title: box.querySelector('.etitle').value, taken: box.querySelector('.etaken').value } : { body: box.querySelector('.ebody').value };
    btn.disabled = true;
    call('edit', Object.assign({ kind: q[0], id: q[1] }, data), true).then(function () {
      editing = null;
      if (q[0] === 'photo') { var p = photoById(q[1]); if (p) { p.title = data.title.trim(); p.taken = data.taken.trim() || null; p.edited = true; } var lb = document.querySelector('.cmlb'); if (lb) lb.remove(); drawGallery(); }
      else { var x = findPost(q[1]); if (x) { x.body = data.body.trim(); x.edited = true; } drawPosts(); }
    }).catch(function (x) { btn.disabled = false; err.textContent = errText(x); });
  }
  function sendPost(s) {
    var f = s.closest('.pform'), txt = f.querySelector('.pbody').value, k = f.querySelector('.pkinds .chip.on'), err = f.querySelector('.cmerr');
    s.disabled = true;
    call('post', { body: txt, kind: k ? k.dataset.pk : 'reply', parent: s.dataset.psend || null }, true).then(function () {
      reply = null; pFilter = 'all'; loadPosts(); loadHome();
    }).catch(function (x) { s.disabled = false; err.textContent = errText(x); });
  }

  /* ---------- load ---------- */
  function drawAll() { drawTop(); drawGallery(); drawPosts(); }
  function loadHome() { call('home', {}).then(function (j) { H = j && typeof j.admin === 'boolean' ? j : null; drawTop(); }).catch(function () { drawTop(); }); }
  function loadGallery() { call('photos', {}).then(function (j) { G = j && Array.isArray(j.photos) ? j : { photos: [], pending: 0 }; drawGallery(); }).catch(function () { G = { photos: [], pending: 0 }; drawGallery(); }); }
  function loadPosts() { call('posts', {}).then(function (j) { P = j && Array.isArray(j.posts) ? j : { posts: [], pending: 0 }; drawPosts(); }).catch(function () { P = { posts: [], pending: 0 }; drawPosts(); }); }
  window.addEventListener('hashchange', function () { var t = /talk/.test(location.hash) ? 'talk' : /gallery/.test(location.hash) ? 'gallery' : tab; if (t !== tab) setTab(t, false); });
  function tabsTop() { var hd = document.querySelector('header.top'), bar = $('cmTabs'); if (hd && bar) bar.style.setProperty('--cmtop', (hd.offsetHeight + 8) + 'px'); }
  window.addEventListener('resize', tabsTop); tabsTop();
  API.onRender(drawAll);
  drawAll(); loadHome(); loadGallery(); loadPosts();
})();
