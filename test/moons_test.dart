import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/core/badges.dart';
import 'package:heliora/core/moons.dart';

// The expected numbers come from the same formulas running as JavaScript on
// astryl.space (tools/site_src/moons.js), so the app and the site agree.
typedef _Case = (DateTime, List<List<double>>, List<List<double>>, double);

final List<_Case> _cases = <_Case>[
  (DateTime.utc(2000, 1, 1, 12, 0), <List<double>>[[1.312543, 0.293272, 5.729912], [0.714551, -0.474608, -9.272814], [3.444400, -0.744654, -14.548927], [-21.342715, 0.790104, 15.436929]],
    <List<double>>[[2.991304, 0.126726, -0.380653], [3.876727, 0.193445, -0.563765], [4.879997, -0.076227, -0.064035], [6.182436, 0.276308, -0.800289], [-5.593092, 2.233816, -6.329788], [-20.502093, 1.217929, -3.200067], [-16.098257, -5.340119, 16.617763], [-0.229003, 15.823645, -58.315850],
  ], -19.046083),
  (DateTime.utc(2015, 6, 15, 3, 0), <List<double>>[[5.496395, 0.005172, -2.224551], [-4.598817, 0.019025, -8.183123], [-3.486815, -0.033928, 14.593293], [0.216605, -0.061608, 26.499728]],
    <List<double>>[[-1.280379, -1.195183, -2.562851], [1.321556, 1.527679, 3.406036], [4.792406, -0.326574, -0.867288], [-6.062764, 0.637602, 1.423595], [-5.659676, 2.677340, 6.071335], [17.228577, -4.509436, -10.388548], [23.698729, 3.245771, 6.307953], [-26.896014, 7.625988, 52.308799],
  ], 24.175999),
  (DateTime.utc(2026, 11, 11, 0, 0), <List<double>>[[0.469431, -0.022656, 5.907683], [9.269836, -0.006447, 1.681197], [-6.491526, 0.051723, -13.486890], [21.848465, 0.055264, -14.410390]],
    <List<double>>[[-0.119184, 0.303454, -3.111113], [2.641535, 0.326590, -2.928910], [3.439311, 0.357087, -3.445614], [-5.607499, 0.305839, -2.714125], [-6.638807, -0.650250, 5.620810], [12.383071, 1.759880, -16.285571], [-25.454790, -0.347953, 7.728611], [-56.510776, 16.192116, -2.455920],
  ], -6.396778),
  (DateTime.utc(2040, 3, 1, 18, 30), <List<double>>[[4.326428, -0.162220, 4.040718], [-8.649620, -0.143582, 3.576471], [8.276735, 0.500441, -12.465404], [26.222184, -0.084745, 2.110895]],
    <List<double>>[[3.072285, 0.076701, 0.029564], [3.502582, 0.224778, 1.794463], [-2.435756, -0.570553, -4.191358], [-1.730556, -0.744995, -5.970723], [-5.206252, -0.920374, -6.932829], [13.596606, 2.063526, 15.525579], [-17.229875, 1.999120, 17.803019], [-3.995898, 10.376505, 59.602806],
  ], 7.112405),
];

void main() {
  group('moons', () {
    for (final c in _cases) {
      test('${c.$1.toIso8601String()} matches the website', () {
        final jup = jupiterMoons(c.$1);
        expect(jup.length, 4);
        for (var i = 0; i < 4; i++) {
          expect(jup[i].x, closeTo(c.$2[i][0], 1e-4));
          expect(jup[i].y, closeTo(c.$2[i][1], 1e-4));
          expect(jup[i].z, closeTo(c.$2[i][2], 1e-4));
        }
        final sat = saturnMoons(c.$1);
        expect(sat.length, 8);
        for (var i = 0; i < 8; i++) {
          expect(sat[i].x, closeTo(c.$3[i][0], 1e-4));
          expect(sat[i].y, closeTo(c.$3[i][1], 1e-4));
          expect(sat[i].z, closeTo(c.$3[i][2], 1e-4));
        }
        expect(saturnRingTilt(c.$1), closeTo(c.$4, 1e-4));
      });
    }

    test('Callisto stays about 26 Jupiter radii from the planet', () {
      final p = jupiterMoons(DateTime.utc(2026, 11, 11, 0, 0))[3];
      expect(p.apparentDistance, lessThan(27.5));
      expect(p.apparentDistance, greaterThan(20));
    });
  });

  group('badges', () {
    test('reads the server numbers', () {
      final s = DailyStats.fromJson(<String, Object?>{
        'streak': 2,
        'best': 8,
        'perfect': 1,
        'plays': 12,
      });
      expect(s, isNotNull);
      expect(s!.streak, 2);
      expect(s.best, 8);
    });

    test('is null when the server sent nothing', () {
      expect(DailyStats.fromJson(null), isNull);
    });

    test('lights the right badges', () {
      final earned = badgesFor(const DailyStats(
              streak: 2, best: 8, perfect: 1, plays: 12))
          .where((b) => b.earned)
          .map((b) => b.id)
          .toList();
      expect(earned, <String>['first', 's3', 's7', 'perfect', 'p10']);
    });

    test('a new person has no badges', () {
      expect(badgesFor(const DailyStats()).where((b) => b.earned), isEmpty);
    });
  });
}
