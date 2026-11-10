import 'package:flutter/widgets.dart';

import '../core/format.dart';
import '../core/quiz.dart';
import '../data/cities.dart';
import '../data/planets.dart';
import '../data/surface_sites.dart';
import 'gen/app_localizations.dart';

/// The app languages, shown in their own script in the picker.
const List<(String, String)> appLanguages = <(String, String)>[
  ('en', 'English'),
  ('hi', 'हिन्दी'),
];

/// Native name of a language code, or the code itself.
String languageName(String code) {
  for (final (c, name) in appLanguages) {
    if (c == code) {
      return name;
    }
  }
  return code;
}

extension HelioraL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

String planetName(AppLocalizations l, Planet planet) {
  switch (planet.id) {
    case 'mercury':
      return l.planetMercury;
    case 'venus':
      return l.planetVenus;
    case 'earth':
      return l.planetEarth;
    case 'mars':
      return l.planetMars;
    case 'jupiter':
      return l.planetJupiter;
    case 'saturn':
      return l.planetSaturn;
    case 'uranus':
      return l.planetUranus;
    case 'neptune':
      return l.planetNeptune;
    case 'sun':
      return l.bodySun;
    case 'moon':
      return l.bodyMoon;
    case 'pluto':
      return l.bodyPluto;
    case 'io':
      return l.moonIo;
    case 'europa':
      return l.moonEuropa;
    case 'ganymede':
      return l.moonGanymede;
    case 'callisto':
      return l.moonCallisto;
    case 'titan':
      return l.moonTitan;
    case 'enceladus':
      return l.moonEnceladus;
    case 'triton':
      return l.moonTriton;
  }
  return planet.id;
}

/// One line under a body's name: "Planet 3 from the Sun", "Moon of Jupiter".
String bodySubtitle(AppLocalizations l, Planet body) {
  switch (body.kind) {
    case BodyKind.star:
      return l.kindStar;
    case BodyKind.dwarf:
      return l.kindDwarf;
    case BodyKind.moon:
      return l.moonOf(planetName(l, planetById(body.parentId ?? 'earth')));
    case BodyKind.planet:
      return l.planetOrder(body.order);
  }
}

String waterName(AppLocalizations l, Water water) {
  switch (water) {
    case Water.liquid:
      return l.waterLiquid;
    case Water.ice:
      return l.waterIce;
    case Water.ocean:
      return l.waterOcean;
    case Water.none:
      return l.waterNone;
  }
}

/// A short verdict for a life score from 0 to 10.
String lifeVerdict(AppLocalizations l, int score) {
  if (score >= 8) {
    return l.lifeHome;
  }
  if (score >= 3) {
    return l.lifeHard;
  }
  return l.lifeNo;
}

String gasName(AppLocalizations l, Gas gas) {
  switch (gas) {
    case Gas.co2:
      return l.gasCo2;
    case Gas.n2:
      return l.gasN2;
    case Gas.o2:
      return l.gasO2;
    case Gas.ar:
      return l.gasAr;
    case Gas.h2:
    case Gas.h:
      return l.gasH2;
    case Gas.he:
      return l.gasHe;
    case Gas.ch4:
      return l.gasCh4;
    case Gas.na:
      return l.gasNa;
    case Gas.k:
      return l.gasK;
  }
}

String quizQuestionText(AppLocalizations l, QuizKind kind) {
  switch (kind) {
    case QuizKind.largest:
      return l.qLargest;
    case QuizKind.smallest:
      return l.qSmallest;
    case QuizKind.hottest:
      return l.qHottest;
    case QuizKind.coldest:
      return l.qColdest;
    case QuizKind.mostMoons:
      return l.qMostMoons;
    case QuizKind.breathable:
      return l.qBreathable;
    case QuizKind.closest:
      return l.qClosest;
    case QuizKind.farthest:
      return l.qFarthest;
    case QuizKind.strongestGravity:
      return l.qStrongestGravity;
    case QuizKind.shortestDay:
      return l.qShortestDay;
    case QuizKind.longestDay:
      return l.qLongestDay;
    case QuizKind.star:
      return l.qStar;
    case QuizKind.dwarf:
      return l.qDwarf;
    case QuizKind.moonVisited:
      return l.qMoonVisited;
    case QuizKind.largestMoon:
      return l.qLargestMoon;
    case QuizKind.smallestMoon:
      return l.qSmallestMoon;
    case QuizKind.thickAirMoon:
      return l.qThickAirMoon;
    case QuizKind.geyserMoon:
      return l.qGeyserMoon;
    case QuizKind.volcanicMoon:
      return l.qVolcanicMoon;
    case QuizKind.backwardsMoon:
      return l.qBackwardsMoon;
    case QuizKind.biggestRocky:
      return l.qBiggestRocky;
    case QuizKind.coldestRocky:
      return l.qColdestRocky;
    case QuizKind.highestPressure:
      return l.qHighestPressure;
    case QuizKind.secondLargest:
      return l.qSecondLargest;
    case QuizKind.longestYear:
      return l.qLongestYear;
    case QuizKind.shortestYear:
      return l.qShortestYear;
    case QuizKind.smallestGiant:
      return l.qSmallestGiant;
    case QuizKind.rockyLongestYear:
      return l.qRockyLongestYear;
    case QuizKind.fastestMoon:
      return l.qFastestMoon;
    case QuizKind.slowestMoon:
      return l.qSlowestMoon;
    case QuizKind.strongestMoonGravity:
      return l.qStrongestMoonGravity;
    case QuizKind.coldestMoon:
      return l.qColdestMoon;
    case QuizKind.secondLargestMoon:
      return l.qSecondLargestMoon;
  }
}

