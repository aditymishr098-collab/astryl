import 'package:flutter/material.dart';

import '../core/birthday.dart';
import '../core/format.dart';
import '../core/sky.dart';
import '../data/cities.dart';
import '../l10n/event_text.dart';
import '../l10n/gen/app_localizations.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/moon_view.dart';
import '../widgets/orbit_view.dart';

/// "My birthday sky": the Moon phase and the planets on the day the user was
/// born, and round-number days of their life.
class BirthdayScreen extends StatelessWidget {
  const BirthdayScreen({super.key});

  Future<void> _pick(BuildContext context, DateTime? current) async {
    final state = AppScope.read(context);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      await state.setBirthDate(
          DateTime(picked.year, picked.month, picked.day, 12));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final loc = MaterialLocalizations.of(context);
    final state = AppScope.of(context);
    final now = DateTime.now();
    final saved = state.settings.birthDate;
    final DateTime? birth =
        saved != null && saved.isBefore(now) ? saved : null;
    final city = cityById(state.settings.cityId);

    final children = <Widget>[
      Text(l.birthdaySubtitle,
          style: TextStyle(fontSize: 14, color: p.muted, height: 1.4)),
      const SizedBox(height: 16),
      SurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            Icon(Icons.cake_outlined, color: p.accentText),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                birth != null
                    ? loc.formatFullDate(birth)
                    : l.birthdayNeedDate,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, color: p.text),
              ),
            ),
            TextButton(
              onPressed: () => _pick(context, birth),
              child: Text(birth != null ? l.changeBirthDate : l.setBirthDate),
            ),
          ],
        ),
      ),
    ];

    if (birth != null) {
      final moon = moonOnBirthday(birth);
      final today = DateTime(now.year, now.month, now.day);
      children
        ..add(const SizedBox(height: 16))
        ..add(SurfaceCard(
          child: Row(
            children: <Widget>[
              MoonView(
                age: moon.age,
                lit: moon.lit,
                size: 88,
                southern: city != null && city.lat < 0,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(l.birthdayMoon,
                        style: TextStyle(fontSize: 12, color: p.muted)),
                    const SizedBox(height: 2),
                    Text(_phaseName(l, phaseIndex(moon.age)),
                        style: TextStyle(fontFamily: headingFont, fontSize: 20, fontWeight: FontWeight.w700,
                            color: p.text)),
                    const SizedBox(height: 4),
                    Text(
                      l.illuminated(
                          formatNumber(context, (moon.lit * 100).round())),
                      style: TextStyle(fontSize: 14, color: p.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ))
        ..add(const SizedBox(height: 16))
        ..add(SectionLabel(l.birthdayPlanets))
        ..add(SurfaceCard(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 320,
            child: OrbitView(
              date: DateTime(birth.year, birth.month, birth.day, 12),
              selectedId: 'earth',
              onPlanetTap: (_) {},
              nameOf: (planet) => planetName(l, planet),
            ),
          ),
        ))
        ..add(const SizedBox(height: 16))
        ..add(SurfaceCard(
          child: Row(
            children: <Widget>[
              Icon(Icons.hourglass_bottom, color: p.accentText),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.birthdayDaysOld(
                      formatNumber(context, daysOld(birth, now))),
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, color: p.text),
                ),
              ),
            ],
          ),
        ))
        ..add(const SizedBox(height: 16))
        ..add(SectionLabel(l.birthdayMilestones));
      for (final m in lifeMilestones(birth)) {
        final done = m.date.isBefore(today);
        final days = DateTime.utc(m.date.year, m.date.month, m.date.day)
            .difference(DateTime.utc(now.year, now.month, now.day))
            .inDays;
        children
          ..add(SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: <Widget>[
                Icon(done ? Icons.check_circle : Icons.flag_outlined,
                    color: done ? p.muted : p.accentText),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        m.days == null
                            ? l.birthdayBillion
                            : l.birthdayDayN(formatNumber(context, m.days!)),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: p.text),
                      ),
                      Text(loc.formatMediumDate(m.date),
                          style: TextStyle(fontSize: 13, color: p.muted)),
                    ],
                  ),
                ),
                Text(
                  done ? l.birthdayPassed : eventWhen(context, l, days),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: done ? p.muted : p.accentText),
                ),
              ],
            ),
          ))
          ..add(const SizedBox(height: 8));
      }
      children
        ..add(const SizedBox(height: 8))
        ..add(Text(l.birthdayNote,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: p.muted)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.birthdayTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: children,
      ),
    );
  }
}

String _phaseName(AppLocalizations l, int index) {
  switch (index) {
    case 0:
      return l.phaseNew;
    case 1:
      return l.phaseWaxingCrescent;
    case 2:
      return l.phaseFirstQuarter;
    case 3:
      return l.phaseWaxingGibbous;
    case 4:
      return l.phaseFull;
    case 5:
      return l.phaseWaningGibbous;
    case 6:
      return l.phaseLastQuarter;
    default:
      return l.phaseWaningCrescent;
  }
}
