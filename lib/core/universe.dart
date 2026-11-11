import 'dart:math' as math;

import '../data/universe_catalog.dart';
import 'orbits.dart';

/// The Universe map: real places of the planets, nearby stars, black holes
/// and galaxies in one 3D space, measured in light-years from the Sun.
///
/// The axes are the equatorial ones (J2000): x points to the March equinox,
/// z to the north celestial pole. Everything runs on the phone.

/// Astronomical units in one light-year.
const double auPerLightYear = 63241.077;

/// Radius of the observable universe today, in light-years.
const double observableRadiusLy = 46.5e9;

/// The Sun's distance from the centre of the Milky Way, in light-years.
const double sunToCentreLy = 26700;

/// Years the Sun needs for one trip around the Milky Way.
const double galacticYear = 230e6;

/// Years a typical spiral galaxy's disk needs for one turn (for the sped-up
/// spin of other galaxies; each real galaxy has its own value).
const double otherGalaxyTurn = 250e6;

const double _obliquity = 23.4392911 * math.pi / 180;

double _rad(double d) => d * math.pi / 180;

/// A point or a direction in space.
class V3 {
  const V3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  static const V3 zero = V3(0, 0, 0);

  V3 operator +(V3 o) => V3(x + o.x, y + o.y, z + o.z);
  V3 operator -(V3 o) => V3(x - o.x, y - o.y, z - o.z);
  V3 operator *(double k) => V3(x * k, y * k, z * k);

  double dot(V3 o) => x * o.x + y * o.y + z * o.z;

  V3 cross(V3 o) =>
      V3(y * o.z - z * o.y, z * o.x - x * o.z, x * o.y - y * o.x);

  double get length => math.sqrt(x * x + y * y + z * z);

  V3 get unit {
    final l = length;
    return l == 0 ? this : V3(x / l, y / l, z / l);
  }

  static V3 lerp(V3 a, V3 b, double t) => a + (b - a) * t;
}

/// The place at right ascension [raDeg], declination [decDeg] and [dist].
V3 fromEquatorial(double raDeg, double decDeg, double dist) {
  final a = _rad(raDeg), d = _rad(decDeg);
  return V3(dist * math.cos(d) * math.cos(a), dist * math.cos(d) * math.sin(a),
      dist * math.sin(d));
}

/// Directions of the Milky Way in the equatorial frame (the rows of the
/// standard J2000 equatorial to galactic matrix).
const V3 galacticCentreDir = V3(-0.0548755604, -0.8734370902, -0.4838350155);
const V3 galacticSpinDir = V3(0.4941094279, -0.4448296300, 0.7469822445);
const V3 galacticNorth = V3(-0.8676661490, -0.1980763734, 0.4559837762);

/// The centre of the Milky Way (Sagittarius A*), in light-years from the Sun.
final V3 galacticCentre = fromEquatorial(266.4168, -29.0078, sunToCentreLy);

/// Turns [p] around the centre of the Milky Way by the angle the disk covers
/// in [years]. Seen from the north side the Galaxy turns clockwise. The disk
/// is turned as one piece, which keeps the picture simple; real stars at
/// different distances from the centre take different times.
V3 turnWithGalaxy(V3 p, double years) {
  if (years == 0) {
    return p;
  }
  final angle = -2 * math.pi * years / galacticYear;
  return galacticCentre + rotate(p - galacticCentre, galacticNorth, angle);
}

/// Rotates [v] around the unit [axis] by [angle] radians (Rodrigues).
V3 rotate(V3 v, V3 axis, double angle) {
  final c = math.cos(angle), s = math.sin(angle);
  return v * c + axis.cross(v) * s + axis * (axis.dot(v) * (1 - c));
}

/// From the ecliptic frame (the one the planet formulas use) to the
/// equatorial frame.
V3 eclipticToEquatorial(double x, double y, double z) {
  final c = math.cos(_obliquity), s = math.sin(_obliquity);
  return V3(x, y * c - z * s, y * s + z * c);
}

final V3 _eclipticNorth = eclipticToEquatorial(0, 0, 1);

