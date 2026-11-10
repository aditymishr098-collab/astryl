import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../core/format.dart';
import '../core/habitability.dart';
import '../core/orbits.dart';
import '../core/sky.dart';
import '../data/cities.dart';
import '../data/planets.dart';
import '../data/tonight_alerts.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/space_view.dart';
import 'compare_screen.dart';
import 'iss_screen.dart';
import 'planet_screen.dart';
import 'quiz_screen.dart';
import 'search_screen.dart';
import 'sky_screen.dart';
import 'spacecraft_screen.dart';
import 'star_map_screen.dart';
import 'you_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  String _alertKey = '';
  String _quizAlertKey = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppScope.read(context).account.onAppOpen();
    });
  }

  /// Prepares the next evenings' "tonight in the sky" notes. Done again when
  /// the switch, the time, the city or the language changes, and once a day.
  void _syncTonightAlerts(AppState state) {
    final settings = state.settings;
    if (kIsWeb || !settings.tonightAlert) {
      _alertKey = '';
      return;
    }
    final now = DateTime.now();
    final locale = Localizations.localeOf(context);
    final key = '${settings.tonightMinutes}-${settings.cityId}-'
        '${locale.languageCode}-${now.year}-${now.month}-${now.day}';
    if (key == _alertKey) {
      return;
    }
    _alertKey = key;
    final l = context.l10n;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      final alerts = buildTonightAlerts(
        l: l,
        locale: locale,
        city: cityById(settings.cityId),
        minutes: settings.tonightMinutes,
        now: now,
      );
      await scheduleTonightAlerts(state.bridge, alerts, channel: l.eventsTitle);
    });
  }

  /// Prepares the next 15 days' Daily 5 Quiz reminder notifications.
  /// Automatically skips today (`quiz:0`) if the user already played today.
  void _syncQuizAlerts(AppState state) {
    if (kIsWeb || !state.quizAlert) {
      _quizAlertKey = '';
      return;
    }
    final settings = state.settings;
    final now = DateTime.now();
    final nowUtc = now.toUtc();
    final todayUtcNum = nowUtc.year * 10000 + nowUtc.month * 100 + nowUtc.day;
    final lastDay = settings.quizBests['lastDay'] ?? 0;
    final streak = settings.quizBests['streak'] ?? 0;
    final playedToday = lastDay == todayUtcNum;
    final locale = Localizations.localeOf(context);
    final key = '${state.quizMinutes}-$streak-$playedToday-'
        '${locale.languageCode}-${now.year}-${now.month}-${now.day}';
    if (key == _quizAlertKey) {
      return;
    }
    _quizAlertKey = key;
    final l = context.l10n;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      final alerts = buildQuizAlerts(
        l: l,
        locale: locale,
        minutes: state.quizMinutes,
        now: now,
        streak: streak,
        playedToday: playedToday,
      );
      await scheduleQuizAlerts(state.bridge, alerts, channel: l.quizTitle);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = AppScope.of(context);
    _syncTonightAlerts(state);
    _syncQuizAlerts(state);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = Palette.of(context);
    return Scaffold(
      extendBody: false,
      body: Stack(
        children: <Widget>[
          if (isDark)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.7, -0.82),
                      radius: 1.45,
                      colors: <Color>[
                        p.accent.withValues(alpha: 0.14),
                        p.orbit.withValues(alpha: 0.11),
                        Colors.transparent,
                      ],
                      stops: const <double>[0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                _MissionControlHudBar(
                  onTapProfile: () => setState(() => _tab = 3),
                  onTapStreak: () => setState(() => _tab = 4),
                  onTapSearch: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const SearchScreen()),
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _tab,
                    children: <Widget>[
                      for (final (i, tab) in <Widget>[
                        ExploreTab(
                          active: _tab == 0,
                          onSelectTab: (t) => setState(() => _tab = t),
                        ),
                        const SkyScreen(),
                        const CompareScreen(),
                        const YouScreen(),
                        const QuizScreen(),
                      ].indexed)
                        TickerMode(
                          enabled: _tab == i,
                          child: AnimatedOpacity(
                            opacity: _tab == i ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.easeOutCubic,
                            child: AnimatedScale(
                              scale: _tab == i ? 1.0 : 0.985,
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOutCubic,
                              child: tab,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _NeonCapsuleBottomDock(
        selectedIndex: _tab,
        onSelect: (i) => setState(() => _tab = i),
        labels: <String>[
          l.navExplore,
          l.navSky,
          l.navCompare,
          l.navYou,
          l.navQuiz,
        ],
      ),
    );
  }
}

/// Top Mission Control HUD header + Live Cosmic Telemetry Ticker shown across tabs.
class _MissionControlHudBar extends StatefulWidget {
  const _MissionControlHudBar({
    required this.onTapProfile,
    required this.onTapStreak,
    required this.onTapSearch,
  });

  final VoidCallback onTapProfile;
  final VoidCallback onTapStreak;
  final VoidCallback onTapSearch;

  @override
  State<_MissionControlHudBar> createState() => _MissionControlHudBarState();
}

class _MissionControlHudBarState extends State<_MissionControlHudBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tickerCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 28),
  )..repeat();

  @override
  void dispose() {
    _tickerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    final state = AppScope.of(context);
    final settings = state.settings;
    final streak = settings.quizBests['streak'] ?? 0;
    final stars = settings.bestFor('easy') +
        settings.bestFor('medium') +
        settings.bestFor('hard');
    final rankLabel = stars >= 25
        ? (isHi ? 'कमांडर' : 'Commander')
        : stars >= 12
            ? (isHi ? 'पायलट' : 'Pilot')
            : (isHi ? 'कैडेट' : 'Cadet');
    final now = DateTime.now();
    final moonLit = (moonPhase(now).lit * 100).round();
    final marsDistMkm = (distanceFromEarthKm('mars', now) / 1e6).round();

    final tickerText = isHi
        ? '🛰️ ISS गति: 27,600 km/h   •   🌕 चंद्रमा: $moonLit% प्रकाशित   •   🔴 मंगल दूरी: ${marsDistMkm}M km   •   ☀️ आदित्य-L1: L1 कक्षा (1.5M km)   •   🚀 वॉयेजर 1: 24.6B km दूर   •   '
        : '🛰️ ISS SPEED: 27,600 KM/H   •   🌕 MOON: $moonLit% LIT   •   🔴 MARS RANGE: ${marsDistMkm}M KM   •   ☀️ ADITYA-L1: L1 HALO ORBIT   •   🚀 VOYAGER 1: 24.6B KM   •   ';

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 4),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? <Color>[
                  const Color(0xFF0E1734).withValues(alpha: 0.92),
                  const Color(0xFF141132).withValues(alpha: 0.92),
                ]
              : <Color>[p.surface, p.surfaceHigh],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: p.accent.withValues(alpha: isDark ? 0.42 : 0.25),
          width: 1.2,
        ),
        boxShadow: isDark
            ? <BoxShadow>[
                BoxShadow(
                  color: p.accent.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              const HelioraLogo(size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'ASTRYL',
                          style: headingStyle(16, p.text),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: p.good.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: p.good.withValues(alpha: 0.55)),
                          ),
                          child: Text(
                            'LIVE HUD',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                              color: p.good,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isHi
                          ? 'अंतरिक्ष मिशन कंट्रोल'
                          : 'CYBER-SPACE MISSION CONTROL',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.7,
                        color: p.muted,
                      ),
                    ),
                  ],
                ),
              ),
              // Streak Pill
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: widget.onTapStreak,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: p.star.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: p.star.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('🔥', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '$streak',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: p.star,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Commander Rank Pill
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: widget.onTapProfile,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: p.orbit.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: p.orbit.withValues(alpha: 0.55)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('👩‍🚀', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        rankLabel,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: p.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Quick Search Icon
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: widget.onTapSearch,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: p.accent.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(color: p.accent.withValues(alpha: 0.45)),
                  ),
                  child: Icon(Icons.search_rounded,
                      size: 16, color: p.accentText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Live scrolling cosmic telemetry ticker
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 20,
              width: double.infinity,
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
              alignment: Alignment.centerLeft,
              child: AnimatedBuilder(
                animation: _tickerCtrl,
                builder: (context, _) {
                  return FractionalTranslation(
                    translation: Offset(-_tickerCtrl.value * 0.5, 0),
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '$tickerText$tickerText',
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: p.accentText,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Neon Cyber-Space Floating Capsule Bottom Dock with glowing gradient pills.
class _NeonCapsuleBottomDock extends StatelessWidget {
  const _NeonCapsuleBottomDock({
    required this.selectedIndex,
    required this.onSelect,
    required this.labels,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final List<String> labels;

  static const List<(IconData, IconData)> _icons = <(IconData, IconData)>[
    (Icons.public_outlined, Icons.public),
    (Icons.nights_stay_outlined, Icons.nights_stay),
    (Icons.compare_arrows_rounded, Icons.compare_arrows_rounded),
    (Icons.person_outline_rounded, Icons.person_rounded),
    (Icons.bolt_outlined, Icons.bolt_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? <Color>[
                    const Color(0xFF0A1128).withValues(alpha: 0.96),
                    const Color(0xFF130E2B).withValues(alpha: 0.96),
                  ]
                : <Color>[Colors.white, p.surfaceHigh],
          ),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: p.accent.withValues(alpha: isDark ? 0.45 : 0.3),
            width: 1.3,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: p.accent.withValues(alpha: isDark ? 0.16 : 0.06),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.55 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: _DockItem(
                  icon: selectedIndex == i ? _icons[i].$2 : _icons[i].$1,
                  label: labels[i],
                  selected: selectedIndex == i,
                  isPrimary3D: i == 0,
                  onTap: () => onSelect(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.isPrimary3D,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool isPrimary3D;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    p.accent.withValues(alpha: 0.28),
                    p.orbit.withValues(alpha: 0.26),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(999),
          border: selected
              ? Border.all(color: p.accent.withValues(alpha: 0.65), width: 1.1)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: isPrimary3D ? 23 : 21,
              color: selected ? p.accentText : p.muted,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                color: selected ? p.accentText : p.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The main tab: the Solar System in 3D, Quick Launch Bento Grid, and
/// Holographic 2-Column Planet Showcase.
class ExploreTab extends StatefulWidget {
  const ExploreTab({
    super.key,
    required this.active,
    this.onSelectTab,
  });

  /// False while another tab is shown, so the animation can stop.
  final bool active;
  final ValueChanged<int>? onSelectTab;

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab>
    with SingleTickerProviderStateMixin {
  String _selectedId = 'earth';

  /// The planet the Space view's camera is on; null shows the whole system.
  String? _spaceFocus;

  /// The date the 3D view shows. Starts at today.
  DateTime _date = DateTime.now();
  bool _playing = false;
  late final Ticker _ticker = createTicker(_tick);
  Duration _last = Duration.zero;

  /// While playing, time runs this many days per second.
  static const double _daysPerSecond = 20;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExploreTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.active && _playing) {
      _ticker.stop();
      _playing = false;
    }
  }

  void _tick(Duration elapsed) {
    if (elapsed - _last < const Duration(milliseconds: 33)) {
      return;
    }
    final seconds = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    final next = _date.add(
        Duration(minutes: (seconds * _daysPerSecond * 24 * 60).round()));
    if (next.isAfter(orbitMaxDate)) {
      _stop();
      setState(() => _date = orbitMaxDate.toLocal());
      return;
    }
    setState(() => _date = next);
  }

  void _togglePlay() {
    if (_playing) {
      _stop();
    } else {
      _last = Duration.zero;
      _ticker.start();
      setState(() => _playing = true);
    }
  }

  void _stop() {
    _ticker.stop();
    if (mounted) {
      setState(() => _playing = false);
    }
  }

  void _setDate(DateTime date) {
    if (_playing) {
      _stop();
    }
    setState(() => _date = clampOrbitDate(date.toUtc()).toLocal());
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: orbitMinDate.toLocal(),
      lastDate: orbitMaxDate.toLocal(),
    );
    if (picked != null) {
      _setDate(DateTime(picked.year, picked.month, picked.day, 12));
    }
  }

  /// Flies the Space view to [id], or back to the whole system for null.
  void _focusSpace(String? id) {
    setState(() {
      _spaceFocus = id;
      if (id != null) {
        _selectedId = id;
      }
    });
  }

  void _openPlanet(Planet planet) {
    setState(() => _selectedId = planet.id);
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PlanetScreen(planet: planet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final selected = planetById(_selectedId);
    final width = MediaQuery.sizeOf(context).width;
    final spaceHeight = ((width - 32) * 1.08).clamp(300.0, 480.0);
    final isHi = Localizations.localeOf(context).languageCode == 'hi';

    return ListView(
      padding: const EdgeInsets.only(bottom: 28, top: 4),
      children: <Widget>[
        // Planet & Moon selector chips right above the 3D NASA Eyes viewport.
        _PlanetChips(
          bodies: allBodies,
          selectedId: _spaceFocus ?? '',
          onSelect: (planet) => _focusSpace(planet.id),
        ),
        const SizedBox(height: 8),
        // Unified 3D "Eyes on the Solar System" interactive viewport with Neon Cockpit Rim.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: spaceHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                  color: p.accent.withValues(alpha: 0.5), width: 1.5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: p.accent.withValues(alpha: 0.14),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: !widget.active
                ? const SizedBox.shrink()
                : SpaceView(
                    date: _date,
                    focusId: _spaceFocus,
                    onFocus: _focusSpace,
                    nameOf: (planet) => planetName(l, planet),
                    backLabel: l.spaceBack,
                  ),
          ),
        ),
        // Live time scrubber bar directly under the 3D viewport.
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: _DateBar(
            date: _date,
            playing: _playing,
            onPick: _pickDate,
            onBack: () => _setDate(_date.subtract(const Duration(days: 30))),
            onForward: () => _setDate(_date.add(const Duration(days: 30))),
            onPlay: _togglePlay,
            onToday: () => _setDate(DateTime.now()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          child: Text(
            l.spaceHint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: p.muted),
          ),
        ),
        // Selected Planet / Moon live telemetry & details card right below!
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: _GlobeInfoCard(
            planet: selected,
            date: _date,
            onOpen: () => _openPlanet(selected),
          ),
        ),
        // Quick Launch Mission Bento Tiles (4 interactive shortcuts)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: _QuickLaunchBentoGrid(
            isHi: isHi,
            onOpenQuiz: () => widget.onSelectTab?.call(4),
          ),
        ),
        // Holographic 2-Column Planet Showcase Grid
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
          child: Row(
            children: <Widget>[
              Icon(Icons.auto_awesome, size: 18, color: p.accentText),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.planetsTitle,
                  style: headingStyle(18, p.text),
                ),
              ),
              Text(
                isHi ? 'होलोग्राफिक ग्रिड' : 'HOLOGRAPHIC DECK',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: p.accentText,
                ),
              ),
            ],
          ),
        ),
        _PopularCards(
          selectedId: _selectedId,
          onTap: (planet) {
            _focusSpace(planet.id);
            _openPlanet(planet);
          },
        ),
      ],
    );
  }
}

/// 2x2 Quick Launch Bento Tiles on the Home screen.
class _QuickLaunchBentoGrid extends StatelessWidget {
  const _QuickLaunchBentoGrid({
    required this.isHi,
    required this.onOpenQuiz,
  });

  final bool isHi;
  final VoidCallback onOpenQuiz;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final city = cityById(AppScope.of(context).settings.cityId) ?? cities.first;
    final tiles = <({
      String emoji,
      String title,
      String sub,
      Color tint,
      VoidCallback onTap,
    })>[
      (
        emoji: '🛰️',
        title: isHi ? 'ISS लाइव ट्रैकर' : 'Live ISS Tracker',
        sub: isHi ? 'कक्षा और पास समय' : '27,600 km/h orbit',
        tint: p.accent,
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => IssScreen(city: city)),
            ),
      ),
      (
        emoji: '✨',
        title: isHi ? '3D तारामंडल मैप' : 'Interactive Star Map',
        sub: isHi ? '1,000 तारे · 89 तारामंडल' : '1,000 stars · 89 constellations',
        tint: p.orbit,
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const StarMapScreen()),
            ),
      ),
      (
        emoji: '🚀',
        title: isHi ? 'अंतरिक्ष यान रडार' : 'Deep Spacecraft',
        sub: isHi ? 'वॉयेजर · JWST · आदित्य-L1' : 'Voyager · JWST · Aditya-L1',
        tint: p.good,
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SpacecraftScreen()),
            ),
      ),
      (
        emoji: '⚡',
        title: isHi ? '60s क्विज़ ब्लिट्ज़' : '60s Quiz Blitz',
        sub: isHi ? '3 लाइफ · लीडरबोर्ड' : '3 lives · Daily 5 arena',
        tint: p.star,
        onTap: onOpenQuiz,
      ),
    ];

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: _BentoTile(item: tiles[0])),
            const SizedBox(width: 10),
            Expanded(child: _BentoTile(item: tiles[1])),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(child: _BentoTile(item: tiles[2])),
            const SizedBox(width: 10),
            Expanded(child: _BentoTile(item: tiles[3])),
          ],
        ),
      ],
    );
  }
}

