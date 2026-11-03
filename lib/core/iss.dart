import 'dart:math' as math;

import 'sgp4.dart';
import 'sky.dart';

/// Where the International Space Station is, and when it flies over a
/// place. Positions come from SGP4 (sgp4.dart) and the orbit data (TLE)
/// that the app downloads once in a while, so after that everything works
/// without internet.

const double _wgsA = 6378.137;
const double _wgsF = 1 / 298.257223563;
const double _e2 = _wgsF * (2 - _wgsF);

double _rad(double d) => d * math.pi / 180;
double _deg(double r) => r * 180 / math.pi;

/// The station seen from space: point on Earth below it, height and speed.
class IssPosition {
  const IssPosition({
    required this.lat,
    required this.lon,
    required this.altitudeKm,
    required this.speedKmh,
    required this.ecef,
  });

  final double lat;
  final double lon;
  final double altitudeKm;
  final double speedKmh;

  /// Position in the Earth-fixed frame, km.
  final ({double x, double y, double z}) ecef;
}

({double x, double y, double z}) _toEcef(Teme p, DateTime t) {
  final th = _rad(siderealTime(t, 0));
  final c = math.cos(th), s = math.sin(th);
  return (x: p.x * c + p.y * s, y: -p.x * s + p.y * c, z: p.z);
}

/// Where the station is at [t], or null when the orbit data cannot be used.
IssPosition? issPosition(Sgp4 sat, DateTime t) {
  final p = sat.at(t);
  if (p == null) {
    return null;
  }
  final e = _toEcef(p, t);
  final lon = _deg(math.atan2(e.y, e.x));
  final r = math.sqrt(e.x * e.x + e.y * e.y);
  var lat = math.atan2(e.z, r * (1 - _e2));
  var h = 0.0;
  for (var i = 0; i < 6; i++) {
    final n = _wgsA / math.sqrt(1 - _e2 * math.sin(lat) * math.sin(lat));
    h = r / math.cos(lat) - n;
    lat = math.atan2(e.z, r * (1 - _e2 * n / (n + h)));
  }
  final speed = math.sqrt(p.vx * p.vx + p.vy * p.vy + p.vz * p.vz) * 3600;
  return IssPosition(
    lat: _deg(lat),
    lon: lon,
    altitudeKm: h,
    speedKmh: speed,
    ecef: e,
  );
}

/// Where the station is in the sky of a place.
class LookAngle {
  const LookAngle(this.elevation, this.azimuth, this.rangeKm);

  final double elevation;
  final double azimuth;
  final double rangeKm;
}

LookAngle lookAngle(
    ({double x, double y, double z}) ecef, double latDeg, double lonDeg) {
  final la = _rad(latDeg), lo = _rad(lonDeg);
  final n = _wgsA / math.sqrt(1 - _e2 * math.sin(la) * math.sin(la));
  final ox = n * math.cos(la) * math.cos(lo);
  final oy = n * math.cos(la) * math.sin(lo);
  final oz = n * (1 - _e2) * math.sin(la);
  final rx = ecef.x - ox, ry = ecef.y - oy, rz = ecef.z - oz;
  final east = -math.sin(lo) * rx + math.cos(lo) * ry;
  final north = -math.sin(la) * math.cos(lo) * rx -
      math.sin(la) * math.sin(lo) * ry +
      math.cos(la) * rz;
  final up = math.cos(la) * math.cos(lo) * rx +
      math.cos(la) * math.sin(lo) * ry +
      math.sin(la) * rz;
  final range = math.sqrt(east * east + north * north + up * up);
  var az = _deg(math.atan2(east, north));
  if (az < 0) {
    az += 360;
  }
  return LookAngle(_deg(math.asin(up / range)), az, range);
}

/// Distance over the Earth's surface between two places, km.
double greatCircleKm(double lat1, double lon1, double lat2, double lon2) {
  final p1 = _rad(lat1), p2 = _rad(lat2);
  final dl = _rad(lon2 - lon1);
  final c = math.sin(p1) * math.sin(p2) + math.cos(p1) * math.cos(p2) * math.cos(dl);
  return 6371.0 * math.acos(c.clamp(-1.0, 1.0).toDouble());
}

/// One flight of the station over a place.
class IssPass {
  const IssPass({
    required this.rise,
    required this.set,
    required this.peak,
    required this.maxElevation,
    required this.riseAzimuth,
    required this.peakAzimuth,
    required this.setAzimuth,
    required this.visible,
    this.satId = 'iss',
  });

  /// Which satellite: 'iss' for the space station, or the id of another one
  /// from `trackedSatellites`.
  final String satId;

  final DateTime rise;
  final DateTime set;

  /// The moment it is highest.
  final DateTime peak;
  final double maxElevation;
  final double riseAzimuth;
  final double peakAzimuth;
  final double setAzimuth;

  /// True when the sky is dark and the station is lit by the Sun, so it can
  /// be seen with the naked eye as a bright, fast "star".
  final bool visible;

  Duration get duration => set.difference(rise);

