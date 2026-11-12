import 'dart:math' as math;

import 'eclipses.dart';
import 'orbits.dart';
import 'sky.dart';

/// Space events for the "Space events" screen: Moon phases, oppositions,
/// greatest elongations, close meetings of planets, equinoxes, solstices,
/// meteor shower peaks and eclipses. All of it is worked out on the phone from the same
/// orbits as the rest of the app, with no internet.

enum SpaceEventKind {
  fullMoon,
  newMoon,
  opposition,
  eveningElongation,
  morningElongation,
  conjunction,
  marchEquinox,
  juneSolstice,
  septemberEquinox,
  decemberSolstice,
  meteorShower,
  lunarEclipse,
  solarEclipse,
}

class SpaceEvent {
  const SpaceEvent({
    required this.kind,
    required this.time,
    this.bodies = const <String>[],
    this.value = 0,
    this.extra = 0,
  });

  final SpaceEventKind kind;

  /// The moment of the event (UTC). Meteor showers use noon on the peak date
  /// of the phone's time zone.
  final DateTime time;

  /// Planet ids, or the shower id for a meteor shower.
  final List<String> bodies;

  /// Degrees (elongation or distance between planets) or meteors per hour.
  final double value;

  /// For meteor showers: how much of the Moon is lit on the peak night, 0 to 1.
  final double extra;

  /// Stays the same every time the list is worked out again.
  String get id {
    final t = time.toUtc();
    final m = t.month.toString().padLeft(2, '0');
    final d = t.day.toString().padLeft(2, '0');
    return '${kind.name}:${bodies.join('+')}:${t.year}$m$d';
  }

  /// The eclipse behind a lunar or solar eclipse event, null for others.
  Eclipse? get eclipse {
    if (kind != SpaceEventKind.lunarEclipse &&
        kind != SpaceEventKind.solarEclipse) {
      return null;
    }
    var type = EclipseType.partial;
    for (final t in EclipseType.values) {
      if (bodies.isNotEmpty && t.name == bodies[0]) {
        type = t;
      }
    }
    return Eclipse(
      lunar: kind == SpaceEventKind.lunarEclipse,
      time: time,
      type: type,
      magnitude: value,
    );
  }

  /// The day of the event in the phone's time zone, without the time.
  DateTime get localDay {
    final t = time.toLocal();
    return DateTime(t.year, t.month, t.day);
  }
}

double _rad(double d) => d * math.pi / 180;
double _deg(double r) => r * 180 / math.pi;

/// [d] wrapped to -180 (exclusive) .. 180 (inclusive).
double _signed(double d) {
  var v = d % 360;
  if (v > 180) {
    v -= 360;
  }
  return v;
}

/// Geocentric ecliptic longitude of a planet, in degrees.
double _geoLongitude(String id, DateTime t) {
  final d = clampOrbitDate(t);
  final earth = heliocentricPosition('earth', d);
  final p = heliocentricPosition(id, d);
  return (_deg(math.atan2(p.y - earth.y, p.x - earth.x))) % 360;
}

/// The Sun's longitude measured from the equinox of the date, which is what
/// equinoxes and solstices are defined by. The orbits use the J2000 equinox,
/// which has moved by about 0.014 degrees a year since.
double _sunLongitudeOfDate(DateTime t) =>
    sunLongitude(t) + 0.013970 * (julianDay(t) - 2451545.0) / 365.25;

/// Angle in degrees between two directions in the sky.
double _angle(Equatorial a, Equatorial b) {
  final ar = _rad(a.ra), ad = _rad(a.dec);
  final br = _rad(b.ra), bd = _rad(b.dec);
  final c = math.sin(ad) * math.sin(bd) +
      math.cos(ad) * math.cos(bd) * math.cos(ar - br);
  return _deg(math.acos(c.clamp(-1.0, 1.0).toDouble()));
}

DateTime _at(int ms) => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);

/// The moment between [a] and [b] where [f] changes sign.
DateTime _crossing(double Function(DateTime) f, DateTime a, DateTime b) {
  var lo = a.millisecondsSinceEpoch;
  var hi = b.millisecondsSinceEpoch;
  final startPositive = f(a) > 0;
  for (var i = 0; i < 28; i++) {
    final mid = lo + (hi - lo) ~/ 2;
    if ((f(_at(mid)) > 0) == startPositive) {
      lo = mid;
    } else {
      hi = mid;
    }
  }
  return _at(lo + (hi - lo) ~/ 2);
}

