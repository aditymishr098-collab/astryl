import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/data/cities.dart';
import 'package:heliora/data/world_cities.dart';
import 'package:heliora/screens/constellations_screen.dart';

void main() {
  group('world cities', () {
    test('a letter file reads and search finds cities', () {
      final rows = parseShard(File('assets/cities/p.json').readAsStringSync());
      expect(rows.length, greaterThan(1000));
      final found = filterCities(rows, foldName('Patna'));
      expect(found.any((c) => c.name == 'Patna' && c.countryCode == 'IN'), isTrue);
      expect(foldName('São Paulo'), 'sao paulo');
      expect(parseShard('[["x"],1,["Ok","IN",1,2]]').single.name, 'Ok');
    });

    test('every letter file exists', () {
      for (final k in <String>['_', ...'abcdefghijklmnopqrstuvwxyz'.split('')]) {
        expect(File('assets/cities/$k.json').existsSync(), isTrue, reason: k);
      }
    });

    test('a picked place becomes a city', () {
      setPlace('Patna', 25.59, 85.14);
      final c = cityById(placeCityId)!;
      expect(c.name, 'Patna');
      expect(c.lat, 25.59);
      setPlace(null, null, null);
      expect(cityById(placeCityId), isNull);
    });
  });

  group('constellations', () {
    final all = allConstellations();

    test('there are 88, Serpens once with head and tail', () {
      expect(all.length, 88);
      final ser = all.singleWhere((c) => c.id == 'Ser');
      expect(ser.lines.length, 2);
      expect(ser.points.any((p) => (p.$1 - 236.067).abs() < 0.01), isTrue); // Unukalhai, in the head
    });

    test('facts make sense', () {
      final ori = all.singleWhere((c) => c.id == 'Ori');
      expect(brightestStar(ori)!.name, 'Rigel');
      expect(ori.bestMonth, 0); // January
      expect(ori.topFromIndia, greaterThan(25));
      final oct = all.singleWhere((c) => c.id == 'Oct');
      expect(oct.topFromIndia, lessThan(5));
    });
  });
}
