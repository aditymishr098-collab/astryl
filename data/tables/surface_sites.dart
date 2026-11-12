/// Landing sites and big surface features of the Moon and Mars, for the
/// surface map. Coordinates are real (latitude north positive, longitude east
/// positive, -180 to 180). Names of missions are proper names and stay as they
/// are in every language; the short stories and the feature names are
/// translated (see `siteText` and `featureName` in names.dart).
library;

enum SurfaceWorld { moon, mars }

enum SiteKind { crewed, lander, rover, sample }

/// A place where a spacecraft landed.
class SurfaceSite {
  const SurfaceSite({
    required this.id,
    required this.world,
    required this.name,
    required this.agency,
    required this.year,
    required this.lat,
    required this.lon,
    required this.kind,
  });

  /// Short id, also the last part of the l10n key (`site` + id).
  final String id;
  final SurfaceWorld world;
  final String name;
  final String agency;
  final int year;
  final double lat;
  final double lon;
  final SiteKind kind;
}

enum FeatureKind { sea, basin, crater, volcano, canyon, highland, cap }

/// A big landform drawn on the map, as an ellipse of half-width [rx] and
/// half-height [ry] in degrees, turned by [tilt] degrees.
class SurfaceFeature {
  const SurfaceFeature({
    required this.id,
    required this.world,
    required this.lat,
    required this.lon,
    required this.rx,
    required this.ry,
    required this.kind,
    this.tilt = 0,
    this.major = false,
  });

  /// Short id, also the last part of the l10n key (`feat` + id).
  final String id;
  final SurfaceWorld world;
  final double lat;
  final double lon;
  final double rx;
  final double ry;
  final FeatureKind kind;
  final double tilt;

  /// Labelled even when the map is not zoomed in.
  final bool major;
}

List<SurfaceSite> sitesOf(SurfaceWorld world) =>
    surfaceSites.where((s) => s.world == world).toList()
      ..sort((a, b) => a.year != b.year ? a.year.compareTo(b.year) : a.name.compareTo(b.name));

List<SurfaceFeature> featuresOf(SurfaceWorld world) =>
    surfaceFeatures.where((f) => f.world == world).toList();

