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
  var ios = /iphone|ipad|ipod/i.test(navigator.userAgent) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
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
  window.addEventListener('beforeinstallprompt', function (e) { e.preventDefault(); deferred = e; show(); });
  window.addEventListener('appinstalled', function () { deferred = null; box.innerHTML = ''; });
  show();
  new MutationObserver(show).observe(document.documentElement, { attributes: true, attributeFilter: ['lang'] });
})();
