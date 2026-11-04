import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/sky.dart';
import '../core/starmap.dart';
import '../data/cities.dart';
import '../data/planets.dart';
import '../data/sky_catalog.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'binocular_screen.dart';

/// What is selected on the map.
enum _Kind { star, constellation, body, deepSky }

class _Pick {
  const _Pick(this.kind, this.index, [this.id = '']);

  final _Kind kind;

  /// Index into the star or constellation list.
  final int index;

  /// Body id for the Sun, the Moon and the planets.
  final String id;

  @override
  bool operator ==(Object other) =>
      other is _Pick &&
      other.kind == kind &&
      other.index == index &&
      other.id == id;

  @override
  int get hashCode => Object.hash(kind, index, id);
}

/// The sky above the chosen city, with stars, constellations, the Moon and
/// the planets. Drag to look around, pinch to zoom, tap to learn.
class StarMapScreen extends StatefulWidget {
  const StarMapScreen({super.key, this.focus, this.initialTime});

  /// An object to show when the map opens, from the binocular guide.
  final DeepSkyData? focus;

  /// The moment the map opens at. Now if null.
  final DateTime? initialTime;

  @override
  State<StarMapScreen> createState() => _StarMapScreenState();
}

class _StarMapScreenState extends State<StarMapScreen> {
  late DateTime _time;
  SkyFrame? _frame;
  String _frameKey = '';

  double _centerAz = 180;
  double _centerAlt = 45;
  double _fov = 100;
  bool _placed = false;

  bool _showStars = true;
  bool _showLines = true;
  bool _showBodies = true;

  _Pick? _selected;

