/* Planet pages: "Inside this world" (a cut-open globe with the real layer sizes, gently animated) and the
   telescope eyepiece simulator (true sizes for today's distance, today's phase, Saturn's ring tilt and
   Jupiter's moons where they really are). Everything is drawn in the browser; no pictures are loaded. */
(function () {
  var API = window.ASTRYL_API, D = window.ASTRYL;
  if (!API || !D) return;
  var byId = {};
  D.bodies.forEach(function (b) { byId[b.id] = b; });
  var REDUCE = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;
  var DEG = Math.PI / 180;
  function hi() { return API.lang() === 'hi'; }
  function L(pair) { return pair ? (hi() ? pair[1] : pair[0]) : ''; }
  function km(v) { return Math.round(v).toLocaleString(hi() ? 'hi-IN' : 'en-US') + ' km'; }
  function kmBig(v) { if (v < 1e6) return km(v); return hi() ? (v / 1e7).toLocaleString('hi-IN', { maximumFractionDigits: 2 }) + ' करोड़ km' : (v / 1e6).toLocaleString('en-US', { maximumFractionDigits: 1 }) + ' million km'; }
  function esc(x) { return String(x).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function rnd(seed) { var s = seed >>> 0; return function () { s = (s * 1664525 + 1013904223) >>> 0; return s / 4294967296; }; }
  function hash(str) { var h = 2166136261; for (var i = 0; i < str.length; i++) { h ^= str.charCodeAt(i); h = Math.imul(h, 16777619); } return h >>> 0; }
  function canvas(box, size) {
    var c = document.createElement('canvas'), dpr = Math.min(window.devicePixelRatio || 1, 2);
    c.width = size * dpr; c.height = size * dpr; c.style.width = size + 'px'; c.style.height = size + 'px'; c.style.flexShrink = '0'; c.style.touchAction = 'manipulation';
    var ctx = c.getContext('2d'); ctx.scale(dpr, dpr);
    return { el: c, ctx: ctx, size: size };
  }
  /* Runs draw(t) every frame while the box is on screen (once only when motion is reduced). */
  function animate(box, draw) {
    var on = false, raf = 0, t0 = performance.now();
    function frame(now) { draw((now - t0) / 1000); if (on && !REDUCE) raf = requestAnimationFrame(frame); }
    function start() { if (!on) { on = true; raf = requestAnimationFrame(frame); } }
    function stop() { on = false; cancelAnimationFrame(raf); }
    if ('IntersectionObserver' in window) new IntersectionObserver(function (e) { if (e[0].isIntersecting) start(); else stop(); }).observe(box);
    else start();
    document.addEventListener('visibilitychange', function () { if (document.hidden) stop(); });
    return { redraw: function () { draw((performance.now() - t0) / 1000); } };
  }

  /* ---------- layers: outer radius (km), name, temperature, what it is, kind ---------- */
  function Y(r, n, t, d, k) { return { r: r, n: n, t: t, d: d, k: k }; }
  var LAYERS = {
    sun: [
      Y(174000, ['Core', 'केंद्र (core)'], ['about 15 million °C', 'लगभग 1.5 करोड़ °C'], ['Hydrogen is fused into helium here. This makes all of the Sun’s light.', 'यहाँ हाइड्रोजन जुड़कर हीलियम बनती है। सूरज की सारी रोशनी यहीं बनती है।'], 'fusion'),
      Y(487000, ['Radiative zone', 'विकिरण क्षेत्र'], ['7 to 2 million °C', '70 लाख से 20 लाख °C'], ['Light bounces from atom to atom; it takes it over 100,000 years to cross this layer.', 'रोशनी एक परमाणु से दूसरे पर टकराती चलती है; इस परत को पार करने में उसे 1 लाख साल से ज़्यादा लगते हैं।'], 'plasma'),
      Y(696000, ['Convection zone', 'संवहन क्षेत्र'], ['2 million °C to 5,500 °C at the surface', '20 लाख °C से सतह पर 5,500 °C'], ['Hot gas rises, cools and sinks again, like boiling water. The tops of these bubbles are the grains you see on the surface.', 'गर्म गैस ऊपर उठती है, ठंडी होकर फिर नीचे जाती है, उबलते पानी की तरह। इन बुलबुलों के ऊपरी सिरे सतह पर दाने जैसे दिखते हैं।'], 'convect')
    ],
    mercury: [
      Y(2020, ['Iron core', 'लोहे का केंद्र'], ['about 1,700 to 2,000 °C', 'लगभग 1,700 से 2,000 °C'], ['Huge for such a small planet: about 83% of Mercury’s radius. Part of it is liquid and makes a weak magnetic field.', 'इतने छोटे ग्रह के लिए बहुत बड़ा: बुध की त्रिज्या का लगभग 83%। इसका कुछ हिस्सा तरल है और हल्का चुंबकीय क्षेत्र बनाता है।'], 'metal'),
      Y(2410, ['Rocky mantle', 'चट्टानी mantle'], null, ['A thin shell of rock, only about 400 km thick.', 'चट्टान की पतली परत, बस लगभग 400 km मोटी।'], 'mantle'),
      Y(2440, ['Crust', 'पपड़ी (crust)'], ['−180 °C at night, 430 °C by day', 'रात में −180 °C, दिन में 430 °C'], ['Old, cratered rock about 30 km thick.', 'गड्ढों से भरी पुरानी चट्टान, लगभग 30 km मोटी।'], 'crust')
    ],
    venus: [
      Y(3000, ['Iron core', 'लोहे का केंद्र'], ['about 4,700 °C', 'लगभग 4,700 °C'], ['Probably part liquid, but Venus has no magnetic field of its own.', 'शायद कुछ तरल, पर शुक्र का अपना कोई चुंबकीय क्षेत्र नहीं है।'], 'metal'),
      Y(6022, ['Rocky mantle', 'चट्टानी mantle'], null, ['Hot rock that may still feed volcanoes.', 'गर्म चट्टान, जो शायद अब भी ज्वालामुखियों को ताक़त देती है।'], 'mantle'),
      Y(6052, ['Crust', 'पपड़ी (crust)'], ['465 °C at the surface', 'सतह पर 465 °C'], ['Volcanic plains under a thick, crushing atmosphere.', 'मोटे, भारी वायुमंडल के नीचे ज्वालामुखी के मैदान।'], 'crust')
    ],
    earth: [
      Y(1221, ['Inner core', 'भीतरी केंद्र'], ['about 5,400 °C', 'लगभग 5,400 °C'], ['Solid iron and nickel, as hot as the surface of the Sun but squeezed solid.', 'ठोस लोहा और निकल, सूरज की सतह जितना गर्म, पर दबाव से ठोस।'], 'hot'),
      Y(3480, ['Outer core', 'बाहरी केंद्र'], ['4,000 to 5,000 °C', '4,000 से 5,000 °C'], ['Liquid iron. Its flow makes Earth’s magnetic field, which turns compasses and shields us.', 'तरल लोहा। इसका बहाव पृथ्वी का चुंबकीय क्षेत्र बनाता है, जो compass घुमाता है और हमें बचाता है।'], 'liquidMetal'),
      Y(6336, ['Mantle', 'Mantle'], ['1,000 to 3,700 °C', '1,000 से 3,700 °C'], ['Hot rock that flows very slowly, a few centimetres a year, and moves the continents.', 'गर्म चट्टान जो बहुत धीरे बहती है, साल में कुछ सेंटीमीटर, और महाद्वीपों को खिसकाती है।'], 'mantle'),
      Y(6371, ['Crust', 'पपड़ी (crust)'], ['15 °C on average at the surface', 'सतह पर औसतन 15 °C'], ['Where we live: 5 km thick under the oceans, up to 70 km under mountains.', 'जहाँ हम रहते हैं: समुद्र के नीचे 5 km मोटी, पहाड़ों के नीचे 70 km तक।'], 'crust')
    ],
    mars: [
      Y(1830, ['Liquid iron core', 'तरल लोहे का केंद्र'], ['about 1,900 °C', 'लगभग 1,900 °C'], ['Measured by NASA’s InSight lander from marsquakes. It no longer makes a magnetic field.', 'NASA के InSight lander ने मंगल के भूकंपों से इसे नापा। अब यह चुंबकीय क्षेत्र नहीं बनाता।'], 'liquidMetal'),
      Y(3340, ['Rocky mantle', 'चट्टानी mantle'], null, ['Once fed giant volcanoes like Olympus Mons.', 'कभी Olympus Mons जैसे विशाल ज्वालामुखियों को ताक़त देता था।'], 'mantle'),
      Y(3390, ['Crust', 'पपड़ी (crust)'], ['−65 °C on average', 'औसतन −63 °C'], ['Red, iron-rich dust and rock, about 50 km thick.', 'लाल, लोहे वाली धूल और चट्टान, लगभग 50 km मोटी।'], 'crust')
    ],
    moon: [
      Y(240, ['Inner core', 'भीतरी केंद्र'], ['about 1,400 °C', 'लगभग 1,400 °C'], ['A small ball of solid iron.', 'ठोस लोहे की एक छोटी गेंद।'], 'hot'),
      Y(330, ['Outer core', 'बाहरी केंद्र'], null, ['Liquid iron, found from moonquakes recorded by Apollo.', 'तरल लोहा, Apollo के दर्ज किए चंद्र-भूकंपों से पता चला।'], 'liquidMetal'),
      Y(480, ['Partly melted layer', 'आंशिक पिघली परत'], null, ['Rock that is partly molten.', 'चट्टान जो कुछ पिघली हुई है।'], 'magma'),
      Y(1697, ['Mantle', 'Mantle'], null, ['Cold, solid rock.', 'ठंडी, ठोस चट्टान।'], 'mantle'),
      Y(1737, ['Crust', 'पपड़ी (crust)'], ['−170 °C at night, 120 °C by day', 'रात में −170 °C, दिन में 120 °C'], ['Light highlands and dark lava plains, about 40 km thick.', 'हल्के ऊँचे इलाक़े और काले lava के मैदान, लगभग 40 km मोटी।'], 'crust')
    ],
    jupiter: [
      Y(24500, ['Dilute core', 'फैला हुआ केंद्र'], ['about 20,000 °C', 'लगभग 20,000 °C'], ['Rock and ice mixed into hydrogen. NASA’s Juno found it is fuzzy, not a sharp ball.', 'हाइड्रोजन में घुली चट्टान और बर्फ़। NASA के Juno ने पाया कि यह धुंधला है, साफ़ गोला नहीं।'], 'hot'),
      Y(58000, ['Metallic hydrogen', 'धात्विक हाइड्रोजन'], ['10,000 °C and more', '10,000 °C और ज़्यादा'], ['Squeezed so hard that hydrogen becomes a liquid metal. Its flow makes the strongest magnetic field of any planet.', 'इतना दबाव कि हाइड्रोजन तरल धातु बन जाती है। इसका बहाव किसी भी ग्रह का सबसे तेज़ चुंबकीय क्षेत्र बनाता है।'], 'metalH'),
      Y(69911, ['Hydrogen and clouds', 'हाइड्रोजन और बादल'], ['−110 °C at the cloud tops', 'बादलों के ऊपर −110 °C'], ['Hydrogen and helium gas with ammonia clouds on top. There is no surface to stand on.', 'हाइड्रोजन और हीलियम गैस, ऊपर अमोनिया के बादल। खड़े होने के लिए कोई सतह नहीं।'], 'gas')
    ],
    saturn: [
      Y(14500, ['Core', 'केंद्र (core)'], ['about 12,000 °C', 'लगभग 12,000 °C'], ['Rock and ice mixed with hydrogen; ring waves suggest it is spread out.', 'हाइड्रोजन में मिली चट्टान और बर्फ़; छल्लों की लहरें बताती हैं कि यह फैला हुआ है।'], 'hot'),
      Y(29000, ['Metallic hydrogen', 'धात्विक हाइड्रोजन'], null, ['Liquid metal hydrogen that makes Saturn’s magnetic field.', 'तरल धातु जैसी हाइड्रोजन, जो शनि का चुंबकीय क्षेत्र बनाती है।'], 'metalH'),
      Y(58232, ['Hydrogen and clouds', 'हाइड्रोजन और बादल'], ['−140 °C at the cloud tops', 'बादलों के ऊपर −140 °C'], ['Mostly hydrogen gas. Saturn is so light it would float in a big enough bath.', 'ज़्यादातर हाइड्रोजन गैस। शनि इतना हल्का है कि बहुत बड़े पानी के टब में तैर जाए।'], 'gas')
    ],
    uranus: [
      Y(5000, ['Rocky core', 'चट्टानी केंद्र'], ['about 5,000 °C', 'लगभग 5,000 °C'], ['Rock and iron, about the size of Earth.', 'चट्टान और लोहा, लगभग पृथ्वी जितना।'], 'hot'),
      Y(19000, ['Icy mantle', 'बर्फ़ीला mantle'], null, ['A hot, dense fluid of water, ammonia and methane. Astronomers call these “ices”.', 'पानी, अमोनिया और मीथेन का गर्म, घना तरल। खगोलविद इन्हें “बर्फ़” कहते हैं।'], 'iceMantle'),
      Y(25362, ['Atmosphere', 'वायुमंडल'], ['−195 °C at the cloud tops', 'बादलों के ऊपर −195 °C'], ['Hydrogen and helium; methane makes it look blue-green.', 'हाइड्रोजन और हीलियम; मीथेन इसे नीला-हरा दिखाती है।'], 'gas')
    ],
    neptune: [
      Y(6000, ['Rocky core', 'चट्टानी केंद्र'], ['about 5,100 °C', 'लगभग 5,100 °C'], ['Rock and iron, a little bigger than Earth.', 'चट्टान और लोहा, पृथ्वी से थोड़ा बड़ा।'], 'hot'),
      Y(19700, ['Icy mantle', 'बर्फ़ीला mantle'], null, ['Hot, dense water, ammonia and methane. It may rain diamonds in here.', 'गर्म, घना पानी, अमोनिया और मीथेन। यहाँ शायद हीरों की बारिश होती है।'], 'iceMantle'),
      Y(24622, ['Atmosphere', 'वायुमंडल'], ['−200 °C at the cloud tops', 'बादलों के ऊपर −200 °C'], ['The fastest winds in the solar system, over 2,000 km/h.', 'सौरमंडल की सबसे तेज़ हवाएँ, 2,000 km/h से ज़्यादा।'], 'gas')
    ],
    pluto: [
      Y(850, ['Rocky core', 'चट्टानी केंद्र'], null, ['Rock, making up most of Pluto’s mass.', 'चट्टान, जो प्लूटो के ज़्यादातर वज़न का हिस्सा है।'], 'mantle'),
      Y(950, ['Ocean (likely)', 'महासागर (शायद)'], null, ['New Horizons’ pictures suggest a slushy water ocean under the ice.', 'New Horizons की तस्वीरों से लगता है कि बर्फ़ के नीचे पानी का गाढ़ा महासागर है।'], 'ocean'),
      Y(1188, ['Ice shell', 'बर्फ़ की परत'], ['−230 °C at the surface', 'सतह पर −230 °C'], ['Water ice with frozen nitrogen and methane on top, including the heart-shaped plain.', 'पानी की बर्फ़, ऊपर जमी नाइट्रोजन और मीथेन, दिल के आकार वाले मैदान के साथ।'], 'ice')
    ],
    io: [
      Y(900, ['Iron core', 'लोहे का केंद्र'], null, ['Iron and iron sulphide.', 'लोहा और आयरन सल्फ़ाइड।'], 'metal'),
      Y(1790, ['Hot mantle', 'गर्म mantle'], ['up to about 1,600 °C', 'लगभग 1,600 °C तक'], ['Squeezed by Jupiter’s pull, so it stays partly molten and feeds over 400 volcanoes.', 'बृहस्पति के खिंचाव से दबता है, इसलिए कुछ पिघला रहता है और 400 से ज़्यादा ज्वालामुखियों को चलाता है।'], 'magma'),
      Y(1822, ['Crust', 'पपड़ी (crust)'], ['−130 °C, with lava at over 1,000 °C', '−130 °C, जबकि lava 1,000 °C से ज़्यादा'], ['Sulphur and lava, painted yellow, orange and red.', 'गंधक और lava, पीले, नारंगी और लाल रंग में।'], 'crust')
    ],
    europa: [
      Y(600, ['Iron core', 'लोहे का केंद्र'], null, ['A metal core, probably.', 'शायद धातु का केंद्र।'], 'metal'),
      Y(1430, ['Rocky mantle', 'चट्टानी mantle'], null, ['Rock, warmed by Jupiter’s pull.', 'चट्टान, बृहस्पति के खिंचाव से गर्म।'], 'mantle'),
      Y(1540, ['Salty ocean', 'खारा महासागर'], null, ['About 100 km deep: more water than all of Earth’s oceans. One of the best places to look for life.', 'लगभग 100 km गहरा: पृथ्वी के सारे महासागरों से ज़्यादा पानी। जीवन ढूँढने की सबसे अच्छी जगहों में से एक।'], 'ocean'),
      Y(1561, ['Ice shell', 'बर्फ़ की परत'], ['−160 °C at the surface', 'सतह पर −160 °C'], ['Cracked water ice, roughly 15 to 25 km thick.', 'दरारों वाली पानी की बर्फ़, लगभग 15 से 25 km मोटी।'], 'ice')
    ],
    ganymede: [
      Y(700, ['Iron core', 'लोहे का केंद्र'], null, ['Liquid in part: Ganymede is the only moon with its own magnetic field.', 'कुछ तरल: गैनिमीड अकेला चाँद है जिसका अपना चुंबकीय क्षेत्र है।'], 'liquidMetal'),
      Y(1500, ['Rocky mantle', 'चट्टानी mantle'], null, ['Rock around the core.', 'केंद्र के चारों ओर चट्टान।'], 'mantle'),
      Y(2340, ['Deep ice', 'गहरी बर्फ़'], null, ['Ice squeezed into dense forms.', 'दबाव से घनी बनी बर्फ़।'], 'ice'),
      Y(2490, ['Ocean', 'महासागर'], null, ['A salty ocean sandwiched between layers of ice.', 'बर्फ़ की परतों के बीच दबा खारा महासागर।'], 'ocean'),
      Y(2634, ['Ice crust', 'बर्फ़ की पपड़ी'], ['−160 °C at the surface', 'सतह पर −160 °C'], ['Dark, cratered ice with bright grooves.', 'काली, गड्ढों वाली बर्फ़, चमकीली धारियों के साथ।'], 'ice')
    ],
    callisto: [
      Y(2260, ['Rock and ice', 'चट्टान और बर्फ़'], null, ['Rock and ice only partly separated: Callisto’s inside never fully melted.', 'चट्टान और बर्फ़ पूरी तरह अलग नहीं: कैलिस्टो का भीतर कभी पूरा नहीं पिघला।'], 'mantle'),
      Y(2310, ['Ocean (possible)', 'महासागर (संभव)'], null, ['Magnetic readings hint at salty water here.', 'चुंबकीय माप यहाँ खारे पानी का इशारा देते हैं।'], 'ocean'),
      Y(2410, ['Ice crust', 'बर्फ़ की पपड़ी'], ['−140 °C at the surface', 'सतह पर −140 °C'], ['The most cratered surface in the solar system.', 'सौरमंडल की सबसे ज़्यादा गड्ढों वाली सतह।'], 'ice')
    ],
    titan: [
      Y(2050, ['Rocky core', 'चट्टानी केंद्र'], null, ['Rock, perhaps with water in it.', 'चट्टान, शायद पानी के साथ।'], 'mantle'),
      Y(2300, ['High-pressure ice', 'दबाव वाली बर्फ़'], null, ['Ice squeezed into dense forms.', 'दबाव से घनी बनी बर्फ़।'], 'ice'),
      Y(2475, ['Ocean', 'महासागर'], null, ['Salty water, found from how Titan bends in Saturn’s pull.', 'खारा पानी, शनि के खिंचाव में टाइटन के मुड़ने से पता चला।'], 'ocean'),
      Y(2575, ['Ice shell', 'बर्फ़ की परत'], ['−179 °C at the surface', 'सतह पर −179 °C'], ['Under a thick orange haze, with lakes of liquid methane.', 'मोटी नारंगी धुंध के नीचे, तरल मीथेन की झीलों के साथ।'], 'ice')
    ],
    enceladus: [
      Y(185, ['Rocky core', 'चट्टानी केंद्र'], null, ['Porous rock that hot water can flow through.', 'छेदों वाली चट्टान जिसमें गर्म पानी बह सकता है।'], 'mantle'),
      Y(230, ['Ocean', 'महासागर'], null, ['A global salty ocean. It sprays out of cracks at the south pole.', 'पूरे चाँद में खारा महासागर। दक्षिणी ध्रुव की दरारों से यह फुहार बनकर निकलता है।'], 'ocean'),
      Y(252, ['Ice shell', 'बर्फ़ की परत'], ['−200 °C at the surface', 'सतह पर −200 °C'], ['Very white ice, about 20 km thick, thinner at the south pole.', 'बहुत सफ़ेद बर्फ़, लगभग 20 km मोटी, दक्षिणी ध्रुव पर पतली।'], 'ice')
    ],
    triton: [
      Y(950, ['Rock and metal core', 'चट्टान और धातु का केंद्र'], null, ['Most of Triton’s mass.', 'ट्राइटन के ज़्यादातर वज़न का हिस्सा।'], 'mantle'),
      Y(1250, ['Ice mantle', 'बर्फ़ का mantle'], null, ['Water ice; there may be an ocean.', 'पानी की बर्फ़; शायद महासागर भी हो।'], 'ice'),
      Y(1353, ['Nitrogen ice crust', 'नाइट्रोजन बर्फ़ की पपड़ी'], ['−235 °C, one of the coldest surfaces known', '−235 °C, जानी हुई सबसे ठंडी सतहों में से एक'], ['With geysers of nitrogen gas.', 'नाइट्रोजन गैस के गीज़रों के साथ।'], 'ice')
    ]
  };
  var KIND = {
    fusion: ['#fffbe6', '#ffd75e'], plasma: ['#ffc24a', '#ff8a1f'], convect: ['#ff8a1f', '#e04f10'],
    hot: ['#fff2b8', '#ffb43a'], metal: ['#ffcf73', '#d9822b'], liquidMetal: ['#ffad4a', '#e2661c'],
    magma: ['#ff7a2e', '#b8361a'], mantle: ['#c8603a', '#8a3a24'], crust: null,
    metalH: ['#9fb4f2', '#4e66c4'], gas: null, iceMantle: ['#62c6d8', '#2b7fa6'],
    ocean: ['#4aa6ec', '#1d5fb0'], ice: ['#eaf4fb', '#b8cfe0']
  };
  var MOVING = { fusion: 1, plasma: 1, convect: 1, liquidMetal: 1, magma: 1, metalH: 1, ocean: 1, iceMantle: 1 };

  /* ---------- the surface of a globe (shared by both pictures) ---------- */
  var FEAT = {};
  function features(b) {
    if (FEAT[b.id]) return FEAT[b.id];
    var r = rnd(hash(b.id)), f = [], n = b.style === 'earth' ? 26 : b.style === 'rocky' ? 30 : b.style === 'icyMoon' ? 14 : b.style === 'sun' ? 6 : 0;
    for (var i = 0; i < n; i++) f.push({ lon: r() * 360, lat: (r() * 2 - 1) * (b.style === 'sun' ? 30 : 70), s: b.style === 'earth' ? 0.16 + r() * 0.22 : b.style === 'sun' ? 0.03 + r() * 0.04 : 0.05 + r() * 0.13, c: r() });
    return (FEAT[b.id] = f);
  }
  function surface(ctx, b, x, y, R, rot) {
    ctx.save();
    ctx.beginPath(); ctx.arc(x, y, R, 0, 7); ctx.clip();
    var c = b.colors, g = ctx.createRadialGradient(x - R * 0.35, y - R * 0.35, R * 0.1, x, y, R);
    g.addColorStop(0, c[2]); g.addColorStop(0.55, c[0]); g.addColorStop(1, c[1]);
    ctx.fillStyle = b.style === 'earth' ? c[0] : g; ctx.fillRect(x - R, y - R, 2 * R, 2 * R);
    if (b.style === 'banded' || b.style === 'ice') {
      var bands = b.id === 'jupiter' ? 9 : b.id === 'saturn' ? 7 : 5, strong = b.id === 'jupiter' ? 0.55 : b.id === 'saturn' ? 0.3 : 0.12;
      for (var i = 0; i < bands; i++) {
        var y0 = y - R + (2 * R) * (i + 0.5) / bands, h = (2 * R / bands) * (0.35 + 0.3 * ((i * 7) % 3) / 2);
        ctx.globalAlpha = strong * (i % 2 ? 1 : 0.5); ctx.fillStyle = i % 2 ? c[1] : c[2];
        ctx.fillRect(x - R, y0 - h / 2, 2 * R, h);
      }
      ctx.globalAlpha = 1;
      if (b.spot) { // Jupiter's Great Red Spot turns with the planet
        var a = (200 - rot) * DEG, cs = Math.cos(a);
        if (cs > 0) { ctx.fillStyle = '#c4573a'; ctx.globalAlpha = 0.85; ctx.beginPath(); ctx.ellipse(x + R * Math.sin(a) * 0.92, y + R * 0.38, R * 0.17 * cs, R * 0.09, 0, 0, 7); ctx.fill(); ctx.globalAlpha = 1; }
      }
    }
    var f = features(b);
    for (var k = 0; k < f.length; k++) {
      var p = f[k], lo = (p.lon - rot) * DEG, cl = Math.cos(lo) * Math.cos(p.lat * DEG);
      if (cl <= 0) continue;
      var px = x + R * Math.cos(p.lat * DEG) * Math.sin(lo), py = y - R * Math.sin(p.lat * DEG), rr = R * p.s;
      ctx.globalAlpha = b.style === 'earth' ? 0.95 : b.style === 'sun' ? 0.75 : 0.45;
      ctx.fillStyle = b.style === 'earth' ? (p.c > 0.75 ? c[2] : c[1]) : b.style === 'sun' ? '#5a2408' : (p.c > 0.5 ? c[1] : c[2]);
      ctx.beginPath(); ctx.ellipse(px, py, Math.max(rr * cl, 0.3), rr, 0, 0, 7); ctx.fill();
    }
    ctx.globalAlpha = 1;
    if (b.style === 'earth') { // clouds drift a little faster than the ground
      ctx.fillStyle = 'rgba(255,255,255,.55)';
      for (var q = 0; q < f.length; q += 3) { var p2 = f[q], lo2 = (p2.lon * 1.7 - rot * 1.3) * DEG, cl2 = Math.cos(lo2) * Math.cos(p2.lat * 0.8 * DEG); if (cl2 <= 0) continue; ctx.beginPath(); ctx.ellipse(x + R * Math.cos(p2.lat * 0.8 * DEG) * Math.sin(lo2), y - R * Math.sin(p2.lat * 0.8 * DEG), R * 0.2 * cl2, R * 0.05, 0.2, 0, 7); ctx.fill(); }
    }
    if (b.caps) { ctx.fillStyle = 'rgba(255,255,255,.9)'; ctx.beginPath(); ctx.ellipse(x, y - R * 0.97, R * 0.38, R * 0.12, 0, 0, 7); ctx.fill(); if (b.id === 'earth') { ctx.beginPath(); ctx.ellipse(x, y + R * 0.97, R * 0.42, R * 0.12, 0, 0, 7); ctx.fill(); } }
    // light from the upper left; the Sun glows at its edge instead
    var s = ctx.createRadialGradient(x - R * 0.3, y - R * 0.3, R * 0.2, x, y, R * 1.05);
    if (b.style === 'sun') { s.addColorStop(0, 'rgba(255,255,220,0)'); s.addColorStop(0.8, 'rgba(255,140,30,.15)'); s.addColorStop(1, 'rgba(160,40,0,.55)'); }
    else { s.addColorStop(0, 'rgba(255,255,255,.12)'); s.addColorStop(0.55, 'rgba(0,0,0,0)'); s.addColorStop(1, 'rgba(0,0,10,.6)'); }
    ctx.fillStyle = s; ctx.fillRect(x - R, y - R, 2 * R, 2 * R);
    ctx.restore();
  }

  /* ---------- real surface maps (Solar System Scope, CC BY 4.0, from NASA data) ---------- */
  var TEXTURED = { sun: 1, mercury: 1, venus: 1, earth: 1, moon: 1, mars: 1, jupiter: 1, saturn: 1, uranus: 1, neptune: 1 };
  var TEX = {}, ROOT = document.body.getAttribute('data-root') || '';
  function texture(id) {
    if (!TEXTURED[id]) return null;
    var t = TEX[id];
    if (!t) {
      t = TEX[id] = { ready: false };
      var img = new Image();
      img.onload = function () {
        var c = document.createElement('canvas'); c.width = 512; c.height = 256;
        var x = c.getContext('2d'); x.drawImage(img, 0, 0, 512, 256);
        try { t.data = x.getImageData(0, 0, 512, 256).data; t.ready = true; } catch (e) { t.failed = true; }
      };
      img.onerror = function () { t.failed = true; };
      img.src = ROOT + 'img/textures/' + id + '.webp';
    }
    return t.ready ? t : null;
  }
  var SPHERES = {};
  /* Draws a globe from its surface map: each screen pixel looks up its latitude and longitude. */
  function texGlobe(ctx, b, x, y, R, rot) {
    var t = texture(b.id);
    if (!t) return false;
    var dpr = Math.min(1.5, ctx.getTransform ? ctx.getTransform().a : 1), S = Math.max(4, Math.ceil(2 * R * dpr)), key = S + (b.style === 'sun' ? 's' : '');
    var sp = SPHERES[key];
    if (!sp) {
      var cv = document.createElement('canvas'); cv.width = S; cv.height = S;
      var n = S * S, lat = new Int32Array(n), lon = new Float32Array(n), lit = new Float32Array(n), inside = new Uint8Array(n);
      for (var py = 0; py < S; py++) for (var px = 0; px < S; px++) {
        var i = py * S + px, nx = (px + 0.5) / S * 2 - 1, ny = (py + 0.5) / S * 2 - 1, r2 = nx * nx + ny * ny;
        if (r2 >= 1) continue;
        var nz = Math.sqrt(1 - r2);
        inside[i] = 1;
        lat[i] = Math.min(255, Math.max(0, Math.floor((0.5 + Math.asin(ny) / Math.PI) * 256)));
        lon[i] = (Math.atan2(nx, nz) / (2 * Math.PI) + 0.5) * 512;
        lit[i] = b.style === 'sun' ? 0.55 + 0.45 * nz : Math.max(0.12, 0.25 + 0.85 * (-0.42 * nx - 0.38 * ny + 0.82 * nz));
      }
      sp = SPHERES[key] = { cv: cv, ctx: cv.getContext('2d'), img: cv.getContext('2d').createImageData(S, S), lat: lat, lon: lon, lit: lit, inside: inside, S: S };
    }
    var d = sp.img.data, src = t.data, shift = (((b.id === 'venus' ? rot : -rot) % 360) + 360) % 360 / 360 * 512, n2 = S * S;
    for (var k = 0; k < n2; k++) {
      var o = k * 4;
      if (!sp.inside[k]) { d[o + 3] = 0; continue; }
      var u = (sp.lon[k] + shift) | 0; if (u >= 512) u -= 512;
      var si = (sp.lat[k] * 512 + u) * 4, l = sp.lit[k];
      d[o] = src[si] * l; d[o + 1] = src[si + 1] * l; d[o + 2] = src[si + 2] * l; d[o + 3] = 255;
    }
    sp.ctx.putImageData(sp.img, 0, 0);
    ctx.drawImage(sp.cv, x - R, y - R, 2 * R, 2 * R);
    return true;
  }
  function globe(ctx, b, x, y, R, rot) { if (!texGlobe(ctx, b, x, y, R, rot)) surface(ctx, b, x, y, R, rot); }

  /* ---------- 1. Inside this world ---------- */
  function cutaway(box) {
    var id = box.dataset.body, b = byId[id], layers = LAYERS[id];
    if (!b || !layers) { box.style.display = 'none'; return; }
    var Rkm = layers[layers.length - 1].r, picked = 0;
    // thin layers are drawn thicker so they can be seen; inner ones keep their real proportion otherwise
    var MIN = 0.05, drawn = [], outer = 1;
    for (var i = layers.length - 1; i >= 0; i--) {
      drawn[i] = outer;
      var inner = i > 0 ? layers[i - 1].r / Rkm : 0;
      outer = Math.min(inner, outer - MIN);
      if (i > 0 && outer < 0.06 * i) outer = Math.max(outer, 0.06 * i);
    }
    var size = Math.min(280, Math.max(200, box.clientWidth - 40));
    var cv = canvas(box, size), ctx = cv.ctx, cx = size / 2, cy = size / 2, R = size * 0.43;
    var wrap = document.createElement('div'); wrap.className = 'sim-flex';
    var info = document.createElement('div'); info.style.flex = '1'; info.style.minWidth = '220px';
    wrap.appendChild(cv.el); wrap.appendChild(info); box.innerHTML = ''; box.appendChild(wrap);
    var grains = []; var rg = rnd(hash(id + 'g'));
    for (var g = 0; g < 26; g++) grains.push({ a: rg(), p: rg(), s: 0.5 + rg() });
    function sector(r0, r1) {
      ctx.beginPath(); ctx.moveTo(cx + r0, cy); ctx.arc(cx, cy, r1, 0, -Math.PI / 2, true); ctx.lineTo(cx, cy - r0); ctx.arc(cx, cy, r0, -Math.PI / 2, 0, false); ctx.closePath();
    }
    function draw(t) {
      ctx.clearRect(0, 0, size, size);
      var rot = REDUCE ? 30 : t * (b.style === 'sun' ? 6 : 9);
      // glow behind the Sun
      if (b.style === 'sun') { var gl = ctx.createRadialGradient(cx, cy, R * 0.9, cx, cy, R * 1.18); gl.addColorStop(0, 'rgba(255,170,60,.45)'); gl.addColorStop(1, 'rgba(255,170,60,0)'); ctx.fillStyle = gl; ctx.fillRect(0, 0, size, size); }
      globe(ctx, b, cx, cy, R, rot);
      // the cut-out quarter, layer by layer from the outside in
      for (var i = layers.length - 1; i >= 0; i--) {
        var Lr = layers[i], r1 = drawn[i] * R, r0 = i > 0 ? drawn[i - 1] * R : 0, col = KIND[Lr.k] || (Lr.k === 'crust' ? [b.colors[2], b.colors[1]] : [b.colors[2], b.colors[0]]);
        sector(r0, r1);
        var gr = ctx.createRadialGradient(cx, cy, r0, cx, cy, r1);
        gr.addColorStop(0, col[0]); gr.addColorStop(1, col[1]);
        ctx.fillStyle = gr; ctx.fill();
        if (MOVING[Lr.k] && !REDUCE) { // slow currents in liquid and hot layers
          ctx.save(); sector(r0, r1); ctx.clip();
          ctx.strokeStyle = 'rgba(255,255,255,.18)'; ctx.lineWidth = Math.max(1, (r1 - r0) * 0.12);
          for (var w = 0; w < 3; w++) { var rr = r0 + (r1 - r0) * (0.3 + 0.2 * w), a0 = -Math.PI / 2 + ((t * (0.25 + w * 0.08) + w * 0.4) % 1.2) * Math.PI / 2.2; ctx.beginPath(); ctx.arc(cx, cy, rr, a0, a0 + 0.35); ctx.stroke(); }
          if (Lr.k === 'convect' || Lr.k === 'plasma') {
            ctx.fillStyle = 'rgba(255,240,200,.35)';
            grains.forEach(function (q) { var ph = (q.p + t * 0.12 * q.s) % 1, rr2 = r0 + (r1 - r0) * ph, aa = -Math.PI / 2 + q.a * Math.PI / 2; ctx.beginPath(); ctx.arc(cx + rr2 * Math.cos(aa), cy + rr2 * Math.sin(aa), 1.2 + 1.8 * Math.sin(ph * Math.PI), 0, 7); ctx.fill(); });
          }
          ctx.restore();
        }
        if (i === 0 && (Lr.k === 'hot' || Lr.k === 'fusion' || Lr.k === 'metal' || Lr.k === 'liquidMetal')) { // the hot centre glows
          var pulse = REDUCE ? 0.5 : 0.5 + 0.5 * Math.sin(t * 2);
          var hg = ctx.createRadialGradient(cx, cy, 0, cx, cy, r1 * 1.4);
          hg.addColorStop(0, 'rgba(255,250,220,' + (0.35 + 0.35 * pulse) + ')'); hg.addColorStop(1, 'rgba(255,200,80,0)');
          ctx.save(); sector(0, Math.min(R, r1 * 1.4)); ctx.clip(); ctx.fillStyle = hg; ctx.fillRect(0, 0, size, size); ctx.restore();
        }
      }
      // dim the layers that are not chosen, outline the chosen one
      for (var j = 0; j < layers.length; j++) {
        var a1 = drawn[j] * R, a0b = j > 0 ? drawn[j - 1] * R : 0;
        sector(a0b, a1);
        if (j !== picked) { ctx.fillStyle = 'rgba(4,6,14,.28)'; ctx.fill(); }
      }
      var p1 = drawn[picked] * R, p0 = picked > 0 ? drawn[picked - 1] * R : 0, pl = REDUCE ? 1 : 0.75 + 0.25 * Math.sin(t * 3);
      sector(p0, p1); ctx.strokeStyle = 'rgba(255,255,255,' + pl + ')'; ctx.lineWidth = 2.2; ctx.stroke();
      // the cut faces
      ctx.strokeStyle = 'rgba(0,0,0,.45)'; ctx.lineWidth = 1.2;
      ctx.beginPath(); ctx.moveTo(cx, cy); ctx.lineTo(cx + R, cy); ctx.moveTo(cx, cy); ctx.lineTo(cx, cy - R); ctx.stroke();
    }
    function infoHtml() {
      var Lr = layers[picked], top = picked > 0 ? layers[picked - 1].r : 0, depthTop = Rkm - Lr.r, depthBottom = Rkm - top;
      var chips = layers.map(function (x, i) { var col = KIND[x.k] || [b.colors[2], b.colors[0]]; return '<button class="eyes-chip' + (i === picked ? ' on' : '') + '" type="button" data-layer="' + i + '"><i style="background:' + col[1] + '"></i>' + esc(L(x.n)) + '</button>'; }).reverse().join('');
      var depth = picked === 0
        ? (hi() ? 'केंद्र से ' + km(Lr.r) + ' तक (सतह से ' + km(depthTop) + ' नीचे से शुरू)' : 'From the centre out to ' + km(Lr.r) + ' (starts ' + km(depthTop) + ' below the surface)')
        : (depthTop < 1 ? (hi() ? 'सतह से ' + km(depthBottom) + ' गहराई तक' : 'From the surface down to ' + km(depthBottom))
          : (hi() ? km(depthTop) + ' से ' + km(depthBottom) + ' गहराई तक' : km(depthTop) + ' to ' + km(depthBottom) + ' deep'));
      return '<div class="eyes-chips" style="margin-bottom:10px">' + chips + '</div><h3 style="margin:4px 0;color:var(--accent)">' + esc(L(Lr.n)) + '</h3>' +
        '<p class="note" style="margin:0 0 6px">📏 ' + esc(depth) + (Lr.t ? ' · 🌡️ ' + esc(L(Lr.t)) : '') + '</p><p style="margin:0;color:var(--text)">' + esc(L(Lr.d)) + '</p>' +
        '<p class="note" style="margin-top:10px">' + (hi() ? 'परतों के आकार असली अनुपात में हैं; बहुत पतली परतें दिखने लायक़ मोटी बनाई गई हैं। गहराई की परतें भूकंप की तरंगों, गुरुत्व और अंतरिक्ष यानों के माप से पता चली हैं।' + (TEXTURED[id] ? ' सतह का नक्शा: Solar System Scope (CC BY 4.0), NASA के data से।' : '') : 'Layer sizes are to scale; very thin layers are drawn thicker so you can see them. The insides are known from quake waves, gravity and spacecraft measurements.' + (TEXTURED[id] ? ' Surface map: Solar System Scope (CC BY 4.0), from NASA data.' : '')) + '</p>';
    }
    function pick(i) { picked = i; info.innerHTML = infoHtml(); an.redraw(); }
    info.addEventListener('click', function (e) { var c = e.target.closest('[data-layer]'); if (c) pick(+c.dataset.layer); });
    cv.el.addEventListener('click', function (e) {
      var r = cv.el.getBoundingClientRect(), x = e.clientX - r.left - cx, y = e.clientY - r.top - cy, d = Math.hypot(x, y) / R;
      if (d > 1) return;
      for (var i = 0; i < layers.length; i++) if (d <= drawn[i]) { pick(i); return; }
    });
    var an = animate(box, draw);
    info.innerHTML = infoHtml(); an.redraw();
    API.onRender(function () { info.innerHTML = infoHtml(); });
  }

  /* ---------- 2. Telescope eyepiece ---------- */
  var MODES = [
    { m: 1, field: 60, en: '1× Naked eye', hi: '1× नंगी आँख', lim: 5.5 },
    { m: 10, field: 6.5, en: '10× Binoculars', hi: '10× दूरबीन (binoculars)', lim: 9.5 },
    { m: 100, field: 0.5, en: '100× Telescope', hi: '100× टेलिस्कोप', lim: 12.5 }
  ];
  var MOON_INDEX = { io: ['jupiter', 0], europa: ['jupiter', 1], ganymede: ['jupiter', 2], callisto: ['jupiter', 3], enceladus: ['saturn', 1], titan: ['saturn', 5] };
  function geo(id, ms) { var e = API.helio('earth', ms), p = API.helio(id, ms); return { x: p.x - e.x, y: p.y - e.y, z: p.z - e.z, e: e, p: p }; }
  function phaseOf(id, ms) { // lit fraction and which side faces the Sun (as seen from Earth)
    if (id === 'moon') { var mp = API.moonPhase(ms); return { k: mp.lit, right: mp.age < 180 }; }
    if (id === 'earth') { var m2 = API.moonPhase(ms); return { k: 1 - m2.lit, right: m2.age > 180 }; }
    if (!API.helio || ['mercury', 'venus', 'mars'].indexOf(id) < 0) return null;
    var g = geo(id, ms), r = Math.hypot(g.p.x, g.p.y, g.p.z), d = Math.hypot(g.x, g.y, g.z), R = Math.hypot(g.e.x, g.e.y, g.e.z);
    var cosi = (r * r + d * d - R * R) / (2 * r * d), lon = Math.atan2(g.y, g.x) / DEG, sun = API.sunLon(ms), el = ((lon - sun) % 360 + 540) % 360 - 180;
    return { k: (1 + cosi) / 2, right: el > 0 };
  }
  function shade(ctx, x, y, r, ph) { // darkens the unlit part of a disc
    if (!ph || ph.k > 0.995) return;
    var s = ph.right ? 1 : -1, k = ph.k;
    ctx.save(); ctx.beginPath(); ctx.arc(x, y, r + 0.5, 0, 7);
    ctx.moveTo(x, y - r);
    for (var a = 90; a >= -90; a -= 6) ctx.lineTo(x + s * r * Math.cos(a * DEG), y - r * Math.sin(a * DEG));
    for (var a2 = -90; a2 <= 90; a2 += 6) ctx.lineTo(x + s * r * (1 - 2 * k) * Math.cos(a2 * DEG), y - r * Math.sin(a2 * DEG));
    ctx.closePath(); ctx.fillStyle = 'rgba(2,3,10,.93)'; ctx.fill('evenodd'); ctx.restore();
  }
  function rings(ctx, x, y, r, tilt, front) {
    var s = Math.max(0.02, Math.abs(Math.sin(tilt * DEG))), bands = [[1.24, 1.53, 'rgba(170,150,110,.35)'], [1.53, 1.95, 'rgba(232,214,170,.9)'], [2.03, 2.27, 'rgba(214,194,150,.75)']];
    // seen from the north side (tilt > 0) the far half of the rings is above the planet
    var lower = (tilt >= 0) === front;
    ctx.save(); ctx.beginPath();
    if (lower) ctx.rect(x - r * 3, y, r * 6, r * 3); else ctx.rect(x - r * 3, y - r * 3, r * 6, r * 3);
    ctx.clip();
    bands.forEach(function (bd) { ctx.beginPath(); ctx.ellipse(x, y, r * bd[1], r * bd[1] * s, 0, 0, 7); ctx.ellipse(x, y, r * bd[0], r * bd[0] * s, 0, 0, 7); ctx.fillStyle = bd[2]; ctx.fill('evenodd'); });
    ctx.restore();
  }
  function telescope(box) {
    var id = box.dataset.body, b = byId[id];
    if (!b) return;
    var M = window.ASTRYL_MOONS, host = MOON_INDEX[id] ? MOON_INDEX[id][0] : (b.parent && b.parent !== 'earth' ? b.parent : null);
    var main = id === 'earth' ? b : (host ? byId[host] : b), mode = 1, field = MODES[1].field, target = field, zoomFrom = field, zoomAt = 0;
    var size = Math.min(300, Math.max(220, box.clientWidth - 40));
    var cv = canvas(box, size), ctx = cv.ctx, cx = size / 2, cy = size / 2, FR = size / 2 - 3;
    var wrap = document.createElement('div'); wrap.className = 'sim-flex';
    var info = document.createElement('div'); info.style.flex = '1'; info.style.minWidth = '220px';
    wrap.appendChild(cv.el); wrap.appendChild(info); box.innerHTML = ''; box.appendChild(wrap);
    var stars = [], sr = rnd(hash(id + 's'));
    for (var i = 0; i < 520; i++) { var rr = 34 * Math.sqrt(sr()), aa = sr() * 6.283; stars.push({ x: rr * Math.cos(aa), y: rr * Math.sin(aa), m: 1 + 7.5 * Math.pow(sr(), 0.45), tw: sr() * 6 }); }
    for (var j = 0; j < 40; j++) { var r2 = 1.2 * Math.sqrt(sr()), a2 = sr() * 6.283; stars.push({ x: r2 * Math.cos(a2), y: r2 * Math.sin(a2), m: 8.5 + 4 * sr(), tw: sr() * 6 }); }
    function state(ms) {
      var dist, Rkm = main.diam / 2;
      if (id === 'earth') dist = 384400; // Earth as seen from the Moon
      else if (main.id === 'moon') dist = 384400;
      else dist = API.distKm ? API.distKm(main.id, ms) : 1.5e8;
      var ang = 2 * Math.atan(Rkm / dist) / DEG; // degrees
      return { dist: dist, ang: ang, ph: phaseOf(main.id === 'earth' ? 'earth' : main.id, ms), tilt: main.id === 'saturn' && M ? M.ringTilt(ms) : 0 };
    }
    function moonDots(ms) {
      if (!M) return [];
      if (main.id === 'jupiter') return M.jupiter(ms).map(function (p, i) { return { x: p.x, y: p.y, z: p.z, id: ['io', 'europa', 'ganymede', 'callisto'][i] }; });
      if (main.id === 'saturn') { var s = M.saturn(ms); return [{ p: s[5], id: 'titan' }, { p: s[1], id: 'enceladus' }, { p: s[4], id: 'rhea' }].map(function (o) { return { x: o.p.x, y: o.p.y, z: o.p.z, id: o.id }; }); }
      return [];
    }
    function draw(t) {
      var ms = Date.now(), st = state(ms);
      if (zoomAt) { var q = Math.min(1, (performance.now() - zoomAt) / 700); field = Math.exp(Math.log(zoomFrom) + (Math.log(target) - Math.log(zoomFrom)) * (1 - Math.pow(1 - q, 3))); if (q >= 1) zoomAt = 0; }
      var ppd = FR / (field / 2), lim = MODES[mode].lim;
      ctx.clearRect(0, 0, size, size);
      ctx.save(); ctx.beginPath(); ctx.arc(cx, cy, FR, 0, 7); ctx.clip();
      ctx.fillStyle = id === 'earth' ? '#020308' : '#03050c'; ctx.fillRect(0, 0, size, size);
      var jit = REDUCE || field > 10 ? 0 : (field < 1 ? 0.7 : 0.25), jx = jit * (Math.sin(t * 11) + 0.6 * Math.sin(t * 23.7)), jy = jit * (Math.cos(t * 9.3) + 0.6 * Math.sin(t * 17.1));
      var drift = REDUCE || field > 1 ? 0 : Math.sin(t * 0.18) * FR * 0.1;
      if (id !== 'sun') stars.forEach(function (s) { // fainter stars appear as the aperture grows
        if (s.m > lim) return;
        var x = cx + s.x * ppd + drift, y = cy + s.y * ppd; if (x < -2 || x > size + 2 || y < -2 || y > size + 2) return;
        var a = Math.min(1, 0.25 + (lim - s.m) / 5), tw = field > 10 && !REDUCE ? 0.75 + 0.25 * Math.sin(t * 3 + s.tw) : 1;
        ctx.fillStyle = 'rgba(235,240,255,' + (a * tw).toFixed(2) + ')'; ctx.beginPath(); ctx.arc(x, y, s.m < 2.5 ? 1.6 : s.m < 4.5 ? 1.1 : 0.7, 0, 7); ctx.fill();
      });
      var R = st.ang / 2 * ppd, x = cx + jx + drift, y = cy + jy;
      if (main.id === 'saturn' && R > 1.5) rings(ctx, x, y, R, st.tilt, false);
      if (R < 1.4) { // too small to show a disc: a star-like point
        var glow = ctx.createRadialGradient(x, y, 0, x, y, 6);
        glow.addColorStop(0, 'rgba(255,255,255,1)'); glow.addColorStop(0.25, main.colors[2]); glow.addColorStop(1, 'rgba(255,255,255,0)');
        ctx.fillStyle = glow; ctx.beginPath(); ctx.arc(x, y, 6, 0, 7); ctx.fill();
      } else {
        globe(ctx, main, x, y, R, REDUCE ? 20 : t * 4);
        shade(ctx, x, y, R, st.ph);
      }
      if (main.id === 'saturn' && R > 1.5) rings(ctx, x, y, R, st.tilt, true);
      var dots = moonDots(ms), mark = null;
      dots.forEach(function (d) {
        var mx = x + d.x * Math.max(R, 0.0001), my = y - d.y * Math.max(R, 0.0001);
        if (Math.hypot(d.x, d.y) < 1 && d.z < 0) return; // behind the planet
        if (mode === 0) return;
        ctx.fillStyle = d.id === id ? '#ffd166' : 'rgba(240,236,220,.95)'; ctx.beginPath(); ctx.arc(mx, my, d.id === id ? 1.8 : 1.3, 0, 7); ctx.fill();
        if (d.id === id) mark = [mx, my];
      });
      if (mark) { ctx.strokeStyle = '#ffd166'; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.arc(mark[0], mark[1], 7, 0, 7); ctx.stroke(); }
      // crosshair and field ring
      ctx.strokeStyle = 'rgba(120,170,255,.16)'; ctx.lineWidth = 1;
      ctx.beginPath(); ctx.moveTo(cx - FR, cy); ctx.lineTo(cx - 14, cy); ctx.moveTo(cx + 14, cy); ctx.lineTo(cx + FR, cy); ctx.moveTo(cx, cy - FR); ctx.lineTo(cx, cy - 14); ctx.moveTo(cx, cy + 14); ctx.lineTo(cx, cy + FR); ctx.stroke();
      var v = ctx.createRadialGradient(cx, cy, FR * 0.8, cx, cy, FR); v.addColorStop(0, 'rgba(0,0,0,0)'); v.addColorStop(1, 'rgba(0,0,0,.65)'); ctx.fillStyle = v; ctx.fillRect(0, 0, size, size);
      ctx.restore();
      ctx.strokeStyle = 'rgba(130,155,220,.45)'; ctx.lineWidth = 3; ctx.beginPath(); ctx.arc(cx, cy, FR, 0, 7); ctx.stroke();
      // a close-up when the real disc is small
      if (mode > 0 && R >= 1.4 && R < 24 && main.id !== 'moon' && id !== 'sun') {
        var ix = size - 52, iy = size - 52, IR = 46, big = IR * (main.id === 'saturn' ? 0.36 : 0.72);
        ctx.save(); ctx.beginPath(); ctx.arc(ix, iy, IR, 0, 7); ctx.fillStyle = '#02030a'; ctx.fill(); ctx.clip();
        if (main.id === 'saturn') rings(ctx, ix, iy, big, st.tilt, false);
        globe(ctx, main, ix, iy, big, REDUCE ? 20 : t * 4); shade(ctx, ix, iy, big, st.ph);
        if (main.id === 'saturn') rings(ctx, ix, iy, big, st.tilt, true);
        ctx.restore();
        ctx.strokeStyle = 'rgba(255,209,102,.7)'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.arc(ix, iy, IR, 0, 7); ctx.stroke();
        ctx.fillStyle = 'rgba(255,220,150,.95)'; ctx.font = '600 10px "DM Sans",sans-serif'; ctx.textAlign = 'center';
        ctx.fillText(hi() ? 'बड़ा करके ×' + Math.round(big / R) : 'enlarged ×' + Math.round(big / R), ix, iy + IR - 6);
      }
      ctx.fillStyle = '#8fa8ff'; ctx.font = '700 11px "DM Sans",sans-serif'; ctx.textAlign = 'center';
      ctx.fillText(MODES[mode].m + '× · ' + (field >= 1 ? field.toFixed(field < 10 ? 1 : 0) + '°' : Math.round(field * 60) + '′') + (hi() ? ' दृश्य' : ' field'), cx, size - 10);
    }
    function sizeText(deg) { var as = deg * 3600; return as < 120 ? Math.round(as) + '″' : (as < 7200 ? (as / 60).toFixed(1) + '′' : (deg).toFixed(1) + '°'); }
    function infoHtml() {
      var st = state(Date.now()), m = MODES[mode], apparent = st.ang * m.m, moonRatio = apparent / 0.52;
      var chips = MODES.map(function (x, i) { return '<button class="eyes-chip' + (i === mode ? ' on' : '') + '" type="button" data-mode="' + i + '">' + esc(hi() ? x.hi : x.en) + '</button>'; }).join('');
      var nm = API.bname(main.id), cmp = moonRatio >= 1.15 ? (hi() ? 'नंगी आँख से दिखते पूरे चाँद से ' + moonRatio.toFixed(1) + ' गुना चौड़ा' : moonRatio.toFixed(1) + ' times as wide as the full Moon looks to your eyes')
        : moonRatio >= 0.85 ? (hi() ? 'लगभग उतना जितना नंगी आँख से पूरा चाँद' : 'about as wide as the full Moon looks to your eyes')
          : (hi() ? 'नंगी आँख से दिखते पूरे चाँद का 1/' + Math.round(1 / moonRatio) : '1/' + Math.round(1 / moonRatio) + ' of the full Moon’s width to your eyes');
      var lines = [];
      if (id === 'earth') lines.push(hi() ? 'आप पृथ्वी पर खड़े हैं, इसलिए यहाँ वह पृथ्वी है जो चाँद से दिखती है, आज की कला के साथ।' : 'You are standing on Earth, so this is Earth as seen from the Moon, with today’s phase.');
      else if (main.id === 'moon') lines.push(hi() ? 'चाँद लगभग ' + km(st.dist) + ' दूर है और लगभग ' + sizeText(st.ang) + ' चौड़ा दिखता है।' : 'The Moon is about ' + km(st.dist) + ' away and looks about ' + sizeText(st.ang) + ' wide.');
      else lines.push(hi() ? nm + ' आज ' + kmBig(st.dist) + ' दूर है और ' + sizeText(st.ang) + ' चौड़ा दिखता है।' : nm + ' is ' + kmBig(st.dist) + ' away today and looks ' + sizeText(st.ang) + ' wide.');
      if (mode > 0) lines.push(hi() ? m.m + '× पर यह ' + cmp + ' दिखता है।' : 'At ' + m.m + '× it looks ' + cmp + '.');
      if (main.id === 'saturn') lines.push(hi() ? 'आज छल्ले हमारी ओर ' + Math.abs(st.tilt).toFixed(1) + '° झुके हैं' + (Math.abs(st.tilt) < 4 ? ', लगभग किनारे से, इसलिए पतली लकीर जैसे दिखते हैं।' : '।') : 'Today the rings are tilted ' + Math.abs(st.tilt).toFixed(1) + '° towards us' + (Math.abs(st.tilt) < 4 ? ', almost edge-on, so they look like a thin line.' : '.'));
      if (st.ph && st.ph.k < 0.995) lines.push(hi() ? 'आज इसका ' + Math.round(st.ph.k * 100) + '% हिस्सा रोशन है।' : 'Today ' + Math.round(st.ph.k * 100) + '% of it is lit.');
      var tip = TIPS[id] || TIPS[main.id];
      if (tip) lines.push(L(tip[mode]));
      if (host && id !== host) lines.push(MOON_INDEX[id] ? (hi() ? API.bname(id) + ' पीले घेरे वाला बिंदु है, आज की असली जगह पर।' : API.bname(id) + ' is the dot in the yellow ring, where it really is today.') : (hi() ? API.bname(id) + ' ' + nm + ' के पास एक बहुत धुंधला बिंदु है, बड़े telescope से ही दिखता है।' : API.bname(id) + ' is a very faint point near ' + nm + '; it needs a big telescope.'));
      var warn = id === 'sun' ? '<p class="no" style="margin:8px 0 0"><b>⚠️ ' + (hi() ? 'सूरज को कभी भी दूरबीन, telescope या नंगी आँख से सीधे मत देखिए। सिर्फ़ सही solar filter के साथ।' : 'Never look at the Sun through binoculars, a telescope or with bare eyes. Only with a proper solar filter.') + '</b></p>' : '';
      return '<div class="eyes-chips" style="margin-bottom:10px">' + chips + '</div>' + lines.map(function (l) { return '<p style="margin:0 0 6px;color:var(--text)">' + esc(l) + '</p>'; }).join('') + warn +
        '<p class="note" style="margin-top:8px">' + (hi() ? 'आकार आज की असली दूरी से निकाले गए हैं। 100× पर हवा की वजह से तस्वीर थोड़ी काँपती है, असली telescope की तरह।' : 'Sizes are worked out from today’s real distance. At 100× the air makes the view shimmer a little, as in a real telescope.') + '</p>';
    }
    var TIPS = {
      sun: [['A blinding disc. Do not look.', 'आँखें चौंधियाने वाली डिस्क। मत देखिए।'], ['Through a solar filter: the round Sun and maybe sunspots.', 'Solar filter से: गोल सूरज और शायद सौर धब्बे।'], ['Through a solar filter: sunspots and the darker edge of the Sun.', 'Solar filter से: सौर धब्बे और सूरज का गहरा किनारा।']],
      moon: [['Light and dark patches: the dark ones are old lava plains.', 'हल्के और गहरे धब्बे: गहरे वाले पुराने lava के मैदान हैं।'], ['Craters stand out along the line between light and dark.', 'रोशनी और अँधेरे की सीमा पर गड्ढे साफ़ दिखते हैं।'], ['Craters, mountains and valleys. The Moon fills the whole view.', 'गड्ढे, पहाड़ और घाटियाँ। चाँद पूरा दृश्य भर देता है।']],
      mercury: [['A star-like point low in the twilight, never far from the Sun.', 'संध्या में नीचे एक तारे जैसा बिंदु, सूरज से कभी दूर नहीं।'], ['Still a point; it is small and far.', 'अब भी एक बिंदु; यह छोटा और दूर है।'], ['A tiny disc that shows phases like the Moon.', 'एक छोटी डिस्क जो चाँद की तरह कलाएँ दिखाती है।']],
      venus: [['The brightest “star” in the evening or morning sky.', 'शाम या सुबह के आसमान का सबसे चमकीला “तारा”।'], ['Sometimes you can just see its crescent.', 'कभी-कभी इसका पतला चाँद जैसा रूप दिख जाता है।'], ['Its phase is clear: crescent, half or almost full. The clouds hide the surface.', 'इसकी कला साफ़ दिखती है: पतली, आधी या लगभग पूरी। बादल सतह को छुपा देते हैं।']],
      mars: [['An orange-red point.', 'एक नारंगी-लाल बिंदु।'], ['Still a small orange point.', 'अब भी एक छोटा नारंगी बिंदु।'], ['A small orange disc; when Mars is close, a white polar cap and dark markings.', 'एक छोटी नारंगी डिस्क; मंगल पास हो तो सफ़ेद ध्रुवीय बर्फ़ और गहरे निशान।']],
      jupiter: [['A bright, steady point.', 'एक चमकीला, स्थिर बिंदु।'], ['Its four big moons appear as tiny dots in a line.', 'इसके चार बड़े चाँद एक लाइन में छोटे बिंदुओं जैसे दिखते हैं।'], ['Two dark cloud belts, and the four moons where they are tonight.', 'बादलों की दो गहरी पट्टियाँ, और चारों चाँद जहाँ वे आज रात हैं।']],
      saturn: [['A yellowish point.', 'एक पीला-सा बिंदु।'], ['A slightly oval point; the rings are hard to see.', 'थोड़ा अंडाकार बिंदु; छल्ले मुश्किल से दिखते हैं।'], ['The rings, at today’s tilt, and the moon Titan nearby.', 'छल्ले, आज के झुकाव पर, और पास में टाइटन चाँद।']],
      uranus: [['Just at the edge of what eyes can see, from a dark place.', 'अँधेरी जगह से, आँख की पहुँच के ठीक किनारे पर।'], ['A faint star-like point.', 'एक धुंधला, तारे जैसा बिंदु।'], ['A tiny blue-green disc.', 'एक छोटी नीली-हरी डिस्क।']],
      neptune: [['Too faint for the eyes.', 'आँखों के लिए बहुत धुंधला।'], ['A faint star-like point if you know where to look.', 'पता हो कहाँ देखना है तो एक धुंधला बिंदु।'], ['A tiny blue point, barely a disc.', 'एक छोटा नीला बिंदु, मुश्किल से डिस्क।']],
      pluto: [['Far too faint.', 'बहुत ही धुंधला।'], ['Far too faint.', 'बहुत ही धुंधला।'], ['About magnitude 14: you need a large telescope and a star map; even then it looks like a faint star.', 'लगभग magnitude 14: बड़ा telescope और तारों का नक्शा चाहिए; तब भी एक धुंधले तारे जैसा दिखता है।']],
      earth: [['From the Moon, Earth is about 2° wide and hangs still in the sky.', 'चाँद से पृथ्वी लगभग 2° चौड़ी दिखती है और आसमान में एक जगह टिकी रहती है।'], ['Clouds, oceans and continents.', 'बादल, समुद्र और महाद्वीप।'], ['At 100× it is bigger than the whole view.', '100× पर यह पूरे दृश्य से बड़ी है।']]
    };
    function setMode(i) { if (i === mode) return; zoomFrom = field; target = MODES[i].field; zoomAt = REDUCE ? 0 : performance.now(); if (REDUCE) field = target; mode = i; info.innerHTML = infoHtml(); an.redraw(); }
    info.addEventListener('click', function (e) { var c = e.target.closest('[data-mode]'); if (c) setMode(+c.dataset.mode); });
    var an = animate(box, draw);
    info.innerHTML = infoHtml(); an.redraw();
    API.onRender(function () { info.innerHTML = infoHtml(); });
  }

  function init() {
    var c = document.getElementById('cutawaySim'), tl = document.getElementById('telescopeSim');
    if (c) cutaway(c);
    if (tl) telescope(tl);
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
  window.ASTRYL_WORLDS = { LAYERS: LAYERS, phaseOf: phaseOf };
})();
