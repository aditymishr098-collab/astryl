import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../core/daylight.dart';
import '../core/events.dart';
import '../core/format.dart';
import '../core/sky.dart';
import '../data/cities.dart';
import '../data/planets.dart';
import '../l10n/event_text.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/moon_view.dart';
import 'events_screen.dart';
import 'binocular_screen.dart';
import 'finder_screen.dart';
import 'iss_screen.dart';
import 'missions_screen.dart';
import 'moon_calendar_screen.dart';
import 'news_screen.dart';
import 'satellites_screen.dart';
import 'spacecraft_screen.dart';
import 'star_map_screen.dart';
import 'tonight_share_screen.dart';

/// "Tonight's sky": the Moon's phase and which planets can be seen tonight
/// from the chosen city, with rise and set times.
class SkyScreen extends StatefulWidget {
  const SkyScreen({super.key});

  @override
  State<SkyScreen> createState() => _SkyScreenState();
}

class _SkyScreenState extends State<SkyScreen> {
  /// The day being shown. Null means today, and follows the clock.
  DateTime? _picked;

  SkyTonight? _sky;
  SunDay? _sun;
  DateTime? _darkStarts;
  DateTime? _darkEnds;
  String _skyKey = '';

  ({double age, double lit})? _phase;
  DateTime? _nextFull;
  DateTime? _nextNew;

  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  DateTime get _day => _picked ?? _today;

  /// The middle of the dark part of the night that starts on [day], for
  /// opening the star map on that night.
  DateTime _nightMiddle(City city, DateTime day) {
    final w = nightWindow(day, city.lat, city.lon);
    return w.start.add(w.end.difference(w.start) ~/ 2).toLocal();
  }

  /// Works the sky out once per city and day, not on every rebuild.
  void _compute(City city) {
    final now = DateTime.now();
    final day = _day;
    final key = '${city.id}-${day.year}-${day.month}-${day.day}';
    if (key == _skyKey) {
      return;
    }
    _skyKey = key;
    // The Moon card describes right now for today, and 9 pm for any other day.
    final at = _picked == null
        ? now
        : DateTime(day.year, day.month, day.day, 21);
    _sky = skyTonight(day, city.lat, city.lon);
    _phase = moonPhase(at);
    _nextFull = nextPhase(at, 180).toLocal();
    _nextNew = nextPhase(at, 0).toLocal();
    final sun = sunDay(day, city.lat, city.lon);
    _sun = sun;
    // The sky is fully dark from this evening's dusk to the next dawn.
    _darkStarts = sun.darkStarts;
    _darkEnds = sunDay(DateTime(day.year, day.month, day.day + 1), city.lat,
            city.lon)
        .darkEnds;
  }

  void _setDay(DateTime d) {
    var day = DateTime(d.year, d.month, d.day);
    if (day.isBefore(moonCalendarFirst)) day = moonCalendarFirst;
    if (day.isAfter(moonCalendarLast)) day = moonCalendarLast;
    setState(() {
      _picked = day == _today ? null : day;
    });
  }