/// Where the planet [id] is around the Sun, in light-years, [years] after
/// [now]. Inside 1800 to 2050 this is the real position. Outside, the planet
/// keeps its orbit and simply goes on around at its mean speed.
V3 planetOffset(String id, double yearDays, DateTime now, double years) {
  const msPerYear = 365.25 * 86400000.0;
  final wantedMs = now.millisecondsSinceEpoch + years * msPerYear;
  final lo = orbitMinDate.millisecondsSinceEpoch.toDouble();
  final hi = orbitMaxDate.millisecondsSinceEpoch.toDouble();
  final insideMs = wantedMs.clamp(lo, hi).toDouble();
  final date =
      DateTime.fromMillisecondsSinceEpoch(insideMs.round(), isUtc: true);
  final h = heliocentricPosition(id, date);
  var p = eclipticToEquatorial(h.x, h.y, h.z) * (1 / auPerLightYear);
  final extraYears = (wantedMs - insideMs) / msPerYear;
  if (extraYears != 0 && yearDays > 0) {
    final turns = extraYears * 365.25 / yearDays;
    p = rotate(p, _eclipticNorth, 2 * math.pi * (turns - turns.floorToDouble()));
  }
  return p;
}

/// One full orbit of the planet [id] as [steps] points around the Sun, in
/// light-years. Used to draw the orbit line.
List<V3> orbitLine(String id, double yearDays, DateTime now, {int steps = 96}) {
  final out = <V3>[];
  final base = clampOrbitDate(now);
  for (var i = 0; i < steps; i++) {
    var date = base.add(Duration(
        milliseconds: (yearDays * 86400000.0 * i / steps).round()));
    // Keep inside the range of the formulas by going back whole orbits.
    while (date.isAfter(orbitMaxDate)) {
      date = date.subtract(
          Duration(milliseconds: (yearDays * 86400000.0).round()));
    }
    final h = heliocentricPosition(id, date);
    out.add(eclipticToEquatorial(h.x, h.y, h.z) * (1 / auPerLightYear));
  }
  return out;
}

// ---------------------------------------------------------------------------
// Catalogue rows (written by tools/build_universe.py)

/// A star, a nebula or a star cluster near us.
class StarRow {
  const StarRow(this.name, this.ra, this.dec, this.distLy, this.kind, this.tint);

  final String name;
  final double ra;
  final double dec;
  final double distLy;

  /// 0 star, 1 nebula, 2 star cluster.
  final int kind;

  /// 0 blue-white, 1 white, 2 yellow, 3 orange, 4 red.
  final int tint;
}

/// A black hole.
class HoleRow {
  const HoleRow(this.name, this.ra, this.dec, this.distLy, this.lightYears,
      this.massSuns, this.estimated);

  final String name;
  final double ra;
  final double dec;

  /// Distance today, in light-years.
  final double distLy;

  /// Years its light has travelled; 0 when that is the same as [distLy].
  final double lightYears;
  final double massSuns;

  /// 1 when the distance comes from the redshift.
  final int estimated;
}

/// A cluster of galaxies or a very far galaxy.
class MarkRow {
  const MarkRow(
      this.name, this.ra, this.dec, this.distLy, this.lightYears, this.kind);

  final String name;
  final double ra;
  final double dec;
  final double distLy;
  final double lightYears;

  /// 0 cluster of galaxies, 1 far galaxy.
  final int kind;
}

// ---------------------------------------------------------------------------
// Bodies of the map

enum UKind {
  sun,
  planet,
  star,
  nebula,
  starCluster,
  blackHole,
  milkyWay,
  galaxy,
  galaxyCluster,
}

/// Shape of a galaxy.
enum GalaxyShape { spiral, barred, elliptical, lenticular, irregular, unknown }

/// One thing on the map.
class UBody {
  UBody({
    required this.kind,
    required this.id,
    required this.name,
    required this.base,
    required this.radiusLy,
    this.distLy = 0,
    this.lightYears = 0,
    this.massSuns = 0,
    this.estimated = false,
    this.inMilkyWay = false,
    this.rank = 9,
    this.tint = 1,
    this.shape = GalaxyShape.unknown,
    this.positionAngle = 0,
    this.axisRatio = 1,
    this.yearDays = 0,
    this.search = '',
  });

