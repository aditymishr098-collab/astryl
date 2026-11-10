import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../core/badges.dart';
import '../core/daily.dart';
import '../core/format.dart';
import '../core/quiz.dart';
import '../data/planets.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/fact_card.dart';
import '../widgets/share_card.dart';

/// Ten questions built from the planet and moon data, in three levels, plus
/// the shared Daily 5 challenge, 60-second Blitz Survival mode, lifelines,
/// scientific explanations, streak counter, and achievements.
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

  // Lifelines, visual clues, and answer history
  bool _used5050 = false;
  bool _usedHint = false;
  final GlobalKey _resultKey = GlobalKey();
  bool _sharingResult = false;

  /// Shares the result as a picture with the Astryl footer; falls back to the
  /// text score card when the picture cannot be made or shared.
  Future<void> _shareResult(BuildContext context, int total, bool isHi) async {
    final palette = Palette.of(context);
    final bridge = AppScope.read(context).bridge;
    setState(() => _sharingResult = true);
    var shared = false;
    try {
      final boundary = _resultKey.currentContext?.findRenderObject();
      if (boundary is RenderRepaintBoundary) {
        final bytes = await renderShareCard(boundary, palette);
        final dir = await bridge.sharedDir();
        if (dir.isNotEmpty) {
          final file = File('$dir${Platform.pathSeparator}Astryl-quiz.png');
          await file.writeAsBytes(bytes, flush: true);
          final text = _isDaily
              ? (isHi
                  ? 'मैंने आज Astryl के Daily 5 में $_dailyPoints अंक लिए! https://astryl.space/quiz/'
                  : 'I scored $_dailyPoints points on today\'s Astryl Daily 5! https://astryl.space/quiz/')
              : 'Astryl Space Quiz https://astryl.space/quiz/';
          shared = await bridge.shareImage(file.path, text);
        }
      }
    } on Exception {
      shared = false;
    }
    if (!mounted) {
      return;
    }
    setState(() => _sharingResult = false);
    if (!shared && context.mounted) {
      await _copyShareCard(context, total, isHi);
    }
  }

  Set<String> _hiddenOptionIds = <String>{};
  bool _showHintBanner = false;
  List<bool> _history = <bool>[];

  // 60s Blitz Survival mode
  bool _isBlitz = false;
  int _blitzLives = 3;
  int _blitzCombo = 0;
  int _blitzMaxCombo = 0;
  int _blitzSecondsLeft = 60;
  int _blitzPoints = 0;
  Timer? _blitzTimer;

  // Daily 5 & Leaderboard state
  bool _isDaily = false;
  int _dailyStartMs = 0;
  int _dailyElapsedSec = 0;
  int _dailyPoints = 0;
  List<String> _dailyPicks = <String>[];
  List<QuizQuestion>? _dailyServerQuestions;
  Timer? _dailyTimer;
  /// 0 = today, 1 = this week, 2 = all time.
  int _boardTab = 0;
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
    _blitzTimer?.cancel();
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

  Future<void> _toggleQuizBell(BuildContext context, bool isHi) async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    if (state.quizAlert) {
      await state.setQuizAlert(false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            isHi ? '🔕 डेली क्विज़ रिमाइंडर बंद कर दिया गया।' : '🔕 Daily quiz reminder turned off.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (!await state.bridge.requestNotifications()) {
      messenger.showSnackBar(SnackBar(content: Text(l.notificationsOff)));
      return;
    }
    if (!context.mounted) {
      return;
    }
    final minutes = state.quizMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    );
    if (picked != null) {
      await state.setQuizMinutes(picked.hour * 60 + picked.minute);
    }
    await state.setQuizAlert(true);
    if (!context.mounted) {
      return;
    }
    final timeStr = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: state.quizMinutes ~/ 60, minute: state.quizMinutes % 60),
    );
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          isHi
              ? '🔔 हर दिन $timeStr बजे Daily 5 क्विज़ का रिमाइंडर आएगा!'
              : '🔔 Daily 5 quiz reminder set for $timeStr every day!',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _start(QuizLevel level) {
    _dailyTimer?.cancel();
    _blitzTimer?.cancel();
    setState(() {
      _isDaily = false;
      _isBlitz = false;
      _level = level;
      _questions = buildQuiz(level: level);
      _index = 0;
      _score = 0;
      _picked = null;
      _finished = false;
      _newBest = false;
      _used5050 = false;
      _usedHint = false;
      _hiddenOptionIds = <String>{};
      _showHintBanner = false;
      _history = <bool>[];
    });
  }

  void _startBlitz() {
    _dailyTimer?.cancel();
    _blitzTimer?.cancel();
    final rng = Random();
    final allKinds = List<QuizKind>.of(QuizKind.values)..shuffle(rng);
    final blitzQs = <QuizQuestion>[];
    for (final k in allKinds) {
      final ans = answerFor(k);
      final others = distractorsFor(k).where((p) => p.id != ans.id).toList()
        ..shuffle(rng);
      final opts = <Planet>[ans, ...others.take(3)]..shuffle(rng);
      blitzQs.add(QuizQuestion(k, opts, ans));
    }
    setState(() {
      _isDaily = false;
      _isBlitz = true;
      _questions = blitzQs;
      _index = 0;
      _score = 0;
      _picked = null;
      _finished = false;
      _newBest = false;
      _blitzLives = 3;
      _blitzCombo = 0;
      _blitzMaxCombo = 0;
      _blitzSecondsLeft = 60;
      _blitzPoints = 0;
      _used5050 = false;
      _usedHint = false;
      _hiddenOptionIds = <String>{};
      _showHintBanner = false;
      _history = <bool>[];
    });
    _blitzTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _finished) {
        return;
      }
      if (_blitzSecondsLeft <= 1) {
        _blitzTimer?.cancel();
        _finishBlitz();
      } else {
        setState(() {
          _blitzSecondsLeft--;
        });
      }
    });
  }

  Future<void> _finishBlitz() async {
    _blitzTimer?.cancel();
    final best = await AppScope.read(context).recordQuizScore('blitz', _blitzPoints);
    if (!mounted) {
      return;
    }
    setState(() {
      _blitzSecondsLeft = 0;
      _finished = true;
      _newBest = best;
    });
  }

  Future<void> _startDaily() async {
    final dayUtc = DateTime.now().toUtc().toIso8601String().substring(0, 10);
    final acct = AppScope.read(context).account;
    var elapsedMs = 0;
    List<QuizQuestion>? serverQuestions;
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
      // The server picks today's questions and checks the answers later.
      if (started != null && started['questions'] != null) {
        serverQuestions = parseDaily(started['questions']);
        if (serverQuestions == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(context.l10n.dailyUpdate),
            behavior: SnackBarBehavior.floating,
          ));
          return;
        }
      }
    }
    _dailyTimer?.cancel();
    _blitzTimer?.cancel();
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _isDaily = true;
      _isBlitz = false;
      _questions = serverQuestions ?? buildDailyFive(dayUtc);
      _dailyServerQuestions = serverQuestions;
      _dailyPicks = <String>[];
      _index = 0;
      _score = 0;
      _picked = null;
      _finished = false;
      _newBest = false;
      _dailyStartMs = nowMs - elapsedMs;
      _dailyElapsedSec = elapsedMs ~/ 1000;
      _dailyPoints = 0;
      _used5050 = false;
      _usedHint = false;
      _hiddenOptionIds = <String>{};
      _showHintBanner = false;
      _history = <bool>[];
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

  void _useFiftyFifty(QuizQuestion q) {
    if (_used5050 || _picked != null) {
      return;
    }
    final wrong = q.options
        .where((o) => o.id != q.answer.id)
        .map((o) => o.id)
        .toList()
      ..shuffle();
    setState(() {
      _used5050 = true;
      _hiddenOptionIds = wrong.take(2).toSet();
    });
  }

  void _useHint() {
    if (_usedHint || _picked != null) {
      return;
    }
    setState(() {
      _usedHint = true;
      _showHintBanner = true;
    });
  }

  void _pick(Planet planet) {
    if (_picked != null) {
      return;
    }
    final question = _questions![_index];
    final right = planet.id == question.answer.id;
    setState(() {
      _picked = planet;
      _history.add(right);
      if (_isDaily) {
        _dailyPicks.add(planet.id);
      }
      if (right) {
        _score++;
        if (_isBlitz) {
          _blitzCombo++;
          if (_blitzCombo > _blitzMaxCombo) {
            _blitzMaxCombo = _blitzCombo;
          }
          final mult = _blitzCombo >= 5 ? 3 : (_blitzCombo >= 3 ? 2 : 1);
          _blitzPoints += 100 * mult;
        }
      } else if (_isBlitz) {
        _blitzCombo = 0;
        _blitzLives--;
      }
    });
    if (_isBlitz && _blitzLives <= 0) {
      _blitzTimer?.cancel();
    }
  }

  Future<void> _next() async {
    final questions = _questions!;
    if (_isBlitz && _blitzLives <= 0) {
      await _finishBlitz();
      return;
    }
    if (_index + 1 < questions.length) {
      setState(() {
        _index++;
        _picked = null;
        _hiddenOptionIds = <String>{};
        _showHintBanner = false;
      });
      return;
    }
    _dailyTimer?.cancel();
    _blitzTimer?.cancel();
    if (_isBlitz) {
      await _finishBlitz();
      return;
    }
    if (_isDaily) {
      final elapsedMs =
          (DateTime.now().millisecondsSinceEpoch - _dailyStartMs)
              .clamp(3000, 1800000);
      var pts = dailyFivePoints(_score, elapsedMs);
      final state = AppScope.read(context);
      await state.recordDailyStreak();
      final acct = state.account;
      if (acct.loggedIn && _dailyServerQuestions != null) {
        final sub = await acct.dailySubmit(_dailyPicks);
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

  String _hintFor(BuildContext context, Planet body, bool isHi) {
    final kindStr = body.isStar
        ? (isHi ? 'यह सौर मंडल का तारा है' : 'It is the star at the center of our solar system')
        : body.isMoon
            ? (isHi ? 'यह एक प्राकृतिक उपग्रह (चंद्रमा) है' : 'It is a natural moon orbiting a planet')
            : body.kind == BodyKind.dwarf
                ? (isHi ? 'यह एक बौना ग्रह (Dwarf Planet) है' : 'It is a dwarf planet in the Kuiper Belt')
                : body.order <= 4
                    ? (isHi ? 'यह एक चट्टानी भीतरी ग्रह (Rocky Planet) है' : 'It is an inner rocky planet')
                    : (isHi ? 'यह एक विशाल बाहरी ग्रह (Giant Planet) है' : 'It is an outer giant planet');
    final d = formatNumber(context, body.diameterKm);
    return isHi
        ? '💡 संकेत: $kindStr · व्यास $d km · औसत तापमान ${body.meanTempC}°C'
        : '💡 Clue: $kindStr · Diameter $d km · Mean temp ${body.meanTempC}°C';
  }

  String _explanationFor(BuildContext context, QuizQuestion q, bool isHi) {
    final l = context.l10n;
    final b = q.answer;
    final name = planetName(l, b);
    final facts = bodyFacts(l, b.id);
    final fact = facts.isNotEmpty ? facts.first : '';
    final d = formatNumber(context, b.diameterKm);
    final statLine = isHi
        ? '$name — व्यास: $d km · गुरुत्वाकर्षण: ${b.gravity} m/s² · तापमान: ${b.meanTempC}°C · चंद्रमा: ${b.moons}'
        : '$name — Diameter: $d km · Gravity: ${b.gravity} m/s² · Temp: ${b.meanTempC}°C · Moons: ${b.moons}';
    return fact.isEmpty ? statLine : '$statLine\n$fact';
  }

  Future<void> _copyShareCard(BuildContext context, int total, bool isHi) async {
    final l = context.l10n;
    final grid = _history.map((ok) => ok ? '🟩' : '🟥').join();
    final modeTitle = _isDaily
        ? 'Daily 5'
        : _isBlitz
            ? '60s Blitz ($_blitzPoints pts)'
            : quizLevelName(l, _level);
    final text = '🪐 Astryl Space Quiz · $modeTitle\n'
        'Score: $_score / ${_history.isEmpty ? total : _history.length} '
        '${_isDaily ? "($_dailyPoints pts)" : ""}\n'
        '$grid\n'
        'Play at https://astryl.space/quiz/';
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHi
              ? '📋 स्कोर कार्ड कॉपी हो गया! अब दोस्तों को भेजें।'
              : '📋 Score card copied! Paste to challenge your friends.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
    final streak = settings.quizBests['streak'] ?? 0;
    final blitzBest = settings.quizBests['blitz'] ?? 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(l.quizTitle,
                  style: TextStyle(
                      fontFamily: headingFont,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: p.text)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: streak > 0
                    ? const Color(0xFFFF8A47).withValues(alpha: 0.16)
                    : p.surfaceHigh,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: streak > 0
                      ? const Color(0xFFFF8A47).withValues(alpha: 0.5)
                      : p.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('🔥', style: TextStyle(fontSize: 15)),
                  const SizedBox(width: 6),
                  Text(
                    isHi ? '$streak दिन स्ट्रीक' : '$streak day streak',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: streak > 0 ? const Color(0xFFFF8A47) : p.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _DailyFiveCard(
          isHi: isHi,
          loggedIn: state.account.loggedIn,
          username: state.account.username,
          loading: _loadingBoard,
          boardData: _boardData,
          boardTab: _boardTab,
          quizAlertOn: state.quizAlert,
          quizAlertTime: MaterialLocalizations.of(context).formatTimeOfDay(
            TimeOfDay(
              hour: state.quizMinutes ~/ 60,
              minute: state.quizMinutes % 60,
            ),
          ),
          onToggleBell: () => _toggleQuizBell(context, isHi),
          onToggleTab: (tab) => setState(() => _boardTab = tab),
          onPlayDaily: _startDaily,
          onRefresh: _refreshBoard,
        ),
        const SizedBox(height: 14),
        _BlitzModeCard(
          isHi: isHi,
          bestPoints: blitzBest,
          onStart: _startBlitz,
        ),
        const SizedBox(height: 16),
        _AchievementsCard(
          isHi: isHi,
          bests: settings.quizBests,
          easyBest: settings.bestFor('easy'),
          medBest: settings.bestFor('medium'),
          hardBest: settings.bestFor('hard'),
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
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    final question = questions[_index];
    final picked = _picked;
    final last = (_index + 1 == questions.length) ||
        (_isBlitz && _blitzLives <= 0);
    final mult = _blitzCombo >= 5 ? 3 : (_blitzCombo >= 3 ? 2 : 1);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _isBlitz
                  ? (isHi ? '⚡ सवाल #${_index + 1}' : '⚡ Question #${_index + 1}')
                  : l.quizProgress(_index + 1, questions.length),
              style: TextStyle(fontSize: 13, color: p.muted),
            ),
            if (_isDaily)
              Text(
                '⏱ $_dailyElapsedSec s',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: p.accentText),
              )
            else if (_isBlitz)
              Row(
                children: <Widget>[
                  Text(
                    '❤️' * _blitzLives.clamp(0, 3) +
                        '🖤' * (3 - _blitzLives.clamp(0, 3)),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(width: 8),
                  if (mult > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8A47).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '🔥 ${mult}x',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF8A47),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    '⏱ ${_blitzSecondsLeft}s · $_blitzPoints pts',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _blitzSecondsLeft <= 10 ? p.bad : p.accentText),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: _isBlitz
                ? (_blitzSecondsLeft / 60.0).clamp(0.0, 1.0)
                : (_index + (picked != null ? 1 : 0)) / questions.length,
            minHeight: 6,
            color: _isBlitz && _blitzSecondsLeft <= 10 ? p.bad : p.accent,
            backgroundColor: p.surface,
          ),
        ),
        const SizedBox(height: 16),
        // Visual Mystery World Header + Lifelines bar
        SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: <Widget>[
              if (picked != null)
                PlanetBall(planet: question.answer, size: 42)
              else
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        p.accent.withValues(alpha: 0.35),
                        p.surfaceHigh,
                      ],
                    ),
                    border: Border.all(color: p.accent.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontFamily: headingFont,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: p.accentText,
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  picked != null
                      ? planetName(l, question.answer)
                      : (isHi ? 'रहस्यमय लोक पहचाने' : 'Identify the Cosmic World'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: p.text,
                  ),
                ),
              ),
              if (!_isDaily) ...<Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onPressed: (_used5050 || picked != null)
                      ? null
                      : () => _useFiftyFifty(question),
                  child: const Text('50:50',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 6),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onPressed: (_usedHint || picked != null) ? null : _useHint,
                  child: Text(isHi ? '💡 संकेत' : '💡 Hint',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
        ),
        if (_showHintBanner) ...<Widget>[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: p.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: p.accent.withValues(alpha: 0.35)),
            ),
            child: Text(
              _hintFor(context, question.answer, isHi),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: p.accentText,
                height: 1.35,
              ),
            ),
          ),
        ],
        const SizedBox(height: 18),
        Text(quizQuestionText(l, question.kind),
            style: TextStyle(
                fontFamily: headingFont,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: p.text,
                height: 1.3)),
        const SizedBox(height: 20),
        for (final option in question.options)
          if (!_hiddenOptionIds.contains(option.id)) ...<Widget>[
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
          const SizedBox(height: 6),
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
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: p.surfaceHigh,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: p.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isHi ? '🔬 वैज्ञानिक तथ्य (Why?)' : '🔬 Cosmic Insight (Why?)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: p.accentText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _explanationFor(context, question, isHi),
                  style: TextStyle(
                    fontSize: 13,
                    color: p.text,
                    height: 1.4,
                  ),
                ),
              ],
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
    final settings = AppScope.of(context).settings;
    final best = _isBlitz
        ? (settings.quizBests['blitz'] ?? 0)
        : settings.bestFor(_level.name);
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    final emojiGrid = _history.map((ok) => ok ? '🟩' : '🟥').join(' ');

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: <Widget>[
        RepaintBoundary(
          key: _resultKey,
          child: Container(
            color: p.background,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: <Widget>[
            Text(l.quizTitle,
                style: TextStyle(
                    fontFamily: headingFont,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: p.text)),
            const SizedBox(height: 8),
            Text(
                _isDaily
                    ? 'Daily 5'
                    : _isBlitz
                        ? (isHi ? '⚡ 60s ब्लिट्ज़ सर्वाइवल' : '⚡ 60s Blitz Survival')
                        : quizLevelName(l, _level),
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: p.muted)),
            const SizedBox(height: 32),
            Text(
              _isBlitz ? '$_blitzPoints pts' : '$_score / $total',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: headingFont,
                  fontSize: 52,
                  fontWeight: FontWeight.w700,
                  color: p.accentText),
            ),
            const SizedBox(height: 8),
            Text(
                _isBlitz
                    ? (isHi
                        ? '$_score सही जवाब · अधिकतम कॉम्बो ${_blitzMaxCombo}x'
                        : '$_score correct · Max combo ${_blitzMaxCombo}x')
                    : l.quizScore(_score, total),
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
            if (_history.isNotEmpty) ...<Widget>[
              const SizedBox(height: 18),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: p.surfaceHigh,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: p.border),
                  ),
                  child: Text(
                    emojiGrid,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, letterSpacing: 2),
                  ),
                ),
              ),
            ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          onPressed: _sharingResult
              ? null
              : () => _shareResult(context, total, isHi),
          icon: const Icon(Icons.share_outlined, size: 19),
          label: Text(
            isHi ? 'स्कोर कार्ड शेयर करें' : 'Share score card',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        TextButton(
          onPressed: () => _copyShareCard(context, total, isHi),
          child: Text(isHi ? 'सिर्फ़ text कॉपी करें' : 'Copy as text'),
        ),
        const SizedBox(height: 10),
        if (!_isDaily) ...<Widget>[
          FilledButton.tonal(
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            onPressed: () => _isBlitz ? _startBlitz() : _start(_level),
            child: Text(l.quizAgain),
          ),
          const SizedBox(height: 10),
        ],
        OutlinedButton(
          style:
              OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          onPressed: () => setState(() {
            _questions = null;
            _isDaily = false;
            _isBlitz = false;
          }),
          child: Text(l.quizChoose),
        ),
      ],
    );
  }
}

