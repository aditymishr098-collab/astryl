import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../core/format.dart';
import '../core/orbits.dart';
import '../core/universe.dart';
import '../data/planets.dart';
import '../l10n/gen/app_localizations.dart';
import '../l10n/names.dart';

/// The Universe map: one 3D space with the planets where they are right now,
/// nearby stars, black holes and thousands of galaxies at their real places.
/// Drag to turn, pinch to zoom from the Solar System out to the edge of the
/// observable universe, tap anything to read about it or fly to it.
class UniverseScreen extends StatefulWidget {
  const UniverseScreen({super.key});

  @override
  State<UniverseScreen> createState() => _UniverseScreenState();
}

const Color _space = Color(0xFF03050A);
const Color _ink = Color(0xFFE8EDF7);
const Color _dim = Color(0xFF9AA6BC);
const Color _panel = Color(0xE6101622);
const Color _line = Color(0xFF263042);
const Color _accent = Color(0xFF8FB4FF);
const Color _hot = Color(0xFFFFB45E);

const double _maxDist = 2.0e11;

/// What the painter and the screen share. It changes all the time, so it is
/// one plain object and the painter is told when to draw again.
class _Scene {
  _Scene(this.universe)
      : galaxies = universe.bodies
            .where((UBody b) => b.kind == UKind.galaxy)
            .toList(growable: false),
        others = universe.bodies
            .where((UBody b) => b.kind != UKind.galaxy)
            .toList(growable: false) {
    focus = universe.sun;
  }

  final Universe universe;
  final List<UBody> galaxies;
  final List<UBody> others;
  final DateTime now = DateTime.now().toUtc();

  late UBody focus;
  UBody? selected;
  double yaw = 0.7;
  double pitch = 0.45;
  double logDist = math.log(levelDistance[ULevel.solarSystem]!) / math.ln10;

  /// Years of map time after [now].
  double years = 0;
  USpeed speed = USpeed.real;

  // A flight to a new focus.
  bool flying = false;
  double flight = 0;
  double flightSeconds = 1.6;
  V3 flyFrom = V3.zero;
  double flyFromLog = 0;
  double flyToLog = 0;
  double flyMidLog = 0;

  // Filled by the painter: what was drawn where, for taps.
  final List<UBody> hitBodies = <UBody>[];
  final List<double> hitX = <double>[];
  final List<double> hitY = <double>[];
  final List<double> hitReach = <double>[];
  Size size = Size.zero;

  bool get freezePlanets => yearsPerSecond(speed) > 50;

  double get dist => math.pow(10, logDist).toDouble();

  V3 positionOf(UBody b) =>
      universe.positionOf(b, now, years, freezePlanets: freezePlanets);

  /// Where the camera looks.
  V3 focusPosition() {
    final to = positionOf(focus);
    if (!flying) {
      return to;
    }
    final t = ((flight - 0.25) / 0.5).clamp(0.0, 1.0).toDouble();
    final s = t * t * (3 - 2 * t);
    return V3.lerp(flyFrom, to, s);
  }

  double minLog(UBody b) {
    double d;
    switch (b.kind) {
      case UKind.sun:
        d = 3e-6;
      case UKind.planet:
        d = 2e-6;
      case UKind.blackHole:
        d = b.radiusLy * 4;
      case UKind.star:
        d = 0.02;
      case UKind.nebula:
      case UKind.starCluster:
        d = 20;
      case UKind.milkyWay:
      case UKind.galaxy:
        d = b.radiusLy * 0.6;
      case UKind.galaxyCluster:
        d = 2e6;
    }
    return math.log(d) / math.ln10;
  }

  /// A good distance to look at [b] from.
  double viewDistance(UBody b) {
    switch (b.kind) {
      case UKind.sun:
        return levelDistance[ULevel.solarSystem]!;
      case UKind.planet:
        return 6e-5;
      case UKind.star:
        return 9;
      case UKind.nebula:
      case UKind.starCluster:
        return 120;
      case UKind.blackHole:
        return b.radiusLy * 12;
      case UKind.milkyWay:
        return levelDistance[ULevel.milkyWay]!;
      case UKind.galaxy:
        return math.max(b.radiusLy * 4.5, 20000.0);
      case UKind.galaxyCluster:
        return 4e7;
    }
  }
}

