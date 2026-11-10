import 'dart:math' as math;

import 'orbits.dart';

// Positions of the moons of Jupiter and Saturn for any date.
//
// Jupiter: the four Galilean moons, Jean Meeus, Astronomical Algorithms
// (2nd ed.), chapter 44, low accuracy method.
// Saturn: the eight major moons, Meeus chapter 46 (theory of Harper and Taylor).
// The formulas are ported from the MIT licensed library "astronomia" by Sonia
// Keys and commenthol, through the same code that runs on astryl.space.
//
// Results are in planet equatorial radii as seen from Earth: x to the west,
// y to the north, z towards Earth. A moon with z below 0 is farther away than
// the planet.

/// Where a moon is, as seen from Earth, in radii of its planet.
class MoonPosition {
  const MoonPosition(this.x, this.y, this.z);

  /// West is positive.
  final double x;

  /// North is positive.
  final double y;

  /// Towards Earth is positive.
  final double z;

  /// Distance from the planet's centre in the picture.
  double get apparentDistance => math.sqrt(x * x + y * y);
}

const double _d = math.pi / 180;

(double, double) _sincos(double x) => (math.sin(x), math.cos(x));

double _hypot(double a, double b) => math.sqrt(a * a + b * b);

double _lightTime(double dist) => 0.0057755183 * dist;

double _horner(double x, List<double> c) {
  var i = c.length - 1;
  var y = c[i];
  while (i > 0) {
    i--;
    y = y * x + c[i];
  }
  return y;
}

/// Io, Europa, Ganymede and Callisto, in this order.
List<MoonPosition> jupiterMoons(DateTime date) {
  const p = _d;
  final dd0 = julianDay(date) - 2451545.0;
  final v = 172.74 * p + 0.00111588 * p * dd0;
  final m = 357.529 * p + 0.9856003 * p * dd0;
  final sV = math.sin(v);
  final n = 20.02 * p + 0.0830853 * p * dd0 + 0.329 * p * sV;
  final j = 66.115 * p + 0.9025179 * p * dd0 - 0.329 * p * sV;
  final (sM, cM) = _sincos(m);
  final (sN, cN) = _sincos(n);
  final (s2M, c2M) = _sincos(2 * m);
  final (s2N, c2N) = _sincos(2 * n);
  final a = 1.915 * p * sM + 0.02 * p * s2M;
  final b = 5.555 * p * sN + 0.168 * p * s2N;
  final k = j + a - b;
  final sunDist = 1.00014 - 0.01671 * cM - 0.00014 * c2M;
  final r = 5.20872 - 0.25208 * cN - 0.00611 * c2N;
  final (sK, cK) = _sincos(k);
  final delta = math.sqrt(r * r + sunDist * sunDist - 2 * r * sunDist * cK);
  final psi = math.asin(sunDist / delta * sK);
  final lam = 34.35 * p + 0.083091 * p * dd0 + 0.329 * p * sV + b;
  final ds = 3.12 * p * math.sin(lam + 42.8 * p);
  final de = ds -
      2.22 * p * math.sin(psi) * math.cos(lam + 22 * p) -
      ((1.3 * p * (r - delta)) / delta) * math.sin(lam - 100.5 * p);
  final dd = dd0 - delta / 173;
  final u1 = 163.8069 * p + 203.4058646 * p * dd + psi - b;
  final u2 = 358.414 * p + 101.2916335 * p * dd + psi - b;
  final u3 = 5.7176 * p + 50.234518 * p * dd + psi - b;
  final u4 = 224.8092 * p + 21.48798 * p * dd + psi - b;
  final g = 331.18 * p + 50.310482 * p * dd;
  final h = 87.45 * p + 21.569231 * p * dd;
  final (s212, c212) = _sincos(2 * (u1 - u2));
  final (s223, c223) = _sincos(2 * (u2 - u3));
  final (sG, cG) = _sincos(g);
  final (sH, cH) = _sincos(h);
  final c1 = 0.473 * p * s212;
  final c2 = 1.065 * p * s223;
  final c3 = 0.165 * p * sG;
  final c4 = 0.843 * p * sH;
  final r1 = 5.9057 - 0.0244 * c212;
  final r2 = 9.3966 - 0.0882 * c223;
  final r3 = 14.9883 - 0.0216 * cG;
  final r4 = 26.3627 - 0.1939 * cH;
  final sDE = math.sin(de);
  final cDE = math.cos(de);
  MoonPosition xy(double u, double rr) {
    final (su, cu) = _sincos(u);
    return MoonPosition(rr * su, -rr * cu * sDE, -rr * cu * cDE);
  }

  return <MoonPosition>[
    xy(u1 + c1, r1),
    xy(u2 + c2, r2),
    xy(u3 + c3, r3),
    xy(u4 + c4, r4),
  ];
}