  void _shiftDay(int delta) {
    final d = _day;
    _setDay(DateTime(d.year, d.month, d.day + delta));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: moonCalendarFirst,
      lastDate: moonCalendarLast,
    );
    if (picked != null && mounted) {
      _setDay(picked);
    }
  }

  Future<void> _openCalendar() async {
    final picked = await Navigator.of(context).push<DateTime>(
      MaterialPageRoute<DateTime>(
        builder: (_) => MoonCalendarScreen(initial: _day),
      ),
    );
    if (picked != null && mounted) {
      _setDay(picked);
    }
  }

  Future<void> _pickCity() async {
    final state = AppScope.read(context);
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _CitySheet(),
    );
    if (picked != null) {
      await state.setCity(picked);
    }
  }

  String _time(DateTime? t) {
    if (t == null) {
      return '–';
    }
    return MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(t.toLocal()));
  }

  String _date(DateTime? t) => t == null
      ? '–'
      : MaterialLocalizations.of(context).formatMediumDate(t.toLocal());

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final city = cityById(AppScope.of(context).settings.cityId);
    final today = _picked == null;

    final header = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(today ? l.skyTitle : l.skyOtherNight,
                style: TextStyle(fontFamily: headingFont, fontSize: 26, fontWeight: FontWeight.w700, color: p.text)),
          ),
          if (city != null)
            ActionChip(
              avatar: Icon(Icons.place_outlined, size: 18, color: p.accentText),
              label: Text(cityName(l, city)),
              labelStyle:
                  TextStyle(color: p.text, fontWeight: FontWeight.w600),
              backgroundColor: p.surface,
              side: BorderSide(color: p.border),
              shape: const StadiumBorder(),
              onPressed: _pickCity,
            ),
        ],
      ),
    );

    final calendarCard = _NavCard(
      icon: Icons.calendar_month_outlined,
      title: l.moonCalendar,
      hint: l.moonCalendarHint,
      onTap: _openCalendar,
    );

    if (city == null) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: <Widget>[
          header,
          calendarCard,
          const SizedBox(height: 12),
          const _EventsCard(),
          const SizedBox(height: 12),
          const _NewsCard(),
          const SizedBox(height: 12),
          const _MissionsCard(),
          const SizedBox(height: 12),
          const _SpacecraftCard(),
          const SizedBox(height: 12),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.nights_stay_outlined, size: 48, color: p.accentText),
                const SizedBox(height: 12),
                Text(l.chooseCityHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: p.text, height: 1.4)),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: _pickCity,
                  icon: const Icon(Icons.place_outlined),
                  label: Text(l.chooseCity),
                ),
              ],
            ),
          ),
        ],
      );
    }

    _compute(city);
    final sky = _sky!;
    final phase = _phase!;
    final sun = _sun!;
    final day = _day;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: <Widget>[
        header,
        _DateBar(
          label: today
              ? '${l.today} · ${_date(day)}'
              : MaterialLocalizations.of(context).formatMediumDate(day),
          isToday: today,
          canPrevious: day.isAfter(moonCalendarFirst),
          canNext: day.isBefore(moonCalendarLast),
          onPrevious: () => _shiftDay(-1),
          onNext: () => _shiftDay(1),
          onPick: _pickDate,
          onToday: () => setState(() => _picked = null),
        ),
        const SizedBox(height: 12),
        // Clean Moon & Tonight's Sky summary card.
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  MoonView(
                    age: phase.age,
                    lit: phase.lit,
                    size: 80,
                    southern: city.lat < 0,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(moonPhaseName(l, phaseIndex(phase.age)),
                            style: TextStyle(
                                fontFamily: headingFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: p.text)),
                        const SizedBox(height: 4),
                        Text(
                          l.illuminated(
                              formatNumber(context, (phase.lit * 100).round())),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: p.accentText),
                        ),
                      ],
                    ),
                  ),
                  if (today) _FindButton(city: city, targetId: 'moon'),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 10),
              InfoRow(
                  icon: Icons.north_east,
                  label: l.moonrise,
                  value: _time(sky.moon.rise)),
              InfoRow(
                  icon: Icons.south_east,
                  label: l.moonset,
                  value: _time(sky.moon.set)),
              InfoRow(
                  icon: Icons.circle,
                  label: l.nextFull,
                  value: _date(_nextFull)),
              InfoRow(
                  icon: Icons.circle_outlined,
                  label: l.nextNew,
                  value: _date(_nextNew)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _NavCard(
          icon: Icons.public,
          title: today ? l.planetsTonight : l.planetsThatNight,
          hint: l.planetsTonightHint,
          builder: (_) => PlanetsTonightScreen(
              planets: sky.planets, city: city, time: _time, today: today),
        ),
        const SizedBox(height: 12),
        calendarCard,
        const SizedBox(height: 12),
        _NavCard(
          icon: Icons.auto_awesome_outlined,
          title: l.starMapTitle,
          hint: l.starMapCardHint,
          builder: (_) => StarMapScreen(
            initialTime: today ? null : _nightMiddle(city, day),
          ),
        ),
        const SizedBox(height: 12),
        _NavCard(
          icon: Icons.zoom_in_map_outlined,
          title: l.binocularsTitle,
          hint: l.binocularsHint,
          builder: (_) => BinocularScreen(day: day),
        ),
        const SizedBox(height: 12),
        _SunCard(
          sun: sun,
          darkStarts: _darkStarts,
          darkEnds: _darkEnds,
          time: _time,
        ),
        const SizedBox(height: 20),
        if (!kIsWeb)
          _NavCard(
            icon: Icons.ios_share_outlined,
            title: l.tonightShareTitle,
            hint: l.tonightShareHint,
            builder: (_) => TonightShareScreen(city: city, day: day),
          ),
        const SizedBox(height: 12),
        Text(l.cityNote,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: p.muted)),
        const SizedBox(height: 20),
        const _EventsCard(),
        const SizedBox(height: 12),
        // The online cards need the Android app.
        if (!kIsWeb) ...<Widget>[
          _IssCard(city: city),
          const SizedBox(height: 12),
          _NavCard(
            icon: Icons.satellite_alt_outlined,
            title: l.satellitesTitle,
            hint: l.satellitesCardHint,
            builder: (_) => SatellitesScreen(city: city),
          ),
          const SizedBox(height: 12),
          const _NewsCard(),
          const SizedBox(height: 12),
        ],
        const _MissionsCard(),
        const SizedBox(height: 12),
        const _SpacecraftCard(),
      ],
    );
  }
}

