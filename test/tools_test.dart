import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/screens/birthday_extras.dart';
import 'package:heliora/screens/tools_screens.dart';

void main() {
  group('tools', () {
    test('black hole numbers', () {
      expect(schwarzschildRadius(1.989e30), closeTo(2954, 5));
      expect(hawkingTemperature(1.989e30), closeTo(6.2e-8, 0.1e-8));
      expect(evaporationSeconds(1.989e30) / 3.15576e7, closeTo(2.1e67, 0.2e67));
      expect(clockRate(1), 0);
      expect(clockRate(4), closeTo(0.866, 0.001));
      expect(sci(2.954e3), '2954');
      expect(sci(6.2e-8), contains('10⁻⁸'));
    });

    test('planets on a birthday', () {
      // 15 July 1998: Saturn was in Aries and Jupiter in Pisces.
      final day = DateTime.utc(1998, 7, 15, 12);
      expect(planetPlace('saturn', day).$1, 'Aries');
      expect(planetPlace('jupiter', day).$1, 'Pisces');
      expect(planetPlace('mercury', day).$3, 1); // evening sky
    });

    test('birthday light', () {
      final (passed, next) = birthdayLight(DateTime.utc(1998, 7, 15), DateTime.utc(2026, 11, 11));
      expect(passed.first.$1, 'Proxima Centauri');
      expect(passed.last.$2, lessThanOrEqualTo(28.4));
      expect(next, isNotNull);
      expect(next!.$2, greaterThan(28.3));
      expect(spaceHistory.length, greaterThan(10));
    });

    testWidgets('telescope simulator opens and changes', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: TelescopeScreen()));
      await tester.pump();
      expect(find.text('36×'), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(find.text('72×'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('black hole lab opens and takes input', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: BlackHoleLabScreen()));
      await tester.pump();
      expect(find.text('3.0 km'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '0');
      await tester.pump();
      expect(find.text('Enter a mass above zero.'), findsOneWidget);
      await tester.drag(find.byType(CustomPaint).first, const Offset(30, 10));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
