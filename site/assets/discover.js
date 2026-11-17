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
    '<div class="dcstreak" title="Days in a row you have visited Astryl on this device"><span aria-hidden="true">🔥</span><b>' + st.n + '</b><small>' + (st.n === 1 ? 'day' : 'days in a row') + (st.best > st.n ? ' · best ' + st.best : '') + '</small></div></div><div class="dcgrid">';
  h += '<a class="dccard dchist" href="' + esc(ev[4]) + '"><small>📅 ' + (exact ? 'On this day' : 'This month in space history') + '</small><b>' + ev[1] + ' ' + MON[ev[0] - 1] + ' ' + ev[2] + '</b><span>' + esc(ev[3]) + '</span><em>Read more →</em></a>';
  h += '<a class="dccard" href="body/' + esc(world[0]) + '.html"><img src="img/planets/' + esc(world[0]) + '-s.webp" alt="" width="72" height="72" loading="lazy"><small>🪐 World of the day</small><b>' + esc(world[1]) + '</b><span>Real numbers, photos and how it formed.</span><em>Visit ' + esc(world[1]) + ' →</em></a>';
  h += '<a class="dccard" href="glossary.html"><small>📖 Word of the day</small><b>' + esc(word[0]) + '</b><span>' + esc(word[1]) + '</span><em>Open the glossary →</em></a>';
  h += '<a class="dccard" href="quiz.html#daily"><small>🧠 Today’s challenge</small><b>Daily 5</b><span>Five new questions every day. Keep your quiz streak going and earn Space Points.</span><em>Play now →</em></a>';
  if (X.post) h += '<a class="dccard" href="' + esc(X.post[0]) + '"><small>📝 From the blog</small><b>' + esc(X.post[1]) + '</b><span>' + esc(X.post[2]) + '</span><em>Read the post →</em></a>';
  h += '<a class="dccard" href="community.html"><small>👥 Community</small><b>New sky photos and questions</b><span>See what people shared, or ask your own question about space.</span><em>Open the community →</em></a>';
  box.innerHTML = h + '</div>';
})();