  final UKind kind;

  /// Planet id ('earth'), or a catalogue name.
  final String id;

  /// Name as shown. Planets, the Sun and the Milky Way get a translated name
  /// from the screen instead.
  final String name;

  /// Place today, in light-years from the Sun.
  final V3 base;

  /// Rough size, used for how close the camera may come and for drawing.
  final double radiusLy;

  /// Distance from Earth today, in light-years.
  final double distLy;

  /// Years its light has travelled, when that differs from [distLy].
  final double lightYears;
  final double massSuns;
  final bool estimated;

  /// True when it turns with the Milky Way's disk.
  final bool inMilkyWay;

  /// 0 is the most important label, 9 never gets one by itself.
  final int rank;
  final int tint;
  final GalaxyShape shape;
  final double positionAngle;
  final double axisRatio;
  final double yearDays;

  /// Lower-case text the search looks in.
  final String search;
}

/// "NGC0224" to "NGC 224", "IC0010" to "IC 10".
String catalogueName(String raw) {
  final m = RegExp(r'^(NGC|IC)0*(\d+)(.*)$').firstMatch(raw);
  if (m == null) {
    return raw;
  }
  return '${m.group(1)} ${m.group(2)}${m.group(3)}';
}

GalaxyShape _shape(String code) {
  switch (code) {
    case 'S':
      return GalaxyShape.spiral;
    case 'B':
      return GalaxyShape.barred;
    case 'E':
      return GalaxyShape.elliptical;
    case 'L':
      return GalaxyShape.lenticular;
    case 'I':
      return GalaxyShape.irregular;
    default:
      return GalaxyShape.unknown;
  }
}

/// Reads the galaxy table of the catalogue.
List<UBody> parseGalaxies(String rows) {
  final out = <UBody>[];
  for (final line in rows.split('\n')) {
    final f = line.split('|');
    if (f.length < 11) {
      continue;
    }
    final ra = double.parse(f[2]);
    final dec = double.parse(f[3]);
    final dist = double.parse(f[4]) * 1e6;
    final width = double.parse(f[5]) * 1e3;
    final catalogue = catalogueName(f[0]);
    final messier = f[1].isEmpty ? '' : 'M${f[1]}';
    final common = f[10];
    String name;
    if (common.isNotEmpty) {
      name = common;
    } else if (messier.isNotEmpty) {
      name = '$messier ($catalogue)';
    } else {
      name = catalogue;
    }
    out.add(UBody(
      kind: UKind.galaxy,
      id: f[0],
      name: name,
      base: fromEquatorial(ra, dec, dist),
      radiusLy: math.max(width / 2, 1500.0),
      distLy: dist,
      estimated: f[7] == '1',
      rank: common.isNotEmpty ? 3 : (messier.isNotEmpty ? 4 : 9),
      shape: _shape(f[6]),
      positionAngle: double.parse(f[8]),
      axisRatio: double.parse(f[9]),
      search: '$common $messier $catalogue ${f[0]}'.toLowerCase(),
    ));
  }
  return out;
}

/// Planets shown on the map, with the length of their year in days.
const Map<String, double> mapPlanets = <String, double>{
  'mercury': 87.969,
  'venus': 224.701,
  'earth': 365.256,
  'mars': 686.980,
  'jupiter': 4332.59,
  'saturn': 10759.22,
  'uranus': 30688.5,
  'neptune': 60182.0,
};

/// Everything on the map except the dust of the Milky Way.
class Universe {
  Universe._(this.bodies, this.sun, this.milkyWay);

  final List<UBody> bodies;
  final UBody sun;
  final UBody milkyWay;

  static Universe? _cached;

  /// Builds the map once and keeps it.
  static Universe load() => _cached ??= _build();