/// Moves the Sky tab to another day: arrows, a date picker and a way back.
class _DateBar extends StatelessWidget {
  const _DateBar({
    required this.label,
    required this.isToday,
    required this.canPrevious,
    required this.canNext,
    required this.onPrevious,
    required this.onNext,
    required this.onPick,
    required this.onToday,
  });

  final String label;
  final bool isToday;
  final bool canPrevious;
  final bool canNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPick;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                tooltip: l.previousDay,
                icon: const Icon(Icons.chevron_left),
                onPressed: canPrevious ? onPrevious : null,
              ),
              Expanded(
                child: Semantics(
                  button: true,
                  label: l.pickDate,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: onPick,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.calendar_month_outlined,
                              size: 20, color: p.accentText),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: p.text)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: l.nextDay,
                icon: const Icon(Icons.chevron_right),
                onPressed: canNext ? onNext : null,
              ),
            ],
          ),
          if (!isToday)
            TextButton.icon(
              onPressed: onToday,
              icon: const Icon(Icons.today_outlined),
              label: Text(l.backToTonight),
            ),
        ],
      ),
    );
  }
}

/// Sunrise, sunset, golden hour, twilight and the dark sky for one day.
class _SunCard extends StatelessWidget {
  const _SunCard({
    required this.sun,
    required this.darkStarts,
    required this.darkEnds,
    required this.time,
  });

  final SunDay sun;
  final DateTime? darkStarts;
  final DateTime? darkEnds;
  final String Function(DateTime? t) time;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final dark = darkStarts == null || darkEnds == null
        ? '–'
        : '${time(darkStarts)} – ${time(darkEnds)}';
    final hours = sun.dayLength.inMinutes ~/ 60;
    final minutes = sun.dayLength.inMinutes % 60;
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(l.sunLightTitle,
              style: TextStyle(fontFamily: headingFont, fontSize: 18, fontWeight: FontWeight.w700, color: p.text)),
          if (sun.stayUp || sun.stayDown) ...<Widget>[
            const SizedBox(height: 6),
            Text(sun.stayUp ? l.sunStaysUp : l.sunStaysDown,
                style: TextStyle(fontSize: 13, color: p.accentText)),
          ],
          const SizedBox(height: 6),
          InfoRow(
              icon: Icons.brightness_5_outlined,
              label: l.firstLight,
              value: time(sun.firstLight)),
          InfoRow(
              icon: Icons.wb_sunny_outlined,
              label: l.sunrise,
              value: time(sun.sunrise)),
          InfoRow(
              icon: Icons.camera_alt_outlined,
              label: l.goldenMorningEnds,
              value: time(sun.goldenMorningEnds)),
          InfoRow(
              icon: Icons.light_mode_outlined,
              label: l.solarNoon,
              value: time(sun.solarNoon)),
          InfoRow(
              icon: Icons.camera_alt_outlined,
              label: l.goldenEveningStarts,
              value: time(sun.goldenEveningStarts)),
          InfoRow(
              icon: Icons.wb_twilight,
              label: l.sunset,
              value: time(sun.sunset)),
          InfoRow(
              icon: Icons.brightness_4_outlined,
              label: l.lastLight,
              value: time(sun.lastLight)),
          InfoRow(
              icon: Icons.dark_mode_outlined,
              label: l.darkSky,
              value: dark),
          InfoRow(
              icon: Icons.timelapse,
              label: l.sunDayLength,
              value: l.durationHm(formatNumber(context, hours),
                  formatNumber(context, minutes))),
          const SizedBox(height: 6),
          Text(l.sunNote, style: TextStyle(fontSize: 12, color: p.muted)),
        ],
      ),
    );
  }
}

