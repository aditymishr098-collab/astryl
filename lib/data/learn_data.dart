import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

/// The Learn section: lessons about black holes, galaxies and school topics,
/// a glossary, a timeline of the universe, a size scale and a quiz. The text
/// is the website's own, exported by tools/export_learn.py into
/// assets/learn/learn.json, so the app and the site say the same thing. It is
/// all offline.

/// A text in English and Hindi.
class Bi {
  const Bi(this.en, this.hi);

  factory Bi.from(Object? json) {
    if (json is Map) {
      final en = json['en'] is String ? json['en'] as String : '';
      final hi = json['hi'] is String ? json['hi'] as String : '';
      return Bi(en, hi.isEmpty ? en : hi);
    }
    return const Bi('', '');
  }

  final String en;
  final String hi;

  /// The text for the app's current language (Hindi, otherwise English).
  String of(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'hi' ? hi : en;
}

/// One piece of a lesson.
class LessonBlock {
  const LessonBlock(this.kind, this.text, {this.cells = const <Bi>[], this.head = false});

  /// h2, h3, p, callout, li or row.
  final String kind;
  final Bi text;

  /// The cells of a table row.
  final List<Bi> cells;
  final bool head;
}

class QuizQuestion {
  const QuizQuestion(this.question, this.options, this.answer, {this.explain, this.set = ''});

  final Bi question;
  final List<Bi> options;
  final int answer;
  final Bi? explain;

  /// For the deep space quiz: bh (black holes) or gx (galaxies).
  final String set;
}

class Lesson {
  const Lesson(this.id, this.groupId, this.title, this.lead, this.blocks, this.quiz);

  final String id;
  final String groupId;
  final Bi title;
  final Bi lead;
  final List<LessonBlock> blocks;
  final List<QuizQuestion> quiz;

  /// The id kept in the settings when the lesson has been read.
  String get key => '$groupId/$id';
}

class LessonGroup {
  const LessonGroup(this.id, this.title, this.lessons);

  final String id;
  final Bi title;
  final List<Lesson> lessons;
}

class GlossaryTerm {
  const GlossaryTerm(this.term, this.meaning);

  final Bi term;
  final Bi meaning;
}

class TimelineEvent {
  const TimelineEvent(this.title, this.text, {this.when = 0});

  /// For the past: years after the Big Bang. 0 for "what comes next".
  final double when;
  final Bi title;
  final Bi text;
}

class ScaleItem {
  const ScaleItem(this.name, this.metres, this.text);

  final Bi name;
  final double metres;
  final Bi text;
}

class LearnData {
  const LearnData(this.groups, this.glossary, this.timeline, this.future, this.scale, this.quiz);

  final List<LessonGroup> groups;
  final List<GlossaryTerm> glossary;
  final List<TimelineEvent> timeline;
  final List<TimelineEvent> future;
  final List<ScaleItem> scale;
  final List<QuizQuestion> quiz;

  LessonGroup? group(String id) {
    for (final g in groups) {
      if (g.id == id) {
        return g;
      }
    }
    return null;
  }

  static LearnData? _cached;
  static Future<LearnData>? _loading;

  /// Reads the lessons once; later calls get the same data.
  static Future<LearnData> load() {
    if (_cached != null) {
      return Future<LearnData>.value(_cached);
    }
    return _loading ??= rootBundle
        .loadString('assets/learn/learn.json')
        .then((text) => _cached = parse(text));
  }

  static List<QuizQuestion> _questions(Object? list) {
    final out = <QuizQuestion>[];
    if (list is! List) {
      return out;
    }
    for (final q in list) {
      if (q is! Map) {
        continue;
      }
      final opts = q['o'] is List ? <Bi>[for (final o in q['o'] as List) Bi.from(o)] : <Bi>[];
      final a = q['a'] is int ? q['a'] as int : 0;
      if (opts.length < 2 || a < 0 || a >= opts.length) {
        continue;
      }
      out.add(QuizQuestion(Bi.from(q['q']), opts, a,
          explain: q['e'] == null ? null : Bi.from(q['e']),
          set: q['s'] is String ? q['s'] as String : ''));
    }
    return out;
  }

  /// Turns the JSON of learn.json into data. Broken parts are skipped.
  static LearnData parse(String text) {
    final json = jsonDecode(text) as Map<String, dynamic>;
    final groups = <LessonGroup>[];
    for (final g in (json['groups'] as List? ?? const <Object>[])) {
      if (g is! Map) {
        continue;
      }
      final gid = g['id'] is String ? g['id'] as String : '';
      final lessons = <Lesson>[];
      for (final l in (g['lessons'] as List? ?? const <Object>[])) {
        if (l is! Map) {
          continue;
        }
        final blocks = <LessonBlock>[];
        for (final b in (l['blocks'] as List? ?? const <Object>[])) {
          if (b is! Map) {
            continue;
          }
          final kind = b['t'] is String ? b['t'] as String : 'p';
          if (kind == 'row') {
            blocks.add(LessonBlock('row', const Bi('', ''),
                cells: <Bi>[for (final c in (b['cells'] as List? ?? const <Object>[])) Bi.from(c)],
                head: b['head'] == true));
          } else {
            blocks.add(LessonBlock(kind, Bi.from(b)));
          }
        }
        lessons.add(Lesson(l['id'] is String ? l['id'] as String : '', gid, Bi.from(l['title']),
            Bi.from(l['lead']), blocks, _questions(l['quiz'])));
      }
      groups.add(LessonGroup(gid, Bi.from(g['title']), lessons));
    }
    Bi pair(Map<dynamic, dynamic> m, String en, String hi) =>
        Bi(m[en] is String ? m[en] as String : '', m[hi] is String ? m[hi] as String : '');
    List<Map<dynamic, dynamic>> maps(Object? list) =>
        <Map<dynamic, dynamic>>[for (final x in (list is List ? list : const <Object>[])) if (x is Map) x];
    return LearnData(
      groups,
      <GlossaryTerm>[for (final m in maps(json['glossary'])) GlossaryTerm(pair(m, 'en', 'hi'), pair(m, 'den', 'dhi'))],
      <TimelineEvent>[
        for (final m in maps(json['timeline']))
          TimelineEvent(pair(m, 'en', 'hi'), pair(m, 'den', 'dhi'), when: m['v'] is num ? (m['v'] as num).toDouble() : 0)
      ],
      <TimelineEvent>[for (final m in maps(json['future'])) TimelineEvent(pair(m, 'en', 'hi'), pair(m, 'den', 'dhi'))],
      <ScaleItem>[
        for (final m in maps(json['scale']))
          if (m['m'] is num) ScaleItem(pair(m, 'en', 'hi'), (m['m'] as num).toDouble(), pair(m, 'den', 'dhi'))
      ],
      _questions(json['quiz']),
    );
  }
}

/// Black holes 101: read every black hole lesson and score 4 of 5 or more in
/// the black hole quiz.
const int bh101QuizNeeded = 4;

/// The key of the deep space quiz best score of [set] in the quiz bests.
String deepQuizKey(String set) => 'ds-$set';
