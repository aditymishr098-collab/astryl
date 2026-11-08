import 'dart:ui' show Locale;

import '../core/format.dart';
import '../core/sky.dart';
import '../l10n/gen/app_localizations.dart';
import '../l10n/names.dart';
import 'cities.dart';
import 'native_bridge.dart';
import 'planets.dart';

/// How many evenings are set up ahead. Android has no way to run Astryl
/// every evening, so a fortnight of notes is prepared each time the app is
/// opened.
const int tonightAlertDays = 15;

/// One evening's note.
class TonightAlert {
  const TonightAlert({
    required this.id,
    required this.at,
    required this.title,
    required this.body,
  });

  /// "tonight:0" for today, "tonight:1" for tomorrow, and so on.
  final String id;
  final DateTime at;
  final String title;
  final String body;
}

/// Planets bright enough to find without a telescope.
const List<String> _brightPlanets = <String>[
  'mercury',
  'venus',
  'mars',
  'jupiter',
  'saturn',
];

String _moonName(AppLocalizations l, int index) {
  switch (index) {
    case 0:
      return l.phaseNew;
    case 1:
      return l.phaseWaxingCrescent;
    case 2:
      return l.phaseFirstQuarter;
    case 3:
      return l.phaseWaxingGibbous;
    case 4:
      return l.phaseFull;
    case 5:
      return l.phaseWaningGibbous;
    case 6:
      return l.phaseLastQuarter;
    default:
      return l.phaseWaningCrescent;
  }
}

/// The notes for today and the days after it, in the phone's language.
/// Evenings whose time has passed are left out. [city] can be null: the note
/// then only tells about the Moon.
List<TonightAlert> buildTonightAlerts({
  required AppLocalizations l,
  required Locale locale,
  required City? city,
  required int minutes,
  required DateTime now,
  int days = tonightAlertDays,
}) {
  final soon = now.add(const Duration(minutes: 1));
  final out = <TonightAlert>[];
  for (var i = 0; i < days; i++) {
    final at = DateTime(
        now.year, now.month, now.day + i, minutes ~/ 60, minutes % 60);
    if (!at.isAfter(soon)) {
      continue;
    }
    final phase = moonPhase(at);
    final percent = (phase.lit * 100).round();
    final parts = <String>[
      l.tonightMoon(
        _moonName(l, phaseIndex(phase.age)),
        formatNumberFor(locale.toLanguageTag(), percent),
      ),
    ];
    if (city == null) {
      parts.add(l.tonightNoCity);
    } else {
      final sky = skyTonight(at, city.lat, city.lon);
      final seen = <String>[
        for (final night in sky.planets)
          if (_brightPlanets.contains(night.id) &&
              (night.visibility == SkyVisibility.evening ||
                  night.visibility == SkyVisibility.allNight))
            planetName(l, planetById(night.id)),
      ];
      parts.add(seen.isEmpty
          ? l.tonightNoPlanets
          : l.tonightPlanets(seen.join(', ')));
    }
    out.add(TonightAlert(
      id: 'tonight:$i',
      at: at,
      title: l.tonightNotifTitle,
      body: parts.join(' '),
    ));
  }
  return out;
}

/// Sets the Android alarms for [alerts], and removes the ones for evenings
/// that have no note any more.
Future<void> scheduleTonightAlerts(
  NativeBridge bridge,
  List<TonightAlert> alerts, {
  required String channel,
  int days = tonightAlertDays,
}) async {
  final have = <String>{for (final a in alerts) a.id};
  for (var i = 0; i < days; i++) {
    if (!have.contains('tonight:$i')) {
      await bridge.cancelReminder('tonight:$i');
    }
  }
  for (final a in alerts) {
    await bridge.scheduleReminder(
      id: a.id,
      at: a.at,
      title: a.title,
      body: a.body,
      channel: channel,
    );
  }
}

