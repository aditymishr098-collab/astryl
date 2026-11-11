import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/learn_data.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Picks the English or Hindi text, following the app's language.
String bi(BuildContext context, String en, String hi) =>
    Localizations.localeOf(context).languageCode == 'hi' ? hi : en;

TextStyle _h(Palette p, double size) =>
    TextStyle(fontFamily: headingFont, fontSize: size, fontWeight: FontWeight.w700, color: p.text);

/// Waits for the lessons, then builds [builder].
class _LearnLoader extends StatelessWidget {
  const _LearnLoader({required this.builder});

  final Widget Function(BuildContext context, LearnData data) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LearnData>(
      future: LearnData.load(),
      builder: (context, snap) {
        if (snap.hasData) {
          return builder(context, snap.data!);
        }
        if (snap.hasError) {
          return Center(child: Text(bi(context, 'Could not open the lessons.', 'पाठ नहीं खुल सके।')));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

/// A tappable row with an icon, a title and a line under it.
class LearnTile extends StatelessWidget {
  const LearnTile({super.key, required this.icon, required this.title, required this.sub, required this.onTap, this.done = false});

  final IconData icon;
  final String title;
  final String sub;
  final VoidCallback onTap;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        button: true,
        label: title,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: <Widget>[
                Icon(icon, color: p.accentText),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.text)),
                      if (sub.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 2),
                        Text(sub, style: TextStyle(fontSize: 13, color: p.muted, height: 1.35)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(done ? Icons.check_circle : Icons.chevron_right, color: done ? p.good : p.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The Learn hub: lesson groups, the reference pages and the quiz.
class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key, this.tools = const <Widget>[]});

  /// Extra tiles for the tools (black hole lab, telescope), added by the caller.
  final List<Widget> tools;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final settings = AppScope.of(context).settings;
    return Scaffold(
      appBar: AppBar(title: Text(bi(context, 'Learn', 'सीखिए'), style: const TextStyle(fontWeight: FontWeight.w700))),
      body: _LearnLoader(builder: (context, data) {
        final read = settings.readLessons.toSet();
        final bh = data.group('blackholes');
        final bhRead = bh == null ? 0 : bh.lessons.where((l) => read.contains(l.key)).length;
        final bhBest = settings.quizBests[deepQuizKey('bh')] ?? 0;
        final badge = bh != null && bhRead >= bh.lessons.length && bhBest >= bh101QuizNeeded;
        IconData iconFor(String id) => switch (id) {
              'blackholes' => Icons.radio_button_checked,
              'galaxies' => Icons.blur_circular,
              _ => Icons.school_outlined,
            };
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: <Widget>[
            if (bh != null)
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(bi(context, 'Black holes 101', 'Black holes 101'), style: _h(p, 18)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(value: bh.lessons.isEmpty ? 0 : bhRead / bh.lessons.length, minHeight: 8),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        badge
                            ? bi(context, '🏅 Badge earned: Black hole explorer!', '🏅 Badge मिल गया: Black hole explorer!')
                            : bi(context, '$bhRead of ${bh.lessons.length} lessons read. Read them all and score $bh101QuizNeeded of 5 in the black hole quiz to earn the badge.',
                                '${bh.lessons.length} में से $bhRead पाठ पढ़े। Badge के लिए सब पढ़िए और black hole quiz में 5 में से $bh101QuizNeeded लाइए।'),
                        style: TextStyle(fontSize: 14, color: p.text, height: 1.4)),
                  ],
                ),
              ),
            const SizedBox(height: 18),
            for (final g in data.groups) ...<Widget>[
              LearnTile(
                icon: iconFor(g.id),
                title: g.title.of(context),
                sub: bi(context, '${g.lessons.where((l) => read.contains(l.key)).length} of ${g.lessons.length} read',
                    '${g.lessons.length} में से ${g.lessons.where((l) => read.contains(l.key)).length} पढ़े'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => LessonListScreen(groupId: g.id))),
              ),
            ],
            LearnTile(
              icon: Icons.quiz_outlined,
              title: bi(context, 'Black hole and galaxy quiz', 'ब्लैक होल और galaxy quiz'),
              sub: bi(context, '5 random questions a round', 'हर round में 5 सवाल'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DeepQuizScreen())),
            ),
            const SizedBox(height: 8),
            Text(bi(context, 'Reference', 'संदर्भ'), style: _h(p, 18)),
            const SizedBox(height: 10),
            LearnTile(
              icon: Icons.straighten,
              title: bi(context, 'Scale of the universe', 'ब्रह्मांड का पैमाना'),
              sub: bi(context, 'From a proton to the observable universe', 'प्रोटॉन से दिखने वाले ब्रह्मांड तक'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ScaleScreen())),
            ),
            LearnTile(
              icon: Icons.timeline,
              title: bi(context, 'Timeline of the universe', 'ब्रह्मांड की timeline'),
              sub: bi(context, '13.8 billion years squeezed into one year', '13.8 अरब साल एक साल में'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const TimelineScreen())),
            ),
            LearnTile(
              icon: Icons.menu_book_outlined,
              title: bi(context, 'Space glossary', 'अंतरिक्ष शब्दकोश'),
              sub: bi(context, '${data.glossary.length} words explained simply', '${data.glossary.length} शब्द आसान भाषा में'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const GlossaryScreen())),
            ),
            if (tools.isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Text(bi(context, 'Tools', 'Tools'), style: _h(p, 18)),
              const SizedBox(height: 10),
              ...tools,
            ],
          ],
        );
      }),
    );
  }
}