String quizLevelName(AppLocalizations l, QuizLevel level) {
  switch (level) {
    case QuizLevel.easy:
      return l.levelEasy;
    case QuizLevel.medium:
      return l.levelMedium;
    case QuizLevel.hard:
      return l.levelHard;
  }
}

String quizLevelHint(AppLocalizations l, QuizLevel level) {
  switch (level) {
    case QuizLevel.easy:
      return l.levelEasyHint;
    case QuizLevel.medium:
      return l.levelMediumHint;
    case QuizLevel.hard:
      return l.levelHardHint;
  }
}

/// The two "Did you know?" facts of a body, in the app language.
List<String> bodyFacts(AppLocalizations l, String id) {
  switch (id) {
    case 'sun':
      return <String>[l.factSun1, l.factSun2];
    case 'mercury':
      return <String>[l.factMercury1, l.factMercury2];
    case 'venus':
      return <String>[l.factVenus1, l.factVenus2];
    case 'earth':
      return <String>[l.factEarth1, l.factEarth2];
    case 'mars':
      return <String>[l.factMars1, l.factMars2];
    case 'jupiter':
      return <String>[l.factJupiter1, l.factJupiter2];
    case 'saturn':
      return <String>[l.factSaturn1, l.factSaturn2];
    case 'uranus':
      return <String>[l.factUranus1, l.factUranus2];
    case 'neptune':
      return <String>[l.factNeptune1, l.factNeptune2];
    case 'moon':
      return <String>[l.factMoon1, l.factMoon2];
    case 'pluto':
      return <String>[l.factPluto1, l.factPluto2];
    case 'io':
      return <String>[l.factIo1, l.factIo2];
    case 'europa':
      return <String>[l.factEuropa1, l.factEuropa2];
    case 'ganymede':
      return <String>[l.factGanymede1, l.factGanymede2];
    case 'callisto':
      return <String>[l.factCallisto1, l.factCallisto2];
    case 'titan':
      return <String>[l.factTitan1, l.factTitan2];
    case 'enceladus':
      return <String>[l.factEnceladus1, l.factEnceladus2];
    case 'triton':
      return <String>[l.factTriton1, l.factTriton2];
    default:
      return const <String>[];
  }
}

/// A jump height as text: centimetres below one metre, metres above.
String jumpText(BuildContext context, AppLocalizations l, double cm) {
  if (cm < 100) {
    return l.valueCm(formatNumber(context, cm, decimals: cm < 10 ? 1 : 0));
  }
  return l.valueM(formatNumber(context, cm / 100, decimals: 1));
}

/// Compass name for a [compassIndex] (0 = north, clockwise).
String directionName(AppLocalizations l, int index) {
  switch (index) {
    case 0:
      return l.dirN;
    case 1:
      return l.dirNE;
    case 2:
      return l.dirE;
    case 3:
      return l.dirSE;
    case 4:
      return l.dirS;
    case 5:
      return l.dirSW;
    case 6:
      return l.dirW;
    default:
      return l.dirNW;
  }
}

/// The short story of a mission from the missions timeline.
String missionText(AppLocalizations l, String id) {
  switch (id) {
    case 'sputnik1':
      return l.missionSputnik1;
    case 'vostok1':
      return l.missionVostok1;
    case 'apollo11':
      return l.missionApollo11;
    case 'venera7':
      return l.missionVenera7;
    case 'viking1':
      return l.missionViking1;
    case 'voyager1':
      return l.missionVoyager1;
    case 'hubble':
      return l.missionHubble;
    case 'huygens':
      return l.missionHuygens;
    case 'curiosity':
      return l.missionCuriosity;
    case 'mangalyaan':
      return l.missionMangalyaan;
    case 'rosetta':
      return l.missionRosetta;
    case 'newhorizons':
      return l.missionNewhorizons;
    case 'perseverance':
      return l.missionPerseverance;
    case 'jwst':
      return l.missionJwst;
    default:
      return l.missionChandrayaan3;
  }
}

/// The short story of the spacecraft with [id].
String spacecraftText(AppLocalizations l, String id) {
  switch (id) {
    case 'voyager1':
      return l.spacecraftVoyager1;
    case 'voyager2':
      return l.spacecraftVoyager2;
    case 'newhorizons':
      return l.spacecraftNewHorizons;
    case 'jwst':
      return l.spacecraftJwst;
    case 'adityal1':
      return l.spacecraftAdityal1;
    case 'iss':
      return l.spacecraftIss;
    case 'hubble':
      return l.spacecraftHubble;
    default:
      return l.spacecraftMarsRovers;
  }
}