class _R4 {
  double lam = 0;
  double r = 0;
  double gam = 0;
  double om = 0;
}

const List<int> _ksat = <int>[
  0,
  20947,
  23715,
  26382,
  29876,
  35313,
  53800,
  59222,
  91820,
];

/// The periodic quantities of the Saturn theory for one moment.
class _Qs {
  _Qs(double jde) {
    t1 = jde - 2411093;
    t2 = t1 / 365.25;
    t3 = (jde - 2433282.423) / 365.25 + 1950;
    t4 = jde - 2411368;
    t5 = t4 / 365.25;
    t6 = jde - 2415020;
    t7 = t6 / 36525;
    t8 = t6 / 365.25;
    t9 = (jde - 2442000.5) / 365.25;
    t10 = jde - 2409786;
    t11 = t10 / 36525;
    w0 = 5.095 * _d * (t3 - 1866.39);
    w1 = 74.4 * _d + 32.39 * _d * t2;
    w2 = 134.3 * _d + 92.62 * _d * t2;
    w3 = 42 * _d - 0.5118 * _d * t5;
    w4 = 276.59 * _d + 0.5118 * _d * t5;
    w5 = 267.2635 * _d + 1222.1136 * _d * t7;
    w6 = 175.4762 * _d + 1221.5515 * _d * t7;
    w7 = 2.4891 * _d + 0.002435 * _d * t7;
    w8 = 113.35 * _d - 0.2597 * _d * t7;
    s1 = math.sin(28.0817 * _d);
    c1 = math.cos(28.0817 * _d);
    s2 = math.sin(168.8112 * _d);
    c2 = math.cos(168.8112 * _d);
    e1 = 0.05589 - 0.000346 * t7;
    sW0 = math.sin(w0);
    s3W0 = math.sin(3 * w0);
    s5W0 = math.sin(5 * w0);
    sW1 = math.sin(w1);
    sW2 = math.sin(w2);
    sW3 = math.sin(w3);
    cW3 = math.cos(w3);
    sW4 = math.sin(w4);
    cW4 = math.cos(w4);
    sW7 = math.sin(w7);
    cW7 = math.cos(w7);
  }

  late final double t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11;
  late final double w0, w1, w2, w3, w4, w5, w6, w7, w8;
  late final double s1, c1, s2, c2, e1;
  late final double sW0, s3W0, s5W0, sW1, sW2, sW3, cW3, sW4, cW4, sW7, cW7;

  _R4 mimas() {
    final r = _R4();
    final l = 127.64 * _d +
        381.994497 * _d * t1 -
        43.57 * _d * sW0 -
        0.72 * _d * s3W0 -
        0.02144 * _d * s5W0;
    final p = 106.1 * _d + 365.549 * _d * t2;
    final m = l - p;
    final c = 2.18287 * _d * math.sin(m) +
        0.025988 * _d * math.sin(2 * m) +
        0.00043 * _d * math.sin(3 * m);
    r.lam = l + c;
    r.r = 3.06879 / (1 + 0.01905 * math.cos(m + c));
    r.gam = 1.563 * _d;
    r.om = 54.5 * _d - 365.072 * _d * t2;
    return r;
  }

  _R4 enceladus() {
    final r = _R4();
    final l = 200.317 * _d +
        262.7319002 * _d * t1 +
        0.25667 * _d * sW1 +
        0.20883 * _d * sW2;
    final p = 309.107 * _d + 123.44121 * _d * t2;
    final m = l - p;
    final c = 0.55577 * _d * math.sin(m) + 0.00168 * _d * math.sin(2 * m);
    r.lam = l + c;
    r.r = 3.94118 / (1 + 0.00485 * math.cos(m + c));
    r.gam = 0.0262 * _d;
    r.om = 348 * _d - 151.95 * _d * t2;
    return r;
  }

  _R4 tethys() {
    final r = _R4();
    r.lam = 285.306 * _d +
        190.69791226 * _d * t1 +
        2.063 * _d * sW0 +
        0.03409 * _d * s3W0 +
        0.001015 * _d * s5W0;
    r.r = 4.880998;
    r.gam = 1.0976 * _d;
    r.om = 111.33 * _d - 72.2441 * _d * t2;
    return r;
  }

