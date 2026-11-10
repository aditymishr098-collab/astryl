import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../core/orbits.dart';
import '../data/planets.dart';
import '../data/sky_catalog.dart';
import '../theme.dart';
import 'common.dart';
import 'globe_view.dart';

/// The Sun, the planets and Pluto, in the order the Space view knows them.
final List<Planet> spaceBodies = <Planet>[
  planetById('sun'),
  ...planets,
  planetById('pluto'),
];

/// Distance from the Sun of each orbit in the scene, Mercury to Pluto. Not to
/// scale: the real gaps would leave the inner planets invisible.
const List<double> _orbitRadii = <double>[
  50, 85, 120, 155, 215, 290, 360, 425, 480, //
];

Planet? _bodyById(String id) {
  for (final body in allBodies) {
    if (body.id == id) {
      return body;
    }
  }
  return null;
}

const double _sunRadius = 26;

/// How far the camera sits when the whole Solar System is in view.
const double _overviewDistance = 1150;

double _orbitRadius(Planet p) => _orbitRadii[(p.order - 1).clamp(0, 8)];

/// Radius of a body in the scene. Sizes are squeezed (square root), so Jupiter
/// is bigger than Earth but not a hundred times.
double _bodyRadius(Planet p) {
  if (p.id == 'sun') {
    return _sunRadius;
  }
  if (p.isMoon) {
    return 1.3;
  }
  return 2.2 * (1.5 + 3.2 * math.sqrt(p.diameterKm / 12756));
}

class _V3 {
  const _V3(this.x, this.y, this.z);

  static const _V3 zero = _V3(0, 0, 0);

  final double x, y, z;

  _V3 operator +(_V3 o) => _V3(x + o.x, y + o.y, z + o.z);
  _V3 operator -(_V3 o) => _V3(x - o.x, y - o.y, z - o.z);
  _V3 operator *(double k) => _V3(x * k, y * k, z * k);

  double dot(_V3 o) => x * o.x + y * o.y + z * o.z;

  _V3 cross(_V3 o) =>
      _V3(y * o.z - z * o.y, z * o.x - x * o.z, x * o.y - y * o.x);

  double get length => math.sqrt(x * x + y * y + z * z);

  _V3 normalized() {
    final len = length;
    return len == 0 ? this : _V3(x / len, y / len, z / len);
  }
}

/// Where a body sits in the scene on [date]: on its circular orbit, at its
/// real direction from the Sun. z points to the north of the ecliptic.
_V3 _positionOf(Planet p, DateTime date) {
  if (p.id == 'sun') {
    return _V3.zero;
  }
  if (p.isMoon) {
    final parent = planetById(p.parentId ?? 'earth');
    final parentPos = _positionOf(parent, date);
    final moons = moonsOf(parent.id);
    final idx = math.max(0, moons.indexWhere((m) => m.id == p.id));
    final baseR = _bodyRadius(parent) * (parent.hasRings ? 2.4 : 1.8);
    final r = baseR + idx * 5.2;
    final j2000 = DateTime.utc(2000, 1, 1, 12);
    final days = date.toUtc().difference(j2000).inMinutes / 1440.0;
    final period = p.yearDays > 0 ? p.yearDays : 1.0;
    final a = ((days / period) * 2 * math.pi) + idx * 1.1;
    return parentPos + _V3(math.cos(a) * r, math.sin(a) * r, 0);
  }
  final lon = heliocentricLongitude(p.id, clampOrbitDate(date)) * math.pi / 180;
  final r = _orbitRadius(p);
  return _V3(math.cos(lon) * r, math.sin(lon) * r, 0);
}

/// The moving parts of the camera. The "goal" values are where it is heading;
/// every frame it moves part of the way there.
class _SceneState {
  double yaw = -math.pi / 2;
  double pitch = 0.8;
  double dist = _overviewDistance;
  _V3 target = _V3.zero;

  double goalYaw = -math.pi / 2;
  double goalPitch = 0.8;
  double goalDist = _overviewDistance;

  double time = 0;
}