/// The lessons of one group.
class LessonListScreen extends StatelessWidget {
  const LessonListScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    final settings = AppScope.of(context).settings;
    return _LearnLoader(builder: (context, data) {
      final g = data.group(groupId);
      return Scaffold(
        appBar: AppBar(title: Text(g?.title.of(context) ?? '', style: const TextStyle(fontWeight: FontWeight.w700))),
        body: g == null
            ? const SizedBox.shrink()
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: <Widget>[
                  for (final (i, l) in g.lessons.indexed)
                    LearnTile(
                      icon: Icons.article_outlined,
                      title: '${i + 1}. ${l.title.of(context)}',
                      sub: l.lead.of(context),
                      done: settings.readLessons.contains(l.key),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => LessonScreen(groupId: groupId, index: i))),
                    ),
                ],
              ),
      );
    });
  }
}

/// One lesson. It counts as read after a few seconds on screen.
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.groupId, required this.index});

  final String groupId;
  final int index;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  Timer? _timer;
  final Map<int, int> _picked = <int, int>{};

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 4), () async {
      final data = await LearnData.load();
      final g = data.group(widget.groupId);
      if (!mounted || g == null || widget.index >= g.lessons.length) {
        return;
      }
      await AppScope.read(context).markLessonRead(g.lessons[widget.index].key);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _block(BuildContext context, Palette p, LessonBlock b) {
    final text = b.text.of(context);
    switch (b.kind) {
      case 'h2':
        return Padding(padding: const EdgeInsets.only(top: 18, bottom: 6), child: Text(text, style: _h(p, 20)));
      case 'h3':
        return Padding(padding: const EdgeInsets.only(top: 12, bottom: 4), child: Text(text, style: _h(p, 16)));
      case 'callout':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SurfaceCard(
            borderColor: p.accent,
            child: Text(text, style: TextStyle(fontSize: 15, height: 1.5, color: p.text)),
          ),
        );
      case 'li':
        return Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Text('•  ', style: TextStyle(fontSize: 15, color: p.accentText)),
            Expanded(child: Text(text, style: TextStyle(fontSize: 15, height: 1.5, color: p.text))),
          ]),
        );
      case 'row':
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: p.border))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final c in b.cells)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(c.of(context),
                        style: TextStyle(fontSize: 13.5, height: 1.35, color: b.head ? p.muted : p.text, fontWeight: b.head ? FontWeight.w700 : FontWeight.w400)),
                  ),
                ),
            ],
          ),
        );
      default:
        return Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(text, style: TextStyle(fontSize: 15.5, height: 1.55, color: p.text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return _LearnLoader(builder: (context, data) {
      final g = data.group(widget.groupId);
      if (g == null || widget.index >= g.lessons.length) {
        return const Scaffold(body: SizedBox.shrink());
      }
      final l = g.lessons[widget.index];
      final hasNext = widget.index + 1 < g.lessons.length;
      return Scaffold(
        appBar: AppBar(title: Text(g.title.of(context), style: const TextStyle(fontWeight: FontWeight.w700))),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
          children: <Widget>[
            Text(l.title.of(context), style: _h(p, 26)),
            const SizedBox(height: 8),
            Text(l.lead.of(context), style: TextStyle(fontSize: 16, height: 1.45, color: p.muted)),
            const SizedBox(height: 8),
            for (final b in l.blocks) _block(context, p, b),
            if (l.quiz.isNotEmpty) ...<Widget>[
              const SizedBox(height: 16),
              Text(bi(context, 'Quick quiz', 'छोटी quiz'), style: _h(p, 20)),
              const SizedBox(height: 8),
              for (final (qi, q) in l.quiz.indexed)
                _QuestionCard(
                  number: qi + 1,
                  question: q,
                  picked: _picked[qi],
                  onPick: (i) => setState(() => _picked[qi] = i),
                ),
            ],
            const SizedBox(height: 16),
            if (hasNext)
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(builder: (_) => LessonScreen(groupId: widget.groupId, index: widget.index + 1))),
                icon: const Icon(Icons.arrow_forward),
                label: Text('${bi(context, 'Next', 'अगला')}: ${g.lessons[widget.index + 1].title.of(context)}'),
              ),
          ],
        ),
      );
    });
  }
}

