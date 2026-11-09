import 'package:flutter/widgets.dart';

import '../core/eclipses.dart';
import '../core/events.dart';
import '../core/format.dart';
import '../data/cities.dart';
import '../data/planets.dart';
import '../state/app_state.dart';
import 'gen/app_localizations.dart';
import 'names.dart';

String _planet(AppLocalizations l, String id) => planetName(l, planetById(id));

String _showerName(AppLocalizations l, String id) {
  switch (id) {
    case 'quadrantids':
      return l.showerQuadrantids;
    case 'lyrids':
      return l.showerLyrids;
    case 'etaAquariids':
      return l.showerEtaAquariids;
    case 'perseids':
      return l.showerPerseids;
    case 'orionids':
      return l.showerOrionids;
    case 'leonids':
      return l.showerLeonids;
    case 'geminids':
      return l.showerGeminids;
    default:
      return l.showerUrsids;
  }
}

/// The name of an event, in the app's language.
String eventTitle(AppLocalizations l, SpaceEvent e) {
  switch (e.kind) {
    case SpaceEventKind.fullMoon:
      return l.eventFullMoon;
    case SpaceEventKind.newMoon:
      return l.eventNewMoon;
    case SpaceEventKind.opposition:
      return l.eventOpposition(_planet(l, e.bodies[0]));
    case SpaceEventKind.eveningElongation:
      return l.eventEveningElongation(_planet(l, e.bodies[0]));
    case SpaceEventKind.morningElongation:
      return l.eventMorningElongation(_planet(l, e.bodies[0]));
    case SpaceEventKind.conjunction:
      return l.eventConjunction(
          _planet(l, e.bodies[0]), _planet(l, e.bodies[1]));
    case SpaceEventKind.marchEquinox:
      return l.eventMarchEquinox;
    case SpaceEventKind.juneSolstice:
      return l.eventJuneSolstice;
    case SpaceEventKind.septemberEquinox:
      return l.eventSeptemberEquinox;
    case SpaceEventKind.decemberSolstice:
      return l.eventDecemberSolstice;
    case SpaceEventKind.meteorShower:
      return l.eventMeteorShower(_showerName(l, e.bodies[0]));
    case SpaceEventKind.lunarEclipse:
      switch (e.eclipse!.type) {
        case EclipseType.total:
          return l.eclipseTotalLunar;
        case EclipseType.penumbral:
          return l.eclipsePenumbralLunar;
        default:
          return l.eclipsePartialLunar;
      }
    case SpaceEventKind.solarEclipse:
      switch (e.eclipse!.type) {
        case EclipseType.total:
          return l.eclipseTotalSolar;
        case EclipseType.annular:
          return l.eclipseAnnularSolar;
        case EclipseType.hybrid:
          return l.eclipseHybridSolar;
        default:
          return l.eclipsePartialSolar;
      }
  }
}

/// One or two sentences about an event.
String eventDescription(BuildContext context, AppLocalizations l, SpaceEvent e) {
  switch (e.kind) {
    case SpaceEventKind.fullMoon:
      return l.eventFullMoonDesc;
    case SpaceEventKind.newMoon:
      return l.eventNewMoonDesc;
    case SpaceEventKind.opposition:
      return l.eventOppositionDesc(_planet(l, e.bodies[0]));
    case SpaceEventKind.eveningElongation:
      return l.eventEveningDesc(_planet(l, e.bodies[0]),
          formatNumber(context, e.value.round()));
    case SpaceEventKind.morningElongation:
      return l.eventMorningDesc(_planet(l, e.bodies[0]),
          formatNumber(context, e.value.round()));
    case SpaceEventKind.conjunction:
      return l.eventConjunctionDesc(
          formatNumber(context, e.value, decimals: 1));
    case SpaceEventKind.marchEquinox:
    case SpaceEventKind.septemberEquinox:
      return l.eventEquinoxDesc;
    case SpaceEventKind.juneSolstice:
      return l.eventJuneSolsticeDesc;
    case SpaceEventKind.decemberSolstice:
      return l.eventDecemberSolsticeDesc;
    case SpaceEventKind.meteorShower:
      return l.eventMeteorDesc(formatNumber(context, e.value.round()),
          formatNumber(context, (e.extra * 100).round()));
    case SpaceEventKind.lunarEclipse:
    case SpaceEventKind.solarEclipse:
      return _eclipseDescription(context, l, e.eclipse!);
  }
}

/// What the eclipse is, and a careful note on whether the chosen city can
/// see it. The note is a rough guide, so it says "roughly" and "check a map".
String _eclipseDescription(
    BuildContext context, AppLocalizations l, Eclipse eclipse) {
  final lines = <String>[];
  final city = cityById(AppScope.read(context).settings.cityId);
  if (eclipse.lunar) {
    switch (eclipse.type) {
      case EclipseType.total:
        lines.add(l.eclipseTotalLunarDesc);
      case EclipseType.penumbral:
        lines.add(l.eclipsePenumbralLunarDesc);
      default:
        lines.add(l.eclipsePartialLunarDesc(
            formatNumber(context, (eclipse.magnitude * 100).round())));
    }
    if (city == null) {
      lines.add(l.eclipseNoCity);
    } else {
      switch (lunarView(eclipse, city.lat, city.lon)) {
        case LunarView.up:
          lines.add(l.eclipseLunarUp(cityName(l, city)));
        case LunarView.partly:
          lines.add(l.eclipseLunarPartly(cityName(l, city)));
        case LunarView.down:
          lines.add(l.eclipseLunarDown(cityName(l, city)));
      }
    }
    return lines.join('\n');
  }
  switch (eclipse.type) {
    case EclipseType.total:
      lines.add(l.eclipseTotalSolarDesc);
    case EclipseType.annular:
      lines.add(l.eclipseAnnularSolarDesc);
    case EclipseType.hybrid:
      lines.add(l.eclipseHybridSolarDesc);
    default:
      lines.add(l.eclipsePartialSolarDesc);
  }
  if (city == null) {
    lines.add(l.eclipseNoCity);
  } else {
    final mag = solarLocalMagnitude(eclipse, city.lat, city.lon);
    if (mag == null || mag < 0.02) {
      lines.add(l.eclipseSolarNone(cityName(l, city)));
    } else if (mag < 0.12) {
      lines.add(l.eclipseSolarSlight(cityName(l, city)));
    } else if (mag < 0.9) {
      final percent = (mag * 10).round() * 10;
      lines.add(l.eclipseSolarPartial(
          cityName(l, city), formatNumber(context, percent)));
    } else {
      lines.add(l.eclipseSolarNear(cityName(l, city)));
    }
  }
  lines.add(l.eclipseSolarSafety);
  return lines.join('\n');
}

/// "Today", "Tomorrow" or "In 5 days".
String eventWhen(BuildContext context, AppLocalizations l, int days) {
  if (days <= 0) {
    return l.eventToday;
  }
  if (days == 1) {
    return l.eventTomorrow;
  }
  return l.eventInDays(formatNumber(context, days));
}
