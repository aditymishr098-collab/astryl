import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../core/facts.dart';
import '../core/format.dart';
import '../core/habitability.dart';
import '../core/orbits.dart';
import '../data/planets.dart';
import '../l10n/gen/app_localizations.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/fact_card.dart';
import '../widgets/favorite_button.dart';
import '../widgets/motion.dart';
import '../widgets/share_card.dart';
import 'surface_map_screen.dart';

/// Text helpers shared by the planet and compare screens.
class PlanetText {
  PlanetText(this.context) : l = context.l10n;

  final BuildContext context;
  final AppLocalizations l;

  String diameter(Planet p) =>
      l.valueKm(formatNumber(context, p.diameterKm));

  String gravity(Planet p) =>
      '${formatNumber(context, p.gravity, decimals: 1)} m/s² '
      '(${formatNumber(context, p.relativeGravity, decimals: 2)} g)';

  String temperature(Planet p) => '${formatNumber(context, p.meanTempC)} °C';

  String day(Planet p) => p.dayHours > 48
      ? l.valueDays(formatNumber(context, p.dayHours / 24, decimals: 1))
      : l.valueHours(formatNumber(context, p.dayHours, decimals: 1));

  /// One trip around the Sun, or around its planet for a moon.
  String year(Planet p) {
    if (p.yearDays <= 0) {
      return '–';
    }
    return p.yearDays > 1000
        ? l.valueYears(formatNumber(context, p.yearDays / 365.25, decimals: 1))
        : l.valueDays(formatNumber(context, p.yearDays, decimals: 1));
  }

  String moons(Planet p) => formatNumber(context, p.moons);

  /// Distance from the Sun. A moon uses its planet's distance.
  String distance(Planet p) {
    if (p.isStar) {
      return '–';
    }
    final from = p.isMoon ? planetById(p.parentId ?? 'earth') : p;
    return l.valueMillionKm(
        formatNumber(context, from.distanceMillionKm, decimals: 1));
  }

  /// Distance between a moon and its planet.
  String parentDistance(Planet p) =>
      l.valueKm(formatNumber(context, p.distanceMillionKm * 1e6));

  String relativeGravity(Planet p) =>
      '${formatNumber(context, p.relativeGravity, decimals: 2)} g';

  String pressure(Planet p) {
    final bar = p.pressureBar;
    if (bar == null) {
      return l.noSurface;
    }
    if (bar == 0) {
      return '≈ 0 bar';
    }
    if (bar < 0.001) {
      return '< 0.001 bar';
    }
    return '${formatNumber(context, bar, decimals: 3)} bar';
  }

  String oxygen(Planet p) => formatPercent(context, p.oxygenPercent);

  /// A length of time in the easiest unit: seconds up to years.
  String duration(double seconds) {
    if (seconds < 60) {
      return l.valueSeconds(formatNumber(context, seconds, decimals: 1));
    }
    final minutes = seconds / 60;
    if (minutes < 60) {
      return l.valueMinutes(
          formatNumber(context, minutes, decimals: minutes < 10 ? 1 : 0));
    }
    final hours = minutes / 60;
    if (hours < 48) {
      return l.valueHours(formatNumber(context, hours, decimals: 1));
    }
    final days = hours / 24;
    if (days < 730) {
      return l.valueDays(formatNumber(context, days));
    }
    final years = days / 365.25;
    return l.valueYears(
        formatNumber(context, years, decimals: years < 100 ? 1 : 0));
  }

  /// A distance in km, or in millions of km when it is large.
  String kilometres(double km) => km < 1e6
      ? l.valueKm(formatNumber(context, km))
      : l.valueMillionKm(formatNumber(context, km / 1e6, decimals: 1));
}

class PlanetScreen extends StatefulWidget {
  const PlanetScreen({super.key, required this.planet});

  final Planet planet;

  @override
  State<PlanetScreen> createState() => _PlanetScreenState();
}

class _PlanetScreenState extends State<PlanetScreen> {
  /// A typical standing jump, used for the jump comparison.
  static const double _earthJumpCm = 40;

