/* Scale of the universe: step through objects from a proton to the observable universe. */
(function () {
  var C = 2.99792458e8, AU = 1.495978707e11, LY = 9.4607e15;
  function $(id) { return document.getElementById(id); }
  function bi(en, hi) { return '<span class="t" lang="en">' + en + '</span><span class="t" lang="hi">' + hi + '</span>'; }
  var SUP = { '-': '⁻', '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴', '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹' };
  function sci(x, d) {
    var e = Math.floor(Math.log10(x)), m = x / Math.pow(10, e);
    if (parseFloat(m.toFixed(d)) >= 10) { m /= 10; e += 1; }
    return m.toFixed(d) + ' × 10' + String(e).split('').map(function (c) { return SUP[c]; }).join('');
  }
  function n2(x, d) { return [x.toLocaleString('en-US', { maximumFractionDigits: d }), x.toLocaleString('hi-IN', { maximumFractionDigits: d })]; }
  function both(x, d, en, hi) { var g = n2(x, d); return bi(g[0] + ' ' + en, g[1] + ' ' + (hi || en)); }
  function length(m) {
    if (m < 1e-9) return bi(sci(m, 1) + ' m', sci(m, 1) + ' m');
    if (m < 1e-6) return both(m * 1e9, 1, 'nm');
    if (m < 1e-3) return both(m * 1e6, 1, 'µm');
    if (m < 1) return both(m * 1000, 1, 'mm');
    if (m < 1000) return both(m, 1, 'm');
    if (m < 1e9) return both(m / 1000, 0, 'km');
    if (m < 0.1 * AU) return both(m / 1e9, 1, 'million km', 'मिलियन km');
    if (m < 0.1 * LY) return both(m / AU, 1, 'AU');
    if (m < 1e6 * LY) return both(m / LY, 1, 'light-years', 'प्रकाश-वर्ष');
    if (m < 1e9 * LY) return both(m / LY / 1e6, 1, 'million light-years', 'मिलियन प्रकाश-वर्ष');
    return both(m / LY / 1e9, 1, 'billion light-years', 'अरब प्रकाश-वर्ष');
  }
  function duration(s) {
    if (s < 1e-6) return bi(sci(s, 1) + ' s', sci(s, 1) + ' s');
    if (s < 1e-3) return both(s * 1e6, 1, 'microseconds', 'माइक्रोसेकंड');
    if (s < 1) return both(s * 1e3, 1, 'milliseconds', 'मिलीसेकंड');
    if (s < 60) return both(s, 1, 'seconds', 'सेकंड');
    if (s < 3600) return both(s / 60, 1, 'minutes', 'मिनट');
    if (s < 86400) return both(s / 3600, 1, 'hours', 'घंटे');
    if (s < 3.15576e7) return both(s / 86400, 1, 'days', 'दिन');
    var y = s / 3.15576e7;
    if (y < 1e6) return both(y, 1, 'years', 'साल');
    if (y < 1e9) return both(y / 1e6, 1, 'million years', 'मिलियन साल');
    return both(y / 1e9, 1, 'billion years', 'अरब साल');
  }
  function big(x) {
    if (x < 1000) return both(x, x < 10 ? 2 : 0, '');
    if (x < 1e6) return both(x, 0, '');
    return bi(sci(x, 1), sci(x, 1));
  }
  var items = JSON.parse($('scaleData').textContent), i = 4;
  function show() {
    var it = items[i], prev = items[i - 1], p = (Math.log10(it.m) - Math.log10(items[0].m)) / (Math.log10(items[items.length - 1].m) - Math.log10(items[0].m));
    $('scName').innerHTML = bi(it.en, it.hi);
    $('scSize').innerHTML = length(it.m);
    $('scBlurb').innerHTML = bi(it.be, it.bh);
    var person = it.m / 1.7;
    var cells = (it.x ? '<div class="stat"><b>—</b><span>' + bi('Space expands while light crosses, so there is no simple crossing time', 'रोशनी के पार करते समय अंतरिक्ष फैलता है, इसलिए सीधा समय नहीं बनता') + '</span></div>' :
      '<div class="stat"><b>' + duration(it.m / C) + '</b><span>' + bi('Light takes this long to cross it', 'रोशनी को इसे पार करने में इतना समय लगता है') + '</span></div>') +
      '<div class="stat"><b>' + (person >= 1 ? big(person) : bi(sci(person, 1), sci(person, 1))) + '</b><span>' + bi('People end to end', 'इंसान एक के आगे एक') + '</span></div>';
    if (prev) cells += '<div class="stat"><b>× ' + big(it.m / prev.m) + '</b><span>' + bi('bigger than the step before', 'पिछले पड़ाव से बड़ा') + '</span></div>';
    $('scStats').innerHTML = cells;
    $('scDot').style.left = (p * 100) + '%';
    $('scIdx').textContent = (i + 1) + ' / ' + items.length;
    $('scBar').value = i;
    var rows = document.querySelectorAll('#scList tr[data-i]');
    for (var r = 0; r < rows.length; r++) rows[r].classList.toggle('on', +rows[r].getAttribute('data-i') === i);
  }
  document.addEventListener('DOMContentLoaded', function () {
    $('scBar').max = items.length - 1;
    $('scPrev').addEventListener('click', function () { if (i > 0) { i--; show(); } });
    $('scNext').addEventListener('click', function () { if (i < items.length - 1) { i++; show(); } });
    $('scBar').addEventListener('input', function () { i = +this.value; show(); });
    var rows = document.querySelectorAll('#scList tr[data-i]');
    for (var r = 0; r < rows.length; r++) rows[r].addEventListener('click', function () { i = +this.getAttribute('data-i'); show(); window.scrollTo({ top: $('scName').getBoundingClientRect().top + window.scrollY - 120, behavior: 'smooth' }); });
    show();
  });
})();
