import 'dart:async';
import 'dart:isolate';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/iss.dart';
import '../core/sgp4.dart';
import '../core/sky.dart';
import '../data/cities.dart';
import '../data/world_outline.dart';
import '../l10n/event_text.dart';
import '../l10n/gen/app_localizations.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../state/online_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/event_tile.dart';
import 'reminder_actions.dart';

/// The International Space Station: where it is right now on a map, and when
/// it flies over the chosen city.
class IssScreen extends StatefulWidget {
  const IssScreen({super.key, required this.city});

  final City city;

  @override
  State<IssScreen> createState() => _IssScreenState();
}

class _IssScreenState extends State<IssScreen> {
  Timer? _timer;
  OnlineState? _online;
  DateTime _now = DateTime.now();

  List<IssPass>? _passes;
  String _passesKey = '';

  List<({double lat, double lon})> _track = const <({double lat, double lon})>[];
  int _trackKey = -1;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _now = DateTime.now());
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      final state = AppScope.read(context);
      _online = state.online..addListener(_onOnlineChanged);
      if (state.settings.onlineFeatures) {
        await state.online.refreshIss();
      }
      _onOnlineChanged();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _online?.removeListener(_onOnlineChanged);
    super.dispose();
  }

  void _onOnlineChanged() {
    if (mounted) {
      _computePasses();
    }
  }

  Future<void> _computePasses() async {
    final state = AppScope.read(context);
    final sat = state.online.sat;
    if (sat == null) {
      return;
    }
    final lat = widget.city.lat;
    final lon = widget.city.lon;
    final today = DateTime.now();
    final key =
        '${sat.epoch.millisecondsSinceEpoch}|${widget.city.id}|${today.year}-${today.month}-${today.day}-${today.hour ~/ 6}';
    if (key == _passesKey) {
      return;
    }
    _passesKey = key;
    List<IssPass> passes;
    try {
      passes = await Isolate.run(() => findIssPasses(sat, today, lat, lon));
    } on Exception {
      passes = findIssPasses(sat, today, lat, lon);
    }
    if (!mounted) {
      return;
    }
    await state.pruneReminders(
        (id) => id.startsWith('iss:'), <String>{for (final p in passes) p.id});
    if (mounted) {
      setState(() => _passes = passes);
    }
  }

  Future<void> _togglePass(IssPass pass) {
    final l = context.l10n;
    final now = DateTime.now();
    final at = pass.rise.toLocal().subtract(const Duration(minutes: 10));
    final soon = now.add(const Duration(minutes: 1));
    return toggleReminder(
      context,
      id: pass.id,
      at: at.isAfter(soon) ? at : null,
      title: l.issPassTitle,
      body: l.issPassBody(
        formatNumber(context, pass.maxElevation.round()),
        directionName(l, compassIndex(pass.riseAzimuth)),
      ),
    );
  }

  Future<void> _turnOn() async {
    final state = AppScope.read(context);
    await state.setOnlineFeatures(true);
    await state.online.refreshIss(force: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final state = AppScope.of(context);
    final online = state.online;

    return ListenableBuilder(
      listenable: online,
      builder: (context, _) {
        final sat = online.sat;
        final canRefresh = state.settings.onlineFeatures;
        return Scaffold(
          appBar: AppBar(
            title: Text(l.issTitle,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            actions: <Widget>[
              if (canRefresh && sat != null)
                IconButton(
                  tooltip: l.tryAgain,
                  onPressed: online.loadingIss
                      ? null
                      : () => online.refreshIss(force: true),
                  icon: const Icon(Icons.refresh),
                ),
            ],
          ),
          body: sat == null
              ? _emptyState(context, l, p, online.loadingIss, online.issFailed,
                  canRefresh)
              : _content(context, l, p, sat),
        );
      },
    );
  }

  Widget _emptyState(BuildContext context, AppLocalizations l, Palette p, bool loading,
      bool failed, bool canRefresh) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.satellite_alt, size: 48, color: p.accentText),
              const SizedBox(height: 12),
              if (loading) ...<Widget>[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 12),
                Text(l.issLoading,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: p.text)),
              ] else if (failed && canRefresh) ...<Widget>[
                Text(l.issFailed,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: p.text, height: 1.4)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => AppScope.read(context)
                      .online
                      .refreshIss(force: true),
                  child: Text(l.tryAgain),
                ),
              ] else ...<Widget>[
                Text(l.issNeedsOnline,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: p.text, height: 1.4)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _turnOn,
                  child: Text(l.turnOnOnline),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _content(BuildContext context, AppLocalizations l, Palette p, Sgp4 sat) {
    final state = AppScope.of(context);
    final city = widget.city;
    final pos = issPosition(sat, _now);
    final loc = MaterialLocalizations.of(context);

    if (pos == null) {
      return _emptyState(context, l, p, false, true, state.settings.onlineFeatures);
    }

    // The ground track is worked out again every 30 seconds.
    final trackKey = _now.millisecondsSinceEpoch ~/ 30000;
    if (trackKey != _trackKey) {
      _trackKey = trackKey;
      _track = groundTrack(sat, _now);
    }

    final look = lookAngle(pos.ecef, city.lat, city.lon);
    final overhead = look.elevation > 0;
    final km = greatCircleKm(pos.lat, pos.lon, city.lat, city.lon);
    final ageDays = _now.difference(sat.epoch).inDays;

    String coord(double v, String positive, String negative) =>
        '${formatNumber(context, v.abs(), decimals: 1)}° ${v >= 0 ? positive : negative}';

    final passes = _passes;
    final children = <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 2,
          child: CustomPaint(
            painter: _MapPainter(
              pos: pos,
              track: _track,
              cityLat: city.lat,
              cityLon: city.lon,
              dark: Theme.of(context).brightness == Brightness.dark,
              palette: p,
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        overhead
            ? l.issAboveHorizon(
                directionName(l, compassIndex(look.azimuth)),
                formatNumber(context, look.elevation.round()),
              )
            : l.issBelowHorizon,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: overhead ? p.good : p.text,
        ),
      ),
      const SizedBox(height: 12),
      SurfaceCard(
        child: Column(
          children: <Widget>[
            _Line(
              icon: Icons.public,
              label: cityName(l, city),
              value: l.altitudeDir(
                directionName(l, compassIndex(look.azimuth)),
                formatNumber(context, look.elevation.round()),
              ),
            ),
            _Line(
              icon: Icons.place_outlined,
              label: l.issTitle,
              value:
                  '${coord(pos.lat, l.dirN, l.dirS)}, ${coord(pos.lon, l.dirE, l.dirW)}',
            ),
            _Line(
              icon: Icons.height,
              label: l.issHeight,
              value: l.valueKm(
                  formatNumber(context, pos.altitudeKm.round())),
            ),
            _Line(
              icon: Icons.speed,
              label: l.issSpeed,
              value: l.valueKmh(
                  formatNumber(context, pos.speedKmh.round())),
            ),
            _Line(
              icon: Icons.straighten,
              label: l.issFromYou,
              value: l.valueKm(formatNumber(context, km.round())),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Text(l.issPassesTitle(cityName(l, city)),
          style: TextStyle(fontFamily: headingFont, fontSize: 18, fontWeight: FontWeight.w700, color: p.text)),
      const SizedBox(height: 12),
    ];

    if (passes == null) {
      children.add(const Center(child: CircularProgressIndicator()));
    } else if (passes.isEmpty) {
      children.add(Text(l.issNoPasses,
          style: TextStyle(fontSize: 14, color: p.muted)));
    } else {
      for (final pass in passes) {
        final rise = pass.rise.toLocal();
        final day = DateTime(rise.year, rise.month, rise.day);
        final days = DateTime.utc(day.year, day.month, day.day)
            .difference(DateTime.utc(_now.year, _now.month, _now.day))
            .inDays;
        children
          ..add(EventTile(
            icon: Icon(Icons.satellite_alt, size: 28, color: p.orbit),
            title:
                '${loc.formatMediumDate(day)} · ${loc.formatTimeOfDay(TimeOfDay.fromDateTime(rise))}',
            when: eventWhen(context, l, days),
            description:
                '${l.issMaxHigh(formatNumber(context, pass.maxElevation.round()))} · ${l.valueMinutes(formatNumber(context, math.max(1, (pass.duration.inSeconds / 60).round())))}\n${l.issFromTo(directionName(l, compassIndex(pass.riseAzimuth)), directionName(l, compassIndex(pass.setAzimuth)))}',
            badge: (pass.visible ? l.issVisible : l.issHidden),
            badgeColor: pass.visible ? p.good : p.muted,
            reminderOn: state.hasReminder(pass.id),
            tooltip: l.remindMe,
            onToggle: () => _togglePass(pass),
          ))
          ..add(const SizedBox(height: 8));
      }
    }

    if (ageDays >= 3) {
      children
        ..add(const SizedBox(height: 8))
        ..add(Text(
          l.issStale(formatNumber(context, ageDays)),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: p.bad),
        ));
    }
    children
      ..add(const SizedBox(height: 12))
      ..add(Text(l.issNote,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: p.muted)));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: children,
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18, color: p.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(fontSize: 14, color: p.muted)),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, color: p.text)),
        ],
      ),
    );
  }
}

