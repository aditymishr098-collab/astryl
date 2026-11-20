/* Astryl service worker: lets the installed website open fast and work offline.
   - Pages: from the network first (so they are always fresh), from the cache when offline.
   - Scripts, styles, fonts and pictures of this site: from the cache first (their names carry a version).
   - Anything on other servers (account, NASA photo, orbit data) is never touched or stored here.
   Nothing about the visitor is stored or sent. */
var VERSION = "eb413f8e1a";
var CACHE = 'astryl-' + VERSION;
var CORE = ["/", "/index.html", "/offline.html", "/planets.html", "/assets/icon.svg?v=a7f1611c", "/img/icons/icon-192.png?v=a7f1611c", "/assets/style.css?v=eb413f8e1a", "/assets/data.js?v=eb413f8e1a", "/assets/app.js?v=eb413f8e1a", "/assets/account.js?v=eb413f8e1a", "/assets/me.js?v=eb413f8e1a", "/assets/fx.js?v=eb413f8e1a", "/assets/pwa.js?v=eb413f8e1a", "/assets/icons.js?v=eb413f8e1a", "/assets/citypick.js?v=eb413f8e1a", "/assets/home.js?v=eb413f8e1a", "/assets/apod.js?v=eb413f8e1a", "/fonts/DMSans-Regular.woff2", "/fonts/DMSans-Medium.woff2", "/fonts/DMSans-Bold.woff2", "/fonts/SpaceGrotesk-Medium.woff2", "/fonts/SpaceGrotesk-Bold.woff2"];

self.addEventListener('install', function (e) {
  e.waitUntil(caches.open(CACHE).then(function (c) { return c.addAll(CORE); }).then(function () { return self.skipWaiting(); }));
});

self.addEventListener('activate', function (e) {
  e.waitUntil(caches.keys().then(function (keys) {
    return Promise.all(keys.filter(function (k) { return k.indexOf('astryl-') === 0 && k !== CACHE; }).map(function (k) { return caches.delete(k); }));
  }).then(function () { return self.clients.claim(); }));
});

function timeout(ms, p) { return new Promise(function (ok, no) { var t = setTimeout(function () { no(new Error('timeout')); }, ms); p.then(function (r) { clearTimeout(t); ok(r); }, function (er) { clearTimeout(t); no(er); }); }); }

self.addEventListener('fetch', function (e) {
  var req = e.request, url = new URL(req.url);
  if (req.method !== 'GET' || url.origin !== self.location.origin) return;
  if (req.mode === 'navigate') {
    e.respondWith(timeout(6000, fetch(req)).then(function (res) {
      if (res && res.ok) { var copy = res.clone(); caches.open(CACHE).then(function (c) { c.put(req, copy); }); }
      return res;
    }).catch(function () {
      return caches.match(req, { ignoreSearch: true }).then(function (hit) { return hit || caches.match('/offline.html'); });
    }));
    return;
  }
  function keep(res) { if (res && res.ok && res.type === 'basic') { var copy = res.clone(); caches.open(CACHE).then(function (c) { c.put(req, copy); }); } return res; }
  if (url.search.indexOf('v=') >= 0 || url.pathname.indexOf('/fonts/') === 0 || url.pathname.indexOf('/img/') === 0) {
    // versioned files never change under the same name: the cache is enough
    e.respondWith(caches.match(req).then(function (hit) { return hit || fetch(req).then(keep); }));
  } else {
    // other files (data lists): fresh from the network, the saved copy when offline
    e.respondWith(fetch(req).then(keep).catch(function () { return caches.match(req); }));
  }
});
