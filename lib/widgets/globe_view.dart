import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../data/planets.dart';
import 'common.dart';

/// Loads shaders/planet.frag once for the whole app.
class PlanetShader {
  static Future<ui.FragmentProgram>? _program;

  static Future<ui.FragmentProgram> load() =>
      _program ??= ui.FragmentProgram.fromAsset('shaders/planet.frag');
}

/// A 3D planet that turns slowly by itself. Drag to rotate, pinch to zoom.
class GlobeView extends StatefulWidget {
  const GlobeView({super.key, required this.planet});

  final Planet planet;

  @override
  State<GlobeView> createState() => _GlobeViewState();
}

class _GlobeState {
  double yaw = 0;

  /// Positive looks at the planet slightly from above.
  double pitch = 0.35;
  double zoom = 1;
  double time = 0;
}

class _GlobeViewState extends State<GlobeView>
    with SingleTickerProviderStateMixin {
  final _GlobeState _state = _GlobeState();
  final ValueNotifier<int> _frame = ValueNotifier<int>(0);
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  bool _dragging = false;
  double _zoomAtStart = 1;
  ui.FragmentShader? _shader;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    PlanetShader.load().then((program) {
      if (mounted) {
        setState(() => _shader = program.fragmentShader());
      }
    }, onError: (Object _) {
      if (mounted) {
        setState(() => _failed = true);
      }
    });
    _ticker = createTicker(_tick)..start();
  }

  /// The slow spin needs no more than 30 frames a second, which halves the
  /// work of the shader. Dragging still runs at the full rate.
  static const Duration _idleFrameGap = Duration(milliseconds: 33);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // "Remove animations" in the phone's settings: the planet stands still
    // until it is touched.
    _ticker.muted = MediaQuery.disableAnimationsOf(context);
  }

  void _tick(Duration elapsed) {
    if (!_dragging && elapsed - _last < _idleFrameGap) {
      return;
    }
    // After a pause the gap can be long; never jump the planet by it.
    final dt = math.min((elapsed - _last).inMicroseconds / 1e6, 0.1);
    _last = elapsed;
    _state.time += dt;
    if (!_dragging) {
      _state.yaw += dt * 0.25;
    }
    _frame.value++;
  }

  @override
  void didUpdateWidget(GlobeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.planet.id != widget.planet.id) {
      _state.zoom = 1;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    if (shader == null) {
      // While loading, or on a phone where the shader cannot run, show a
      // simple shaded planet instead.
      return Center(
        child: _failed
            ? PlanetBall(planet: widget.planet, size: 200)
            : const SizedBox.shrink(),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) {
        _dragging = true;
        _zoomAtStart = _state.zoom;
      },
      onScaleUpdate: (details) {
        _state.yaw -= details.focalPointDelta.dx * 0.012;
        _state.pitch = (_state.pitch + details.focalPointDelta.dy * 0.01)
            .clamp(-1.3, 1.3)
            .toDouble();
        if (details.pointerCount > 1) {
          _state.zoom =
              (_zoomAtStart * details.scale).clamp(0.5, 1.6).toDouble();
        }
        _frame.value++;
      },
      onScaleEnd: (_) => _dragging = false,
      child: CustomPaint(
        size: Size.infinite,
        painter: _GlobePainter(
          shader: shader,
          planet: widget.planet,
          state: _state,
          frame: _frame,
        ),
      ),
    );
  }
}

class _GlobePainter extends CustomPainter {
  _GlobePainter({
    required this.shader,
    required this.planet,
    required this.state,
    required ValueNotifier<int> frame,
  }) : super(repaint: frame);

  final ui.FragmentShader shader;
  final Planet planet;
  final _GlobeState state;

  static const double _baseZoom = 0.62;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }
    final zoom = _baseZoom * state.zoom;
    final radius = math.min(size.width, size.height) / 2 * zoom;
    final center = size.center(Offset.zero);
    final roll = planet.tiltDeg * math.pi / 180;

    if (planet.hasRings) {
      _paintRings(canvas, center, radius, roll, back: true);
    }

    var i = 0;
    void f(double v) => shader.setFloat(i++, v);
    void color(Color c) {
      f(c.r);
      f(c.g);
      f(c.b);
    }

    f(size.width);
    f(size.height);
    f(state.yaw);
    f(-state.pitch);
    f(roll);
    f(zoom);
    color(planet.colors[0]);
    color(planet.colors[1]);
    color(planet.colors[2]);
    f(planet.style.index.toDouble());
    f(planet.polarCaps ? 1.0 : 0.0);
    f(planet.spot ? 1.0 : 0.0);
    // A different noise pattern for every body.
    f((planet.id.codeUnits.fold<int>(0, (a, c) => a + c) % 50) * 0.13);
    color(_glowColor(planet));
    f(_glowAmount(planet));
    f(state.time);

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);

    if (planet.hasRings) {
      _paintRings(canvas, center, radius, roll, back: false);
    }
  }

  /// Draws the back or front half of Saturn's rings. Looking from above, the
  /// near half is the lower one on screen.
  void _paintRings(Canvas canvas, Offset center, double radius, double roll,
      {required bool back}) {
    final flatten = math.sin(state.pitch).abs().clamp(0.04, 1.0).toDouble();
    final fromAbove = state.pitch >= 0;
    // Arc 0..pi is the lower half on screen (y points down).
    final lowerHalf = back ? !fromAbove : fromAbove;
    final start = lowerHalf ? 0.0 : math.pi;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-roll);
    const bands = <(double, double, double)>[
      // inner radius, outer radius, opacity
      (1.24, 1.45, 0.45),
      (1.48, 1.86, 0.85),
      (1.92, 2.18, 0.65),
    ];
    for (final (inner, outer, opacity) in bands) {
      final mid = (inner + outer) / 2 * radius;
      final width = (outer - inner) * radius;
      final rect = Rect.fromCenter(
          center: Offset.zero, width: mid * 2, height: mid * 2 * flatten);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth =
            math.max(1.0, (width * flatten.clamp(0.35, 1.0)).toDouble())
        ..color = Color.lerp(planet.colors[2], planet.colors[1], 0.35)!
            .withValues(alpha: opacity);
      canvas.drawArc(rect, start, math.pi, false, paint);
    }
    canvas.restore();
  }

  Color _glowColor(Planet p) {
    switch (p.id) {
      case 'sun':
        return const Color(0xFFFFB347);
      case 'titan':
        return const Color(0xFFF0B060);
      case 'earth':
        return const Color(0xFF7FB2FF);
      case 'venus':
        return const Color(0xFFFFE2A8);
      case 'mars':
        return const Color(0xFFFFB38A);
      case 'uranus':
      case 'neptune':
        return const Color(0xFFBFE8FF);
      default:
        return Color.lerp(p.colors[2], Colors.white, 0.3)!;
    }
  }

  double _glowAmount(Planet p) {
    if (p.thinAtmosphere || p.atmosphere.isEmpty) {
      return 0;
    }
    switch (p.id) {
      case 'sun':
        return 1.0;
      case 'titan':
        return 0.9;
      case 'pluto':
      case 'triton':
        return 0.15;
      case 'earth':
        return 0.9;
      case 'venus':
        return 0.7;
      case 'mars':
        return 0.3;
      default:
        return 0.45;
    }
  }

  @override
  bool shouldRepaint(covariant _GlobePainter oldDelegate) =>
      oldDelegate.planet.id != planet.id || oldDelegate.shader != shader;
}
