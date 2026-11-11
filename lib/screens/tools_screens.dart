import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import 'learn_screen.dart' show bi;

const double _g = 6.674e-11;
const double _c = 2.99792458e8;
const double _hbar = 1.054571817e-34;
const double _kb = 1.380649e-23;
const double _sun = 1.989e30;
const double _earth = 5.972e24;
const double _au = 1.495978707e11;
const double _ly = 9.4607e15;
const double _year = 3.15576e7;

const List<String> _sup = <String>['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹'];

/// A number like 3.2 × 10⁻⁵; small powers are written out.
String sci(double x, [int digits = 2]) {
  if (x == 0) {
    return '0';
  }
  var e = (math.log(x.abs()) / math.ln10).floor();
  var m = x / math.pow(10, e);
  if (double.parse(m.toStringAsFixed(digits)) >= 10) {
    m /= 10;
    e += 1;
  }
  if (e.abs() < 4) {
    return x.toStringAsFixed(x.abs() >= 100 ? 0 : digits);
  }
  final p = e.abs().toString().split('').map((ch) => _sup[int.parse(ch)]).join();
  return '${m.toStringAsFixed(digits)} × 10${e < 0 ? '⁻' : ''}$p';
}

String _length(BuildContext context, double m) {
  if (m < 1e-3) {
    return '${sci(m, 1)} m';
  }
  if (m < 1) {
    return '${(m * 1000).toStringAsFixed(1)} mm';
  }
  if (m < 1000) {
    return '${m.toStringAsFixed(1)} m';
  }
  if (m < 1e9) {
    return '${(m / 1000).toStringAsFixed(1)} km';
  }
  if (m < 0.1 * _au) {
    return bi(context, '${(m / 1e9).toStringAsFixed(1)} million km', '${(m / 1e9).toStringAsFixed(1)} मिलियन km');
  }
  if (m < 0.1 * _ly) {
    return '${(m / _au).toStringAsFixed(1)} AU';
  }
  return bi(context, '${(m / _ly).toStringAsFixed(2)} light-years', '${(m / _ly).toStringAsFixed(2)} प्रकाश-वर्ष');
}

Widget _stat(Palette p, String value, String label) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: p.surfaceHigh, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: p.text)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12.5, color: p.muted)),
        ],
      ),
    );

/// A labelled drop-down list.
class _Picker extends StatelessWidget {
  const _Picker({required this.value, required this.label, required this.items, required this.onChanged});

  final int value;
  final String label;
  final List<DropdownMenuItem<int>> items;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(value: value, isExpanded: true, items: items, onChanged: onChanged),
      ),
    );
  }
}

Widget _grid(List<Widget> items) => LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth > 520 ? 3 : 2;
      final w = (c.maxWidth - (cols - 1) * 8) / cols;
      return Wrap(spacing: 8, runSpacing: 8, children: <Widget>[for (final i in items) SizedBox(width: w, child: i)]);
    });

TextStyle _h(Palette p, double size) =>
    TextStyle(fontFamily: headingFont, fontSize: size, fontWeight: FontWeight.w700, color: p.text);

// ---------------------------------------------------------------------------
// Telescope and eyepiece simulator

class _Scope {
  const _Scope(this.aperture, this.focal, this.en, this.hi);

  final double aperture;
  final double focal;
  final String en;
  final String hi;
}

const List<_Scope> _scopes = <_Scope>[
  _Scope(70, 700, '70 mm refractor (f/10)', '70 mm refractor (f/10)'),
  _Scope(80, 400, '80 mm short refractor (f/5)', '80 mm छोटा refractor (f/5)'),
  _Scope(114, 900, '114 mm reflector (f/8)', '114 mm reflector (f/8)'),
  _Scope(130, 650, '130 mm reflector (f/5)', '130 mm reflector (f/5)'),
  _Scope(150, 750, '150 mm reflector (f/5)', '150 mm reflector (f/5)'),
  _Scope(203, 1200, '8-inch Dobsonian (f/6)', '8-इंच Dobsonian (f/6)'),
  _Scope(254, 1200, '10-inch Dobsonian (f/4.7)', '10-इंच Dobsonian (f/4.7)'),
  _Scope(90, 1250, '90 mm Maksutov (f/14)', '90 mm Maksutov (f/14)'),
];

