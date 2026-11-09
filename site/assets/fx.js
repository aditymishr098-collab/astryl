/* Soft motion for the whole site: things fade up as they scroll into view and
   the header gets a shadow once the page moves. Switched off when the visitor
   asks for less motion (the page then shows everything at once). */
(function () {
  'use strict';
  var doc = document;
  var header = doc.querySelector('header.top');
  function onScroll() { if (header) header.classList.toggle('scrolled', (window.scrollY || 0) > 8); }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  if (!doc.documentElement.classList.contains('js')) return;
  var SEL = '.card,a.sc,.stat,details,.tl .m,.steps li,.opt,section.blk>h2,section.blk>.sub,.callout,.pn,.policy>h2';
  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); }
    });
  }, { rootMargin: '0px 0px -6% 0px', threshold: 0.05 });

  function scan() {
    var main = doc.querySelector('main'); if (!main) return;
    var seen = new Map();
    [].forEach.call(main.querySelectorAll(SEL), function (el) {
      if (el.classList.contains('rv') || el.closest('.journey')) return;
      var parent = el.parentNode, n = seen.get(parent) || 0;
      seen.set(parent, n + 1);
      el.style.setProperty('--d', Math.min(n * 0.06, 0.36) + 's');
      el.classList.add('rv');
      io.observe(el);
    });
  }
  scan();
  // Pages fill themselves in with scripts (lists, calendars): look again.
  var timer = 0, main = doc.querySelector('main');
  if (main && 'MutationObserver' in window) {
    new MutationObserver(function () { clearTimeout(timer); timer = setTimeout(scan, 80); })
      .observe(main, { childList: true, subtree: true });
  }
})();
