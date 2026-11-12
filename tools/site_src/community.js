/* Astryl Community page: "I saw it" sky reports, the weekly challenge, polls, leaderboards, the
   photo gallery and the discussion board. Photos and posts appear only after the moderator approves
   them. Talks to the "community" Edge Function. */
(function () {
  var API = window.ASTRYL_API, ACCT = window.ASTRYL_ACCT, C = window.ASTRYL_COMMUNITY;
  if (!API || !C) return;
  var URL_ = 'https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/community';
  var root = document.body.getAttribute('data-root') || '';
  function hi() { return API.lang() === 'hi'; }
  function T(en, h) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + h + '</span>'; }
  function L(p) { return hi() ? p[1] : p[0]; }
  function esc(x) { return String(x == null ? '' : x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function num(v) { return Number(v || 0).toLocaleString(hi() ? 'hi-IN' : 'en-US'); }
  function get(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } }
  function set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { } }
  function $(id) { return document.getElementById(id); }
  function session() { return ACCT && ACCT.session && ACCT.session(); }
  function device() { var d = get('astryl-device', ''); if (!d) { d = ''; for (var i = 0; i < 24; i++) d += 'abcdefghijklmnopqrstuvwxyz0123456789'[Math.floor(Math.random() * 36)]; set('astryl-device', d); } return d; }
  function country() { var m = /[-_]([A-Z]{2})$/.exec(navigator.language || ''); return m ? m[1] : ''; }
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
    not_yet: ['Not done yet: play the round on the Quiz page while logged in, then come back.', 'अभी पूरा नहीं हुआ: log in करके Quiz page पर round खेलिए, फिर लौटिए।'],
    too_big: ['The photo is too big.', 'फ़ोटो बहुत बड़ी है।'], not_jpeg: ['That file is not a photo we can use.', 'यह फ़ाइल ऐसी फ़ोटो नहीं जिसे हम इस्तेमाल कर सकें।']
  };
  function errText(e) { var m = ERR[e && (e.code || e.message)]; return m ? L(m) : (hi() ? 'कुछ गड़बड़ हुई, फिर कोशिश कीजिए।' : 'Something went wrong, please try again.'); }
  function loginLink() { return '<a href="' + root + 'account.html?mode=login">' + T('Log in', 'Log in करें') + '</a>'; }

  var H = null; // data from "home"

  /* ---------- I saw it ---------- */
  function drawSeen() {
    var box = $('cmSeen'); if (!box) return;
    var mine = get('astryl-seen-today', {}), today = new Date().toISOString().slice(0, 10);
    if (mine.day !== today) mine = { day: today, w: {} };
    box.innerHTML = C.sky.map(function (s) {
      var n = H && H.seen[s[0]] || 0, on = mine.w[s[0]];
      return '<button type="button" class="seenb' + (on ? ' on' : '') + '" data-seen="' + s[0] + '"><span class="se">' + s[1] + '</span><b>' + esc(L([s[2], s[3]])) + '</b><small>' + (on ? '✓ ' + T('You saw it today', 'आज आपने देखा') : T('I saw it', 'मैंने देखा')) + '</small><span class="sn">' + num(n) + ' ' + T('this week', 'इस हफ़्ते') + '</span></button>';
    }).join('');
    var cs = H && H.countries ? Object.keys(H.countries).sort(function (a, b) { return H.countries[b] - H.countries[a]; }).slice(0, 8) : [];
    var dn = null; try { dn = new Intl.DisplayNames([hi() ? 'hi' : 'en'], { type: 'region' }); } catch (e) { }
    $('cmSeenNote').innerHTML = (H ? '<b>' + num(H.numbers.seen) + '</b> ' + T('sightings this week', 'इस हफ़्ते देखे गए') : '') + (cs.length ? ' · ' + cs.map(function (c) { return esc(dn ? dn.of(c) : c) + ' ' + num(H.countries[c]); }).join(' · ') : '');
  }
  document.addEventListener('click', function (e) {
    var b = e.target.closest('[data-seen]'); if (!b || b.classList.contains('on')) return;
    var w = b.dataset.seen, mine = get('astryl-seen-today', {}), today = new Date().toISOString().slice(0, 10);
    if (mine.day !== today) mine = { day: today, w: {} };
    mine.w[w] = 1; set('astryl-seen-today', mine);
    if (H) H.seen[w] = (H.seen[w] || 0) + 1;
    drawSeen();
    call('seen', { what: w, device: device(), country: country() }).catch(function () { });
  });

  /* ---------- weekly challenge ---------- */
  function drawChallenge() {
    var box = $('cmChallenge'); if (!box) return;
    if (!H) { box.innerHTML = '<p class="note">⏳</p>'; return; }
    box.innerHTML = H.challenges.map(function (c) {
      return '<div class="card chal' + (c.mine ? ' done' : '') + '"><span class="ck">' + (c.kind === 'quiz' ? '🏆' : '🔭') + '</span><p>' + esc(hi() ? c.hi : c.en) + '</p>' +
        '<p class="note">' + num(c.done) + ' ' + T('people have done it this week', 'लोगों ने इस हफ़्ते पूरा किया') + '</p>' +
        (c.mine ? '<b class="ok">✓ ' + T('Done! You earned this week’s badge.', 'हो गया! आपको इस हफ़्ते का badge मिला।') + '</b>' :
          (session() ? '<button type="button" class="btn primary" data-chal="' + c.id + '">' + (c.kind === 'quiz' ? T('Check my rounds', 'मेरे rounds जाँचिए') : T('I did it!', 'मैंने कर लिया!')) + '</button>' : '<p class="note">' + loginLink() + ' ' + T('to take part.', 'करके हिस्सा लीजिए।') + '</p>')) +
        (c.kind === 'quiz' && !c.mine ? ' <a class="btn" href="' + root + 'quiz.html">' + T('Go to the quiz', 'Quiz पर जाएँ') + ' →</a>' : '') + '<p class="cmerr no"></p></div>';
    }).join('');
    var got = get('astryl-challenge-badges', []);
    $('cmBadges').innerHTML = got.length ? '🏅 ' + T('Your challenge badges: ', 'आपके challenge badges: ') + got.length : '';
  }
  document.addEventListener('click', function (e) {
    var b = e.target.closest('[data-chal]'); if (!b) return;
    b.disabled = true;
    call('challenge', { id: b.dataset.chal }, true).then(function () {
      H.challenges.forEach(function (c) { if (c.id === b.dataset.chal) { c.mine = true; c.done++; } });
      var got = get('astryl-challenge-badges', []), key = H.week + ':' + b.dataset.chal; if (got.indexOf(key) < 0) { got.push(key); set('astryl-challenge-badges', got); }
      drawChallenge();
    }).catch(function (err) { b.disabled = false; b.parentNode.querySelector('.cmerr').textContent = errText(err); });
  });

  /* ---------- polls ---------- */
  function drawPolls() {
    var box = $('cmPolls'); if (!box) return;
    var voted = get('astryl-polls', {});
    box.innerHTML = C.polls.map(function (p) {
      var res = H && H.polls[p[0]] || p[3].map(function () { return 0; }), tot = res.reduce(function (a, b) { return a + b; }, 0), my = voted[p[0]];
      var h = '<div class="card poll"><h3>' + esc(L([p[1], p[2]])) + '</h3>';
      p[3].forEach(function (o, i) {
        if (my === undefined) h += '<button type="button" class="opt" data-poll="' + p[0] + '" data-choice="' + i + '">' + esc(L(o)) + '</button>';
        else { var pc = tot ? Math.round(res[i] / tot * 100) : 0; h += '<div class="pres' + (my === i ? ' me' : '') + '"><span>' + esc(L(o)) + (my === i ? ' ✓' : '') + '</span><b>' + pc + '%</b><i style="width:' + pc + '%"></i></div>'; }
      });
      return h + (my !== undefined ? '<p class="note">' + num(tot) + ' ' + T('votes', 'वोट') + '</p>' : '') + '</div>';
    }).join('');
  }
  document.addEventListener('click', function (e) {
    var b = e.target.closest('[data-poll]'); if (!b) return;
    var p = b.dataset.poll, c = +b.dataset.choice, voted = get('astryl-polls', {});
    if (voted[p] !== undefined) return;
    voted[p] = c; set('astryl-polls', voted);
    if (H) H.polls[p][c]++;
    drawPolls();
    call('vote', { poll: p, choice: c, device: device() }).catch(function () { });
  });

  /* ---------- leaderboards ---------- */
  var B = null, btab = 'week';
  function drawBoards() {
    var box = $('cmBoards'); if (!box) return;
    var tabs = [['week', 'Space Points this week', 'इस हफ़्ते Space Points'], ['all', 'Space Points all time', 'Space Points अब तक'], ['daily', 'Today’s Daily 5', 'आज का Daily 5']];
    var h = '<div class="tabs">' + tabs.map(function (t) { return '<button type="button" class="' + (btab === t[0] ? 'on' : '') + '" data-btab="' + t[0] + '">' + T(t[1], t[2]) + '</button>'; }).join('') + '</div>';
    if (!B) { box.innerHTML = h + '<p class="note">⏳</p>'; return; }
    var me = session() ? session().username : '', rows = [];
    if (btab === 'daily') rows = ((B.daily && B.daily.today) || []).map(function (r) { return { u: r.u, p: r.p }; });
    else rows = ((B.points && B.points[btab]) || []).map(function (r) { return { u: r.u, p: r.p }; });
    h += rows.length ? '<ol class="lb">' + rows.slice(0, 20).map(function (r) { return '<li' + (r.u === me ? ' class="me"' : '') + '><span class="nm">' + esc(r.u) + '</span><b>' + num(r.p) + '</b></li>'; }).join('') + '</ol>' : '<p class="note">' + T('Nobody yet. Be the first!', 'अभी कोई नहीं। पहले बनिए!') + '</p>';
    box.innerHTML = h;
  }
  document.addEventListener('click', function (e) { var b = e.target.closest('[data-btab]'); if (b) { btab = b.dataset.btab; drawBoards(); } });

  /* ---------- gallery ---------- */
  var G = null;
  function kindOf(k) { var x = C.photoKinds.filter(function (p) { return p[0] === k; })[0]; return x ? x[1] + ' ' + L([x[2], x[3]]) : ''; }
  function drawGallery() {
    var box = $('cmGallery'); if (!box) return;
    var h = '';
    if (session()) h += '<button type="button" class="btn primary" id="cmUpOpen">📷 ' + T('Share your sky photo', 'अपने आसमान की फ़ोटो भेजिए') + '</button>' + (G && G.pending ? ' <span class="note">⏳ ' + num(G.pending) + ' ' + T('of your photos are waiting for approval', 'आपकी फ़ोटो मंज़ूरी का इंतज़ार कर रही हैं') + '</span>' : '');
    else h += '<p class="note">' + loginLink() + ' ' + T('to share your own photos of the Moon, planets and stars.', 'करके चाँद, ग्रहों और तारों की अपनी फ़ोटो भेजिए।') + '</p>';
    h += '<div id="cmUpBox"></div>';
    if (!G) h += '<p class="note">⏳</p>';
    else if (!G.photos.length) h += '<p class="note">' + T('No photos yet. Yours could be the first!', 'अभी कोई फ़ोटो नहीं। पहली आपकी हो सकती है!') + '</p>';
    else h += '<div class="cgal">' + G.photos.map(function (p) {
      return '<figure class="cph"><img src="' + URL_ + '?action=img&size=thumb&id=' + p.id + '" data-full="' + URL_ + '?action=img&size=full&id=' + p.id + '" alt="' + esc(p.title) + '" loading="lazy">' +
        '<figcaption><b>' + esc(p.title) + '</b><small>' + kindOf(p.kind) + (p.taken ? ' · ' + esc(p.taken) : '') + ' · 📷 ' + esc(p.by) + '</small>' +
        '<span class="cact"><button type="button" class="star' + (p.starred ? ' on' : '') + '" data-star="' + p.id + '">⭐ ' + num(p.stars) + '</button>' +
        (p.mine ? '<button type="button" class="linkbtn" data-del="photo:' + p.id + '">' + T('Delete', 'हटाएँ') + '</button>' : '<button type="button" class="linkbtn" data-rep="photo:' + p.id + '">' + T('Report', 'शिकायत') + '</button>') + '</span></figcaption></figure>';
    }).join('') + '</div>';
    box.innerHTML = h;
  }
  function upForm() {
    var kinds = C.photoKinds.map(function (k) { return '<option value="' + k[0] + '">' + k[1] + ' ' + esc(L([k[2], k[3]])) + '</option>'; }).join('');
    $('cmUpBox').innerHTML = '<div class="card upform"><label>' + T('Photo', 'फ़ोटो') + '<input type="file" accept="image/*" id="cmFile"></label><div id="cmPrev"></div>' +
      '<label>' + T('Title', 'शीर्षक') + '<input type="text" id="cmTitle" maxlength="80" placeholder="' + (hi() ? 'जैसे: छत से पूर्णिमा का चाँद' : 'e.g. Full Moon from my roof') + '"></label>' +
      '<label>' + T('What is it?', 'यह क्या है?') + '<select id="cmKind">' + kinds + '</select></label>' +
      '<label>' + T('Where and when (optional, no exact address)', 'कहाँ और कब (ज़रूरी नहीं, पूरा पता नहीं)') + '<input type="text" id="cmTaken" maxlength="60" placeholder="' + (hi() ? 'जैसे: लखनऊ, नवंबर 2026' : 'e.g. Pune, November 2026') + '"></label>' +
      '<label class="chk"><input type="checkbox" id="cmOwn"> ' + T('I took this photo myself, and Astryl may show it with my username.', 'यह फ़ोटो मैंने ख़ुद खींची है, और Astryl इसे मेरे username के साथ दिखा सकता है।') + '</label>' +
      '<p class="note">' + T('Your photo is resized in your browser and any camera or location data is removed before it is sent. It appears after the moderator approves it, usually within a day. No people’s faces, please.', 'आपकी फ़ोटो भेजने से पहले browser में छोटी की जाती है और camera या location की जानकारी हटा दी जाती है। Moderator की मंज़ूरी के बाद दिखेगी, आमतौर पर एक दिन में। कृपया लोगों के चेहरे न हों।') + '</p>' +
      '<button type="button" class="btn primary" id="cmSend">' + T('Send for approval', 'मंज़ूरी के लिए भेजें') + '</button> <button type="button" class="btn" id="cmCancel">' + T('Cancel', 'रद्द करें') + '</button><p class="cmerr no" id="cmUpErr"></p></div>';
  }
  function shrink(file, max, q) {
    return new Promise(function (ok, no) {
      var img = new Image(), url = URL.createObjectURL(file);
      img.onload = function () {
        var s = Math.min(1, max / Math.max(img.naturalWidth, img.naturalHeight)), w = Math.round(img.naturalWidth * s), h = Math.round(img.naturalHeight * s);
        var c = document.createElement('canvas'); c.width = w; c.height = h; c.getContext('2d').drawImage(img, 0, 0, w, h);
        URL.revokeObjectURL(url);
        var data = c.toDataURL('image/jpeg', q); ok({ b64: data.split(',')[1], w: w, h: h, url: data });
      };
      img.onerror = function () { no(new Error('not_jpeg')); }; img.src = url;
    });
  }
  var upFile = null;
  document.addEventListener('change', function (e) {
    if (e.target.id !== 'cmFile' || !e.target.files[0]) return;
    upFile = e.target.files[0];
    shrink(upFile, 600, 0.8).then(function (p) { $('cmPrev').innerHTML = '<img src="' + p.url + '" alt="" style="max-width:100%;max-height:260px;border-radius:12px;margin:8px 0">'; });
  });
  document.addEventListener('click', function (e) {
    var t = e.target;
    if (t.closest('#cmUpOpen')) { upForm(); return; }
    if (t.closest('#cmCancel')) { $('cmUpBox').innerHTML = ''; upFile = null; return; }
    if (t.closest('#cmSend')) {
      var err = $('cmUpErr'); err.textContent = '';
      if (!upFile) { err.textContent = hi() ? 'पहले फ़ोटो चुनिए।' : 'Choose a photo first.'; return; }
      if (!$('cmOwn').checked) { err.textContent = hi() ? 'कृपया पुष्टि कीजिए कि फ़ोटो आपकी खींची है।' : 'Please confirm that you took the photo.'; return; }
      var btn = t.closest('#cmSend'); btn.disabled = true; btn.textContent = '⏳';
      Promise.all([shrink(upFile, 1600, 0.85), shrink(upFile, 480, 0.8)]).then(function (r) {
        return call('upload', { own: true, title: $('cmTitle').value, kind: $('cmKind').value, taken: $('cmTaken').value, full: r[0].b64, thumb: r[1].b64, w: r[0].w, h: r[0].h }, true);
      }).then(function () {
        $('cmUpBox').innerHTML = '<p class="ok"><b>✓ ' + T('Thank you! Your photo will appear once it is approved.', 'धन्यवाद! मंज़ूरी के बाद आपकी फ़ोटो दिखेगी।') + '</b></p>'; upFile = null; loadGallery();
      }).catch(function (x) { btn.disabled = false; btn.innerHTML = T('Send for approval', 'मंज़ूरी के लिए भेजें'); err.textContent = errText(x); });
      return;
    }
    var st = t.closest('[data-star]');
    if (st) {
      if (!session()) { st.insertAdjacentHTML('afterend', ' <small class="note">' + T('Log in to give stars.', 'Stars देने के लिए log in कीजिए।') + '</small>'); return; }
      call('star', { id: st.dataset.star }, true).then(function (j) { st.classList.toggle('on', j.on); st.textContent = '⭐ ' + num(j.stars); }).catch(function () { });
      return;
    }
    var im = t.closest('.cph img');
    if (im) { var box = document.createElement('div'); box.className = 'lightbox'; box.innerHTML = '<img src="' + im.dataset.full + '" alt="">'; box.onclick = function () { box.remove(); }; document.body.appendChild(box); return; }
    var rp = t.closest('[data-rep]');
    if (rp) {
      var q = rp.dataset.rep.split(':');
      if (!confirmInline(rp, T('Report this to the moderator?', 'Moderator को शिकायत भेजें?'))) return;
      call('report', { kind: q[0], id: q[1], device: device(), reason: 'user' }).then(function () { rp.outerHTML = '<small class="note">✓ ' + T('Reported. Thank you.', 'शिकायत भेज दी। धन्यवाद।') + '</small>'; });
      return;
    }
    var dl = t.closest('[data-del]');
    if (dl) {
      var d = dl.dataset.del.split(':');
      if (!confirmInline(dl, T('Delete it for good?', 'हमेशा के लिए हटाएँ?'))) return;
      call('mine_delete', { kind: d[0], id: d[1] }, true).then(function () { d[0] === 'photo' ? loadGallery() : loadPosts(); });
    }
  });
  /* a second tap confirms, so no browser dialog is needed */
  function confirmInline(el, label) {
    if (el.dataset.sure) return true;
    el.dataset.sure = '1'; el.dataset.old = el.innerHTML; el.innerHTML = label;
    setTimeout(function () { if (el.isConnected) { delete el.dataset.sure; el.innerHTML = el.dataset.old; } }, 4000);
    return false;
  }

  /* ---------- Astryl Community board ---------- */
  var P = null, reply = null;
  function postKind(k) { var x = C.postKinds.filter(function (p) { return p[0] === k; })[0]; return x ? x[1] + ' ' + L([x[2], x[3]]) : ''; }
  function when(s) { return new Date(s).toLocaleDateString(hi() ? 'hi-IN' : 'en-GB', { day: 'numeric', month: 'short' }); }
  function form(parent) {
    var kinds = C.postKinds.map(function (k) { return '<option value="' + k[0] + '">' + k[1] + ' ' + esc(L([k[2], k[3]])) + '</option>'; }).join('');
    return '<div class="card pform">' + (parent ? '' : '<label>' + T('What is it?', 'यह क्या है?') + '<select class="pkind">' + kinds + '</select></label>') +
      '<textarea class="pbody" maxlength="600" rows="3" placeholder="' + (parent ? (hi() ? 'अपना जवाब लिखिए…' : 'Write your answer…') : (hi() ? 'अपना सवाल, आपने क्या देखा, या सुझाव…' : 'Your question, what you saw, or an idea…')) + '"></textarea>' +
      '<p class="note">' + T('Be kind. No links, phone numbers, e-mail addresses or where you live. Every post is read by the moderator before it appears.', 'अच्छे से लिखिए। कोई link, फ़ोन नंबर, e-mail या आपका पता नहीं। हर post दिखने से पहले moderator पढ़ते हैं।') + '</p>' +
      '<button type="button" class="btn primary" data-psend="' + (parent || '') + '">' + T('Send', 'भेजें') + '</button><p class="cmerr no"></p></div>';
  }
  function drawPosts() {
    var box = $('cmPosts'); if (!box) return;
    var h = session() ? form('') + (P && P.pending ? '<p class="note">⏳ ' + num(P.pending) + ' ' + T('of your posts are waiting for approval', 'आपकी posts मंज़ूरी का इंतज़ार कर रही हैं') + '</p>' : '') : '<p class="note">' + loginLink() + ' ' + T('to ask a question or share what you saw.', 'करके सवाल पूछिए या बताइए आपने क्या देखा।') + '</p>';
    if (!P) h += '<p class="note">⏳</p>';
    else if (!P.posts.length) h += '<p class="note">' + T('No posts yet. Start the conversation!', 'अभी कोई post नहीं। बातचीत शुरू कीजिए!') + '</p>';
    else h += P.posts.map(function (p) {
      return '<div class="card post"><div class="ph"><b>' + esc(p.by) + '</b> <small class="note">' + postKind(p.kind) + ' · ' + when(p.at) + '</small></div><p class="pb">' + esc(p.body).replace(/\n/g, '<br>') + '</p>' +
        (p.replies.length ? '<div class="replies">' + p.replies.map(function (r) {
          return '<div class="rep"><b>' + esc(r.by) + '</b> <small class="note">' + when(r.at) + '</small><p>' + esc(r.body).replace(/\n/g, '<br>') + '</p>' + act('post', r) + '</div>';
        }).join('') + '</div>' : '') +
        '<div class="pact">' + (session() ? '<button type="button" class="linkbtn" data-reply="' + p.id + '">↩ ' + T('Reply', 'जवाब दें') + '</button>' : '') + act('post', p) + '</div>' +
        (reply === p.id ? form(p.id) : '') + '</div>';
    }).join('');
    box.innerHTML = h;
  }
  function act(kind, x) { return x.mine ? '<button type="button" class="linkbtn" data-del="' + kind + ':' + x.id + '">' + T('Delete', 'हटाएँ') + '</button>' : '<button type="button" class="linkbtn" data-rep="' + kind + ':' + x.id + '">' + T('Report', 'शिकायत') + '</button>'; }
  document.addEventListener('click', function (e) {
    var r = e.target.closest('[data-reply]'); if (r) { reply = reply === r.dataset.reply ? null : r.dataset.reply; drawPosts(); return; }
    var s = e.target.closest('[data-psend]'); if (!s) return;
    var f = s.closest('.pform'), body = f.querySelector('.pbody').value, kind = f.querySelector('.pkind'), err = f.querySelector('.cmerr');
    s.disabled = true;
    call('post', { body: body, kind: kind ? kind.value : 'reply', parent: s.dataset.psend || null }, true).then(function () {
      f.outerHTML = '<p class="ok"><b>✓ ' + T('Thank you! It will appear once the moderator has read it.', 'धन्यवाद! Moderator के पढ़ने के बाद यह दिखेगा।') + '</b></p>';
      if (P) P.pending++; reply = null;
    }).catch(function (x) { s.disabled = false; err.textContent = errText(x); });
  });

  /* ---------- load ---------- */
  function drawAll() { drawSeen(); drawChallenge(); drawPolls(); drawBoards(); drawGallery(); drawPosts(); var a = $('cmAdmin'); if (a) a.hidden = !(H && H.admin); }
  function loadGallery() { call('photos', {}).then(function (j) { G = j && j.photos ? j : { photos: [], pending: 0 }; drawGallery(); }).catch(function () { G = { photos: [], pending: 0 }; drawGallery(); }); }
  function loadPosts() { call('posts', {}).then(function (j) { P = j && j.posts ? j : { posts: [], pending: 0 }; drawPosts(); }).catch(function () { P = { posts: [], pending: 0 }; drawPosts(); }); }
  API.onRender(drawAll);
  call('home', {}).then(function (j) { H = j && j.seen && j.polls && j.challenges ? j : null; drawAll(); }).catch(function () { drawAll(); });
  call('boards', {}).then(function (j) { B = j; drawBoards(); }).catch(function () { B = {}; drawBoards(); });
  loadGallery(); loadPosts();
})();