const List<(double, double)> _eyepieces = <(double, double)>[(32, 52), (25, 52), (20, 68), (15, 52), (10, 52), (6, 60), (4, 52)];

/// What to look at, with its typical apparent size in arcminutes.
const List<(String, double, String, String)> _targets = <(String, double, String, String)>[
  ('moon', 31, 'The Moon', 'चाँद'),
  ('jupiter', 0.75, 'Jupiter and its moons', 'बृहस्पति और उसके चाँद'),
  ('saturn', 0.7, 'Saturn and its rings', 'शनि और उसके छल्ले'),
  ('mars', 0.25, 'Mars', 'मंगल'),
  ('orion', 65, 'Orion Nebula (M42)', 'ओरायन नीहारिका (M42)'),
  ('pleiades', 110, 'Pleiades (M45)', 'कृत्तिका (M45)'),
  ('andromeda', 190, 'Andromeda Galaxy (M31)', 'एंड्रोमेडा galaxy (M31)'),
];

class TelescopeScreen extends StatefulWidget {
  const TelescopeScreen({super.key});

  @override
  State<TelescopeScreen> createState() => _TelescopeScreenState();
}

class _TelescopeScreenState extends State<TelescopeScreen> {
  int _scope = 2;
  int _eye = 1;
  bool _barlow = false;
  int _target = 0;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final s = _scopes[_scope];
    final e = _eyepieces[_eye];
    final mag = s.focal * (_barlow ? 2 : 1) / e.$1;
    final tfov = e.$2 / mag * 60; // arcminutes
    final exit = s.aperture / mag;
    final maxMag = 2 * s.aperture;
    final lim = 2.7 + 5 * math.log(s.aperture) / math.ln10;
    final res = 116 / s.aperture;
    final t = _targets[_target];
    final fits = t.$2 <= tfov;
    String? warn;
    if (mag > maxMag) {
      warn = bi(context, '⚠️ Too much magnification: above about ${maxMag.round()}× this telescope only shows a bigger blur.',
          '⚠️ बहुत ज़्यादा ज़ूम: लगभग ${maxMag.round()}× से ऊपर यह telescope सिर्फ़ बड़ा धुंधलापन दिखाता है।');
    } else if (exit > 7) {
      warn = bi(context, '⚠️ Exit pupil above 7 mm: some light is wasted. Use a shorter eyepiece.', '⚠️ Exit pupil 7 mm से ज़्यादा: कुछ रोशनी बेकार जाती है। छोटा eyepiece लगाइए।');
    }
    return Scaffold(
      appBar: AppBar(title: Text(bi(context, 'Telescope simulator', 'Telescope simulator'), style: const TextStyle(fontWeight: FontWeight.w700))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: <Widget>[
          _Picker(
            value: _scope,
            label: bi(context, 'Telescope', 'Telescope'),
            items: <DropdownMenuItem<int>>[
              for (final (i, sc) in _scopes.indexed) DropdownMenuItem<int>(value: i, child: Text(bi(context, sc.en, sc.hi))),
            ],
            onChanged: (v) => setState(() => _scope = v ?? _scope),
          ),
          const SizedBox(height: 10),
          _Picker(
            value: _eye,
            label: bi(context, 'Eyepiece', 'Eyepiece'),
            items: <DropdownMenuItem<int>>[
              for (final (i, ep) in _eyepieces.indexed) DropdownMenuItem<int>(value: i, child: Text('${ep.$1.round()} mm (${ep.$2.round()}°)')),
            ],
            onChanged: (v) => setState(() => _eye = v ?? _eye),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(bi(context, '2× Barlow lens', '2× Barlow lens'), style: TextStyle(color: p.text)),
            value: _barlow,
            onChanged: (v) => setState(() => _barlow = v),
          ),
          _Picker(
            value: _target,
            label: bi(context, 'Look at', 'क्या देखें'),
            items: <DropdownMenuItem<int>>[
              for (final (i, tg) in _targets.indexed) DropdownMenuItem<int>(value: i, child: Text(bi(context, tg.$3, tg.$4))),
            ],
            onChanged: (v) => setState(() => _target = v ?? _target),
          ),
          const SizedBox(height: 16),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: EyepiecePainter(target: t.$1, sizeArcmin: t.$2, fieldArcmin: tfov, limit: lim, blur: mag > maxMag ? math.min(8, (mag / maxMag - 1) * 6) : 0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
              fits
                  ? bi(context, '✅ ${t.$3} fits in the view.', '✅ ${t.$4} पूरा दिखता है।')
                  : bi(context, '↔️ ${t.$3} is bigger than the view; you see part of it.', '↔️ ${t.$4} दृश्य से बड़ा है; आपको इसका एक हिस्सा दिखता है।'),
              textAlign: TextAlign.center,
              style: TextStyle(color: p.muted)),
          const SizedBox(height: 12),
          _grid(<Widget>[
            _stat(p, '${mag.round()}×', bi(context, 'Magnification', 'ज़ूम')),
            _stat(p, tfov >= 60 ? '${(tfov / 60).toStringAsFixed(2)}°' : '${tfov.toStringAsFixed(1)}′', bi(context, 'True field of view', 'असली दृश्य-क्षेत्र')),
            _stat(p, '${exit.toStringAsFixed(1)} mm', bi(context, 'Exit pupil', 'Exit pupil')),
            _stat(p, '${maxMag.round()}×', bi(context, 'Highest useful power', 'सबसे ज़्यादा काम का ज़ूम')),
            _stat(p, lim.toStringAsFixed(1), bi(context, 'Faintest star (magnitude)', 'सबसे धुंधला तारा')),
            _stat(p, '${res.toStringAsFixed(2)}″', bi(context, 'Finest detail', 'सबसे बारीक detail')),
          ]),
          if (warn != null) ...<Widget>[
            const SizedBox(height: 10),
            Text(warn, style: TextStyle(color: p.bad)),
          ],
          const SizedBox(height: 14),
          Text(
              bi(context, 'A simplified picture: real views are fainter, and many telescopes show the view upside down. Never point a telescope at the Sun without a proper solar filter.',
                  'यह सरल तस्वीर है: असली नज़ारा कम चमकीला होता है, और कई telescope उल्टा दिखाते हैं। सही solar filter के बिना telescope को कभी सूरज की ओर मत कीजिए।'),
              style: TextStyle(fontSize: 13, height: 1.4, color: p.muted)),
        ],
      ),
    );
  }
}