class _BlitzModeCard extends StatelessWidget {
  const _BlitzModeCard({
    required this.isHi,
    required this.bestPoints,
    required this.onStart,
  });

  final bool isHi;
  final int bestPoints;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A47).withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('⚡', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isHi ? '60s ब्लिट्ज़ सर्वाइवल (3 ❤️)' : '60s Blitz Survival (3 ❤️)',
                  style: TextStyle(
                    fontFamily: headingFont,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: p.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isHi
                      ? '60 सेकंड · 3 लाइफ · कॉम्बो बोनस (2x/3x)'
                      : '60 seconds · 3 lives · Combo multiplier (2x/3x)',
                  style: TextStyle(fontSize: 12.5, color: p.muted),
                ),
                if (bestPoints > 0) ...<Widget>[
                  const SizedBox(height: 3),
                  Text(
                    isHi ? 'सर्वश्रेष्ठ: $bestPoints pts' : 'Best: $bestPoints pts',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: p.accentText,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onStart,
            child: Text(isHi ? 'खेलें' : 'Play'),
          ),
        ],
      ),
    );
  }
}

class _AchievementsCard extends StatelessWidget {
  const _AchievementsCard({
    required this.isHi,
    required this.bests,
    required this.easyBest,
    required this.medBest,
    required this.hardBest,
  });