/// The page behind "Planets tonight": every planet with its status, the best
/// time to look, the direction and height, and the rise and set times.
class PlanetsTonightScreen extends StatelessWidget {
  const PlanetsTonightScreen({
    super.key,
    required this.planets,
    required this.city,
    required this.time,
    required this.today,
  });

  final List<BodyNight> planets;
  final City city;
  final String Function(DateTime? t) time;
  final bool today;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(today ? l.planetsTonight : l.planetsThatNight)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          for (final night in planets) ...<Widget>[
            _PlanetNightCard(
                night: night, city: city, time: time, canFind: today),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          Text(l.cityNote,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: p.muted)),
        ],
      ),
    );
  }
}

class _PlanetNightCard extends StatelessWidget {
  const _PlanetNightCard(
      {required this.night,
      required this.city,
      required this.time,
      this.canFind = true});

  final BodyNight night;
  final City city;
  final String Function(DateTime? t) time;

  /// The finder points at the sky now, so it is only offered for today.
  final bool canFind;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final planet = planetById(night.id);
    final telescope = night.id == 'uranus' || night.id == 'neptune';

    final String status;
    final Color statusColor;
    switch (night.visibility) {
      case SkyVisibility.allNight:
        status = l.statusVisible;
        statusColor = p.good;
      case SkyVisibility.evening:
        status = l.statusEvening;
        statusColor = p.good;
      case SkyVisibility.morning:
        status = l.statusMorning;
        statusColor = p.good;
      case SkyVisibility.notVisible:
        status = l.statusNotVisible;
        statusColor = p.muted;
    }

    final best = night.bestTime;
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: PlanetBall(planet: planet, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(planetName(l, planet),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: p.text)),
                const SizedBox(height: 2),
                Text(status,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: statusColor)),
                if (best != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    '${l.bestAt(time(best))} · '
                    '${l.altitudeDir(directionName(l, compassIndex(night.bestAzimuth)), formatNumber(context, night.bestAltitude.round()))}',
                    style: TextStyle(fontSize: 13, color: p.text),
                  ),
                ],
                const SizedBox(height: 4),
                Text(l.riseSet(time(night.rise), time(night.set)),
                    style: TextStyle(fontSize: 12, color: p.muted)),
                if (telescope && best != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(l.needsTelescope,
                      style: TextStyle(fontSize: 12, color: p.accentText)),
                ],
              ],
            ),
          ),
          if (canFind) _FindButton(city: city, targetId: night.id),
        ],
      ),
    );
  }
}

/// Opens the list of space events, with the next one as a teaser.
class _EventsCard extends StatelessWidget {
  const _EventsCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final events = upcomingEvents();
    final next = events.isEmpty ? null : events.first;
    final subtitle = next == null
        ? l.eventsSubtitle
        : l.eventsNext(
            eventTitle(l, next),
            eventWhen(context, l, daysUntil(next, DateTime.now())),
          );
    return Semantics(
      button: true,
      label: l.eventsTitle,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => const EventsScreen(),
          ));
        },
        child: SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              Icon(Icons.event_outlined, color: p.accentText),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(l.eventsTitle,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: p.text)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(fontSize: 13, color: p.muted)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: p.muted),
            ],
          ),
        ),
      ),
    );
  }
}

