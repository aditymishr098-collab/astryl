/* Astryl: positions of the moons of Jupiter and Saturn for any date.
 *
 * Jupiter: the four Galilean moons (Jean Meeus, Astronomical Algorithms, 2nd ed., chapter 44, low accuracy method).
 * Saturn: the eight major moons (Meeus chapter 46, from the theory of Harper and Taylor).
 * The formulas are ported from the MIT licensed library "astronomia" by Sonia Keys and commenthol.
 * Results are in planet equatorial radii as seen from Earth: x to the west, y to the north, z towards Earth.
 * The planet positions come from the same orbital elements as the rest of the site (window.ASTRYL_API.helio).
 */
(function () {
  'use strict';
  var API = window.ASTRYL_API;
  if (!API) { return; }
  var d = Math.PI / 180;
  function sincos(x) { return [Math.sin(x), Math.cos(x)]; }
  function horner(x) {
    var c = Array.prototype.slice.call(arguments, 1), i = c.length - 1, y = c[i];
    while (i > 0) { i--; y = y * x + c[i]; }
    return y;
  }
  function mk(x, y, z) { return { x: x, y: y, z: z }; }
  function lightTime(dist) { return 0.0057755183 * dist; }

function jupiterLow(jde) {
  const d = jde - 2451545
  const p = Math.PI / 180
  const V = 172.74 * p + 0.00111588 * p * d
  const M = 357.529 * p + 0.9856003 * p * d
  const sV = Math.sin(V)
  const N = 20.02 * p + 0.0830853 * p * d + 0.329 * p * sV
  const J = 66.115 * p + 0.9025179 * p * d - 0.329 * p * sV
  const [sM, cM] = sincos(M)
  const [sN, cN] = sincos(N)
  const [s2M, c2M] = sincos(2 * M)
  const [s2N, c2N] = sincos(2 * N)
  const A = 1.915 * p * sM + 0.02 * p * s2M
  const B = 5.555 * p * sN + 0.168 * p * s2N
  const K = J + A - B
  const R = 1.00014 - 0.01671 * cM - 0.00014 * c2M
  const r = 5.20872 - 0.25208 * cN - 0.00611 * c2N
  const [sK, cK] = sincos(K)
  const Δ = Math.sqrt(r * r + R * R - 2 * r * R * cK)
  const ψ = Math.asin((R / Δ) * sK)
  const λ = 34.35 * p + 0.083091 * p * d + 0.329 * p * sV + B
  const DS = 3.12 * p * Math.sin(λ + 42.8 * p)
  const DE =
    DS -
    2.22 * p * Math.sin(ψ) * Math.cos(λ + 22 * p) -
    ((1.3 * p * (r - Δ)) / Δ) * Math.sin(λ - 100.5 * p)
  const dd = d - Δ / 173
  const u1 = 163.8069 * p + 203.4058646 * p * dd + ψ - B
  const u2 = 358.414 * p + 101.2916335 * p * dd + ψ - B
  const u3 = 5.7176 * p + 50.234518 * p * dd + ψ - B
  const u4 = 224.8092 * p + 21.48798 * p * dd + ψ - B
  const G = 331.18 * p + 50.310482 * p * dd
  const H = 87.45 * p + 21.569231 * p * dd
  const [s212, c212] = sincos(2 * (u1 - u2))
  const [s223, c223] = sincos(2 * (u2 - u3))
  const [sG, cG] = sincos(G)
  const [sH, cH] = sincos(H)
  const c1 = 0.473 * p * s212
  const c2 = 1.065 * p * s223
  const c3 = 0.165 * p * sG
  const c4 = 0.843 * p * sH
  const r1 = 5.9057 - 0.0244 * c212
  const r2 = 9.3966 - 0.0882 * c223
  const r3 = 14.9883 - 0.0216 * cG
  const r4 = 26.3627 - 0.1939 * cH
  const sDE = Math.sin(DE)
  const cDE = Math.cos(DE)
  const xy = function (u, r) {
    const [su, cu] = sincos(u)
    return mk(r * su, -r * cu * sDE, -r * cu * cDE)
  }
  return [xy(u1 + c1, r1), xy(u2 + c2, r2), xy(u3 + c3, r3), xy(u4 + c4, r4)]
}

const ksat = [0, 20947, 23715, 26382, 29876, 35313, 53800, 59222, 91820]

function R4(λ, r, γ, Ω) {
  this.λ = λ || 0
  this.r = r || 0
  this.γ = γ || 0
  this.Ω = Ω || 0
}

function Qs(jde) {
  this.t1 = jde - 2411093
  this.t2 = this.t1 / 365.25
  this.t3 = (jde - 2433282.423) / 365.25 + 1950
  this.t4 = jde - 2411368
  this.t5 = this.t4 / 365.25
  this.t6 = jde - 2415020
  this.t7 = this.t6 / 36525
  this.t8 = this.t6 / 365.25
  this.t9 = (jde - 2442000.5) / 365.25
  this.t10 = jde - 2409786
  this.t11 = this.t10 / 36525
  this.W0 = 5.095 * d * (this.t3 - 1866.39)
  this.W1 = 74.4 * d + 32.39 * d * this.t2
  this.W2 = 134.3 * d + 92.62 * d * this.t2
  this.W3 = 42 * d - 0.5118 * d * this.t5
  this.W4 = 276.59 * d + 0.5118 * d * this.t5
  this.W5 = 267.2635 * d + 1222.1136 * d * this.t7
  this.W6 = 175.4762 * d + 1221.5515 * d * this.t7
  this.W7 = 2.4891 * d + 0.002435 * d * this.t7
  this.W8 = 113.35 * d - 0.2597 * d * this.t7
  this.s1 = Math.sin(28.0817 * d)
  this.c1 = Math.cos(28.0817 * d)
  this.s2 = Math.sin(168.8112 * d)
  this.c2 = Math.cos(168.8112 * d)
  this.e1 = 0.05589 - 0.000346 * this.t7
  this.sW0 = Math.sin(this.W0)
  this.s3W0 = Math.sin(3 * this.W0)
  this.s5W0 = Math.sin(5 * this.W0)
  this.sW1 = Math.sin(this.W1)
  this.sW2 = Math.sin(this.W2)
  this.sW3 = Math.sin(this.W3)
  this.cW3 = Math.cos(this.W3)
  this.sW4 = Math.sin(this.W4)
  this.cW4 = Math.cos(this.W4)
  this.sW7 = Math.sin(this.W7)
  this.cW7 = Math.cos(this.W7)
}

Qs.prototype.mimas = function () {
  const r = new R4()
  const L =
    127.64 * d +
    381.994497 * d * this.t1 -
    43.57 * d * this.sW0 -
    0.72 * d * this.s3W0 -
    0.02144 * d * this.s5W0
  const p = 106.1 * d + 365.549 * d * this.t2
  const M = L - p
  const C =
    2.18287 * d * Math.sin(M) +
    0.025988 * d * Math.sin(2 * M) +
    0.00043 * d * Math.sin(3 * M)
  r.λ = L + C
  r.r = 3.06879 / (1 + 0.01905 * Math.cos(M + C))
  r.γ = 1.563 * d
  r.Ω = 54.5 * d - 365.072 * d * this.t2
  return r
}

Qs.prototype.enceladus = function () {
  const r = new R4()
  const L =
    200.317 * d +
    262.7319002 * d * this.t1 +
    0.25667 * d * this.sW1 +
    0.20883 * d * this.sW2
  const p = 309.107 * d + 123.44121 * d * this.t2
  const M = L - p
  const C = 0.55577 * d * Math.sin(M) + 0.00168 * d * Math.sin(2 * M)
  r.λ = L + C
  r.r = 3.94118 / (1 + 0.00485 * Math.cos(M + C))
  r.γ = 0.0262 * d
  r.Ω = 348 * d - 151.95 * d * this.t2
  return r
}

Qs.prototype.tethys = function () {
  const r = new R4()
  r.λ =
    285.306 * d +
    190.69791226 * d * this.t1 +
    2.063 * d * this.sW0 +
    0.03409 * d * this.s3W0 +
    0.001015 * d * this.s5W0
  r.r = 4.880998
  r.γ = 1.0976 * d
  r.Ω = 111.33 * d - 72.2441 * d * this.t2
  return r
}

Qs.prototype.dione = function () {
  const r = new R4()
  const L =
    254.712 * d +
    131.53493193 * d * this.t1 -
    0.0215 * d * this.sW1 -
    0.01733 * d * this.sW2
  const p = 174.8 * d + 30.82 * d * this.t2
  const M = L - p
  const C = 0.24717 * d * Math.sin(M) + 0.00033 * d * Math.sin(2 * M)
  r.λ = L + C
  r.r = 6.24871 / (1 + 0.002157 * Math.cos(M + C))
  r.γ = 0.0139 * d
  r.Ω = 232 * d - 30.27 * d * this.t2
  return r
}

Qs.prototype.rhea = function () {
  const pʹ = 342.7 * d + 10.057 * d * this.t2
  const [spʹ, cpʹ] = sincos(pʹ)
  const a1 = 0.000265 * spʹ + 0.001 * this.sW4
  const a2 = 0.000265 * cpʹ + 0.001 * this.cW4
  const e = Math.hypot(a1, a2)
  const p = Math.atan2(a1, a2)
  const N = 345 * d - 10.057 * d * this.t2
  const [sN, cN] = sincos(N)
  const λʹ = 359.244 * d + 79.6900472 * d * this.t1 + 0.086754 * d * sN
  const i = 28.0362 * d + 0.346898 * d * cN + 0.0193 * d * this.cW3
  const Ω = 168.8034 * d + 0.736936 * d * sN + 0.041 * d * this.sW3
  const a = 8.725924
  return this.subr(λʹ, p, e, a, Ω, i)
}

Qs.prototype.subr = function (λʹ, p, e, a, Ω, i) {
  const r = new R4()
  const M = λʹ - p
  const e2 = e * e
  const e3 = e2 * e
  const e4 = e2 * e2
  const e5 = e3 * e2
  const C =
    (2 * e - 0.25 * e3 + 0.0520833333 * e5) * Math.sin(M) +
    (1.25 * e2 - 0.458333333 * e4) * Math.sin(2 * M) +
    (1.083333333 * e3 - 0.671875 * e5) * Math.sin(3 * M) +
    1.072917 * e4 * Math.sin(4 * M) +
    1.142708 * e5 * Math.sin(5 * M)
  r.r = (a * (1 - e2)) / (1 + e * Math.cos(M + C)) // return value
  const g = Ω - 168.8112 * d
  const [si, ci] = sincos(i)
  const [sg, cg] = sincos(g)
  const a1 = si * sg
  const a2 = this.c1 * si * cg - this.s1 * ci
  r.γ = Math.asin(Math.hypot(a1, a2)) // return value
  const u = Math.atan2(a1, a2)
  r.Ω = 168.8112 * d + u // return value (w)
  const h = this.c1 * si - this.s1 * ci * cg
  const ψ = Math.atan2(this.s1 * sg, h)
  r.λ = λʹ + C + u - g - ψ // return value
  return r
}

Qs.prototype.titan = function () {
  const L = 261.1582 * d + 22.57697855 * d * this.t4 + 0.074025 * d * this.sW3
  const iʹ = 27.45141 * d + 0.295999 * d * this.cW3
  const Ωʹ = 168.66925 * d + 0.628808 * d * this.sW3
  const [siʹ, ciʹ] = sincos(iʹ)
  const [sΩʹW8, cΩʹW8] = sincos(Ωʹ - this.W8)
  const a1 = this.sW7 * sΩʹW8
  const a2 = this.cW7 * siʹ - this.sW7 * ciʹ * cΩʹW8
  const g0 = 102.8623 * d
  const ψ = Math.atan2(a1, a2)
  const s = Math.hypot(a1, a2)
  let g = this.W4 - Ωʹ - ψ
  let ϖ = 0
  const [s2g0, c2g0] = sincos(2 * g0)
  const f = () => {
    ϖ = this.W4 + 0.37515 * d * (Math.sin(2 * g) - s2g0)
    g = ϖ - Ωʹ - ψ
  }
  f()
  f()
  f()
  const eʹ = 0.029092 + 0.00019048 * (Math.cos(2 * g) - c2g0)
  const qq = 2 * (this.W5 - ϖ)
  const b1 = siʹ * sΩʹW8
  const b2 = this.cW7 * siʹ * cΩʹW8 - this.sW7 * ciʹ
  const θ = Math.atan2(b1, b2) + this.W8
  const [sq, cq] = sincos(qq)
  const e = eʹ + 0.002778797 * eʹ * cq
  const p = ϖ + 0.159215 * d * sq
  const u = 2 * this.W5 - 2 * θ + ψ
  const [su, cu] = sincos(u)
  const h = 0.9375 * eʹ * eʹ * sq + 0.1875 * s * s * Math.sin(2 * (this.W5 - θ))
  const λʹ =
    L -
    0.254744 *
      d *
      (this.e1 * Math.sin(this.W6) +
        0.75 * this.e1 * this.e1 * Math.sin(2 * this.W6) +
        h)
  const i = iʹ + 0.031843 * d * s * cu
  const Ω = Ωʹ + (0.031843 * d * s * su) / siʹ
  const a = 20.216193
  return this.subr(λʹ, p, e, a, Ω, i)
}

Qs.prototype.hyperion = function () {
  const η = 92.39 * d + 0.5621071 * d * this.t6
  const ζ = 148.19 * d - 19.18 * d * this.t8
  const θ = 184.8 * d - 35.41 * d * this.t9
  const θʹ = θ - 7.5 * d
  const as = 176 * d + 12.22 * d * this.t8
  const bs = 8 * d + 24.44 * d * this.t8
  const cs = bs + 5 * d
  const ϖ = 69.898 * d - 18.67088 * d * this.t8
  const φ = 2 * (ϖ - this.W5)
  const χ = 94.9 * d - 2.292 * d * this.t8
  const [sη, cη] = sincos(η)
  const [sζ, cζ] = sincos(ζ)
  const [s2ζ, c2ζ] = sincos(2 * ζ)
  const [s3ζ, c3ζ] = sincos(3 * ζ)
  const [sζpη, cζpη] = sincos(ζ + η)
  const [sζmη, cζmη] = sincos(ζ - η)
  const [sφ, cφ] = sincos(φ)
  const [sχ, cχ] = sincos(χ)
  const [scs, ccs] = sincos(cs)
  const a = 24.50601 - 0.08686 * cη - 0.00166 * cζpη + 0.00175 * cζmη
  const e =
    0.103458 -
    0.004099 * cη -
    0.000167 * cζpη +
    0.000235 * cζmη +
    0.02303 * cζ -
    0.00212 * c2ζ +
    0.000151 * c3ζ +
    0.00013 * cφ
  const p =
    ϖ +
    0.15648 * d * sχ -
    0.4457 * d * sη -
    0.2657 * d * sζpη -
    0.3573 * d * sζmη -
    12.872 * d * sζ +
    1.668 * d * s2ζ -
    0.2419 * d * s3ζ -
    0.07 * d * sφ
  const λʹ =
    177.047 * d +
    16.91993829 * d * this.t6 +
    0.15648 * d * sχ +
    9.142 * d * sη +
    0.007 * d * Math.sin(2 * η) -
    0.014 * d * Math.sin(3 * η) +
    0.2275 * d * sζpη +
    0.2112 * d * sζmη -
    0.26 * d * sζ -
    0.0098 * d * s2ζ -
    0.013 * d * Math.sin(as) +
    0.017 * d * Math.sin(bs) -
    0.0303 * d * sφ
  const i =
    27.3347 * d +
    0.6434886 * d * cχ +
    0.315 * d * this.cW3 +
    0.018 * d * Math.cos(θ) -
    0.018 * d * ccs
  const Ω =
    168.6812 * d +
    1.40136 * d * cχ +
    0.68599 * d * this.sW3 -
    0.0392 * d * scs +
    0.0366 * d * Math.sin(θʹ)
  return this.subr(λʹ, p, e, a, Ω, i)
}

Qs.prototype.iapetus = function () {
  const L = 261.1582 * d + 22.57697855 * d * this.t4
  const ϖʹ = 91.796 * d + 0.562 * d * this.t7
  const ψ = 4.367 * d - 0.195 * d * this.t7
  const θ = 146.819 * d - 3.198 * d * this.t7
  const φ = 60.47 * d + 1.521 * d * this.t7
  const Φ = 205.055 * d - 2.091 * d * this.t7
  const eʹ = 0.028298 + 0.001156 * this.t11
  const ϖ0 = 352.91 * d + 11.71 * d * this.t11
  const μ = 76.3852 * d + 4.53795125 * d * this.t10
  const iʹ = horner(
    this.t11,
    18.4602 * d,
    -0.9518 * d,
    -0.072 * d,
    0.0054 * d
  )
  const Ωʹ = horner(
    this.t11,
    143.198 * d,
    -3.919 * d,
    0.116 * d,
    0.008 * d
  )
  const l = μ - ϖ0
  const g = ϖ0 - Ωʹ - ψ
  const g1 = ϖ0 - Ωʹ - φ
  const ls = this.W5 - ϖʹ
  const gs = ϖʹ - θ
  const lT = L - this.W4
  const gT = this.W4 - Φ
  const u1 = 2 * (l + g - ls - gs)
  const u2 = l + g1 - lT - gT
  const u3 = l + 2 * (g - ls - gs)
  const u4 = lT + gT - g1
  const u5 = 2 * (ls + gs)
  const [sl, cl] = sincos(l)
  const [su1, cu1] = sincos(u1)
  const [su2, cu2] = sincos(u2)
  const [su3, cu3] = sincos(u3)
  const [su4, cu4] = sincos(u4)
  const [slu2, clu2] = sincos(l + u2)
  const [sg1gT, cg1gT] = sincos(g1 - gT)
  const [su52g, cu52g] = sincos(u5 - 2 * g)
  const [su5ψ, cu5ψ] = sincos(u5 + ψ)
  const [su2φ, cu2φ] = sincos(u2 + φ)
  const [s5, c5] = sincos(l + g1 + lT + gT + φ)
  const a = 58.935028 + 0.004638 * cu1 + 0.058222 * cu2
  const e =
    eʹ -
    0.0014097 * cg1gT +
    0.0003733 * cu52g +
    0.000118 * cu3 +
    0.0002408 * cl +
    0.0002849 * clu2 +
    0.000619 * cu4
  const w =
    0.08077 * d * sg1gT +
    0.02139 * d * su52g -
    0.00676 * d * su3 +
    0.0138 * d * sl +
    0.01632 * d * slu2 +
    0.03547 * d * su4
  const p = ϖ0 + w / eʹ
  const λʹ =
    μ -
    0.04299 * d * su2 -
    0.00789 * d * su1 -
    0.06312 * d * Math.sin(ls) -
    0.00295 * d * Math.sin(2 * ls) -
    0.02231 * d * Math.sin(u5) +
    0.0065 * d * su5ψ
  const i = iʹ + 0.04204 * d * cu5ψ + 0.00235 * d * c5 + 0.0036 * d * cu2φ
  const wʹ = 0.04204 * d * su5ψ + 0.00235 * d * s5 + 0.00358 * d * su2φ
  const Ω = Ωʹ + wʹ / Math.sin(iʹ)
  return this.subr(λʹ, p, e, a, Ω, i)
}



/* Saturn: geocentric J2000 ecliptic position of Saturn and the Sun, then the Meeus chapter 46 steps. */
var PREC = (function () {
  /* precession from J2000 to B1950 (t = -0.5 centuries), Meeus chapter 21 */
  var t = -0.5, as = Math.PI / 180 / 3600;
  var zeta = (2306.2181 * t + 0.30188 * t * t + 0.017998 * t * t * t) * as;
  var z = (2306.2181 * t + 1.09468 * t * t + 0.018203 * t * t * t) * as;
  var theta = (2004.3109 * t - 0.42665 * t * t - 0.041833 * t * t * t) * as;
  return { zeta: zeta, z: z, theta: theta };
})();
var EPS2000 = 23.4392911 * d, EPS1950 = 23.4457889 * d;

function saturnLow(ms) {
  var jde = ms / 86400000 + 2440587.5;
  var earth = API.helio('earth', ms);
  var dist = 9.0, x = 0, y = 0, z = 0, ms2 = ms;
  for (var n = 0; n < 2; n++) {
    ms2 = ms - lightTime(dist) * 86400000;
    var s = API.helio('saturn', ms2);
    x = s.x - earth.x; y = s.y - earth.y; z = s.z - earth.z;
    dist = Math.sqrt(x * x + y * y + z * z);
  }
  var Δ = dist, _jde = ms2 / 86400000 + 2440587.5;
  /* J2000 ecliptic -> equatorial J2000 -> precess to B1950 -> ecliptic B1950 */
  var ce = Math.cos(EPS2000), se = Math.sin(EPS2000);
  var ex = x, ey = y * ce - z * se, ez = y * se + z * ce;
  var ra = Math.atan2(ey, ex), dec = Math.atan2(ez, Math.hypot(ex, ey));
  var A1 = Math.cos(dec) * Math.sin(ra + PREC.zeta);
  var B1 = Math.cos(dec) * Math.cos(ra + PREC.zeta) * Math.cos(PREC.theta) - Math.sin(dec) * Math.sin(PREC.theta);
  var C1 = Math.cos(dec) * Math.cos(ra + PREC.zeta) * Math.sin(PREC.theta) + Math.sin(dec) * Math.cos(PREC.theta);
  var ra2 = Math.atan2(A1, B1) + PREC.z, dec2 = Math.asin(C1);
  var c2 = Math.cos(EPS1950), s2 = Math.sin(EPS1950);
  var qx = Math.cos(dec2) * Math.cos(ra2), qy = Math.cos(dec2) * Math.sin(ra2), qz = Math.sin(dec2);
  var fx = qx, fy = qy * c2 + qz * s2, fz = -qy * s2 + qz * c2;
  var λ0 = Math.atan2(fy, fx), β0 = Math.atan2(fz, Math.hypot(fx, fy));
  const q = new Qs(_jde)
  const s4 = [
    new R4(), // 0 unused
    q.mimas(),
    q.enceladus(),
    q.tethys(),
    q.dione(),
    q.rhea(),
    q.titan(),
    q.hyperion(),
    q.iapetus()
  ]

  const X = new Array(9).fill(0)
  const Y = new Array(9).fill(0)
  const Z = new Array(9).fill(0)
  for (let j = 1; j <= 8; j++) {
    const u = s4[j].λ - s4[j].Ω
    const w = s4[j].Ω - 168.8112 * d
    const [su, cu] = sincos(u)
    const [sw, cw] = sincos(w)
    const [sγ, cγ] = sincos(s4[j].γ)
    const r = s4[j].r
    X[j] = r * (cu * cw - su * cγ * sw)
    Y[j] = r * (su * cw * cγ + cu * sw)
    Z[j] = r * su * sγ
  }
  Z[0] = 1
  const [sλ0, cλ0] = sincos(λ0)
  const [sβ0, cβ0] = sincos(β0)
  const A = new Array(9).fill(0)
  const B = new Array(9).fill(0)
  const C = new Array(9).fill(0)
  for (const j in X) {
    let a = X[j]
    let b = q.c1 * Y[j] - q.s1 * Z[j]
    const c = q.s1 * Y[j] + q.c1 * Z[j]
    const a0 = q.c2 * a - q.s2 * b
    b = q.s2 * a + q.c2 * b
    a = a0

    A[j] = a * sλ0 - b * cλ0
    b = a * cλ0 + b * sλ0

    B[j] = b * cβ0 + c * sβ0
    C[j] = c * cβ0 - b * sβ0
  }

  const pos = new Array(9)
  const D = Math.atan2(A[0], C[0])
  const [sD, cD] = sincos(D)
  for (let j = 1; j <= 8; j++) {
    X[j] = A[j] * cD - C[j] * sD
    Y[j] = A[j] * sD + C[j] * cD
    Z[j] = B[j]
    const d = X[j] / s4[j].r
    X[j] += (Math.abs(Z[j]) / ksat[j]) * Math.sqrt(1 - d * d)
    const W = Δ / (Δ + Z[j] / 2475)
    pos[j - 1] = mk(X[j] * W, Y[j] * W, Z[j])
  }
  return pos;
}

  /* ---------- public functions ---------- */
  function jupiter(ms) { return jupiterLow(ms / 86400000 + 2440587.5); }
  function saturn(ms) { return saturnLow(ms); }

  /* Tilt of Saturn's rings towards Earth (degrees, Meeus chapter 45), positive when Earth is north of the ring plane. */
  function ringTilt(ms) {
    var earth = API.helio('earth', ms), s = API.helio('saturn', ms - lightTime(9.2) * 86400000);
    var x = s.x - earth.x, y = s.y - earth.y, z = s.z - earth.z;
    var lam = Math.atan2(y, x), bet = Math.atan2(z, Math.hypot(x, y));
    var i = 28.075216 * d, om = 169.50847 * d;
    return Math.asin(Math.sin(i) * Math.cos(bet) * Math.sin(lam - om) - Math.cos(i) * Math.sin(bet)) / d;
  }

  /* ---------- the picture on Jupiter and Saturn pages ---------- */
  var JUP = [
    { id: 'io', en: 'Io', hi: 'आयो', p: 1.769, c: '#f2c94c' },
    { id: 'europa', en: 'Europa', hi: 'यूरोपा', p: 3.551, c: '#bce0fd' },
    { id: 'ganymede', en: 'Ganymede', hi: 'गैनिमीड', p: 7.155, c: '#d0c4b4' },
    { id: 'callisto', en: 'Callisto', hi: 'कैलिस्टो', p: 16.689, c: '#9e9488' }
  ];
  var SAT = [
    { id: 'mimas', en: 'Mimas', hi: 'मिमास', p: 0.942, c: '#e9e9ef' },
    { id: 'enceladus', en: 'Enceladus', hi: 'एन्सेलेडस', p: 1.370, c: '#dcf2ff' },
    { id: 'tethys', en: 'Tethys', hi: 'टेथिस', p: 1.888, c: '#cfe3f2' },
    { id: 'dione', en: 'Dione', hi: 'डायोन', p: 2.737, c: '#e8dcc8' },
    { id: 'rhea', en: 'Rhea', hi: 'रिया', p: 4.518, c: '#d8cfc4' },
    { id: 'titan', en: 'Titan', hi: 'टाइटन', p: 15.945, c: '#f0ad4e' },
    { id: 'hyperion', en: 'Hyperion', hi: 'हाइपेरियन', p: 21.277, c: '#c7a98a' },
    { id: 'iapetus', en: 'Iapetus', hi: 'आयापेटस', p: 79.322, c: '#b8b0e8' }
  ];
  var TX = {
    title: ['Live moon positions', 'चंद्रमाओं की लाइव स्थिति'],
    jup: ['Jupiter\'s four big moons as a small telescope shows them, for the date below. North is up, west is to the right.',
      'बृहस्पति के 4 बड़े चंद्रमा जैसे छोटी दूरबीन में दिखते हैं, नीचे की तारीख़ के लिए। ऊपर उत्तर है, दाईं ओर पश्चिम।'],
    sat: ['Saturn\'s eight major moons as a telescope shows them, for the date below. North is up, west is to the right. The ring angle is only roughly drawn.',
      'शनि के 8 प्रमुख चंद्रमा जैसे दूरबीन में दिखते हैं, नीचे की तारीख़ के लिए। ऊपर उत्तर है, दाईं ओर पश्चिम। छल्लों का कोण मोटे तौर पर बना है।'],
    now: ['Now', 'अभी'], play: ['▶ Play', '▶ चलाओ'], pause: ['⏸ Pause', '⏸ रोको'],
    close: ['Show near moons', 'पास के चंद्रमा दिखाओ'], all: ['Show all moons', 'सभी चंद्रमा दिखाओ'],
    th: [['Moon', 'Distance', 'Side', 'Orbit', 'Now'], ['चंद्रमा', 'दूरी', 'ओर', 'परिक्रमा', 'अभी']],
    west: ['west', 'पश्चिम'], east: ['east', 'पूर्व'],
    front: ['in front of the planet', 'ग्रह के सामने'], behind: ['behind the planet', 'ग्रह के पीछे'], clear: ['clear of the planet', 'ग्रह से अलग'],
    off: ['off the picture', 'तस्वीर से बाहर'],
    days: ['days', 'दिन'], rad: ['radii', 'त्रिज्या'],
    noteJ: ['Calculated with the formulas of Jean Meeus (Astronomical Algorithms). Checked against a high accuracy theory, the moons are within about 0.1 of the planet\'s radius.',
      'हिसाब Jean Meeus के formulas (Astronomical Algorithms) से। high accuracy theory से मिलाने पर चंद्रमा ग्रह की त्रिज्या के लगभग 0.1 भाग के भीतर हैं।'],
    noteS: ['Calculated with the formulas of Jean Meeus (Astronomical Algorithms). Checked against the full calculation, the moons are within about 0.2 of the planet\'s radius.',
      'हिसाब Jean Meeus के formulas (Astronomical Algorithms) से। पूरी गणना से मिलाने पर चंद्रमा ग्रह की त्रिज्या के लगभग 0.2 भाग के भीतर हैं।']
  };
  function L(k) { return TX[k][API.lang() === 'hi' ? 1 : 0]; }

  function init() {
    var host = document.getElementById('moonOrbitSim');
    if (!host) { return; }
    var id = host.getAttribute('data-body');
    var isSat = id === 'saturn';
    var list = isSat ? SAT : JUP;
    var fn = isSat ? saturn : jupiter;
    var colors = (window.ASTRYL && window.ASTRYL.bodies || []).filter(function (b) { return b.id === id; })[0];
    var planetColor = colors && colors.color || (isSat ? '#dfc07c' : '#d99a62');
    var reduce = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;
    var t = Date.now(), playing = !reduce, wide = false, last = 0, W = 300, H = isSat ? 170 : 150, tick = 0;

    host.innerHTML = '<p id="mnDesc" style="margin-top:0"></p>' +
      '<div class="row" style="gap:8px;flex-wrap:wrap;align-items:center;margin-bottom:10px"><b id="mnDate"></b>' +
      '<button class="btn" id="mnM1" type="button">−1 d</button><button class="btn" id="mnM6" type="button">−6 h</button>' +
      '<button class="btn" id="mnPlay" type="button"></button>' +
      '<button class="btn" id="mnP6" type="button">+6 h</button><button class="btn" id="mnP1" type="button">+1 d</button>' +
      '<button class="btn" id="mnNow" type="button"></button>' + (isSat ? '<button class="btn" id="mnZoom" type="button"></button>' : '') + '</div>' +
      '<canvas id="mnCv" style="width:100%;border-radius:14px;background:#050812;display:block"></canvas>' +
      '<div style="overflow-x:auto;margin-top:12px"><table id="mnTb" style="width:100%;border-collapse:collapse;font-size:.92em"></table></div>' +
      '<p class="note" id="mnNote"></p>';
    var cv = document.getElementById('mnCv'), ctx = cv.getContext('2d');

    function size() {
      W = Math.max(260, cv.clientWidth || host.clientWidth || 300);
      var r = window.devicePixelRatio || 1;
      cv.width = Math.round(W * r); cv.height = Math.round(H * r);
      cv.style.height = H + 'px';
      ctx.setTransform(r, 0, 0, r, 0, 0);
    }
    function nm(m) { return API.lang() === 'hi' ? m.hi : m.en; }
    function range() { return isSat ? (wide ? 62 : 22) : 29; }

    function draw() {
      var pos = fn(t), cx = W / 2, cy = H / 2, s = (W / 2 - 14) / range();
      ctx.clearRect(0, 0, W, H);
      var tilt = isSat ? ringTilt(t) : 0, k = Math.abs(Math.sin(tilt * d));
      function rings(front) {
        if (!isSat) { return; }
        ctx.save(); ctx.strokeStyle = 'rgba(223,192,124,.75)';
        [[1.55, 0.5], [2.0, 0.55], [2.27, 0.25]].forEach(function (rr) {
          ctx.lineWidth = Math.max(1, rr[1] * s);
          ctx.beginPath();
          /* the half of each ring nearer to us crosses in front of the planet */
          var near = tilt >= 0 ? 0 : Math.PI;
          ctx.ellipse(cx, cy, rr[0] * s, rr[0] * s * k, 0, front ? near : near + Math.PI, front ? near + Math.PI : near + 2 * Math.PI);
          ctx.stroke();
        });
        ctx.restore();
      }
      rings(false);
      ctx.fillStyle = planetColor; ctx.beginPath(); ctx.arc(cx, cy, Math.max(3, s), 0, 7); ctx.fill();
      rings(true);
      var behind = [], front = [];
      pos.forEach(function (p, i) { (p.z < 0 ? behind : front).push(i); });
      function dot(i) {
        var m = list[i], p = pos[i], x = cx + p.x * s, y = cy - p.y * s;
        if (Math.abs(p.x) > range()) { return; }
        var hidden = p.z < 0 && Math.hypot(p.x, p.y) < 1;
        if (hidden) { return; }
        ctx.fillStyle = m.c; ctx.beginPath(); ctx.arc(x, y, 3.6, 0, 7); ctx.fill();
        ctx.fillStyle = 'rgba(235,240,255,.9)'; ctx.font = '600 11px "DM Sans",sans-serif';
        ctx.textAlign = 'center'; ctx.fillText(nm(m), x, y + (i % 2 ? 17 : -9));
      }
      behind.forEach(dot); front.forEach(dot);
      ctx.fillStyle = 'rgba(180,195,230,.7)'; ctx.font = '600 10px "DM Sans",sans-serif'; ctx.textAlign = 'left'; ctx.fillText(API.lang() === 'hi' ? 'पूर्व' : 'E', 8, 14);
      ctx.textAlign = 'right'; ctx.fillText(API.lang() === 'hi' ? 'पश्चिम' : 'W', W - 8, 14);
      document.getElementById('mnDate').textContent = new Date(t).toISOString().slice(0, 16).replace('T', ' ') + ' UTC';
      if (tick++ % 6 === 0) { table(pos); }
    }
    function table(pos) {
      var hd = L('th');
      var rows = '<tr>' + hd.map(function (h) { return '<th style="text-align:left;padding:4px 8px 4px 0;opacity:.7;font-weight:600">' + h + '</th>'; }).join('') + '</tr>';
      pos.forEach(function (p, i) {
        var m = list[i], rho = Math.hypot(p.x, p.y), st = rho < 1 ? (p.z > 0 ? L('front') : L('behind')) : L('clear');
        if (Math.abs(p.x) > range()) { st = L('off'); }
        rows += '<tr><td style="padding:4px 8px 4px 0"><i style="display:inline-block;width:10px;height:10px;border-radius:50%;background:' + m.c + ';margin-right:6px"></i>' + nm(m) + '</td>' +
          '<td style="padding:4px 8px 4px 0">' + rho.toFixed(1) + ' ' + L('rad') + '</td>' +
          '<td style="padding:4px 8px 4px 0">' + (p.x > 0 ? L('west') : L('east')) + '</td>' +
          '<td style="padding:4px 8px 4px 0">' + m.p + ' ' + L('days') + '</td><td style="padding:4px 0">' + st + '</td></tr>';
      });
      document.getElementById('mnTb').innerHTML = rows;
    }
    function labels() {
      document.getElementById('mnDesc').textContent = L(isSat ? 'sat' : 'jup');
      document.getElementById('mnPlay').textContent = playing ? L('pause') : L('play');
      document.getElementById('mnNow').textContent = L('now');
      var z = document.getElementById('mnZoom'); if (z) { z.textContent = wide ? L('close') : L('all'); }
      document.getElementById('mnNote').textContent = L(isSat ? 'noteS' : 'noteJ');
      tick = 0; draw();
    }
    function step(ms) { t += ms; tick = 0; draw(); }
    function loop(ts) {
      if (playing) { if (last) { t += (ts - last) * 12 * 3600 / 1000; } last = ts; draw(); requestAnimationFrame(loop); } else { last = 0; }
    }
    function setPlaying(v) { playing = v; last = 0; labels(); if (v) { requestAnimationFrame(loop); } }
    document.getElementById('mnM1').addEventListener('click', function () { step(-86400000); });
    document.getElementById('mnM6').addEventListener('click', function () { step(-21600000); });
    document.getElementById('mnP6').addEventListener('click', function () { step(21600000); });
    document.getElementById('mnP1').addEventListener('click', function () { step(86400000); });
    document.getElementById('mnNow').addEventListener('click', function () { t = Date.now(); tick = 0; draw(); });
    document.getElementById('mnPlay').addEventListener('click', function () { setPlaying(!playing); });
    var zb = document.getElementById('mnZoom'); if (zb) { zb.addEventListener('click', function () { wide = !wide; labels(); }); }
    window.addEventListener('resize', function () { size(); draw(); });
    size(); API.onRender(labels);
    if (playing) { requestAnimationFrame(loop); }
  }

  window.ASTRYL_MOONS = { jupiter: jupiter, saturn: saturn, ringTilt: ringTilt };
  if (document.readyState === 'loading') { document.addEventListener('DOMContentLoaded', init); } else { init(); }
})();
