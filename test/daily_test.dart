import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/core/daily.dart';
import 'package:heliora/core/quiz.dart';
import 'package:heliora/data/account_store.dart';

void main() {
  test('the server quiz bank agrees with the app\'s quiz', () {
    final bank = jsonDecode(
            File('supabase/functions/account/quiz_bank.json').readAsStringSync())
        as Map<String, dynamic>;
    expect(bank.keys.toList(), QuizKind.values.map((k) => k.name).toList(),
        reason: 'same kinds, easy then medium then hard');
    for (final kind in QuizKind.values) {
      final entry = bank[kind.name] as Map<String, dynamic>;
      expect(entry['a'], answerFor(kind).id, reason: '${kind.name} answer');
      final pool = (entry['pool'] as List).cast<String>().toSet();
      final expected = distractorsFor(kind)
          .map((b) => b.id)
          .where((id) => id != answerFor(kind).id)
          .toSet();
      expect(pool, expected, reason: '${kind.name} wrong answers');
    }
  });

  test('parseDaily reads five questions and refuses anything else', () {
    List<String> optionsFor(QuizKind kind) {
      final answer = answerFor(kind).id;
      final others = <String>['mars', 'venus', 'earth', 'mercury', 'jupiter']
          .where((id) => id != answer)
          .take(3);
      return <String>[...others, answer];
    }

    final kinds = <QuizKind>[
      QuizKind.largest,
      QuizKind.coldest,
      QuizKind.volcanicMoon,
      QuizKind.longestDay,
      QuizKind.secondLargestMoon,
    ];
    final good = <Map<String, Object>>[
      for (final k in kinds)
        <String, Object>{'k': k.name, 'o': optionsFor(k)},
    ];
    final parsed = parseDaily(good);
    expect(parsed, isNotNull);
    expect(parsed!.length, 5);
    expect(parsed.first.kind, QuizKind.largest);
    expect(parsed.first.answer.id, 'jupiter');
    expect(parsed[1].answer.id, 'neptune');
    expect(parsed[1].options.map((b) => b.id), contains('neptune'));

    expect(parseDaily(good.take(4).toList()), isNull);
    expect(parseDaily(null), isNull);
    final unknownKind = List<Map<String, Object>>.of(good)
      ..[2] = <String, Object>{'k': 'newQuestion', 'o': <String>['mars', 'venus']};
    expect(parseDaily(unknownKind), isNull);
    final unknownBody = List<Map<String, Object>>.of(good)
      ..[0] = <String, Object>{'k': 'largest', 'o': <String>['mars', 'vulcan']};
    expect(parseDaily(unknownBody), isNull);
    final noRightAnswer = List<Map<String, Object>>.of(good)
      ..[0] = <String, Object>{'k': 'largest', 'o': <String>['mars', 'venus']};
    expect(parseDaily(noRightAnswer), isNull);
  });

  test('points: 100 per right answer plus up to 20 for speed', () {
    // The server works the score out the same way (see the account function).
    expect(dailyFivePoints(0, 1000), 0);
    expect(dailyFivePoints(5, 0), 600);
    expect(dailyFivePoints(5, 120000), 500);
    expect(dailyFivePoints(5, 600000), 500);
    expect(dailyFivePoints(3, 60000), 330);
  });

  test('showOnBoard is on by default and survives a round trip', () {
    expect(const AccountPrefs().showOnBoard, isTrue);
    final off = const AccountPrefs().copyWith(showOnBoard: false);
    final back = AccountPrefs.fromJson(
        jsonDecode(jsonEncode(off.toJson())) as Map<String, dynamic>);
    expect(back.showOnBoard, isFalse);
    expect(AccountPrefs.fromJson(<String, dynamic>{}).showOnBoard, isTrue);
  });
}
