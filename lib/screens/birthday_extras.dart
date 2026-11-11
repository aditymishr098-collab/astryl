import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../core/orbits.dart';
import '../data/universe_catalog.dart';
import '../l10n/names.dart';
import '../data/planets.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/share_card.dart';
import 'learn_screen.dart' show bi;

/// Constellations along the ecliptic (IAU boundaries), by the ecliptic
/// longitude where each begins.
const List<(double, String, String)> _zodiac = <(double, String, String)>[
  (0, 'Pisces', 'मीन'), (29.1, 'Aries', 'मेष'), (53.5, 'Taurus', 'वृषभ'), (90.4, 'Gemini', 'मिथुन'), (118.3, 'Cancer', 'कर्क'),
  (138.2, 'Leo', 'सिंह'), (174.2, 'Virgo', 'कन्या'), (218.0, 'Libra', 'तुला'), (241.1, 'Scorpius', 'वृश्चिक'), (247.7, 'Ophiuchus', 'सर्पधारी'),
  (266.3, 'Sagittarius', 'धनु'), (299.7, 'Capricornus', 'मकर'), (327.6, 'Aquarius', 'कुंभ'), (351.6, 'Pisces', 'मीन'),
];

/// The constellation a planet stood in front of on [date], and whether it
/// was an evening (1), morning (-1), all-night (2) or hidden (0) planet.
(String, String, int) planetPlace(String id, DateTime date) {
  final d = clampOrbitDate(date);
  final e = heliocentricPosition('earth', d);
  final p = heliocentricPosition(id, d);
  double n360(double a) => (a % 360 + 360) % 360;
  final lon = n360(math.atan2(p.y - e.y, p.x - e.x) * 180 / math.pi);
  final sunLon = n360(math.atan2(-e.y, -e.x) * 180 / math.pi);
  var con = _zodiac.first;
  for (final z in _zodiac) {
    if (lon >= z.$1) {
      con = z;
    }
  }
  final diff = n360(lon - sunLon);
  final elong = diff > 180 ? 360 - diff : diff;
  final when = elong < 15 ? 0 : (elong > 150 ? 2 : (diff < 180 ? 1 : -1));
  return (con.$2, con.$3, when);
}

/// Space milestones, as year-month, with English and Hindi text.
const List<(int, int, String, String)> spaceHistory = <(int, int, String, String)>[
  (1957, 10, 'Sputnik 1, the first satellite', 'स्पुतनिक 1, पहला उपग्रह'),
  (1961, 4, 'Yuri Gagarin, the first person in space', 'यूरी गागारिन, अंतरिक्ष में पहले इंसान'),
  (1969, 7, 'Apollo 11: the first people on the Moon', 'अपोलो 11: चाँद पर पहले इंसान'),
  (1977, 9, 'Voyager 1 launched; now the farthest human-made object', 'Voyager 1 छोड़ा गया; अब इंसान की बनाई सबसे दूर की चीज़'),
  (1984, 4, 'Rakesh Sharma, the first Indian in space', 'राकेश शर्मा, अंतरिक्ष में पहले भारतीय'),
  (1990, 4, 'The Hubble Space Telescope launched', 'Hubble space telescope छोड़ा गया'),
  (1995, 10, 'The first planet found around another Sun-like star', 'किसी दूसरे सूरज जैसे तारे के पास पहला ग्रह मिला'),
  (2000, 11, 'People start living on the International Space Station', 'अंतर्राष्ट्रीय अंतरिक्ष स्टेशन पर इंसान रहने लगे'),
  (2006, 8, 'Pluto becomes a dwarf planet', 'प्लूटो बौना ग्रह बना'),
  (2008, 10, 'Chandrayaan-1 launched; it found water on the Moon', 'चंद्रयान-1 छोड़ा गया; उसने चाँद पर पानी पाया'),
  (2012, 8, 'Curiosity lands on Mars; Voyager 1 enters interstellar space', 'Curiosity मंगल पर उतरा; Voyager 1 तारों के बीच पहुँचा'),
  (2014, 9, 'Mangalyaan reaches Mars on India’s first try', 'मंगलयान भारत की पहली ही कोशिश में मंगल पहुँचा'),
  (2015, 7, 'New Horizons flies past Pluto', 'New Horizons प्लूटो के पास से गुज़रा'),
  (2015, 9, 'Gravitational waves detected for the first time', 'पहली बार गुरुत्वीय तरंगें पकड़ी गईं'),
  (2019, 4, 'The first picture of a black hole (M87*)', 'ब्लैक होल की पहली तस्वीर (M87*)'),
  (2021, 12, 'The James Webb Space Telescope launched', 'James Webb space telescope छोड़ा गया'),
  (2022, 9, 'DART pushes an asteroid off course', 'DART ने एक क्षुद्रग्रह का रास्ता बदला'),
  (2023, 8, 'Chandrayaan-3 lands near the Moon’s south pole', 'चंद्रयान-3 चाँद के दक्षिणी ध्रुव के पास उतरा'),
];

