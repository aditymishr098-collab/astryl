import 'orbits.dart';

/// How a spacecraft's distance is worked out.
enum SpacecraftKind {
  /// A probe leaving the solar system. Its distance grows at a steady speed
  /// from a known point (a straight-line estimate).
  probe,

  /// A spacecraft in orbit close to Earth. The height is about constant.
  lowOrbit,

  /// A spacecraft that stays at about the same distance from Earth.
  fixedDistance,

  /// Rovers on Mars. Their distance is the distance to Mars today.
  mars,
}

/// A famous spacecraft whose distance from Earth the app shows. Names are
/// proper names and stay as they are in every language; the short story of
/// each one is translated (see `spacecraftText` in names.dart).
class Spacecraft {
  const Spacecraft({
    required this.id,
    required this.name,
    required this.kind,
    this.anchorYear = 2000,
    this.anchorMonth = 1,
    this.anchorDay = 1,
    this.anchorAu = 0,
    this.speedKmS = 0,
    this.fixedKm = 0,
  });

  /// Short id, also the last part of the l10n key.
  final String id;
  final String name;
  final SpacecraftKind kind;

  /// For a [SpacecraftKind.probe]: the date (UTC) when it was at [anchorAu].
  final int anchorYear;
  final int anchorMonth;
  final int anchorDay;

  /// Distance in astronomical units at the anchor date.
  final double anchorAu;

  /// Average speed away from the Sun in km per second.
  final double speedKmS;

  /// Height or distance in km for the spacecraft that stay about the same.
  final double fixedKm;

  DateTime get anchor => DateTime.utc(anchorYear, anchorMonth, anchorDay);

  /// True when the distance is a height above Earth's surface.
  bool get isAltitude => kind == SpacecraftKind.lowOrbit;

  /// Distance from Earth in km on [now].
  double distanceKm(DateTime now) {
    switch (kind) {
      case SpacecraftKind.probe:
        final seconds = now.toUtc().difference(anchor).inSeconds;
        return anchorAu * kmPerAu + seconds * speedKmS;
      case SpacecraftKind.lowOrbit:
      case SpacecraftKind.fixedDistance:
        return fixedKm;
      case SpacecraftKind.mars:
        return distanceFromEarthKm('mars', now);
    }
  }

  /// Distance in astronomical units on [now].
  double distanceAu(DateTime now) => distanceKm(now) / kmPerAu;

  /// How long a radio signal takes to cross that distance, in seconds.
  double signalSeconds(DateTime now) => distanceKm(now) / speedOfLightKmS;
}

/// Speed of light in km per second.
const double speedOfLightKmS = 299792.458;

/// The spacecraft in the app, far probes first.
///
/// Anchors: NASA says Voyager 1 reaches one light-day (173.14 AU) from Earth
/// on 18 November 2026 and Voyager 2 in November 2035; New Horizons crossed
/// 50 AU from the Sun on 17 April 2021. Speeds are the published averages.
const List<Spacecraft> spacecraft = <Spacecraft>[
  Spacecraft(
    id: 'voyager1',
    name: 'Voyager 1',
    kind: SpacecraftKind.probe,
    anchorYear: 2026,
    anchorMonth: 11,
    anchorDay: 18,
    anchorAu: 173.14,
    speedKmS: 16.9,
  ),
  Spacecraft(
    id: 'voyager2',
    name: 'Voyager 2',
    kind: SpacecraftKind.probe,
    anchorYear: 2035,
    anchorMonth: 11,
    anchorDay: 15,
    anchorAu: 173.14,
    speedKmS: 15.3,
  ),
  Spacecraft(
    id: 'newhorizons',
    name: 'New Horizons',
    kind: SpacecraftKind.probe,
    anchorYear: 2021,
    anchorMonth: 4,
    anchorDay: 17,
    anchorAu: 50,
    speedKmS: 13.4,
  ),
  Spacecraft(
    id: 'jwst',
    name: 'James Webb (JWST)',
    kind: SpacecraftKind.fixedDistance,
    fixedKm: 1500000,
  ),
  Spacecraft(
    id: 'adityal1',
    name: 'Aditya-L1 (ISRO)',
    kind: SpacecraftKind.fixedDistance,
    fixedKm: 1500000,
  ),
  Spacecraft(
    id: 'iss',
    name: 'ISS',
    kind: SpacecraftKind.lowOrbit,
    fixedKm: 420,
  ),
  Spacecraft(
    id: 'hubble',
    name: 'Hubble',
    kind: SpacecraftKind.lowOrbit,
    fixedKm: 520,
  ),
  Spacecraft(
    id: 'marsrovers',
    name: 'Curiosity · Perseverance',
    kind: SpacecraftKind.mars,
  ),
];
