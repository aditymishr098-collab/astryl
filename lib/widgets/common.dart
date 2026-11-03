import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/planets.dart';
import '../theme.dart';

/// The Heliora mark: a golden sun with a blue planet on a tilted orbit.
class HelioraLogo extends StatelessWidget {
  const HelioraLogo({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: const CustomPaint(painter: HelioraLogoPainter()),
    );
  }
}

class HelioraLogoPainter extends CustomPainter {
  const HelioraLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 120;
    canvas.scale(s);
    final bg = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 120, 120), const Radius.circular(28));
    canvas.drawRRect(bg, Paint()..color = const Color(0xFF141B33));

    canvas.save();
    canvas.translate(60, 60);
    canvas.rotate(-22 * math.pi / 180);
    canvas.translate(-60, -60);
    final orbitRect = Rect.fromCenter(
        center: const Offset(60, 60), width: 88, height: 34);
    final orbit = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF7AA2FF);
    // Back half of the orbit, behind the sun.
    canvas.drawArc(orbitRect, math.pi, math.pi, false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = const Color(0x8C7AA2FF));
    canvas.drawCircle(
        const Offset(60, 60), 19, Paint()..color = const Color(0xFFF5A524));
    // Front half, in front of the sun.
    canvas.drawArc(orbitRect, 0, math.pi, false, orbit);
    canvas.drawCircle(
        const Offset(104, 60), 7.5, Paint()..color = const Color(0xFF7AA2FF));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A small shaded ball in the planet's colour, used in lists and cards.
class PlanetBall extends StatelessWidget {
  const PlanetBall({super.key, required this.planet, this.size = 36});

  final Planet planet;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: planet.hasRings ? size * 1.5 : size,
      height: size,
      child: CustomPaint(painter: PlanetBallPainter(planet)),
    );
  }
}

class PlanetBallPainter extends CustomPainter {
  PlanetBallPainter(this.planet);

  final Planet planet;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.height / 2;
    final c = Offset(size.width / 2, size.height / 2);
    paintPlanetBall(canvas, planet, c, r);
  }

  @override
  bool shouldRepaint(covariant PlanetBallPainter oldDelegate) =>
      oldDelegate.planet.id != planet.id;
}

/// Draws a lit ball (and Saturn's rings) at [c] with radius [r].
void paintPlanetBall(Canvas canvas, Planet planet, Offset c, double r) {
  final ringRect = Rect.fromCenter(center: c, width: r * 3, height: r * 0.9);
  final ring = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = math.max(1.2, r * 0.18)
    ..color = planet.colors[1].withValues(alpha: 0.85);
  if (planet.hasRings) {
    canvas.drawArc(ringRect, math.pi, math.pi, false, ring);
  }
  final rect = Rect.fromCircle(center: c, radius: r);
  canvas.drawCircle(
    c,
    r,
    Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.4),
        radius: 1.0,
        colors: <Color>[
          Color.lerp(planet.colors[2], Colors.white, 0.15)!,
          planet.colors[0],
          Color.lerp(planet.colors[1], Colors.black, 0.35)!,
        ],
        stops: const <double>[0, 0.55, 1],
      ).createShader(rect),
  );
  if (planet.hasRings) {
    canvas.drawArc(ringRect, 0, math.pi, false, ring);
  }
}

/// A horizontal bar split by gas, with a legend underneath.
class AtmosphereBar extends StatelessWidget {
  const AtmosphereBar({
    super.key,
    required this.planet,
    required this.labelFor,
  });

  final Planet planet;

  /// Text for one legend item, for example "CO₂ 95.1%".
  final String Function(GasShare share) labelFor;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 14,
            child: Row(
              children: <Widget>[
                for (final share in planet.atmosphere)
                  Flexible(
                    // Tiny shares still get a visible sliver.
                    flex: math.max(6, (share.percent * 10).round()),
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(end: 2),
                      color: share.gas.color,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: <Widget>[
            for (final share in planet.atmosphere)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: share.gas.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(labelFor(share),
                      style: TextStyle(fontSize: 13, color: p.text)),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

/// A rounded card with the palette's surface colour.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final light = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? p.surface,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : (light ? Border.all(color: p.border) : null),
      ),
      child: child,
    );
  }
}

/// A stat with an icon, a small label and a value.
class IconStatTile extends StatelessWidget {
  const IconStatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 22, color: p.accentText),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(label, style: TextStyle(fontSize: 12, color: p.muted)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: p.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tiles in two columns. Each row is as tall as its tallest tile, so it
/// grows with the text size (a grid with a fixed shape would overflow).
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var i = 0; i < tiles.length; i += 2) ...<Widget>[
          if (i > 0) const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: tiles[i]),
                const SizedBox(width: 8),
                Expanded(
                  child: i + 1 < tiles.length
                      ? tiles[i + 1]
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Section heading in the small caps style of the design.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: p.muted,
        ),
      ),
    );
  }
}
