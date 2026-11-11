import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/sky_catalog.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'learn_screen.dart' show bi;

const Set<String> _zodiac = <String>{'Ari', 'Tau', 'Gem', 'Cnc', 'Leo', 'Vir', 'Lib', 'Sco', 'Sgr', 'Cap', 'Aqr', 'Psc', 'Oph'};
const List<String> _monthsEn = <String>['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
const List<String> _monthsHi = <String>['जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर'];

/// One of the 88 constellations, with its parts joined (Serpens has two).
class ConstellationInfo {
  ConstellationInfo(this.id, this.latin, this.names, this.lines);

  final String id;
  final String latin;
  final Map<String, String> names;
  final List<List<double>> lines;

  late final List<(double, double)> points = <(double, double)>[
    for (final seg in lines)
      for (var k = 0; k + 1 < seg.length; k += 2) (seg[k], seg[k + 1])
  ];

  /// Centre of the figure on the sky (right ascension, declination), degrees.
  late final (double, double) centre = () {
    var x = 0.0, y = 0.0, z = 0.0;
    for (final p in points) {
      final a = p.$1 * math.pi / 180, d = p.$2 * math.pi / 180;
      x += math.cos(d) * math.cos(a);
      y += math.cos(d) * math.sin(a);
      z += math.sin(d);
    }
    final n = math.sqrt(x * x + y * y + z * z);
    return ((math.atan2(y, x) * 180 / math.pi + 360) % 360, math.asin(z / (n == 0 ? 1 : n)) * 180 / math.pi);
  }();

  /// The month when it is highest at about 9 pm (0 = January).
  int get bestMonth {
    final days = ((centre.$1 / 15 - 9) % 24) / 24 * 365.25;
    return (((79 + days) % 365.25) / 30.44).floor() % 12;
  }

  /// Highest point above the horizon seen from Delhi (28.6° N), degrees.
  double get topFromIndia => 90 - (28.6 - centre.$2).abs();

  String nameFor(String lang) => names[lang] ?? names['en'] ?? latin;
}

double _sep(double a1, double d1, double a2, double d2) {
  final r = math.pi / 180;
  final c = math.sin(d1 * r) * math.sin(d2 * r) + math.cos(d1 * r) * math.cos(d2 * r) * math.cos((a1 - a2) * r);
  return math.acos(c.clamp(-1.0, 1.0)) / r;
}

/// The 88 constellations: the app's catalogue lists Serpens in two parts.
List<ConstellationInfo> allConstellations() {
  final byId = <String, ConstellationInfo>{};
  for (final c in catalogConstellations) {
    final have = byId[c.id];
    if (have == null) {
      byId[c.id] = ConstellationInfo(c.id, c.latin, c.names, <List<double>>[...c.lines]);
    } else {
      have.lines.addAll(c.lines);
    }
  }
  return byId.values.toList();
}

/// The brightest catalogue star on the figure, or null.
StarData? brightestStar(ConstellationInfo c) {
  StarData? best;
  for (final p in c.points) {
    for (final s in catalogStars) {
      if ((s.ra - p.$1).abs() < 0.5 && (s.dec - p.$2).abs() < 0.5 && _sep(s.ra, s.dec, p.$1, p.$2) < 0.3) {
        if (best == null || s.mag < best.mag) {
          best = s;
        }
      }
    }
  }
  return best;
}

class ConstellationsScreen extends StatefulWidget {
  const ConstellationsScreen({super.key});

  @override
  State<ConstellationsScreen> createState() => _ConstellationsScreenState();
}

class _ConstellationsScreenState extends State<ConstellationsScreen> {
  late final List<ConstellationInfo> _all = allConstellations();
  String _q = '';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final q = _q.trim().toLowerCase();
    final list = _all.where((c) {
      final text = '${c.nameFor('en')} ${c.nameFor('hi')} ${c.latin} ${c.id}'.toLowerCase();
      if (q.isNotEmpty && !text.contains(q)) {
        return false;
      }
      return switch (_filter) {
        'india' => c.topFromIndia > 25,
        'north' => c.centre.$2 > 15,
        'south' => c.centre.$2 < -15,
        'zodiac' => _zodiac.contains(c.id),
        _ => true,
      };
    }).toList()
      ..sort((a, b) => a.nameFor(lang).compareTo(b.nameFor(lang)));
    final chips = <(String, String, String)>[
      ('all', 'All 88', 'सभी 88'), ('india', 'Seen from India', 'भारत से दिखने वाले'), ('north', 'Northern', 'उत्तरी'), ('south', 'Southern', 'दक्षिणी'), ('zodiac', 'Zodiac', 'राशि-पथ'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(bi(context, 'Constellations', 'तारामंडल'), style: const TextStyle(fontWeight: FontWeight.w700))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: <Widget>[
          Text(bi(context, 'All 88 constellations as you see them when you face them: north up, east to the left. Bigger dots are brighter stars.', 'सभी 88 तारामंडल, जैसे उनकी तरफ़ देखने पर दिखते हैं: ऊपर उत्तर, बाईं ओर पूर्व। बड़े बिंदु चमकीले तारे हैं।'),
              style: TextStyle(fontSize: 14, height: 1.4, color: p.muted)),
          const SizedBox(height: 10),
          TextField(
            onChanged: (v) => setState(() => _q = v),
            decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: bi(context, 'Orion, Saptarishi…', 'ओरायन, सप्तर्षि…')),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
            for (final ch in chips)
              ChoiceChip(label: Text(bi(context, ch.$2, ch.$3)), selected: _filter == ch.$1, onSelected: (_) => setState(() => _filter = ch.$1)),
          ]),
          const SizedBox(height: 6),
          Text('${list.length} / ${_all.length}', style: TextStyle(fontSize: 12, color: p.muted)),
          const SizedBox(height: 8),
          for (final c in list) _ConstellationCard(info: c),
        ],
      ),
    );
  }
}

