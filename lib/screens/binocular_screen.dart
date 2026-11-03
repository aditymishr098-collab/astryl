import 'package:flutter/material.dart';

import '../core/daylight.dart';
import '../core/format.dart';
import '../core/sky.dart';
import '../core/starmap.dart';
import '../data/cities.dart';
import '../data/sky_catalog.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'star_map_screen.dart';

/// The dark part of the night that starts on [day] at [lat], [lon], as a start
/// and an end in UTC. In the polar summer, when the sky never gets fully dark,
/// it falls back to sunset and sunrise, and then to the hours around local
/// solar midnight.
({DateTime start, DateTime end}) nightWindow(
    DateTime day, double lat, double lon) {
  final today = sunDay(day, lat, lon);
  final next = sunDay(DateTime(day.year, day.month, day.day + 1), lat, lon);
  final dark = today.darkStarts;
  final dawn = next.darkEnds;
  if (dark != null && dawn != null && dawn.isAfter(dark)) {
    return (start: dark, end: dawn);
  }
  final set = today.sunset;
  final rise = next.sunrise;
  if (set != null && rise != null && rise.isAfter(set)) {
    return (start: set, end: rise);
  }
  final midnight = today.solarNoon.add(const Duration(hours: 12));
  return (
    start: midnight.subtract(const Duration(hours: 3)),
    end: midnight.add(const Duration(hours: 3)),
  );
}

/// How one object sits in the sky during a night.
class NightView {
  const NightView(this.time, this.position);

  /// The moment it is highest during the night.
  final DateTime time;
  final Horizontal position;

  /// High enough over the horizon to be worth looking for.
  bool get visible => position.altitude >= minUsefulAltitude;
}

/// Lowest altitude, in degrees, at which a faint object is still easy to see.
const double minUsefulAltitude = 12;

/// When [d] is highest between [start] and [end], and where it is then.
NightView bestView(
    DeepSkyData d, DateTime start, DateTime end, double lat, double lon) {
  final eq = Equatorial(d.ra, d.dec);
  DateTime bestTime = start;
  Horizontal best = toHorizontal(precessFromJ2000(eq, start), start, lat, lon);
  var t = start.add(const Duration(minutes: 20));
  while (!t.isAfter(end)) {
    final h = toHorizontal(precessFromJ2000(eq, t), t, lat, lon);
    if (h.altitude > best.altitude) {
      best = h;
      bestTime = t;
    }
    t = t.add(const Duration(minutes: 20));
  }
  return NightView(bestTime, best);
}

String _kindName(BuildContext context, int kind) {
  final l = context.l10n;
  switch (kind) {
    case 1:
      return l.dsoGalaxy;
    case 2:
      return l.dsoNebula;
    default:
      return l.dsoCluster;
  }
}

IconData _kindIcon(int kind) {
  switch (kind) {
    case 1:
      return Icons.blur_circular;
    case 2:
      return Icons.cloud_outlined;
    default:
      return Icons.scatter_plot_outlined;
  }
}

/// A short list of sights for ordinary binoculars, with where each one is
/// in the sky tonight. Tapping an object opens it on the star map.
class BinocularScreen extends StatefulWidget {
  const BinocularScreen({super.key, this.day});

  /// The night to look at, which starts on this calendar day. Tonight if null.
  final DateTime? day;

  @override
  State<BinocularScreen> createState() => _BinocularScreenState();
}

class _BinocularScreenState extends State<BinocularScreen> {
  String _key = '';
  List<(DeepSkyData, NightView)> _rows = const <(DeepSkyData, NightView)>[];

  void _compute(City city) {
    final now = DateTime.now();
    final day = widget.day ?? DateTime(now.year, now.month, now.day);
    final key = '${city.id}-${day.year}-${day.month}-${day.day}';
    if (key == _key) {
      return;
    }
    _key = key;
    final w = nightWindow(day, city.lat, city.lon);
    final rows = <(DeepSkyData, NightView)>[
      for (final d in catalogDeepSky)
        (d, bestView(d, w.start, w.end, city.lat, city.lon)),
    ]..sort((a, b) {
        // Visible objects first, the highest ones at the top.
        if (a.$2.visible != b.$2.visible) {
          return a.$2.visible ? -1 : 1;
        }
        return b.$2.position.altitude.compareTo(a.$2.position.altitude);
      });
    _rows = rows;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final city = cityById(AppScope.of(context).settings.cityId);

    if (city == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.binocularsTitle)),
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

    _compute(city);
    final loc = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.binocularsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          Text(l.binocularsIntro,
              style: TextStyle(fontSize: 14, height: 1.45, color: p.muted)),
          const SizedBox(height: 16),
          for (final (d, view) in _rows) ...<Widget>[
            _ObjectCard(
              data: d,
              view: view,
              timeText: loc.formatTimeOfDay(
                  TimeOfDay.fromDateTime(view.time.toLocal())),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) =>
                    StarMapScreen(focus: d, initialTime: view.time.toLocal()),
              )),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          Text(l.binocularsNote,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: p.muted)),
        ],
      ),
    );
  }
}

class _ObjectCard extends StatelessWidget {
  const _ObjectCard({
    required this.data,
    required this.view,
    required this.timeText,
    required this.onTap,
  });

  final DeepSkyData data;
  final NightView view;
  final String timeText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final kind = _kindName(context, data.kind);
    final title = data.name == data.id ? data.id : '${data.name} · ${data.id}';
    final dir = directionName(l, compassIndex(view.position.azimuth));
    final where = view.visible
        ? '${l.altitudeDir(dir, formatNumber(context, view.position.altitude.round()))} · ${l.bestAt(timeText)}'
        : l.statusNotVisible;
    final star = catalogConstellations
        .where((c) => c.id == data.constellation)
        .map((c) => c.nameFor(Localizations.localeOf(context).languageCode))
        .firstOrNull;
    final magnitude =
        l.magnitudeValue(formatNumber(context, data.mag, decimals: 1));

    return Semantics(
      button: true,
      label: '$title, $kind, $where',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              Icon(_kindIcon(data.kind),
                  color: view.visible ? p.accentText : p.muted),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: p.text)),
                    const SizedBox(height: 2),
                    Text(
                      star == null
                          ? '$kind · $magnitude'
                          : '$kind · $star · $magnitude',
                      style: TextStyle(fontSize: 13, color: p.muted),
                    ),
                    const SizedBox(height: 4),
                    Text(where,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: view.visible ? p.accentText : p.muted)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: p.muted),
            ],
          ),
        ),
      ),
    );
  }
}