  _R4 dione() {
    final r = _R4();
    final l = 254.712 * _d +
        131.53493193 * _d * t1 -
        0.0215 * _d * sW1 -
        0.01733 * _d * sW2;
    final p = 174.8 * _d + 30.82 * _d * t2;
    final m = l - p;
    final c = 0.24717 * _d * math.sin(m) + 0.00033 * _d * math.sin(2 * m);
    r.lam = l + c;
    r.r = 6.24871 / (1 + 0.002157 * math.cos(m + c));
    r.gam = 0.0139 * _d;
    r.om = 232 * _d - 30.27 * _d * t2;
    return r;
  }

  _R4 rhea() {
    final p0 = 342.7 * _d + 10.057 * _d * t2;
    final (sp0, cp0) = _sincos(p0);
    final a1 = 0.000265 * sp0 + 0.001 * sW4;
    final a2 = 0.000265 * cp0 + 0.001 * cW4;
    final e = _hypot(a1, a2);
    final p = math.atan2(a1, a2);
    final n = 345 * _d - 10.057 * _d * t2;
    final (sN, cN) = _sincos(n);
    final lam0 = 359.244 * _d + 79.6900472 * _d * t1 + 0.086754 * _d * sN;
    final i = 28.0362 * _d + 0.346898 * _d * cN + 0.0193 * _d * cW3;
    final om = 168.8034 * _d + 0.736936 * _d * sN + 0.041 * _d * sW3;
    const a = 8.725924;
    return _subr(lam0, p, e, a, om, i);
  }

  /// Turns orbital elements into the position values.
  _R4 _subr(
      double lam0, double p, double e, double a, double om, double i) {
    final r = _R4();
    final m = lam0 - p;
    final e2 = e * e;
    final e3 = e2 * e;
    final e4 = e2 * e2;
    final e5 = e3 * e2;
    final c = (2 * e - 0.25 * e3 + 0.0520833333 * e5) * math.sin(m) +
        (1.25 * e2 - 0.458333333 * e4) * math.sin(2 * m) +
        (1.083333333 * e3 - 0.671875 * e5) * math.sin(3 * m) +
        1.072917 * e4 * math.sin(4 * m) +
        1.142708 * e5 * math.sin(5 * m);
    r.r = (a * (1 - e2)) / (1 + e * math.cos(m + c));
    final g = om - 168.8112 * _d;
    final (si, ci) = _sincos(i);
    final (sg, cg) = _sincos(g);
    final a1 = si * sg;
    final a2 = c1 * si * cg - s1 * ci;
    r.gam = math.asin(_hypot(a1, a2));
    final u = math.atan2(a1, a2);
    r.om = 168.8112 * _d + u;
    final h = c1 * si - s1 * ci * cg;
    final psi = math.atan2(s1 * sg, h);
    r.lam = lam0 + c + u - g - psi;
    return r;
  }

  _R4 titan() {
    final l = 261.1582 * _d + 22.57697855 * _d * t4 + 0.074025 * _d * sW3;
    final i0 = 27.45141 * _d + 0.295999 * _d * cW3;
    final om0 = 168.66925 * _d + 0.628808 * _d * sW3;
    final (si0, ci0) = _sincos(i0);
    final (sOmW8, cOmW8) = _sincos(om0 - w8);
    final a1 = sW7 * sOmW8;
    final a2 = cW7 * si0 - sW7 * ci0 * cOmW8;
    const g0 = 102.8623 * _d;
    final psi = math.atan2(a1, a2);
    final s = _hypot(a1, a2);
    var g = w4 - om0 - psi;
    var varpi = 0.0;
    final (s2g0, c2g0) = _sincos(2 * g0);
    for (var n = 0; n < 3; n++) {
      varpi = w4 + 0.37515 * _d * (math.sin(2 * g) - s2g0);
      g = varpi - om0 - psi;
    }
    final e0 = 0.029092 + 0.00019048 * (math.cos(2 * g) - c2g0);
    final qq = 2 * (w5 - varpi);
    final b1 = si0 * sOmW8;
    final b2 = cW7 * si0 * cOmW8 - sW7 * ci0;
    final theta = math.atan2(b1, b2) + w8;
    final (sq, cq) = _sincos(qq);
    final e = e0 + 0.002778797 * e0 * cq;
    final p = varpi + 0.159215 * _d * sq;
    final u = 2 * w5 - 2 * theta + psi;
    final (su, cu) = _sincos(u);
    final h = 0.9375 * e0 * e0 * sq + 0.1875 * s * s * math.sin(2 * (w5 - theta));
    final lam0 = l -
        0.254744 *
            _d *
            (e1 * math.sin(w6) + 0.75 * e1 * e1 * math.sin(2 * w6) + h);
    final i = i0 + 0.031843 * _d * s * cu;
    final om = om0 + (0.031843 * _d * s * su) / si0;
    const a = 20.216193;
    return _subr(lam0, p, e, a, om, i);
  }

