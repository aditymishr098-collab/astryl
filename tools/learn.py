"""Deep space quiz, the Black holes 101 learning path and its badge (logic in site_src/learn.js)."""
import json

from dskit import Kit

# s: set (bh or gx); q: question; o: options; a: index of the right option; e: explanation (en, hi)
def _o(*xs):
    return [x if isinstance(x, tuple) else (x, x) for x in xs]


QUESTIONS = [
    dict(s='bh', q=('What is the edge of a black hole called?', 'ब्लैक होल के किनारे को क्या कहते हैं?'), o=_o(('Event horizon', 'Event horizon (घटना क्षितिज)'), ('Photon ring', 'Photon ring'), ('Accretion disk', 'Accretion disk'), ('Singularity', 'Singularity')), a=0, e=('The event horizon is the point of no return. The singularity is the centre.', 'Event horizon वापसी का आख़िरी बिंदु है। Singularity केंद्र है।')),
    dict(s='bh', q=('What will the Sun become at the end of its life?', 'जीवन के अंत में सूरज क्या बनेगा?'), o=_o(('A black hole', 'ब्लैक होल'), ('A white dwarf', 'White dwarf'), ('A neutron star', 'न्यूट्रॉन तारा'), ('A quasar', 'Quasar')), a=1, e=('The Sun is too light to become a black hole. It will end as a white dwarf about the size of Earth.', 'सूरज ब्लैक होल बनने के लिए बहुत हल्का है। वह पृथ्वी जितने white dwarf के रूप में समाप्त होगा।')),
    dict(s='bh', q=('Which black hole was pictured first, in 2019?', '2019 में किस ब्लैक होल की पहली तस्वीर ली गई?'), o=_o('Sagittarius A*', 'M87*', 'Cygnus X-1', 'TON 618'), a=1, e=('The Event Horizon Telescope pictured M87* in April 2019 and Sagittarius A* in 2022.', 'Event Horizon Telescope ने अप्रैल 2019 में M87* और 2022 में Sagittarius A* की तस्वीर ली।')),
    dict(s='bh', q=('What is the event horizon radius of a black hole with the mass of the Sun, roughly?', 'सूरज के द्रव्यमान वाले ब्लैक होल के event horizon की त्रिज्या लगभग कितनी है?'), o=_o(('3 m', '3 m'), ('3 km', '3 km'), ('30 km', '30 km'), ('300 km', '300 km')), a=1, e=('The Schwarzschild radius is about 3 km for every Sun of mass.', 'Schwarzschild radius हर सूरज के द्रव्यमान पर लगभग 3 km है।')),
    dict(s='bh', q=('How heavy is the black hole at the centre of our Galaxy?', 'हमारी आकाशगंगा के केंद्र का ब्लैक होल कितना भारी है?'), o=_o(('About 10 Suns', 'लगभग 10 सूरज'), ('About 4.3 million Suns', 'लगभग 43 लाख सूरज'), ('About 4.3 billion Suns', 'लगभग 4.3 अरब सूरज'), ('About 100 Suns', 'लगभग 100 सूरज')), a=1, e=('Sagittarius A* weighs about 4.3 million Suns, worked out from stars that orbit it.', 'Sagittarius A* का द्रव्यमान लगभग 43 लाख सूरज है, जो उसकी परिक्रमा करते तारों से निकाला गया।')),
    dict(s='bh', q=('What did LIGO detect for the first time in 2015?', '2015 में LIGO ने पहली बार क्या पकड़ा?'), o=_o(('Light from a black hole', 'ब्लैक होल की रोशनी'), ('Gravitational waves', 'गुरुत्वीय तरंगें'), ('A wormhole', 'Wormhole'), ('Hawking radiation', 'Hawking radiation')), a=1, e=('Two merging black holes shook space itself, and LIGO measured the ripples.', 'दो ब्लैक होल के मिलने से अंतरिक्ष ही हिला, और LIGO ने उन लहरों को नापा।')),
    dict(s='bh', q=('If the Sun were swapped for a black hole of the same mass, what would Earth do?', 'अगर सूरज की जगह उतने ही द्रव्यमान का ब्लैक होल रख दें, तो पृथ्वी क्या करेगी?'), o=_o(('Get sucked in at once', 'तुरंत खिंच जाएगी'), ('Fly away', 'दूर उड़ जाएगी'), ('Keep orbiting the same way', 'वैसे ही घूमती रहेगी'), ('Stop spinning', 'घूमना बंद कर देगी')), a=2, e=('Gravity far away depends on mass only. It would be dark and cold, but the orbit would not change.', 'दूर की gravity सिर्फ़ द्रव्यमान पर निर्भर है। अँधेरा और ठंड होती, पर कक्षा नहीं बदलती।')),
    dict(s='bh', q=('Roughly how far away is the nearest known black hole?', 'सबसे नज़दीकी ज्ञात ब्लैक होल लगभग कितना दूर है?'), o=_o(('16 light-years', '16 प्रकाश-वर्ष'), ('1,600 light-years', '1,600 प्रकाश-वर्ष'), ('160,000 light-years', '1,60,000 प्रकाश-वर्ष'), ('16 million light-years', '1.6 करोड़ प्रकाश-वर्ष')), a=1, e=('Gaia BH1, found in 2022, is about 1,600 light-years away.', 'Gaia BH1, जो 2022 में मिला, लगभग 1,600 प्रकाश-वर्ष दूर है।')),
    dict(s='bh', q=('What is spaghettification?', 'Spaghettification क्या है?'), o=_o(('A black hole eating a star whole', 'ब्लैक होल का तारे को पूरा निगलना'), ('Stretching caused by the difference in gravity across an object', 'किसी चीज़ पर gravity के फ़र्क़ से होने वाला खिंचाव'), ('Light bending round a black hole', 'ब्लैक होल के चारों ओर रोशनी का मुड़ना'), ('A jet of gas', 'गैस की धारा')), a=1, e=('Gravity pulls harder on the nearer part, so an object falling in is stretched long and thin.', 'Gravity पास वाले हिस्से को ज़्यादा खींचती है, इसलिए गिरती चीज़ लंबी और पतली खिंच जाती है।')),
    dict(s='bh', q=('Hawking radiation has been…', 'Hawking radiation…'), o=_o(('Photographed in 2019', '2019 में photograph की गई'), ('Predicted but never observed', 'भविष्यवाणी हुई पर कभी देखी नहीं गई'), ('Proven false', 'ग़लत साबित हो चुकी है'), ('Measured by LIGO', 'LIGO ने नापी')), a=1, e=('Hawking predicted in 1974 that black holes glow very faintly. It has not been observed.', 'Hawking ने 1974 में कहा कि ब्लैक होल बहुत हल्का चमकते हैं। इसे देखा नहीं गया है।')),
    dict(s='gx', q=('What shape is the Milky Way?', 'आकाशगंगा का आकार कैसा है?'), o=_o(('Elliptical', 'Elliptical'), ('Barred spiral', 'Barred spiral'), ('Irregular', 'Irregular'), ('A perfect sphere', 'पूरा गोला')), a=1, e=('A flat disk with a bar of stars and spiral arms.', 'चपटी disk, जिसमें तारों की bar और spiral भुजाएँ हैं।')),
    dict(s='gx', q=('About how wide is the Milky Way’s disk?', 'आकाशगंगा की disk लगभग कितनी चौड़ी है?'), o=_o(('1,000 light-years', '1,000 प्रकाश-वर्ष'), ('100,000 light-years', '1,00,000 प्रकाश-वर्ष'), ('10 million light-years', '1 करोड़ प्रकाश-वर्ष'), ('1 light-year', '1 प्रकाश-वर्ष')), a=1, e=('About 100,000 light-years across, but only about 1,000 thick.', 'लगभग 1,00,000 प्रकाश-वर्ष चौड़ी, पर सिर्फ़ लगभग 1,000 मोटी।')),
    dict(s='gx', q=('Which large galaxy is nearest to the Milky Way?', 'आकाशगंगा के सबसे पास की बड़ी galaxy कौन-सी है?'), o=_o('Triangulum', 'Andromeda', 'Whirlpool', 'Sombrero'), a=1, e=('Andromeda (M31) is about 2.5 million light-years away.', 'Andromeda (M31) लगभग 25 लाख प्रकाश-वर्ष दूर है।')),
    dict(s='gx', q=('Andromeda is moving…', 'Andromeda…'), o=_o(('Toward us', 'हमारी ओर आ रही है'), ('Away from us', 'हमसे दूर जा रही है'), ('Not at all', 'बिल्कुल नहीं हिल रही'), ('In a circle round the Sun', 'सूरज के चारों ओर घूम रही है')), a=0, e=('It approaches at about 110 km per second and may merge with the Milky Way billions of years from now.', 'यह लगभग 110 km प्रति सेकंड से पास आ रही है और अरबों साल बाद आकाशगंगा से मिल सकती है।')),
    dict(s='gx', q=('Which is the most common kind of galaxy by number?', 'गिनती में सबसे आम प्रकार की galaxy कौन-सी है?'), o=_o(('Giant spirals', 'विशाल spiral'), ('Dwarf galaxies', 'बौनी galaxies'), ('Quasars', 'Quasar'), ('Giant ellipticals', 'विशाल elliptical')), a=1, e=('Small dwarf galaxies far outnumber the big ones.', 'छोटी बौनी galaxies बड़ी वाली से कहीं ज़्यादा हैं।')),
    dict(s='gx', q=('What does a light-year measure?', 'प्रकाश-वर्ष क्या नापता है?'), o=_o(('Time', 'समय'), ('Distance', 'दूरी'), ('Brightness', 'चमक'), ('Speed', 'गति')), a=1, e=('It is the distance light travels in a year, about 9.46 trillion km.', 'यह प्रकाश के एक साल में तय की दूरी है, लगभग 94.6 खरब km।')),
    dict(s='gx', q=('How far is the Sun from the centre of the Milky Way?', 'सूरज आकाशगंगा के केंद्र से कितनी दूर है?'), o=_o(('2,600 light-years', '2,600 प्रकाश-वर्ष'), ('26,000 light-years', '26,000 प्रकाश-वर्ष'), ('260,000 light-years', '2,60,000 प्रकाश-वर्ष'), ('26 light-years', '26 प्रकाश-वर्ष')), a=1, e=('About 26,000 light-years, on a small branch called the Orion Spur.', 'लगभग 26,000 प्रकाश-वर्ष, Orion Spur नाम की छोटी शाखा पर।')),
    dict(s='gx', q=('Who showed in 1924 that Andromeda is a separate galaxy?', '1924 में किसने दिखाया कि Andromeda एक अलग galaxy है?'), o=_o('Galileo', 'Edwin Hubble', 'Stephen Hawking', 'Carl Sagan'), a=1, e=('Edwin Hubble measured its distance and found it far outside the Milky Way.', 'Edwin Hubble ने उसकी दूरी नापी और पाया कि वह आकाशगंगा से बहुत बाहर है।')),
    dict(s='gx', q=('Most of the Milky Way’s mass is…', 'आकाशगंगा का ज़्यादातर द्रव्यमान…'), o=_o(('Stars', 'तारे हैं'), ('Gas', 'गैस है'), ('Dark matter', 'Dark matter है'), ('Black holes', 'ब्लैक होल हैं')), a=2, e=('Roughly a trillion Suns of mass, mostly dark matter, which we know only from its pull.', 'लगभग 10 खरब सूरज का द्रव्यमान, ज़्यादातर dark matter, जिसे हम सिर्फ़ उसके खिंचाव से जानते हैं।')),
    dict(s='gx', q=('When two galaxies collide, what rarely happens?', 'दो galaxies के टकराने पर क्या शायद ही होता है?'), o=_o(('Stars hit each other', 'तारों का आपस में टकराना'), ('Gas clouds are squeezed', 'गैस के बादलों का दबना'), ('New stars form', 'नए तारों का बनना'), ('Shapes change', 'आकार का बदलना')), a=0, e=('Stars are so far apart that almost none collide, but the gas does.', 'तारे एक-दूसरे से इतने दूर हैं कि लगभग कोई नहीं टकराता, पर गैस टकराती है।')),
    dict(s='gx', q=('The Magellanic Clouds can be seen only from…', 'Magellanic Clouds सिर्फ़ यहाँ से दिखते हैं…'), o=_o(('The far north', 'सुदूर उत्तर'), ('The southern hemisphere and near the equator', 'दक्षिणी गोलार्ध और भूमध्य रेखा के पास'), ('Space', 'अंतरिक्ष'), ('Mountains only', 'सिर्फ़ पहाड़ों से')), a=1, e=('They sit in the far southern sky, so they never rise for most of the northern hemisphere.', 'वे सुदूर दक्षिणी आसमान में हैं, इसलिए उत्तरी गोलार्ध के ज़्यादातर हिस्से में कभी उगते नहीं।')),
]


