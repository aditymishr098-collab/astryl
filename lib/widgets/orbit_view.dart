import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/orbits.dart';
import '../data/planets.dart';
import '../theme.dart';
import 'common.dart';

/// Top-down 2D view of the Solar System, seen from above the Sun's north
/// pole. Each planet sits at its real direction from the Sun on [date];
/// sizes and distances are not to scale. Tapping a planet calls
/// [onPlanetTap].
class OrbitView extends StatelessWidget {
  const OrbitView({
    super.key,
    required this.date,
    required this.selectedId,
    required this.onPlanetTap,
    required this.nameOf,
  });

  final DateTime date;
  final String selectedId;
  final ValueChanged<Planet> onPlanetTap;
  final String Function(Planet planet) nameOf;

  void _handleTap(TapUpDetails details, Size size) {
    final layout = OrbitLayout(size);
    if ((details.localPosition - layout.center).distance <
        layout.sunRadius + 8) {
      onPlanetTap(planetById('sun'));
      return;
    }
    Planet? best;
    var bestDistance = double.infinity;
    for (final planet in planets) {
      final position = layout.position(planet, date);
      final distance = (position - details.localPosition).distance;
      final reach = math.max(layout.planetRadius(planet) + 14, 24.0);
      if (distance < reach && distance < bestDistance) {
        best = planet;
        bestDistance = distance;
      }
    }
    if (best != null) {
      onPlanetTap(best);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    final textColor = palette.text;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) => _handleTap(details, size),
          child: CustomPaint(
            size: size,
            painter: _OrbitPainter(
              date: date,
              palette: palette,
              selectedId: selectedId,
              selectedName: nameOf(planetById(selectedId)),
              textColor: textColor,
            ),
          ),
        );
      },
    );
  }
}

/// Where everything sits in the 2D view. Shared by painting and tapping.
class OrbitLayout {
  OrbitLayout(this.size)
      : center = Offset(size.width / 2, size.height / 2),
        maxRadius = math.min(size.width, size.height) / 2 - 14;

  final Size size;
  final Offset center;
  final double maxRadius;

  double get sunRadius => math.max(10, maxRadius * 0.09);

  double orbitRadius(Planet planet) =>
      maxRadius * (0.2 + 0.8 * (planet.order - 1) / 7);

  double planetRadius(Planet planet) {
    final scale = math.sqrt(planet.diameterKm / 4879);
    return (2.6 + scale * 1.9).clamp(3.0, 11.0).toDouble();
  }

  /// Screen angle in radians on [date]. Planets go round anticlockwise, as
  /// seen from above; the screen's y axis points down, hence the minus.
  double angle(Planet planet, DateTime date) {
    final degrees = hasOrbit(planet.id)
        ? heliocentricLongitude(planet.id, clampOrbitDate(date))
        : 0.0;
    return -degrees * math.pi / 180;
  }

  Offset position(Planet planet, DateTime date) {
    final a = angle(planet, date);
    final r = orbitRadius(planet);
    return center + Offset(math.cos(a) * r, math.sin(a) * r);
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({
    required this.date,
    required this.palette,
    required this.selectedId,
    required this.selectedName,
    required this.textColor,
  });

  final DateTime date;
  final Palette palette;
  final String selectedId;
  final String selectedName;
  final Color textColor;

  static final List<Offset> _stars = () {
    final rng = math.Random(7);
    return List<Offset>.generate(
        60, (_) => Offset(rng.nextDouble(), rng.nextDouble()));
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final layout = OrbitLayout(size);

    if (palette.star.a > 0) {
      final t = date.millisecondsSinceEpoch / 1000.0;
      for (var i = 0; i < _stars.length; i++) {
        final s = _stars[i];
        final twinkle =
            0.5 + 0.5 * (0.5 + 0.5 * math.sin(t * 2.0 + i * 1.7));
        final starPaint = Paint()
          ..color = palette.star.withValues(alpha: palette.star.a * twinkle);
        canvas.drawCircle(Offset(s.dx * size.width, s.dy * size.height),
            i.isEven ? 1.0 : 1.35, starPaint);
      }
    }

    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = palette.orbitLine;
    for (final planet in planets) {
      if (planet.id == selectedId) {
        _dashedCircle(canvas, layout.center, layout.orbitRadius(planet),
            planet.color);
      } else {
        canvas.drawCircle(
            layout.center, layout.orbitRadius(planet), orbitPaint);
      }
    }

    // Sun with a soft glow.
    canvas.drawCircle(layout.center, layout.sunRadius * 1.5,
        Paint()..color = palette.accent.withValues(alpha: 0.22));
    canvas.drawCircle(
        layout.center, layout.sunRadius, Paint()..color = palette.accent);

    for (final planet in planets) {
      final position = layout.position(planet, date);
      final radius = layout.planetRadius(planet);
      paintPlanetBall(canvas, planet, position, radius);
      if (planet.id == selectedId) {
        canvas.drawCircle(
          position,
          radius + 6,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = palette.accentText,
        );
        final label = TextPainter(
          text: TextSpan(
            text: selectedName,
            style: TextStyle(
                color: textColor, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        var labelPos = position + Offset(radius + 8, radius + 2);
        if (labelPos.dx + label.width > size.width) {
          labelPos = Offset(position.dx - radius - 8 - label.width, labelPos.dy);
        }
        if (labelPos.dy + label.height > size.height) {
          labelPos = Offset(labelPos.dx, position.dy - radius - 4 - label.height);
        }
        label.paint(canvas, labelPos);
      }
    }
  }

  void _dashedCircle(Canvas canvas, Offset c, double r, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = color;
    const dash = 3.0;
    const gap = 4.0;
    final circumference = 2 * math.pi * r;
    final count = (circumference / (dash + gap)).floor();
    final step = 2 * math.pi / count;
    final sweep = step * dash / (dash + gap);
    final rect = Rect.fromCircle(center: c, radius: r);
    for (var i = 0; i < count; i++) {
      canvas.drawArc(rect, i * step, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) =>
      oldDelegate.date != date ||
      oldDelegate.palette != palette ||
      oldDelegate.selectedId != selectedId ||
      oldDelegate.selectedName != selectedName;
}
