import 'dart:async';

import 'package:flutter/material.dart';

import '../core/quiz.dart';
import '../data/planets.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/fact_card.dart';

/// Ten questions built from the planet and moon data, in three levels, plus
/// the shared Daily 5 challenge and live leaderboard.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuizLevel _level = QuizLevel.medium;
  List<QuizQuestion>? _questions;
  int _index = 0;
  int _score = 0;
  Planet? _picked;
  bool _finished = false;
  bool _newBest = false;

  // Daily 5 & Leaderboard state
  bool _isDaily = false;
  int _dailyStartMs = 0;
  int _dailyElapsedSec = 0;
  int _dailyPoints = 0;
  Timer? _dailyTimer;
  bool _boardTabAll = false;
  bool _loadingBoard = true;
  Map<String, dynamic>? _boardData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshBoard();
    });
  }

  @override
  void dispose() {
    _dailyTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshBoard() async {
    if (!mounted) {
      return;
    }
    setState(() => _loadingBoard = true);
    final data = await AppScope.read(context).account.dailyBoard();
    if (!mounted) {
      return;
    }
    setState(() {
      _boardData = data;
      _loadingBoard = false;
    });
  }

  void _start(QuizLevel level) {
    _dailyTimer?.cancel();
    setState(() {
      _isDaily = false;
      _level = level;
      _questions = buildQuiz(level: level);
      _index = 0;
      _score = 0;
      _picked = null;
      _finished = false;
      _newBest = false;
    });
  }

  Future<void> _startDaily() async {
    final dayUtc = DateTime.now().toUtc().toIso8601String().substring(0, 10);
    final acct = AppScope.read(context).account;
    var elapsedMs = 0;
    if (acct.loggedIn) {
      final started = await acct.dailyStart();
      if (!mounted) {
        return;
      }
      if (started != null && started['done'] == true) {
        await _refreshBoard();
        return;
      }
      if (started != null && started['elapsedMs'] is int) {
        elapsedMs = started['elapsedMs'] as int;
      }
    }
    _dailyTimer?.cancel();
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _isDaily = true;
      _questions = buildDailyFive(dayUtc);
      _index = 0;
      _score = 0;
      _picked = null;
      _finished = false;
      _newBest = false;
      _dailyStartMs = nowMs - elapsedMs;
      _dailyElapsedSec = elapsedMs ~/ 1000;
      _dailyPoints = 0;
    });
    _dailyTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _finished) {
        return;
      }
      setState(() {
        _dailyElapsedSec =
            (DateTime.now().millisecondsSinceEpoch - _dailyStartMs) ~/ 1000;
      });
    });
  }

  void _pick(Planet planet) {
    if (_picked != null) {
      return;
    }
    final question = _questions![_index];
    setState(() {
      _picked = planet;
      if (planet.id == question.answer.id) {
        _score++;
      }
    });
  }

  Future<void> _next() async {
    final questions = _questions!;
    if (_index + 1 < questions.length) {
      setState(() {
        _index++;
        _picked = null;
      });
      return;
    }
    _dailyTimer?.cancel();
    if (_isDaily) {
      final elapsedMs =
          (DateTime.now().millisecondsSinceEpoch - _dailyStartMs).clamp(3000, 1800000);
      var pts = dailyFivePoints(_score, elapsedMs);
      final acct = AppScope.read(context).account;
      if (acct.loggedIn) {
        final sub = await acct.dailySubmit(_score);
        if (sub != null && sub['points'] is int) {
          pts = sub['points'] as int;
        }
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _dailyPoints = pts;
        _finished = true;
      });
      unawaited(_refreshBoard());
      return;
    }
    final best =
        await AppScope.read(context).recordQuizScore(_level.name, _score);
    if (!mounted) {
      return;
    }
    setState(() {
      _finished = true;
      _newBest = best;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = _questions;
    if (questions == null) {
      return _intro(context);
    }
    if (_finished) {
      return _result(context, questions.length);
    }
    return _question(context, questions);
  }

  Widget _intro(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final state = AppScope.of(context);
    final settings = state.settings;
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: <Widget>[
        Text(l.quizTitle,
            style: TextStyle(
                fontFamily: headingFont,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: p.text)),
        const SizedBox(height: 16),
        _DailyFiveCard(
          isHi: isHi,
          loggedIn: state.account.loggedIn,
          username: state.account.username,
          loading: _loadingBoard,
          boardData: _boardData,
          boardTabAll: _boardTabAll,
          onToggleTab: (all) => setState(() => _boardTabAll = all),
          onPlayDaily: _startDaily,
          onRefresh: _refreshBoard,
        ),
        const SizedBox(height: 20),
        Text(l.quizChoose,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: p.muted)),
        const SizedBox(height: 8),
        for (final level in QuizLevel.values) ...<Widget>[
          _LevelCard(
            level: level,
            best: settings.bestFor(level.name),
            onTap: () => _start(level),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 10),
        FactCard.daily(DateTime.now()),
      ],
    );
  }

  Widget _question(BuildContext context, List<QuizQuestion> questions) {
    final l = context.l10n;
    final p = Palette.of(context);
    final question = questions[_index];
    final picked = _picked;
    final last = _index + 1 == questions.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(l.quizProgress(_index + 1, questions.length),
                style: TextStyle(fontSize: 13, color: p.muted)),
            if (_isDaily)
              Text(
                '⏱ $_dailyElapsedSec s',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: p.accentText),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: (_index + (picked != null ? 1 : 0)) / questions.length,
            minHeight: 6,
            color: p.accent,
            backgroundColor: p.surface,
          ),
        ),
        const SizedBox(height: 24),
        Text(quizQuestionText(l, question.kind),
            style: TextStyle(
                fontFamily: headingFont,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: p.text,
                height: 1.3)),
        const SizedBox(height: 20),
        for (final option in question.options) ...<Widget>[
          _OptionButton(
            planet: option,
            label: planetName(l, option),
            state: picked == null
                ? _OptionState.open
                : option.id == question.answer.id
                    ? _OptionState.right
                    : option.id == picked.id
                        ? _OptionState.wrong
                        : _OptionState.idle,
            onTap: () => _pick(option),
          ),
          const SizedBox(height: 10),
        ],
        if (picked != null) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            picked.id == question.answer.id
                ? l.quizCorrect
                : l.quizWrong(planetName(l, question.answer)),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: picked.id == question.answer.id ? p.good : p.bad,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            onPressed: _next,
            child: Text(last ? l.quizSeeResult : l.quizNext),
          ),
        ],
      ],
    );
  }

  Widget _result(BuildContext context, int total) {
    final l = context.l10n;
    final p = Palette.of(context);
    final best = AppScope.of(context).settings.bestFor(_level.name);
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: <Widget>[
        Text(l.quizTitle,
            style: TextStyle(
                fontFamily: headingFont,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: p.text)),
        const SizedBox(height: 8),
        Text(_isDaily ? 'Daily 5' : quizLevelName(l, _level),
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: p.muted)),
        const SizedBox(height: 40),
        Text(
          '$_score / $total',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: headingFont,
              fontSize: 56,
              fontWeight: FontWeight.w700,
              color: p.accentText),
        ),
        const SizedBox(height: 8),
        Text(l.quizScore(_score, total),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: p.text)),
        const SizedBox(height: 8),
        if (_isDaily)
          Text(
            isHi
                ? '$_dailyPoints अंक · $_dailyElapsedSec सेकंड'
                : '$_dailyPoints points · $_dailyElapsedSec s',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: p.good),
          )
        else
          Text(_newBest ? l.quizNewBest : l.quizBest(best),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: _newBest ? p.good : p.muted)),
        const SizedBox(height: 32),
        if (!_isDaily) ...<Widget>[
          FilledButton(
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            onPressed: () => _start(_level),
            child: Text(l.quizAgain),
          ),
          const SizedBox(height: 10),
        ],
        OutlinedButton(
          style:
              OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          onPressed: () => setState(() {
            _questions = null;
            _isDaily = false;
          }),
          child: Text(l.quizChoose),
        ),
      ],
    );
  }
}