/// Stars and clusters that the light of [birth] has already passed, nearest
/// first, and the next one it will reach.
(List<(String, double)>, (String, double)?) birthdayLight(DateTime birth, DateTime now) {
  final ly = now.difference(birth).inSeconds / (365.25 * 86400);
  final stars = <(String, double)>[for (final s in starRows) if (s.kind != 1) (s.name, s.distLy)]..sort((a, b) => a.$2.compareTo(b.$2));
  final passed = <(String, double)>[for (final s in stars) if (s.$2 <= ly) s];
  (String, double)? next;
  for (final s in stars) {
    if (s.$2 > ly) {
      next = s;
      break;
    }
  }
  return (passed, next);
}

class BirthdayExtras extends StatefulWidget {
  const BirthdayExtras({super.key, required this.birth});

  final DateTime birth;

  @override
  State<BirthdayExtras> createState() => _BirthdayExtrasState();
}

class _BirthdayExtrasState extends State<BirthdayExtras> {
  final GlobalKey _card = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    final palette = Palette.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final bridge = AppScope.read(context).bridge;
    final text = '${bi(context, 'My birthday sky', 'मेरे जन्मदिन का आसमान')}: https://astryl.space/you.html';
    final failed = bi(context, 'Could not share the picture.', 'तस्वीर share नहीं हो सकी।');
    setState(() => _sharing = true);
    var ok = false;
    try {
      final boundary = _card.currentContext?.findRenderObject();
      if (boundary is RenderRepaintBoundary) {
        final bytes = await renderShareCard(boundary, palette);
        final dir = await bridge.sharedDir();
        if (dir.isNotEmpty) {
          final file = File('$dir${Platform.pathSeparator}Astryl-birthday.png');
          await file.writeAsBytes(bytes, flush: true);
          ok = await bridge.shareImage(file.path, text);
        }
      }
    } on Exception {
      ok = false;
    }
    if (!mounted) {
      return;
    }
    setState(() => _sharing = false);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final l = context.l10n;
    final b = widget.birth;
    final now = DateTime.now();
    final noon = DateTime.utc(b.year, b.month, b.day, 12);
    final years = now.difference(b).inSeconds / (365.25 * 86400);
    final (passed, next) = birthdayLight(b, now);
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    String big(double x) {
      if (x >= 1e12) {
        return '${(x / 1e12).toStringAsFixed(1)} ${isHi ? 'लाख करोड़' : 'trillion'}';
      }
      if (x >= 1e9) {
        return '${(x / 1e9).toStringAsFixed(1)} ${isHi ? 'अरब' : 'billion'}';
      }
      if (x >= 1e6) {
        return '${(x / 1e6).toStringAsFixed(1)} ${isHi ? 'मिलियन' : 'million'}';
      }
      return x.round().toString();
    }

