import 'sky.dart';

/// Sun times for one day at one place: sunrise and sunset, the golden
/// hours, the twilights and solar noon. Worked out on the phone from the
/// Sun's height in the sky, with no internet.
///
/// The "day" is the solar day of the place, from the mean solar midnight
/// before to the one after (the longitude decides it, not the phone's time
/// zone). That way a city far from the phone's own time zone still gets a
/// sunrise and a sunset that belong together. Times are returned in UTC;
/// show them with `toLocal()`.
class SunDay {
  const SunDay({
    required this.firstLight,
    required this.sunrise,
    required this.goldenMorningEnds,
    required this.solarNoon,
    required this.goldenEveningStarts,
    required this.sunset,
    required this.lastLight,
    required this.darkStarts,
    required this.darkEnds,
    required this.dayLength,
    required this.stayUp,
    required this.stayDown,
  });

  /// Civil dawn: the Sun is 6° below the horizon and climbing.
  final DateTime? firstLight;
  final DateTime? sunrise;

  /// The Sun has climbed to 6° above the horizon.
  final DateTime? goldenMorningEnds;
  final DateTime solarNoon;

  /// The Sun has dropped to 6° above the horizon.
  final DateTime? goldenEveningStarts;
  final DateTime? sunset;

  /// Civil dusk: the Sun is 6° below the horizon and sinking.
  final DateTime? lastLight;

  /// Astronomical dusk: the Sun has sunk to 18° below the horizon.
  final DateTime? darkStarts;

  /// Astronomical dawn: the Sun climbs back to 18° below the horizon.
  final DateTime? darkEnds;

  /// Time between sunrise and sunset.
  final Duration dayLength;

  /// The Sun does not set on this day (midnight sun).
  final bool stayUp;

  /// The Sun does not rise on this day (polar night).
  final bool stayDown;
}

/// Sun height in degrees at the time of each 2 minute step of a solar day.
const Duration _sunStep = Duration(minutes: 2);
const int _sunSteps = 720;

/// The Sun's height at which it counts as rising or setting.
const double _sunHorizon = -0.833;

/// Works out the sun times for the calendar [date] at [lat], [lon].
SunDay sunDay(DateTime date, double lat, double lon) {
  final start = DateTime.utc(date.year, date.month, date.day)
      .subtract(Duration(minutes: (lon * 4).round()));
  final times = <DateTime>[
    for (var i = 0; i <= _sunSteps; i++) start.add(_sunStep * i),
  ];
  final alt = <double>[
    for (final t in times)
      toHorizontal(equatorialOf('sun', t), t, lat, lon).altitude,
  ];

  DateTime at(int i, double h) {
    final f = ((h - alt[i]) / (alt[i + 1] - alt[i])).clamp(0.0, 1.0);
    return times[i].add(
        Duration(milliseconds: (_sunStep.inMilliseconds * f).round()));
  }

  // First time the Sun climbs through [h], last time it drops through it.
  DateTime? rising(double h) {
    for (var i = 0; i < _sunSteps; i++) {
      if (alt[i] < h && alt[i + 1] >= h) {
        return at(i, h);
      }
    }
    return null;
  }

  DateTime? falling(double h) {
    for (var i = _sunSteps - 1; i >= 0; i--) {
      if (alt[i] >= h && alt[i + 1] < h) {
        return at(i, h);
      }
    }
    return null;
  }

  // Solar noon: the highest point, refined with a parabola through the
  // highest step and its two neighbours.
  var top = 1;
  for (var i = 1; i < _sunSteps; i++) {
    if (alt[i] > alt[top]) {
      top = i;
    }
  }
  var noon = times[top];
  final denom = alt[top - 1] - 2 * alt[top] + alt[top + 1];
  if (denom.abs() > 1e-9) {
    final shift = 0.5 * (alt[top - 1] - alt[top + 1]) / denom;
    noon = noon.add(Duration(
        milliseconds: (_sunStep.inMilliseconds * shift.clamp(-1.0, 1.0)).round()));
  }

  final sunrise = rising(_sunHorizon);
  final sunset = falling(_sunHorizon);

  final Duration length;
  if (sunrise != null && sunset != null && sunset.isAfter(sunrise)) {
    length = sunset.difference(sunrise);
  } else {
    final above = alt.take(_sunSteps).where((a) => a >= _sunHorizon).length;
    length = _sunStep * above;
  }

  final up = alt.every((a) => a >= _sunHorizon);
  final down = alt.every((a) => a < _sunHorizon);

  return SunDay(
    firstLight: rising(-6),
    sunrise: sunrise,
    goldenMorningEnds: rising(6),
    solarNoon: noon,
    goldenEveningStarts: falling(6),
    sunset: sunset,
    lastLight: falling(-6),
    darkStarts: falling(-18),
    darkEnds: rising(-18),
    dayLength: up ? const Duration(hours: 24) : (down ? Duration.zero : length),
    stayUp: up,
    stayDown: down,
  );
}