/// A camera looking at [target], placed on a sphere around it.
class _Camera {
  _Camera(_SceneState s, Size size)
      : center = size.center(Offset.zero),
        focal = math.min(size.width, size.height) * 1.1 {
    final cp = math.cos(s.pitch);
    pos = s.target +
        _V3(cp * math.cos(s.yaw), cp * math.sin(s.yaw), math.sin(s.pitch)) *
            s.dist;
    fwd = (s.target - pos).normalized();
    right = fwd.cross(const _V3(0, 0, 1)).normalized();
    up = right.cross(fwd);
  }

  final Offset center;
  final double focal;
  late final _V3 pos;
  late final _V3 fwd;
  late final _V3 right;
  late final _V3 up;

  /// Depth of [p] in front of the camera. Zero or less means behind it.
  double depth(_V3 p) => (p - pos).dot(fwd);

  Offset screen(_V3 p, double depth) {
    final v = p - pos;
    return Offset(center.dx + v.dot(right) / depth * focal,
        center.dy - v.dot(up) / depth * focal);
  }
}

/// A body as it appears on screen right now.
class _Placed {
  _Placed(this.planet, this.world, this.screen, this.depth, this.radius);

  final Planet planet;
  final _V3 world;
  final Offset screen;
  final double depth;

  /// Radius on screen in pixels.
  final double radius;
}

List<_Placed> _place(
  _SceneState s,
  _Camera cam,
  DateTime date,
  String? focusId,
) {
  final out = <_Placed>[];
  final activePlanetId = focusId == null
      ? null
      : (_bodyById(focusId)?.isMoon == true
          ? _bodyById(focusId)!.parentId
          : focusId);
  for (final planet in spaceBodies) {
    final world = _positionOf(planet, date);
    final depth = cam.depth(world);
    if (depth < 1) {
      continue;
    }
    out.add(_Placed(planet, world, cam.screen(world, depth), depth,
        _bodyRadius(planet) / depth * cam.focal));
  }
  if (activePlanetId != null) {
    for (final moon in moonsOf(activePlanetId)) {
      final world = _positionOf(moon, date);
      final depth = cam.depth(world);
      if (depth < 1) {
        continue;
      }
      out.add(_Placed(moon, world, cam.screen(world, depth), depth,
          _bodyRadius(moon) / depth * cam.focal));
    }
  }
  // Far ones first, so near ones are drawn on top.
  out.sort((a, b) => b.depth.compareTo(a.depth));
  return out;
}

/// All the planets in one 3D scene. Drag to look around, pinch to zoom, tap a
/// planet to fly to it. [focusId] is the planet the camera is on, or null for
/// the whole Solar System; taps are reported through [onFocus].
class SpaceView extends StatefulWidget {
  const SpaceView({
    super.key,
    required this.date,
    required this.focusId,
    required this.onFocus,
    required this.nameOf,
    required this.backLabel,
  });

  final DateTime date;
  final String? focusId;
  final ValueChanged<String?> onFocus;
  final String Function(Planet planet) nameOf;
  final String backLabel;

