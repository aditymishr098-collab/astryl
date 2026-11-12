/* Space photo of the day: NASA's Astronomy Picture of the Day, through Astryl's server (which keeps
   a copy for a couple of hours). The picture itself loads from NASA's server. The last one is kept in
   this browser so the card still shows something offline. */
(function () {
  var box = document.getElementById('dailyPhoto');
  var API = window.ASTRYL_API;
  if (!box) return;
  var FEED = 'https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/daily?what=apod', KEY = 'astryl-apod2';
  function get(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } }
  function set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { } }
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + hi + '</span>'; }
  function esc(x) { return String(x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function nasa(u) { return typeof u === 'string' && /^https:\/\/(apod\.nasa\.gov|science\.nasa\.gov|assets\.science\.nasa\.gov)\//.test(u) ? u : ''; }
  function day(s) {
    var hi = API && API.lang() === 'hi';
    try { return new Date(s + 'T12:00:00Z').toLocaleDateString(hi ? 'hi-IN' : 'en-GB', { day: 'numeric', month: 'long', year: 'numeric' }); } catch (e) { return s; }
  }
  function draw(a) {
    if (!a || !a.title) { box.innerHTML = '<h3>📷 ' + bi('Space photo of the day', 'आज की अंतरिक्ष तस्वीर') + '</h3><p class="note">' + bi('Could not load today’s photo. Please try again later.', 'आज की तस्वीर load नहीं हो पाई। कृपया बाद में फिर कोशिश कीजिए।') + '</p>'; return; }
    var img = nasa(a.url), page = nasa(a.page) || 'https://science.nasa.gov/apod/', text = String(a.explanation || ''), short = text.length > 320 ? text.slice(0, text.lastIndexOf(' ', 300)) + '…' : text;
    var h = '<h3>📷 ' + bi('Space photo of the day', 'आज की अंतरिक्ष तस्वीर') + '</h3>';
    if (img) h += '<a class="apodimg" href="' + esc(nasa(a.hdurl) || img) + '" target="_blank" rel="noopener"><img src="' + esc(img) + '" alt="' + esc(a.title) + '" loading="lazy" referrerpolicy="no-referrer" onerror="this.parentNode.style.display=\'none\'"></a>';
    else h += '<p class="note">🎬 ' + bi('Today it is a video or animation. Watch it on NASA’s page.', 'आज यह एक video या animation है। इसे NASA के page पर देखिए।') + '</p>';
    h += '<p><b>' + esc(a.title) + '</b><br><small>' + day(a.date) + (a.copyright ? ' · © ' + esc(a.copyright) : '') + '</small></p>';
    h += '<p class="apodtxt" lang="en">' + esc(short) + (short !== text ? ' <button type="button" class="linkbtn" data-more>' + bi('Read more', 'और पढ़ें') + '</button>' : '') + '</p>';
    h += '<p class="note">' + bi('From NASA’s Astronomy Picture of the Day. The description is in English.', 'NASA की Astronomy Picture of the Day से। विवरण अंग्रेज़ी में है।') + ' <a href="' + esc(page) + '" target="_blank" rel="noopener">science.nasa.gov ↗</a></p>';
    box.innerHTML = h;
    var m = box.querySelector('[data-more]');
    if (m) m.onclick = function () { box.querySelector('.apodtxt').textContent = text; };
  }
  var saved = get(KEY, null);
  if (saved && saved.title) draw(saved); else box.innerHTML = '<h3>📷 ' + bi('Space photo of the day', 'आज की अंतरिक्ष तस्वीर') + '</h3><p class="note">⏳</p>';
  if (saved && saved.title && Date.now() - (saved.got || 0) < 2 * 3600000) return;
  fetch(FEED).then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); }).then(function (a) {
    if (!a || typeof a.title !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(a.date || '')) throw new Error('bad');
    a.got = Date.now(); set(KEY, a); draw(a);
  }).catch(function () { if (!saved) draw(null); });
  if (API && API.onRender) API.onRender(function () { var s = get(KEY, null); if (s) draw(s); });
})();
