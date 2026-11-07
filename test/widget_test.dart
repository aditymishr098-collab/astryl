import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/core/birthday.dart';
import 'package:heliora/core/daylight.dart';
import 'package:heliora/core/eclipses.dart';
import 'package:heliora/core/events.dart';
import 'package:heliora/core/facts.dart';
import 'package:heliora/core/finder.dart';
import 'package:heliora/core/format.dart';
import 'package:heliora/core/habitability.dart';
import 'package:heliora/core/iss.dart';
import 'package:heliora/core/moon_calendar.dart';
import 'package:heliora/core/orbits.dart';
import 'package:heliora/core/sgp4.dart';
import 'package:heliora/core/sky.dart';
import 'package:heliora/core/spacecraft.dart';
import 'package:heliora/core/starmap.dart';
import 'package:heliora/data/backup.dart';
import 'package:heliora/data/cities.dart';
import 'package:heliora/data/favorites.dart';
import 'package:heliora/data/missions.dart';
import 'package:heliora/data/sky_catalog.dart';
import 'package:heliora/data/tonight_alerts.dart';
import 'package:heliora/l10n/gen/app_localizations.dart';
import 'package:heliora/data/build_flavor.dart' show inAppUpdates;
import 'package:heliora/l10n/names.dart'
    show appLanguages, constellationStory, languageName;
import 'package:heliora/core/quiz.dart';
import 'package:heliora/core/version.dart';
import 'package:heliora/data/online_service.dart';
import 'package:heliora/data/planets.dart';
import 'package:heliora/data/settings.dart';
import 'package:heliora/data/update_service.dart';
import 'package:heliora/screens/binocular_screen.dart' show bestView, nightWindow;
import 'package:heliora/screens/events_screen.dart' show launchReminderTime;
import 'package:heliora/screens/reminder_actions.dart' show isEventReminder;
import 'package:heliora/widgets/common.dart' show BigStat, IconStatTile, InfoRow, StatGrid, StatPanel;