  @override
  State<SpaceView> createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView>
    with SingleTickerProviderStateMixin {
  final _SceneState _scene = _SceneState();
  final ValueNotifier<int> _frame = ValueNotifier<int>(0);
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  bool _busy = false;
  double _distAtStart = 1;
  Size _size = Size.zero;
  final Map<String, ui.FragmentShader> _shaders =
      <String, ui.FragmentShader>{};
  bool _shaderFailed = false;

  static const Duration _idleFrameGap = Duration(milliseconds: 33);

  @override
  void initState() {
    super.initState();
    _applyFocus(widget.focusId, snap: true);
    PlanetShader.load().then((program) {
      if (!mounted) {
        return;
      }
      // One shader object per body, so no draw can borrow another's values.
      for (final body in allBodies) {
        _shaders[body.id] = program.fragmentShader();
      }
      _frame.value++;
    }, onError: (Object _) {
      _shaderFailed = true;
      if (mounted) {
        _frame.value++;
      }
    });
    _ticker = createTicker(_tick)..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // "Remove animations" in the phone's settings: the scene stands still
    // until it is touched.
    _ticker.muted = MediaQuery.disableAnimationsOf(context);
  }

  @override
  void didUpdateWidget(SpaceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusId != widget.focusId) {
      _applyFocus(widget.focusId, snap: _ticker.muted);
      _frame.value++;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    for (final shader in _shaders.values) {
      shader.dispose();
    }
    super.dispose();
  }

  Planet? get _focus =>
      widget.focusId == null ? null : _bodyById(widget.focusId!);

  double _minDist(Planet? focus) =>
      focus == null ? 150 : _bodyRadius(focus) * 1.7;

  double _maxDist(Planet? focus) =>
      focus == null ? 1700 : _bodyRadius(focus) * 70;

  /// Sets where the camera is heading. With [snap] it gets there at once.
  void _applyFocus(String? id, {required bool snap}) {
    final focus = id == null ? null : _bodyById(id);
    final s = _scene;
    if (focus == null) {
      s.goalDist = _overviewDistance;
      s.goalPitch = 0.8;
    } else {
      s.goalDist = _bodyRadius(focus) * (focus.hasRings ? 5.4 : 3.3);
      s.goalPitch = 0.25;
      // Come in from the Sun's side, a little to one side, so the planet is
      // lit like a crescent-to-half moon rather than flat on.
      final pos = _positionOf(focus, widget.date);
      var goal = focus.id == 'sun'
          ? s.yaw
          : math.atan2(-pos.y, -pos.x) + 0.7;
      var delta = (goal - s.yaw) % (2 * math.pi);
      if (delta > math.pi) {
        delta -= 2 * math.pi;
      }
      goal = s.yaw + delta;
      s.goalYaw = goal;
    }
    if (snap) {
      s.yaw = s.goalYaw;
      s.pitch = s.goalPitch;
      s.dist = s.goalDist;
      s.target = focus == null ? _V3.zero : _positionOf(focus, widget.date);
    }
  }

  void _tick(Duration elapsed) {
    if (!_busy && elapsed - _last < _idleFrameGap) {
      return;
    }
    // After a pause the gap can be long; never jump the scene by it.
    final dt = math.min((elapsed - _last).inMicroseconds / 1e6, 0.1);
    _last = elapsed;
    final s = _scene;
    s.time += dt;
    final k = 1 - math.exp(-dt * 3.5);
    final focus = _focus;
    final goalTarget =
        focus == null ? _V3.zero : _positionOf(focus, widget.date);
    s.target = s.target + (goalTarget - s.target) * k;
    s.yaw += (s.goalYaw - s.yaw) * k;
    s.pitch += (s.goalPitch - s.pitch) * k;
    s.dist += (s.goalDist - s.dist) * k;
    _frame.value++;
  }

  void _onScaleStart(ScaleStartDetails details) {
    _busy = true;
    _distAtStart = _scene.goalDist;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final s = _scene;
    s.yaw -= details.focalPointDelta.dx * 0.01;
    s.pitch = (s.pitch + details.focalPointDelta.dy * 0.008)
        .clamp(-1.4, 1.4)
        .toDouble();
    // The user is steering now: stop heading for the old angles.
    s.goalYaw = s.yaw;
    s.goalPitch = s.pitch;
    if (details.pointerCount > 1) {
      final focus = _focus;
      s.goalDist = (_distAtStart / details.scale)
          .clamp(_minDist(focus), _maxDist(focus))
          .toDouble();
      s.dist = s.goalDist;
    }
    _frame.value++;
  }

  void _onTapUp(TapUpDetails details) {
    if (_size.isEmpty) {
      return;
    }
    final placed =
        _place(_scene, _Camera(_scene, _size), widget.date, widget.focusId);
    _Placed? best;
    var bestDistance = double.infinity;
    for (final item in placed) {
      final distance = (item.screen - details.localPosition).distance;
      final reach = math.max(item.radius + 10, 22.0);
      // Later in the list is nearer the camera, so ties go to the near one.
      if (distance < reach && distance <= bestDistance) {
        best = item;
        bestDistance = distance;
      }
    }
    if (best != null && best.planet.id != widget.focusId) {
      widget.onFocus(best.planet.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        _size = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onScaleEnd: (_) => _busy = false,
                onTapUp: _onTapUp,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _SpacePainter(
                    scene: _scene,
                    date: widget.date,
                    palette: palette,
                    shaders: _shaders,
                    shaderFailed: _shaderFailed,
                    focusId: widget.focusId,
                    nameOf: widget.nameOf,
                    frame: _frame,
                  ),
                ),
              ),
            ),
            if (widget.focusId != null)
              Positioned(
                left: 10,
                top: 10,
                child: Material(
                  color: palette.background.withValues(alpha: 0.85),
                  shape: StadiumBorder(side: BorderSide(color: palette.border)),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: () => widget.onFocus(null),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.arrow_back,
                              size: 16, color: palette.accentText),
                          const SizedBox(width: 6),
                          Text(widget.backLabel,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: palette.text)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SpacePainter extends CustomPainter {
  _SpacePainter({
    required this.scene,
    required this.date,
    required this.palette,
    required this.shaders,
    required this.shaderFailed,
    required this.focusId,
    required this.nameOf,
    required ValueNotifier<int> frame,
  }) : super(repaint: frame);

  final _SceneState scene;
  final DateTime date;
  final Palette palette;
  final Map<String, ui.FragmentShader> shaders;
  final bool shaderFailed;
  final String? focusId;
  final String Function(Planet planet) nameOf;

  /// Real 3D celestial sphere stars from [catalogStars] with realistic spectral
  /// colors, magnitudes and names, plus a 3D Milky Way galactic dust band.
  static _V3 _raDecToV3(double raDeg, double decDeg) {
    final ra = raDeg * math.pi / 180.0;
    final dec = decDeg * math.pi / 180.0;
    final cd = math.cos(dec);
    return _V3(cd * math.cos(ra), cd * math.sin(ra), math.sin(dec));
  }

  static Color _starSpectralColor(StarData s, int index) {
    switch (s.name) {
      case 'Betelgeuse':
      case 'Antares':
      case 'Aldebaran':
      case 'Gacrux':
        return const Color(0xFFFFB07A); // M/K red-orange supergiants
      case 'Arcturus':
      case 'Capella':
      case 'Pollux':
      case 'Toliman':
        return const Color(0xFFFFE29A); // G/K warm yellow-orange
      case 'Rigel':
      case 'Spica':
      case 'Bellatrix':
      case 'Alnilam':
      case 'Alnitak':
      case 'Shaula':
      case 'Regulus':
      case 'Acrux':
      case 'Hadar':
        return const Color(0xFFA8CBFF); // O/B hot blue-white
      case 'Sirius':
      case 'Vega':
      case 'Deneb':
      case 'Altair':
      case 'Fomalhaut':
        return const Color(0xFFEAF3FF); // A brilliant white-blue
      default:
        const tints = <Color>[
          Color(0xFFEAF2FF),
          Color(0xFFD2E4FF),
          Color(0xFFFFF4DC),
          Color(0xFFFFDFB8),
          Color(0xFFBBD6FF),
        ];
        return tints[index % tints.length];
    }
  }

  static final List<({_V3 dir, double radius, Color color, String name, double mag})>
      _realStars = () {
    final list = <({_V3 dir, double radius, Color color, String name, double mag})>[];
    final count = math.min(catalogStars.length, 460);
    for (var i = 0; i < count; i++) {
      final s = catalogStars[i];
      final r = (2.5 - s.mag * 0.42).clamp(0.55, 2.75).toDouble();
      list.add((
        dir: _raDecToV3(s.ra, s.dec),
        radius: r,
        color: _starSpectralColor(s, i),
        name: s.name,
        mag: s.mag,
      ));
    }
    return list;
  }();

  static final List<List<_V3>> _constellationPolylines = () {
    const featured = <String>{
      'Ori', 'UMa', 'UMi', 'Cas', 'Cyg', 'Sco', 'Leo', 'Tau', 'Gem', 'Cru', 'Lyr', 'Aql', 'Peg', 'And'
    };
    final out = <List<_V3>>[];
    for (final c in catalogConstellations) {
      if (!featured.contains(c.id)) {
        continue;
      }
      for (final seg in c.lines) {
        final pts = <_V3>[];
        for (var i = 0; i + 1 < seg.length; i += 2) {
          pts.add(_raDecToV3(seg[i], seg[i + 1]));
        }
        if (pts.length >= 2) {
          out.add(pts);
        }
      }
    }
    return out;
  }();

  static final List<({_V3 dir, double size, Color color})> _milkyWayCloud = () {
    final rng = math.Random(42);
    final out = <({_V3 dir, double size, Color color})>[];
    const tilt = 1.08; // ~62 deg galactic plane tilt
    final ct = math.cos(tilt), st = math.sin(tilt);
    for (var i = 0; i < 68; i++) {
      final a = (i / 68.0) * 2 * math.pi + (rng.nextDouble() - 0.5) * 0.14;
      final spread = (rng.nextDouble() - 0.5) * 0.24;
      final x0 = math.cos(a);
      final y0 = math.sin(a);
      final z0 = spread;
      final dir = _V3(x0, y0 * ct - z0 * st, y0 * st + z0 * ct).normalized();
      out.add((
        dir: dir,
        size: 32.0 + rng.nextDouble() * 44.0,
        color: i.isEven ? const Color(0xFF4F74D8) : const Color(0xFF835CD8),
      ));
    }
    return out;
  }();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }
    final cam = _Camera(scene, size);
    final bounds = Offset.zero & size;

    // Deep space background gradient so the 3D scene always looks like real space
    final bgPaint = Paint()
      ..shader = ui.Gradient.radial(
        cam.center,
        math.max(size.width, size.height) * 0.85,
        const <Color>[Color(0xFF0A1126), Color(0xFF050813), Color(0xFF020308)],
        const <double>[0.0, 0.58, 1.0],
      );
    canvas.drawRect(bounds, bgPaint);

    // 1. 3D Milky Way Galactic Band
    for (final cloud in _milkyWayCloud) {
      final depth = cloud.dir.dot(cam.fwd);
      if (depth <= 0.08) {
        continue;
      }
      final at = Offset(
        cam.center.dx + cloud.dir.dot(cam.right) / depth * cam.focal,
        cam.center.dy - cloud.dir.dot(cam.up) / depth * cam.focal,
      );
      if (bounds.inflate(90).contains(at)) {
        final r = cloud.size / depth;
        final nebPaint = Paint()
          ..shader = ui.Gradient.radial(
            at,
            r,
            <Color>[
              cloud.color.withValues(alpha: 0.065),
              cloud.color.withValues(alpha: 0.0),
            ],
          );
        canvas.drawCircle(at, r, nebPaint);
      }
    }

    // 2. Subtle 3D Constellation Stick Lines on the celestial sphere
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..color = const Color(0xFF6E9BFF).withValues(alpha: 0.16);
    for (final seg in _constellationPolylines) {
      final path = Path();
      var started = false;
      for (final d in seg) {
        final depth = d.dot(cam.fwd);
        if (depth <= 0.08) {
          started = false;
          continue;
        }
        final at = Offset(
          cam.center.dx + d.dot(cam.right) / depth * cam.focal,
          cam.center.dy - d.dot(cam.up) / depth * cam.focal,
        );
        if (!started) {
          path.moveTo(at.dx, at.dy);
          started = true;
        } else {
          path.lineTo(at.dx, at.dy);
        }
      }
      canvas.drawPath(path, linePaint);
    }

    // 3. 460 Real Catalog Stars (RA/Dec) with spectral colors, halos & diffraction spikes
    for (var i = 0; i < _realStars.length; i++) {
      final st = _realStars[i];
      final depth = st.dir.dot(cam.fwd);
      if (depth <= 0.05) {
        continue;
      }
      final at = Offset(
        cam.center.dx + st.dir.dot(cam.right) / depth * cam.focal,
        cam.center.dy - st.dir.dot(cam.up) / depth * cam.focal,
      );
      if (!bounds.contains(at)) {
        continue;
      }
      final twinkle =
          0.62 + 0.38 * (0.5 + 0.5 * math.sin(scene.time * 2.4 + i * 1.7));
      final r = st.radius;

      // Soft halo and 4-point diffraction spikes for 1st-magnitude bright stars
      if (st.mag < 1.35) {
        canvas.drawCircle(
          at,
          r * 3.4,
          Paint()..color = st.color.withValues(alpha: 0.18 * twinkle),
        );
        final spikeLen = r * 4.2;
        final spikePaint = Paint()
          ..strokeWidth = 0.85
          ..color = st.color.withValues(alpha: 0.42 * twinkle);
        canvas.drawLine(
            at.translate(-spikeLen, 0), at.translate(spikeLen, 0), spikePaint);
        canvas.drawLine(
            at.translate(0, -spikeLen), at.translate(0, spikeLen), spikePaint);
      } else if (st.mag < 2.3) {
        canvas.drawCircle(
          at,
          r * 2.2,
          Paint()..color = st.color.withValues(alpha: 0.12 * twinkle),
        );
      }

      canvas.drawCircle(
        at,
        r,
        Paint()..color = st.color.withValues(alpha: (0.95 * twinkle).clamp(0.2, 1.0)),
      );
    }

    // 4. Periodic 3D shooting star streak across deep space
    final cycle = scene.time % 8.5;
    if (cycle < 0.75) {
      final progress = cycle / 0.75;
      final seed = (scene.time ~/ 8.5) % 5;
      final startX = size.width * (0.18 + seed * 0.14);
      final startY = size.height * (0.12 + (seed.isEven ? 0.08 : 0.22));
      const dx = 135.0;
      const dy = 65.0;
      final head = Offset(startX + dx * progress, startY + dy * progress);
      final tail = Offset(
        startX + dx * math.max(0.0, progress - 0.28),
        startY + dy * math.max(0.0, progress - 0.28),
      );
      final fade = math.sin(progress * math.pi);
      final streakPaint = Paint()
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: (0.85 * fade).clamp(0.0, 1.0));
      canvas.drawLine(tail, head, streakPaint);
    }

    _paintOrbits(canvas, cam, bounds);

    for (final item in _place(scene, cam, date, focusId)) {
      _paintBody(canvas, size, cam, item);
    }
  }

