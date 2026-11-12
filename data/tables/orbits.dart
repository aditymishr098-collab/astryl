import 'dart:math' as math;

/// Keplerian elements of one orbit at J2000 and how they change per century.
/// From "Keplerian Elements for Approximate Positions of the Major Planets"
/// (E. M. Standish, JPL), valid from 1800 to 2050.
class _Elements {
  const _Elements(
    this.a,
    this.aRate,
    this.e,
    this.eRate,
    this.i,
    this.iRate,
    this.l,
    this.lRate,
    this.peri,
    this.periRate,
    this.node,
    this.nodeRate,
  );

  /// Semi-major axis (au) and its rate.
  final double a, aRate;

  /// Eccentricity and its rate.
  final double e, eRate;

  /// Inclination (degrees) and its rate.
  final double i, iRate;

  /// Mean longitude (degrees) and its rate.
  final double l, lRate;

  /// Longitude of perihelion (degrees) and its rate.
  final double peri, periRate;

  /// Longitude of the ascending node (degrees) and its rate.
  final double node, nodeRate;
}

const Map<String, _Elements> _table = <String, _Elements>{
  'mercury': _Elements(0.38709927, 0.00000037, 0.20563593, 0.00001906,
      7.00497902, -0.00594749, 252.25032350, 149472.67411175, 77.45779628,
      0.16047689, 48.33076593, -0.12534081),
  'venus': _Elements(0.72333566, 0.00000390, 0.00677672, -0.00004107,
      3.39467605, -0.00078890, 181.97909950, 58517.81538729, 131.60246718,
      0.00268329, 76.67984255, -0.27769418),
  'earth': _Elements(1.00000261, 0.00000562, 0.01671123, -0.00004392,
      -0.00001531, -0.01294668, 100.46457166, 35999.37244981, 102.93768193,
      0.32327364, 0.0, 0.0),
  'mars': _Elements(1.52371034, 0.00001847, 0.09339410, 0.00007882,
      1.84969142, -0.00813131, -4.55343205, 19140.30268499, -23.94362959,
      0.44441088, 49.55953891, -0.29257343),
  'jupiter': _Elements(5.20288700, -0.00011607, 0.04838624, -0.00013253,
      1.30439695, -0.00183714, 34.39644051, 3034.74612775, 14.72847983,
      0.21252668, 100.47390909, 0.20469106),
  'saturn': _Elements(9.53667594, -0.00125060, 0.05386179, -0.00050991,
      2.48599187, 0.00193609, 49.95424423, 1222.49362201, 92.59887831,
      -0.41897216, 113.66242448, -0.28867794),
  'uranus': _Elements(19.18916464, -0.00196176, 0.04725744, -0.00004397,
      0.77263783, -0.00242939, 313.23810451, 428.48202785, 170.95427630,
      0.40805281, 74.01692503, 0.04240589),
  'neptune': _Elements(30.06992276, 0.00026291, 0.00859048, 0.00005105,
      1.77004347, 0.00035372, -55.12002969, 218.45945325, 44.96476227,
      -0.32241464, 131.78422574, -0.00508664),
  'pluto': _Elements(39.48211675, -0.00031596, 0.24882730, 0.00005170,
      17.14001206, 0.00004818, 238.92903833, 145.20780515, 224.06891629,
      -0.04062942, 110.30393684, -0.01183482),
};

/// Earliest and latest dates the formulas are good for.
final DateTime orbitMinDate = DateTime.utc(1800, 1, 1);
final DateTime orbitMaxDate = DateTime.utc(2050, 12, 31);

/// Keeps [date] inside the range the formulas are good for.
DateTime clampOrbitDate(DateTime date) {
  if (date.isBefore(orbitMinDate)) {
    return orbitMinDate;
  }
  if (date.isAfter(orbitMaxDate)) {
    return orbitMaxDate;
  }
  return date;
}

/// Julian day number for a moment in time.
double julianDay(DateTime date) =>
    date.toUtc().millisecondsSinceEpoch / 86400000.0 + 2440587.5;