class _DailyFiveCard extends StatelessWidget {
  const _DailyFiveCard({
    required this.isHi,
    required this.loggedIn,
    required this.username,
    required this.loading,
    required this.boardData,
    required this.boardTabAll,
    required this.onToggleTab,
    required this.onPlayDaily,
    required this.onRefresh,
  });

  final bool isHi;
  final bool loggedIn;
  final String username;
  final bool loading;
  final Map<String, dynamic>? boardData;
  final bool boardTabAll;
  final ValueChanged<bool> onToggleTab;
  final VoidCallback onPlayDaily;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final meToday = boardData?['me_today'] as Map<String, dynamic>?;
    final playersToday = boardData?['players_today'] is int
        ? boardData!['players_today'] as int
        : 0;
    final listRaw =
        boardData?[boardTabAll ? 'all' : 'today'] as List<Object?>? ??
            const <Object?>[];

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.emoji_events_outlined, color: p.accentText, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Daily 5 · Leaderboard',
                  style: TextStyle(
                    fontFamily: headingFont,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: p.text,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, size: 20, color: p.muted),
                tooltip: isHi ? 'ताज़ा करें' : 'Refresh',
                onPressed: onRefresh,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isHi
                ? 'हर दिन सबके लिए वही 5 सवाल (UTC)। सही जवाब और तेज़ी से आपका स्कोर और रैंक बनती है।'
                : 'The same 5 questions for everybody every day (UTC). Right answers and speed make your score.',
            style: TextStyle(fontSize: 13, color: p.muted, height: 1.35),
          ),
          const SizedBox(height: 12),
          if (meToday != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: p.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isHi
                    ? 'आज का नतीजा: ${meToday['points']} अंक · रैंक #${meToday['rank']} / $playersToday'
                    : 'Today\'s result: ${meToday['points']} pts · Rank #${meToday['rank']} of $playersToday',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: p.accentText,
                ),
              ),
            )
          else
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
              ),
              onPressed: onPlayDaily,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                isHi ? 'आज के 5 खेलिए' : 'Play today\'s 5',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          if (!loggedIn) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              isHi
                  ? 'लीडरबोर्ड में अपना नाम जोड़ने के लिए You टैब में लॉग इन करें।'
                  : 'Log in on the You tab to save your score on the leaderboard.',
              style: TextStyle(fontSize: 12, color: p.muted),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              ChoiceChip(
                label: Text(isHi ? 'आज' : 'Today'),
                selected: !boardTabAll,
                onSelected: (_) => onToggleTab(false),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: Text(isHi ? 'कुल (All time)' : 'All time'),
                selected: boardTabAll,
                onSelected: (_) => onToggleTab(true),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (loading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: p.accent,
                  ),
                ),
              ),
            )
          else if (listRaw.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                isHi
                    ? 'आज अभी कोई नहीं खेला — सबसे पहले आप खेलिए!'
                    : 'Nobody on the board yet today. Be the first!',
                style: TextStyle(fontSize: 13, color: p.muted),
              ),
            )
          else
            for (var i = 0; i < listRaw.length && i < 10; i++)
              _BoardRow(
                rank: i + 1,
                entry: listRaw[i] as Map<String, dynamic>,
                isMe: username.isNotEmpty &&
                    (listRaw[i] as Map<String, dynamic>)['u'] == username,
                isAllTime: boardTabAll,
                isHi: isHi,
              ),
        ],
      ),
    );
  }
}