  void _paintOrbits(Canvas canvas, _Camera cam, Rect bounds) {
    const steps = 96;
    for (final planet in spaceBodies) {
      if (planet.id == 'sun') {
        continue;
      }
      final isFocused = planet.id == focusId;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isFocused ? 1.8 : 1.15
        ..color = planet.color.withValues(alpha: isFocused ? 0.82 : 0.36);
      final r = _orbitRadius(planet);
      final path = Path();
      var drawing = false;
      for (var i = 0; i <= steps; i++) {
        final a = i / steps * 2 * math.pi;
        final p = _V3(math.cos(a) * r, math.sin(a) * r, 0);
        final depth = cam.depth(p);
        if (depth < 1) {
          drawing = false;
          continue;
        }
        final at = cam.screen(p, depth);
        if (drawing) {
          path.lineTo(at.dx, at.dy);
        } else {
          path.moveTo(at.dx, at.dy);
        }
      }
      canvas.drawPath(path, paint);
    }

    // Draw moon orbit rings when focused on a planet with moons
    final activePlanetId = focusId == null
        ? null
        : (_bodyById(focusId!)?.isMoon == true
            ? _bodyById(focusId!)!.parentId
            : focusId);
    if (activePlanetId != null) {
      final parent = planetById(activePlanetId);
      final parentPos = _positionOf(parent, date);
      final moons = moonsOf(activePlanetId);
      for (var mIdx = 0; mIdx < moons.length; mIdx++) {
        final moon = moons[mIdx];
        final baseR = _bodyRadius(parent) * (parent.hasRings ? 2.4 : 1.8);
        final mr = baseR + mIdx * 5.2;
        final mPath = Path();
        var drawing = false;
        for (var i = 0; i <= 64; i++) {
          final a = i / 64 * 2 * math.pi;
          final p = parentPos + _V3(math.cos(a) * mr, math.sin(a) * mr, 0);
          final depth = cam.depth(p);
          if (depth < 1) {
            drawing = false;
            continue;
          }
          final at = cam.screen(p, depth);
          if (drawing) {
            mPath.lineTo(at.dx, at.dy);
          } else {
            mPath.moveTo(at.dx, at.dy);
            drawing = true;
          }
        }
        canvas.drawPath(
          mPath,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.9
            ..color = moon.color.withValues(alpha: 0.45),
        );
      }
    }
  }

