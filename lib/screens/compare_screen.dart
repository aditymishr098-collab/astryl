import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../data/planets.dart';
import '../l10n/names.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'calculators.dart';
import 'planet_screen.dart';

/// Two planets side by side.
class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  String _a = 'earth';
  String _b = 'mars';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final t = PlanetText(context);
    final a = planetById(_a);
    final b = planetById(_b);

    final rows = <(String, String, String)>[
      (l.oxygen, t.oxygen(a), t.oxygen(b)),
      (l.diameter, t.diameter(a), t.diameter(b)),
      (l.gravity, t.gravity(a), t.gravity(b)),
      (l.avgTemp, t.temperature(a), t.temperature(b)),
      (l.moons, t.moons(a), t.moons(b)),
      (l.dayLength, t.day(a), t.day(b)),
      (l.yearLength, t.year(a), t.year(b)),
      (l.distance, t.distance(a), t.distance(b)),
      (l.pressure, t.pressure(a), t.pressure(b)),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(l.compareTitle,
                  style: TextStyle(
                      fontFamily: headingFont,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: p.text)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: p.orbit.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: p.orbit.withValues(alpha: 0.5)),
              ),
              child: Text(
                'VS ARENA',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: p.orbit,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(l.compareHint, style: TextStyle(fontSize: 14, color: p.muted)),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: _PlanetPicker(
                value: _a,
                onChanged: (id) => setState(() => _a = id),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: <Color>[p.accent, p.orbit],
                  ),
                ),
                child: Text(
                  'VS',
                  style: TextStyle(
                    fontFamily: headingFont,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: p.onAccent,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _PlanetPicker(
                value: _b,
                onChanged: (id) => setState(() => _b = id),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SizeCompare(a: a, b: b),
        const SizedBox(height: 16),
        SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          borderColor: p.accent.withValues(alpha: 0.45),
          child: Column(
            children: <Widget>[
              for (var i = 0; i < rows.length; i++) ...<Widget>[
                if (i > 0) const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        rows[i].$1.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: p.accentText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: a.color.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: a.color.withValues(alpha: 0.35)),
                              ),
                              child: Text(rows[i].$2,
                                  style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: p.text)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: b.color.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: b.color.withValues(alpha: 0.35)),
                              ),
                              child: Text(rows[i].$3,
                                  style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: p.text)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Calculators(),
      ],
    );
  }
}

class _PlanetPicker extends StatelessWidget {
  const _PlanetPicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: p.surface,
          borderRadius: BorderRadius.circular(16),
          onChanged: (id) {
            if (id != null) {
              onChanged(id);
            }
          },
          items: <DropdownMenuItem<String>>[
            for (final planet in allBodies)
              DropdownMenuItem<String>(
                value: planet.id,
                child: Row(
                  children: <Widget>[
                    PlanetBall(planet: planet, size: 18),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(planetName(l, planet),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: p.text, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The two bodies drawn side by side at their true sizes.
class _SizeCompare extends StatelessWidget {
  const _SizeCompare({required this.a, required this.b});

  final Planet a;
  final Planet b;

  static const double _maxSize = 120;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final big = a.diameterKm >= b.diameterKm ? a : b;
    final small = identical(big, a) ? b : a;
    final ratio = big.diameterKm / small.diameterKm;

    double sizeOf(Planet body) =>
        math.max(3.0, _maxSize * body.diameterKm / big.diameterKm);

    Widget ball(Planet body) {
      final size = sizeOf(body);
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          PlanetBall(planet: body, size: size),
          const SizedBox(height: 8),
          Text(planetName(l, body),
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: p.text)),
        ],
      );
    }

    final text = ratio < 1.05
        ? l.sizeSimilar(planetName(l, a), planetName(l, b))
        : l.sizeTimes(
            planetName(l, big),
            formatNumber(context, ratio, decimals: ratio < 10 ? 1 : 0),
            planetName(l, small),
          );

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(l.sizeTitle,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: p.text)),
          const SizedBox(height: 12),
          SizedBox(
            height: _maxSize + 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[ball(a), ball(b)],
            ),
          ),
          const SizedBox(height: 12),
          Text(text, style: TextStyle(fontSize: 14, color: p.text, height: 1.4)),
        ],
      ),
    );
  }
}