/// A card that opens another screen.
class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.title,
    required this.hint,
    this.builder,
    this.onTap,
  }) : assert(builder != null || onTap != null);

  final IconData icon;
  final String title;
  final String hint;
  final WidgetBuilder? builder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap ??
            () {
              Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: builder!));
            },
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
                    Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: p.text)),
                    const SizedBox(height: 2),
                    Text(hint, style: TextStyle(fontSize: 13, color: p.muted)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: p.muted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens the space news.
class _NewsCard extends StatelessWidget {
  const _NewsCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _NavCard(
      icon: Icons.newspaper_outlined,
      title: l.newsTitle,
      hint: l.newsCardHint,
      builder: (_) => const NewsScreen(),
    );
  }
}

/// Opens the missions timeline.
class _MissionsCard extends StatelessWidget {
  const _MissionsCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _NavCard(
      icon: Icons.timeline,
      title: l.missionsTitle,
      hint: l.missionsCardHint,
      builder: (_) => const MissionsScreen(),
    );
  }
}

/// Opens "Spacecraft now".
class _SpacecraftCard extends StatelessWidget {
  const _SpacecraftCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _NavCard(
      icon: Icons.rocket_launch_outlined,
      title: l.spacecraftTitle,
      hint: l.spacecraftCardHint,
      builder: (_) => const SpacecraftScreen(),
    );
  }
}

/// Opens the space station screen.
class _IssCard extends StatelessWidget {
  const _IssCard({required this.city});

  final City city;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    return Semantics(
      button: true,
      label: l.issTitle,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => IssScreen(city: city),
          ));
        },
        child: SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              Icon(Icons.satellite_alt, color: p.accentText),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(l.issTitle,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: p.text)),
                    const SizedBox(height: 2),
                    Text(l.issCardHint,
                        style: TextStyle(fontSize: 13, color: p.muted)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: p.muted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens the compass finder for one body.
class _FindButton extends StatelessWidget {
  const _FindButton({required this.city, required this.targetId});

  final City city;
  final String targetId;

  @override
  Widget build(BuildContext context) {
    // The compass finder needs the phone's motion sensors.
    if (kIsWeb) {
      return const SizedBox.shrink();
    }
    final l = context.l10n;
    final p = Palette.of(context);
    return IconButton(
      tooltip: l.findPlanet,
      icon: Icon(Icons.explore_outlined, color: p.accentText),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => FinderScreen(city: city, targetId: targetId),
        ));
      },
    );
  }
}

class _CitySheet extends StatefulWidget {
  const _CitySheet();

  @override
  State<_CitySheet> createState() => _CitySheetState();
}

class _CitySheetState extends State<_CitySheet> {
  String _query = '';

  /// Asks Android for the approximate location and makes it the city.
  Future<void> _useMyLocation() async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final place = await state.bridge.getLocation(ask: true);
    if (!place.ok) {
      messenger.showSnackBar(SnackBar(
          content: Text(switch (place.status) {
        'denied' => l.locDenied,
        'off' => l.locOff,
        _ => l.locError,
      })));
      return;
    }
    await state.setMyLocationCity(place.lat, place.lon);
    navigator.pop(gpsCityId);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final q = _query.trim().toLowerCase();
    final list = q.isEmpty
        ? cities
        : cities
            .where((c) =>
                c.name.toLowerCase().contains(q) ||
                c.country.toLowerCase().contains(q))
            .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        children: <Widget>[
          if (!kIsWeb)
            ListTile(
              leading: Icon(Icons.my_location, color: p.accentText),
              title: Text(l.useMyLocation, style: TextStyle(color: p.text)),
              onTap: _useMyLocation,
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: false,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l.searchCity,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: p.surfaceHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Text(l.noCityFound,
                        style: TextStyle(color: p.muted)))
                : ListView.builder(
                    controller: controller,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final city = list[index];
                      return ListTile(
                        title:
                            Text(city.name, style: TextStyle(color: p.text)),
                        subtitle: Text(city.country,
                            style: TextStyle(color: p.muted)),
                        onTap: () => Navigator.of(context).pop(city.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
