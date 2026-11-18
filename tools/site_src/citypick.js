/* City box: type a city (or use your location) and open its "Night sky tonight" page.
   Your location is used only in this browser to find the nearest city; it is never sent. */
(function () {
  function norm(x) { return String(x || '').toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/[^a-z ]/g, ' ').replace(/\s+/g, ' ').trim(); }
  document.querySelectorAll('form.citypick').forEach(function (f) {
    var cities = []; try { cities = JSON.parse(f.getAttribute('data-cities') || '[]'); } catch (e) { }
    var root = f.getAttribute('data-root') || '', msg = f.querySelector('.cpmsg');
    function go(c) { location.href = root + 'tonight/' + c[0] + '.html'; }
    function say(t) { if (msg) msg.textContent = t; }
    f.addEventListener('submit', function (e) {
      e.preventDefault();
      var q = norm(f.querySelector('input').value.split(',')[0]);
      if (!q) return;
      var hit = cities.filter(function (c) { return norm(c[1]) === q; })[0] || cities.filter(function (c) { return norm(c[1]).indexOf(q) === 0; })[0];
      if (hit) return go(hit);
      say('That city is not on the list yet. Pick the nearest one, or tap “Use my location”.');
    });
    var near = f.querySelector('[data-near]');
    if (near) near.addEventListener('click', function () {
      if (!navigator.geolocation) return say('Your browser cannot share a location. Please type your city.');
      say('Finding the nearest city…');
      navigator.geolocation.getCurrentPosition(function (p) {
        var la = p.coords.latitude * Math.PI / 180, lo = p.coords.longitude * Math.PI / 180, best = null, bd = 1e9;
        cities.forEach(function (c) {
          var a = c[3] * Math.PI / 180, b = c[4] * Math.PI / 180;
          var d = Math.acos(Math.min(1, Math.sin(la) * Math.sin(a) + Math.cos(la) * Math.cos(a) * Math.cos(lo - b)));
          if (d < bd) { bd = d; best = c; }
        });
        if (best) { say('Nearest: ' + best[1] + ' (' + Math.round(bd * 6371) + ' km away)'); go(best); }
      }, function () { say('Location was not shared. Please type your city.'); }, { maximumAge: 600000, timeout: 10000 });
    });
  });
})();
