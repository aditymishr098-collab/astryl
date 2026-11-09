import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/data/surface_sites.dart';
import 'package:heliora/screens/surface_map_screen.dart';

Map<String, dynamic> _arb(String lang) =>
    jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('the surface maps have the expected number of sites', () {
    expect(sitesOf(SurfaceWorld.moon).length, 15);
    expect(sitesOf(SurfaceWorld.mars).length, 10);
    final ids = surfaceSites.map((s) => s.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('every site and feature sits on the map', () {
    for (final s in surfaceSites) {
      expect(s.lat, inInclusiveRange(-90, 90), reason: s.name);
      expect(s.lon, inInclusiveRange(-180, 180), reason: s.name);
    }
    for (final f in surfaceFeatures) {
      expect(f.lat, inInclusiveRange(-90, 90), reason: f.id);
      expect(f.lon, inInclusiveRange(-180, 180), reason: f.id);
      expect(f.rx, greaterThan(0), reason: f.id);
      expect(f.ry, greaterThan(0), reason: f.id);
    }
  });

  test('every site story and landform name is translated', () {
    for (final lang in <String>['en', 'hi']) {
      final arb = _arb(lang);
      for (final s in surfaceSites) {
        expect(arb['site${s.id}'], isA<String>(), reason: '$lang ${s.id}');
      }
      for (final f in surfaceFeatures) {
        expect(arb['feat${f.id}'], isA<String>(), reason: '$lang ${f.id}');
      }
    }
  });

  test('sites are listed oldest first', () {
    for (final w in SurfaceWorld.values) {
      final years = sitesOf(w).map((s) => s.year).toList();
      expect(years, orderedEquals(<int>[...years]..sort()));
    }
  });

  test('latitude and longitude are written with N S E W', () {
    expect(formatLatLon(0.67, 23.47), '0.67° N, 23.47° E');
    expect(formatLatLon(-69.37, -12.5), '69.37° S, 12.50° W');
  });
}
