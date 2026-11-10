import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/spacecraft.dart';
import '../data/favorites.dart';
import '../l10n/names.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/favorite_button.dart';
import 'planet_screen.dart' show PlanetText;

/// How far famous spacecraft are from Earth right now.
class SpacecraftScreen extends StatelessWidget {
  const SpacecraftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.spacecraftTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: <Widget>[
              Text(l.spacecraftSubtitle,
                  style: TextStyle(fontSize: 14, color: p.muted, height: 1.4)),
              const SizedBox(height: 16),
              for (final craft in spacecraft) ...<Widget>[
                SpacecraftCard(craft: craft, now: now),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 4),
              Text(l.spacecraftNote,
                  style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
            ],
          ),
        ),
      ),
    );
  }
}

/// One spacecraft with its distance. Also used by the search and favourites
/// list.
class SpacecraftCard extends StatelessWidget {
  const SpacecraftCard({super.key, required this.craft, DateTime? now})
      : _now = now;

  final Spacecraft craft;
  final DateTime? _now;

  /// The distance in the unit that reads best for this spacecraft.
  String _distance(BuildContext context, DateTime now) {
    final l = context.l10n;
    final km = craft.distanceKm(now);
    switch (craft.kind) {
      case SpacecraftKind.probe:
        return l.valueBillionKm(formatNumber(context, km / 1e9, decimals: 1));
      case SpacecraftKind.mars:
        return l.valueMillionKm(formatNumber(context, km / 1e6, decimals: 1));
      case SpacecraftKind.lowOrbit:
      case SpacecraftKind.fixedDistance:
        return '≈ ${l.valueKm(formatNumber(context, km))}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final now = _now ?? DateTime.now();
    final text = PlanetText(context);
    final probe = craft.kind == SpacecraftKind.probe;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                probe
                    ? Icons.rocket_launch_outlined
                    : craft.kind == SpacecraftKind.mars
                        ? Icons.directions_car_outlined
                        : Icons.satellite_alt_outlined,
                color: p.accentText,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(craft.name,
                    style: TextStyle(fontFamily: headingFont, fontSize: 18, fontWeight: FontWeight.w700,
                        color: p.text)),
              ),
              FavoriteButton(favoriteKey: craftKey(craft.id)),
            ],
          ),
          const SizedBox(height: 4),
          Text(spacecraftText(l, craft.id),
              style: TextStyle(fontSize: 14, color: p.muted, height: 1.4)),
          const SizedBox(height: 12),
          _StatRow(
            label: craft.isAltitude ? l.spacecraftAltitude : l.spacecraftDistance,
            value: _distance(context, now),
            big: true,
          ),
          if (probe) ...<Widget>[
            _StatRow(
              label: l.spacecraftInAu,
              value: l.valueAu(
                  formatNumber(context, craft.distanceAu(now), decimals: 1)),
            ),
            _StatRow(
              label: l.spacecraftSpeed,
              value: l.valueKmS(
                  formatNumber(context, craft.speedKmS, decimals: 1)),
            ),
          ],
          if (!craft.isAltitude)
            _StatRow(
              label: l.spacecraftSignal,
              value: text.duration(craft.signalSeconds(now)),
            ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, this.big = false});

  final String label;
  final String value;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(label,
                style: TextStyle(fontSize: 14, color: p.muted)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: big ? 18 : 14,
                fontWeight: big ? FontWeight.w700 : FontWeight.w600,
                color: big ? p.accentText : p.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