  /// The part of the page that becomes the shared image.
  final GlobalKey _cardKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    final l = context.l10n;
    final palette = Palette.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final bridge = AppScope.read(context).bridge;
    final name = planetName(l, widget.planet);
    setState(() => _sharing = true);
    var shared = false;
    try {
      final boundary = _cardKey.currentContext?.findRenderObject();
      if (boundary is RenderRepaintBoundary) {
        final bytes = await renderShareCard(boundary, palette);
        final dir = await bridge.sharedDir();
        if (dir.isNotEmpty) {
          final file = File('$dir${Platform.pathSeparator}'
              'Astryl-${widget.planet.id}.png');
          await file.writeAsBytes(bytes, flush: true);
          shared = await bridge.shareImage(file.path, l.shareText(name));
        }
      }
    } on Exception {
      shared = false;
    }
    if (!mounted) {
      return;
    }
    setState(() => _sharing = false);
    if (!shared) {
      messenger.showSnackBar(SnackBar(content: Text(l.shareFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final planet = widget.planet;
    final l = context.l10n;
    final p = Palette.of(context);
    final t = PlanetText(context);
    final earth = planetById('earth');
    final moons = moonsOf(planet.id);
    final parentName = planet.isMoon
        ? planetName(l, planetById(planet.parentId ?? 'earth'))
        : '';

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FavoriteButton(favoriteKey: widget.planet.id),
          IconButton(
            tooltip: l.share,
            onPressed: _sharing ? null : _share,
            icon: _sharing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: <Widget>[
          RepaintBoundary(
            key: _cardKey,
            child: ColoredBox(
              color: p.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
          const SizedBox(height: 4),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // A soft glow in the planet's own colour.
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: planet.color.withValues(alpha: 0.42),
                        blurRadius: 60,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const SizedBox.square(dimension: 120),
                ),
                Hero(
                  tag: 'planet-hero-${planet.id}',
                  child: PlanetBall(planet: planet, size: 160),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            planetName(l, planet),
            textAlign: TextAlign.center,
            style: headingStyle(38, p.text, height: 1.1),
          ),
          const SizedBox(height: 4),
          Text(bodySubtitle(l, planet),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: p.muted)),
          if (!planet.isStar) ...<Widget>[
            const SizedBox(height: 12),
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: p.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: p.accent.withValues(alpha: 0.5)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: Text(
                    '${l.lifeScoreShort} '
                    '${formatNumber(context, lifeScore(planet).total)} / '
                    '${formatNumber(context, LifeScore.maxTotal)}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: p.accentText),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          StatPanel(
            tiles: <BigStat>[
              BigStat(
                  icon: Icons.straighten,
                  label: l.diameter,
                  value: t.diameter(planet)),
              BigStat(
                  icon: Icons.vertical_align_bottom,
                  label: l.gravity,
                  value: t.gravity(planet)),
              BigStat(
                  icon: Icons.thermostat,
                  label: l.avgTemp,
                  value: t.temperature(planet)),
              if (!planet.isMoon && !planet.isStar)
                BigStat(
                    icon: Icons.brightness_2_outlined,
                    label: l.moons,
                    value: t.moons(planet)),
              BigStat(
                  icon: Icons.wb_sunny_outlined,
                  label: l.dayLength,
                  value: t.day(planet)),
              if (planet.isMoon)
                BigStat(
                    icon: Icons.autorenew,
                    label: l.orbitPeriod,
                    value: t.year(planet))
              else if (!planet.isStar)
                BigStat(
                    icon: Icons.autorenew,
                    label: l.yearLength,
                    value: t.year(planet)),
              if (planet.isMoon)
                BigStat(
                  icon: Icons.swap_horiz,
                  label: l.distanceFrom(parentName),
                  value: t.parentDistance(planet),
                )
              else if (!planet.isStar)
                BigStat(
                    icon: Icons.swap_horiz,
                    label: l.distance,
                    value: t.distance(planet)),
              BigStat(
                  icon: Icons.speed,
                  label: l.pressure,
                  value: t.pressure(planet)),
            ],
          ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          FactCard.of(planet.id, key: ValueKey<String>('fact-${planet.id}')),
          if (SurfaceMapScreen.isAvailable(planet.id)) ...<Widget>[
            const SizedBox(height: 14),
            _SurfaceMapTile(planet: planet),
          ],
          const SizedBox(height: 16),
          _InteriorCutawayCard(planet: planet),
          if (moons.isNotEmpty) ...<Widget>[
            const SizedBox(height: 24),
            Text(l.majorMoons,
                style: TextStyle(fontFamily: headingFont, fontSize: 18, fontWeight: FontWeight.w700, color: p.text)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final moon in moons)
                  ActionChip(
                    avatar: PlanetBall(planet: moon, size: 18),
                    label: Text(planetName(l, moon)),
                    labelStyle:
                        TextStyle(color: p.text, fontWeight: FontWeight.w600),
                    backgroundColor: p.surface,
                    side: BorderSide(color: p.border),
                    shape: const StadiumBorder(),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => PlanetScreen(planet: moon)),
                    ),
                  ),
              ],
            ),
            if (planet.id == 'jupiter' || planet.id == 'saturn') ...<Widget>[
              const SizedBox(height: 14),
              _MoonOrbitCard(planet: planet, moons: moons),
            ],
          ],
          const SizedBox(height: 24),
          Text(planet.isStar ? l.composition : l.atmosphere,
              style: TextStyle(fontFamily: headingFont, fontSize: 18, fontWeight: FontWeight.w700, color: p.text)),
          const SizedBox(height: 12),
          if (planet.atmosphere.isEmpty)
            Text(l.noAtmosphere,
                style: TextStyle(fontSize: 14, color: p.muted, height: 1.4))
          else
            AtmosphereBar(
              planet: planet,
              labelFor: (share) =>
                  '${gasName(l, share.gas)} (${share.gas.formula}) '
                  '${formatPercent(context, share.percent)}',
            ),
          if (planet.thinAtmosphere && planet.atmosphere.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Text(l.thinAtmosphere,
                style: TextStyle(fontSize: 13, color: p.muted, height: 1.4)),
          ],
          const SizedBox(height: 16),
          _LifeCard(planet: planet),
          if (planet.id != 'earth') ...<Widget>[
            const SizedBox(height: 12),
            _TravelCard(planet: planet),
          ],
          const SizedBox(height: 16),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(l.oxygenVsEarth,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: p.text)),
                if (!planet.thinAtmosphere) ...<Widget>[
                  const SizedBox(height: 12),
                  _OxygenRow(
                    label: planetName(l, planet),
                    percent: planet.oxygenPercent,
                    text: t.oxygen(planet),
                  ),
                  if (planet.id != 'earth') ...<Widget>[
                    const SizedBox(height: 8),
                    _OxygenRow(
                      label: planetName(l, earth),
                      percent: earth.oxygenPercent,
                      text: t.oxygen(earth),
                    ),
                  ],
                ],
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Icon(planet.breathable ? Icons.check : Icons.close,
                        size: 18, color: planet.breathable ? p.good : p.bad),
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
          ),
          const SizedBox(height: 12),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(l.weightFeelsLike(formatNumber(context, 70)),
                          style: TextStyle(fontSize: 14, color: p.muted)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${formatNumber(context, planet.weightFor(70), decimals: 1)} kg',
                      style: TextStyle(fontFamily: headingFont, fontSize: 20, fontWeight: FontWeight.w700,
                        color: p.accentText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          l.jumpFeelsLike(jumpText(context, l, _earthJumpCm)),
                          style: TextStyle(fontSize: 14, color: p.muted)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      jumpText(context, l,
                          jumpHeightCm(_earthJumpCm, planet.relativeGravity)),
                      style: TextStyle(fontFamily: headingFont, fontSize: 20, fontWeight: FontWeight.w700,
                        color: p.accentText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(l.dataSource,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: p.muted)),
        ],
      ),
    );
  }
}