class _UniverseScreenState extends State<UniverseScreen>
    with SingleTickerProviderStateMixin {
  late final _Scene _scene = _Scene(Universe.load());
  final ValueNotifier<int> _frame = ValueNotifier<int>(0);
  final ValueNotifier<int> _hud = ValueNotifier<int>(0);
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  double _sinceDraw = 0;
  double _sinceHud = 0;
  double _logAtStart = 0;
  bool _still = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _still = MediaQuery.disableAnimationsOf(context);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    _hud.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    final dt = math.min((elapsed - _last).inMicroseconds / 1e6, 0.1);
    _last = elapsed;
    final s = _scene;
    s.years += dt * yearsPerSecond(s.speed);
    var draw = s.speed != USpeed.real;
    if (s.flying) {
      s.flight += dt / s.flightSeconds;
      if (s.flight >= 1) {
        s.flying = false;
        s.logDist = s.flyToLog;
      } else {
        final p = s.flight;
        final e = p * p * (3 - 2 * p);
        final control = 2 * s.flyMidLog - (s.flyFromLog + s.flyToLog) / 2;
        s.logDist = (1 - e) * (1 - e) * s.flyFromLog +
            2 * e * (1 - e) * control +
            e * e * s.flyToLog;
      }
      draw = true;
    }
    _sinceDraw += dt;
    _sinceHud += dt;
    // In real time nothing moves fast enough to need more than a redraw a
    // second.
    if (draw || _sinceDraw >= 1) {
      _sinceDraw = 0;
      _frame.value++;
    }
    if (_sinceHud >= 0.25 && (draw || _sinceHud >= 1)) {
      _sinceHud = 0;
      _hud.value++;
    }
  }

  void _flyTo(UBody body, {double? distance}) {
    final s = _scene;
    final from = s.focusPosition();
    final to = s.positionOf(body);
    final toLog = math.max(
        math.log(distance ?? s.viewDistance(body)) / math.ln10, s.minLog(body));
    s.focus = body;
    if (_still) {
      s.flying = false;
      s.logDist = toLog;
    } else {
      final travel = (to - from).length;
      final high = math.max(s.logDist, toLog);
      var mid = (s.logDist + toLog) / 2;
      if (travel > 0) {
        final travelLog = math.log(travel * 1.3) / math.ln10;
        if (travelLog > high) {
          mid = travelLog;
        }
      }
      s.flyFrom = from;
      s.flyFromLog = s.logDist;
      s.flyToLog = toLog;
      s.flyMidLog = math.min(mid, math.log(_maxDist) / math.ln10);
      s.flight = 0;
      s.flightSeconds = (mid - math.min(s.logDist, toLog)) > 2 ? 2.4 : 1.3;
      s.flying = true;
    }
    _frame.value++;
    _hud.value++;
  }

  void _goLevel(ULevel level) {
    final s = _scene;
    final body = (level == ULevel.milkyWay ||
            level == ULevel.localGroup ||
            level == ULevel.galaxies)
        ? s.universe.milkyWay
        : s.universe.sun;
    _flyTo(body, distance: levelDistance[level]);
  }

  void _onScaleStart(ScaleStartDetails d) {
    final s = _scene;
    if (s.flying) {
      // Taking over: stay where the flight has got to.
      s.flying = false;
    }
    _logAtStart = s.logDist;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    final s = _scene;
    s.yaw -= d.focalPointDelta.dx * 0.008;
    s.pitch =
        (s.pitch + d.focalPointDelta.dy * 0.006).clamp(-1.5, 1.5).toDouble();
    if (d.pointerCount > 1 && d.scale > 0) {
      s.logDist = (_logAtStart - math.log(d.scale) / math.ln10)
          .clamp(s.minLog(s.focus), math.log(_maxDist) / math.ln10)
          .toDouble();
    }
    _frame.value++;
    _hud.value++;
  }

  void _onTapUp(TapUpDetails d) {
    final s = _scene;
    UBody? best;
    var bestScore = double.infinity;
    for (var i = 0; i < s.hitBodies.length; i++) {
      final dx = s.hitX[i] - d.localPosition.dx;
      final dy = s.hitY[i] - d.localPosition.dy;
      final distance = math.sqrt(dx * dx + dy * dy);
      final reach = math.max(s.hitReach[i] + 8, 22.0);
      if (distance > reach) {
        continue;
      }
      // Named things win over the crowd of small galaxies around them.
      final score = distance + s.hitBodies[i].rank * 1.5;
      if (score < bestScore) {
        best = s.hitBodies[i];
        bestScore = score;
      }
    }
    setState(() {
      s.selected = best;
    });
    _frame.value++;
  }

  Future<void> _openGoTo() async {
    final l = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<UBody>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _GoToSheet(
        universe: _scene.universe,
        nameOf: (UBody b) => _nameOf(l, b),
        kindOf: (UBody b) => _kindOf(l, b),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _scene.selected = picked;
      });
      _flyTo(picked);
    }
  }

  void _setSpeed(USpeed speed) {
    setState(() {
      _scene.speed = speed;
    });
    _frame.value++;
  }

  void _backToNow() {
    setState(() {
      _scene.years = 0;
      _scene.speed = USpeed.real;
    });
    _frame.value++;
    _hud.value++;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = _scene;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      backgroundColor: _space,
      appBar: AppBar(
        backgroundColor: _space,
        foregroundColor: _ink,
        title: Text(l.uniTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: <Widget>[
          IconButton(
            tooltip: l.uniGoTo,
            icon: const Icon(Icons.search),
            onPressed: _openGoTo,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            ValueListenableBuilder<int>(
              valueListenable: _hud,
              builder: (BuildContext context, int value, Widget? child) {
                final level = levelFor(s.dist);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: <Widget>[
                      for (final v in ULevel.values) ...<Widget>[
                        _Chip(
                          label: _levelName(l, v),
                          selected: v == level,
                          onTap: () => _goLevel(v),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onScaleStart: _onScaleStart,
                      onScaleUpdate: _onScaleUpdate,
                      onTapUp: _onTapUp,
                      child: RepaintBoundary(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _UniversePainter(
                            scene: s,
                            frame: _frame,
                            nameOf: (UBody b) => _nameOf(l, b),
                            edgeLabel: l.uniEdge,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 8,
                    right: 14,
                    child: IgnorePointer(
                      child: ValueListenableBuilder<int>(
                        valueListenable: _hud,
                        builder: (BuildContext context, int value, Widget? child) {
                          final width = s.size.isEmpty
                              ? s.dist
                              : s.dist *
                                  s.size.width /
                                  (s.size.shortestSide * 0.9);
                          return Text(
                            '${l.uniScreen(_lengthText(l, locale, width))}\n${l.uniHint}',
                            style: const TextStyle(
                                fontSize: 12, color: _dim, height: 1.5),
                          );
                        },
                      ),
                    ),
                  ),
                  if (s.selected != null)
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 8,
                      child: _InfoCard(
                        body: s.selected!,
                        scene: s,
                        name: _nameOf(l, s.selected!),
                        kind: _kindOf(l, s.selected!),
                        isFocus: identical(s.selected, s.focus),
                        onFly: () => _flyTo(s.selected!),
                        onClose: () {
                          setState(() {
                            s.selected = null;
                          });
                          _frame.value++;
                        },
                      ),
                    ),
                ],
              ),
            ),
            _TimeBar(
              scene: s,
              hud: _hud,
              onSpeed: _setSpeed,
              onReset: _backToNow,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Words

String _levelName(AppLocalizations l, ULevel level) {
  switch (level) {
    case ULevel.solarSystem:
      return l.uniLevelSolar;
    case ULevel.stars:
      return l.uniLevelStars;
    case ULevel.milkyWay:
      return l.uniLevelMilkyWay;
    case ULevel.localGroup:
      return l.uniLevelLocal;
    case ULevel.galaxies:
      return l.uniLevelGalaxies;
    case ULevel.universe:
      return l.uniLevelUniverse;
  }
}

String _speedName(AppLocalizations l, USpeed speed) {
  switch (speed) {
    case USpeed.real:
      return l.uniSpeedReal;
    case USpeed.dayPerSecond:
      return l.uniSpeedDay;
    case USpeed.yearPerSecond:
      return l.uniSpeedYear;
    case USpeed.millionPerSecond:
      return l.uniSpeedMillion;
    case USpeed.fastest:
      return l.uniSpeedFast;
  }
}

String _nameOf(AppLocalizations l, UBody b) {
  switch (b.kind) {
    case UKind.sun:
    case UKind.planet:
      return planetName(l, planetById(b.id));
    case UKind.milkyWay:
      return l.uniLevelMilkyWay;
    case UKind.star:
    case UKind.nebula:
    case UKind.starCluster:
    case UKind.blackHole:
    case UKind.galaxy:
    case UKind.galaxyCluster:
      return b.name;
  }
}

String _kindOf(AppLocalizations l, UBody b) {
  switch (b.kind) {
    case UKind.sun:
    case UKind.star:
      return l.uniKindStar;
    case UKind.planet:
      return l.uniKindPlanet;
    case UKind.nebula:
      return l.dsoNebula;
    case UKind.starCluster:
      return l.dsoCluster;
    case UKind.blackHole:
      return l.uniKindBlackHole;
    case UKind.galaxyCluster:
      return l.uniKindGalaxyCluster;
    case UKind.milkyWay:
    case UKind.galaxy:
      switch (b.shape) {
        case GalaxyShape.spiral:
          return l.uniShapeSpiral;
        case GalaxyShape.barred:
          return l.uniShapeBarred;
        case GalaxyShape.elliptical:
          return l.uniShapeElliptical;
        case GalaxyShape.lenticular:
          return l.uniShapeLenticular;
        case GalaxyShape.irregular:
          return l.uniShapeIrregular;
        case GalaxyShape.unknown:
          return l.dsoGalaxy;
      }
  }
}

/// Up to three digits that matter: 4.24, 26.7, 433.
String _short(String locale, double v) {
  final a = v.abs();
  final decimals = a >= 100 ? 0 : (a >= 10 ? 1 : 2);
  return formatNumberFor(locale, v, decimals: decimals);
}

/// A length given in light-years, in the unit that reads best.
String _lengthText(AppLocalizations l, String locale, double ly) {
  if (ly < 0.01) {
    final au = ly * auPerLightYear;
    if (au < 0.01) {
      final km = au * kmPerAu;
      if (km >= 1e6) {
        return l.valueMillionKm(_short(locale, km / 1e6));
      }
      return l.valueKm(formatNumberFor(locale, km, decimals: km < 100 ? 1 : 0));
    }
    return l.valueAu(_short(locale, au));
  }
  if (ly < 1000) {
    return l.uniLy(_short(locale, ly));
  }
  if (ly < 1e6) {
    return l.uniLyK(_short(locale, ly / 1e3));
  }
  if (ly < 1e9) {
    return l.uniLyM(_short(locale, ly / 1e6));
  }
  return l.uniLyB(_short(locale, ly / 1e9));
}

String _yearsText(AppLocalizations l, String locale, double years) {
  if (years < 1) {
    return l.uniDays(_short(locale, years * 365.25));
  }
  if (years < 1000) {
    return l.uniYr(_short(locale, years));
  }
  if (years < 1e6) {
    return l.uniYrK(_short(locale, years / 1e3));
  }
  if (years < 1e9) {
    return l.uniYrM(_short(locale, years / 1e6));
  }
  return l.uniYrB(_short(locale, years / 1e9));
}

String _massText(AppLocalizations l, String locale, double suns) {
  if (suns < 1e6) {
    return l.uniSuns(
        formatNumberFor(locale, suns, decimals: suns < 100 ? 1 : 0));
  }
  if (suns < 1e9) {
    return l.uniSunsM(_short(locale, suns / 1e6));
  }
  return l.uniSunsB(_short(locale, suns / 1e9));
}

String _kmText(AppLocalizations l, String locale, double km) {
  if (km >= 1e9) {
    return l.valueBillionKm(_short(locale, km / 1e9));
  }
  if (km >= 1e6) {
    return l.valueMillionKm(_short(locale, km / 1e6));
  }
  return l.valueKm(formatNumberFor(locale, km, decimals: km < 100 ? 1 : 0));
}

// ---------------------------------------------------------------------------
// Small widgets

class _Chip extends StatelessWidget {
  const _Chip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? _accent.withValues(alpha: 0.18) : _panel,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? _accent : _line),
          ),
          child: ExcludeSemantics(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? _ink : _dim,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeBar extends StatelessWidget {
  const _TimeBar({
    required this.scene,
    required this.hud,
    required this.onSpeed,
    required this.onReset,
  });

  final _Scene scene;
  final ValueNotifier<int> hud;
  final ValueChanged<USpeed> onSpeed;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: <Widget>[
                const Icon(Icons.schedule, size: 16, color: _dim),
                const SizedBox(width: 6),
                Expanded(
                  child: ValueListenableBuilder<int>(
                    valueListenable: hud,
                    builder: (BuildContext context, int value, Widget? child) {
                      final years = scene.years;
                      final text = years < 0.5 / 365.25
                          ? l.uniNow
                          : l.uniAhead(_yearsText(l, locale, years));
                      final note = scene.speed == USpeed.real
                          ? text
                          : '$text · ${l.uniSpedUp}';
                      return Text(note,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: _dim));
                    },
                  ),
                ),
                TextButton(
                  onPressed: onReset,
                  child: Text(l.uniBackToNow),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: <Widget>[
                for (final v in USpeed.values) ...<Widget>[
                  _Chip(
                    label: _speedName(l, v),
                    selected: v == scene.speed,
                    onTap: () => onSpeed(v),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.body,
    required this.scene,
    required this.name,
    required this.kind,
    required this.isFocus,
    required this.onFly,
    required this.onClose,
  });

  final UBody body;
  final _Scene scene;
  final String name;
  final String kind;
  final bool isFocus;
  final VoidCallback onFly;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final rows = <List<String>>[];
    final date = clampOrbitDate(scene.now);
    switch (body.kind) {
      case UKind.sun:
        rows.add(<String>[
          l.uniDistance,
          _kmText(l, locale, distanceFromEarthKm('sun', date)),
        ]);
      case UKind.planet:
        if (body.id != 'earth') {
          rows.add(<String>[
            l.uniDistance,
            _kmText(l, locale, distanceFromEarthKm(body.id, date)),
          ]);
        }
      case UKind.star:
      case UKind.nebula:
      case UKind.starCluster:
      case UKind.galaxyCluster:
        rows.add(<String>[l.uniDistance, _lengthText(l, locale, body.distLy)]);
      case UKind.blackHole:
        _distanceRows(l, locale, rows);
        rows.add(<String>[l.uniMass, _massText(l, locale, body.massSuns)]);
        rows.add(<String>[
          l.uniHorizon,
          _kmText(l, locale, body.massSuns * 2.95),
        ]);
      case UKind.milkyWay:
      case UKind.galaxy:
        _distanceRows(l, locale, rows);
        if (body.kind == UKind.milkyWay || body.radiusLy > 1500) {
          rows.add(<String>[
            l.uniWidth,
            _lengthText(l, locale, body.radiusLy * 2),
          ]);
        }
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 12),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: _ink)),
                      const SizedBox(height: 2),
                      Text(kind,
                          style: const TextStyle(fontSize: 13, color: _accent)),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                icon: const Icon(Icons.close, color: _dim),
                onPressed: onClose,
              ),
            ],
          ),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(row[0],
                        style: const TextStyle(fontSize: 13, color: _dim)),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(row[1],
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _ink)),
                  ),
                ],
              ),
            ),
          if (body.estimated)
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Text(l.uniEstimated,
                  style: const TextStyle(fontSize: 12, color: _dim)),
            ),
          if (!isFocus)
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 8),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onFly,
                  icon: const Icon(Icons.rocket_launch_outlined, size: 18),
                  label: Text(l.uniFlyHere),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _distanceRows(AppLocalizations l, String locale, List<List<String>> rows) {
    if (body.lightYears > 0) {
      rows.add(<String>[
        l.uniLightTime,
        _yearsText(l, locale, body.lightYears),
      ]);
      rows.add(<String>[
        l.uniDistanceNow,
        _lengthText(l, locale, body.distLy),
      ]);
    } else {
      rows.add(<String>[l.uniDistance, _lengthText(l, locale, body.distLy)]);
    }
  }
}