  static Universe _build() {
    final bodies = <UBody>[];
    final sun = UBody(
      kind: UKind.sun,
      id: 'sun',
      name: 'Sun',
      base: V3.zero,
      radiusLy: 0.00465 / auPerLightYear,
      inMilkyWay: true,
      rank: 0,
      tint: 2,
      search: 'sun',
    );
    bodies.add(sun);
    for (final e in mapPlanets.entries) {
      if (!hasOrbit(e.key)) {
        continue;
      }
      bodies.add(UBody(
        kind: UKind.planet,
        id: e.key,
        name: e.key,
        base: V3.zero,
        radiusLy: 0.0005 / auPerLightYear,
        inMilkyWay: true,
        rank: 1,
        yearDays: e.value,
        search: e.key,
      ));
    }
    for (final s in starRows) {
      bodies.add(UBody(
        kind: s.kind == 1
            ? UKind.nebula
            : (s.kind == 2 ? UKind.starCluster : UKind.star),
        id: s.name,
        name: s.name,
        base: fromEquatorial(s.ra, s.dec, s.distLy),
        radiusLy: s.kind == 0 ? 0.0002 : 10,
        distLy: s.distLy,
        inMilkyWay: true,
        rank: 2,
        tint: s.tint,
        search: s.name.toLowerCase(),
      ));
    }
    for (final h in holeRows) {
      bodies.add(UBody(
        kind: UKind.blackHole,
        id: h.name,
        name: h.name,
        base: fromEquatorial(h.ra, h.dec, h.distLy),
        // Horizon radius: 2.95 km for each Sun of mass.
        radiusLy: h.massSuns * 2.95 / 9.4607e12,
        distLy: h.distLy,
        lightYears: h.lightYears,
        massSuns: h.massSuns,
        estimated: h.estimated == 1,
        inMilkyWay: h.distLy < 60000,
        rank: 2,
        search: h.name.toLowerCase(),
      ));
    }
    final milkyWay = UBody(
      kind: UKind.milkyWay,
      id: 'milkyway',
      name: 'Milky Way',
      base: galacticCentre,
      radiusLy: 50000,
      distLy: sunToCentreLy,
      inMilkyWay: true,
      rank: 0,
      shape: GalaxyShape.barred,
      search: 'milky way',
    );
    bodies.add(milkyWay);
    bodies.addAll(parseGalaxies(galaxyRows));
    for (final m in markRows) {
      bodies.add(UBody(
        kind: m.kind == 0 ? UKind.galaxyCluster : UKind.galaxy,
        id: m.name,
        name: m.name,
        base: fromEquatorial(m.ra, m.dec, m.distLy),
        radiusLy: m.kind == 0 ? 5e6 : 3000,
        distLy: m.distLy,
        lightYears: m.lightYears,
        estimated: m.kind == 1,
        rank: m.kind == 0 ? 3 : 2,
        search: m.name.toLowerCase(),
      ));
    }
    return Universe._(bodies, sun, milkyWay);
  }

  /// Where [b] is [years] after [now].
  V3 positionOf(UBody b, DateTime now, double years, {bool freezePlanets = false}) {
    if (b.kind == UKind.planet) {
      final sunNow = turnWithGalaxy(V3.zero, years);
      return sunNow +
          planetOffset(b.id, b.yearDays, now, freezePlanets ? 0 : years);
    }
    if (b.inMilkyWay) {
      return turnWithGalaxy(b.base, years);
    }
    return b.base;
  }

  /// Bodies whose name contains [query], best first.
  List<UBody> find(String query, {int limit = 60}) {
    final q = query.trim().toLowerCase();
    final out = <UBody>[];
    for (final b in bodies) {
      if (q.isEmpty ? b.rank <= 4 : b.search.contains(q)) {
        out.add(b);
      }
    }
    if (q.isNotEmpty) {
      out.sort((a, b) => a.rank.compareTo(b.rank));
    }
    return out.length > limit ? out.sublist(0, limit) : out;
  }
}

// ---------------------------------------------------------------------------
// The Milky Way and other galaxies as clouds of points

/// Points of the Milky Way's disk, bar, bulge and arms, in light-years from
/// the Sun, with a colour group each (0 warm centre, 1 blue arms, 2 pale
/// disk). The spiral is a model with the real size, a bar and four trailing
/// arms; single stars this far cannot be mapped.
class GalaxyCloud {
  GalaxyCloud(this.points, this.groups);