/// The round view in the eyepiece, with the target drawn to scale.
class EyepiecePainter extends CustomPainter {
  EyepiecePainter({required this.target, required this.sizeArcmin, required this.fieldArcmin, required this.limit, required this.blur});

  final String target;
  final double sizeArcmin;
  final double fieldArcmin;
  final double limit;
  final double blur;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.shortestSide;
    final r = w / 2 - 4;
    final c = Offset(size.width / 2, size.height / 2);
    final k = 2 * r / fieldArcmin; // pixels per arcminute
    canvas.drawCircle(c, r + 3, Paint()..color = const Color(0xFF000000));
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: c, radius: r)));
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF04060C));
    final rnd = math.Random(7);
    final n = math.min(400, (30 * math.pow(10, (limit - 9) * 0.25) * fieldArcmin / 60).round());
    final star = Paint();
    for (var i = 0; i < n; i++) {
      star.color = Color.fromRGBO(220, 228, 255, 0.3 + rnd.nextDouble() * 0.6);
      canvas.drawRect(Rect.fromLTWH(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height, 1.2, 1.2), star);
    }
    final paint = Paint();
    if (blur > 0) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
    }
    final s = sizeArcmin * k / 2;
    switch (target) {
      case 'moon':
        paint.color = const Color(0xFFD9D3BF);
        canvas.drawCircle(c, s, paint);
        final rc = math.Random(3);
        for (var i = 0; i < 70; i++) {
          final a = rc.nextDouble() * 2 * math.pi, d = math.sqrt(rc.nextDouble()) * s * 0.95;
          canvas.drawCircle(c + Offset(math.cos(a) * d, math.sin(a) * d), s * (0.02 + rc.nextDouble() * 0.07),
              Paint()..color = Color.fromRGBO(120, 112, 95, 0.25 + rc.nextDouble() * 0.35));
        }
        canvas.drawPath(
            Path()
              ..addArc(Rect.fromCircle(center: c, radius: s + 1), math.pi / 2, math.pi)
              ..addArc(Rect.fromCenter(center: c, width: s * 0.7, height: 2 * s + 2), -math.pi / 2, math.pi),
            Paint()..color = const Color(0xE004060C));
      case 'jupiter':
        final jr = math.max(1.5, (44 / 60) * k / 2);
        paint.color = const Color(0xFFE8D6B4);
        canvas.drawCircle(c, jr, paint);
        if (jr > 6) {
          final band = Paint()..color = const Color(0x99A06E46);
          canvas.drawRect(Rect.fromLTWH(c.dx - jr, c.dy - jr * 0.28, jr * 2, jr * 0.16), band);
          canvas.drawRect(Rect.fromLTWH(c.dx - jr, c.dy + jr * 0.12, jr * 2, jr * 0.16), band);
        }
        for (final m in <double>[-7.5, -4.4, 3.0, 12.5]) {
          canvas.drawCircle(c + Offset(m * k, 0), math.max(1, jr * 0.07), Paint()..color = const Color(0xFFF4F0E0));
        }
      case 'saturn':
        final sr = math.max(1.2, (18 / 60) * k / 2);
        canvas.save();
        canvas.translate(c.dx, c.dy);
        canvas.rotate(-0.25);
        canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: sr * 4.6, height: sr * 1.5),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = math.max(1, sr * 0.35)
              ..color = const Color(0xFFD8C79D));
        canvas.restore();
        paint.color = const Color(0xFFE6D39F);
        canvas.drawCircle(c, sr, paint);
      case 'mars':
        final mr = math.max(1.2, (15 / 60) * k / 2);
        paint.color = const Color(0xFFD7774A);
        canvas.drawCircle(c, mr, paint);
      case 'orion':
        canvas.drawOval(
            Rect.fromCenter(center: c, width: 2 * s, height: 1.7 * s),
            Paint()
              ..shader = RadialGradient(colors: const <Color>[Color(0xC0AADCC8), Color(0x596EA0AA), Color(0x003C5078)])
                  .createShader(Rect.fromCircle(center: c, radius: s)));
        for (final o in <Offset>[Offset.zero, const Offset(0.024, 0.01), const Offset(-0.016, 0.02), const Offset(0.01, -0.024)]) {
          canvas.drawCircle(c + o * s * 10, 1.4, Paint()..color = const Color(0xFFFFFFFF));
        }
      case 'pleiades':
        const stars = <(double, double, double)>[(0, 0, 2.9), (-0.42, -0.25, 3.6), (0.35, 0.18, 3.7), (-0.15, 0.38, 3.9), (0.55, -0.3, 4.2), (-0.62, 0.15, 4.3), (0.1, -0.5, 5.1), (0.6, 0.45, 5.4)];
        for (final st in stars) {
          canvas.drawCircle(c + Offset(st.$1 * s, st.$2 * s), math.max(1, 3.6 - 0.5 * st.$3), Paint()..color = const Color(0xFFCFE0FF));
        }
      case 'andromeda':
        canvas.save();
        canvas.translate(c.dx, c.dy);
        canvas.rotate(-0.6);
        canvas.scale(1, 0.32);
        canvas.drawCircle(
            Offset.zero,
            s,
            Paint()
              ..shader = RadialGradient(colors: const <Color>[Color(0xD9FFF0D7), Color(0x73E6DCC8), Color(0x00787896)], stops: const <double>[0, 0.15, 1])
                  .createShader(Rect.fromCircle(center: Offset.zero, radius: s)));
        canvas.restore();
    }
    canvas.restore();
    canvas.drawCircle(c, r, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFF3A4560));
  }

  @override
  bool shouldRepaint(EyepiecePainter old) =>
      old.target != target || old.sizeArcmin != sizeArcmin || old.fieldArcmin != fieldArcmin || old.blur != blur || old.limit != limit;
}

