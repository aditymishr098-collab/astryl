import 'dart:async';
import 'dart:isolate';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/iss.dart';
import '../core/sgp4.dart';
import '../core/sky.dart';
import '../data/cities.dart';
import '../data/online_service.dart';
import '../l10n/event_text.dart';
import '../l10n/gen/app_localizations.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../state/online_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/event_tile.dart';
import 'reminder_actions.dart';

/// The name of a tracked satellite in the language of the app.
String satelliteName(BuildContext context, String id) {
  final l = context.l10n;
  return id == 'hst' ? l.hubbleName : l.tiangongName;
}

/// Tiangong and the Hubble Space Telescope: where each one is now and when
/// it flies over the chosen city.
class SatellitesScreen extends StatefulWidget {
  const SatellitesScreen({super.key, required this.city});

  final City city;

  @override
  State<SatellitesScreen> createState() => _SatellitesScreenState();
}

class _SatellitesScreenState extends State<SatellitesScreen> {
  Timer? _timer;
  OnlineState? _online;
  DateTime _now = DateTime.now();
  String _selected = trackedSatellites.first.id;

  final Map<String, List<IssPass>> _passes = <String, List<IssPass>>{};
  final Map<String, String> _passKeys = <String, String>{};

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
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
        await Future.wait(<Future<void>>[
          for (final s in trackedSatellites)
            state.online.refreshSatellite(s.id),
        ]);
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
      _computePasses(_selected);
    }
  }

  Future<void> _computePasses(String id) async {
    final state = AppScope.read(context);
    final sat = state.online.satFor(id);
    if (sat == null) {
      return;
    }
    final lat = widget.city.lat;
    final lon = widget.city.lon;
    final today = DateTime.now();
    final key =
        '${sat.epoch.millisecondsSinceEpoch}|${widget.city.id}|${today.year}-${today.month}-${today.day}-${today.hour ~/ 6}';
    if (key == _passKeys[id]) {
      return;
    }
    _passKeys[id] = key;
    List<IssPass> passes;
    try {
      passes = await Isolate.run(
          () => findIssPasses(sat, today, lat, lon, satId: id));
    } on Exception {
      passes = findIssPasses(sat, today, lat, lon, satId: id);
    }
    if (!mounted) {
      return;
    }
    final valid = <String>{for (final p in passes) p.id};
    await state.pruneReminders(
        (r) => r.startsWith('sat:$id:'), valid);
    if (mounted) {
      setState(() => _passes[id] = passes);
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
      title: l.satPassTitle(satelliteName(context, pass.satId)),
      body: l.issPassBody(
        formatNumber(context, pass.maxElevation.round()),
        directionName(l, compassIndex(pass.riseAzimuth)),
      ),
    );
  }

  Future<void> _turnOn() async {
    final state = AppScope.read(context);
    await state.setOnlineFeatures(true);
    await Future.wait(<Future<void>>[
      for (final s in trackedSatellites)
        state.online.refreshSatellite(s.id, force: true),
    ]);
  }

  Future<void> _refresh() async {
    final online = AppScope.read(context).online;
    await online.refreshSatellite(_selected, force: true);
  }

  void _select(String id) {
    setState(() => _selected = id);
    _computePasses(id);
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
        final sat = online.satFor(_selected);
        final canRefresh = state.settings.onlineFeatures;
        return Scaffold(
          appBar: AppBar(
            title: Text(l.satellitesTitle),
            actions: <Widget>[
              if (canRefresh && sat != null)
                IconButton(
                  tooltip: l.tryAgain,
                  onPressed:
                      online.loadingSat(_selected) ? null : _refresh,
                  icon: const Icon(Icons.refresh),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: <Widget>[
              Wrap(
                spacing: 8,
                children: <Widget>[
                  for (final s in trackedSatellites)
                    ChoiceChip(
                      label: Text(satelliteName(context, s.id)),
                      selected: _selected == s.id,
                      onSelected: (_) => _select(s.id),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (sat == null)
                _emptyState(context, l, p, online, canRefresh)
              else
                ..._content(context, l, p, sat),
            ],
          ),
        );
      },
    );
  }

  Widget _emptyState(BuildContext context, AppLocalizations l, Palette p,
      OnlineState online, bool canRefresh) {
    final loading = online.loadingSat(_selected);
    final failed = online.satFailed(_selected);
    final name = satelliteName(context, _selected);
    return SurfaceCard(
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
                  .refreshSatellite(_selected, force: true),
              child: Text(l.tryAgain),
            ),
          ] else ...<Widget>[
            Text(l.satNeedsOnline(name),
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
    );
  }

  List<Widget> _content(
      BuildContext context, AppLocalizations l, Palette p, Sgp4 sat) {
    final state = AppScope.of(context);
    final city = widget.city;
    final pos = issPosition(sat, _now);
    final loc = MaterialLocalizations.of(context);
    if (pos == null) {
      return <Widget>[
        _emptyState(context, l, p, state.online, state.settings.onlineFeatures),
      ];
    }

    final look = lookAngle(pos.ecef, city.lat, city.lon);
    final overhead = look.elevation > 0;
    final km = greatCircleKm(pos.lat, pos.lon, city.lat, city.lon);
    final ageDays = _now.difference(sat.epoch).inDays;
    final passes = _passes[_selected];

    final children = <Widget>[
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
            InfoRow(
              icon: Icons.height,
              label: l.issHeight,
              value: l.valueKm(formatNumber(context, pos.altitudeKm.round())),
            ),
            InfoRow(
              icon: Icons.speed,
              label: l.issSpeed,
              value: l.valueKmh(formatNumber(context, pos.speedKmh.round())),
            ),
            InfoRow(
              icon: Icons.straighten,
              label: l.issFromYou,
              value: l.valueKm(formatNumber(context, km.round())),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Text(l.issPassesTitle(city.name),
          style: headingStyle(18, p.text)),
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
      ..add(Text(l.satNote,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: p.muted)));
    return children;
  }
}
