/* Home page "Discover today": a new set every day (history, a word, a world, the quiz and the
   blog), and how many days in a row you have come back. The streak lives only in this browser. */
(function () {
  var box = document.getElementById('discover'), X = window.ASTRYL_DISCOVER;
  if (!box || !X) return;
  function esc(x) { return String(x == null ? '' : x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  var now = new Date(), day = Math.floor(Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()) / 86400000);
  var MON = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  // days in a row
  var st = { last: 0, n: 0, best: 0 };
  try { st = JSON.parse(localStorage.getItem('astryl-visit-streak') || 'null') || st; } catch (e) { }
  if (st.last !== day) { st.n = st.last === day - 1 ? st.n + 1 : 1; st.last = day; st.best = Math.max(st.best || 0, st.n); try { localStorage.setItem('astryl-visit-streak', JSON.stringify(st)); } catch (e) { } }

  // on this day: today's event, or the most recent one before today
  var key = (now.getMonth() + 1) * 100 + now.getDate(), ev = null, exact = false;
  X.history.forEach(function (h) { var k = h[0] * 100 + h[1]; if (k <= key && (!ev || k >= ev[0] * 100 + ev[1])) ev = h; });
  if (!ev) ev = X.history[X.history.length - 1];
  exact = ev[0] * 100 + ev[1] === key;
  var word = X.words[day % X.words.length], world = X.worlds[(day * 7) % X.worlds.length];
  var until = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1) - now, hrs = Math.floor(until / 3600000), mins = Math.floor(until % 3600000 / 60000);

  var h = '<div class="dchead"><div><h2>🔭 Discover today</h2><p class="note">' + now.toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long' }) + ' · a new set arrives in ' + (hrs ? hrs + ' h ' : '') + mins + ' min</p></div>' +
    '<div class="dcstreak" title="Days in a row you have visited Astryl on this device"><span aria-hidden="true">🔥</span><span>' + (st.n === 1 ? '<b>Day 1</b> in a row · come back tomorrow' : '<b>' + st.n + ' days</b> in a row' + (st.best > st.n ? ' · best ' + st.best : '')) + '</span></div></div><div class="dcgrid">';
  h += '<a class="dccard dchist" href="' + esc(ev[4]) + '"><small>📅 ' + (exact ? 'On this day' : ev[0] === now.getMonth() + 1 ? 'This month in space history' : 'Recently in space history') + '</small><b>' + ev[1] + ' ' + MON[ev[0] - 1] + ' ' + ev[2] + '</b><span>' + esc(ev[3]) + '</span><em>Read more →</em></a>';
  h += '<a class="dccard" href="body/' + esc(world[0]) + '.html"><img src="img/planets/' + esc(world[0]) + '-s.webp" alt="" width="72" height="72" loading="lazy"><small>🪐 World of the day</small><b>' + esc(world[1]) + '</b><span>' + esc(world[2] || 'Real numbers, photos and how it formed.') + '</span><em>Visit ' + esc(world[1]) + ' →</em></a>';
  var wid = String(word[0]).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
  h += '<a class="dccard" href="glossary.html#' + esc(wid) + '"><small>📖 Word of the day</small><b>' + esc(word[0]) + '</b><span>' + esc(word[1]) + '</span><em>Read it in the glossary →</em></a>';
  h += '<a class="dccard" href="quiz.html#daily"><small>🧠 Today’s challenge</small><b>Daily 5</b><span>Five new questions every day, free with an account. Keep your streak going and earn Space Points.</span><em>Play now →</em></a>';
  if (X.post) h += '<a class="dccard" href="' + esc(X.post[0]) + '"><small>📝 From the blog</small><b>' + esc(X.post[1]) + '</b><span>' + esc(X.post[2]) + '</span><em>Read the post →</em></a>';
  h += '<a class="dccard" href="community.html"><small>👥 Community</small><b id="dcComm">New sky photos and questions</b><span>See what people shared, or ask your own question about space.</span><em>Open the community →</em></a>';
  box.innerHTML = h + '</div>';

  // real numbers for the community card, fetched only when the section comes into view
  function plural(n, one) { return n.toLocaleString('en-US') + ' ' + one + (n === 1 ? '' : 's'); }
  function loadCounts() {
    fetch('https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/community', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ action: 'home' }) })
      .then(function (r) { if (!r.ok) throw 0; return r.json(); })
      .then(function (j) {
        var n = j && j.numbers, el = document.getElementById('dcComm');
        if (!n || !el || !(n.photos || n.questions)) return;
        el.textContent = plural(n.photos || 0, 'sky photo') + ' · ' + plural(n.questions || 0, 'question');
      }).catch(function () { });
  }
  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (en) { if (en[0].isIntersecting) { io.disconnect(); loadCounts(); } }, { rootMargin: '200px' });
    io.observe(box);
  } else loadCounts();
})();