class _ConstellationCard extends StatelessWidget {
  const _ConstellationCard({required this.info});

  final ConstellationInfo info;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final star = brightestStar(info);
    final m = info.bestMonth;
    final top = info.topFromIndia;
    final dsos = catalogDeepSky.where((d) => d.constellation == info.id).take(3).toList();
    final india = top > 25
        ? bi(context, '✅ Seen well from India', '✅ भारत से अच्छा दिखता है')
        : top > 5
            ? bi(context, '🟡 Low in the south from India', '🟡 भारत से दक्षिण में नीचे')
            : bi(context, '❌ Not seen from most of India', '❌ भारत के ज़्यादातर हिस्से से नहीं दिखता');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(aspectRatio: 1.6, child: CustomPaint(painter: ConstellationPainter(info, star))),
            ),
            const SizedBox(height: 10),
            Text(bi(context, info.nameFor('en'), info.nameFor('hi')),
                style: TextStyle(fontFamily: headingFont, fontSize: 18, fontWeight: FontWeight.w700, color: p.text)),
            Text('${info.latin}${_zodiac.contains(info.id) ? ' · ${bi(context, 'Zodiac', 'राशि-पथ')}' : ''}', style: TextStyle(fontSize: 13, color: p.muted)),
            const SizedBox(height: 6),
            if (star != null && star.name.isNotEmpty)
              Text('⭐ ${bi(context, 'Brightest star', 'सबसे चमकीला तारा')}: ${star.name} (${star.mag.toStringAsFixed(1)})', style: TextStyle(fontSize: 13.5, color: p.text)),
            Text('🗓️ ${bi(context, 'Best in the evening', 'शाम को सबसे अच्छा')}: ${bi(context, _monthsEn[m], _monthsHi[m])}', style: TextStyle(fontSize: 13.5, color: p.text)),
            Text(india, style: TextStyle(fontSize: 13.5, color: p.text)),
            if (dsos.isNotEmpty) Text('🔭 ${dsos.map((d) => '${d.id} ${d.name}').join(', ')}', style: TextStyle(fontSize: 13.5, color: p.text)),
          ],
        ),
      ),
    );
  }
}

/// A constellation drawn with a tangent-plane projection: east left, north up.
class ConstellationPainter extends CustomPainter {
  ConstellationPainter(this.info, this.bright);