/// A multiple-choice question that shows right and wrong once answered.
class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.number, required this.question, required this.picked, required this.onPick});

  final int number;
  final QuizQuestion question;
  final int? picked;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final answered = picked != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('$number. ${question.question.of(context)}', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600, color: p.text)),
            const SizedBox(height: 10),
            for (final (i, o) in question.options.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    side: BorderSide(
                        color: !answered
                            ? p.border
                            : i == question.answer
                                ? p.good
                                : (i == picked ? p.bad : p.border),
                        width: answered && (i == question.answer || i == picked) ? 2 : 1),
                  ),
                  onPressed: answered ? null : () => onPick(i),
                  child: Text(o.of(context), style: TextStyle(color: p.text)),
                ),
              ),
            if (answered) ...<Widget>[
              Text(picked == question.answer ? bi(context, '✅ Right!', '✅ सही!') : bi(context, '❌ Not quite.', '❌ नहीं।'),
                  style: TextStyle(fontWeight: FontWeight.w700, color: picked == question.answer ? p.good : p.bad)),
              if (question.explain != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(question.explain!.of(context), style: TextStyle(fontSize: 14, height: 1.4, color: p.muted)),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// The black hole and galaxy quiz: 5 random questions from a set.
class DeepQuizScreen extends StatefulWidget {
  const DeepQuizScreen({super.key});

  @override
  State<DeepQuizScreen> createState() => _DeepQuizScreenState();
}

class _DeepQuizScreenState extends State<DeepQuizScreen> {
  String _set = 'bh';
  List<QuizQuestion> _round = const <QuizQuestion>[];
  int _index = 0;
  int _score = 0;
  int? _picked;
  bool _newBest = false;
  final math.Random _random = math.Random();

  void _start(LearnData data, String set) {
    final pool = data.quiz.where((q) => set == 'all' || q.set == set).toList()..shuffle(_random);
    setState(() {
      _set = set;
      _round = pool.take(5).toList();
      _index = 0;
      _score = 0;
      _picked = null;
      _newBest = false;
    });
  }

  Future<void> _next() async {
    if (_index + 1 < _round.length) {
      setState(() {
        _index++;
        _picked = null;
      });
      return;
    }
    final best = await AppScope.read(context).recordDeepQuiz(_set, _score);
    if (mounted) {
      setState(() {
        _index++;
        _newBest = best;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final settings = AppScope.of(context).settings;
    return Scaffold(
      appBar: AppBar(title: Text(bi(context, 'Black hole and galaxy quiz', 'ब्लैक होल और galaxy quiz'), style: const TextStyle(fontWeight: FontWeight.w700))),
      body: _LearnLoader(builder: (context, data) {
        if (_round.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _round.isEmpty) {
              _start(data, _set);
            }
          });
          return const SizedBox.shrink();
        }
        final sets = <(String, String, String)>[('bh', 'Black holes', 'ब्लैक होल'), ('gx', 'Galaxies', 'Galaxies'), ('all', 'Mixed', 'मिला-जुला')];
        final done = _index >= _round.length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: <Widget>[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final s in sets)
                  ChoiceChip(
                    label: Text('${bi(context, s.$2, s.$3)} · ${settings.quizBests[deepQuizKey(s.$1)] ?? 0}/5'),
                    selected: _set == s.$1,
                    onSelected: (_) => _start(data, s.$1),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (done)
              SurfaceCard(
                child: Column(
                  children: <Widget>[
                    Text(bi(context, 'You scored $_score out of ${_round.length}', '${_round.length} में से आपके $_score अंक'), style: _h(p, 22), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(_newBest ? bi(context, 'A new best for this set!', 'इस set का नया सबसे अच्छा score!') : bi(context, 'Your best: ${settings.quizBests[deepQuizKey(_set)] ?? 0}/5', 'आपका सबसे अच्छा: ${settings.quizBests[deepQuizKey(_set)] ?? 0}/5'),
                        style: TextStyle(color: p.muted)),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: () => _start(data, _set), child: Text(bi(context, 'Play again', 'फिर खेलिए'))),
                  ],
                ),
              )
            else ...<Widget>[
              Text(bi(context, 'Question ${_index + 1} of ${_round.length}', 'सवाल ${_index + 1} / ${_round.length}'), style: TextStyle(color: p.muted)),
              const SizedBox(height: 8),
              _QuestionCard(
                number: _index + 1,
                question: _round[_index],
                picked: _picked,
                onPick: (i) => setState(() {
                  _picked = i;
                  if (i == _round[_index].answer) {
                    _score++;
                  }
                }),
              ),
              if (_picked != null)
                FilledButton(onPressed: _next, child: Text(_index + 1 < _round.length ? bi(context, 'Next', 'अगला') : bi(context, 'See my score', 'मेरा score देखें'))),
            ],
          ],
        );
      }),
    );
  }
}

/// Words used in astronomy, with a search box.
class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(bi(context, 'Space glossary', 'अंतरिक्ष शब्दकोश'), style: const TextStyle(fontWeight: FontWeight.w700))),
      body: _LearnLoader(builder: (context, data) {
        final q = _q.trim().toLowerCase();
        final list = data.glossary
            .where((g) => q.isEmpty || '${g.term.en} ${g.term.hi} ${g.meaning.en} ${g.meaning.hi}'.toLowerCase().contains(q))
            .toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: <Widget>[
            TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: bi(context, 'Search a word', 'शब्द खोजिए')),
            ),
            const SizedBox(height: 12),
            if (list.isEmpty) Text(bi(context, 'No word matches.', 'कोई शब्द नहीं मिला।'), style: TextStyle(color: p.muted)),
            for (final g in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(g.term.of(context), style: _h(p, 16)),
                      const SizedBox(height: 4),
                      Text(g.meaning.of(context), style: TextStyle(fontSize: 14.5, height: 1.45, color: p.text)),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

/// The history of the universe squeezed into one calendar year.
class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  static const double _age = 13.8e9;

  /// The day and time on the cosmic calendar for [years] after the Big Bang.
  static String stamp(BuildContext context, double years) {
    final seconds = years / _age * 365 * 86400;
    final date = DateTime.utc(2001, 1, 1).add(Duration(seconds: seconds.round()));
    final loc = MaterialLocalizations.of(context);
    final day = loc.formatShortMonthDay(date);
    if (years > _age - 1e6) {
      return '$day, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
    }
    return day;
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(bi(context, 'Timeline of the universe', 'ब्रह्मांड की timeline'), style: const TextStyle(fontWeight: FontWeight.w700))),
      body: _LearnLoader(builder: (context, data) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: <Widget>[
            Text(
                bi(context, 'If the 13.8 billion years since the Big Bang were one year, the Big Bang is on 1 January at midnight and today is the last second of 31 December.',
                    'अगर Big Bang से अब तक के 13.8 अरब साल एक साल होते, तो Big Bang 1 जनवरी की आधी रात को है और आज 31 दिसंबर का आख़िरी सेकंड।'),
                style: TextStyle(fontSize: 15, height: 1.45, color: p.muted)),
            const SizedBox(height: 14),
            for (final e in data.timeline)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SurfaceCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 92,
                        child: Text(stamp(context, e.when), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: p.accentText)),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(e.title.of(context), style: _h(p, 16)),
                            const SizedBox(height: 4),
                            Text(e.text.of(context), style: TextStyle(fontSize: 14, height: 1.45, color: p.text)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(bi(context, 'What comes next', 'आगे क्या होगा'), style: _h(p, 20)),
            const SizedBox(height: 10),
            for (final e in data.future)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(e.title.of(context), style: _h(p, 16)),
                      const SizedBox(height: 4),
                      Text(e.text.of(context), style: TextStyle(fontSize: 14, height: 1.45, color: p.text)),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

/// Sizes from a proton to the observable universe, on a ten-times scale.
class ScaleScreen extends StatelessWidget {
  const ScaleScreen({super.key});

  static String size(BuildContext context, double m) {
    String n(double v) => v >= 100 ? v.round().toString() : v.toStringAsFixed(v >= 10 ? 1 : 2);
    if (m < 1e-6) {
      return '10^${(math.log(m) / math.ln10).round()} m';
    }
    if (m < 1e-3) {
      return '${n(m * 1e6)} µm';
    }
    if (m < 1) {
      return '${n(m * 1e3)} mm';
    }
    if (m < 1e3) {
      return '${n(m)} m';
    }
    const ly = 9.4607e15;
    if (m < 1e13) {
      return '${n(m / 1e3)} km';
    }
    if (m < ly * 1e3) {
      return bi(context, '${n(m / ly)} light-years', '${n(m / ly)} प्रकाश-वर्ष');
    }
    if (m < ly * 1e6) {
      return bi(context, '${n(m / ly / 1e3)} thousand light-years', '${n(m / ly / 1e3)} हज़ार प्रकाश-वर्ष');
    }
    if (m < ly * 1e9) {
      return bi(context, '${n(m / ly / 1e6)} million light-years', '${n(m / ly / 1e6)} मिलियन प्रकाश-वर्ष');
    }
    return bi(context, '${n(m / ly / 1e9)} billion light-years', '${n(m / ly / 1e9)} अरब प्रकाश-वर्ष');
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(bi(context, 'Scale of the universe', 'ब्रह्मांड का पैमाना'), style: const TextStyle(fontWeight: FontWeight.w700))),
      body: _LearnLoader(builder: (context, data) {
        final items = List<ScaleItem>.of(data.scale)..sort((a, b) => a.metres.compareTo(b.metres));
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }
        final lo = math.log(items.first.metres) / math.ln10, hi = math.log(items.last.metres) / math.ln10;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: <Widget>[
            Text(bi(context, 'Each step down the list is many times bigger. The bar shows the size on a scale where every mark is ten times the one before.', 'सूची में हर अगला कदम कई गुना बड़ा है। Bar उस पैमाने पर आकार दिखाता है जहाँ हर निशान पिछले से दस गुना है।'),
                style: TextStyle(fontSize: 15, height: 1.45, color: p.muted)),
            const SizedBox(height: 14),
            for (final it in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(child: Text(it.name.of(context), style: _h(p, 16))),
                        Text(size(context, it.metres), style: TextStyle(fontWeight: FontWeight.w700, color: p.accentText)),
                      ]),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(value: hi == lo ? 1 : ((math.log(it.metres) / math.ln10) - lo) / (hi - lo), minHeight: 6),
                      ),
                      const SizedBox(height: 8),
                      Text(it.text.of(context), style: TextStyle(fontSize: 14, height: 1.45, color: p.text)),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