void main() {
  group('planet data', () {
    test('eight planets in order', () {
      expect(planets.length, 8);
      for (var i = 0; i < planets.length; i++) {
        expect(planets[i].order, i + 1);
      }
    });

    test('atmospheres add up to about 100%', () {
      for (final planet in allBodies.where((b) => b.atmosphere.isNotEmpty)) {
        final total =
            planet.atmosphere.fold<double>(0, (sum, s) => sum + s.percent);
        expect(total, closeTo(100, 1.5), reason: planet.id);
      }
    });

    test('oxygen and breathing', () {
      expect(planetById('earth').oxygenPercent, 20.95);
      expect(planetById('mars').oxygenPercent, 0.16);
      expect(planetById('jupiter').oxygenPercent, 0);
      expect(planets.where((p) => p.breathable).map((p) => p.id), ['earth']);
    });

    test('weight on Mars', () {
      expect(planetById('mars').weightFor(70), closeTo(26.4, 0.1));
      expect(planetById('earth').weightFor(70), closeTo(70, 0.001));
    });

    test('unknown id falls back to Earth', () {
      expect(planetById('vulcan').id, 'earth');
    });

    test('Sun, Pluto and moons', () {
      expect(allBodies.length, 18);
      expect(allBodies.map((b) => b.id).toSet().length, 18);
      expect(planetById('sun').isStar, isTrue);
      expect(planetById('pluto').kind, BodyKind.dwarf);
      expect(moonsOf('jupiter').map((m) => m.id),
          <String>['io', 'europa', 'ganymede', 'callisto']);
      expect(moonsOf('earth').single.id, 'moon');
      for (final moon in allBodies.where((b) => b.isMoon)) {
        expect(planets.any((p) => p.id == moon.parentId), isTrue,
            reason: moon.id);
      }
    });
  });

  group('life score', () {
    test('Earth is 10 and the rest are lower', () {
      expect(lifeScore(planetById('earth')).total, 10);
      for (final body in allBodies.where((b) => b.id != 'earth')) {
        expect(lifeScore(body).total, lessThan(10), reason: body.id);
      }
    });

    test('known scores', () {
      expect(lifeScore(planetById('mars')).total, 4);
      expect(lifeScore(planetById('venus')).total, 2);
      expect(lifeScore(planetById('titan')).total, 4);
      expect(lifeScore(planetById('moon')).total, 3);
      expect(lifeScore(planetById('jupiter')).total, 0);
      expect(lifeScore(planetById('sun')).total, 0);
    });

    test('Mercury gets no oxygen points from its exosphere', () {
      final oxygen = lifeScore(planetById('mercury'))
          .factors
          .firstWhere((f) => f.factor == LifeFactor.oxygen);
      expect(oxygen.points, 0);
    });
  });

  group('quiz', () {
    test('answers come from the data', () {
      expect(answerFor(QuizKind.largest).id, 'jupiter');
      expect(answerFor(QuizKind.smallest).id, 'mercury');
      expect(answerFor(QuizKind.hottest).id, 'venus');
      expect(answerFor(QuizKind.coldest).id, 'neptune');
      expect(answerFor(QuizKind.mostMoons).id, 'saturn');
      expect(answerFor(QuizKind.breathable).id, 'earth');
      expect(answerFor(QuizKind.closest).id, 'mercury');
      expect(answerFor(QuizKind.farthest).id, 'neptune');
      expect(answerFor(QuizKind.strongestGravity).id, 'jupiter');
      expect(answerFor(QuizKind.shortestDay).id, 'jupiter');
      expect(answerFor(QuizKind.longestDay).id, 'mercury');
    });

    test('ten different questions with four options', () {
      final quiz = buildQuiz(random: Random(1));
      expect(quiz.length, 10);
      expect(quiz.map((q) => q.kind).toSet().length, 10);
      for (final q in quiz) {
        expect(q.options.length, 4);
        expect(q.options.map((p) => p.id).toSet().length, 4);
        expect(q.options.any((p) => p.id == q.answer.id), isTrue);
      }
    });

    test('moon and ranking answers come from the data', () {
      const expected = <QuizKind, String>{
        QuizKind.star: 'sun',
        QuizKind.dwarf: 'pluto',
        QuizKind.moonVisited: 'moon',
        QuizKind.largestMoon: 'ganymede',
        QuizKind.smallestMoon: 'enceladus',
        QuizKind.thickAirMoon: 'titan',
        QuizKind.geyserMoon: 'enceladus',
        QuizKind.volcanicMoon: 'io',
        QuizKind.backwardsMoon: 'triton',
        QuizKind.biggestRocky: 'earth',
        QuizKind.coldestRocky: 'mars',
        QuizKind.highestPressure: 'venus',
        QuizKind.secondLargest: 'saturn',
        QuizKind.longestYear: 'neptune',
        QuizKind.shortestYear: 'mercury',
        QuizKind.smallestGiant: 'neptune',
        QuizKind.rockyLongestYear: 'mars',
        QuizKind.fastestMoon: 'enceladus',
        QuizKind.slowestMoon: 'moon',
        QuizKind.strongestMoonGravity: 'io',
        QuizKind.coldestMoon: 'triton',
        QuizKind.secondLargestMoon: 'titan',
      };
      for (final entry in expected.entries) {
        expect(answerFor(entry.key).id, entry.value, reason: '${entry.key}');
      }
    });

    test('every question has an answer and a level', () {
      final seen = <QuizKind>{};
      for (final level in QuizLevel.values) {
        seen.addAll(kindsOf(level));
        expect(kindsOf(level).length, greaterThanOrEqualTo(10));
      }
      expect(seen.length, QuizKind.values.length);
      expect(levelOf(QuizKind.largest), QuizLevel.easy);
      expect(levelOf(QuizKind.longestDay), QuizLevel.medium);
      expect(levelOf(QuizKind.secondLargestMoon), QuizLevel.hard);
    });

    test('each level gives ten fair questions', () {
      for (final level in QuizLevel.values) {
        for (var seed = 0; seed < 20; seed++) {
          final quiz = buildQuiz(level: level, random: Random(seed));
          expect(quiz.length, 10);
          expect(quiz.map((q) => q.kind).toSet().length, 10);
          for (final q in quiz) {
            expect(levelOf(q.kind), level);
            expect(q.options.length, 4);
            expect(q.options.map((b) => b.id).toSet().length, 4);
            expect(q.options.any((b) => b.id == q.answer.id), isTrue);
            expect(q.answer.id, answerFor(q.kind).id);
            switch (q.kind) {
              case QuizKind.biggestRocky:
              case QuizKind.coldestRocky:
              case QuizKind.rockyLongestYear:
                expect(q.options.every((b) => b.order <= 4 && !b.isMoon), isTrue);
              case QuizKind.smallestGiant:
                expect(q.options.every((b) => b.order >= 5 && !b.isMoon), isTrue);
              case QuizKind.geyserMoon:
                expect(q.options.every((b) => b.isMoon && b.id != 'europa'),
                    isTrue);
              case QuizKind.largestMoon:
              case QuizKind.smallestMoon:
              case QuizKind.thickAirMoon:
              case QuizKind.volcanicMoon:
              case QuizKind.backwardsMoon:
              case QuizKind.moonVisited:
              case QuizKind.fastestMoon:
              case QuizKind.slowestMoon:
              case QuizKind.strongestMoonGravity:
              case QuizKind.coldestMoon:
              case QuizKind.secondLargestMoon:
                expect(q.options.every((b) => b.isMoon), isTrue);
              default:
                break;
            }
          }
        }
      }
    });
  });

  group('facts and jumps', () {
    test('every world has facts and every day has one', () {
      expect(factBodyIds.toSet(), allBodies.map((b) => b.id).toSet());
      for (final id in factBodyIds) {
        expect(planetById(id).id, id);
      }
      final seen = <String>{};
      final start = DateTime(2026, 10, 29);
      for (var i = 0; i < factBodyIds.length * factsPerBody; i++) {
        final f = factOfTheDay(start.add(Duration(days: i)));
        expect(f.index, inInclusiveRange(0, factsPerBody - 1));
        seen.add('${f.bodyId}:${f.index}');
      }
      expect(seen.length, factBodyIds.length * factsPerBody);
      expect(factOfTheDay(DateTime(2026, 10, 29, 3)),
          factOfTheDay(DateTime(2026, 10, 29, 23)));
      expect(factOfTheDay(DateTime(2010, 5, 5)).bodyId, isNotEmpty);
    });

    test('jump height follows gravity', () {
      expect(jumpHeightCm(40, 1), 40);
      expect(jumpHeightCm(40, planetById('moon').relativeGravity),
          closeTo(242, 1));
      expect(jumpHeightCm(40, planetById('jupiter').relativeGravity),
          lessThan(40));
      expect(jumpHeightCm(40, 0), 0);
    });
  });

  group('real positions', () {
    test('Earth at J2000 and at the March equinox', () {
      expect(heliocentricLongitude('earth', DateTime.utc(2000, 1, 1, 12)),
          closeTo(100.4, 0.5));
      expect(heliocentricLongitude('earth', DateTime.utc(2026, 3, 20, 15)),
          closeTo(180, 1));
    });

    test('planets line up with Earth at opposition', () {
      double gap(String id, DateTime d) {
        final diff = (heliocentricLongitude(id, d) -
                    heliocentricLongitude('earth', d))
                .abs() %
            360;
        return diff > 180 ? 360 - diff : diff;
      }

      expect(gap('mars', DateTime.utc(2025, 1, 16)), lessThan(2));
      expect(gap('jupiter', DateTime.utc(2026, 1, 10)), lessThan(2));
      expect(gap('saturn', DateTime.utc(2025, 9, 21)), lessThan(2));
    });

    test('every planet has an orbit and dates are kept in range', () {
      for (final planet in planets) {
        expect(hasOrbit(planet.id), isTrue, reason: planet.id);
      }
      expect(hasOrbit('moon'), isFalse);
      expect(clampOrbitDate(DateTime.utc(1700)), orbitMinDate);
      expect(clampOrbitDate(DateTime.utc(2100)), orbitMaxDate);
    });

    test('distance from Earth matches known dates', () {
      // Mars was closest on 12 Jan 2025, about 96 million km away.
      expect(distanceFromEarthKm('mars', DateTime.utc(2025, 1, 12)) / 1e6,
          closeTo(96, 1.5));
      // Earth is closest to the Sun in early January, about 147.1 million km.
      expect(distanceFromEarthKm('sun', DateTime.utc(2026, 1, 3)) / 1e6,
          closeTo(147.1, 0.3));
    });

    test('age on other planets', () {
      final birth = DateTime.utc(2000, 1, 1);
      final now = DateTime.utc(2020, 1, 1);
      expect(ageOn(birth, now, 365.25), closeTo(20, 0.01));
      expect(ageOn(birth, now, 88), closeTo(83, 0.1));
      final days = daysToNextBirthday(birth, now, 88);
      expect(days, greaterThan(0));
      expect(days, lessThanOrEqualTo(88));
    });
  });

  group('tonight sky', () {
    Matcher near(DateTime expected, int minutes) => predicate<DateTime>(
        (t) => t.difference(expected).inMinutes.abs() <= minutes,
        'within $minutes minutes of $expected');

    test('London sunrise and sunset on 21 June 2025', () {
      final s = sunRiseSet(DateTime.utc(2025, 6, 21), 51.5074, -0.1278);
      expect(s.rise, near(DateTime.utc(2025, 6, 21, 3, 43), 3));
      expect(s.set, near(DateTime.utc(2025, 6, 21, 20, 21), 3));
    });

    test('full and new moon dates', () {
      expect(nextPhase(DateTime.utc(2025, 10, 1), 180),
          near(DateTime.utc(2025, 10, 7, 3, 47), 30));
      expect(nextPhase(DateTime.utc(2025, 10, 10), 0),
          near(DateTime.utc(2025, 10, 21, 12, 25), 30));
      expect(nextPhase(DateTime.utc(2025, 12, 25), 180),
          near(DateTime.utc(2026, 1, 3, 10, 3), 30));
    });

    test('phase names and lit part', () {
      final full = moonPhase(DateTime.utc(2025, 10, 7, 3, 47));
      expect(phaseIndex(full.age), 4);
      expect(full.lit, greaterThan(0.98));
      final fresh = moonPhase(DateTime.utc(2025, 10, 21, 12, 25));
      expect(phaseIndex(fresh.age), 0);
      expect(fresh.lit, lessThan(0.02));
    });

    test('compass directions', () {
      expect(compassIndex(0), 0);
      expect(compassIndex(90), 2);
      expect(compassIndex(181), 4);
      expect(compassIndex(350), 0);
      expect(compassIndex(300), 7);
    });

    test('a night in Yerevan gives every planet', () {
      final city = cityById('yerevan')!;
      final sky = skyTonight(DateTime(2026, 1, 10), city.lat, city.lon);
      expect(sky.planets.length, 7);
      expect(sky.sunset, isNotNull);
      final jupiter = sky.planets.firstWhere((n) => n.id == 'jupiter');
      // Jupiter was opposite the Sun that night, up all night.
      expect(jupiter.visibility, SkyVisibility.allNight);
    });

    test('city ids are unique', () {
      expect(cities.map((c) => c.id).toSet().length, cities.length);
    });
  });

  group('compass finder', () {
    test('turn angle takes the short way round', () {
      expect(turnAngle(350, 10), closeTo(20, 1e-9));
      expect(turnAngle(10, 350), closeTo(-20, 1e-9));
      expect(turnAngle(90, 90), 0);
      expect(turnAngle(0, 180).abs(), closeTo(180, 1e-9));
    });

    test('guidance says which way to move', () {
      final g = guide(
        phoneAzimuth: 100,
        phoneAltitude: 10,
        targetAzimuth: 130,
        targetAltitude: 40,
      );
      expect(g.turn, greaterThan(0));
      expect(g.tilt, closeTo(30, 1e-9));
      expect(g.onTarget, isFalse);
      final back = guide(
        phoneAzimuth: 130,
        phoneAltitude: 60,
        targetAzimuth: 100,
        targetAltitude: 40,
      );
      expect(back.turn, lessThan(0));
      expect(back.tilt, closeTo(-20, 1e-9));
    });

    test('pointing at the target counts as found', () {
      final g = guide(
        phoneAzimuth: 200,
        phoneAltitude: 30,
        targetAzimuth: 203,
        targetAltitude: 32,
      );
      expect(g.onTarget, isTrue);
    });

    test('turns shrink near the zenith', () {
      final low = guide(
        phoneAzimuth: 0,
        phoneAltitude: 0,
        targetAzimuth: 40,
        targetAltitude: 0,
      );
      final high = guide(
        phoneAzimuth: 0,
        phoneAltitude: 80,
        targetAzimuth: 40,
        targetAltitude: 80,
      );
      expect(high.turn.abs(), lessThan(low.turn.abs() / 4));
    });

    test('smoother averages 359 and 1 degrees to north', () {
      final sm = DirectionSmoother(factor: 0.5);
      sm.add(359, 20);
      final r = sm.add(1, 20);
      final az = r.azimuth > 180 ? r.azimuth - 360 : r.azimuth;
      expect(az.abs(), lessThan(1));
      expect(r.altitude, closeTo(20, 1e-9));
    });
  });

  group('space events', () {
    final events = computeSpaceEvents(DateTime(2025, 1, 1), days: 731);

    SpaceEvent find(SpaceEventKind kind, [String? body]) => events.firstWhere(
          (e) =>
              e.kind == kind && (body == null || e.bodies.join('+') == body),
        );

    bool near(SpaceEvent e, DateTime utc, {int hours = 30}) =>
        e.time.difference(utc).inHours.abs() <= hours;

    test('events are in order and have their own ids', () {
      for (var i = 1; i < events.length; i++) {
        expect(events[i].time.isBefore(events[i - 1].time), isFalse);
      }
      final ids = events.map((e) => e.id).toSet();
      expect(ids.length, events.length);
    });

    test('oppositions match real dates', () {
      final mars = find(SpaceEventKind.opposition, 'mars');
      expect(near(mars, DateTime.utc(2025, 1, 16, 3)), isTrue);
      final saturn = find(SpaceEventKind.opposition, 'saturn');
      expect(near(saturn, DateTime.utc(2025, 9, 21, 8)), isTrue);
      final jupiter = events.firstWhere((e) =>
          e.kind == SpaceEventKind.opposition &&
          e.bodies.first == 'jupiter' &&
          e.time.year == 2026);
      expect(near(jupiter, DateTime.utc(2026, 1, 10, 8)), isTrue);
    });

    test('Venus is farthest from the Sun in the evening of 15 Aug 2026', () {
      final venus = events.firstWhere((e) =>
          e.kind == SpaceEventKind.eveningElongation &&
          e.bodies.first == 'venus' &&
          e.time.year == 2026);
      expect(near(venus, DateTime.utc(2026, 8, 15, 6)), isTrue);
      expect(venus.value, closeTo(45.9, 0.4));
    });

    test('Venus and Jupiter meet on 12 Aug 2025', () {
      final meet = find(SpaceEventKind.conjunction, 'venus+jupiter');
      expect(near(meet, DateTime.utc(2025, 8, 12, 6)), isTrue);
      expect(meet.value, lessThan(1.2));
    });

    test('seasons match the real minute within half an hour', () {
      final march = events.firstWhere((e) =>
          e.kind == SpaceEventKind.marchEquinox && e.time.year == 2026);
      expect(
          march.time.difference(DateTime.utc(2026, 3, 20, 14, 46)).inMinutes.abs(),
          lessThan(30));
      final december = events.firstWhere((e) =>
          e.kind == SpaceEventKind.decemberSolstice && e.time.year == 2026);
      expect(
          december.time
              .difference(DateTime.utc(2026, 12, 21, 20, 50))
              .inMinutes
              .abs(),
          lessThan(30));
    });

    test('a year has 12 or 13 full moons and meteor showers', () {
      final year = computeSpaceEvents(DateTime(2026, 1, 1));
      final full = year.where((e) => e.kind == SpaceEventKind.fullMoon).length;
      expect(full, inInclusiveRange(12, 13));
      final showers =
          year.where((e) => e.kind == SpaceEventKind.meteorShower).toList();
      expect(showers.length, 8);
      final perseids = showers.firstWhere((e) => e.bodies.first == 'perseids');
      expect(perseids.localDay, DateTime(2026, 8, 12));
      expect(perseids.value, 100);
      expect(perseids.extra, inInclusiveRange(0, 1));
    });

    test('reminders are set for the evening before, then the morning', () {
      final event = SpaceEvent(
        kind: SpaceEventKind.fullMoon,
        time: DateTime(2026, 5, 10, 12).toUtc(),
      );
      expect(reminderTime(event, DateTime(2026, 5, 8, 10)),
          DateTime(2026, 5, 9, 18));
      expect(reminderTime(event, DateTime(2026, 5, 9, 19)),
          DateTime(2026, 5, 10, 8));
      expect(reminderTime(event, DateTime(2026, 5, 10, 9)), isNull);
      expect(daysUntil(event, DateTime(2026, 5, 7, 23)), 3);
      expect(daysUntil(event, DateTime(2026, 5, 10, 1)), 0);
    });
  });

  group('space station', () {
    // Test orbit 00005 from Vallado's published SGP4 test set.
    const vallado1 =
        '1 00005U 58002B   00179.78495062  .00000023  00000-0  28098-4 0  4753';
    const vallado2 =
        '2 00005  34.2682 348.7242 1859667 331.7664  19.3264 10.82419157413667';
    const iss1 =
        '1 25544U 98067A   26300.50000000  .00016717  00000-0  10270-3 0  9991';
    const iss2 =
        '2 25544  51.6400 120.0000 0005000  90.0000 270.0000 15.50000000400009';

    test('SGP4 matches the published test vectors', () {
      final sat = Sgp4.fromTle(vallado1, vallado2);
      final p0 = sat.propagate(0)!;
      expect(p0.x, closeTo(7022.46529266, 1e-3));
      expect(p0.y, closeTo(-1400.08296755, 1e-3));
      expect(p0.z, closeTo(0.03995155, 1e-3));
      expect(p0.vx, closeTo(1.893841015, 1e-5));
      expect(p0.vy, closeTo(6.405893759, 1e-5));
      expect(p0.vz, closeTo(4.534807250, 1e-5));
      final p6 = sat.propagate(360)!;
      expect(p6.x, closeTo(-7154.03120202, 1e-2));
      expect(p6.y, closeTo(-3783.17682504, 1e-2));
      expect(p6.z, closeTo(-3536.19412294, 1e-2));
      final p12 = sat.propagate(720)!;
      expect(p12.x, closeTo(-7134.5934, 1e-1));
      expect(p12.y, closeTo(6531.6864, 1e-1));
      expect(p12.z, closeTo(3260.2719, 1e-1));
    });

    test('broken orbit lines are refused', () {
      expect(() => Sgp4.fromTle('1 x', '2 y'), throwsFormatException);
      expect(() => Sgp4.fromTle('hello', 'world'), throwsFormatException);
    });

    test('the station stays at a sensible height, speed and latitude', () {
      final sat = Sgp4.fromTle(iss1, iss2);
      var maxLat = 0.0;
      for (var m = 0; m < 200; m += 1) {
        final pos = issPosition(sat, sat.epoch.add(Duration(minutes: m)))!;
        expect(pos.altitudeKm, inInclusiveRange(380, 450));
        expect(pos.speedKmh, inInclusiveRange(27400, 27800));
        expect(pos.lon, inInclusiveRange(-180, 180));
        maxLat = maxLat < pos.lat.abs() ? pos.lat.abs() : maxLat;
      }
      expect(maxLat, inInclusiveRange(51.3, 52.1));
    });

    test('look angle is straight up when the station is overhead', () {
      final sat = Sgp4.fromTle(iss1, iss2);
      final pos = issPosition(sat, sat.epoch)!;
      final look = lookAngle(pos.ecef, pos.lat, pos.lon);
      expect(look.elevation, closeTo(90, 0.5));
      expect(look.rangeKm, closeTo(pos.altitudeKm, 1));
      final far = lookAngle(pos.ecef, -pos.lat, pos.lon + 180);
      expect(far.elevation, lessThan(0));
    });

    test('distances over the ground', () {
      expect(greatCircleKm(0, 0, 0, 0), closeTo(0, 1e-9));
      expect(greatCircleKm(0, 0, 0, 90), closeTo(10007.5, 5));
      expect(greatCircleKm(90, 0, -90, 0), closeTo(20015, 10));
    });

    test('passes over a city make sense', () {
      final sat = Sgp4.fromTle(iss1, iss2);
      final passes = findIssPasses(sat, sat.epoch, 40.18, 44.51);
      expect(passes, isNotEmpty);
      var last = sat.epoch;
      for (final pass in passes) {
        expect(pass.rise.isBefore(pass.peak), isTrue);
        expect(pass.peak.isBefore(pass.set), isTrue);
        expect(pass.rise.isBefore(last), isFalse);
        last = pass.rise;
        expect(pass.maxElevation, inInclusiveRange(10, 90));
        expect(pass.duration.inMinutes, inInclusiveRange(1, 15));
        expect(pass.riseAzimuth, inInclusiveRange(0, 360));
        expect(pass.setAzimuth, inInclusiveRange(0, 360));
        expect(pass.id, startsWith('iss:'));
      }
      expect(passes.map((e) => e.id).toSet().length, passes.length);
      final again = findIssPasses(sat, sat.epoch, 40.18, 44.51);
      expect(again.first.id, passes.first.id);
    });

    test('passes of another satellite get their own ids', () {
      final sat = Sgp4.fromTle(iss1, iss2);
      final passes =
          findIssPasses(sat, sat.epoch, 40.18, 44.51, satId: 'hst');
      expect(passes, isNotEmpty);
      for (final pass in passes) {
        expect(pass.satId, 'hst');
        expect(pass.id, startsWith('sat:hst:'));
        expect(isEventReminder(pass.id), isFalse);
      }
      expect(isEventReminder('iss:202611031200'), isFalse);
      expect(isEventReminder('full-moon-20261124'), isTrue);
    });

    test('the ground track has a point a minute', () {
      final sat = Sgp4.fromTle(iss1, iss2);
      final track = groundTrack(sat, sat.epoch);
      expect(track.length, 146);
    });
  });

  group('online data', () {
    const line1 =
        '1 25544U 98067A   26300.50000000  .00016717  00000-0  10270-3 0  9991';
    const line2 =
        '2 25544  51.6400 120.0000 0005000  90.0000 270.0000 15.50000000400009';

    test('wheretheiss.at answer is read', () {
      final body =
          '{"name":"iss","id":25544,"header":"ISS (ZARYA)","line1":"$line1","line2":"$line2"}';
      final tle = OnlineService.parseWhereTheIss(body, 5);
      expect(tle.name, 'ISS (ZARYA)');
      expect(tle.line1, line1);
      expect(tle.fetchedAtMs, 5);
      expect(tle.toSgp4(), isNotNull);
    });

    test('Celestrak answer is read', () {
      final body = 'ISS (ZARYA)             \r\n$line1\r\n$line2\r\n';
      final tle = OnlineService.parseCelestrak(body, 9);
      expect(tle.name, 'ISS (ZARYA)');
      expect(tle.line2, line2);
    });

    test('wrong or broken orbit answers are refused', () {
      expect(() => OnlineService.parseWhereTheIss('[]', 0), throwsFormatException);
      expect(() => OnlineService.parseWhereTheIss('{"line1":"a"}', 0),
          throwsFormatException);
      expect(() => OnlineService.parseCelestrak('nothing here', 0),
          throwsFormatException);
      final other = line1.replaceFirst('25544', '25545');
      expect(() => OnlineService.parseCelestrak('X\n$other\n$line2', 0),
          throwsFormatException);
    });

    test('the orbit of another satellite must match its number', () {
      final hubble1 = line1.replaceFirst('25544', '20580');
      final hubble2 = line2.replaceFirst('25544', '20580');
      final body = 'HST\r\n$hubble1\r\n$hubble2\r\n';
      final tle = OnlineService.parseCelestrak(body, 3, noradId: '20580');
      expect(tle.name, 'HST');
      expect(tle.toSgp4(), isNotNull);
      // The space station's lines are refused for Hubble, and the other way.
      expect(
          () => OnlineService.parseCelestrak('X\n$line1\n$line2', 0,
              noradId: '20580'),
          throwsFormatException);
      expect(() => OnlineService.parseCelestrak(body, 0), throwsFormatException);
    });

    test('tracked satellites are Tiangong and Hubble', () {
      expect(trackedSatellites.map((s) => s.id), <String>['css', 'hst']);
      expect(trackedSatelliteById('hst')!.noradId, '20580');
      expect(trackedSatelliteById('css')!.noradId, '48274');
      expect(trackedSatelliteById('iss'), isNull);
    });

    test('news is read, newest first, and unsafe links are dropped', () {
      const body = r"""
{"count":4,"results":[
 {"id":11,"title":"  Older story ","url":"https://example.org/a",
  "news_site":"Example","summary":"  Short text. ","published_at":"2026-11-01T08:00:00Z"},
 {"id":12,"title":"Newest story","url":"https://example.org/b",
  "published_at":"2026-11-03T09:30:00Z"},
 {"id":13,"title":"Plain http","url":"http://example.org/c",
  "published_at":"2026-11-03T10:00:00Z"},
 {"id":14,"title":"","url":"https://example.org/d","published_at":"2026-11-03T10:00:00Z"},
 {"id":15,"title":"No date","url":"https://example.org/e"},
 "junk"
]}""";
      final list = OnlineService.parseNews(body);
      expect(list.map((e) => e.id), <String>['12', '11']);
      expect(list[0].site, '');
      expect(list[0].summary, '');
      expect(list[1].title, 'Older story');
      expect(list[1].summary, 'Short text.');
      expect(list[1].site, 'Example');
      expect(list[0].published, DateTime.utc(2026, 11, 3, 9, 30));
    });

    test('a news answer of the wrong shape is refused', () {
      expect(() => OnlineService.parseNews('{"detail":"x"}'),
          throwsFormatException);
      expect(() => OnlineService.parseNews('[]'), throwsFormatException);
    });

    test('saved news survives a round trip and refuses http links', () {
      const item = NewsItem(
          id: '1',
          title: 'T',
          summary: 'S',
          url: 'https://example.org/x',
          site: 'Site',
          publishedMs: 99);
      final back = NewsItem.fromJson(item.toJson())!;
      expect(back.title, 'T');
      expect(back.publishedMs, 99);
      final bad = Map<String, Object>.of(item.toJson())..['url'] = 'http://x';
      expect(NewsItem.fromJson(bad), isNull);
      expect(NewsItem.fromJson('nope'), isNull);
    });

    test('the news host is one of the trusted hosts', () {
      expect(OnlineService.trustedHosts,
          contains('api.spaceflightnewsapi.net'));
    });

    test('launch list is read and sorted', () {
      const body = r"""
{"count":3,"results":[
 {"id":"b-2","name":"Falcon 9 Block 5 | Starlink","net":"2026-11-10T04:30:00Z",
  "net_precision":{"abbrev":"MIN"},"status":{"abbrev":"Go","name":"Go for Launch"},
  "launch_service_provider":{"name":"SpaceX"},
  "rocket":{"configuration":{"name":"Falcon 9","full_name":"Falcon 9 Block 5"}},
  "pad":{"name":"SLC-40","location":{"name":"Cape Canaveral, FL, USA"}}},
 {"id":"a-1","name":"Test | Early","net":"2026-11-02T00:00:00Z",
  "net_precision":{"abbrev":"DAY"},"status":{"name":"To Be Determined"}},
 {"id":"c-3","net":"2026-12-01T00:00:00Z"},
 {"id":"d-4","name":"No time","net":"oops"},
 "junk"
]}""";
      final list = OnlineService.parseLaunches(body);
      expect(list.map((e) => e.id), <String>['a-1', 'b-2']);
      expect(list[0].timeKnown, isFalse);
      expect(list[0].status, 'To Be Determined');
      expect(list[1].timeKnown, isTrue);
      expect(list[1].rocket, 'Falcon 9 Block 5');
      expect(list[1].provider, 'SpaceX');
      expect(list[1].pad, 'SLC-40');
      expect(list[1].location, 'Cape Canaveral, FL, USA');
      expect(list[1].net, DateTime.utc(2026, 11, 10, 4, 30));
      expect(list[1].reminderId, 'launch:b-2');
      expect(list[1].details, contains('SpaceX'));
      expect(list[1].details, contains('SLC-40, Cape Canaveral'));
    });

    test('a launch answer of the wrong shape is refused', () {
      expect(() => OnlineService.parseLaunches('{"detail":"Throttled"}'),
          throwsFormatException);
      expect(() => OnlineService.parseLaunches('[]'), throwsFormatException);
    });

    test('saved data survives a round trip', () {
      const tle = IssTle(name: 'ISS', line1: line1, line2: line2, fetchedAtMs: 7);
      final back = IssTle.fromJson(tle.toJson())!;
      expect(back.line1, line1);
      expect(back.fetchedAtMs, 7);
      expect(IssTle.fromJson(<String, dynamic>{'name': 3}), isNull);
      expect(IssTle.fromJson('x'), isNull);

      final launch = Launch(
        id: 'x',
        name: 'Rocket | Payload',
        netMs: DateTime.utc(2026, 11, 3, 12).millisecondsSinceEpoch,
        timeKnown: false,
        provider: 'P',
      );
      final l2 = Launch.fromJson(launch.toJson())!;
      expect(l2.id, 'x');
      expect(l2.timeKnown, isFalse);
      expect(l2.provider, 'P');
      expect(Launch.fromJson(<String, dynamic>{'id': 1}), isNull);
    });

    test('launch reminders', () {
      final now = DateTime(2026, 10, 28, 12);
      final known = Launch(
        id: 'k',
        name: 'K',
        netMs: now.add(const Duration(days: 3)).toUtc().millisecondsSinceEpoch,
        timeKnown: true,
      );
      expect(launchReminderTime(known, now),
          now.add(const Duration(days: 3)).subtract(const Duration(hours: 1)));

      final unknown = Launch(
        id: 'u',
        name: 'U',
        netMs: DateTime(2026, 11, 5, 14).toUtc().millisecondsSinceEpoch,
        timeKnown: false,
      );
      expect(launchReminderTime(unknown, now), DateTime(2026, 11, 4, 18));

      final past = Launch(
        id: 'p',
        name: 'P',
        netMs: now.subtract(const Duration(hours: 2)).toUtc().millisecondsSinceEpoch,
        timeKnown: true,
      );
      expect(launchReminderTime(past, now), isNull);
      final tooSoon = Launch(
        id: 't',
        name: 'T',
        netMs: now.add(const Duration(minutes: 30)).toUtc().millisecondsSinceEpoch,
        timeKnown: true,
      );
      expect(launchReminderTime(tooSoon, now), isNull);
    });
  });

  group('eclipses', () {
    final all = computeEclipses(DateTime.utc(2025), DateTime.utc(2030));

    bool has(bool lunar, EclipseType type, DateTime utc) => all.any((e) =>
        e.lunar == lunar &&
        e.type == type &&
        e.time.difference(utc).inMinutes.abs() <= 60);

    test('match the official lists for 2025 to 2029', () {
      expect(has(true, EclipseType.total, DateTime.utc(2025, 3, 14, 7)), isTrue);
      expect(has(false, EclipseType.partial, DateTime.utc(2025, 3, 29, 10, 48)),
          isTrue);
      expect(has(true, EclipseType.total, DateTime.utc(2025, 9, 7, 18, 11)),
          isTrue);
      expect(has(false, EclipseType.annular, DateTime.utc(2026, 2, 17, 12, 13)),
          isTrue);
      expect(has(true, EclipseType.total, DateTime.utc(2026, 3, 3, 11, 33)),
          isTrue);
      expect(has(false, EclipseType.total, DateTime.utc(2026, 8, 12, 17, 46)),
          isTrue);
      expect(has(true, EclipseType.partial, DateTime.utc(2026, 8, 28, 4, 13)),
          isTrue);
      expect(has(false, EclipseType.annular, DateTime.utc(2027, 2, 6, 16)),
          isTrue);
      expect(has(false, EclipseType.total, DateTime.utc(2027, 8, 2, 10, 7)),
          isTrue);
      expect(has(true, EclipseType.partial, DateTime.utc(2028, 1, 12, 4, 13)),
          isTrue);
      expect(has(false, EclipseType.total, DateTime.utc(2028, 7, 22, 2, 56)),
          isTrue);
      expect(has(true, EclipseType.total, DateTime.utc(2028, 12, 31, 16, 52)),
          isTrue);
    });

    test('there are twelve solar eclipses in 2025 to 2029', () {
      expect(all.where((e) => !e.lunar).length, 12);
    });

    test('are in order and magnitudes look right', () {
      for (var i = 1; i < all.length; i++) {
        expect(all[i].time.isBefore(all[i - 1].time), isFalse);
      }
      final march2026 = all.firstWhere(
          (e) => e.lunar && e.time.year == 2026 && e.time.month == 3);
      expect(march2026.magnitude, closeTo(1.15, 0.1));
      final august2026 = all.firstWhere(
          (e) => !e.lunar && e.time.year == 2026 && e.time.month == 8);
      expect(august2026.magnitude, closeTo(0.9, 0.06));
    });

    test('they show up in the space events with their type', () {
      final events = computeSpaceEvents(DateTime(2026, 1, 1));
      final solar =
          events.where((e) => e.kind == SpaceEventKind.solarEclipse).toList();
      expect(solar.length, 2);
      final total = solar.firstWhere((e) => e.eclipse!.type == EclipseType.total);
      expect(total.time.month, 8);
      expect(total.id, startsWith('solarEclipse:total:202608'));
      expect(events.where((e) => e.kind == SpaceEventKind.lunarEclipse).length,
          greaterThanOrEqualTo(2));
      expect(
          events.firstWhere((e) => e.kind == SpaceEventKind.fullMoon).eclipse,
          isNull);
    });

    test('the Moon is about 56 to 64 Earth radii away', () {
      for (var day = 0; day < 40; day++) {
        final d = moonDistance(DateTime.utc(2026, 1, 1 + day));
        expect(d, inInclusiveRange(55.5, 64.5));
      }
    });

    test('a lunar eclipse is seen where the Moon is up', () {
      final eclipse = all.firstWhere(
          (e) => e.lunar && e.time.year == 2026 && e.time.month == 3);
      expect(lunarView(eclipse, 34.05, -118.24), LunarView.up);
      expect(lunarView(eclipse, 40.4, -3.7), LunarView.down);
      expect(lunarView(eclipse, 28.6, 77.2), LunarView.partly);
    });

    test('a solar eclipse is rated by place', () {
      final aug2026 = all.firstWhere(
          (e) => !e.lunar && e.time.year == 2026 && e.time.month == 8);
      final madrid = solarLocalMagnitude(aug2026, 40.4, -3.7);
      expect(madrid, isNotNull);
      expect(madrid!, greaterThan(0.9));
      final yerevan = solarLocalMagnitude(aug2026, 40.18, 44.51);
      expect(yerevan == null || yerevan < 0, isTrue);
      final mar2025 = all.firstWhere(
          (e) => !e.lunar && e.time.year == 2025 && e.time.month == 3);
      final london = solarLocalMagnitude(mar2025, 51.5, -0.12);
      expect(london!, inInclusiveRange(0.2, 0.5));
      final delhi = solarLocalMagnitude(mar2025, 28.6, 77.2);
      expect(delhi == null || delhi < 0, isTrue);
    });
  });

  group('tonight alerts', () {
    final l = lookupAppLocalizations(const Locale('en'));
    final yerevan = cityById('yerevan');

    test('a fortnight of notes with their own ids', () {
      final alerts = buildTonightAlerts(
        l: l,
        locale: const Locale('en'),
        city: yerevan,
        minutes: 20 * 60,
        now: DateTime(2026, 3, 1, 10),
      );
      expect(alerts.length, tonightAlertDays);
      expect(alerts.first.id, 'tonight:0');
      expect(alerts.first.at, DateTime(2026, 3, 1, 20));
      expect(alerts.last.id, 'tonight:${tonightAlertDays - 1}');
      expect(alerts.first.title, l.tonightNotifTitle);
      expect(alerts.first.body, contains('Moon:'));
      expect(alerts.first.body, contains('% lit.'));
    });

    test('an evening that has passed is left out', () {
      final alerts = buildTonightAlerts(
        l: l,
        locale: const Locale('en'),
        city: yerevan,
        minutes: 20 * 60,
        now: DateTime(2026, 3, 1, 21),
      );
      expect(alerts.first.id, 'tonight:1');
      expect(alerts.length, tonightAlertDays - 1);
    });

    test('without a city the note is about the Moon only', () {
      final alerts = buildTonightAlerts(
        l: l,
        locale: const Locale('en'),
        city: null,
        minutes: 19 * 60 + 30,
        now: DateTime(2026, 3, 1, 10),
        days: 3,
      );
      expect(alerts.length, 3);
      expect(alerts.first.at, DateTime(2026, 3, 1, 19, 30));
      expect(alerts.first.body, contains(l.tonightNoCity));
    });

    test('with a city the note names planets or says there are none', () {
      final alerts = buildTonightAlerts(
        l: l,
        locale: const Locale('en'),
        city: yerevan,
        minutes: 20 * 60,
        now: DateTime(2026, 3, 1, 10),
        days: 5,
      );
      for (final a in alerts) {
        expect(
            a.body.contains('Look for:') || a.body.contains(l.tonightNoPlanets),
            isTrue);
      }
    });

    test('the normal build updates itself, only F-Droid turns it off', () {
      // The F-Droid build sets --dart-define=FDROID=true; tests do not.
      expect(inAppUpdates, isTrue);
    });

    test('the app has English and Hindi only', () {
      expect(appLanguages.map((e) => e.$1), <String>['en', 'hi']);
      expect(languageName('hi'), 'हिन्दी');
      expect(AppLocalizations.supportedLocales.map((e) => e.languageCode),
          <String>['en', 'hi']);
    });

    test('a saved language that was removed falls back to the phone', () {
      for (final code in <String>['ru', 'ar', 'zz']) {
        final back = HelioraSettings.fromJson(<String, Object?>{'locale': code});
        expect(back.localeCode, '');
      }
      for (final code in <String>['', 'en', 'hi']) {
        final back = HelioraSettings.fromJson(<String, Object?>{'locale': code});
        expect(back.localeCode, code);
      }
    });

    test('the daily note is a setting', () {
      const on = HelioraSettings(tonightAlert: true, tonightMinutes: 21 * 60);
      final back = HelioraSettings.fromJson(on.toJson());
      expect(back.tonightAlert, isTrue);
      expect(back.tonightMinutes, 21 * 60);
      const d = HelioraSettings();
      expect(d.tonightAlert, isFalse);
      expect(d.tonightMinutes, 20 * 60);
      expect(
          HelioraSettings.fromJson(<String, dynamic>{'tonightMinutes': 5000})
              .tonightMinutes,
          20 * 60);
      expect(
          HelioraSettings.fromJson(<String, dynamic>{'tonightAlert': 'yes'})
              .tonightAlert,
          isFalse);
    });
  });

  group('birthday sky', () {
    final birth = DateTime(2000, 1, 1, 12);

    test('days old count the birth day as day 0', () {
      expect(daysOld(birth, DateTime(2000, 1, 1, 23)), 0);
      expect(daysOld(birth, DateTime(2000, 1, 2)), 1);
      expect(daysOld(birth, DateTime(2001, 1, 1)), 366);
    });

    test('milestones fall on the right days', () {
      final list = lifeMilestones(birth);
      expect(list.length, milestoneDays.length + 1);
      for (var i = 1; i < list.length; i++) {
        expect(list[i].date.isBefore(list[i - 1].date), isFalse);
      }
      DateTime day(int n) =>
          list.firstWhere((m) => m.days == n).date;
      expect(day(1000), DateTime(2002, 9, 27));
      expect(day(10000), DateTime(2027, 5, 19));
      expect(day(20000), DateTime(2054, 10, 4));
      final billion = list.firstWhere((m) => m.days == null);
      expect(billion.date, DateTime(2031, 9, 9));
    });

    test('the Moon on 1 January 2000 was a thin waning crescent', () {
      final moon = moonOnBirthday(birth);
      expect(phaseIndex(moon.age), 7);
      expect(moon.lit, inInclusiveRange(0.15, 0.3));
    });

    test('the Moon on 20 July 1969 was a waxing crescent', () {
      final moon = moonOnBirthday(DateTime(1969, 7, 20, 12));
      expect(phaseIndex(moon.age), 1);
    });
  });

  group('missions', () {
    test('are in date order with their own ids', () {
      expect(missions.length, 15);
      for (var i = 1; i < missions.length; i++) {
        expect(missions[i].date.isBefore(missions[i - 1].date), isFalse);
      }
      expect(missions.map((m) => m.id).toSet().length, missions.length);
      for (final m in missions) {
        expect(m.name, isNotEmpty);
        expect(m.agency, isNotEmpty);
      }
    });
  });

  group('spacecraft', () {
    Spacecraft byId(String id) => spacecraft.firstWhere((c) => c.id == id);

    test('are listed once each with a name', () {
      expect(spacecraft.length, 7);
      expect(spacecraft.map((c) => c.id).toSet().length, spacecraft.length);
      for (final c in spacecraft) {
        expect(c.name, isNotEmpty);
      }
    });

    test('Voyager 1 is one light-day away on the NASA date', () {
      final v1 = byId('voyager1');
      final day = DateTime.utc(2026, 11, 18);
      expect(v1.distanceAu(day), closeTo(173.14, 0.001));
      // A light-day is 86,400 light-seconds.
      expect(v1.signalSeconds(day), closeTo(86400, 50));
      final later = DateTime.utc(2027, 11, 18);
      final grown = v1.distanceAu(later) - v1.distanceAu(day);
      expect(grown, inInclusiveRange(3.4, 3.7));
    });

    test('Voyager 2 reaches one light-day in 2035', () {
      expect(byId('voyager2').distanceAu(DateTime.utc(2035, 11, 15)),
          closeTo(173.14, 0.001));
    });

    test('far probes are in the right order and range today', () {
      final now = DateTime.utc(2026, 10, 29);
      final v1 = byId('voyager1').distanceAu(now);
      final v2 = byId('voyager2').distanceAu(now);
      final nh = byId('newhorizons').distanceAu(now);
      expect(v1, inInclusiveRange(172, 174));
      expect(v2, inInclusiveRange(140, 150));
      expect(nh, inInclusiveRange(60, 70));
      expect(v1 > v2 && v2 > nh, isTrue);
    });

    test('close spacecraft stay close and rovers follow Mars', () {
      final now = DateTime.utc(2026, 10, 29);
      expect(byId('iss').isAltitude, isTrue);
      expect(byId('iss').distanceKm(now), lessThan(byId('hubble').distanceKm(now)));
      expect(byId('hubble').distanceKm(now), lessThan(byId('jwst').distanceKm(now)));
      expect(byId('jwst').signalSeconds(now), closeTo(5, 0.1));
      for (var year = 2020; year <= 2040; year++) {
        final km = byId('marsrovers').distanceKm(DateTime.utc(year, 6, 15));
        expect(km, inInclusiveRange(5.4e7, 4.1e8));
      }
    });
  });

  group('favourites and search', () {
    test('toggling adds, removes and keeps the order', () {
      const list = <String>['mars'];
      final added = toggledFavorite(list, missionKey('apollo11'));
      expect(added, <String>['mars', 'mission:apollo11']);
      expect(list, <String>['mars']);
      expect(toggledFavorite(added, 'mars'), <String>['mission:apollo11']);
      expect(craftKey('iss'), 'craft:iss');
    });

    test('the list never grows past the limit', () {
      var list = <String>[];
      for (var i = 0; i < maxFavorites + 5; i++) {
        list = toggledFavorite(list, 'k$i');
      }
      expect(list.length, maxFavorites);
      expect(list.last, 'k${maxFavorites + 4}');
      expect(list.contains('k0'), isFalse);
    });

    test('text is folded for searching', () {
      expect(foldText('  Plutón '), 'pluton');
      expect(foldText('Земля'), 'земля');
      expect(foldText('Ёж'), 'еж');
      expect(foldText('Réunion'), 'reunion');
    });

    test('queries match names', () {
      expect(matchesQuery('mer', <String>['Mercury']), isTrue);
      expect(matchesQuery('PLUTON', <String>['Plutón']), isTrue);
      expect(matchesQuery('voy', <String>['Voyager 1', 'NASA']), isTrue);
      expect(matchesQuery('', <String>['Mercury']), isFalse);
      expect(matchesQuery('   ', <String>['Mercury']), isFalse);
      expect(matchesQuery('zzz', <String>['Mercury', 'Venus']), isFalse);
    });

    test('every planet and spacecraft can be found by its English name', () {
      for (final b in allBodies) {
        expect(matchesQuery(b.id, <String>[b.id]), isTrue);
      }
      for (final m in missions) {
        expect(matchesQuery(m.name, <String>[m.name]), isTrue);
      }
    });

    test('favourites and text size are saved', () {
      const s = HelioraSettings(
        favorites: <String>['mars', 'craft:iss'],
        textScalePercent: 130,
      );
      final back = HelioraSettings.fromJson(s.toJson());
      expect(back.favorites, <String>['mars', 'craft:iss']);
      expect(back.textScalePercent, 130);
    });

    test('broken favourites and text size fall back', () {
      final bad = HelioraSettings.fromJson(<String, dynamic>{
        'favorites': <Object?>['x', 3, null],
        'textScale': 117,
      });
      expect(bad.favorites, <String>['x']);
      expect(bad.textScalePercent, 100);
      final worse = HelioraSettings.fromJson(<String, dynamic>{
        'favorites': 'no',
        'textScale': 'big',
      });
      expect(worse.favorites, isEmpty);
      expect(worse.textScalePercent, 100);
      expect(HelioraSettings.fromJson(<String, dynamic>{}).textScalePercent, 100);
      expect(textScaleChoices, <int>[100, 115, 130]);
    });
  });

  group('stat grid', () {
    Widget app(double scale, int count) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(360, 800),
            textScaler: TextScaler.linear(scale),
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: StatGrid(
                tiles: <Widget>[
                  for (var i = 0; i < count; i++)
                    const IconStatTile(
                      icon: Icons.speed,
                      label: 'Average temperature on the surface',
                      value: '1,234,567 million km',
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('has every tile and grows with big text without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(720, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(app(1.0, 5));
      expect(tester.takeException(), isNull);
      expect(find.byType(IconStatTile), findsNWidgets(5));
      final normal = tester.getSize(find.byType(StatGrid)).height;

      await tester.pumpWidget(app(1.3, 5));
      expect(tester.takeException(), isNull);
      expect(find.byType(IconStatTile), findsNWidgets(5));
      final big = tester.getSize(find.byType(StatGrid)).height;
      expect(big, greaterThan(normal));
    });
  });

  group('sun times and Moon calendar', () {
    Matcher near(DateTime expected, int minutes) => predicate<DateTime>(
        (t) => t.difference(expected).inMinutes.abs() <= minutes,
        'within $minutes minutes of $expected');

    test('London on the shortest day, 21 December 2025', () {
      final s = sunDay(DateTime(2025, 12, 21), 51.5074, -0.1278);
      expect(s.firstLight, near(DateTime.utc(2025, 12, 21, 7, 22), 3));
      expect(s.sunrise, near(DateTime.utc(2025, 12, 21, 8, 2), 3));
      expect(s.goldenMorningEnds, near(DateTime.utc(2025, 12, 21, 9, 4), 3));
      expect(s.solarNoon, near(DateTime.utc(2025, 12, 21, 11, 57), 3));
      expect(s.goldenEveningStarts,
          near(DateTime.utc(2025, 12, 21, 14, 50), 3));
      expect(s.sunset, near(DateTime.utc(2025, 12, 21, 15, 52), 3));
      expect(s.lastLight, near(DateTime.utc(2025, 12, 21, 16, 32), 3));
      expect(s.darkStarts, near(DateTime.utc(2025, 12, 21, 17, 56), 3));
      expect(s.darkEnds, near(DateTime.utc(2025, 12, 21, 5, 58), 3));
      expect(s.dayLength.inMinutes, closeTo(7 * 60 + 50, 3));
      expect(s.stayUp, isFalse);
      expect(s.stayDown, isFalse);
    });

    test('the times come in the right order', () {
      final s = sunDay(DateTime(2026, 3, 20), -0.18, -78.47);
      final order = <DateTime?>[
        s.firstLight,
        s.sunrise,
        s.goldenMorningEnds,
        s.solarNoon,
        s.goldenEveningStarts,
        s.sunset,
        s.lastLight,
      ];
      for (var i = 0; i < order.length; i++) {
        expect(order[i], isNotNull);
        if (i > 0) {
          expect(order[i]!.isAfter(order[i - 1]!), isTrue, reason: '$i');
        }
      }
      // Quito on the equinox: a day of about 12 hours.
      expect(s.dayLength.inMinutes, closeTo(12 * 60 + 6, 3));
    });

    test('sunDay agrees with sunRiseSet', () {
      final a = sunDay(DateTime(2025, 6, 21), 51.5074, -0.1278);
      final b = sunRiseSet(DateTime.utc(2025, 6, 21), 51.5074, -0.1278);
      expect(a.sunrise, near(b.rise!, 3));
      expect(a.sunset, near(b.set!, 3));
    });

    test('a far city gets a sunrise and sunset that belong together', () {
      // Yerevan, midsummer: about 15 hours of daylight, whatever the
      // time zone of the phone.
      final s = sunDay(DateTime(2026, 6, 21), 40.18, 44.51);
      expect(s.sunrise, near(DateTime.utc(2026, 6, 21, 1, 31), 3));
      expect(s.sunset, near(DateTime.utc(2026, 6, 21, 16, 33), 3));
      expect(s.sunset!.isAfter(s.sunrise!), isTrue);
      expect(s.dayLength.inMinutes, closeTo(15 * 60 + 2, 3));
    });

    test('midnight sun and polar night', () {
      final summer = sunDay(DateTime(2026, 6, 21), 69.65, 18.96);
      expect(summer.stayUp, isTrue);
      expect(summer.sunrise, isNull);
      expect(summer.sunset, isNull);
      expect(summer.dayLength.inHours, 24);
      final winter = sunDay(DateTime(2026, 12, 21), 69.65, 18.96);
      expect(winter.stayDown, isTrue);
      expect(winter.sunrise, isNull);
      expect(winter.dayLength, Duration.zero);
    });

    test('the four main phases of November 2026', () {
      final list =
          phaseEvents(DateTime.utc(2026, 11, 1), DateTime.utc(2026, 12, 1));
      expect(list.map((e) => e.kind).toList(), <int>[3, 0, 1, 2]);
      expect(list[0].time, near(DateTime.utc(2026, 11, 1, 20, 27), 30));
      expect(list[1].time, near(DateTime.utc(2026, 11, 9, 7, 1), 30));
      expect(list[2].time, near(DateTime.utc(2026, 11, 17, 11, 49), 30));
      expect(list[3].time, near(DateTime.utc(2026, 11, 24, 15, 2), 30));
      expect(list[1].nameIndex, 0);
      expect(list[3].nameIndex, 4);
    });

    test('a month of Moon days', () {
      final days = moonMonth(2026, 11);
      expect(days.length, 30);
      expect(moonMonth(2028, 2).length, 29);
      expect(days.first.date, DateTime(2026, 11, 1));
      expect(days.last.date, DateTime(2026, 11, 30));
      for (final d in days) {
        expect(d.lit, inInclusiveRange(0.0, 1.0));
        expect(d.age, inInclusiveRange(0.0, 360.0));
      }
      final marked = days.where((d) => d.event != null).toList();
      expect(marked.length, inInclusiveRange(4, 5));
      for (final d in marked) {
        final local = d.event!.time.toLocal();
        expect(d.date, DateTime(local.year, local.month, local.day));
      }
      final full = marked.firstWhere((d) => d.event!.kind == 2);
      expect(full.lit, 1.0);
      expect(phaseIndex(full.age), 4);
      final fresh = marked.firstWhere((d) => d.event!.kind == 0);
      expect(fresh.lit, 0.0);
      expect(phaseIndex(fresh.age), 0);
    });

    test('moonrise falls on the horizon', () {
      final city = cityById('yerevan')!;
      var withRise = 0;
      for (var d = 1; d <= 30; d++) {
        final r = moonRiseSet(DateTime(2026, 11, d), city.lat, city.lon);
        final rise = r.rise;
        if (rise != null) {
          withRise++;
          final alt = toHorizontal(
                  equatorialOf('moon', rise), rise, city.lat, city.lon)
              .altitude;
          expect(alt, closeTo(horizonFor('moon'), 0.3), reason: 'day $d');
        }
        final set = r.set;
        if (set != null) {
          final alt = toHorizontal(
                  equatorialOf('moon', set), set, city.lat, city.lon)
              .altitude;
          expect(alt, closeTo(horizonFor('moon'), 0.3), reason: 'day $d');
        }
      }
      // The Moon rises about 50 minutes later each day, so one day in
      // about thirty has no moonrise.
      expect(withRise, greaterThanOrEqualTo(26));
    });

    testWidgets('info rows wrap long text without overflow', (tester) async {
      tester.view.physicalSize = const Size(640, 1400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              size: const Size(320, 700),
              textScaler: TextScaler.linear(1.3),
            ),
            child: const Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    InfoRow(
                      icon: Icons.camera_alt_outlined,
                      label: 'Evening golden hour starts',
                      value: '4:50 PM',
                    ),
                    InfoRow(
                      icon: Icons.dark_mode_outlined,
                      label: 'Fully dark sky',
                      value: '7:41 PM – 4:50 AM next morning',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(InfoRow), findsNWidgets(2));
    });
  });

  group('stat panel', () {
    Widget app(double scale, int count) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(320, 800),
            textScaler: TextScaler.linear(scale),
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: StatPanel(
                tiles: <BigStat>[
                  for (var i = 0; i < count; i++)
                    const BigStat(
                      icon: Icons.speed,
                      label: 'Average temperature on the surface',
                      value: '1,234,567 million km',
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('three columns, any number of tiles, big text without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(640, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      for (final count in <int>[1, 2, 3, 5, 7, 8]) {
        await tester.pumpWidget(app(1.0, count));
        expect(tester.takeException(), isNull, reason: '$count tiles');
        expect(find.byType(BigStat), findsNWidgets(count));
      }
      await tester.pumpWidget(app(1.0, 6));
      final normal = tester.getSize(find.byType(StatPanel)).height;
      await tester.pumpWidget(app(1.3, 6));
      expect(tester.takeException(), isNull);
      expect(find.byType(BigStat), findsNWidgets(6));
      expect(tester.getSize(find.byType(StatPanel)).height,
          greaterThan(normal));
    });
  });

  group('versions', () {
    test('newer and older', () {
      expect(isNewerVersion('v1.0.1', '1.0.0'), isTrue);
      expect(isNewerVersion('v1.10.0', '1.9.9'), isTrue);
      expect(isNewerVersion('v2.0', '1.9.9'), isTrue);
      expect(isNewerVersion('v1.0.0', '1.0.0'), isFalse);
      expect(isNewerVersion('v1.0.0', '1.0.1'), isFalse);
      expect(isNewerVersion('1.0.1+3', '1.0.1'), isFalse);
    });

    test('release json', () {
      final info = UpdateService.parse(
        '{"tag_name":"v1.0.1","html_url":"https://github.com/aditymishr098-collab/heliora/releases/tag/v1.0.1","body":"Fixes","assets":[{"name":"Heliora-v1.0.1.apk","browser_download_url":"https://github.com/x/Heliora-v1.0.1.apk"}]}',
      );
      expect(info.version, '1.0.1');
      expect(info.apkUrl, 'https://github.com/x/Heliora-v1.0.1.apk');
      expect(info.downloadUrl, 'https://github.com/x/Heliora-v1.0.1.apk');
      expect(info.notes, 'Fixes');
    });

    test('updates download only from GitHub', () {
      expect(
          UpdateService.isTrustedDownload(
              'https://github.com/aditymishr098-collab/heliora/releases/download/v1.2.0/Heliora-v1.2.0.apk'),
          isTrue);
      expect(UpdateService.isTrustedDownload('http://github.com/x.apk'),
          isFalse);
      expect(UpdateService.isTrustedDownload('https://evil.example/x.apk'),
          isFalse);
      expect(UpdateService.isTrustedDownload('not a link'), isFalse);
    });

    test('every address on the way to an update must be GitHub', () {
      bool ok(String url, Set<String> hosts) =>
          UpdateService.isTrustedHost(Uri.parse(url), hosts);
      const dl = UpdateService.downloadHosts;
      expect(ok('https://github.com/a/b/releases/download/v1/x.apk', dl), isTrue);
      expect(ok('https://objects.githubusercontent.com/x', dl), isTrue);
      expect(ok('https://release-assets.githubusercontent.com/x', dl), isTrue);
      expect(ok('http://objects.githubusercontent.com/x', dl), isFalse);
      expect(ok('https://github.com.evil.example/x.apk', dl), isFalse);
      expect(ok('https://evil.example/github.com', dl), isFalse);
      expect(ok('https://api.github.com/repos/x', UpdateService.apiHosts), isTrue);
      expect(ok('https://github.com/x', UpdateService.apiHosts), isFalse);
    });

    test('release without apk opens the release page', () {
      final info = UpdateService.parse('{"tag_name":"v1.2.0","assets":[]}');
      expect(info.apkUrl, isNull);
      expect(info.downloadUrl, UpdateService.releasesPage);
    });
  });

  group('settings', () {
    test('round trip', () {
      const s = HelioraSettings(
        themeMode: ThemeMode.dark,
        localeCode: 'hi',
        viewMode: ViewMode.globe,
        autoUpdateCheck: false,
        lastUpdateCheckMs: 42,
        bestQuizScore: 7,
        birthDateMs: 946728000000,
        cityId: 'yerevan',
      );
      final back = HelioraSettings.fromJson(s.toJson());
      expect(back.themeMode, ThemeMode.dark);
      expect(back.localeCode, 'hi');
      expect(back.viewMode, ViewMode.globe);
      expect(back.autoUpdateCheck, isFalse);
      expect(back.lastUpdateCheckMs, 42);
      expect(back.bestQuizScore, 7);
      expect(back.birthDateMs, 946728000000);
      expect(back.cityId, 'yerevan');
      expect(back.birthDate, isNotNull);
    });

    test('quiz scores are kept for each level', () {
      const s = HelioraSettings(
        bestQuizScore: 7,
        quizBests: <String, int>{'easy': 9, 'hard': 3},
      );
      final back = HelioraSettings.fromJson(s.toJson());
      expect(back.bestFor('easy'), 9);
      expect(back.bestFor('hard'), 3);
      // The older single score counts as the medium score.
      expect(back.bestFor('medium'), 7);
      expect(const HelioraSettings().bestFor('easy'), 0);
      final more = HelioraSettings.fromJson(<String, dynamic>{
        'bestQuizScore': 7,
        'quizBests': <String, dynamic>{'medium': 10, 'easy': 'x', 'hard': 4},
      });
      expect(more.bestFor('medium'), 10);
      expect(more.bestFor('easy'), 0);
      expect(more.bestFor('hard'), 4);
      expect(HelioraSettings.fromJson(<String, dynamic>{'quizBests': 3})
          .quizBests, isEmpty);
    });

    test('online features are off by default and saved', () {
      expect(const HelioraSettings().onlineFeatures, isFalse);
      expect(HelioraSettings.fromJson(<String, dynamic>{}).onlineFeatures, isFalse);
      const on = HelioraSettings(onlineFeatures: true);
      expect(HelioraSettings.fromJson(on.toJson()).onlineFeatures, isTrue);
      expect(
          HelioraSettings.fromJson(<String, dynamic>{'onlineFeatures': 'yes'})
              .onlineFeatures,
          isFalse);
    });

    test('reminders are saved and broken ones ignored', () {
      const s = HelioraSettings(reminders: <String>['a:b:20260101']);
      final back = HelioraSettings.fromJson(s.toJson());
      expect(back.reminders, <String>['a:b:20260101']);
      final bad = HelioraSettings.fromJson(<String, dynamic>{
        'reminders': <Object?>['x', 5, null],
      });
      expect(bad.reminders, <String>['x']);
      expect(HelioraSettings.fromJson(<String, dynamic>{'reminders': 3}).reminders,
          isEmpty);
    });

    test('broken values fall back to defaults', () {
      final s = HelioraSettings.fromJson(<String, dynamic>{
        'theme': 'purple',
        'view': 42,
        'locale': null,
        'bestQuizScore': 'x',
      });
      expect(s.themeMode, ThemeMode.system);
      expect(s.viewMode, ViewMode.flat);
      expect(s.localeCode, '');
      expect(s.bestQuizScore, 0);
    });
  });

  group('star map', () {
    final yerevan = cityById('yerevan')!;
    final polaris = catalogStars.firstWhere((s) => s.name == 'Polaris');

    double separation(Equatorial a, Equatorial b) {
      final d1 = a.dec * pi / 180, d2 = b.dec * pi / 180;
      final dr = (a.ra - b.ra) * pi / 180;
      final c = sin(d1) * sin(d2) + cos(d1) * cos(d2) * cos(dr);
      return acos(c.clamp(-1.0, 1.0).toDouble()) * 180 / pi;
    }

    test('the catalogue is complete and in order', () {
      expect(catalogConstellations.length, 89);
      expect(catalogStars.first.name, 'Sirius');
      for (var i = 1; i < catalogStars.length; i++) {
        expect(catalogStars[i].mag >= catalogStars[i - 1].mag, isTrue,
            reason: 'star $i is out of order');
      }
      for (final c in catalogConstellations) {
        expect(c.lines, isNotEmpty, reason: c.id);
        for (final line in c.lines) {
          expect(line.length.isEven, isTrue, reason: c.id);
          expect(line.length >= 4, isTrue, reason: c.id);
        }
      }
      expect(catalogDeepSky.length, 12);
      expect(constellationIndex('Ori'), isNonNegative);
      expect(constellationIndex('zzz'), -1);
    });

    test('precession moves Sirius about 0.28 degrees and nothing in 2000', () {
      const sirius = Equatorial(101.2875, -16.7161);
      final j2000 = DateTime.utc(2000, 1, 1, 12);
      expect(separation(sirius, precessFromJ2000(sirius, j2000)), lessThan(0.01));
      final now = precessFromJ2000(sirius, DateTime.utc(2026, 6, 1));
      final shift = separation(sirius, now);
      // Sirius is 39.6 degrees south of the ecliptic, so it moves
      // 50.3" * sin(129.6 deg) = 38.8" a year: 0.28 degrees in 26.4 years.
      expect(shift, greaterThan(0.25));
      expect(shift, lessThan(0.32));
      // A star on the ecliptic moves the full 50.3" a year, about 0.37.
      const onEcliptic = Equatorial(0, 0);
      final full =
          separation(onEcliptic, precessFromJ2000(onEcliptic, DateTime.utc(2026, 6, 1)));
      expect(full, greaterThan(0.3));
      expect(full, lessThan(0.4));
    });

    test('Polaris stands as high as the latitude, all day long', () {
      for (final city in <City>[yerevan, cityById('london')!]) {
        for (var hour = 0; hour < 24; hour += 3) {
          final date = DateTime.utc(2026, 11, 3, hour);
          final eq = precessFromJ2000(Equatorial(polaris.ra, polaris.dec), date);
          final h = toHorizontal(eq, date, city.lat, city.lon);
          expect((h.altitude - city.lat).abs(), lessThan(1.0),
              reason: '${city.id} at $hour');
        }
      }
    });

    test('Sirius reaches its expected height from Yerevan', () {
      var best = -90.0;
      for (var m = 0; m < 1440; m += 3) {
        final date = DateTime.utc(2026, 1, 10).add(Duration(minutes: m));
        final eq = precessFromJ2000(const Equatorial(101.2875, -16.7161), date);
        best = max(best, toHorizontal(eq, date, yerevan.lat, yerevan.lon).altitude);
      }
      expect(best, closeTo(90 - yerevan.lat - 16.77, 0.3));
    });

    test('a frame has one entry for every star and constellation', () {
      final f = SkyFrame.at(DateTime.utc(2026, 11, 3, 20), yerevan.lat, yerevan.lon);
      expect(f.stars.length, catalogStars.length);
      expect(f.lines.length, catalogConstellations.length);
      expect(f.centres.length, catalogConstellations.length);
      expect(f.bodies.keys, containsAll(<String>['sun', 'moon', 'mars']));
      expect(f.bodies.length, 2 + skyPlanets.length);
    });

    test('the view puts the middle in the middle and the edge at the edge', () {
      const v = SkyView(
          centerAz: 90, centerAlt: 0, fov: 100, width: 400, height: 800);
      final mid = v.project(const Horizontal(0, 90))!;
      expect(mid.dx, closeTo(200, 1e-6));
      expect(mid.dy, closeTo(400, 1e-6));
      // Half the field of view to the east is the right edge.
      expect(v.project(const Horizontal(0, 140))!.dx, closeTo(400, 1e-6));
      expect(v.project(const Horizontal(0, 40))!.dx, closeTo(0, 1e-6));
      // Straight behind you is not drawn.
      expect(v.project(const Horizontal(0, 270)), isNull);
    });

    test('projecting and unprojecting gives the same direction back', () {
      const v = SkyView(
          centerAz: 200, centerAlt: 40, fov: 80, width: 360, height: 640);
      for (final h in const <Horizontal>[
        Horizontal(40, 200),
        Horizontal(10, 170),
        Horizontal(65, 250),
        Horizontal(25, 220),
      ]) {
        final o = v.project(h)!;
        final back = v.unproject(o);
        expect(skyAngle(h, back), lessThan(1e-6));
      }
      expect(skyAngle(const Horizontal(0, 0), const Horizontal(0, 90)),
          closeTo(90, 1e-9));
    });

    test('bright stars get bigger dots', () {
      expect(starRadius(-1.4), greaterThan(starRadius(1)));
      expect(starRadius(1), greaterThan(starRadius(4)));
      expect(starRadius(9), 0.7);
    });
  });

  group('binocular guide', () {
    final london = cityById('london')!;
    final pleiades = catalogDeepSky.firstWhere((d) => d.id == 'M45');
    final lagoon = catalogDeepSky.firstWhere((d) => d.id == 'M8');

    test('the night window is a long stretch of dark', () {
      final w = nightWindow(DateTime(2026, 12, 15), london.lat, london.lon);
      final hours = w.end.difference(w.start).inMinutes / 60;
      expect(hours, greaterThan(8));
      expect(hours, lessThan(16));
    });

    test('the window still exists when the sky never gets dark', () {
      // Tromso at midsummer has no astronomical night.
      final w = nightWindow(DateTime(2026, 6, 21), 69.65, 18.96);
      expect(w.end.isAfter(w.start), isTrue);
    });

    test('the Pleiades are high on a December night, the Lagoon is not up', () {
      final w = nightWindow(DateTime(2026, 12, 15), london.lat, london.lon);
      final p = bestView(pleiades, w.start, w.end, london.lat, london.lon);
      expect(p.visible, isTrue);
      expect(p.position.altitude, greaterThan(55));
      final m = bestView(lagoon, w.start, w.end, london.lat, london.lon);
      expect(m.visible, isFalse);
      expect(p.time.isAfter(w.start.subtract(const Duration(minutes: 1))), isTrue);
      expect(p.time.isBefore(w.end.add(const Duration(minutes: 1))), isTrue);
    });
  });

  test('every constellation story exists in English', () {
    final l = lookupAppLocalizations(const Locale('en'));
    for (final id in <String>[
      'Ori', 'UMa', 'UMi', 'Cas', 'Cyg', 'Sco', 'Leo', 'Tau', 'Gem', 'Lyr', 'Cru'
    ]) {
      expect(constellationStory(l, id), isNotNull, reason: id);
      expect(constellationIndex(id), isNonNegative, reason: id);
    }
    expect(constellationStory(l, 'And'), isNull);
  });

  test('numbers use the language format', () {
    expect(formatNumberFor('en', 1234.5, decimals: 1), '1,234.5');
    expect(formatNumberFor('en', 20.95, decimals: 2), '20.95');
    expect(formatNumberFor('en', 2.0, decimals: 2), '2');
    expect(formatNumberFor('zz', 5), '5');
  });

  group('backup', () {
    const mine = HelioraSettings(
      themeMode: ThemeMode.dark,
      localeCode: 'hi',
      viewMode: ViewMode.globe,
      bestQuizScore: 6,
      birthDateMs: 946728000000,
      cityId: 'yerevan',
      reminders: <String>['iss:202611051200', 'full-moon-20261124'],
      onlineFeatures: true,
      quizBests: <String, int>{'easy': 9, 'hard': 4},
      tonightAlert: true,
      tonightMinutes: 21 * 60,
      favorites: <String>['mars', 'apollo-11'],
      textScalePercent: 115,
      lastUpdateCheckMs: 5,
    );

    test('a backup brings every setting back', () {
      final text = buildBackup(mine, DateTime.utc(2026, 11, 5), '1.17.0');
      final back = parseBackup(text);
      expect(back.themeMode, ThemeMode.dark);
      expect(back.localeCode, 'hi');
      expect(back.viewMode, ViewMode.globe);
      expect(back.birthDateMs, 946728000000);
      expect(back.cityId, 'yerevan');
      expect(back.onlineFeatures, isTrue);
      expect(back.quizBests, <String, int>{'easy': 9, 'hard': 4});
      expect(back.tonightAlert, isTrue);
      expect(back.tonightMinutes, 21 * 60);
      expect(back.favorites, <String>['mars', 'apollo-11']);
      expect(back.textScalePercent, 115);
      expect(isHelioraBackup(text), isTrue);
    });

    test('restoring drops event bells and keeps this phone\'s update time',
        () {
      final back = parseBackup(buildBackup(mine, DateTime.utc(2026, 11, 5), ''));
      const current =
          HelioraSettings(lastUpdateCheckMs: 77, reminders: <String>['x']);
      final next = restoredSettings(current, back);
      expect(next.reminders, isEmpty);
      expect(next.lastUpdateCheckMs, 77);
      expect(next.favorites, <String>['mars', 'apollo-11']);
      expect(next.tonightAlert, isTrue);
      expect(next.cityId, 'yerevan');
    });

    test('a language that no longer exists falls back to the phone', () {
      const old = HelioraSettings(localeCode: 'ru');
      final back = parseBackup(buildBackup(old, DateTime.utc(2026, 11, 5), ''));
      expect(back.localeCode, '');
    });

    test('files that are not a Heliora backup are refused', () {
      expect(() => parseBackup('nope'), throwsFormatException);
      expect(() => parseBackup('[]'), throwsFormatException);
      expect(() => parseBackup('{"app":"other","format":1,"settings":{}}'),
          throwsFormatException);
      expect(() => parseBackup('{"app":"heliora","format":99,"settings":{}}'),
          throwsFormatException);
      expect(() => parseBackup('{"app":"heliora","format":1}'),
          throwsFormatException);
      expect(() => parseBackup('x' * (maxBackupChars + 1)),
          throwsFormatException);
      expect(isHelioraBackup('{"app":"heliora"}'), isFalse);
    });
  });
}