    TextStyle h(double s) => TextStyle(fontFamily: headingFont, fontSize: s, fontWeight: FontWeight.w700, color: p.text);
    Widget stat(String v, String label) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: <Widget>[
            Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: p.muted))),
            const SizedBox(width: 10),
            Text(v, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: p.text)),
          ]),
        );
    final planets = <String>['mercury', 'venus', 'mars', 'jupiter', 'saturn'];
    final history = spaceHistory.where((e) => DateTime(e.$1, e.$2, 28).isAfter(b)).toList();
    final lastStar = passed.isEmpty ? null : passed.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RepaintBoundary(
          key: _card,
          child: SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(bi(context, 'The planets on your birthday', 'आपके जन्मदिन पर ग्रह'), style: h(18)),
                const SizedBox(height: 10),
                for (final id in planets)
                  Builder(builder: (context) {
                    final place = planetPlace(id, noon);
                    final when = switch (place.$3) {
                      1 => bi(context, 'evening sky', 'शाम का आसमान'),
                      -1 => bi(context, 'morning sky', 'सुबह का आसमान'),
                      2 => bi(context, 'all night', 'पूरी रात'),
                      _ => bi(context, 'hidden by the Sun', 'सूरज की चमक में छिपा'),
                    };
                    return stat(bi(context, place.$1, place.$2), '${planetName(l, planetById(id))} · $when');
                  }),
                const SizedBox(height: 6),
                Text(
                    lastStar == null
                        ? bi(context, 'Your birthday light is on its way to the nearest star.', 'आपके जन्मदिन की रोशनी सबसे पास के तारे की ओर जा रही है।')
                        : bi(context, '✨ Light from your birthday has reached ${lastStar.$1}, ${years.toStringAsFixed(1)} light-years away.',
                            '✨ आपके जन्मदिन की रोशनी ${lastStar.$1} तक पहुँच गई है, ${years.toStringAsFixed(1)} प्रकाश-वर्ष दूर।'),
                    style: TextStyle(fontSize: 15, height: 1.4, fontWeight: FontWeight.w600, color: p.accentText)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(bi(context, 'Constellations here are the real star patterns behind each planet, not astrology signs.', 'यहाँ तारामंडल हर ग्रह के पीछे के असली तारा-समूह हैं, ज्योतिष की राशियाँ नहीं।'),
            style: TextStyle(fontSize: 12, color: p.muted)),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _sharing ? null : _share,
          icon: const Icon(Icons.share),
          label: Text(bi(context, 'Share my birthday sky', 'अपने जन्मदिन का आसमान share करें')),
        ),
        const SizedBox(height: 16),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(bi(context, 'How far your birthday light has gone', 'आपके जन्मदिन की रोशनी कितनी दूर गई'), style: h(18)),
              const SizedBox(height: 8),
              Text(
                  bi(context, '${passed.length} stars on our list are already behind it.${next == null ? '' : ' Next stop: ${next.$1}, in ${(b.year + next.$2).floor()}.'}',
                      'हमारी list के ${passed.length} तारे पीछे छूट चुके हैं।${next == null ? '' : ' अगला पड़ाव: ${next.$1}, ${(b.year + next.$2).floor()} में।'}'),
                  style: TextStyle(fontSize: 14.5, height: 1.45, color: p.text)),
              if (passed.isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Text(passed.map((s) => s.$1).join(' · '), style: TextStyle(fontSize: 12.5, color: p.muted)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(bi(context, 'What the universe did since you were born', 'आपके जन्म से अब तक ब्रह्मांड में क्या हुआ'), style: h(18)),
              const SizedBox(height: 10),
              stat(years.toStringAsFixed(2), bi(context, 'Trips around the Sun', 'सूरज के चक्कर')),
              stat('${big(years * 940e6)} km', bi(context, 'Travelled around the Sun', 'सूरज के चारों ओर सफ़र')),
              stat('${big(years * 365.25 * 86400 * 230)} km', bi(context, 'Travelled around the Milky Way', 'आकाशगंगा के चारों ओर सफ़र')),
              stat((years * 365.25 / 29.53).floor().toString(), bi(context, 'Full Moons', 'पूर्णिमाएँ')),
              stat('~${(years * 7).round()}', bi(context, 'New stars in the Milky Way', 'आकाशगंगा में नए तारे')),
              stat('~${big(years * 3e11)}', bi(context, 'New stars in the universe (very rough)', 'ब्रह्मांड में नए तारे (बहुत मोटा अनुमान)')),
              stat('${(9.4607e12 * 6.92e-11 * years).round()} km', bi(context, 'Stretch of every light-year of space', 'अंतरिक्ष के हर प्रकाश-वर्ष का खिंचाव')),
              const SizedBox(height: 4),
              Text(
                  bi(context, 'Averages: the Milky Way makes about 7 new stars a year; the universe-wide number comes from the measured star-forming rate and can be off by a few times.',
                      'औसत: आकाशगंगा साल में लगभग 7 नए तारे बनाती है; पूरे ब्रह्मांड की संख्या नापी गई तारा-निर्माण दर से है और कुछ गुना ऊपर-नीचे हो सकती है।'),
                  style: TextStyle(fontSize: 12, color: p.muted)),
            ],
          ),
        ),
        if (history.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(bi(context, 'Space history in your lifetime', 'आपके जीवनकाल में अंतरिक्ष का इतिहास'), style: h(18)),
                const SizedBox(height: 8),
                for (final e in history)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      SizedBox(width: 48, child: Text('${e.$1}', style: TextStyle(fontWeight: FontWeight.w700, color: p.accentText))),
                      Expanded(child: Text(bi(context, e.$3, e.$4), style: TextStyle(fontSize: 14, height: 1.4, color: p.text))),
                    ]),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}
