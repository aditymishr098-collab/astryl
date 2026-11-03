import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/moon_calendar.dart';
import '../core/sky.dart';
import '../data/cities.dart';
import '../l10n/gen/app_localizations.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/moon_view.dart';

/// The first and last month the calendar can show.
final DateTime moonCalendarFirst = DateTime(1900, 1, 1);
final DateTime moonCalendarLast = DateTime(2049, 12, 31);

/// A month of Moon phases, with the dates of the four main phases below.
/// Tapping a day opens its details. If the person picks "see the sky on this
/// day", the screen closes and returns that date to the Sky tab.
class MoonCalendarScreen extends StatefulWidget {
  const MoonCalendarScreen({super.key, this.initial});

  /// The day whose month opens first. Today if null.
  final DateTime? initial;

  @override
  State<MoonCalendarScreen> createState() => _MoonCalendarScreenState();
}

class _MoonCalendarScreenState extends State<MoonCalendarScreen> {
  late int _year;
  late int _month;
  late List<MoonDay> _days;

  @override
  void initState() {
    super.initState();
    var start = widget.initial ?? DateTime.now();
    if (start.isBefore(moonCalendarFirst)) start = moonCalendarFirst;
    if (start.isAfter(moonCalendarLast)) start = moonCalendarLast;
    _year = start.year;
    _month = start.month;
    _days = moonMonth(_year, _month);
  }

  bool get _hasPrevious =>
      _year > moonCalendarFirst.year || _month > moonCalendarFirst.month;
  bool get _hasNext =>
      _year < moonCalendarLast.year || _month < moonCalendarLast.month;

  void _go(int delta) {
    final next = DateTime(_year, _month + delta, 1);
    setState(() {
      _year = next.year;
      _month = next.month;
      _days = moonMonth(_year, _month);
    });
  }