/// The moment between [a] and [b] where [f] is smallest.
DateTime _lowest(double Function(DateTime) f, DateTime a, DateTime b) {
  var lo = a.millisecondsSinceEpoch;
  var hi = b.millisecondsSinceEpoch;
  for (var i = 0; i < 40; i++) {
    final third = (hi - lo) ~/ 3;
    final m1 = lo + third;
    final m2 = hi - third;
    if (f(_at(m1)) < f(_at(m2))) {
      hi = m2;
    } else {
      lo = m1;
    }
  }
  return _at(lo + (hi - lo) ~/ 2);
}

const List<String> _oppositionPlanets = <String>[
  'mars',
  'jupiter',
  'saturn',
  'uranus',
  'neptune',
];

const List<String> _brightPlanets = <String>[
  'mercury',
  'venus',
  'mars',
  'jupiter',
  'saturn',
];

/// Planets closer than this count as a close meeting.
const double conjunctionLimit = 2.0;

/// A planet nearer the Sun than this in the sky is lost in its glare.
const double _glareLimit = 15.0;

/// Typical yearly peaks: id, month, day, meteors per hour on a dark night.
const List<(String, int, int, int)> meteorShowers = <(String, int, int, int)>[
  ('quadrantids', 1, 3, 110),
  ('lyrids', 4, 22, 18),
  ('etaAquariids', 5, 6, 50),
  ('perseids', 8, 12, 100),
  ('orionids', 10, 21, 20),
  ('leonids', 11, 17, 15),
  ('geminids', 12, 14, 150),
  ('ursids', 12, 22, 10),
];