double _rad(double degrees) => degrees * math.pi / 180;

/// True when the app knows the orbit of [id].
bool hasOrbit(String id) => _table.containsKey(id);

/// Position of a planet around the Sun on [date], in astronomical units, in
/// the ecliptic frame: x points to the March equinox direction, z points
/// north out of Earth's orbital plane.
({double x, double y, double z}) heliocentricPosition(String id, DateTime date) {
  final el = _table[id];
  if (el == null) {
    throw ArgumentError.value(id, 'id', 'No orbit for this body');
  }
  final t = (julianDay(date) - 2451545.0) / 36525.0;
  final a = el.a + el.aRate * t;
  final e = el.e + el.eRate * t;
  final inc = _rad(el.i + el.iRate * t);
  final l = el.l + el.lRate * t;
  final peri = el.peri + el.periRate * t;
  final node = _rad(el.node + el.nodeRate * t);
  final omega = _rad(peri) - node;

  // Mean anomaly, between -180 and 180 degrees.
  var m = (l - peri) % 360;
  if (m > 180) {
    m -= 360;
  }
  final mean = _rad(m);

  // Kepler's equation, solved by Newton's method.
  var ecc = mean + e * math.sin(mean);
  for (var k = 0; k < 10; k++) {
    final delta =
        (ecc - e * math.sin(ecc) - mean) / (1 - e * math.cos(ecc));
    ecc -= delta;
    if (delta.abs() < 1e-10) {
      break;
    }
  }

  final xp = a * (math.cos(ecc) - e);
  final yp = a * math.sqrt(1 - e * e) * math.sin(ecc);

  final cw = math.cos(omega), sw = math.sin(omega);
  final cn = math.cos(node), sn = math.sin(node);
  final ci = math.cos(inc), si = math.sin(inc);
  return (
    x: (cw * cn - sw * sn * ci) * xp + (-sw * cn - cw * sn * ci) * yp,
    y: (cw * sn + sw * cn * ci) * xp + (-sw * sn + cw * cn * ci) * yp,
    z: (sw * si) * xp + (cw * si) * yp,
  );
}

/// Heliocentric ecliptic longitude of a planet on [date], in degrees from
/// 0 to 360, measured from the March equinox direction. This is where the
/// planet really is around the Sun, seen from above the Solar System.
double heliocentricLongitude(String id, DateTime date) {
  final p = heliocentricPosition(id, date);
  var lon = math.atan2(p.y, p.x) * 180 / math.pi;
  if (lon < 0) {
    lon += 360;
  }
  return lon;
}

/// Kilometres in one astronomical unit.
const double kmPerAu = 149597870.7;

/// Distance in km between Earth and the planet [id] on [date]. 'sun' gives
/// the Earth to Sun distance.
double distanceFromEarthKm(String id, DateTime date) {
  final d = clampOrbitDate(date);
  final earth = heliocentricPosition('earth', d);
  if (id == 'sun') {
    return math.sqrt(earth.x * earth.x + earth.y * earth.y + earth.z * earth.z) *
        kmPerAu;
  }
  final p = heliocentricPosition(id, d);
  final dx = p.x - earth.x, dy = p.y - earth.y, dz = p.z - earth.z;
  return math.sqrt(dx * dx + dy * dy + dz * dz) * kmPerAu;
}

/// How old someone born on [birth] is on a body whose year lasts
/// [yearDays] Earth days, counted up to [now].
double ageOn(DateTime birth, DateTime now, double yearDays) {
  final days = now.difference(birth).inMinutes / 1440.0;
  return days / yearDays;
}

/// Whole Earth days until the next birthday on that body.
int daysToNextBirthday(DateTime birth, DateTime now, double yearDays) {
  final days = now.difference(birth).inMinutes / 1440.0;
  final next = ((days / yearDays).floor() + 1) * yearDays;
  return (next - days).ceil();
}