  final List<V3> points;
  final List<int> groups;
}

GalaxyCloud? _milkyWayCloud;

GalaxyCloud milkyWayCloud() => _milkyWayCloud ??= _buildMilkyWay();

double _gauss(math.Random r) {
  // Box-Muller.
  final u = math.max(r.nextDouble(), 1e-12);
  return math.sqrt(-2 * math.log(u)) * math.cos(2 * math.pi * r.nextDouble());
}

GalaxyCloud _buildMilkyWay() {
  final r = math.Random(7);
  final points = <V3>[];
  final groups = <int>[];
  // Axes in the disk: e1 from the centre away from the Sun's side, e2 at
  // right angles in the disk, e3 to the Galaxy's north.
  const e1 = galacticCentreDir;
  const e2 = galacticSpinDir;
  const e3 = galacticNorth;
  void add(double a, double b, double c, int group) {
    points.add(galacticCentre + e1 * a + e2 * b + e3 * c);
    groups.add(group);
  }

  // Bulge.
  for (var i = 0; i < 520; i++) {
    add(_gauss(r) * 2800, _gauss(r) * 2800, _gauss(r) * 1700, 0);
  }
  // Bar, about 27 degrees from the line between the Sun and the centre.
  const barAngle = 27 * math.pi / 180;
  for (var i = 0; i < 320; i++) {
    final along = _gauss(r) * 6500;
    final across = _gauss(r) * 1300;
    // The near end of the bar points to the Sun's side (negative e1).
    final a = -along * math.cos(barAngle) - across * math.sin(barAngle);
    final b = -along * math.sin(barAngle) + across * math.cos(barAngle);
    add(a, b, _gauss(r) * 700, 0);
  }
  // Four trailing arms: the radius grows with the angle.
  final k = math.tan(12.5 * math.pi / 180);
  for (var arm = 0; arm < 4; arm++) {
    final start = arm * math.pi / 2 + 0.6;
    for (var i = 0; i < 560; i++) {
      final t = r.nextDouble();
      final radius = 9000 + t * 42000;
      final angle = start + math.log(radius / 9000) / k;
      final spread = 900 + radius * 0.035;
      final a = radius * math.cos(angle) + _gauss(r) * spread;
      final b = radius * math.sin(angle) + _gauss(r) * spread;
      add(a, b, _gauss(r) * 450, 1);
    }
  }
  // Thin disk between the arms.
  for (var i = 0; i < 700; i++) {
    final radius = -13000 * math.log(math.max(r.nextDouble(), 1e-9));
    if (radius > 55000) {
      continue;
    }
    final angle = r.nextDouble() * 2 * math.pi;
    add(radius * math.cos(angle), radius * math.sin(angle), _gauss(r) * 600, 2);
  }
  return GalaxyCloud(points, groups);
}

/// Points of a model galaxy of radius 1: x and y in the disk, z out of it.
class GalaxyTemplate {
  GalaxyTemplate(this.x, this.y, this.z);

  final List<double> x;
  final List<double> y;
  final List<double> z;

  int get length => x.length;
}

final Map<GalaxyShape, GalaxyTemplate> _templates =
    <GalaxyShape, GalaxyTemplate>{};

GalaxyTemplate galaxyTemplate(GalaxyShape shape) =>
    _templates.putIfAbsent(shape, () => _buildTemplate(shape));

