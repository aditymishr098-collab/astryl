import 'sky.dart';

/// "My birthday sky": the Moon and day counts for a birth date.

/// A round number in a life: the [days]th day, or one billion seconds when
/// [days] is null.
class LifeMilestone {
  const LifeMilestone({required this.days, required this.date});

  final int? days;

  /// The calendar day in the phone's time zone.
  final DateTime date;
}

/// Days from the birth date to [now], counting the birth day as day 0.
int daysOld(DateTime birth, DateTime now) {
  final b = DateTime.utc(birth.year, birth.month, birth.day);
  final n = DateTime.utc(now.year, now.month, now.day);
  return n.difference(b).inDays;
}

/// Day counts that are celebrated.
const List<int> milestoneDays = <int>[1000, 5000, 10000, 15000, 20000, 25000, 30000];

/// The milestones of a life, earliest first, with one billion seconds
/// (about 31.7 years) among them.
List<LifeMilestone> lifeMilestones(DateTime birth) {
  final start = DateTime(birth.year, birth.month, birth.day);
  final billion = DateTime(birth.year, birth.month, birth.day, 12)
      .add(const Duration(seconds: 1000000000));
  final out = <LifeMilestone>[
    for (final d in milestoneDays)
      LifeMilestone(
          days: d, date: DateTime(start.year, start.month, start.day + d)),
    LifeMilestone(
        days: null, date: DateTime(billion.year, billion.month, billion.day)),
  ]..sort((a, b) => a.date.compareTo(b.date));
  return out;
}

/// The Moon at noon on the birth day: age (0 new, 180 full) and lit part.
({double age, double lit}) moonOnBirthday(DateTime birth) =>
    moonPhase(DateTime(birth.year, birth.month, birth.day, 12));