// ---------------------------------------------------------------------------
// Black hole lab

/// Horizon radius in metres for [kg] of mass.
double schwarzschildRadius(double kg) => 2 * _g * kg / (_c * _c);

/// Hawking temperature in kelvin.
double hawkingTemperature(double kg) => _hbar * math.pow(_c, 3) / (8 * math.pi * _g * kg * _kb);

/// Time to evaporate by Hawking radiation, in seconds.
double evaporationSeconds(double kg) => 5120 * math.pi * _g * _g * math.pow(kg, 3) / (_hbar * math.pow(_c, 4));

/// How fast a clock hovering at [x] horizon radii runs compared to one far away (0 to 1).
double clockRate(double x) => x <= 1 ? 0 : math.sqrt(1 - 1 / x);

class BlackHoleLabScreen extends StatefulWidget {
  const BlackHoleLabScreen({super.key});

  @override
  State<BlackHoleLabScreen> createState() => _BlackHoleLabScreenState();
}

class _BlackHoleLabScreenState extends State<BlackHoleLabScreen> {
  // lensing
  Offset _lens = const Offset(0.5, 0.5);
  double _lensMass = 0.5;
  // calculator
  final TextEditingController _mass = TextEditingController(text: '1');
  String _unit = 'sun';
  // time dilation
  double _dMass = 10;
  double _logX = 0.477;