class _BentoTile extends StatelessWidget {
  const _BentoTile({required this.item});

  final ({
    String emoji,
    String title,
    String sub,
    Color tint,
    VoidCallback onTap,
  }) item;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                item.tint.withValues(alpha: 0.18),
                p.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: item.tint.withValues(alpha: 0.45),
              width: 1.2,
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: item.tint.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(item.emoji, style: const TextStyle(fontSize: 19)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: headingFont,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: p.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: p.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Date controls under the 3D view: back, the date, forward, play, today.
class _DateBar extends StatelessWidget {
  const _DateBar({
    required this.date,
    required this.playing,
    required this.onPick,
    required this.onBack,
    required this.onForward,
    required this.onPlay,
    required this.onToday,
  });

  final DateTime date;
  final bool playing;
  final VoidCallback onPick;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onPlay;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final text = MaterialLocalizations.of(context).formatMediumDate(date);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: l.monthBack,
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: p.text, fontSize: 15),
              ),
            ),
          ),
          IconButton(
            tooltip: l.monthForward,
            onPressed: onForward,
            icon: const Icon(Icons.chevron_right),
          ),
          IconButton.filledTonal(
            tooltip: playing ? l.pause : l.play,
            style: IconButton.styleFrom(
              backgroundColor: playing ? p.accent : p.surface,
              foregroundColor: playing ? p.onAccent : p.text,
            ),
            onPressed: onPlay,
            icon: Icon(playing ? Icons.pause : Icons.play_arrow),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: isToday && !playing ? null : onToday,
            child: Text(l.today),
          ),
        ],
      ),
    );
  }
}

