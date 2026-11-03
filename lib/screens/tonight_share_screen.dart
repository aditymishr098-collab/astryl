import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../core/format.dart';
import '../core/sky.dart';
import '../data/cities.dart';
import '../data/planets.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/moon_view.dart';
import '../widgets/share_card.dart';

/// Planets that need a telescope are left off the picture.
const Set<String> _telescopeOnly = <String>{'uranus', 'neptune'};

/// A picture of the sky over a city for one night: the Moon and the bright
/// planets that can be seen. Made on the phone, shared as an image.
class TonightShareScreen extends StatefulWidget {
  const TonightShareScreen({super.key, required this.city, required this.day});

  final City city;

  /// The night, as a calendar day.
  final DateTime day;

  @override
  State<TonightShareScreen> createState() => _TonightShareScreenState();
}

class _TonightShareScreenState extends State<TonightShareScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    final l = context.l10n;
    final palette = Palette.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final bridge = AppScope.read(context).bridge;
    final text = l.tonightShareText(widget.city.name);
    final failed = l.shareFailed;
    setState(() => _sharing = true);
    var shared = false;
    try {
      final boundary = _cardKey.currentContext?.findRenderObject();
      if (boundary is RenderRepaintBoundary) {
        final bytes = await renderShareCard(boundary, palette);
        final dir = await bridge.sharedDir();
        if (dir.isNotEmpty) {
          final file =
              File('$dir${Platform.pathSeparator}Heliora-tonight.png');
          await file.writeAsBytes(bytes, flush: true);
          shared = await bridge.shareImage(file.path, text);
        }
      }
    } on Exception {
      shared = false;
    }
    if (!mounted) {
      return;
    }
    setState(() => _sharing = false);
    if (!shared) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final city = widget.city;
    final day = widget.day;
    final loc = MaterialLocalizations.of(context);
    final now = DateTime.now();
    final isToday =
        day.year == now.year && day.month == now.month && day.day == now.day;
    final at = isToday ? now : DateTime(day.year, day.month, day.day, 21);
    final phase = moonPhase(at);
    final sky = skyTonight(day, city.lat, city.lon);
    final visible = <BodyNight>[
      for (final n in sky.planets)
        if (n.visibility != SkyVisibility.notVisible &&
            !_telescopeOnly.contains(n.id) &&
            n.bestTime != null)
          n,
    ];
    String time(DateTime t) =>
        loc.formatTimeOfDay(TimeOfDay.fromDateTime(t.toLocal()));

    return Scaffold(
      appBar: AppBar(title: Text(l.tonightShareTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          RepaintBoundary(
            key: _cardKey,
            child: ColoredBox(
              color: p.background,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SurfaceCard(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(l.skyOverCity(city.name),
                          style: headingStyle(24, p.text, height: 1.15)),
                      const SizedBox(height: 4),
                      Text(loc.formatFullDate(day),
                          style: TextStyle(fontSize: 14, color: p.muted)),
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          MoonView(
                            age: phase.age,
                            lit: phase.lit,
                            size: 84,
                            southern: city.lat < 0,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    moonPhaseName(l, phaseIndex(phase.age)),
                                    style: headingStyle(20, p.text)),
                                const SizedBox(height: 4),
                                Text(
                                  l.illuminated(formatNumber(
                                      context, (phase.lit * 100).round())),
                                  style: TextStyle(
                                      fontSize: 14, color: p.muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(l.planetsTitle,
                          style: headingStyle(16, p.text)),
                      const SizedBox(height: 10),
                      if (visible.isEmpty)
                        Text(l.tonightNoPlanets,
                            style: TextStyle(fontSize: 14, color: p.muted))
                      else
                        for (final n in visible)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: <Widget>[
                                PlanetBall(planet: planetById(n.id), size: 30),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          planetName(l, planetById(n.id)),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: p.text)),
                                      Text(
                                        '${l.bestAt(time(n.bestTime!))} · '
                                        '${l.altitudeDir(directionName(l, compassIndex(n.bestAzimuth)), formatNumber(context, n.bestAltitude.round()))}',
                                        style: TextStyle(
                                            fontSize: 13, color: p.muted),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52)),
            onPressed: _sharing ? null : _share,
            icon: _sharing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.share_outlined),
            label: Text(l.share),
          ),
        ],
      ),
    );
  }
}