  _R4 hyperion() {
    final eta = 92.39 * _d + 0.5621071 * _d * t6;
    final zeta = 148.19 * _d - 19.18 * _d * t8;
    final theta = 184.8 * _d - 35.41 * _d * t9;
    final theta0 = theta - 7.5 * _d;
    final as0 = 176 * _d + 12.22 * _d * t8;
    final bs = 8 * _d + 24.44 * _d * t8;
    final cs = bs + 5 * _d;
    final varpi = 69.898 * _d - 18.67088 * _d * t8;
    final phi = 2 * (varpi - w5);
    final chi = 94.9 * _d - 2.292 * _d * t8;
    final (sEta, cEta) = _sincos(eta);
    final (sZeta, cZeta) = _sincos(zeta);
    final (s2Zeta, c2Zeta) = _sincos(2 * zeta);
    final (s3Zeta, c3Zeta) = _sincos(3 * zeta);
    final (sZpE, cZpE) = _sincos(zeta + eta);
    final (sZmE, cZmE) = _sincos(zeta - eta);
    final (sPhi, cPhi) = _sincos(phi);
    final (sChi, cChi) = _sincos(chi);
    final (scs, ccs) = _sincos(cs);
    final a = 24.50601 - 0.08686 * cEta - 0.00166 * cZpE + 0.00175 * cZmE;
    final e = 0.103458 -
        0.004099 * cEta -
        0.000167 * cZpE +
        0.000235 * cZmE +
        0.02303 * cZeta -
        0.00212 * c2Zeta +
        0.000151 * c3Zeta +
        0.00013 * cPhi;
    final p = varpi +
        0.15648 * _d * sChi -
        0.4457 * _d * sEta -
        0.2657 * _d * sZpE -
        0.3573 * _d * sZmE -
        12.872 * _d * sZeta +
        1.668 * _d * s2Zeta -
        0.2419 * _d * s3Zeta -
        0.07 * _d * sPhi;
    final lam0 = 177.047 * _d +
        16.91993829 * _d * t6 +
        0.15648 * _d * sChi +
        9.142 * _d * sEta +
        0.007 * _d * math.sin(2 * eta) -
        0.014 * _d * math.sin(3 * eta) +
        0.2275 * _d * sZpE +
        0.2112 * _d * sZmE -
        0.26 * _d * sZeta -
        0.0098 * _d * s2Zeta -
        0.013 * _d * math.sin(as0) +
        0.017 * _d * math.sin(bs) -
        0.0303 * _d * sPhi;
    final i = 27.3347 * _d +
        0.6434886 * _d * cChi +
        0.315 * _d * cW3 +
        0.018 * _d * math.cos(theta) -
        0.018 * _d * ccs;
    final om = 168.6812 * _d +
        1.40136 * _d * cChi +
        0.68599 * _d * sW3 -
        0.0392 * _d * scs +
        0.0366 * _d * math.sin(theta0);
    return _subr(lam0, p, e, a, om, i);
  }