  final bool isHi;
  final Map<String, int> bests;
  final int easyBest;
  final int medBest;
  final int hardBest;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final games = bests['games'] ?? 0;
    final streak = bests['streak'] ?? 0;
    final blitz = bests['blitz'] ?? 0;
    final badges = <({String icon, String title, bool unlocked})>[
      (
        icon: '🚀',
        title: isHi ? 'प्रथम उड़ान' : 'First Launch',
        unlocked: games >= 1 || easyBest > 0 || medBest > 0 || hardBest > 0,
      ),
      (
        icon: '🔥',
        title: isHi ? '3-दिन स्ट्रीक' : '3-Day Streak',
        unlocked: streak >= 3,
      ),
      (
        icon: '🪐',
        title: isHi ? 'सौर मास्टर (10/10)' : 'Solar Master (10/10)',
        unlocked: easyBest >= 10 || medBest >= 10 || hardBest >= 10,
      ),
      (
        icon: '⚡',
        title: isHi ? 'ब्लिट्ज़ चैंपियन (500+)' : 'Blitz Ace (500+)',
        unlocked: blitz >= 500,
      ),
      (
        icon: '👑',
        title: isHi ? 'कठिन विजेता (8+/10)' : 'Hard Legend (8+/10)',
        unlocked: hardBest >= 8,
      ),
    ];

    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isHi ? '🏅 अंतरिक्ष पदक (Achievements)' : '🏅 Space Badges & Achievements',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: p.text,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final b in badges)
                Opacity(
                  opacity: b.unlocked ? 1.0 : 0.42,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: b.unlocked
                          ? p.accent.withValues(alpha: 0.14)
                          : p.surfaceHigh,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: b.unlocked
                            ? p.accent.withValues(alpha: 0.45)
                            : p.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(b.icon, style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 5),
                        Text(
                          b.title,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: b.unlocked ? p.accentText : p.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
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
    required this.boardTab,
    required this.quizAlertOn,
    required this.quizAlertTime,
    required this.onToggleBell,
    required this.onToggleTab,
    required this.onPlayDaily,
    required this.onRefresh,
  });

  final bool isHi;
  final bool loggedIn;
  final String username;
  final bool loading;
  final Map<String, dynamic>? boardData;
  final int boardTab;
  final bool quizAlertOn;
  final String quizAlertTime;
  final VoidCallback onToggleBell;
  final ValueChanged<int> onToggleTab;
  final VoidCallback onPlayDaily;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final meToday = boardData?['me_today'] as Map<String, dynamic>?;
    final playersToday = boardData?['players_today'] is int
        ? boardData!['players_today'] as int
        : 0;
    final listRaw = boardData?[const <String>['today', 'week', 'all'][boardTab]]
            as List<Object?>? ??
        const <Object?>[];
    final meWeek = boardData?['me_week'] as Map<String, dynamic>?;
    final meAll = boardData?['me_all'] as Map<String, dynamic>?;
    final stats = DailyStats.fromJson(boardData?['me_stats']);

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
              if (!kIsWeb)
                IconButton(
                  icon: Icon(
                    quizAlertOn
                        ? Icons.notifications_active
                        : Icons.notifications_none_outlined,
                    size: 20,
                    color: quizAlertOn ? p.accentText : p.muted,
                  ),
                  tooltip: quizAlertOn
                      ? (isHi
                          ? 'रोज़ाना अलर्ट चालू ($quizAlertTime)'
                          : 'Daily reminder on ($quizAlertTime)')
                      : (isHi ? 'रोज़ाना रिमाइंडर सेट करें' : 'Set daily quiz reminder'),
                  onPressed: onToggleBell,
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
          if (loggedIn && stats != null) ...<Widget>[
            const SizedBox(height: 12),
            _StreakPanel(stats: stats, isHi: isHi),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            children: <Widget>[
              ChoiceChip(
                label: Text(isHi ? 'आज' : 'Today'),
                selected: boardTab == 0,
                onSelected: (_) => onToggleTab(0),
              ),
              ChoiceChip(
                label: Text(isHi ? 'इस हफ़्ते' : 'This week'),
                selected: boardTab == 1,
                onSelected: (_) => onToggleTab(1),
              ),
              ChoiceChip(
                label: Text(isHi ? 'कुल (All time)' : 'All time'),
                selected: boardTab == 2,
                onSelected: (_) => onToggleTab(2),
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
                showDays: boardTab != 0,
                isHi: isHi,
              ),
          if (!loading && boardTab != 0 && (boardTab == 1 ? meWeek : meAll) != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                isHi
                    ? '${boardTab == 1 ? 'इस हफ़्ते' : 'कुल'} आपकी रैंक: #${(boardTab == 1 ? meWeek : meAll)!['rank']}'
                    : 'Your rank ${boardTab == 1 ? 'this week' : 'all time'}: #${(boardTab == 1 ? meWeek : meAll)!['rank']}',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: p.accentText),
              ),
            ),
        ],
      ),
    );
  }
}

