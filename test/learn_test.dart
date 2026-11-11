import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/data/learn_data.dart';
import 'package:heliora/data/settings.dart';

void main() {
  group('learn', () {
    final data = LearnData.parse(File('assets/learn/learn.json').readAsStringSync());

    test('lessons are all there, in both languages', () {
      expect(data.groups.map((g) => g.id), <String>['blackholes', 'galaxies', 'students']);
      expect(data.group('blackholes')!.lessons.length, 7);
      expect(data.group('galaxies')!.lessons.length, 7);
      expect(data.group('students')!.lessons.length, 6);
      for (final g in data.groups) {
        for (final l in g.lessons) {
          expect(l.title.en, isNotEmpty, reason: l.id);
          expect(l.title.hi, isNotEmpty, reason: l.id);
          expect(l.blocks.length, greaterThan(3), reason: l.id);
          for (final b in l.blocks) {
            if (b.kind == 'row') {
              expect(b.cells, isNotEmpty);
            } else {
              expect(b.text.en.trim(), isNotEmpty, reason: '${l.id} ${b.kind}');
            }
          }
        }
      }
      final keys = <String>{for (final g in data.groups) for (final l in g.lessons) l.key};
      expect(keys.length, 20);
    });

    test('every student lesson has a quiz with valid answers', () {
      for (final l in data.group('students')!.lessons) {
        expect(l.quiz.length, 3, reason: l.id);
        for (final q in l.quiz) {
          expect(q.answer, inInclusiveRange(0, q.options.length - 1));
        }
      }
    });

    test('reference lists and the deep space quiz', () {
      expect(data.glossary.length, greaterThan(30));
      expect(data.timeline.first.when, 0);
      expect(data.future, isNotEmpty);
      expect(data.scale.length, greaterThan(10));
      expect(data.quiz.where((q) => q.set == 'bh').length, greaterThanOrEqualTo(5));
      expect(data.quiz.where((q) => q.set == 'gx').length, greaterThanOrEqualTo(5));
      expect(deepQuizKey('bh'), 'ds-bh');
    });

    test('broken data does not crash', () {
      final d = LearnData.parse('{"groups":[{"id":"x","lessons":[{"blocks":[1,{"t":"row"}]}]}],"quiz":[{"o":[]}]}');
      expect(d.groups.single.lessons.single.blocks.length, 1);
      expect(d.quiz, isEmpty);
    });

    test('new settings keep their values and old files still load', () {
      const s = HelioraSettings(readLessons: <String>['blackholes/what-is-a-black-hole'], seen: <String, int>{'moon': 5}, placeName: 'Patna');
      final back = HelioraSettings.fromJson(jsonDecode(jsonEncode(s.toJson())) as Map<String, dynamic>);
      expect(back.readLessons, s.readLessons);
      expect(back.seen, s.seen);
      expect(back.placeName, 'Patna');
      final old = HelioraSettings.fromJson(<String, dynamic>{'cityId': 'delhi', 'favorites': <String>['mars']});
      expect(old.readLessons, isEmpty);
      expect(old.seen, isEmpty);
      expect(old.cityId, 'delhi');
      expect(old.favorites, <String>['mars']);
    });
  });
}