  _R4 iapetus() {
    final l = 261.1582 * _d + 22.57697855 * _d * t4;
    final varpi1 = 91.796 * _d + 0.562 * _d * t7;
    final psi = 4.367 * _d - 0.195 * _d * t7;
    final theta = 146.819 * _d - 3.198 * _d * t7;
    final phi = 60.47 * _d + 1.521 * _d * t7;
    final bigPhi = 205.055 * _d - 2.091 * _d * t7;
    final e0 = 0.028298 + 0.001156 * t11;
    final varpi0 = 352.91 * _d + 11.71 * _d * t11;
    final mu = 76.3852 * _d + 4.53795125 * _d * t10;
    final i0 = _horner(t11, <double>[
      18.4602 * _d,
      -0.9518 * _d,
      -0.072 * _d,
      0.0054 * _d,
    ]);
    final om0 = _horner(t11, <double>[
      143.198 * _d,
      -3.919 * _d,
      0.116 * _d,
      0.008 * _d,
    ]);
    final l0 = mu - varpi0;
    final g = varpi0 - om0 - psi;
    final g1 = varpi0 - om0 - phi;
    final ls = w5 - varpi1;
    final gs = varpi1 - theta;
    final lT = l - w4;
    final gT = w4 - bigPhi;
    final u1 = 2 * (l0 + g - ls - gs);
    final u2 = l0 + g1 - lT - gT;
    final u3 = l0 + 2 * (g - ls - gs);
    final u4 = lT + gT - g1;
    final u5 = 2 * (ls + gs);
    final (sl, cl) = _sincos(l0);
    final (su1, cu1) = _sincos(u1);
    final (su2, cu2) = _sincos(u2);
    final (su3, cu3) = _sincos(u3);
    final (su4, cu4) = _sincos(u4);
    final (slu2, clu2) = _sincos(l0 + u2);
    final (sg1gT, cg1gT) = _sincos(g1 - gT);
    final (su52g, cu52g) = _sincos(u5 - 2 * g);
    final (su5psi, cu5psi) = _sincos(u5 + psi);
    final (su2phi, cu2phi) = _sincos(u2 + phi);
    final (s5, c5) = _sincos(l0 + g1 + lT + gT + phi);
    final a = 58.935028 + 0.004638 * cu1 + 0.058222 * cu2;
    final e = e0 -
        0.0014097 * cg1gT +
        0.0003733 * cu52g +
        0.000118 * cu3 +
        0.0002408 * cl +
        0.0002849 * clu2 +
        0.000619 * cu4;
    final w = 0.08077 * _d * sg1gT +
        0.02139 * _d * su52g -
        0.00676 * _d * su3 +
        0.0138 * _d * sl +
        0.01632 * _d * slu2 +
        0.03547 * _d * su4;
    final p = varpi0 + w / e0;
    final lam0 = mu -
        0.04299 * _d * su2 -
        0.00789 * _d * su1 -
        0.06312 * _d * math.sin(ls) -
        0.00295 * _d * math.sin(2 * ls) -
        0.02231 * _d * math.sin(u5) +
        0.0065 * _d * su5psi;
    final i = i0 + 0.04204 * _d * cu5psi + 0.00235 * _d * c5 + 0.0036 * _d * cu2phi;
    final w1x = 0.04204 * _d * su5psi + 0.00235 * _d * s5 + 0.00358 * _d * su2phi;
    final om = om0 + w1x / math.sin(i0);
    return _subr(lam0, p, e, a, om, i);
  }
}

// Precession of the ecliptic from J2000 to B1950 (t = -0.5 centuries).
const double _asec = math.pi / 180 / 3600;
const double _precT = -0.5;
const double _zetaP =
    (2306.2181 * _precT + 0.30188 * _precT * _precT + 0.017998 * _precT * _precT * _precT) * _asec;
const double _zP =
    (2306.2181 * _precT + 1.09468 * _precT * _precT + 0.018203 * _precT * _precT * _precT) * _asec;
const double _thetaP =
    (2004.3109 * _precT - 0.42665 * _precT * _precT - 0.041833 * _precT * _precT * _precT) * _asec;
const double _eps2000 = 23.4392911 * _d;
const double _eps1950 = 23.4457889 * _d;

