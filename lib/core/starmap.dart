import 'dart:math' as math;
import 'dart:ui' show Offset;

import '../data/sky_catalog.dart';
import 'orbits.dart';
import 'sky.dart';

/// Star map maths: where the catalogue stars, the constellations, the Sun,
/// the Moon and the planets are in the sky of a place at a moment, and how
/// to draw that sky on a screen. Everything runs on the phone.

double _rad(double d) => d * math.pi / 180;
double _deg(double r) => r * 180 / math.pi;

/// Moves a J2000 position to the equinox of [date] (IAU 1976 precession), so
/// stars and planets sit where the phone's clock puts them. The shift is
/// about 0.4 degrees today.
Equatorial precessFromJ2000(Equatorial eq, DateTime date) {
  final t = (julianDay(date) - 2451545.0) / 36525.0;
  const arc = math.pi / (180 * 3600);
  final zeta = (2306.2181 * t + 0.30188 * t * t + 0.017998 * t * t * t) * arc;
  final z = (2306.2181 * t + 1.09468 * t * t + 0.018203 * t * t * t) * arc;
  final theta =
      (2004.3109 * t - 0.42665 * t * t - 0.041833 * t * t * t) * arc;
  final a = _rad(eq.ra), d = _rad(eq.dec);
  final aa = math.cos(d) * math.sin(a + zeta);
  final bb = math.cos(theta) * math.cos(d) * math.cos(a + zeta) -
      math.sin(theta) * math.sin(d);
  final cc = math.sin(theta) * math.cos(d) * math.cos(a + zeta) +
      math.cos(theta) * math.sin(d);
  var ra = _deg(math.atan2(aa, bb) + z) % 360;
  if (ra < 0) ra += 360;
  return Equatorial(ra, _deg(math.asin(cc.clamp(-1.0, 1.0))));
}

/// The sky above a place at one moment, ready to draw.
class SkyFrame {
  SkyFrame._({
    required this.date,
    required this.lat,
    required this.lon,
    required this.stars,
    required this.lines,
    required this.centres,
    required this.bodies,
  });

  final DateTime date;
  final double lat;
  final double lon;

  /// One entry for each of [catalogStars].
  final List<Horizontal> stars;

  /// For each of [catalogConstellations], its lines as points in the sky.
  final List<List<List<Horizontal>>> lines;

  /// For each constellation, the middle of its figure.
  final List<Horizontal> centres;

  /// The Sun, the Moon and the planets by id.
  final Map<String, Horizontal> bodies;

  /// Works out the sky for [date] at [lat], [lon].
  factory SkyFrame.at(DateTime date, double lat, double lon) {
    Horizontal place(double ra, double dec) {
      final eq = precessFromJ2000(Equatorial(ra, dec), date);
      return toHorizontal(eq, date, lat, lon);
    }

    final stars = <Horizontal>[
      for (final s in catalogStars) place(s.ra, s.dec),
    ];
    final lines = <List<List<Horizontal>>>[
      for (final c in catalogConstellations)
        <List<Horizontal>>[
          for (final line in c.lines)
            <Horizontal>[
              for (var i = 0; i + 1 < line.length; i += 2)
                place(line[i], line[i + 1]),
            ],
        ],
    ];
    final centres = <Horizontal>[
      for (final c in catalogConstellations) place(c.ra, c.dec),
    ];
    final bodies = <String, Horizontal>{};
    for (final id in <String>['sun', 'moon', ...skyPlanets]) {
      final eq = precessFromJ2000(equatorialOf(id, date), date);
      bodies[id] = toHorizontal(eq, date, lat, lon);
    }
    return SkyFrame._(
      date: date,
      lat: lat,
      lon: lon,
      stars: stars,
      lines: lines,
      centres: centres,
      bodies: bodies,
    );
  }
}

/// A stereographic view of the sky: [centerAz] and [centerAlt] are the
/// direction in the middle of the screen, [fov] the angle across the
/// screen's width, all in degrees. Azimuth grows to the right, as when you
/// face a direction and look up.
class SkyView {
  const SkyView({
    required this.centerAz,
    required this.centerAlt,
    required this.fov,
    required this.width,
    required this.height,
  });

  final double centerAz;
  final double centerAlt;
  final double fov;
  final double width;
  final double height;

  /// Pixels for one unit of the stereographic plane.
  double get scale => (width / 2) / (2 * math.tan(_rad(fov) / 4));

  /// Where [h] falls on the screen, or null if it is too far from the
  /// middle of the view to draw (more than about 100 degrees away).
  Offset? project(Horizontal h) {
    final alt = _rad(h.altitude), az = _rad(h.azimuth - centerAz);
    final alt0 = _rad(centerAlt);
    final cosc = math.sin(alt0) * math.sin(alt) +
        math.cos(alt0) * math.cos(alt) * math.cos(az);
    if (cosc < -0.17) {
      return null;
    }
    final k = 2 / (1 + cosc);
    final x = k * math.cos(alt) * math.sin(az);
    final y = k *
        (math.cos(alt0) * math.sin(alt) -
            math.sin(alt0) * math.cos(alt) * math.cos(az));
    final s = scale;
    return Offset(width / 2 + x * s, height / 2 - y * s);
  }

  /// The direction under a screen point.
  Horizontal unproject(Offset p) {
    final s = scale;
    final x = (p.dx - width / 2) / s;
    final y = (height / 2 - p.dy) / s;
    final rho = math.sqrt(x * x + y * y);
    if (rho < 1e-9) {
      return Horizontal(centerAlt, centerAz);
    }
    final c = 2 * math.atan(rho / 2);
    final alt0 = _rad(centerAlt);
    final alt = math.asin(math.cos(c) * math.sin(alt0) +
        y * math.sin(c) * math.cos(alt0) / rho);
    final az = _rad(centerAz) +
        math.atan2(x * math.sin(c),
            rho * math.cos(alt0) * math.cos(c) - y * math.sin(alt0) * math.sin(c));
    var azDeg = _deg(az) % 360;
    if (azDeg < 0) azDeg += 360;
    return Horizontal(_deg(alt), azDeg);
  }
}

/// Angle in degrees between two directions in the sky.
double skyAngle(Horizontal a, Horizontal b) {
  final a1 = _rad(a.altitude), a2 = _rad(b.altitude);
  final d = _rad(a.azimuth - b.azimuth);
  final c = math.sin(a1) * math.sin(a2) +
      math.cos(a1) * math.cos(a2) * math.cos(d);
  return _deg(math.acos(c.clamp(-1.0, 1.0)));
}

/// The size of a star's dot for a magnitude: bright stars are bigger.
double starRadius(double mag) {
  final r = 3.2 - 0.55 * mag;
  return r.clamp(0.7, 5.5).toDouble();
}

/// Index of the constellation with IAU code [id], or -1.
int constellationIndex(String id) {
  for (var i = 0; i < catalogConstellations.length; i++) {
    if (catalogConstellations[i].id == id) {
      return i;
    }
  }
  return -1;
}
