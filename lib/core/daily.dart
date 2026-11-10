import '../data/planets.dart';
import 'quiz.dart';

Planet? _body(Object? id) {
  if (id is! String) {
    return null;
  }
  for (final body in allBodies) {
    if (body.id == id) {
      return body;
    }
  }
  return null;
}

/// Reads the "questions" list the server sends for today's Daily 5. The
/// server picks the questions (the same five for everybody each UTC day) and
/// later checks the answers; the right answer shown on the phone after each
/// pick comes from the app's own quiz data, which the tests keep equal to the
/// server's. Returns null when anything is not understood (for example a
/// question kind newer than this version of the app).
List<QuizQuestion>? parseDaily(Object? raw) {
  if (raw is! List || raw.length != 5) {
    return null;
  }
  final out = <QuizQuestion>[];
  for (final item in raw) {
    if (item is! Map) {
      return null;
    }
    final kind = QuizKind.values.asNameMap()[item['k']];
    final options = item['o'];
    if (kind == null || options is! List || options.length < 2) {
      return null;
    }
    final bodies = <Planet>[];
    for (final id in options) {
      final body = _body(id);
      if (body == null) {
        return null;
      }
      bodies.add(body);
    }
    final answer = answerFor(kind);
    if (!bodies.any((b) => b.id == answer.id)) {
      return null;
    }
    out.add(QuizQuestion(kind, bodies, answer));
  }
  return out;
}