class _OxygenRow extends StatelessWidget {
  const _OxygenRow({
    required this.label,
    required this.percent,
    required this.text,
  });

  final String label;
  final double percent;
  final String text;

  /// Bars are scaled so Earth's 20.95% fills the track.
  static const double _full = 20.95;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final fraction = (percent / _full).clamp(0.0, 1.0).toDouble();
    return Row(
      children: <Widget>[
        SizedBox(
          width: 72,
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: p.muted)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 10,
              color: p.background,
              alignment: AlignmentDirectional.centerStart,
              child: AnimatedProgress(
                target:
                    percent > 0 ? fraction.clamp(0.02, 1.0).toDouble() : 0.0,
                builder: (context, val) => FractionallySizedBox(
                  widthFactor: val,
                  child: Container(color: Gas.o2.color),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(text,
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: p.text)),
        ),
      ],
    );
  }
}

/// "Could humans live here?" with a 0 to 10 score and the reason for it.
class _LifeCard extends StatelessWidget {
  const _LifeCard({required this.planet});

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final t = PlanetText(context);
    final score = lifeScore(planet);
    final total = score.total;
    final color = total >= 8 ? p.good : (total >= 3 ? p.accentText : p.bad);

    String label(LifeFactor f) {
      switch (f) {
        case LifeFactor.temperature:
          return l.avgTemp;
        case LifeFactor.pressure:
          return l.pressure;
        case LifeFactor.oxygen:
          return l.oxygen;
        case LifeFactor.water:
          return l.water;
        case LifeFactor.surface:
          return l.surface;
        case LifeFactor.gravity:
          return l.gravity;
      }
    }

