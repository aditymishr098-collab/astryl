/* Planet panel: tap a planet or moon (on the planets page or the 3D solar system) and its facts,
   numbers and the story of how it formed open in a panel on the same page. The full page is one
   tap away. Ctrl/Cmd-click still opens the full page; the Back button closes the panel. */
(function () {
  var D = null, IDS = /^(sun|mercury|venus|earth|moon|mars|jupiter|saturn|uranus|neptune|pluto|io|europa|ganymede|callisto|titan|enceladus|triton)$/;
  var me = document.currentScript && document.currentScript.src, ver = me && /[?&]v=([^&]+)/.exec(me);
  var waiting = [];
  function need(cb, fail) { // the panel's texts (about 40 kB) load on the first tap only
    if (D) { cb(); return; }
    waiting.push([cb, fail]);
    if (waiting.length > 1) return;
    var sc = document.createElement('script');
    sc.src = root + 'assets/sheet-data.js' + (ver ? '?v=' + ver[1] : '');
    sc.onload = function () { D = window.ASTRYL_SHEET || null; var w = waiting; waiting = []; w.forEach(function (x) { D ? x[0]() : x[1](); }); };
    sc.onerror = function () { var w = waiting; waiting = []; w.forEach(function (x) { x[1](); }); };
    document.head.appendChild(sc);
  }
  var root = document.body.getAttribute('data-root') || '';
  var wrap = document.createElement('div');
  wrap.className = 'sheetwrap'; wrap.hidden = true;
  wrap.innerHTML = '<div class="sheetback" data-close></div><section class="sheet" role="dialog" aria-modal="true" aria-labelledby="sheetTitle" tabindex="-1">' +
    '<button type="button" class="sheetx" data-close aria-label="Close">✕</button><div class="sheetin"></div></section>';
  document.body.appendChild(wrap);
  var panel = wrap.querySelector('.sheet'), inner = wrap.querySelector('.sheetin'), lastFocus = null, openId = null;
  function fix(html) { return root ? html.replace(/(src|href)="(img|body)\//g, '$1="' + root + '$2/') : html; }
  function open(id, push) {
    var d = D[id]; if (!d) return false;
    openId = id;
    inner.innerHTML = fix(d.head + d.body);
    if (!wrap.hidden) { panel.scrollTop = 0; } else { lastFocus = document.activeElement; wrap.hidden = false; document.documentElement.classList.add('sheetopen'); requestAnimationFrame(function () { wrap.classList.add('on'); }); }
    panel.scrollTop = 0; panel.focus({ preventScroll: true });
    if (push) { try { history.pushState({ sheet: id }, '', '#world=' + id); } catch (e) { } }
    return true;
  }
  function close(fromHistory) {
    if (wrap.hidden) return;
    wrap.classList.remove('on'); document.documentElement.classList.remove('sheetopen');
    setTimeout(function () { wrap.hidden = true; inner.innerHTML = ''; }, 220);
    openId = null;
    if (!fromHistory && history.state && history.state.sheet) { try { history.back(); } catch (e) { } }
    else if (!fromHistory && /#world=/.test(location.hash)) { try { history.replaceState(null, '', location.pathname + location.search); } catch (e) { } }
    if (lastFocus && lastFocus.focus) lastFocus.focus({ preventScroll: true });
  }
  document.addEventListener('click', function (e) {
    if (e.defaultPrevented || e.button !== 0 || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;
    if (e.target.closest('[data-close]')) { close(); return; }
    var a = e.target.closest('a[href]'); if (!a || a.hasAttribute('data-full')) return;
    var m = /(?:^|\/)body\/([a-z]+)\.html$/.exec(a.getAttribute('href')); if (!m || !IDS.test(m[1])) return;
    e.preventDefault();
    var push = wrap.hidden, href = a.href;
    need(function () { if (!open(m[1], push)) location.href = href; }, function () { location.href = href; });
  });
  document.addEventListener('keydown', function (e) {
    if (wrap.hidden) return;
    if (e.key === 'Escape') { close(); return; }
    if (e.key === 'Tab') { // keep the focus inside the panel
      var f = panel.querySelectorAll('a[href],button,input,[tabindex]:not([tabindex="-1"])'); if (!f.length) return;
      var first = f[0], last = f[f.length - 1];
      if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
      else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
    }
  });
  window.addEventListener('popstate', function (e) {
    if (e.state && e.state.sheet) need(function () { open(e.state.sheet, false); }, function () { }); else close(true);
  });
  var h = /#world=([a-z]+)/.exec(location.hash);
  if (h && IDS.test(h[1])) need(function () { open(h[1], false); }, function () { });
})();
