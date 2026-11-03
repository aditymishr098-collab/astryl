import 'sky.dart';

/// Data for the Moon calendar: the phase on every day of a month, the dates
/// of the four main phases and moonrise and moonset for a day. Worked out on
/// the phone, with no internet.

/// 0 new moon, 1 first quarter, 2 full moon, 3 last quarter. The Sun to Moon
/// angle at each one is `kind * 90` degrees.
class PhaseEvent {
  const PhaseEvent(this.kind, this.time);

  final int kind;

  /// The moment of the phase, in UTC.
  final DateTime time;

  /// The index [phaseIndex] gives for this phase, for its name.
  int get nameIndex => kind * 2;
}

/// The Moon on one calendar day.
class MoonDay {
  const MoonDay({
    required this.date,
    required this.age,
    required this.lit,
    this.event,
  });

  /// The day, at local midnight.
  final DateTime date;

  /// Sun to Moon angle in degrees: 0 new, 180 full.
  final double age;

  /// Lit part of the disc, 0 to 1.
  final double lit;

  /// The main phase that happens on this day, if there is one.
  final PhaseEvent? event;
}

/// Lit part of the disc at each main phase.
const List<double> _litAtPhase = <double>[0, 0.5, 1, 0.5];

/// The new moons, quarters and full moons from [from] up to [to], in order.
List<PhaseEvent> phaseEvents(DateTime from, DateTime to) {
  final out = <PhaseEvent>[];
  final end = to.toUtc();
  var t = from.toUtc();
  while (t.isBefore(end) && out.length < 12) {
    final kind = ((moonPhase(t).age ~/ 90) + 1) % 4;
    final at = nextPhase(t, kind * 90.0);
    if (!at.isBefore(end)) {
      break;
    }
    out.add(PhaseEvent(kind, at));
    t = at.add(const Duration(hours: 1));
  }
  return out;
}

/// The Moon on every day of [month] in [year]. The phase is for noon of the
/// day, except on the day of a main phase, which shows that phase exactly.
List<MoonDay> moonMonth(int year, int month) {
  final first = DateTime(year, month, 1);
  final next = DateTime(year, month + 1, 1);
  final days = DateTime(year, month + 1, 0).day;
  final events = phaseEvents(first, next);

  PhaseEvent? onDay(int d) {
    for (final e in events) {
      final local = e.time.toLocal();
      if (local.year == year && local.month == month && local.day == d) {
        return e;
      }
    }
    return null;
  }

  return <MoonDay>[
    for (var d = 1; d <= days; d++)
      () {
        final e = onDay(d);
        final date = DateTime(year, month, d);
        if (e != null) {
          return MoonDay(
              date: date,
              age: e.kind * 90.0,
              lit: _litAtPhase[e.kind],
              event: e);
        }
        final ph = moonPhase(DateTime(year, month, d, 12));
        return MoonDay(date: date, age: ph.age, lit: ph.lit);
      }(),
  ];
}

/// The Moon's first rise and set on the calendar [day] (phone time) at
/// [lat], [lon]. Either can be null on a day without one.
({DateTime? rise, DateTime? set}) moonRiseSet(
    DateTime day, double lat, double lon) {
  final start = DateTime(day.year, day.month, day.day);
  final end = DateTime(day.year, day.month, day.day + 1);
  const step = Duration(minutes: 5);
  final h = horizonFor('moon');

  double altAt(DateTime t) =>
      toHorizontal(equatorialOf('moon', t), t, lat, lon).altitude;

  DateTime? rise, set;
  var t0 = start;
  var a0 = altAt(t0);
  while (t0.isBefore(end) && (rise == null || set == null)) {
    final t1 = t0.add(step);
    final a1 = altAt(t1);
    DateTime cross() => t0.add(Duration(
        milliseconds: (step.inMilliseconds * ((h - a0) / (a1 - a0)).clamp(0.0, 1.0))
            .round()));
    if (rise == null && a0 < h && a1 >= h) {
      rise = cross();
    }
    if (set == null && a0 >= h && a1 < h) {
      set = cross();
    }
    t0 = t1;
    a0 = a1;
  }
  return (rise: rise, set: set);
}