/// The person's streak and badges (earned ones lit, the rest dimmed).
class _StreakPanel extends StatelessWidget {
  const _StreakPanel({required this.stats, required this.isHi});

  final DailyStats stats;
  final bool isHi;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final title = stats.streak > 0
        ? (isHi
            ? '🔥 ${stats.streak} दिन की streak'
            : '🔥 ${stats.streak}-day streak')
        : (isHi
            ? 'अभी कोई streak नहीं। आज खेलकर शुरू कीजिए।'
            : 'No streak yet. Play today to start one.');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.surfaceHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: p.text)),
          if (stats.best > 0)
            Text(
              isHi ? 'सबसे लंबी: ${stats.best}' : 'Best: ${stats.best}',
              style: TextStyle(fontSize: 12, color: p.muted),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              for (final b in badgesFor(stats))
                Opacity(
                  opacity: b.earned ? 1 : 0.35,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: b.earned ? p.accent : p.border),
                    ),
                    child: Text('${b.emoji} ${isHi ? b.hi : b.en}',
                        style: TextStyle(fontSize: 12, color: p.text)),
                  ),
                ),
            ],
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
    required this.showDays,
    required this.isHi,
  });

  final int rank;
  final Map<String, dynamic> entry;
  final bool isMe;
  final bool showDays;
  final bool isHi;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final name = '${entry['u'] ?? ''}';
    final pts = entry['p'] ?? 0;
    final sub = showDays
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
    var border = p.border;
    IconData? icon;
    Color iconColor = p.text;
    switch (state) {
      case _OptionState.right:
        border = p.good;
        icon = Icons.check_circle_rounded;
        iconColor = p.good;
      case _OptionState.wrong:
        border = p.bad;
        icon = Icons.cancel_rounded;
        iconColor = p.bad;
      case _OptionState.open:
      case _OptionState.idle:
        break;
    }
    return Opacity(
      opacity: state == _OptionState.idle ? 0.55 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: state == _OptionState.open ? onTap : null,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: border,
                width: state == _OptionState.right || state == _OptionState.wrong
                    ? 1.8
                    : 1.0,
              ),
            ),
            child: Row(
              children: <Widget>[
                PlanetBall(planet: planet, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontFamily: headingFont,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: p.text)),
                ),
                if (icon != null)
                  Icon(icon, color: iconColor)
                else
                  Icon(Icons.chevron_right_rounded,
                      size: 20, color: p.muted),
              ],
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
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: SurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: p.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: p.accentText, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(quizLevelName(l, level),
                      style: TextStyle(
                          fontFamily: headingFont,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: p.text)),
                  const SizedBox(height: 2),
                  Text(quizLevelHint(l, level),
                      style: TextStyle(fontSize: 13, color: p.muted)),
                  if (best > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(l.quizBest(best),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: p.accentText)),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: p.muted, size: 22),
          ],
        ),
      ),
    );
  }
}