  @override
  void dispose() {
    _mass.dispose();
    super.dispose();
  }

  void _preset(double v, String unit) {
    setState(() {
      _mass.text = v == v.roundToDouble() ? v.round().toString() : v.toString();
      _unit = unit;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final v = double.tryParse(_mass.text.replaceAll(',', '')) ?? 0;
    final kg = v * (_unit == 'kg' ? 1 : (_unit == 'earth' ? _earth : _sun));
    final x = math.pow(10, _logX).toDouble();
    final rate = clockRate(x);
    final rsD = schwarzschildRadius(_dMass * _sun);
    return Scaffold(
      appBar: AppBar(title: Text(bi(context, 'Black hole lab', 'ब्लैक होल lab'), style: const TextStyle(fontWeight: FontWeight.w700))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: <Widget>[
          Text(bi(context, '1. Bend the sky', '1. आसमान मोड़िए'), style: _h(p, 20)),
          const SizedBox(height: 6),
          Text(bi(context, 'Drag the black hole over the stars. Its gravity bends their light, making rings and double images (gravitational lensing).', 'ब्लैक होल को तारों पर खींचिए। इसकी gravity उनकी रोशनी मोड़ती है, जिससे छल्ले और दोहरी तस्वीरें बनती हैं (gravitational lensing)।'),
              style: TextStyle(fontSize: 14.5, height: 1.45, color: p.muted)),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: LayoutBuilder(builder: (context, box) {
                return GestureDetector(
                  onPanUpdate: (d) => setState(() {
                    _lens = Offset((_lens.dx + d.delta.dx / box.maxWidth).clamp(0.0, 1.0), (_lens.dy + d.delta.dy / box.maxHeight).clamp(0.0, 1.0));
                  }),
                  onTapDown: (d) => setState(() => _lens = Offset(d.localPosition.dx / box.maxWidth, d.localPosition.dy / box.maxHeight)),
                  child: CustomPaint(size: Size(box.maxWidth, box.maxHeight), painter: LensPainter(lens: _lens, mass: _lensMass)),
                );
              }),
            ),
          ),
          Row(children: <Widget>[
            Text(bi(context, 'Mass', 'द्रव्यमान'), style: TextStyle(color: p.text)),
            Expanded(child: Slider(value: _lensMass, min: 0.15, max: 1, onChanged: (m) => setState(() => _lensMass = m))),
          ]),
          const SizedBox(height: 16),
          Text(bi(context, '2. How big is it?', '2. यह कितना बड़ा है?'), style: _h(p, 20)),
          const SizedBox(height: 8),
          Row(children: <Widget>[
            Expanded(
              child: TextField(
                controller: _mass,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: bi(context, 'Mass', 'द्रव्यमान')),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: _unit,
              items: <DropdownMenuItem<String>>[
                const DropdownMenuItem<String>(value: 'kg', child: Text('kg')),
                DropdownMenuItem<String>(value: 'earth', child: Text(bi(context, 'Earths', 'पृथ्वी'))),
                DropdownMenuItem<String>(value: 'sun', child: Text(bi(context, 'Suns', 'सूरज'))),
              ],
              onChanged: (u) => setState(() => _unit = u ?? _unit),
            ),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
            ActionChip(label: Text(bi(context, 'A person', 'एक इंसान')), onPressed: () => _preset(70, 'kg')),
            ActionChip(label: Text(bi(context, 'Earth', 'पृथ्वी')), onPressed: () => _preset(1, 'earth')),
            ActionChip(label: Text(bi(context, 'The Sun', 'सूरज')), onPressed: () => _preset(1, 'sun')),
            ActionChip(label: const Text('Sagittarius A*'), onPressed: () => _preset(4300000, 'sun')),
            ActionChip(label: const Text('M87*'), onPressed: () => _preset(6500000000, 'sun')),
          ]),
          const SizedBox(height: 10),
          if (kg > 0)
            _grid(<Widget>[
              _stat(p, _length(context, schwarzschildRadius(kg)), bi(context, 'Horizon radius', 'Horizon की त्रिज्या')),
              _stat(p, _length(context, 2 * math.sqrt(27) * _g * kg / (_c * _c)), bi(context, 'Dark shadow width', 'परछाईं की चौड़ाई')),
              _stat(p, '${sci(3 * math.pow(_c, 6) / (32 * math.pi * math.pow(_g, 3) * kg * kg), 1)} kg/m³', bi(context, 'Average density inside', 'अंदर का औसत घनत्व')),
              _stat(p, '${sci(hawkingTemperature(kg), 2)} K', bi(context, 'Hawking temperature', 'Hawking temperature')),
              _stat(p, evaporationSeconds(kg) < _year ? bi(context, '${sci(evaporationSeconds(kg), 1)} s', '${sci(evaporationSeconds(kg), 1)} सेकंड') : bi(context, '${sci(evaporationSeconds(kg) / _year, 1)} years', '${sci(evaporationSeconds(kg) / _year, 1)} साल'),
                  bi(context, 'Time to evaporate', 'ख़त्म होने में समय')),
            ])
          else
            Text(bi(context, 'Enter a mass above zero.', 'शून्य से बड़ा द्रव्यमान लिखिए।'), style: TextStyle(color: p.muted)),
          const SizedBox(height: 20),
          Text(bi(context, '3. Slow down a clock', '3. घड़ी धीमी कीजिए'), style: _h(p, 20)),
          const SizedBox(height: 6),
          Text(bi(context, 'Near a black hole, time runs slower as seen from far away. Move the slider to hover closer.', 'ब्लैक होल के पास, दूर से देखने पर समय धीमा चलता है। पास जाने के लिए slider खिसकाइए।'),
              style: TextStyle(fontSize: 14.5, height: 1.45, color: p.muted)),
          Row(children: <Widget>[
            Text(bi(context, 'Mass: ${_dMass.round()} Suns', 'द्रव्यमान: ${_dMass.round()} सूरज'), style: TextStyle(color: p.text)),
            Expanded(child: Slider(value: math.log(_dMass) / math.ln10, min: 0, max: 10, onChanged: (m) => setState(() => _dMass = math.pow(10, m).toDouble()))),
          ]),
          Row(children: <Widget>[
            Text(bi(context, 'Distance: ${x.toStringAsFixed(x < 10 ? 2 : 0)} × horizon', 'दूरी: ${x.toStringAsFixed(x < 10 ? 2 : 0)} × horizon'), style: TextStyle(color: p.text)),
            Expanded(child: Slider(value: _logX, min: 0.0004, max: 3, onChanged: (m) => setState(() => _logX = m))),
          ]),
          _grid(<Widget>[
            _stat(p, _length(context, rsD * x), bi(context, 'Distance from the centre', 'केंद्र से दूरी')),
            _stat(p, '${(rate * 100).toStringAsFixed(rate > 0.999 ? 4 : 2)}%', bi(context, 'Your clock speed vs far away', 'दूर की घड़ी के मुक़ाबले आपकी घड़ी')),
            _stat(p, rate > 0 ? bi(context, '${(1 / rate).toStringAsFixed(rate < 0.01 ? 0 : 2)} hours', '${(1 / rate).toStringAsFixed(rate < 0.01 ? 0 : 2)} घंटे') : '∞',
                bi(context, '1 hour for you, far away', 'आपका 1 घंटा, दूर की घड़ी में')),
          ]),
          const SizedBox(height: 10),
          Text(
              x < 1.05
                  ? bi(context, 'Almost at the event horizon: seen from far away, your clock has nearly stopped.', 'लगभग event horizon पर: दूर से देखने पर आपकी घड़ी लगभग रुक गई है।')
                  : bi(context, 'Hovering this close needs huge rocket power; falling in is much easier.', 'इतने पास मँडराने के लिए बहुत बड़ी rocket ताक़त चाहिए; गिरना कहीं आसान है।'),
              style: TextStyle(fontSize: 13.5, color: p.muted)),
        ],
      ),
    );
  }
}