class _BoardRow extends StatelessWidget {
  const _BoardRow({
    required this.rank,
    required this.entry,
    required this.isMe,
    required this.isAllTime,
    required this.isHi,
  });

  final int rank;
  final Map<String, dynamic> entry;
  final bool isMe;
  final bool isAllTime;
  final bool isHi;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final name = '${entry['u'] ?? ''}';
    final pts = entry['p'] ?? 0;
    final sub = isAllTime
        ? (isHi ? '${entry['d'] ?? 1} दिन' : '${entry['d'] ?? 1}d')
        : '${entry['c'] ?? 0}/5';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 28,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: rank <= 3 ? p.accentText : p.muted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              isMe ? '$name (${isHi ? 'आप' : 'You'})' : name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isMe ? FontWeight.w700 : FontWeight.w500,
                color: isMe ? p.accentText : p.text,
              ),
            ),
          ),
          Text(
            '$sub · $pts pts',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: p.muted,
            ),
          ),
        ],
      ),
    );
  }
}

enum _OptionState { open, idle, right, wrong }

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.planet,
    required this.label,
    required this.state,
    required this.onTap,
  });

  final Planet planet;
  final String label;
  final _OptionState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final light = Theme.of(context).brightness == Brightness.light;
    var border = light ? p.border : Colors.transparent;
    IconData? icon;
    Color iconColor = p.text;
    switch (state) {
      case _OptionState.right:
        border = p.good;
        icon = Icons.check_circle;
        iconColor = p.good;
      case _OptionState.wrong:
        border = p.bad;
        icon = Icons.cancel;
        iconColor = p.bad;
      case _OptionState.open:
      case _OptionState.idle:
        break;
    }
    return Opacity(
      opacity: state == _OptionState.idle ? 0.6 : 1,
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: state == _OptionState.open ? onTap : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: <Widget>[
                  PlanetBall(planet: planet, size: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(label,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: p.text)),
                  ),
                  if (icon != null) Icon(icon, color: iconColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One of the three level buttons on the quiz start page.
class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.best,
    required this.onTap,
  });

  final QuizLevel level;
  final int best;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final icon = switch (level) {
      QuizLevel.easy => Icons.looks_one_outlined,
      QuizLevel.medium => Icons.looks_two_outlined,
      QuizLevel.hard => Icons.looks_3_outlined,
    };
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: SurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            Icon(icon, color: p.accentText, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(quizLevelName(l, level),
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: p.text)),
                  const SizedBox(height: 2),
                  Text(quizLevelHint(l, level),
                      style: TextStyle(fontSize: 13, color: p.muted)),
                  if (best > 0)
                    Text(l.quizBest(best),
                        style: TextStyle(fontSize: 12, color: p.muted)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: p.muted),
          ],
        ),
      ),
    );
  }
}