/// 2-Column Holographic Bento Grid for the Sun, the planets and Pluto,
/// each with its own planetary nebula aura, temperature, moons and life score.
class _PopularCards extends StatelessWidget {
  const _PopularCards({required this.selectedId, required this.onTap});

  final String selectedId;
  final ValueChanged<Planet> onTap;

  static final List<Planet> _bodies = <Planet>[
    planetById('sun'),
    ...planets,
    planetById('pluto'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final favorites = AppScope.of(context).settings.favorites;
    final bodies = <Planet>[
      for (final b in _bodies)
        if (favorites.contains(b.id)) b,
      for (final b in _bodies)
        if (!favorites.contains(b.id)) b,
    ];

    final rows = <Widget>[];
    for (var i = 0; i < bodies.length; i += 2) {
      if (i > 0) {
        rows.add(const SizedBox(height: 12));
      }
      final left = bodies[i];
      final right = i + 1 < bodies.length ? bodies[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: _HolographicPlanetCard(
                  planet: left,
                  selected: left.id == selectedId,
                  starred: favorites.contains(left.id),
                  l: l,
                  p: p,
                  onTap: () => onTap(left),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: right != null
                    ? _HolographicPlanetCard(
                        planet: right,
                        selected: right.id == selectedId,
                        starred: favorites.contains(right.id),
                        l: l,
                        p: p,
                        onTap: () => onTap(right),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: rows),
    );
  }
}

class _HolographicPlanetCard extends StatelessWidget {
  const _HolographicPlanetCard({
    required this.planet,
    required this.selected,
    required this.starred,
    required this.l,
    required this.p,
    required this.onTap,
  });

  final Planet planet;
  final bool selected;
  final bool starred;
  final dynamic l;
  final Palette p;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final life = lifeScore(planet).total;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                planet.color.withValues(alpha: selected ? 0.34 : 0.22),
                p.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? p.accent
                  : planet.color.withValues(alpha: 0.45),
              width: selected ? 1.8 : 1.2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: planet.color.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: planet.color.withValues(alpha: 0.55),
                                blurRadius: 24,
                              ),
                            ],
                          ),
                        ),
                        Hero(
                          tag: 'planet-hero-${planet.id}',
                          child: PlanetBall(planet: planet, size: 54),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (starred)
                    Icon(Icons.star_rounded, size: 20, color: p.star),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                planetName(l, planet),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: headingStyle(16, p.text),
              ),
              const SizedBox(height: 2),
              Text(
                bodySubtitle(l, planet),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.5, color: p.muted, height: 1.25),
              ),
              const Spacer(),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: <Widget>[
                  _MiniHoloBadge(
                    text: '${planet.meanTempC}°C',
                    color: planet.color,
                  ),
                  if (!planet.isStar)
                    _MiniHoloBadge(
                      text: '🌙 ${planet.moons}',
                      color: p.orbit,
                    ),
                  _MiniHoloBadge(
                    text: '♥ $life/10',
                    color: life >= 5 ? p.good : p.accent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniHoloBadge extends StatelessWidget {
  const _MiniHoloBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: p.text,
        ),
      ),
    );
  }
}