/// A flat world map with the station, its path and the chosen city.
class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.pos,
    required this.track,
    required this.cityLat,
    required this.cityLon,
    required this.dark,
    required this.palette,
  });

  final IssPosition pos;
  final List<({double lat, double lon})> track;
  final double cityLat;
  final double cityLon;
  final bool dark;
  final Palette palette;

  static final List<List<(double, double)>> _land = <List<(double, double)>>[
    for (final s in worldLand) parseOutline(s),
  ];
  static final List<List<(double, double)>> _water = <List<(double, double)>>[
    for (final s in worldWater) parseOutline(s),
  ];

  Offset _point(double lon, double lat, Size size) => Offset(
        (lon + 180) / 360 * size.width,
        (90 - lat) / 180 * size.height,
      );

  Path _shape(List<(double, double)> points, Size size) {
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final o = _point(points[i].$1, points[i].$2, size);
      if (i == 0) {
        path.moveTo(o.dx, o.dy);
      } else {
        path.lineTo(o.dx, o.dy);
      }
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final ocean = dark ? const Color(0xFF0B1630) : const Color(0xFFCFE3F5);
    final land = dark ? const Color(0xFF3A4C78) : const Color(0xFFF3EEE0);
    final grid = dark ? const Color(0x22FFFFFF) : const Color(0x22000000);
    canvas.drawRect(Offset.zero & size, Paint()..color = ocean);

    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var lon = -150; lon <= 150; lon += 30) {
      final x = (lon + 180) / 360 * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var lat = -60; lat <= 60; lat += 30) {
      final y = (90 - lat) / 180 * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final landPaint = Paint()..color = land;
    for (final shape in _land) {
      canvas.drawPath(_shape(shape, size), landPaint);
    }
    final waterPaint = Paint()..color = ocean;
    for (final shape in _water) {
      canvas.drawPath(_shape(shape, size), waterPaint);
    }

    // The area from which the station can be seen above the horizon.
    final footprint = Path();
    final lat1 = pos.lat * math.pi / 180;
    final lon1 = pos.lon * math.pi / 180;
    final delta = math.acos(6371 / (6371 + pos.altitudeKm));
    for (var b = 0; b <= 360; b += 10) {
      final bearing = b * math.pi / 180;
      final lat2 = math.asin(math.sin(lat1) * math.cos(delta) +
          math.cos(lat1) * math.sin(delta) * math.cos(bearing));
      final lon2 = lon1 +
          math.atan2(math.sin(bearing) * math.sin(delta) * math.cos(lat1),
              math.cos(delta) - math.sin(lat1) * math.sin(lat2));
      final o = _point(lon2 * 180 / math.pi, lat2 * 180 / math.pi, size);
      if (b == 0) {
        footprint.moveTo(o.dx, o.dy);
      } else {
        footprint.lineTo(o.dx, o.dy);
      }
    }
    footprint.close();
    final fill = Paint()..color = palette.accent.withValues(alpha: 0.16);
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = palette.accent.withValues(alpha: 0.8);
    for (final shift in <double>[-size.width, 0, size.width]) {
      canvas.save();
      canvas.translate(shift, 0);
      canvas.drawPath(footprint, fill);
      canvas.drawPath(footprint, edge);
      canvas.restore();
    }

    // Where the station was and will be.
    final past = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = palette.accent.withValues(alpha: 0.35);
    final future = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = palette.accent;
    const nowIndex = 45;
    for (var i = 1; i < track.length; i++) {
      final a = track[i - 1], b = track[i];
      if ((a.lon - b.lon).abs() > 180) {
        continue;
      }
      canvas.drawLine(_point(a.lon, a.lat, size), _point(b.lon, b.lat, size),
          i <= nowIndex ? past : future);
    }

    // The city.
    final city = _point(cityLon, cityLat, size);
    canvas.drawCircle(city, 5, Paint()..color = Colors.white);
    canvas.drawCircle(city, 3.2, Paint()..color = palette.orbit);

    // The station.
    final iss = _point(pos.lon, pos.lat, size);
    canvas.drawCircle(
        iss, 11, Paint()..color = palette.accent.withValues(alpha: 0.3));
    canvas.drawCircle(iss, 6.5, Paint()..color = Colors.white);
    canvas.drawCircle(iss, 4.5, Paint()..color = palette.accent);
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => true;
}
