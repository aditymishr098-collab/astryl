import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/finder.dart';
import '../core/format.dart';
import '../core/sky.dart';
import '../data/cities.dart';
import '../data/orientation.dart';
import '../data/planets.dart';
import '../l10n/names.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Points the user to a planet or the Moon in the real sky with the phone's
/// compass and motion sensors.
class FinderScreen extends StatefulWidget {
  const FinderScreen({super.key, required this.city, required this.targetId});

  final City city;
  final String targetId;

  @override
  State<FinderScreen> createState() => _FinderScreenState();
}

/// Bodies the finder can look for. The Sun is left out on purpose: nobody
/// should point at it.
const List<String> finderTargets = <String>['moon', ...skyPlanets];

class _FinderScreenState extends State<FinderScreen> {
  late String _target = widget.targetId;
  StreamSubscription<PhoneDirection>? _sub;
  Timer? _timer;
  final DirectionSmoother _smoother = DirectionSmoother();

  ({double azimuth, double altitude})? _phone;
  bool _needsCalibration = false;
  bool _noSensor = false;
  bool _wasOnTarget = false;
  Horizontal? _targetNow;

  @override
  void initState() {
    super.initState();
    _updateTarget();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) {
      setState(_updateTarget);
    });
    _sub = phoneDirections(widget.city.lat, widget.city.lon).listen(
      (d) {
        if (!mounted) {
          return;
        }
        setState(() {
          _phone = _smoother.add(d.azimuth, d.altitude);
          _needsCalibration = d.needsCalibration;
        });
      },
      onError: (Object _) {
        if (mounted) {
          setState(() => _noSensor = true);
        }
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _updateTarget() {
    final now = DateTime.now();
    _targetNow = toHorizontal(
        equatorialOf(_target, now), now, widget.city.lat, widget.city.lon);
  }

  void _select(String id) {
    setState(() {
      _target = id;
      _wasOnTarget = false;
      _updateTarget();
    });
  }

  String? _riseTime() {
    final night = skyTonight(DateTime.now(), widget.city.lat, widget.city.lon);
    final now = DateTime.now();
    final list = <BodyNight>[night.moon, ...night.planets];
    for (final n in list) {
      if (n.id == _target) {
        final rise = n.rise;
        if (rise != null && rise.isAfter(now)) {
          return MaterialLocalizations.of(context)
              .formatTimeOfDay(TimeOfDay.fromDateTime(rise.toLocal()));
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final body = planetById(_target);
    final name = planetName(l, body);
    final target = _targetNow!;
    final phone = _phone;
    final below = target.altitude < 0;

    Guidance? g;
    if (phone != null && !below) {
      g = guide(
        phoneAzimuth: phone.azimuth,
        phoneAltitude: phone.altitude,
        targetAzimuth: target.azimuth,
        targetAltitude: target.altitude,
      );
      if (g.onTarget && !_wasOnTarget) {
        HapticFeedback.mediumImpact();
      }
      _wasOnTarget = g.onTarget;
    }

    String dir(double az) => directionName(l, compassIndex(az));
    String deg(double v) => formatNumber(context, v.abs().round());

    final List<String> hints;
    if (_noSensor) {
      hints = <String>[l.noSensor];
    } else if (below) {
      final rise = _riseTime();
      hints = <String>[
        l.belowHorizon(name),
        if (rise != null) l.risesAt(rise),
      ];
    } else if (g == null) {
      hints = <String>[l.pointPhone];
    } else if (g.onTarget) {
      hints = <String>[l.onTarget(name)];
    } else {
      hints = <String>[
        if (g.turn.abs() >= 3)
          g.turn > 0 ? l.turnRight(deg(g.turn)) : l.turnLeft(deg(g.turn)),
        if (g.tilt.abs() >= 3)
          g.tilt > 0 ? l.tiltUp(deg(g.tilt)) : l.tiltDown(deg(g.tilt)),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.finderTitle(name),
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: <Widget>[
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: finderTargets.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final id = finderTargets[index];
                final on = id == _target;
                final b = planetById(id);
                return ChoiceChip(
                  selected: on,
                  showCheckmark: false,
                  onSelected: (_) => _select(id),
                  avatar: CircleAvatar(backgroundColor: b.color, radius: 6),
                  label: Text(planetName(l, b)),
                  labelStyle: TextStyle(
                    color: on ? p.onAccent : p.text,
                    fontWeight: on ? FontWeight.w600 : FontWeight.w500,
                  ),
                  selectedColor: p.accent,
                  backgroundColor: p.surface,
                  side: BorderSide(color: on ? p.accent : p.border),
                  shape: const StadiumBorder(),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(
              painter: _ScopePainter(
                palette: p,
                guidance: g,
                body: body,
                onTarget: g?.onTarget ?? false,
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final h in hints)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                h,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: headingFont, fontSize: 20, fontWeight: FontWeight.w700,
                  color: (g?.onTarget ?? false) ? p.good : p.text,
                ),
              ),
            ),
          if (_needsCalibration && !_noSensor) ...<Widget>[
            const SizedBox(height: 8),
            SurfaceCard(
              child: Row(
                children: <Widget>[
                  Icon(Icons.explore_outlined, color: p.accentText),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l.calibrate,
                        style: TextStyle(fontSize: 13, color: p.text)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          SurfaceCard(
            child: Column(
              children: <Widget>[
                _Line(
                  label: name,
                  value: l.altitudeDir(
                      dir(target.azimuth), deg(target.altitude) +
                          (target.altitude < 0 ? ' ↓' : '')),
                ),
                if (phone != null)
                  _Line(
                    label: l.phoneNow,
                    value: l.altitudeDir(
                        dir(phone.azimuth), deg(phone.altitude)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(l.finderNote,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: p.muted)),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 14, color: p.muted)),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, color: p.text)),
        ],
      ),
    );
  }
}

/// A round "scope": the centre is where the phone points, the dot is the
/// target. When the target is outside, an arrow on the edge shows the way.
class _ScopePainter extends CustomPainter {
  _ScopePainter({
    required this.palette,
    required this.guidance,
    required this.body,
    required this.onTarget,
  });

  final Palette palette;
  final Guidance? guidance;
  final Planet body;
  final bool onTarget;

  /// Degrees shown from the centre to the edge of the scope.
  static const double _span = 45;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final c = Offset(r, r);
    canvas.drawCircle(
        c, r, Paint()..color = const Color(0xFF0B1020));
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFF2A3458);
    for (final f in <double>[0.33, 0.66, 1]) {
      canvas.drawCircle(c, r * f - 1, ring);
    }
    canvas.drawLine(Offset(c.dx, 0), Offset(c.dx, size.height), ring);
    canvas.drawLine(Offset(0, c.dy), Offset(size.width, c.dy), ring);

    // Centre: where the phone points.
    final aim = onTarget ? palette.good : palette.accent;
    canvas.drawCircle(
      c,
      r * 6 / _span,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = aim,
    );

    final g = guidance;
    if (g == null) {
      return;
    }
    var off = Offset(g.turn, -g.tilt) * (r / _span);
    final inside = off.distance <= r - 16;
    if (!inside) {
      off = off / off.distance * (r - 22);
    }
    final pos = c + off;
    if (inside) {
      paintPlanetBall(canvas, body, pos, 12);
    } else {
      final angle = math.atan2(off.dy, off.dx);
      final path = Path()
        ..moveTo(18, 0)
        ..lineTo(-8, -12)
        ..lineTo(-8, 12)
        ..close();
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angle);
      canvas.drawPath(path, Paint()..color = palette.accent);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ScopePainter oldDelegate) => true;
}