class _PlanetChips extends StatelessWidget {
  const _PlanetChips({
    required this.selectedId,
    required this.onSelect,
    this.bodies,
  });

  final String selectedId;
  final ValueChanged<Planet> onSelect;

  /// The bodies to list. Everything in the app when null.
  final List<Planet>? bodies;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final list = bodies ?? allBodies;
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: list.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final planet = list[index];
          final on = planet.id == selectedId;
          return ChoiceChip(
            selected: on,
            showCheckmark: false,
            onSelected: (_) => onSelect(planet),
            avatar: CircleAvatar(backgroundColor: planet.color, radius: 6),
            label: Text(planetName(l, planet)),
            labelStyle: TextStyle(
              color: on ? p.onAccent : p.text,
              fontWeight: on ? FontWeight.w700 : FontWeight.w500,
            ),
            selectedColor: p.accent,
            backgroundColor: p.surface,
            side: BorderSide(
                color: on ? p.accent : planet.color.withValues(alpha: 0.45)),
            shape: const StadiumBorder(),
          );
        },
      ),
    );
  }
}

class _GlobeInfoCard extends StatelessWidget {
  const _GlobeInfoCard({
    required this.planet,
    required this.date,
    required this.onOpen,
  });

  final Planet planet;
  final DateTime date;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final t = PlanetText(context);
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    final double earthDistKm;
    if (planet.id == 'earth') {
      earthDistKm = 0;
    } else if (planet.id == 'moon') {
      earthDistKm = 384400;
    } else {
      final id = planet.isMoon ? (planet.parentId ?? 'earth') : planet.id;
      earthDistKm =
          id == 'sun' || hasOrbit(id) ? distanceFromEarthKm(id, date) : 0;
    }