    String value(LifeFactor f) {
      switch (f) {
        case LifeFactor.temperature:
          return t.temperature(planet);
        case LifeFactor.pressure:
          return t.pressure(planet);
        case LifeFactor.oxygen:
          return planet.thinAtmosphere
              ? formatPercent(context, 0)
              : t.oxygen(planet);
        case LifeFactor.water:
          return waterName(l, planet.water);
        case LifeFactor.surface:
          return planet.hasSurface ? l.solidSurface : l.noSurface;
        case LifeFactor.gravity:
          return t.relativeGravity(planet);
      }
    }

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(l.lifeTitle,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: p.text)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${formatNumber(context, total)}/${formatNumber(context, LifeScore.maxTotal)}',
                style: TextStyle(fontFamily: headingFont, fontSize: 34, fontWeight: FontWeight.w700, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(lifeVerdict(l, total),
                    style: TextStyle(
                        fontSize: 14, color: p.text, height: 1.3)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: AnimatedProgress(
              target: total / LifeScore.maxTotal,
              builder: (context, val) => LinearProgressIndicator(
                value: val,
                minHeight: 8,
                color: color,
                backgroundColor: p.background,
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final f in score.factors)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: <Widget>[
                  Icon(
                    f.full
                        ? Icons.check_circle
                        : (f.none ? Icons.cancel : Icons.remove_circle),
                    size: 18,
                    color: f.full ? p.good : (f.none ? p.bad : p.accentText),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(label(f.factor),
                        style: TextStyle(fontSize: 13, color: p.muted)),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(value(f.factor),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: p.text)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          Text(l.lifeNote,
              style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
        ],
      ),
    );
  }
}

/// How far the body is from Earth today and how long it would take to get
/// there. Worked out from the orbits on the phone.
class _TravelCard extends StatelessWidget {
  const _TravelCard({required this.planet});

  final Planet planet;

  /// Average Earth to Moon distance in km.
  static const double _moonKm = 384400;

  /// Speed of light in km per second.
  static const double _lightKmS = 299792.458;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final t = PlanetText(context);
    final double km;
    if (planet.id == 'moon') {
      km = _moonKm;
    } else {
      final id = planet.isMoon ? (planet.parentId ?? 'earth') : planet.id;
      km = id == 'sun' || hasOrbit(id)
          ? distanceFromEarthKm(id, DateTime.now())
          : 0;
    }
    if (km <= 0) {
      return const SizedBox.shrink();
    }

    Widget row(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 20, color: p.muted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: TextStyle(fontSize: 13, color: p.muted)),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: p.text)),
            ),
          ],
        ),
      );
    }

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(l.travelTitle,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: p.text)),
          const SizedBox(height: 8),
          row(Icons.straighten, l.distanceFromEarth, t.kilometres(km)),
          row(Icons.flare, l.lightTime, t.duration(km / _lightKmS)),
          row(Icons.rocket_launch_outlined, l.bySpacecraft,
              t.duration(km / 60000 * 3600)),
          row(Icons.directions_car_outlined, l.byCar,
              t.duration(km / 100 * 3600)),
        ],
      ),
    );
  }
}