def build(h):
    k = Kit(h)
    bt, P, H2, callout, note = k.bt, k.P, k.H2, k.callout, k.note
    asset_v = h['asset_v']
    out = []

    # ---------- quiz
    data = json.dumps(QUESTIONS, ensure_ascii=False)
    body = f'''<section class="blk"><h1>{bt("Black hole and galaxy quiz", "ब्लैक होल और galaxy quiz")}</h1><p class="sub">{bt("Five random questions from the set you pick. Every answer is explained.", "आपके चुने set से पाँच random सवाल। हर जवाब समझाया गया है।")}</p>
<div class="row" id="dsqTabs"><button class="btn primary" type="button" data-set="bh">⚫ {bt("Black holes", "ब्लैक होल")}</button><button class="btn" type="button" data-set="gx">🌌 {bt("Galaxies", "Galaxies")}</button><button class="btn" type="button" data-set="all">🎲 {bt("Mixed", "मिला-जुला")}</button></div>
<div id="dsq"></div>
{note("Your best scores stay in this browser only. They are not sent anywhere.", "आपके सबसे अच्छे स्कोर सिर्फ़ इसी browser में रहते हैं। कहीं भेजे नहीं जाते।")}</section>
<section class="blk callout">{bt("Earn the Black hole explorer badge:", "Black hole explorer badge पाइए:")} <a href="black-holes-101.html">{bt("Black holes 101", "Black holes 101")} →</a></section>
<script type="application/json" id="dsqData">{data}</script>'''
    out.append(('deep-space-quiz.html', h['shell']('Black hole and galaxy quiz', 'ब्लैक होल और galaxy quiz', 'quiz', body,
                'A free quiz on black holes and galaxies, with 20 questions and an explanation for every answer.',
                canonical='deep-space-quiz.html', extra_head=f'<script defer src="assets/learn.js?v={asset_v()}"></script>')))

    # ---------- learning path
    lessons = [
        ('what-is-a-black-hole', 'What is a black hole?', 'ब्लैक होल क्या है?', '⚫'),
        ('how-black-holes-form', 'How black holes form', 'ब्लैक होल कैसे बनते हैं', '💥'),
        ('event-horizon-and-singularity', 'Event horizon and singularity', 'Event horizon और singularity', '🎯'),
        ('falling-into-a-black-hole', 'Falling into a black hole', 'ब्लैक होल में गिरना', '🧑‍🚀'),
        ('famous-black-holes', 'Famous black holes', 'मशहूर ब्लैक होल', '🌟'),
        ('how-we-see-black-holes', 'How we see the invisible', 'अदृश्य को हम कैसे देखते हैं', '📡'),
        ('black-hole-myths-and-big-questions', 'Myths and big questions', 'भ्रम और बड़े सवाल', '❓'),
    ]
    lis = ''.join(f'<li data-slug="{s}"><a href="black-holes/{s}.html"><span class="tick">✓</span><span class="ic">{ic}</span><span>{bt(en, hi)}</span></a></li>' for s, en, hi, ic in lessons)
    slugs = ','.join(s for s, *_ in lessons)
    medal = '''<svg viewBox="0 0 120 150" width="96" height="120" aria-hidden="true"><defs><radialGradient id="mdl" cx=".4" cy=".35"><stop offset="0" stop-color="#ffe9b0"/><stop offset="1" stop-color="#e29a2e"/></radialGradient></defs>
<path d="M32 0 L60 52 L88 0 Z" fill="#5b8cff"/><path d="M44 0 L60 30 L76 0 Z" fill="#a98bff"/>
<circle cx="60" cy="88" r="46" fill="url(#mdl)" stroke="#fff3cf" stroke-width="3"/><circle cx="60" cy="88" r="34" fill="#05070f"/>
<ellipse cx="60" cy="88" rx="44" ry="10" fill="none" stroke="#ffb347" stroke-width="4" transform="rotate(-18 60 88)"/><circle cx="60" cy="88" r="3" fill="#fff"/></svg>'''
    body = f'''<section class="blk"><h1>{bt("Black holes 101", "Black holes 101")}</h1><p class="sub">{bt("A seven-lesson path from “what is it?” to the big open questions. Each lesson takes a few minutes. Finish them all and score well on the quiz to earn a badge.", "सात पाठों का रास्ता, “यह क्या है?” से लेकर बड़े खुले सवालों तक। हर पाठ में कुछ मिनट लगते हैं। सब पूरे कीजिए और quiz में अच्छा स्कोर लाइए, तो badge मिलेगा।")}</p>
<div class="card"><div class="pbar"><i id="pathBar"></i></div><p class="note" id="pathCount"></p>
<ol id="pathList" class="plist">{lis}</ol>
<div class="row"><a class="btn primary" href="deep-space-quiz.html">{bt("Take the Black hole quiz", "Black hole quiz खेलिए")} →</a><a class="btn" href="black-hole-lab.html">🧪 {bt("Black hole lab", "ब्लैक होल lab")}</a><button class="btn" type="button" id="pathReset">{bt("Reset progress", "Progress मिटाएँ")}</button></div></div></section>
<section class="blk"><h2>{bt("Your badge", "आपका badge")}</h2><div class="card badgebox"><div id="badge" data-total="{len(lessons)}" data-slugs="{slugs}">{medal}</div><div><h3>{bt("Black hole explorer", "Black hole explorer")}</h3><p id="badgeState"></p></div></div>
{note("A lesson counts as read after it has been open for a few seconds. Progress is saved in this browser only and is not sent anywhere.", "पाठ कुछ सेकंड खुला रहने के बाद पढ़ा हुआ गिना जाता है। Progress सिर्फ़ इसी browser में सेव होती है और कहीं भेजी नहीं जाती।")}</section>'''
    out.append(('black-holes-101.html', h['shell']('Black holes 101', 'Black holes 101', 'bh', body,
                'A free seven-lesson path to understand black holes, from what they are to the big open questions, with a quiz and a badge.',
                canonical='black-holes-101.html', extra_head=f'<script defer src="assets/learn.js?v={asset_v()}"></script>')))
    for f, html in out:
        h['write'](f, html)
    return [f for f, _ in out]