    Widget stat(String label, String value) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: p.muted)),
            const SizedBox(height: 2),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700, color: p.text)),
          ],
        ),
      );
    }

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      borderColor: planet.color.withValues(alpha: 0.55),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              PlanetBall(planet: planet, size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      planetName(l, planet),
                      style: TextStyle(
                          fontFamily: headingFont,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: p.text),
                    ),
                    Text(
                      bodySubtitle(l, planet),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: p.muted),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(l.openDetails),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              stat(l.diameter, t.diameter(planet)),
              stat(l.gravity, t.relativeGravity(planet)),
              stat(l.avgTempShort,
                  '${formatNumber(context, planet.meanTempC)} °C'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              stat(
                earthDistKm > 0
                    ? l.distanceFromEarth
                    : (isHi ? 'सूर्य से दूरी' : l.distance),
                earthDistKm > 0
                    ? t.kilometres(earthDistKm)
                    : t.distance(planet),
              ),
              stat(l.oxygen, formatPercent(context, planet.oxygenPercent)),
              stat(l.lifeScoreShort,
                  '${formatNumber(context, lifeScore(planet).total)}/${formatNumber(context, LifeScore.maxTotal)}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Icon(
                planet.breathable ? Icons.check : Icons.close,
                size: 18,
                color: planet.breathable ? p.good : p.bad,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  planet.breathable ? l.breathable : l.notBreathable,
                  style: TextStyle(
                      fontSize: 13,
                      color: planet.breathable ? p.good : p.bad),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