  /// Stays the same every time the passes are worked out again.
  String get id {
    final t = rise.toUtc();
    String two(int v) => v.toString().padLeft(2, '0');
    final prefix = satId == 'iss' ? 'iss:' : 'sat:$satId:';
    return '$prefix${t.year}${two(t.month)}${two(t.day)}${two(t.hour)}${two(t.minute)}';
  }
}

DateTime _at(int ms) => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);

/// True when the station at [p] is lit by the Sun, using a simple
/// cylindrical shadow of the Earth.
bool _sunlit(Teme p, DateTime t) {
  final sun = equatorialOf('sun', t);
  final ra = _rad(sun.ra), dec = _rad(sun.dec);
  final sx = math.cos(dec) * math.cos(ra);
  final sy = math.cos(dec) * math.sin(ra);
  final sz = math.sin(dec);
  final along = p.x * sx + p.y * sy + p.z * sz;
  if (along >= 0) {
    return true;
  }
  final px = p.x - along * sx, py = p.y - along * sy, pz = p.z - along * sz;
  return math.sqrt(px * px + py * py + pz * pz) > earthRadiusKm;
}

bool _isVisibleAt(Sgp4 sat, DateTime t, double lat, double lon) {
  final p = sat.at(t);
  if (p == null) {
    return false;
  }
  final sunAlt = toHorizontal(equatorialOf('sun', t), t, lat, lon).altitude;
  return sunAlt < -6 && _sunlit(p, t);
}

/// The flights of the station over a place in the next [days] days, soonest
/// first. Only flights that get at least [minElevation] degrees high count.
List<IssPass> findIssPasses(
  Sgp4 sat,
  DateTime from,
  double lat,
  double lon, {
  int days = 5,
  double minElevation = 10,
  String satId = 'iss',
}) {
  double elevationAt(int ms) {
    final t = _at(ms);
    final p = sat.at(t);
    if (p == null) {
      return -90;
    }
    return lookAngle(_toEcef(p, t), lat, lon).elevation;
  }

  double azimuthAt(int ms) {
    final t = _at(ms);
    final p = sat.at(t)!;
    return lookAngle(_toEcef(p, t), lat, lon).azimuth;
  }

  // The moment between a (below the horizon) and b (above), or the other
  // way round, where the elevation is zero.
  int cross(int a, int b) {
    final startAbove = elevationAt(a) > 0;
    var lo = a, hi = b;
    for (var i = 0; i < 20; i++) {
      final mid = lo + (hi - lo) ~/ 2;
      if ((elevationAt(mid) > 0) == startAbove) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return hi;
  }

  const step = 30000; // 30 seconds
  final start = from.toUtc().millisecondsSinceEpoch;
  final end = start + days * 86400000;
  final out = <IssPass>[];

  var t = start;
  var above = elevationAt(t) > 0;
  int? riseMs;
  if (above) {
    // Already up: the pass began before now, so start it from now.
    riseMs = t;
  }
  while (t < end) {
    final next = t + step;
    final nextAbove = elevationAt(next) > 0;
    if (!above && nextAbove) {
      riseMs = cross(t, next);
    } else if (above && !nextAbove && riseMs != null) {
      final setMs = cross(t, next);
      final pass = _buildPass(
          sat, riseMs, setMs, lat, lon, elevationAt, azimuthAt, satId);
      if (pass != null && pass.maxElevation >= minElevation) {
        out.add(pass);
      }
      riseMs = null;
    }
    above = nextAbove;
    t = next;
  }
  return out;
}

IssPass? _buildPass(
  Sgp4 sat,
  int riseMs,
  int setMs,
  double lat,
  double lon,
  double Function(int) elevationAt,
  double Function(int) azimuthAt,
  String satId,
) {
  if (setMs <= riseMs) {
    return null;
  }
  var peakMs = riseMs;
  var peakEl = -90.0;
  var visibleSeconds = 0;
  for (var ms = riseMs; ms <= setMs; ms += 10000) {
    final el = elevationAt(ms);
    if (el > peakEl) {
      peakEl = el;
      peakMs = ms;
    }
    if (el > 5 && _isVisibleAt(sat, _at(ms), lat, lon)) {
      visibleSeconds += 10;
    }
  }
  return IssPass(
    rise: _at(riseMs),
    set: _at(setMs),
    peak: _at(peakMs),
    maxElevation: peakEl,
    riseAzimuth: azimuthAt(riseMs + 1000 > setMs ? riseMs : riseMs + 1000),
    peakAzimuth: azimuthAt(peakMs),
    setAzimuth: azimuthAt(setMs - 1000 < riseMs ? setMs : setMs - 1000),
    visible: visibleSeconds >= 30,
    satId: satId,
  );
}

/// Points of the station's path on the ground from [before] to [after]
/// around [center], one point a minute.
List<({double lat, double lon})> groundTrack(
  Sgp4 sat,
  DateTime center, {
  Duration before = const Duration(minutes: 45),
  Duration after = const Duration(minutes: 100),
}) {
  final out = <({double lat, double lon})>[];
  final start = center.subtract(before);
  final minutes = (before + after).inMinutes;
  for (var m = 0; m <= minutes; m++) {
    final pos = issPosition(sat, start.add(Duration(minutes: m)));
    if (pos != null) {
      out.add((lat: pos.lat, lon: pos.lon));
    }
  }
  return out;
}
