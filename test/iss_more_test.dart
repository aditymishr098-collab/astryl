import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/core/iss.dart';
import 'package:heliora/core/sgp4.dart';

const _iss1 =
    '1 25544U 98067A   26300.50000000  .00016717  00000-0  10270-3 0  9991';
const _iss2 =
    '2 25544  51.6400 120.0000 0005000  90.0000 270.0000 15.50000000400009';

void main() {
  group('space station extras', () {
    test('passes on a background isolate match the direct ones', () async {
      final sat = Sgp4.fromTle(_iss1, _iss2);
      final direct = findIssPasses(sat, sat.epoch, 40.18, 44.51);
      final background =
          await findIssPassesInBackground(sat, sat.epoch, 40.18, 44.51);
      expect(background.map((p) => p.id), direct.map((p) => p.id));
    });

    test('the Sun is overhead near the equator at the equinox', () {
      // March equinox 2026: 20 March, 14:46 UTC.
      final sun = subsolarPoint(DateTime.utc(2026, 3, 20, 14, 46));
      expect(sun.lat.abs(), lessThan(0.1));
      // Near noon at Greenwich the Sun is over longitude 0 (within the
      // equation of time).
      final noon = subsolarPoint(DateTime.utc(2026, 6, 21, 12));
      expect(noon.lon.abs(), lessThan(5));
      expect(noon.lat, closeTo(23.44, 0.1));
    });

    test('the day-night line is 90 degrees from the Sun', () {
      final sun = subsolarPoint(DateTime.utc(2026, 6, 21, 12));
      // At the Sun's own longitude the line is far south (polar day north).
      expect(terminatorLatitude(sun.lon, sun), closeTo(-66.56, 0.2));
      // Opposite, it is far north.
      expect(terminatorLatitude(sun.lon + 180, sun), closeTo(66.56, 0.2));
      // A quarter turn away it crosses the equator.
      expect(terminatorLatitude(sun.lon + 90, sun).abs(), lessThan(0.01));
    });

    test('sunlight and shadow both happen in one orbit', () {
      final sat = Sgp4.fromTle(_iss1, _iss2);
      var lit = 0, dark = 0;
      for (var m = 0; m < 93; m++) {
        if (satelliteSunlit(sat, sat.epoch.add(Duration(minutes: m)))) {
          lit++;
        } else {
          dark++;
        }
      }
      expect(lit, greaterThan(40));
      expect(dark, greaterThan(15));
    });
  });
}
