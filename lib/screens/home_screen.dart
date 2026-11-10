import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../core/format.dart';
import '../core/habitability.dart';
import '../core/orbits.dart';
import '../data/cities.dart';
import '../data/planets.dart';
import '../data/tonight_alerts.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/space_view.dart';
import 'compare_screen.dart';
import 'planet_screen.dart';
import 'quiz_screen.dart';
import 'search_screen.dart';
import 'sky_screen.dart';
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
                      center: const Alignment(-0.75, -0.85),
                      radius: 1.35,
                      colors: <Color>[
                        p.orbit.withValues(alpha: 0.13),
                        p.accent.withValues(alpha: 0.05),
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
            child: IndexedStack(
              index: _tab,
              // The tabs stay alive, but only the one on screen may animate: a
              // hidden 3D planet would otherwise wake the phone 60 times a second.
              children: <Widget>[
                for (final (i, tab) in <Widget>[
                  ExploreTab(active: _tab == 0),
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
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0D1429).withValues(alpha: 0.95)
                : Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isDark
                  ? p.border.withValues(alpha: 0.9)
                  : p.border,
              width: 1.2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              selectedIndex: _tab,
              onDestinationSelected: (i) => setState(() => _tab = i),
              destinations: <NavigationDestination>[
                NavigationDestination(
                  icon: const Icon(Icons.public_outlined),
                  selectedIcon: const Icon(Icons.public),
                  label: l.navExplore,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.nights_stay_outlined),
                  selectedIcon: const Icon(Icons.nights_stay),
                  label: l.navSky,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.bar_chart_outlined),
                  selectedIcon: const Icon(Icons.bar_chart),
                  label: l.navCompare,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: l.navYou,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.quiz_outlined),
                  selectedIcon: const Icon(Icons.quiz),
                  label: l.navQuiz,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The main tab: the Solar System in 2D or 3D, and the list of planets.
class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key, required this.active});

  /// False while another tab is shown, so the animation can stop.
  final bool active;

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab>
    with SingleTickerProviderStateMixin {
  String _selectedId = 'earth';

  /// The planet the Space view's camera is on; null shows the whole system.
  String? _spaceFocus;

  /// The date the 2D view shows. Starts at today.
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
      // Already rebuilding, so no setState is needed here.
      _ticker.stop();
      _playing = false;
    }
  }

  void _tick(Duration elapsed) {
    // The whole tab is rebuilt for every step, so 30 steps a second are
    // plenty and use half the battery of 60.
    if (elapsed - _last < const Duration(milliseconds: 33)) {
      return;
    }
    final seconds = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    final next = _date.add(Duration(
        minutes: (seconds * _daysPerSecond * 24 * 60).round()));
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
    final spaceHeight = ((width - 40) * 1.15).clamp(320.0, 520.0);
    final isHi = Localizations.localeOf(context).languageCode == 'hi';

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: <Widget>[
        // Header: logo, title and LIVE badge.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Row(
            children: <Widget>[
              const HelioraLogo(size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l.appTitle,
                    maxLines: 1,
                    style: headingStyle(28, p.text),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: p.good.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: p.good.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 7,
                      height: 7,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: p.good),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isHi ? '3D लाइव सौरमंडल' : 'EYES ON SOLAR SYSTEM',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: p.good,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Search bar.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Semantics(
            button: true,
            label: l.searchTooltip,
            child: Material(
              color: p.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: p.border),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => const SearchScreen()),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.search, color: p.muted),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.searchHint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15, color: p.muted),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Planet & Moon selector chips right above the 3D NASA Eyes viewport.
        _PlanetChips(
          bodies: allBodies,
          selectedId: _spaceFocus ?? '',
          onSelect: (planet) => _focusSpace(planet.id),
        ),
        const SizedBox(height: 10),
        // Unified 3D "Eyes on the Solar System" interactive viewport.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: spaceHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: p.border),
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
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: _GlobeInfoCard(
            planet: selected,
            date: _date,
            onOpen: () => _openPlanet(selected),
          ),
        ),
        // All planets & worlds explorer below the telemetry details.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Text(l.planetsTitle, style: headingStyle(17, p.text)),
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

/// Date controls under the 2D view: back, the date, forward, play, today.
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

/// Tall cards for the Sun, the planets and Pluto, each with its own glow.
/// Starred bodies come first. Moons open from their planet.
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
    // The cards grow with the text size so the words always fit.
    final textScale =
        (MediaQuery.textScalerOf(context).scale(10) / 10).clamp(1.0, 1.4);
    return SizedBox(
      height: 164 * textScale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: bodies.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final planet = bodies[index];
          final on = planet.id == selectedId;
          final starred = favorites.contains(planet.id);
          return SizedBox(
            width: 140,
            child: Material(
              color: Color.alphaBlend(
                  planet.color.withValues(alpha: on ? 0.24 : 0.15),
                  p.surface),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
                side: on
                    ? BorderSide(color: p.accentText, width: 1.5)
                    : BorderSide(color: planet.color.withValues(alpha: 0.32)),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(26),
                onTap: () => onTap(planet),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 2, left: 2),
                            child: SizedBox(
                              height: 64,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: planet.color
                                              .withValues(alpha: 0.5),
                                          blurRadius: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Hero(
                                    tag: 'planet-hero-${planet.id}',
                                    child: PlanetBall(planet: planet, size: 58),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (starred)
                            Icon(Icons.star, size: 20, color: p.accentText),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            planetName(l, planet),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: headingStyle(15, p.text),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            bodySubtitle(l, planet),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.5, color: p.muted, height: 1.2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
      height: 44,
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
              fontWeight: on ? FontWeight.w600 : FontWeight.w500,
            ),
            selectedColor: p.accent,
            backgroundColor: p.surface,
            side: BorderSide(color: on ? p.accent : p.border),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              PlanetBall(planet: planet, size: 32),
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
              FilledButton.tonalIcon(
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
                earthDistKm > 0 ? t.kilometres(earthDistKm) : t.distance(planet),
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
