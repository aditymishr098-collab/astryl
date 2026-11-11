import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/core/universe.dart';
import 'package:heliora/data/universe_catalog.dart';
import 'package:heliora/l10n/gen/app_localizations.dart';
import 'package:heliora/screens/universe_screen.dart';

Map<String, dynamic> _arb(String lang) =>
    jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  group('universe map', () {
    final universe = Universe.load();
    final now = DateTime.utc(2026, 11, 11);

    UBody byId(String id) => universe.bodies.firstWhere((b) => b.id == id);

    test('the catalogue is complete', () {
      final galaxies =
          universe.bodies.where((b) => b.kind == UKind.galaxy).toList();
      expect(galaxies.length, greaterThan(3000));
      expect(holeRows.length, greaterThanOrEqualTo(60));
      final ids = universe.bodies.map((b) => b.id).toList();
      expect(ids.toSet().length, ids.length);
      for (final b in universe.bodies) {
        expect(b.base.length.isFinite, isTrue, reason: b.id);
        expect(b.base.length, lessThan(observableRadiusLy), reason: b.id);
        expect(b.radiusLy, greaterThan(0), reason: b.id);
      }
    });

    test('Andromeda is where it should be', () {
      final m31 = byId('NGC0224');
      expect(m31.name, 'Andromeda Galaxy');
      expect(m31.distLy, closeTo(2.5e6, 1e5));
      expect(m31.estimated, isFalse);
      expect(m31.shape, GalaxyShape.spiral);
      final d = m31.base.unit;
      final expected = fromEquatorial(10.685, 41.269, 1);
      expect(d.dot(expected), closeTo(1, 1e-9));
    });

    test('M87* sits in its galaxy', () {
      final hole = byId('M87*');
      final galaxy = byId('NGC4486');
      expect((hole.base - galaxy.base).length, lessThan(galaxy.radiusLy));
      expect(hole.massSuns, 6.5e9);
    });

    test('the centre of the Milky Way', () {
      expect(galacticCentre.length, closeTo(sunToCentreLy, 1e-6));
      expect(galacticCentre.unit.dot(galacticCentreDir), greaterThan(0.9999));
      final hole = byId('Sagittarius A*');
      expect((hole.base - galacticCentre).length, lessThan(5));
      // The three galactic axes are at right angles.
      expect(galacticCentreDir.dot(galacticSpinDir).abs(), lessThan(1e-6));
      expect(galacticCentreDir.cross(galacticSpinDir).dot(galacticNorth),
          closeTo(1, 1e-6));
    });

    test('the Sun goes once around the Galaxy in a galactic year', () {
      final home = turnWithGalaxy(V3.zero, galacticYear);
      expect(home.length, lessThan(1e-3));
      final quarter = turnWithGalaxy(V3.zero, galacticYear / 4);
      expect((quarter - galacticCentre).length, closeTo(sunToCentreLy, 1e-3));
      // It sets off in the direction of galactic rotation.
      final soon = turnWithGalaxy(V3.zero, 1e6);
      expect(soon.unit.dot(galacticSpinDir), greaterThan(0.99));
    });

    test('planets keep their orbit, also far from today', () {
      for (final years in <double>[0, 10, 5000, 2.5e7]) {
        final earth = planetOffset('earth', 365.256, now, years);
        expect(earth.length * auPerLightYear, inInclusiveRange(0.98, 1.02));
        final neptune = planetOffset('neptune', 60182, now, years);
        expect(neptune.length * auPerLightYear, inInclusiveRange(29.7, 30.5));
      }
      expect(orbitLine('mars', 686.98, now).length, 96);
      final earth = byId('earth');
      final sun = universe.positionOf(universe.sun, now, 1e6);
      final at = universe.positionOf(earth, now, 1e6);
      expect((at - sun).length * auPerLightYear, inInclusiveRange(0.98, 1.02));
    });

    test('zoom levels and speeds', () {
      for (final level in ULevel.values) {
        expect(levelFor(levelDistance[level]!), level);
      }
      expect(yearsPerSecond(USpeed.real) * 365.25 * 86400, closeTo(1, 1e-9));
      expect(yearsPerSecond(USpeed.fastest), 25e6);
    });

    test('search and names', () {
      expect(catalogueName('NGC0224'), 'NGC 224');
      expect(catalogueName('IC0010'), 'IC 10');
      expect(universe.find('andromeda').map((b) => b.id), contains('NGC0224'));
      expect(universe.find('ton 618').single.kind, UKind.blackHole);
      expect(universe.find('').length, greaterThan(20));
      expect(universe.find('zzzz-nothing'), isEmpty);
    });

    test('galaxy clouds', () {
      final cloud = milkyWayCloud();
      expect(cloud.points.length, greaterThan(3000));
      expect(cloud.points.length, cloud.groups.length);
      for (final shape in GalaxyShape.values) {
        expect(galaxyTemplate(shape).length, greaterThan(100));
      }
      final axes = galaxyAxes(byId('NGC0224').base, 35, 0.39);
      expect(axes[0].dot(axes[1]).abs(), lessThan(1e-9));
      expect(axes[0].dot(axes[2]).abs(), lessThan(1e-9));
      expect(axes[2].length, closeTo(1, 1e-9));
    });

    test('both languages have the same texts', () {
      final en = _arb('en').keys.where((k) => k.startsWith('uni')).toSet();
      final hi = _arb('hi').keys.where((k) => k.startsWith('uni')).toSet();
      expect(en.length, greaterThan(40));
      expect(hi, en);
    });

    testWidgets('the page opens, flies and takes taps', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: UniverseScreen(),
      ));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Universe map'), findsOneWidget);

      for (final label in <String>['Milky Way', 'Galaxies', 'Nearby stars']) {
        await tester.tap(find.text(label));
        for (var i = 0; i < 40; i++) {
          await tester.pump(const Duration(milliseconds: 80));
        }
      }
      await tester.dragFrom(
          tester.getCenter(find.byType(Scaffold)), const Offset(60, 25));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tapAt(tester.getCenter(find.byType(Scaffold)));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('1 year per second'));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(tester.takeException(), isNull);
    });
  });
}