const List<SurfaceSite> surfaceSites = <SurfaceSite>[
  // The Moon.
  SurfaceSite(id: 'Luna9', world: SurfaceWorld.moon, name: 'Luna 9', agency: 'USSR', year: 1966, lat: 7.08, lon: -64.37, kind: SiteKind.lander),
  SurfaceSite(id: 'Surveyor1', world: SurfaceWorld.moon, name: 'Surveyor 1', agency: 'NASA', year: 1966, lat: -2.47, lon: -43.34, kind: SiteKind.lander),
  SurfaceSite(id: 'Apollo11', world: SurfaceWorld.moon, name: 'Apollo 11', agency: 'NASA', year: 1969, lat: 0.67, lon: 23.47, kind: SiteKind.crewed),
  SurfaceSite(id: 'Apollo12', world: SurfaceWorld.moon, name: 'Apollo 12', agency: 'NASA', year: 1969, lat: -3.01, lon: -23.42, kind: SiteKind.crewed),
  SurfaceSite(id: 'Luna16', world: SurfaceWorld.moon, name: 'Luna 16', agency: 'USSR', year: 1970, lat: -0.68, lon: 56.30, kind: SiteKind.sample),
  SurfaceSite(id: 'Lunokhod1', world: SurfaceWorld.moon, name: 'Lunokhod 1', agency: 'USSR', year: 1970, lat: 38.28, lon: -35.00, kind: SiteKind.rover),
  SurfaceSite(id: 'Apollo14', world: SurfaceWorld.moon, name: 'Apollo 14', agency: 'NASA', year: 1971, lat: -3.65, lon: -17.47, kind: SiteKind.crewed),
  SurfaceSite(id: 'Apollo15', world: SurfaceWorld.moon, name: 'Apollo 15', agency: 'NASA', year: 1971, lat: 26.13, lon: 3.63, kind: SiteKind.crewed),
  SurfaceSite(id: 'Apollo16', world: SurfaceWorld.moon, name: 'Apollo 16', agency: 'NASA', year: 1972, lat: -8.97, lon: 15.50, kind: SiteKind.crewed),
  SurfaceSite(id: 'Apollo17', world: SurfaceWorld.moon, name: 'Apollo 17', agency: 'NASA', year: 1972, lat: 20.19, lon: 30.77, kind: SiteKind.crewed),
  SurfaceSite(id: 'Change3', world: SurfaceWorld.moon, name: "Chang'e 3", agency: 'CNSA', year: 2013, lat: 44.12, lon: -19.51, kind: SiteKind.rover),
  SurfaceSite(id: 'Change4', world: SurfaceWorld.moon, name: "Chang'e 4", agency: 'CNSA', year: 2019, lat: -45.46, lon: 177.59, kind: SiteKind.rover),
  SurfaceSite(id: 'Change5', world: SurfaceWorld.moon, name: "Chang'e 5", agency: 'CNSA', year: 2020, lat: 43.06, lon: -51.92, kind: SiteKind.sample),
  SurfaceSite(id: 'Chandrayaan3', world: SurfaceWorld.moon, name: 'Chandrayaan-3', agency: 'ISRO', year: 2023, lat: -69.37, lon: 32.32, kind: SiteKind.rover),
  SurfaceSite(id: 'Slim', world: SurfaceWorld.moon, name: 'SLIM', agency: 'JAXA', year: 2024, lat: -13.32, lon: 25.25, kind: SiteKind.lander),
  // Mars.
  SurfaceSite(id: 'Viking1', world: SurfaceWorld.mars, name: 'Viking 1', agency: 'NASA', year: 1976, lat: 22.70, lon: -47.95, kind: SiteKind.lander),
  SurfaceSite(id: 'Viking2', world: SurfaceWorld.mars, name: 'Viking 2', agency: 'NASA', year: 1976, lat: 47.64, lon: 134.26, kind: SiteKind.lander),
  SurfaceSite(id: 'Pathfinder', world: SurfaceWorld.mars, name: 'Mars Pathfinder', agency: 'NASA', year: 1997, lat: 19.13, lon: -33.22, kind: SiteKind.rover),
  SurfaceSite(id: 'Spirit', world: SurfaceWorld.mars, name: 'Spirit', agency: 'NASA', year: 2004, lat: -14.57, lon: 175.47, kind: SiteKind.rover),
  SurfaceSite(id: 'Opportunity', world: SurfaceWorld.mars, name: 'Opportunity', agency: 'NASA', year: 2004, lat: -1.95, lon: -5.53, kind: SiteKind.rover),
  SurfaceSite(id: 'Phoenix', world: SurfaceWorld.mars, name: 'Phoenix', agency: 'NASA', year: 2008, lat: 68.22, lon: -125.75, kind: SiteKind.lander),
  SurfaceSite(id: 'Curiosity', world: SurfaceWorld.mars, name: 'Curiosity', agency: 'NASA', year: 2012, lat: -4.59, lon: 137.44, kind: SiteKind.rover),
  SurfaceSite(id: 'Insight', world: SurfaceWorld.mars, name: 'InSight', agency: 'NASA', year: 2018, lat: 4.50, lon: 135.62, kind: SiteKind.lander),
  SurfaceSite(id: 'Perseverance', world: SurfaceWorld.mars, name: 'Perseverance', agency: 'NASA', year: 2021, lat: 18.44, lon: 77.45, kind: SiteKind.rover),
  SurfaceSite(id: 'Zhurong', world: SurfaceWorld.mars, name: 'Zhurong', agency: 'CNSA', year: 2021, lat: 25.07, lon: 109.93, kind: SiteKind.rover),
];