class _GoToSheet extends StatefulWidget {
  const _GoToSheet({
    required this.universe,
    required this.nameOf,
    required this.kindOf,
  });

  final Universe universe;
  final String Function(UBody body) nameOf;
  final String Function(UBody body) kindOf;

  @override
  State<_GoToSheet> createState() => _GoToSheetState();
}

class _GoToSheetState extends State<_GoToSheet> {
  String _query = '';

  IconData _icon(UBody b) {
    switch (b.kind) {
      case UKind.sun:
        return Icons.wb_sunny_outlined;
      case UKind.planet:
        return Icons.public;
      case UKind.star:
        return Icons.star_outline;
      case UKind.nebula:
        return Icons.cloud_outlined;
      case UKind.starCluster:
        return Icons.grain;
      case UKind.blackHole:
        return Icons.radio_button_checked;
      case UKind.milkyWay:
      case UKind.galaxy:
        return Icons.blur_circular;
      case UKind.galaxyCluster:
        return Icons.bubble_chart_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final q = _query.trim().toLowerCase();
    var found = widget.universe.find(q, limit: 400);
    if (q.isNotEmpty) {
      // Translated names (planets, the Milky Way) are searched here.
      final extra = widget.universe.bodies.where((UBody b) =>
          b.rank <= 1 &&
          !found.contains(b) &&
          widget.nameOf(b).toLowerCase().contains(q));
      found = <UBody>[...extra, ...found];
    }
    final height = MediaQuery.sizeOf(context).height * 0.78;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: height,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l.uniSearchHint,
                ),
                onChanged: (String v) {
                  setState(() {
                    _query = v;
                  });
                },
              ),
            ),
            Expanded(
              child: found.isEmpty
                  ? Center(child: Text(l.uniNothing))
                  : ListView.builder(
                      itemCount: found.length,
                      itemBuilder: (BuildContext context, int i) {
                        final b = found[i];
                        return ListTile(
                          leading: Icon(_icon(b)),
                          title: Text(widget.nameOf(b)),
                          subtitle: Text(widget.kindOf(b)),
                          onTap: () => Navigator.of(context).pop(b),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Drawing

class _Label {
  _Label(this.text, this.x, this.y, this.rank, this.near, this.strong);

  final String text;
  final double x;
  final double y;
  final int rank;
  final double near;
  final bool strong;
}

const List<Color> _starTints = <Color>[
  Color(0xFFBFD4FF),
  Color(0xFFF4F6FF),
  Color(0xFFFFF1C4),
  Color(0xFFFFC98A),
  Color(0xFFFF9E80),
];

class _UniversePainter extends CustomPainter {
  _UniversePainter({
    required this.scene,
    required ValueNotifier<int> frame,
    required this.nameOf,
    required this.edgeLabel,
  }) : super(repaint: frame);

  final _Scene scene;
  final String Function(UBody body) nameOf;
  final String edgeLabel;

  static final Map<String, TextPainter> _texts = <String, TextPainter>{};
  static Float32List _buffer = Float32List(8192);
  static final List<Float32List> _cloudBuffers = <Float32List>[
    Float32List(0),
    Float32List(0),
    Float32List(0),
  ];
  static Float64List _cloudA = Float64List(0);
  static Float64List _cloudB = Float64List(0);
  static Float64List _cloudC = Float64List(0);
  static Int8List _cloudGroup = Int8List(0);

  // The camera of this frame.
  late V3 _right;
  late V3 _up;
  late V3 _forward;
  late V3 _focusPos;
  late V3 _back; // from the focus to the camera
  late double _cx;
  late double _cy;
  late double _focal;
  late double _dist;

  // Result of [_project].
  double _sx = 0;
  double _sy = 0;
  double _depth = 0;

  /// Puts a place given from the focus on the screen. False when it is
  /// behind the camera.
  bool _project(double x, double y, double z) {
    final vx = x - _back.x, vy = y - _back.y, vz = z - _back.z;
    final depth = vx * _forward.x + vy * _forward.y + vz * _forward.z;
    if (depth <= _dist * 1e-3) {
      return false;
    }
    _depth = depth;
    _sx = _cx + _focal * (vx * _right.x + vy * _right.y + vz * _right.z) / depth;
    _sy = _cy - _focal * (vx * _up.x + vy * _up.y + vz * _up.z) / depth;
    return true;
  }

  bool _projectAt(V3 p) =>
      _project(p.x - _focusPos.x, p.y - _focusPos.y, p.z - _focusPos.z);

  static void _prepareCloud() {
    if (_cloudA.isNotEmpty) {
      return;
    }
    final cloud = milkyWayCloud();
    final n = cloud.points.length;
    _cloudA = Float64List(n);
    _cloudB = Float64List(n);
    _cloudC = Float64List(n);
    _cloudGroup = Int8List(n);
    final counts = <int>[0, 0, 0];
    for (var i = 0; i < n; i++) {
      final v = cloud.points[i] - galacticCentre;
      _cloudA[i] = v.dot(galacticCentreDir);
      _cloudB[i] = v.dot(galacticSpinDir);
      _cloudC[i] = v.dot(galacticNorth);
      _cloudGroup[i] = cloud.groups[i];
      counts[cloud.groups[i]]++;
    }
    for (var g = 0; g < 3; g++) {
      _cloudBuffers[g] = Float32List(counts[g] * 2);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = scene;
    s.size = size;
    s.hitBodies.clear();
    s.hitX.clear();
    s.hitY.clear();
    s.hitReach.clear();
    canvas.drawRect(Offset.zero & size, Paint()..color = _space);
    if (size.isEmpty) {
      return;
    }
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    _dist = s.dist;
    _cx = size.width / 2;
    _cy = size.height / 2;
    _focal = size.shortestSide * 0.9;
    final cp = math.cos(s.pitch), sp = math.sin(s.pitch);
    final dir = V3(cp * math.cos(s.yaw), cp * math.sin(s.yaw), sp);
    _back = dir * _dist;
    _forward = dir * -1;
    _right = _forward.cross(const V3(0, 0, 1)).unit;
    _up = _right.cross(_forward).unit;
    _focusPos = s.focusPosition();

    final labels = <_Label>[];
    final logD = s.logDist;

    _paintMilkyWay(canvas, size, s);
    _paintGalaxies(canvas, size, s, labels, logD);
    _paintOthers(canvas, size, s, labels);
    _paintEdge(canvas, size, labels);
    _paintLabels(canvas, size, labels);
    canvas.restore();
  }

  void _paintMilkyWay(Canvas canvas, Size size, _Scene s) {
    _prepareCloud();
    final angle = -2 * math.pi * s.years / galacticYear;
    final ca = math.cos(angle), sa = math.sin(angle);
    final g = galacticCentre - _focusPos;
    const e1 = galacticCentreDir, e2 = galacticSpinDir, e3 = galacticNorth;
    final counts = <int>[0, 0, 0];
    final w = size.width, h = size.height;
    for (var i = 0; i < _cloudA.length; i++) {
      final a = _cloudA[i] * ca - _cloudB[i] * sa;
      final b = _cloudA[i] * sa + _cloudB[i] * ca;
      final c = _cloudC[i];
      if (!_project(g.x + e1.x * a + e2.x * b + e3.x * c,
          g.y + e1.y * a + e2.y * b + e3.y * c,
          g.z + e1.z * a + e2.z * b + e3.z * c)) {
        continue;
      }
      if (_sx < -4 || _sy < -4 || _sx > w + 4 || _sy > h + 4) {
        continue;
      }
      final group = _cloudGroup[i];
      final buffer = _cloudBuffers[group];
      final k = counts[group] * 2;
      buffer[k] = _sx;
      buffer[k + 1] = _sy;
      counts[group]++;
    }
    // Seen from far away the whole Galaxy is a few pixels: smaller points.
    final centreVisible = _projectAt(galacticCentre);
    final spread = centreVisible ? _focal * 50000 / _depth : 1000.0;
    final width = spread < 40 ? 1.0 : (spread < 200 ? 1.5 : 2.0);
    final alpha = spread < 12 ? 0.35 : 0.6;
    const colours = <Color>[
      Color(0xFFFFDDA6),
      Color(0xFFA9C6FF),
      Color(0xFFD8DEEC),
    ];
    for (var group = 0; group < 3; group++) {
      if (counts[group] == 0) {
        continue;
      }
      final paint = Paint()
        ..color = colours[group].withValues(alpha: group == 2 ? alpha * 0.6 : alpha)
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round;
      canvas.drawRawPoints(
          ui.PointMode.points,
          Float32List.sublistView(_cloudBuffers[group], 0, counts[group] * 2),
          paint);
    }
  }

  void _paintGalaxies(Canvas canvas, Size size, _Scene s, List<_Label> labels,
      double logD) {
    final list = s.galaxies;
    if (_buffer.length < list.length * 2) {
      _buffer = Float32List(list.length * 2);
    }
    final w = size.width, h = size.height;
    // From inside the Milky Way the far galaxies are a faint background.
    final fade = ((logD - 2.5) / 2.5).clamp(0.3, 1.0).toDouble();
    var count = 0;
    final sprites = <UBody>[];
    final spriteSize = <double>[];
    for (final b in list) {
      final rx = b.base.x - _focusPos.x;
      final ry = b.base.y - _focusPos.y;
      final rz = b.base.z - _focusPos.z;
      if (!_project(rx, ry, rz)) {
        continue;
      }
      if (_sx < -30 || _sy < -30 || _sx > w + 30 || _sy > h + 30) {
        continue;
      }
      final px = _focal * b.radiusLy / _depth;
      final near = math.sqrt(rx * rx + ry * ry + rz * rz) / _dist;
      final chosen = identical(b, s.selected);
      if (px >= 5 && sprites.length < 48) {
        sprites.add(b);
        spriteSize.add(px);
      } else {
        _buffer[count * 2] = _sx;
        _buffer[count * 2 + 1] = _sy;
        count++;
      }
      if (near <= 60 || px >= 1.2 || chosen) {
        s.hitBodies.add(b);
        s.hitX.add(_sx);
        s.hitY.add(_sy);
        s.hitReach.add(math.min(px, 60.0));
      }
      if (chosen) {
        _ring(canvas, _sx, _sy, math.max(px, 6.0) + 5);
      }
      if (chosen ||
          (b.rank <= 4 && near <= 3.2 && (near >= 0.02 || identical(b, s.focus)))) {
        labels.add(_Label(nameOf(b), _sx + math.min(px, 40.0) + 5, _sy, b.rank,
            near, chosen));
      }
    }
    if (count > 0) {
      canvas.drawRawPoints(
          ui.PointMode.points,
          Float32List.sublistView(_buffer, 0, count * 2),
          Paint()
            ..color = const Color(0xFFCBD8F5).withValues(alpha: 0.75 * fade)
            ..strokeWidth = 1.8
            ..strokeCap = StrokeCap.round);
    }
    for (var i = 0; i < sprites.length; i++) {
      _paintSprite(canvas, s, sprites[i], spriteSize[i]);
    }
  }

  void _paintSprite(Canvas canvas, _Scene s, UBody b, double px) {
    final template = galaxyTemplate(b.shape);
    final axes = galaxyAxes(b.base, b.positionAngle, b.axisRatio);
    final major = axes[0], second = axes[1], normal = axes[2];
    final spin = 2 * math.pi * s.years / otherGalaxyTurn;
    final cs = math.cos(spin), sn = math.sin(spin);
    final r = b.radiusLy;
    final gx = b.base.x - _focusPos.x;
    final gy = b.base.y - _focusPos.y;
    final gz = b.base.z - _focusPos.z;
    final n = template.length;
    final points = Float32List(n * 2);
    var count = 0;
    final round = b.shape == GalaxyShape.elliptical;
    for (var i = 0; i < n; i++) {
      final x = (template.x[i] * cs - template.y[i] * sn) * r;
      final y = (template.x[i] * sn + template.y[i] * cs) * r;
      final z = template.z[i] * r * (round ? b.axisRatio.clamp(0.4, 1.0) : 1.0);
      if (!_project(gx + major.x * x + second.x * y + normal.x * z,
          gy + major.y * x + second.y * y + normal.y * z,
          gz + major.z * x + second.z * y + normal.z * z)) {
        continue;
      }
      points[count * 2] = _sx;
      points[count * 2 + 1] = _sy;
      count++;
    }
    if (count == 0) {
      return;
    }
    final warm = b.shape == GalaxyShape.elliptical ||
        b.shape == GalaxyShape.lenticular;
    canvas.drawRawPoints(
        ui.PointMode.points,
        Float32List.sublistView(points, 0, count * 2),
        Paint()
          ..color = (warm ? const Color(0xFFFFE3B5) : const Color(0xFFC4D6FF))
              .withValues(alpha: 0.8)
          ..strokeWidth = (px / 28).clamp(1.3, 3.2).toDouble()
          ..strokeCap = StrokeCap.round);
  }

  void _ring(Canvas canvas, double x, double y, double radius) {
    canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = _accent);
  }

  void _paintOthers(
      Canvas canvas, Size size, _Scene s, List<_Label> labels) {
    final w = size.width, h = size.height;
    final sunPos = s.positionOf(s.universe.sun);
    final showPlanets = _dist < 0.02;

    if (showPlanets) {
      final line = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFF5E7299).withValues(alpha: 0.7);
      for (final b in s.others) {
        if (b.kind != UKind.planet) {
          continue;
        }
        final orbit = _orbits.putIfAbsent(
            b.id, () => orbitLine(b.id, b.yearDays, s.now));
        final path = Path();
        var started = false;
        var whole = true;
        for (final p in orbit) {
          if (!_projectAt(sunPos + p)) {
            whole = false;
            started = false;
            continue;
          }
          if (started) {
            path.lineTo(_sx, _sy);
          } else {
            path.moveTo(_sx, _sy);
            started = true;
          }
        }
        if (whole) {
          path.close();
        }
        canvas.drawPath(path, line);
      }
    }

    for (final b in s.others) {
      final isFocus = identical(b, s.focus);
      final chosen = identical(b, s.selected);
      if (b.kind == UKind.planet && !showPlanets) {
        continue;
      }
      if (b.kind == UKind.milkyWay) {
        // Drawn as the cloud; here only its name and its tap spot.
        if (_dist < 20000 || !_projectAt(galacticCentre)) {
          continue;
        }
        final px = _focal * b.radiusLy / _depth;
        s.hitBodies.add(b);
        s.hitX.add(_sx);
        s.hitY.add(_sy);
        s.hitReach.add(math.min(px * 0.6, 50.0));
        if (chosen) {
          _ring(canvas, _sx, _sy, math.max(px, 6.0) + 5);
        }
        labels.add(
            _Label(nameOf(b), _sx + math.min(px, 30.0) + 6, _sy, 0, 0, chosen));
        continue;
      }
      final p = s.positionOf(b);
      final rx = p.x - _focusPos.x, ry = p.y - _focusPos.y, rz = p.z - _focusPos.z;
      if (!_project(rx, ry, rz)) {
        continue;
      }
      if (_sx < -40 || _sy < -40 || _sx > w + 40 || _sy > h + 40) {
        continue;
      }
      final near = math.sqrt(rx * rx + ry * ry + rz * rz) / _dist;
      final px = _focal * b.radiusLy / _depth;
      final x = _sx, y = _sy;
      var radius = 2.0;
      var tappable = true;
      var wantsLabel = near <= 3.2 && (near >= 0.02 || isFocus);

      switch (b.kind) {
        case UKind.sun:
          if (_dist > 3000 && !isFocus && !chosen) {
            continue;
          }
          radius = math.max(px, _dist < 0.02 ? 5.0 : 2.6);
          canvas.drawCircle(
              Offset(x, y),
              radius * 2.4,
              Paint()
                ..color = const Color(0xFFFFD27A).withValues(alpha: 0.18));
          canvas.drawCircle(
              Offset(x, y), radius, Paint()..color = const Color(0xFFFFE9A8));
          wantsLabel = _dist < 3000;
        case UKind.planet:
          radius = 3.2;
          canvas.drawCircle(Offset(x, y), radius,
              Paint()..color = planetById(b.id).color);
          wantsLabel = true;
        case UKind.star:
        case UKind.nebula:
        case UKind.starCluster:
          if (_dist > 250000 && !isFocus && !chosen) {
            continue;
          }
          final close = near <= 40;
          radius = close ? 2.4 : 1.3;
          final colour = _starTints[b.tint.clamp(0, 4).toInt()];
          if (b.kind != UKind.star && close) {
            canvas.drawCircle(Offset(x, y), math.max(px, 5.0),
                Paint()..color = colour.withValues(alpha: 0.16));
          }
          canvas.drawCircle(Offset(x, y), radius,
              Paint()..color = colour.withValues(alpha: close ? 1.0 : 0.55));
          tappable = close || chosen;
        case UKind.blackHole:
          // Shown at the zoom where it belongs: Milky Way ones inside the
          // Galaxy, giants near their galaxy, far quasars on the big map.
          final inView = b.inMilkyWay
              ? _dist <= 400000
              : ((b.lightYears > 0 && _dist > 1e9) || _dist < 2e7);
          final far = near > 60 || !inView;
          if (far && !isFocus && !chosen) {
            continue;
          }
          if (px > 3.5) {
            // Close enough to see the real size of the horizon.
            canvas.drawCircle(
                Offset(x, y),
                px * 2.6,
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = math.max(px * 0.5, 1.5)
                  ..color = _hot.withValues(alpha: 0.5));
            canvas.drawCircle(
                Offset(x, y), px, Paint()..color = const Color(0xFF000000));
            canvas.drawCircle(
                Offset(x, y),
                px,
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.2
                  ..color = _hot);
            radius = px;
          } else {
            radius = 3.4;
            canvas.drawCircle(
                Offset(x, y), radius, Paint()..color = const Color(0xFF000000));
            canvas.drawCircle(
                Offset(x, y),
                radius,
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.4
                  ..color = _hot);
          }
          wantsLabel = wantsLabel && near <= 2.2;
        case UKind.galaxyCluster:
          if (near > 12 || _dist < 2e6) {
            continue;
          }
          radius = math.max(px, 6.0);
          canvas.drawCircle(
              Offset(x, y),
              radius,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = _dim.withValues(alpha: 0.35));
          radius = math.min(radius, 26.0);
        case UKind.milkyWay:
        case UKind.galaxy:
          break;
      }

      if (tappable) {
        s.hitBodies.add(b);
        s.hitX.add(x);
        s.hitY.add(y);
        s.hitReach.add(math.min(radius, 40.0));
      }
      if (chosen) {
        _ring(canvas, x, y, math.min(radius, 200.0) + 5);
      }
      if (chosen || wantsLabel) {
        labels.add(_Label(
            nameOf(b), x + math.min(radius, 40.0) + 5, y, b.rank, near, chosen));
      }
    }
  }

  static final Map<String, List<V3>> _orbits = <String, List<V3>>{};

  void _paintEdge(Canvas canvas, Size size, List<_Label> labels) {
    if (_dist < 3e9) {
      return;
    }
    // The observable universe is a ball around us.
    final toCentre = V3.zero - (_focusPos + _back);
    final d = toCentre.length;
    if (d <= observableRadiusLy * 1.02 || !_projectAt(V3.zero)) {
      return;
    }
    final radius = _focal *
        observableRadiusLy /
        math.sqrt(d * d - observableRadiusLy * observableRadiusLy);
    canvas.drawCircle(
        Offset(_sx, _sy),
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = _accent.withValues(alpha: 0.55));
    labels.add(_Label(edgeLabel, _sx - 90, _sy - radius - 16, 0, 0, false));
  }

  TextPainter _text(String text, bool strong) {
    final key = strong ? '*$text' : text;
    final cached = _texts[key];
    if (cached != null) {
      return cached;
    }
    if (_texts.length > 400) {
      for (final t in _texts.values) {
        t.dispose();
      }
      _texts.clear();
    }
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
          color: strong ? _ink : _ink.withValues(alpha: 0.82),
          shadows: const <Shadow>[Shadow(color: _space, blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: 220);
    _texts[key] = painter;
    return painter;
  }

  void _paintLabels(Canvas canvas, Size size, List<_Label> labels) {
    labels.sort((_Label a, _Label b) {
      if (a.strong != b.strong) {
        return a.strong ? -1 : 1;
      }
      if (a.rank != b.rank) {
        return a.rank.compareTo(b.rank);
      }
      return a.near.compareTo(b.near);
    });
    final taken = <Rect>[];
    for (final label in labels) {
      if (taken.length >= 16) {
        break;
      }
      final painter = _text(label.text, label.strong);
      var x = label.x;
      if (x + painter.width > size.width - 4) {
        x = size.width - 4 - painter.width;
      }
      if (x < 4) {
        x = 4;
      }
      final y = (label.y - painter.height / 2)
          .clamp(4.0, math.max(4.0, size.height - painter.height - 4))
          .toDouble();
      final rect = Rect.fromLTWH(x, y, painter.width, painter.height).inflate(3);
      var free = true;
      for (final other in taken) {
        if (other.overlaps(rect)) {
          free = false;
          break;
        }
      }
      if (!free && !label.strong) {
        continue;
      }
      taken.add(rect);
      painter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(_UniversePainter oldDelegate) => true;
}