  double _startFov = 100;
  Offset _lastFocal = Offset.zero;
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _time = widget.initialTime ?? DateTime.now();
  }

  void _ensureFrame(City city) {
    final key = '${city.id}-${_time.millisecondsSinceEpoch ~/ 60000}';
    if (key == _frameKey) {
      return;
    }
    _frameKey = key;
    _frame = SkyFrame.at(_time, city.lat, city.lon);
    if (!_placed) {
      _placed = true;
      _centerAz = city.lat >= 0 ? 180 : 0;
      final f = widget.focus;
      if (f != null) {
        final h = _focusPosition(f);
        _selected = const _Pick(_Kind.deepSky, 0);
        _centerAz = h.azimuth;
        _centerAlt = h.altitude.clamp(10.0, 80.0).toDouble();
        _fov = 60;
      }
    }
  }

  Horizontal _focusPosition(DeepSkyData d) {
    final city = cityById(AppScope.read(context).settings.cityId)!;
    final eq = precessFromJ2000(Equatorial(d.ra, d.dec), _time);
    return toHorizontal(eq, _time, city.lat, city.lon);
  }

  void _shiftTime(Duration d) {
    setState(() => _time = _time.add(d));
  }

  void _centerOn(Horizontal h) {
    setState(() {
      _centerAz = h.azimuth;
      _centerAlt = h.altitude.clamp(5.0, 85.0).toDouble();
      if (_fov > 70) {
        _fov = 70;
      }
    });
  }

  void _onScaleStart(ScaleStartDetails d) {
    _startFov = _fov;
    _lastFocal = d.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    final delta = d.focalPoint - _lastFocal;
    _lastFocal = d.focalPoint;
    final w = _size.width == 0 ? 360.0 : _size.width;
    final perPixel = _fov / w;
    setState(() {
      _fov = (_startFov / d.scale).clamp(20.0, 120.0).toDouble();
      final cosAlt = math.max(0.35, math.cos(_centerAlt * math.pi / 180));
      _centerAz = (_centerAz - delta.dx * perPixel / cosAlt) % 360;
      if (_centerAz < 0) _centerAz += 360;
      _centerAlt =
          (_centerAlt + delta.dy * perPixel).clamp(-10.0, 90.0).toDouble();
    });
  }

  SkyView get _view => SkyView(
        centerAz: _centerAz,
        centerAlt: _centerAlt,
        fov: _fov,
        width: _size.width,
        height: _size.height,
      );

  /// The object closest to a tap, if any is near enough.
  _Pick? _pickAt(Offset tap) {
    final frame = _frame;
    if (frame == null) {
      return null;
    }
    final view = _view;
    double best = 1e9;
    _Pick? pick;

    void consider(Offset? o, double reach, _Pick p, {double bias = 0}) {
      if (o == null) {
        return;
      }
      final d = (o - tap).distance - bias;
      if (d < reach && d < best) {
        best = d;
        pick = p;
      }
    }

    final focus = widget.focus;
    if (focus != null) {
      consider(view.project(_focusPosition(focus)), 28,
          const _Pick(_Kind.deepSky, 0),
          bias: 6);
    }
    if (_showBodies) {
      frame.bodies.forEach((id, h) {
        if (h.altitude > -1) {
          consider(view.project(h), 26, _Pick(_Kind.body, 0, id), bias: 8);
        }
      });
    }
    if (_showStars) {
      for (var i = 0; i < catalogStars.length; i++) {
        final h = frame.stars[i];
        if (h.altitude < 0) {
          continue;
        }
        // Brighter stars are easier to hit.
        consider(view.project(h), 20, _Pick(_Kind.star, i),
            bias: (3 - catalogStars[i].mag).clamp(0.0, 4.5).toDouble() * 2);
      }
    }
    if (pick == null && _showLines) {
      for (var i = 0; i < catalogConstellations.length; i++) {
        if (frame.centres[i].altitude < -5) {
          continue;
        }
        consider(view.project(frame.centres[i]), 60, _Pick(_Kind.constellation, i));
      }
    }
    return pick;
  }

  void _openList(String lang) {
    final frame = _frame;
    final l = context.l10n;
    final p = Palette.of(context);
    final order = List<int>.generate(catalogConstellations.length, (i) => i)
      ..sort((a, b) => catalogConstellations[a]
          .nameFor(lang)
          .compareTo(catalogConstellations[b].nameFor(lang)));
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) => SizedBox(
        height: MediaQuery.sizeOf(sheet).height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(l.constellationsList,
                  style: headingStyle(20, p.text)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: order.length,
                itemBuilder: (context, k) {
                  final i = order[k];
                  final c = catalogConstellations[i];
                  final up = frame != null && frame.centres[i].altitude > 0;
                  final shown = c.nameFor(lang);
                  return ListTile(
                    title: Text(shown),
                    subtitle: shown == c.latin ? null : Text(c.latin),
                    trailing: Icon(
                      up ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                      color: up ? p.accentText : p.muted,
                    ),
                    onTap: () {
                      Navigator.of(sheet).pop();
                      setState(() => _selected = _Pick(_Kind.constellation, i));
                      if (frame != null) {
                        _centerOn(frame.centres[i]);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final city = cityById(AppScope.of(context).settings.cityId);

    final actions = <Widget>[
      IconButton(
        tooltip: l.constellationsList,
        icon: const Icon(Icons.list_alt_outlined),
        onPressed: city == null ? null : () => _openList(lang),
      ),
      IconButton(
        tooltip: l.binocularsTitle,
        icon: const Icon(Icons.zoom_in_map_outlined),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const BinocularScreen(),
        )),
      ),
    ];

    if (city == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.starMapTitle), actions: actions),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(l.chooseCityHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: p.text, height: 1.4)),
          ),
        ),
      );
    }

    _ensureFrame(city);
    final frame = _frame!;
    final loc = MaterialLocalizations.of(context);
    final cardinal = <String>[l.dirN, l.dirE, l.dirS, l.dirW];
    final bodyNames = <String, String>{
      for (final id in frame.bodies.keys) id: planetName(l, planetById(id)),
    };

    return Scaffold(
      appBar: AppBar(title: Text(l.starMapTitle), actions: actions),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ClipRect(
              child: LayoutBuilder(
                builder: (context, box) {
                  _size = Size(box.maxWidth, box.maxHeight);
                  final view = _view;
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onScaleStart: _onScaleStart,
                          onScaleUpdate: _onScaleUpdate,
                          onTapUp: (d) {
                            final hit = _pickAt(d.localPosition);
                            setState(() => _selected = hit);
                          },
                          child: CustomPaint(
                            painter: _SkyPainter(
                              frame: frame,
                              view: view,
                              showStars: _showStars,
                              showLines: _showLines,
                              showBodies: _showBodies,
                              language: lang,
                              cardinal: cardinal,
                              bodyNames: bodyNames,
                              selected: _selected,
                              focus: widget.focus,
                              focusAt: widget.focus == null
                                  ? null
                                  : _focusPosition(widget.focus!),
                            ),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        top: 10,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: <Widget>[
                            _MapChip(
                              label: l.starsLabel,
                              on: _showStars,
                              onTap: () =>
                                  setState(() => _showStars = !_showStars),
                            ),
                            _MapChip(
                              label: l.constellationsLabel,
                              on: _showLines,
                              onTap: () =>
                                  setState(() => _showLines = !_showLines),
                            ),
                            _MapChip(
                              label: l.planetsTitle,
                              on: _showBodies,
                              onTap: () =>
                                  setState(() => _showBodies = !_showBodies),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 10,
                        child: _selected == null
                            ? Text(
                                l.starMapHint,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF9AA6C4)),
                              )
                            : _InfoCard(
                                pick: _selected!,
                                frame: frame,
                                language: lang,
                                focus: widget.focus,
                                focusAt: widget.focus == null
                                    ? null
                                    : _focusPosition(widget.focus!),
                                onFind: _centerOn,
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: p.background,
              border: Border(top: BorderSide(color: p.border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: <Widget>[
                IconButton(
                  tooltip: l.previousDay,
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _shiftTime(const Duration(hours: -1)),
                ),
                Expanded(
                  child: Text(
                    '${loc.formatMediumDate(_time)} · '
                    '${loc.formatTimeOfDay(TimeOfDay.fromDateTime(_time))}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: p.text),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _time = DateTime.now()),
                  child: Text(l.starMapNow),
                ),
                IconButton(
                  tooltip: l.nextDay,
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _shiftTime(const Duration(hours: 1)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapChip extends StatelessWidget {
  const _MapChip(
      {required this.label, required this.on, required this.onTap});

  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      button: true,
      selected: on,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: on ? p.accent : const Color(0xCC141B33),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: on ? p.accent : const Color(0xFF2A3458)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: on ? FontWeight.w700 : FontWeight.w500,
              color: on ? const Color(0xFF0B1020) : const Color(0xFFC9D2EA),
            ),
          ),
        ),
      ),
    );
  }
}

/// The card at the bottom of the map for the selected object.
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.pick,
    required this.frame,
    required this.language,
    required this.onFind,
    this.focus,
    this.focusAt,
  });

  final _Pick pick;
  final SkyFrame frame;
  final String language;
  final DeepSkyData? focus;
  final Horizontal? focusAt;
  final ValueChanged<Horizontal> onFind;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const text = Color(0xFFE8ECF8);
    const muted = Color(0xFFC9D2EA);
    final p = Palette.of(context);

    late final String title;
    String? subtitle;
    String? body;
    late final Horizontal where;
    switch (pick.kind) {
      case _Kind.star:
        final s = catalogStars[pick.index];
        title = s.name.isEmpty ? l.starUnnamed : s.name;
        subtitle = l.magnitudeValue(
            formatNumber(context, s.mag, decimals: 1));
        where = frame.stars[pick.index];
      case _Kind.constellation:
        final c = catalogConstellations[pick.index];
        title = c.nameFor(language);
        subtitle = title == c.latin ? null : c.latin;
        body = constellationStory(l, c.id);
        where = frame.centres[pick.index];
      case _Kind.body:
        title = planetName(l, planetById(pick.id));
        where = frame.bodies[pick.id]!;
      case _Kind.deepSky:
        final d = focus!;
        title = d.name == d.id ? d.id : '${d.name} (${d.id})';
        subtitle = l.magnitudeValue(formatNumber(context, d.mag, decimals: 1));
        where = focusAt!;
    }
    final up = where.altitude > 0;
    final dir = directionName(l, compassIndex(where.azimuth));
    final position = up
        ? l.altitudeDir(dir, formatNumber(context, where.altitude.round()))
        : l.starBelowHorizon;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xF2101831),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A3458)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(title,
                    style: headingStyle(20, text)),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: p.accent),
                onPressed: () => onFind(where),
                icon: const Icon(Icons.my_location_outlined, size: 18),
                label: Text(l.starMapFind,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          if (subtitle != null)
            Text(subtitle,
                style: const TextStyle(fontSize: 13, color: muted)),
          const SizedBox(height: 4),
          Text(position,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: up ? p.accent : muted)),
          if (body != null) ...<Widget>[
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.22),
              child: SingleChildScrollView(
                child: Text(body,
                    style: const TextStyle(
                        fontSize: 14, height: 1.4, color: muted)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Draws the sky.
class _SkyPainter extends CustomPainter {
  _SkyPainter({
    required this.frame,
    required this.view,
    required this.showStars,
    required this.showLines,
    required this.showBodies,
    required this.language,
    required this.cardinal,
    required this.bodyNames,
    required this.selected,
    required this.focus,
    required this.focusAt,
  });

  final SkyFrame frame;
  final SkyView view;
  final bool showStars;
  final bool showLines;
  final bool showBodies;
  final String language;
  final List<String> cardinal;
  final Map<String, String> bodyNames;
  final _Pick? selected;
  final DeepSkyData? focus;
  final Horizontal? focusAt;

  static const Color _amber = Color(0xFFF5A524);

  /// Laid-out names, kept between frames: shaping text is the most costly
  /// part of drawing the map, and the same names come back every frame.
  static final Map<String, TextPainter> _labels = <String, TextPainter>{};

  void _label(Canvas canvas, String text, Offset at,
      {double size = 11,
      Color color = const Color(0xFFC9D2EA),
      FontWeight weight = FontWeight.w500,
      bool centered = false,
      double spacing = 0}) {
    final key = '$size|${color.toARGB32()}|${weight.value}|$spacing|$text';
    var tp = _labels[key];
    if (tp == null) {
      if (_labels.length > 500) {
        _labels.clear();
      }
      tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: bodyFont,
            fontSize: size,
            color: color,
            fontWeight: weight,
            letterSpacing: spacing,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      _labels[key] = tp;
    }
    tp.paint(canvas, centered ? at - Offset(tp.width / 2, tp.height / 2) : at);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFF060914), Color(0xFF0D1530)],
        ).createShader(rect),
    );
    final bounds = rect.inflate(12);

    // Horizon and the four main directions.
    final horizon = Path();
    var started = false;
    for (var az = 0; az <= 360; az += 3) {
      final o = view.project(Horizontal(0, az.toDouble()));
      if (o == null) {
        started = false;
        continue;
      }
      if (started) {
        horizon.lineTo(o.dx, o.dy);
      } else {
        horizon.moveTo(o.dx, o.dy);
        started = true;
      }
    }
    canvas.drawPath(
      horizon,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = const Color(0xFF3A4672),
    );
    for (var i = 0; i < 4; i++) {
      final o = view.project(Horizontal(0, i * 90.0));
      if (o != null && bounds.contains(o)) {
        _label(canvas, cardinal[i], o + const Offset(0, 14),
            size: 13,
            color: i == 2 ? _amber : const Color(0xFF9AA6C4),
            weight: FontWeight.w700,
            centered: true);
      }
    }

    // Constellation figures.
    if (showLines) {
      final base = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round
        ..color = const Color(0x667AA2FF);
      final strong = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xCCF5A524);
      for (var i = 0; i < catalogConstellations.length; i++) {
        final isSel =
            selected?.kind == _Kind.constellation && selected?.index == i;
        for (final line in frame.lines[i]) {
          Offset? prev;
          for (final h in line) {
            final o = h.altitude > -3 ? view.project(h) : null;
            if (o != null && prev != null) {
              canvas.drawLine(prev, o, isSel ? strong : base);
            }
            prev = o;
          }
        }
      }
    }

    // Stars.
    if (showStars) {
      final zoom =
          math.pow((100 / view.fov).clamp(0.7, 2.4), 0.5).toDouble();
      final dot = Paint();
      for (var i = 0; i < catalogStars.length; i++) {
        final h = frame.stars[i];
        if (h.altitude < 0) {
          continue;
        }
        final o = view.project(h);
        if (o == null || !bounds.contains(o)) {
          continue;
        }
        final s = catalogStars[i];
        final r = starRadius(s.mag) * zoom;
        dot.color = Color.fromARGB(
            (150 + 105 * (1 - (s.mag + 1.5) / 6.1)).clamp(120, 255).round(),
            232,
            238,
            255);
        canvas.drawCircle(o, r, dot);
        if (s.mag < 1.2) {
          canvas.drawCircle(
              o, r * 2.2, Paint()..color = const Color(0x22BFD8FF));
        }
        if (selected?.kind == _Kind.star && selected?.index == i) {
          canvas.drawCircle(
              o,
              r + 9,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = _amber);
        }
        if (s.name.isNotEmpty && (s.mag <= 2.3 || (view.fov < 70 && s.mag <= 3.4))) {
          _label(canvas, s.name, o + Offset(r + 4, -6));
        }
      }
    }

    // Constellation names.
    if (showLines) {
      for (var i = 0; i < catalogConstellations.length; i++) {
        final h = frame.centres[i];
        if (h.altitude < 3) {
          continue;
        }
        final o = view.project(h);
        if (o == null || !bounds.contains(o)) {
          continue;
        }
        final isSel =
            selected?.kind == _Kind.constellation && selected?.index == i;
        _label(canvas, catalogConstellations[i].nameFor(language), o,
            size: 12,
            color: isSel ? _amber : const Color(0xFF9AA6C4),
            weight: FontWeight.w700,
            centered: true,
            spacing: 1.2);
      }
    }

    // Sun, Moon and planets.
    if (showBodies) {
      frame.bodies.forEach((id, h) {
        if (h.altitude < -1) {
          return;
        }
        final o = view.project(h);
        if (o == null || !bounds.contains(o)) {
          return;
        }
        final Color color;
        double r;
        switch (id) {
          case 'sun':
            color = _amber;
            r = 9;
            canvas.drawCircle(o, 22, Paint()..color = const Color(0x33F5A524));
          case 'moon':
            color = const Color(0xFFE6E8EE);
            r = 8;
          default:
            color = planetById(id).color;
            r = 4.8;
        }
        canvas.drawCircle(o, r, Paint()..color = color);
        _label(canvas, bodyNames[id] ?? id, o + Offset(r + 4, -7),
            size: 12, color: const Color(0xFFE8ECF8), weight: FontWeight.w700);
        if (selected?.kind == _Kind.body && selected?.id == id) {
          canvas.drawCircle(
              o,
              r + 9,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = _amber);
        }
      });
    }

    // The object chosen in the binocular guide.
    final f = focus, fa = focusAt;
    if (f != null && fa != null && fa.altitude > -2) {
      final o = view.project(fa);
      if (o != null && bounds.contains(o)) {
        canvas.drawCircle(
            o,
            14,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = _amber);
        _label(canvas, f.name, o + const Offset(18, -7),
            size: 12, color: _amber, weight: FontWeight.w700);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SkyPainter oldDelegate) => true;
}