const List<SurfaceFeature> surfaceFeatures = <SurfaceFeature>[
  // The Moon: the dark seas, two huge basins and two famous craters.
  SurfaceFeature(id: 'Imbrium', world: SurfaceWorld.moon, lat: 32.8, lon: -15.6, rx: 16, ry: 12, kind: FeatureKind.sea, major: true),
  SurfaceFeature(id: 'Serenitatis', world: SurfaceWorld.moon, lat: 28.0, lon: 17.5, rx: 8, ry: 7, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Tranquillitatis', world: SurfaceWorld.moon, lat: 8.5, lon: 31.4, rx: 11, ry: 8, kind: FeatureKind.sea, major: true),
  SurfaceFeature(id: 'Crisium', world: SurfaceWorld.moon, lat: 17.0, lon: 59.1, rx: 6, ry: 5, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Fecunditatis', world: SurfaceWorld.moon, lat: -7.8, lon: 51.3, rx: 8, ry: 8, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Nectaris', world: SurfaceWorld.moon, lat: -15.2, lon: 35.5, rx: 5, ry: 5, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Nubium', world: SurfaceWorld.moon, lat: -21.3, lon: -16.2, rx: 9, ry: 8, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Humorum', world: SurfaceWorld.moon, lat: -24.4, lon: -38.6, rx: 6, ry: 6, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Procellarum', world: SurfaceWorld.moon, lat: 18.4, lon: -57.4, rx: 20, ry: 24, kind: FeatureKind.sea, major: true),
  SurfaceFeature(id: 'Frigoris', world: SurfaceWorld.moon, lat: 56.0, lon: 1.4, rx: 28, ry: 5, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Orientale', world: SurfaceWorld.moon, lat: -19.4, lon: -92.8, rx: 7, ry: 7, kind: FeatureKind.basin),
  SurfaceFeature(id: 'Aitken', world: SurfaceWorld.moon, lat: -53.0, lon: -169.0, rx: 26, ry: 20, kind: FeatureKind.basin, major: true),
  SurfaceFeature(id: 'Tycho', world: SurfaceWorld.moon, lat: -43.3, lon: -11.2, rx: 3, ry: 3, kind: FeatureKind.crater),
  SurfaceFeature(id: 'Copernicus', world: SurfaceWorld.moon, lat: 9.7, lon: -20.1, rx: 2.5, ry: 2.5, kind: FeatureKind.crater),
  // Mars.
  SurfaceFeature(id: 'Olympus', world: SurfaceWorld.mars, lat: 18.65, lon: -133.8, rx: 7, ry: 7, kind: FeatureKind.volcano, major: true),
  SurfaceFeature(id: 'Tharsis', world: SurfaceWorld.mars, lat: 1.0, lon: -112.0, rx: 11, ry: 6, kind: FeatureKind.highland, major: true),
  SurfaceFeature(id: 'Valles', world: SurfaceWorld.mars, lat: -12.0, lon: -62.0, rx: 22, ry: 2.5, kind: FeatureKind.canyon, tilt: 6, major: true),
  SurfaceFeature(id: 'Hellas', world: SurfaceWorld.mars, lat: -42.4, lon: 70.5, rx: 12, ry: 10, kind: FeatureKind.basin, major: true),
  SurfaceFeature(id: 'Argyre', world: SurfaceWorld.mars, lat: -49.7, lon: -43.0, rx: 7, ry: 6, kind: FeatureKind.basin),
  SurfaceFeature(id: 'Utopia', world: SurfaceWorld.mars, lat: 46.7, lon: 117.5, rx: 20, ry: 12, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Isidis', world: SurfaceWorld.mars, lat: 12.9, lon: 87.0, rx: 8, ry: 6, kind: FeatureKind.basin),
  SurfaceFeature(id: 'Syrtis', world: SurfaceWorld.mars, lat: 8.4, lon: 69.5, rx: 8, ry: 10, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Chryse', world: SurfaceWorld.mars, lat: 28.0, lon: -40.0, rx: 12, ry: 9, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Acidalia', world: SurfaceWorld.mars, lat: 46.0, lon: -22.0, rx: 20, ry: 11, kind: FeatureKind.sea),
  SurfaceFeature(id: 'Elysium', world: SurfaceWorld.mars, lat: 25.0, lon: 147.0, rx: 6, ry: 6, kind: FeatureKind.volcano),
  SurfaceFeature(id: 'NorthCap', world: SurfaceWorld.mars, lat: 90.0, lon: 0.0, rx: 200, ry: 10, kind: FeatureKind.cap),
  SurfaceFeature(id: 'SouthCap', world: SurfaceWorld.mars, lat: -90.0, lon: 0.0, rx: 200, ry: 9, kind: FeatureKind.cap),
];