/// All events from the start of [from]'s day (phone time) for [days] days,
/// earliest first.
List<SpaceEvent> computeSpaceEvents(DateTime from, {int days = 366}) {
  final local = from.toLocal();
  final firstDay = DateTime(local.year, local.month, local.day);
  final lastDay = DateTime(local.year, local.month, local.day + days);
  final begin = firstDay.toUtc();
  final end = lastDay.toUtc();

  // One sample a day, with a day of margin on both sides.
  final start = begin.subtract(const Duration(days: 1));
  final n = days + 3;
  final ts = <DateTime>[
    for (var i = 0; i < n; i++) start.add(Duration(days: i)),
  ];
  final out = <SpaceEvent>[];

  // Oppositions: the planet is opposite the Sun in longitude.
  final sunLon = <double>[for (final t in ts) sunLongitude(t)];
  for (final id in _oppositionPlanets) {
    double g(DateTime t) => _signed(_geoLongitude(id, t) - sunLongitude(t) - 180);
    final gs = <double>[
      for (var i = 0; i < n; i++)
        _signed(_geoLongitude(id, ts[i]) - sunLon[i] - 180),
    ];
    for (var i = 0; i < n - 1; i++) {
      if (gs[i] > 0 && gs[i + 1] <= 0 && gs[i] < 90) {
        out.add(SpaceEvent(
          kind: SpaceEventKind.opposition,
          time: _crossing(g, ts[i], ts[i + 1]),
          bodies: <String>[id],
        ));
      }
    }
  }

  // Equinoxes and solstices.
  const seasons = <(double, SpaceEventKind)>[
    (0.0, SpaceEventKind.marchEquinox),
    (90.0, SpaceEventKind.juneSolstice),
    (180.0, SpaceEventKind.septemberEquinox),
    (270.0, SpaceEventKind.decemberSolstice),
  ];
  for (final (target, kind) in seasons) {
    double f(DateTime t) => _signed(_sunLongitudeOfDate(t) - target);
    var prev = f(ts[0]);
    for (var i = 0; i < n - 1; i++) {
      final next = f(ts[i + 1]);
      if (prev < 0 && next >= 0 && prev > -90) {
        out.add(SpaceEvent(kind: kind, time: _crossing(f, ts[i], ts[i + 1])));
      }
      prev = next;
    }
  }

  // One sample a day of where the bright planets and the Sun are.
  final sun = <Equatorial>[for (final t in ts) equatorialOf('sun', t)];
  final eq = <String, List<Equatorial>>{
    for (final id in _brightPlanets)
      id: <Equatorial>[for (final t in ts) equatorialOf(id, t)],
  };

  // Greatest elongation of Mercury and Venus.
  for (final id in <String>['mercury', 'venus']) {
    final el = <double>[
      for (var i = 0; i < n; i++) _angle(eq[id]![i], sun[i]),
    ];
    double far(DateTime t) =>
        -_angle(equatorialOf(id, t), equatorialOf('sun', t));
    for (var i = 1; i < n - 1; i++) {
      if (el[i - 1] < el[i] && el[i] >= el[i + 1]) {
        final t = _lowest(far, ts[i - 1], ts[i + 1]);
        final evening = _signed(_geoLongitude(id, t) - sunLongitude(t)) > 0;
        out.add(SpaceEvent(
          kind: evening
              ? SpaceEventKind.eveningElongation
              : SpaceEventKind.morningElongation,
          time: t,
          bodies: <String>[id],
          value: -far(t),
        ));
      }
    }
  }

  // Close meetings of two bright planets.
  for (var a = 0; a < _brightPlanets.length; a++) {
    for (var b = a + 1; b < _brightPlanets.length; b++) {
      final ida = _brightPlanets[a], idb = _brightPlanets[b];
      final sep = <double>[
        for (var i = 0; i < n; i++) _angle(eq[ida]![i], eq[idb]![i]),
      ];
      double apart(DateTime t) =>
          _angle(equatorialOf(ida, t), equatorialOf(idb, t));
      for (var i = 1; i < n - 1; i++) {
        if (sep[i - 1] > sep[i] && sep[i] <= sep[i + 1]) {
          final t = _lowest(apart, ts[i - 1], ts[i + 1]);
          final s = apart(t);
          final sunEq = equatorialOf('sun', t);
          if (s < conjunctionLimit &&
              _angle(equatorialOf(ida, t), sunEq) > _glareLimit &&
              _angle(equatorialOf(idb, t), sunEq) > _glareLimit) {
            out.add(SpaceEvent(
              kind: SpaceEventKind.conjunction,
              time: t,
              bodies: <String>[ida, idb],
              value: s,
            ));
          }
        }
      }
    }
  }

  // Moon phases.
  for (final (target, kind) in <(double, SpaceEventKind)>[
    (180.0, SpaceEventKind.fullMoon),
    (0.0, SpaceEventKind.newMoon),
  ]) {
    var t = begin;
    for (var i = 0; i < 20; i++) {
      t = nextPhase(t, target);
      if (!t.isBefore(end)) {
        break;
      }
      out.add(SpaceEvent(kind: kind, time: t));
      t = t.add(const Duration(days: 1));
    }
  }

  // Meteor shower peaks, dated in the phone's time zone.
  for (var year = local.year; year <= lastDay.year; year++) {
    for (final (id, month, day, rate) in meteorShowers) {
      final noon = DateTime(year, month, day, 12);
      final night = DateTime(year, month, day, 23);
      if (noon.isBefore(firstDay) || !noon.isBefore(lastDay)) {
        continue;
      }
      out.add(SpaceEvent(
        kind: SpaceEventKind.meteorShower,
        time: noon.toUtc(),
        bodies: <String>[id],
        value: rate.toDouble(),
        extra: moonPhase(night.toUtc()).lit,
      ));
    }
  }

  // Eclipses: the type goes in bodies, the magnitude in value.
  for (final e in computeEclipses(begin, end)) {
    out.add(SpaceEvent(
      kind: e.lunar ? SpaceEventKind.lunarEclipse : SpaceEventKind.solarEclipse,
      time: e.time,
      bodies: <String>[e.type.name],
      value: e.magnitude,
    ));
  }

  final result = <SpaceEvent>[
    for (final e in out)
      if (!e.localDay.isBefore(firstDay) && e.localDay.isBefore(lastDay)) e,
  ]..sort((a, b) => a.time.compareTo(b.time));
  return result;
}

List<SpaceEvent>? _cached;
String _cachedKey = '';

/// [computeSpaceEvents] for today, worked out once a day.
List<SpaceEvent> upcomingEvents([DateTime? now]) {
  final t = (now ?? DateTime.now()).toLocal();
  final key = '${t.year}-${t.month}-${t.day}';
  if (_cached == null || _cachedKey != key) {
    _cached = computeSpaceEvents(t);
    _cachedKey = key;
  }
  return _cached!;
}

/// Whole days from [now]'s date to the local date of [event].
int daysUntil(SpaceEvent event, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final day = event.localDay;
  return DateTime.utc(day.year, day.month, day.day)
      .difference(DateTime.utc(today.year, today.month, today.day))
      .inDays;
}

/// When to remind about [event]: 18:00 the evening before, or 08:00 on the
/// day itself when the evening before has passed. Null when both are over.
DateTime? reminderTime(SpaceEvent event, DateTime now) {
  final day = event.localDay;
  final soon = now.add(const Duration(minutes: 1));
  final evening = DateTime(day.year, day.month, day.day - 1, 18);
  if (evening.isAfter(soon)) {
    return evening;
  }
  final morning = DateTime(day.year, day.month, day.day, 8);
  if (morning.isAfter(soon)) {
    return morning;
  }
  return null;
}