/// Stars behind a point-mass lens: each star shows up as two images on either side of the lens.
class LensPainter extends CustomPainter {
  LensPainter({required this.lens, required this.mass});

  /// Lens position, 0 to 1 in each direction.
  final Offset lens;
  final double mass;

  static final List<(double, double, double)> _stars = () {
    final r = math.Random(11);
    return <(double, double, double)>[for (var i = 0; i < 1800; i++) (r.nextDouble(), r.nextDouble(), r.nextDouble())];
  }();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF03050A));
    final l = Offset(lens.dx * size.width, lens.dy * size.height);
    final einstein = size.shortestSide * 0.16 * mass;
    final dot = Paint();
    for (final s in _stars) {
      final src = Offset(s.$1 * size.width, s.$2 * size.height);
      final d = src - l;
      final beta = d.distance;
      final brightness = 0.25 + s.$3 * 0.75;
      if (beta < 0.5) {
        continue;
      }
      final u = d / beta;
      final root = math.sqrt(beta * beta + 4 * einstein * einstein);
      final t1 = (beta + root) / 2, t2 = (beta - root) / 2;
      // magnifications of the two images
      final uu = beta / einstein;
      final m = (uu * uu + 2) / (uu * math.sqrt(uu * uu + 4));
      final a1 = (m + 1) / 2, a2 = (m - 1) / 2;
      dot.color = Color.fromRGBO(225, 232, 255, (brightness * math.min(1, 0.6 + 0.2 * a1)).clamp(0.0, 1.0));
      canvas.drawCircle(l + u * t1, math.min(3.5, 0.7 + 0.5 * a1 * s.$3), dot);
      if (a2 > 0.02) {
        dot.color = Color.fromRGBO(225, 232, 255, (brightness * math.min(1, a2)).clamp(0.0, 1.0));
        canvas.drawCircle(l + u * t2, math.min(3.5, 0.6 + 0.5 * a2 * s.$3), dot);
      }
    }
    // the dark shadow and the ring of light around it
    canvas.drawCircle(l, einstein, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x55FFB45E));
    canvas.drawCircle(l, einstein * 0.42, Paint()..color = const Color(0xFF000000));
  }

  @override
  bool shouldRepaint(LensPainter old) => old.lens != lens || old.mass != mass;
}