  final ConstellationInfo info;
  final StarData? bright;

  Offset _proj(double ra, double dec) {
    final r = math.pi / 180;
    final a = ra * r, d = dec * r, a0 = info.centre.$1 * r, d0 = info.centre.$2 * r;
    final cosc = math.sin(d0) * math.sin(d) + math.cos(d0) * math.cos(d) * math.cos(a - a0);
    final x = math.cos(d) * math.sin(a - a0) / cosc;
    final y = (math.cos(d0) * math.sin(d) - math.sin(d0) * math.cos(d) * math.cos(a - a0)) / cosc;
    return Offset(-x, -y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF05070F));
    final pts = <Offset>[for (final p in info.points) _proj(p.$1, p.$2)];
    if (pts.isEmpty) {
      return;
    }
    var minX = pts.first.dx, maxX = minX, minY = pts.first.dy, maxY = minY;
    for (final o in pts) {
      minX = math.min(minX, o.dx);
      maxX = math.max(maxX, o.dx);
      minY = math.min(minY, o.dy);
      maxY = math.max(maxY, o.dy);
    }
    const pad = 22.0;
    final scale = math.min((size.width - 2 * pad) / math.max(maxX - minX, 1e-3), (size.height - 2 * pad) / math.max(maxY - minY, 1e-3));
    final cx = (minX + maxX) / 2, cy = (minY + maxY) / 2;
    Offset to(double ra, double dec) {
      final o = _proj(ra, dec);
      return Offset(size.width / 2 + (o.dx - cx) * scale, size.height / 2 + (o.dy - cy) * scale);
    }

    double radius(double mag) => (5.0 - 0.85 * mag).clamp(1.4, 6.0).toDouble();
    var reach = 0.0;
    for (final p in info.points) {
      reach = math.max(reach, _sep(info.centre.$1, info.centre.$2, p.$1, p.$2));
    }
    reach = reach * 1.45 + 2;
    final faint = Paint()..color = const Color(0x8CB4C2E6);
    for (final s in catalogStars) {
      if (s.mag < 5.2 && (s.dec - info.centre.$2).abs() < reach && _sep(info.centre.$1, info.centre.$2, s.ra, s.dec) < reach) {
        final o = to(s.ra, s.dec);
        if (o.dx > 0 && o.dy > 0 && o.dx < size.width && o.dy < size.height) {
          canvas.drawCircle(o, radius(s.mag) * 0.45, faint);
        }
      }
    }
    final line = Paint()
      ..color = const Color(0xD97AA2FF)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    for (final seg in info.lines) {
      final path = Path();
      for (var k = 0; k + 1 < seg.length; k += 2) {
        final o = to(seg[k], seg[k + 1]);
        if (k == 0) {
          path.moveTo(o.dx, o.dy);
        } else {
          path.lineTo(o.dx, o.dy);
        }
      }
      canvas.drawPath(path, line);
    }
    final dot = Paint()..color = const Color(0xFFF2F4FF);
    for (final p in info.points) {
      var mag = 4.5;
      for (final s in catalogStars) {
        if ((s.ra - p.$1).abs() < 0.5 && (s.dec - p.$2).abs() < 0.5 && _sep(s.ra, s.dec, p.$1, p.$2) < 0.3) {
          mag = math.min(mag, s.mag);
        }
      }
      canvas.drawCircle(to(p.$1, p.$2), radius(mag), dot);
    }
    final b = bright;
    if (b != null && b.name.isNotEmpty) {
      final o = to(b.ra, b.dec);
      final tp = TextPainter(
        text: TextSpan(text: b.name, style: const TextStyle(fontSize: 12, color: Color(0xFFFFD27A))),
        textDirection: TextDirection.ltr,
      )..layout();
      final left = o.dx > size.width * 0.7;
      tp.paint(canvas, Offset(left ? o.dx - tp.width - 8 : o.dx + 8, o.dy - tp.height - 2));
    }
  }

  @override
  bool shouldRepaint(ConstellationPainter old) => old.info.id != info.id;
}
