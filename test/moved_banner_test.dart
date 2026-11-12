import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/widgets/moved_banner.dart';

void main() {
  testWidgets('the website notice shows and points to astryl.space', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: MovedBanner())));
    expect(find.text('Astryl is now on the website'), findsOneWidget);
    expect(find.text('Open astryl.space'), findsOneWidget);
    expect(astrylSite, 'https://astryl.space');
    expect(tester.takeException(), isNull);
  });
}