GalaxyTemplate _buildTemplate(GalaxyShape shape) {
  final r = math.Random(11 + shape.index);
  final x = <double>[], y = <double>[], z = <double>[];
  void add(double a, double b, double c) {
    x.add(a);
    y.add(b);
    z.add(c);
  }

  switch (shape) {
    case GalaxyShape.elliptical:
      for (var i = 0; i < 220; i++) {
        add(_gauss(r) * 0.33, _gauss(r) * 0.33, _gauss(r) * 0.33);
      }
    case GalaxyShape.lenticular:
      for (var i = 0; i < 220; i++) {
        final s = i < 90 ? 0.14 : 0.36;
        add(_gauss(r) * s, _gauss(r) * s, _gauss(r) * 0.05);
      }
    case GalaxyShape.irregular:
      for (var i = 0; i < 180; i++) {
        final cx = (i % 3 - 1) * 0.25;
        add(cx + _gauss(r) * 0.25, _gauss(r) * 0.3, _gauss(r) * 0.12);
      }
    case GalaxyShape.spiral:
    case GalaxyShape.barred:
    case GalaxyShape.unknown:
      for (var i = 0; i < 60; i++) {
        add(_gauss(r) * 0.09, _gauss(r) * 0.09, _gauss(r) * 0.05);
      }
      if (shape == GalaxyShape.barred) {
        for (var i = 0; i < 40; i++) {
          add(_gauss(r) * 0.2, _gauss(r) * 0.04, _gauss(r) * 0.02);
        }
      }
      final k = math.tan(15 * math.pi / 180);
      for (var arm = 0; arm < 2; arm++) {
        for (var i = 0; i < 90; i++) {
          final radius = 0.18 + r.nextDouble() * 0.8;
          final angle = arm * math.pi + math.log(radius / 0.18) / k;
          final spread = 0.03 + radius * 0.05;
          add(radius * math.cos(angle) + _gauss(r) * spread,
              radius * math.sin(angle) + _gauss(r) * spread, _gauss(r) * 0.015);
        }
      }
  }
  return GalaxyTemplate(x, y, z);
}

/// The three axes of a galaxy's disk from how we see it: its direction in
/// the sky, the position angle of its long axis and its axis ratio. Returns
/// the long axis, the second axis in the disk and the disk's normal.
List<V3> galaxyAxes(V3 base, double positionAngleDeg, double axisRatio) {
  final d = base.unit;
  final ra = math.atan2(d.y, d.x);
  final dec = math.asin(d.z.clamp(-1.0, 1.0));
  final east = V3(-math.sin(ra), math.cos(ra), 0);
  final north =
      V3(-math.sin(dec) * math.cos(ra), -math.sin(dec) * math.sin(ra), math.cos(dec));
  final pa = _rad(positionAngleDeg);
  final major = north * math.cos(pa) + east * math.sin(pa);
  final minor = east * math.cos(pa) - north * math.sin(pa);
  final tilt = math.acos(axisRatio.clamp(0.05, 1.0));
  final normal = (d * math.cos(tilt) + minor * math.sin(tilt)).unit;
  final second = normal.cross(major).unit;
  return <V3>[major, second, normal];
}

// ---------------------------------------------------------------------------
// Zoom levels and time speeds

/// Named steps of the zoom, by the camera's distance from what it looks at.
enum ULevel { solarSystem, stars, milkyWay, localGroup, galaxies, universe }

/// Camera distance, in light-years, each level opens at.
const Map<ULevel, double> levelDistance = <ULevel, double>{
  ULevel.solarSystem: 0.0011,
  ULevel.stars: 45,
  ULevel.milkyWay: 190000,
  ULevel.localGroup: 6.5e6,
  ULevel.galaxies: 3.2e8,
  ULevel.universe: 1.4e11,
};

/// The level a camera [dist] light-years away belongs to.
ULevel levelFor(double dist) {
  if (dist < 0.3) {
    return ULevel.solarSystem;
  }
  if (dist < 20000) {
    return ULevel.stars;
  }
  if (dist < 1.2e6) {
    return ULevel.milkyWay;
  }
  if (dist < 4e7) {
    return ULevel.localGroup;
  }
  if (dist < 6e9) {
    return ULevel.galaxies;
  }
  return ULevel.universe;
}

/// How fast the map's clock runs.
enum USpeed { real, dayPerSecond, yearPerSecond, millionPerSecond, fastest }

/// Years of map time per second of real time.
double yearsPerSecond(USpeed s) {
  switch (s) {
    case USpeed.real:
      return 1 / (365.25 * 86400);
    case USpeed.dayPerSecond:
      return 1 / 365.25;
    case USpeed.yearPerSecond:
      return 1;
    case USpeed.millionPerSecond:
      return 1e6;
    case USpeed.fastest:
      return 25e6;
  }
}