/// A card that opens the surface map of the Moon or Mars.
class _SurfaceMapTile extends StatelessWidget {
  const _SurfaceMapTile({required this.planet});

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (_) => SurfaceMapScreen(planet: planet)),
      ),
      child: SurfaceCard(
        child: Row(
          children: <Widget>[
            Icon(Icons.map_outlined, size: 28, color: p.accentText),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l.surfaceMapTitle,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: p.text)),
                  const SizedBox(height: 2),
                  Text(
                      planet.id == 'moon'
                          ? l.surfaceMapMoonHint
                          : l.surfaceMapMarsHint,
                      style: TextStyle(
                          fontSize: 13, color: p.muted, height: 1.35)),
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

/// Live orbital diagram of the major moons of Jupiter (Io, Europa, Ganymede,
/// Callisto) or Saturn (Enceladus, Titan) at their real orbital angles.
class _MoonOrbitCard extends StatefulWidget {
  const _MoonOrbitCard({required this.planet, required this.moons});

  final Planet planet;
  final List<Planet> moons;

  @override
  State<_MoonOrbitCard> createState() => _MoonOrbitCardState();
}

class _MoonOrbitCardState extends State<_MoonOrbitCard>
    with SingleTickerProviderStateMixin {
  bool _playing = false;
  double _dayOffset = 0;
  Ticker? _ticker;
  Duration _last = Duration.zero;

  /// J2000.0 mean longitudes in degrees for the major moons.
  static const Map<String, double> _j2000Deg = <String, double>{
    'io': 106.077,
    'europa': 175.732,
    'ganymede': 120.558,
    'callisto': 84.444,
    'enceladus': 200.01,
    'titan': 186.59,
  };

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      if (!_playing) {
        _last = elapsed;
        return;
      }
      final dt = (elapsed - _last).inMicroseconds / 1e6;
      _last = elapsed;
      setState(() {
        // 1.2 days of moon orbit per real second when playing.
        _dayOffset += dt * 1.2;
      });
    });
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _playing = !_playing;
      if (_playing) {
        _last = Duration.zero;
        _ticker?.start();
      } else {
        _ticker?.stop();
      }
    });
  }

  static double _moonAngleRad(Planet moon, DateTime at) {
    final j2000 = DateTime.utc(2000, 1, 1, 12);
    final days = at.toUtc().difference(j2000).inMinutes / 1440.0;
    final l0 = _j2000Deg[moon.id] ?? 0.0;
    final period = moon.yearDays > 0 ? moon.yearDays : 1.0;
    final deg = (l0 + (days / period) * 360.0) % 360.0;
    return -deg * math.pi / 180.0;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    final sorted = List<Planet>.of(widget.moons)
      ..sort((a, b) => a.distanceMillionKm.compareTo(b.distanceMillionKm));
    final current = DateTime.now()
        .toUtc()
        .add(Duration(minutes: (_dayOffset * 1440).round()));

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.track_changes_outlined,
                  size: 20, color: p.accentText),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isHi
                      ? '${planetName(l, widget.planet)} के चंद्रमाओं की लाइव कक्षा'
                      : '${planetName(l, widget.planet)} moons · Live orbits',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: p.text,
                  ),
                ),
              ),
              if (_dayOffset != 0)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _playing = false;
                      _dayOffset = 0;
                      _ticker?.stop();
                    });
                  },
                  child: Text(isHi ? 'अभी (Now)' : 'Now'),
                ),
              IconButton(
                icon: Icon(
                  _playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: p.accentText,
                  size: 28,
                ),
                tooltip: _playing ? 'Pause' : 'Play',
                onPressed: _togglePlay,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 210,
            width: double.infinity,
            child: CustomPaint(
              painter: _MoonOrbitPainter(
                planet: widget.planet,
                moons: sorted,
                angles: <double>[
                  for (final m in sorted) _moonAngleRad(m, current),
                ],
                names: <String>[
                  for (final m in sorted) planetName(l, m),
                ],
                palette: p,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isHi
                ? 'वास्तविक कक्षीय अवधि (JPL डेटा) के अनुसार चंद्रमाओं की दिशा। Play दबाकर उन्हें घूमते हुए देखें।'
                : 'Positions calculated from each moon\'s orbital period. Tap Play to watch them orbit.',
            style: TextStyle(fontSize: 12, color: p.muted, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _MoonOrbitPainter extends CustomPainter {
  _MoonOrbitPainter({
    required this.planet,
    required this.moons,
    required this.angles,
    required this.names,
    required this.palette,
  });

  final Planet planet;
  final List<Planet> moons;
  final List<double> angles;
  final List<String> names;
  final Palette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = math.min(size.width, size.height) / 2 - 18;
    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = palette.orbitLine;

    // Draw central planet
    canvas.drawCircle(
      center,
      14,
      Paint()..color = planet.color.withValues(alpha: 0.25),
    );
    paintPlanetBall(canvas, planet, center, 10);

    for (var i = 0; i < moons.length; i++) {
      final moon = moons[i];
      final r = maxR * (0.34 + 0.66 * (i / math.max(1, moons.length - 1)));
      canvas.drawCircle(center, r, orbitPaint);
      final a = angles[i];
      final pos = center + Offset(math.cos(a) * r, math.sin(a) * r);
      paintPlanetBall(canvas, moon, pos, 5.5);

      final tp = TextPainter(
        text: TextSpan(
          text: names[i],
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: palette.text,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final labelOffset = pos + const Offset(8, -6);
      tp.paint(canvas, labelOffset);
    }
  }

  @override
  bool shouldRepaint(covariant _MoonOrbitPainter oldDelegate) => true;
}

class _LayerSpec {
  const _LayerSpec({
    required this.fraction,
    required this.color,
    required this.titleEn,
    required this.titleHi,
    required this.descEn,
    required this.descHi,
  });

  final double fraction;
  final Color color;
  final String titleEn;
  final String titleHi;
  final String descEn;
  final String descHi;
}

List<_LayerSpec> _layersFor(Planet planet) {
  if (planet.isStar) {
    return const <_LayerSpec>[
      _LayerSpec(
        fraction: 1.0,
        color: Color(0xFFFF9800),
        titleEn: 'Convective Zone',
        titleHi: 'संवहन क्षेत्र (Convective Zone)',
        descEn: 'Boiling plasma currents carrying heat to the visible photosphere (~5,500 °C).',
        descHi: 'उबलते प्लाज़्मा की धाराएँ जो सतह (5,500 °C) तक गर्मी लाती हैं।',
      ),
      _LayerSpec(
        fraction: 0.70,
        color: Color(0xFFFFC107),
        titleEn: 'Radiative Zone',
        titleHi: 'विकिरण क्षेत्र (Radiative Zone)',
        descEn: 'Dense layer where photons bounce for thousands of years (~2–7 million °C).',
        descHi: 'घनी परत जहाँ प्रकाश कणों को बाहर निकलने में हज़ारों साल लगते हैं।',
      ),
      _LayerSpec(
        fraction: 0.28,
        color: Color(0xFFFFF59D),
        titleEn: 'Thermonuclear Core',
        titleHi: 'केंद्र (Thermonuclear Core)',
        descEn: 'Fuses hydrogen into helium at ~15 million °C and 250 billion bar.',
        descHi: '~1.5 करोड़ °C तापमान पर हाइड्रोजन से हीलियम बनता है।',
      ),
    ];
  }
  if (!planet.hasSurface) {
    final isIceGiant = planet.style == SurfaceStyle.ice;
    return <_LayerSpec>[
      _LayerSpec(
        fraction: 1.0,
        color: planet.color,
        titleEn: 'Molecular Hydrogen & Helium Envelope',
        titleHi: 'हाइड्रोजन और हीलियम बादल परत',
        descEn: 'Thick outer gas bands and high-speed jet streams.',
        descHi: 'बाहरी गैस के घने बादल और तेज़ तूफ़ानी हवाएँ।',
      ),
      _LayerSpec(
        fraction: 0.72,
        color: isIceGiant ? const Color(0xFF26A69A) : const Color(0xFFD48846),
        titleEn: isIceGiant
            ? 'Ionic Slush Mantle (Water, Ammonia, Methane)'
            : 'Liquid Metallic Hydrogen Mantle',
        titleHi: isIceGiant
            ? 'बर्फ़ और अमोनिया का मेंटल (Icy Mantle)'
            : 'तरल धात्विक हाइड्रोजन (Metallic Hydrogen)',
        descEn: isIceGiant
            ? 'Hot, electrically conductive fluid ocean under extreme pressure.'
            : 'Hydrogen squeezed so hard it conducts electricity and powers the magnetic field.',
        descHi: isIceGiant
            ? 'अत्यधिक दबाव में गर्म पानी, अमोनिया और मीथेन का महासागर।'
            : 'इतने भारी दबाव में हाइड्रोजन धातु की तरह बिजली प्रवाहित करती है।',
      ),
      const _LayerSpec(
        fraction: 0.25,
        color: Color(0xFF90A4AE),
        titleEn: 'Dense Rock & Ice Core',
        titleHi: 'ठोस चट्टान और धातु का केंद्र (Core)',
        descEn: 'Heavy central core up to ~20,000 °C and millions of bars.',
        descHi: '~20,000 °C तापमान वाला भारी केंद्रीय भाग।',
      ),
    ];
  }
  if (planet.water == Water.ocean && planet.isMoon) {
    return <_LayerSpec>[
      _LayerSpec(
        fraction: 1.0,
        color: planet.color,
        titleEn: 'Icy Crust',
        titleHi: 'बर्फ़ की बाहरी परत (Icy Crust)',
        descEn: 'Frozen surface shell crisscrossed by ridges and fractures.',
        descHi: 'दरारों से भरी जमी हुई बर्फ़ की मोटी बाहरी परत।',
      ),
      const _LayerSpec(
        fraction: 0.84,
        color: Color(0xFF1E88E5),
        titleEn: 'Subsurface Liquid Ocean',
        titleHi: 'भूमिगत तरल महासागर (Subsurface Ocean)',
        descEn: 'Global salty liquid water ocean kept warm by tidal flexing.',
        descHi: 'बर्फ़ के नीचे छिपा खारे पानी का विशाल महासागर।',
      ),
      const _LayerSpec(
        fraction: 0.56,
        color: Color(0xFF8D6E63),
        titleEn: 'Rocky Silicate Mantle',
        titleHi: 'चट्टानी मेंटल (Rocky Mantle)',
        descEn: 'Silicate rock layer surrounding the centre.',
        descHi: 'महासागर के नीचे चट्टानी परत।',
      ),
      const _LayerSpec(
        fraction: 0.28,
        color: Color(0xFFFFB74D),
        titleEn: 'Metallic Core',
        titleHi: 'धातु का केंद्र (Metallic Core)',
        descEn: 'Iron-nickel core at the heart of the moon.',
        descHi: 'लोहे और निकल से बना केंद्रीय भाग।',
      ),
    ];
  }
  return <_LayerSpec>[
    _LayerSpec(
      fraction: 1.0,
      color: planet.color,
      titleEn: 'Crust',
      titleHi: 'भूपर्पटी (Crust)',
      descEn: 'Outermost solid rock shell with craters, valleys and mountains.',
      descHi: 'सबसे बाहरी ठोस चट्टानी परत जिस पर पहाड़ और गड्ढे हैं।',
    ),
    const _LayerSpec(
      fraction: 0.88,
      color: Color(0xFFD84315),
      titleEn: 'Silicate Mantle',
      titleHi: 'मेंटल (Silicate Mantle)',
      descEn: 'Thick layer of hot silicate rock beneath the crust.',
      descHi: 'भूपर्पटी के नीचे गर्म चट्टानों की मोटी परत।',
    ),
    const _LayerSpec(
      fraction: 0.52,
      color: Color(0xFFFF8F00),
      titleEn: 'Outer Core',
      titleHi: 'बाहरी कोर (Outer Core)',
      descEn: 'Molten iron-nickel layer that generates magnetic fields.',
      descHi: 'पिघले हुए लोहे और निकल की परत।',
    ),
    const _LayerSpec(
      fraction: 0.25,
      color: Color(0xFFFFF176),
      titleEn: 'Inner Core',
      titleHi: 'आंतरिक कोर (Inner Core)',
      descEn: 'Solid, ultra-dense iron-nickel centre (~5,000 °C on Earth).',
      descHi: 'अत्यधिक दबाव में ठोस लोहे का सबसे भीतरी केंद्र।',
    ),
  ];
}

class _InteriorCutawayCard extends StatefulWidget {
  const _InteriorCutawayCard({required this.planet});

  final Planet planet;

  @override
  State<_InteriorCutawayCard> createState() => _InteriorCutawayCardState();
}

class _InteriorCutawayCardState extends State<_InteriorCutawayCard> {
  int _selected = 0;

  @override
  void didUpdateWidget(_InteriorCutawayCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.planet.id != widget.planet.id) {
      _selected = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    final layers = _layersFor(widget.planet);
    final idx = _selected.clamp(0, layers.length - 1);
    final active = layers[idx];

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.layers_outlined, size: 20, color: p.accentText),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isHi
                      ? 'आंतरिक संरचना (Interior Cutaway)'
                      : 'Inside ${planetName(context.l10n, widget.planet)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: p.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              GestureDetector(
                onTapUp: (details) {
                  const box = 136.0;
                  final center = const Offset(box / 2, box / 2);
                  final dist = (details.localPosition - center).distance /
                      (box / 2 - 6);
                  for (var i = layers.length - 1; i >= 0; i--) {
                    if (dist <= layers[i].fraction) {
                      setState(() => _selected = i);
                      break;
                    }
                  }
                },
                child: SizedBox(
                  width: 136,
                  height: 136,
                  child: CustomPaint(
                    painter: _CutawayPainter(
                      layers: layers,
                      selectedIndex: idx,
                      borderColor: p.text,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isHi ? active.titleHi : active.titleEn,
                      style: TextStyle(
                        fontFamily: headingFont,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: p.accentText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isHi ? active.descHi : active.descEn,
                      style: TextStyle(
                        fontSize: 13,
                        color: p.text,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              for (var i = 0; i < layers.length; i++)
                ChoiceChip(
                  label: Text(
                    isHi ? layers[i].titleHi : layers[i].titleEn,
                    style: const TextStyle(fontSize: 12),
                  ),
                  selected: i == idx,
                  onSelected: (_) => setState(() => _selected = i),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CutawayPainter extends CustomPainter {
  _CutawayPainter({
    required this.layers,
    required this.selectedIndex,
    required this.borderColor,
  });

  final List<_LayerSpec> layers;
  final int selectedIndex;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = math.min(size.width, size.height) / 2 - 6;

    for (var i = 0; i < layers.length; i++) {
      final layer = layers[i];
      final r = maxR * layer.fraction;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = layer.color;
      canvas.drawCircle(center, r, paint);
      if (i == selectedIndex) {
        canvas.drawCircle(
          center,
          r,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.2
            ..color = borderColor,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CutawayPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex ||
      oldDelegate.layers != layers;
}