  void _paintBody(Canvas canvas, Size size, _Camera cam, _Placed item) {
    final planet = item.planet;
    final c = item.screen;
    final r = item.radius;
    // Well off screen, rings and glow included.
    final margin = r * 2.4 + 40;
    if (c.dx < -margin ||
        c.dy < -margin ||
        c.dx > size.width + margin ||
        c.dy > size.height + margin) {
      return;
    }

    final isSun = planet.id == 'sun';
    if (isSun) {
      canvas.drawCircle(c, r * 2.2,
          Paint()..color = palette.accent.withValues(alpha: 0.16));
      canvas.drawCircle(c, r * 1.5,
          Paint()..color = palette.accent.withValues(alpha: 0.22));
    }

    final shader = shaders[planet.id];
    final detailed = shader != null && !shaderFailed && r >= 3.2;
    final roll = planet.tiltDeg * math.pi / 180;
    final rings = planet.hasRings && detailed;

    if (rings) {
      paintPlanetRings(canvas, planet, c, r,
          roll: roll, pitch: scene.pitch, back: true);
    }

    if (detailed) {
      const pad = 1.12;
      final side = r * 2 * pad;
      final rect = Rect.fromCenter(center: c, width: side, height: side);
      // Sunlight in view space: from the planet towards the Sun.
      final towardSun = _V3.zero - item.world;
      final light = isSun
          ? defaultPlanetLight
          : <double>[
              towardSun.dot(cam.right),
              towardSun.dot(cam.up),
              -towardSun.dot(cam.fwd),
            ];
      final len = math.sqrt(light[0] * light[0] +
          light[1] * light[1] +
          light[2] * light[2]);
      setPlanetUniforms(
        shader,
        planet,
        size: Size(side, side),
        center: c,
        yaw: scene.time * 0.25,
        pitch: scene.pitch,
        zoom: 1 / pad,
        time: scene.time,
        light: len == 0
            ? defaultPlanetLight
            : <double>[light[0] / len, light[1] / len, light[2] / len],
      );
      // The shader reads canvas coordinates, so clip the rect instead of
      // moving it; a planet filling the screen never paints a huge area.
      canvas.drawRect(
          rect.intersect(Offset.zero & size), Paint()..shader = shader);
    } else {
      paintPlanetBall(canvas, planet, c, math.max(r, 2.4));
    }

    if (rings) {
      paintPlanetRings(canvas, planet, c, r,
          roll: roll, pitch: scene.pitch, back: false);
    }

    // Names, except on the planet that fills the screen.
    if (r < math.min(size.width, size.height) * 0.2) {
      final label = TextPainter(
        text: TextSpan(
          text: nameOf(planet),
          style: TextStyle(
            color: planet.id == focusId
                ? const Color(0xFF7CE2FF)
                : const Color(0xFFEAF0FF),
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      final extra = planet.hasRings && detailed ? r * 1.2 : 0.0;
      final at = Offset(c.dx - label.width / 2,
          c.dy + math.max(r, 2.4) + extra + 4);
      if (at.dy + label.height < size.height &&
          at.dx > 0 &&
          at.dx + label.width < size.width) {
        label.paint(canvas, at);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SpacePainter oldDelegate) =>
      oldDelegate.date != date ||
      oldDelegate.palette != palette ||
      oldDelegate.focusId != focusId ||
      oldDelegate.shaderFailed != shaderFailed ||
      oldDelegate.shaders.length != shaders.length;
}