/// The name of a Moon phase: 0 new moon ... 7 waning crescent, as
/// `phaseIndex` gives it.
String moonPhaseName(AppLocalizations l, int index) {
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

/// A short story to go with a constellation, or null if there is none yet.
/// [id] is the IAU code, such as 'Ori'.
String? constellationStory(AppLocalizations l, String id) {
  switch (id) {
    case 'Ori':
      return l.storyOri;
    case 'UMa':
      return l.storyUMa;
    case 'UMi':
      return l.storyUMi;
    case 'Cas':
      return l.storyCas;
    case 'Cyg':
      return l.storyCyg;
    case 'Sco':
      return l.storySco;
    case 'Leo':
      return l.storyLeo;
    case 'Tau':
      return l.storyTau;
    case 'Gem':
      return l.storyGem;
    case 'Lyr':
      return l.storyLyr;
    case 'Cru':
      return l.storyCru;
  }
  return null;
}

/// The short story of a landing site on the surface map.
String siteText(AppLocalizations l, String id) {
  switch (id) {
    case 'Luna9':
      return l.siteLuna9;
    case 'Surveyor1':
      return l.siteSurveyor1;
    case 'Apollo11':
      return l.siteApollo11;
    case 'Apollo12':
      return l.siteApollo12;
    case 'Luna16':
      return l.siteLuna16;
    case 'Lunokhod1':
      return l.siteLunokhod1;
    case 'Apollo14':
      return l.siteApollo14;
    case 'Apollo15':
      return l.siteApollo15;
    case 'Apollo16':
      return l.siteApollo16;
    case 'Apollo17':
      return l.siteApollo17;
    case 'Change3':
      return l.siteChange3;
    case 'Change4':
      return l.siteChange4;
    case 'Change5':
      return l.siteChange5;
    case 'Chandrayaan3':
      return l.siteChandrayaan3;
    case 'Slim':
      return l.siteSlim;
    case 'Viking1':
      return l.siteViking1;
    case 'Viking2':
      return l.siteViking2;
    case 'Pathfinder':
      return l.sitePathfinder;
    case 'Spirit':
      return l.siteSpirit;
    case 'Opportunity':
      return l.siteOpportunity;
    case 'Phoenix':
      return l.sitePhoenix;
    case 'Curiosity':
      return l.siteCuriosity;
    case 'Insight':
      return l.siteInsight;
    case 'Perseverance':
      return l.sitePerseverance;
    case 'Zhurong':
      return l.siteZhurong;
    default:
      return id;
  }
}

/// The name of a landform on the surface map.
String featureName(AppLocalizations l, String id) {
  switch (id) {
    case 'Imbrium':
      return l.featImbrium;
    case 'Serenitatis':
      return l.featSerenitatis;
    case 'Tranquillitatis':
      return l.featTranquillitatis;
    case 'Crisium':
      return l.featCrisium;
    case 'Fecunditatis':
      return l.featFecunditatis;
    case 'Nectaris':
      return l.featNectaris;
    case 'Nubium':
      return l.featNubium;
    case 'Humorum':
      return l.featHumorum;
    case 'Procellarum':
      return l.featProcellarum;
    case 'Frigoris':
      return l.featFrigoris;
    case 'Orientale':
      return l.featOrientale;
    case 'Aitken':
      return l.featAitken;
    case 'Tycho':
      return l.featTycho;
    case 'Copernicus':
      return l.featCopernicus;
    case 'Olympus':
      return l.featOlympus;
    case 'Tharsis':
      return l.featTharsis;
    case 'Valles':
      return l.featValles;
    case 'Hellas':
      return l.featHellas;
    case 'Argyre':
      return l.featArgyre;
    case 'Utopia':
      return l.featUtopia;
    case 'Isidis':
      return l.featIsidis;
    case 'Syrtis':
      return l.featSyrtis;
    case 'Chryse':
      return l.featChryse;
    case 'Acidalia':
      return l.featAcidalia;
    case 'Elysium':
      return l.featElysium;
    case 'NorthCap':
      return l.featNorthCap;
    case 'SouthCap':
      return l.featSouthCap;
    default:
      return id;
  }
}

/// What kind of landing a site was.
String siteKindLabel(AppLocalizations l, SiteKind kind) {
  switch (kind) {
    case SiteKind.crewed:
      return l.siteKindCrewed;
    case SiteKind.lander:
      return l.siteKindLander;
    case SiteKind.rover:
      return l.siteKindRover;
    case SiteKind.sample:
      return l.siteKindSample;
  }
}

/// The name of [city] for display: "My location" is translated, the others
/// are place names.
String cityName(AppLocalizations l, City city) =>
    city.id == gpsCityId ? l.myLocation : city.name;