  String _time(DateTime? t) {
    if (t == null) {
      return '–';
    }
    return MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(t.toLocal()));
  }

  Future<void> _openDay(MoonDay day, City? city) async {
    final go = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _DaySheet(day: day, city: city, time: _time),
    );
    if (go == true && mounted) {
      Navigator.of(context).pop(day.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final loc = MaterialLocalizations.of(context);
    final city = cityById(AppScope.of(context).settings.cityId);
    final southern = city != null && city.lat < 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Weeks, starting on the first day of the week of the language.
    final firstIndex = loc.firstDayOfWeekIndex; // 0 = Sunday
    final lead = (DateTime(_year, _month, 1).weekday % 7 - firstIndex + 7) % 7;
    final cells = <MoonDay?>[
      for (var i = 0; i < lead; i++) null,
      ..._days,
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    final weekdays = <String>[
      for (var i = 0; i < 7; i++) loc.narrowWeekdays[(firstIndex + i) % 7],
    ];

    final events = <MoonDay>[
      for (final d in _days)
        if (d.event != null) d,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l.moonCalendar)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                tooltip: l.previousMonth,
                icon: const Icon(Icons.chevron_left),
                onPressed: _hasPrevious ? () => _go(-1) : null,
              ),
              Expanded(
                child: Text(
                  loc.formatMonthYear(DateTime(_year, _month)),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: headingFont, fontSize: 20, fontWeight: FontWeight.w700, color: p.text),
                ),
              ),
              IconButton(
                tooltip: l.nextMonth,
                icon: const Icon(Icons.chevron_right),
                onPressed: _hasNext ? () => _go(1) : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    for (final w in weekdays)
                      Expanded(
                        child: Center(
                          child: Text(w,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: p.muted)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                for (var row = 0; row < cells.length ~/ 7; row++)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (var col = 0; col < 7; col++)
                        Expanded(
                          child: cells[row * 7 + col] == null
                              ? const SizedBox.shrink()
                              : _DayCell(
                                  day: cells[row * 7 + col]!,
                                  isToday:
                                      cells[row * 7 + col]!.date == today,
                                  southern: southern,
                                  onTap: () =>
                                      _openDay(cells[row * 7 + col]!, city),
                                ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(l.keyMoonDates,
              style: TextStyle(fontFamily: headingFont, fontSize: 18, fontWeight: FontWeight.w700, color: p.text)),
          const SizedBox(height: 10),
          for (final d in events) ...<Widget>[
            _EventRow(day: d, southern: southern, time: _time),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          Text(l.moonCalendarNote,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: p.muted)),
        ],
      ),
    );
  }
}

/// A short description of a day, for screen readers.
String _dayLabel(BuildContext context, AppLocalizations l, MoonDay day) {
  final date = MaterialLocalizations.of(context).formatFullDate(day.date);
  final phase = moonPhaseName(l, phaseIndex(day.age));
  final lit = l.illuminated(formatNumber(context, (day.lit * 100).round()));
  return '$date, $phase, $lit';
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.southern,
    required this.onTap,
  });

  final MoonDay day;
  final bool isToday;
  final bool southern;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final key = day.event != null;
    return Semantics(
      button: true,
      label: _dayLabel(context, l, day),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isToday ? p.accent.withValues(alpha: 0.18) : null,
            borderRadius: BorderRadius.circular(12),
            border: key
                ? Border.all(color: p.accentText, width: 1.5)
                : (isToday ? Border.all(color: p.accent) : null),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                formatNumber(context, day.date.day),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: key || isToday ? FontWeight.w700 : FontWeight.w500,
                    color: key ? p.accentText : p.text),
              ),
              const SizedBox(height: 3),
              MoonView(
                  age: day.age, lit: day.lit, size: 26, southern: southern),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow(
      {required this.day, required this.southern, required this.time});

  final MoonDay day;
  final bool southern;
  final String Function(DateTime? t) time;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final e = day.event!;
    final when = e.time.toLocal();
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: <Widget>[
          MoonView(age: day.age, lit: day.lit, size: 36, southern: southern),
          const SizedBox(width: 14),
          Expanded(
            child: Text(moonPhaseName(l, e.nameIndex),
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: p.text)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(MaterialLocalizations.of(context).formatMediumDate(when),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: p.text)),
                Text(time(when),
                    style: TextStyle(fontSize: 13, color: p.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Details of one day: phase, how much is lit, moonrise and moonset, and a
/// button to see the whole sky for that day.
class _DaySheet extends StatelessWidget {
  const _DaySheet({required this.day, required this.city, required this.time});

  final MoonDay day;
  final City? city;
  final String Function(DateTime? t) time;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final c = city;
    final rs = c == null ? null : moonRiseSet(day.date, c.lat, c.lon);
    final e = day.event;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: MoonView(
                  age: day.age,
                  lit: day.lit,
                  size: 96,
                  southern: c != null && c.lat < 0),
            ),
            const SizedBox(height: 12),
            Text(
              MaterialLocalizations.of(context).formatFullDate(day.date),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: p.muted),
            ),
            const SizedBox(height: 4),
            Text(
              moonPhaseName(l, phaseIndex(day.age)),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: headingFont, fontSize: 22, fontWeight: FontWeight.w700, color: p.text),
            ),
            const SizedBox(height: 4),
            Text(
              l.illuminated(formatNumber(context, (day.lit * 100).round())),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: p.muted),
            ),
            const SizedBox(height: 12),
            if (e != null)
              InfoRow(
                  icon: Icons.schedule,
                  label: moonPhaseName(l, e.nameIndex),
                  value: time(e.time)),
            if (rs != null) ...<Widget>[
              InfoRow(
                  icon: Icons.north_east,
                  label: l.moonrise,
                  value: time(rs.rise)),
              InfoRow(
                  icon: Icons.south_east,
                  label: l.moonset,
                  value: time(rs.set)),
            ],
            if (c != null) ...<Widget>[
              const SizedBox(height: 12),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)),
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.nights_stay_outlined),
                label: Text(l.seeSkyThatDay),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
