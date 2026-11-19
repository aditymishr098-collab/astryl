/* Install Astryl: registers the service worker (offline use) and shows an "Install" button where the
   browser allows it (Android, desktop Chrome and Edge), or a short how-to on iPhone and iPad. */
(function () {
  var local = location.hostname === 'localhost' || location.hostname === '127.0.0.1';
  if ('serviceWorker' in navigator && (location.protocol === 'https:' || local)) {
    window.addEventListener('load', function () { navigator.serviceWorker.register('/sw.js').catch(function () {}); });
  }
  var standalone = (window.matchMedia && matchMedia('(display-mode: standalone)').matches) || navigator.standalone === true;
  var box = document.getElementById('installBox');
  if (!box || standalone) return;

  /* A small "Install Astryl" bar for new visitors: from their second page (or after 20 seconds),
     never for people who installed it, and not again for 30 days after "Not now". */
  function get(k) { try { return localStorage.getItem(k); } catch (e) { return null; } }
  function remember(k, v) { try { localStorage.setItem(k, v); } catch (e) { } }
  var views = (+get('astryl-pv') || 0) + 1; remember('astryl-pv', String(views));
  var bar = null, ready = views >= 2;
  function snoozed() { return get('astryl-installed') === '1' || Date.now() < (+get('astryl-install-later') || 0); }
  function hideBar() { if (bar) { bar.remove(); bar = null; } }
  function offer() {
    if (bar || !ready || snoozed() || (!deferred && !iosSafari)) return;
    bar = document.createElement('div');
    bar.className = 'instbar'; bar.setAttribute('role', 'region'); bar.setAttribute('aria-label', 'Install Astryl');
    bar.innerHTML = '<img src="/img/icons/icon-192.png" alt="" width="40" height="40"><div><b>Install Astryl</b><span>' +
      (deferred ? 'Opens like an app, works offline, no app store needed.' : 'Tap <b>Share</b>, then <b>Add to Home Screen</b>.') + '</span></div>' +
      (deferred ? '<button class="btn primary" type="button" data-i="go">Install</button>' : '') +
      '<button class="instx" type="button" data-i="later" aria-label="Not now">✕</button>';
    bar.addEventListener('click', function (e) {
      var b = e.target.closest('button'); if (!b) return;
      if (b.getAttribute('data-i') === 'go' && deferred) {
        deferred.prompt();
        deferred.userChoice.then(function (c) {
          if (c && c.outcome === 'accepted') remember('astryl-installed', '1');
          else remember('astryl-install-later', String(Date.now() + 30 * 864e5));
          deferred = null; box.innerHTML = ''; hideBar();
        });
      } else { remember('astryl-install-later', String(Date.now() + 30 * 864e5)); hideBar(); }
    });
    document.body.appendChild(bar);
  }
  if (!ready) setTimeout(function () { ready = true; offer(); }, 20000);
  var ios = /iphone|ipad|ipod/i.test(navigator.userAgent) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
  // Safari itself (not Chrome, Firefox or an app's built-in browser on iOS) is where "Add to Home Screen" works best
  var iosSafari = ios && /safari/i.test(navigator.userAgent) && !/crios|fxios|edgios|fban|fbav|instagram|line\//i.test(navigator.userAgent);
  var deferred = null;
  function lang() { return document.documentElement.lang === 'hi' ? 'hi' : 'en'; }
  function t(en, hi) { return lang() === 'hi' ? hi : en; }
  function show() {
    if (deferred) {
      box.innerHTML = '<button class="btn" type="button" id="installBtn">📲 ' + t('Install Astryl', 'Astryl install करें') + '</button><br><small class="note">' + t('Opens like an app, works offline.', 'App की तरह खुलता है, बिना internet भी चलता है।') + '</small>';
      document.getElementById('installBtn').onclick = function () {
        deferred.prompt();
        deferred.userChoice.then(function () { deferred = null; box.innerHTML = ''; });
      };
    } else if (ios) {
      box.innerHTML = '<small class="note">📲 ' + t('To install on iPhone or iPad: tap Share, then “Add to Home Screen”.', 'iPhone या iPad पर install करने के लिए: Share दबाइए, फिर “Add to Home Screen”।') + '</small>';
    }
  }
  window.addEventListener('beforeinstallprompt', function (e) { e.preventDefault(); deferred = e; show(); offer(); });
  window.addEventListener('appinstalled', function () { deferred = null; box.innerHTML = ''; remember('astryl-installed', '1'); hideBar(); });
  show(); offer();
  new MutationObserver(show).observe(document.documentElement, { attributes: true, attributeFilter: ['lang'] });
})();