/// Mimas, Enceladus, Tethys, Dione, Rhea, Titan, Hyperion and Iapetus, in
/// this order.
List<MoonPosition> saturnMoons(DateTime date) {
  final at = clampOrbitDate(date.toUtc());
  final earth = heliocentricPosition('earth', at);
  var dist = 9.0;
  var x = 0.0, y = 0.0, z = 0.0;
  var date2 = date.toUtc();
  for (var n = 0; n < 2; n++) {
    date2 = date.toUtc().subtract(
        Duration(microseconds: (_lightTime(dist) * 86400e6).round()));
    final s = heliocentricPosition('saturn', clampOrbitDate(date2));
    x = s.x - earth.x;
    y = s.y - earth.y;
    z = s.z - earth.z;
    dist = math.sqrt(x * x + y * y + z * z);
  }
  final delta = dist;
  final jde2 = julianDay(date2);

  // J2000 ecliptic -> J2000 equatorial -> precess to B1950 -> B1950 ecliptic.
  final ce = math.cos(_eps2000), se = math.sin(_eps2000);
  final ex = x, ey = y * ce - z * se, ez = y * se + z * ce;
  final ra = math.atan2(ey, ex);
  final dec = math.atan2(ez, _hypot(ex, ey));
  final a1 = math.cos(dec) * math.sin(ra + _zetaP);
  final b1 = math.cos(dec) * math.cos(ra + _zetaP) * math.cos(_thetaP) -
      math.sin(dec) * math.sin(_thetaP);
  final c1p = math.cos(dec) * math.cos(ra + _zetaP) * math.sin(_thetaP) +
      math.sin(dec) * math.cos(_thetaP);
  final ra2 = math.atan2(a1, b1) + _zP;
  final dec2 = math.asin(c1p);
  final c2e = math.cos(_eps1950), s2e = math.sin(_eps1950);
  final qx = math.cos(dec2) * math.cos(ra2);
  final qy = math.cos(dec2) * math.sin(ra2);
  final qz = math.sin(dec2);
  final fx = qx, fy = qy * c2e + qz * s2e, fz = -qy * s2e + qz * c2e;
  final lam0 = math.atan2(fy, fx);
  final bet0 = math.atan2(fz, _hypot(fx, fy));

  final q = _Qs(jde2);
  final s4 = <_R4>[
    _R4(),
    q.mimas(),
    q.enceladus(),
    q.tethys(),
    q.dione(),
    q.rhea(),
    q.titan(),
    q.hyperion(),
    q.iapetus(),
  ];

  final xs = List<double>.filled(9, 0);
  final ys = List<double>.filled(9, 0);
  final zs = List<double>.filled(9, 0);
  for (var j = 1; j <= 8; j++) {
    final u = s4[j].lam - s4[j].om;
    final w = s4[j].om - 168.8112 * _d;
    final (su, cu) = _sincos(u);
    final (sw, cw) = _sincos(w);
    final (sg, cg) = _sincos(s4[j].gam);
    final r = s4[j].r;
    xs[j] = r * (cu * cw - su * cg * sw);
    ys[j] = r * (su * cw * cg + cu * sw);
    zs[j] = r * su * sg;
  }
  zs[0] = 1;
  final (sl0, cl0) = _sincos(lam0);
  final (sb0, cb0) = _sincos(bet0);
  final aa = List<double>.filled(9, 0);
  final bb = List<double>.filled(9, 0);
  final cc = List<double>.filled(9, 0);
  for (var j = 0; j < 9; j++) {
    var a = xs[j];
    var b = q.c1 * ys[j] - q.s1 * zs[j];
    final c = q.s1 * ys[j] + q.c1 * zs[j];
    final a0 = q.c2 * a - q.s2 * b;
    b = q.s2 * a + q.c2 * b;
    a = a0;
    aa[j] = a * sl0 - b * cl0;
    b = a * cl0 + b * sl0;
    bb[j] = b * cb0 + c * sb0;
    cc[j] = c * cb0 - b * sb0;
  }

  final out = <MoonPosition>[];
  final dd = math.atan2(aa[0], cc[0]);
  final (sD, cD) = _sincos(dd);
  for (var j = 1; j <= 8; j++) {
    var px = aa[j] * cD - cc[j] * sD;
    final py = aa[j] * sD + cc[j] * cD;
    final pz = bb[j];
    final dx = px / s4[j].r;
    px += (pz.abs() / _ksat[j]) * math.sqrt(1 - dx * dx);
    final wv = delta / (delta + pz / 2475);
    out.add(MoonPosition(px * wv, py * wv, pz));
  }
  return out;
}

/// How far the rings of Saturn are tilted towards Earth, in degrees. Positive
/// when Earth is north of the ring plane (Meeus, chapter 45).
double saturnRingTilt(DateTime date) {
  final at = clampOrbitDate(date.toUtc());
  final earth = heliocentricPosition('earth', at);
  final when = date.toUtc().subtract(
      Duration(microseconds: (_lightTime(9.2) * 86400e6).round()));
  final s = heliocentricPosition('saturn', clampOrbitDate(when));
  final x = s.x - earth.x, y = s.y - earth.y, z = s.z - earth.z;
  final lam = math.atan2(y, x);
  final bet = math.atan2(z, _hypot(x, y));
  const inc = 28.075216 * _d;
  const node = 169.50847 * _d;
  return math.asin(math.sin(inc) * math.cos(bet) * math.sin(lam - node) -
          math.cos(inc) * math.sin(bet)) /
      _d;
}
