/* SGP4 (near-Earth, WGS-72), the same maths as the app's lib/core/sgp4.dart: turns a satellite's
   two-line orbit data (TLE) into its position (km, TEME frame) at any time. Used by iss.js. */
(function (g) {
  var PI2 = 2 * Math.PI, MU = 398600.8, RE = 6378.135, XKE = 60 / Math.sqrt(RE * RE * RE / MU);
  var J2 = 0.001082616, J3 = -0.00000253881, J4 = -0.00000165597, J3OJ2 = J3 / J2, X2O3 = 2 / 3;
  function mod(a, b) { var r = a % b; return r < 0 ? r + b : r; }
  function num(s) { var v = parseFloat(s); if (!isFinite(v)) throw new Error('Not a TLE'); return v; }

  function Sgp4(l1, l2) {
    l1 = String(l1).replace(/\s+$/, ''); l2 = String(l2).replace(/\s+$/, '');
    if (l1.length < 63 || l2.length < 63 || l1[0] !== '1' || l2[0] !== '2') throw new Error('Not a TLE');
    var year = parseInt(l1.substring(18, 20), 10); year += year < 57 ? 2000 : 1900;
    var days = num(l1.substring(20, 32));
    this.epochMs = Date.UTC(year, 0, 1) + (days - 1) * 86400000;
    var b = l1.substring(53, 61).trim(), sign = 1;
    if (b[0] === '-') { sign = -1; b = b.substring(1); } else if (b[0] === '+') b = b.substring(1);
    this.bstar = sign * num('0.' + b.substring(0, b.length - 2)) * Math.pow(10, parseInt(b.substring(b.length - 2), 10));
    var D = Math.PI / 180;
    this.inclo = num(l2.substring(8, 16)) * D;
    this.nodeo = num(l2.substring(17, 25)) * D;
    this.ecco = num('0.' + l2.substring(26, 33).trim());
    this.argpo = num(l2.substring(34, 42)) * D;
    this.mo = num(l2.substring(43, 51)) * D;
    this.no = num(l2.substring(52, 63)) * PI2 / 1440;
    this.init();
  }

  Sgp4.prototype.init = function () {
    var s = this, ss = 78 / RE + 1, qzms2t = Math.pow(42 / RE, 4);
    var ecco = s.ecco, inclo = s.inclo, bstar = s.bstar, argpo = s.argpo, mo = s.mo, no = s.no;
    var eccsq = ecco * ecco, omeosq = 1 - eccsq, rteosq = Math.sqrt(omeosq), cosio = Math.cos(inclo), cosio2 = cosio * cosio;
    var ak = Math.pow(XKE / no, X2O3), d1 = 0.75 * J2 * (3 * cosio2 - 1) / (rteosq * omeosq), del = d1 / (ak * ak);
    var adel = ak * (1 - del * del - del * (1 / 3 + 134 * del * del / 81));
    del = d1 / (adel * adel); no = no / (1 + del); s.no = no;
    var ao = Math.pow(XKE / no, X2O3), sinio = Math.sin(inclo), po = ao * omeosq, con42 = 1 - 5 * cosio2;
    s.con41 = -con42 - cosio2 - cosio2;
    var posq = po * po, rp = ao * (1 - ecco);
    s.isimp = rp < (220 / RE + 1);
    var sfour = ss, qzms24 = qzms2t, perige = (rp - 1) * RE;
    if (perige < 156) { sfour = perige - 78; if (perige < 98) sfour = 20; qzms24 = Math.pow((120 - sfour) / RE, 4); sfour = sfour / RE + 1; }
    var pinvsq = 1 / posq, tsi = 1 / (ao - sfour);
    s.eta = ao * ecco * tsi;
    var etasq = s.eta * s.eta, eeta = ecco * s.eta, psisq = Math.abs(1 - etasq), coef = qzms24 * Math.pow(tsi, 4), coef1 = coef / Math.pow(psisq, 3.5);
    var cc2 = coef1 * no * (ao * (1 + 1.5 * etasq + eeta * (4 + etasq)) + 0.375 * J2 * tsi / psisq * s.con41 * (8 + 3 * etasq * (8 + etasq)));
    s.cc1 = bstar * cc2;
    var cc3 = ecco > 1e-4 ? -2 * coef * tsi * J3OJ2 * no * sinio / ecco : 0;
    s.x1mth2 = 1 - cosio2;
    s.cc4 = 2 * no * coef1 * ao * omeosq * (s.eta * (2 + 0.5 * etasq) + ecco * (0.5 + 2 * etasq) - J2 * tsi / (ao * psisq) *
      (-3 * s.con41 * (1 - 2 * eeta + etasq * (1.5 - 0.5 * eeta)) + 0.75 * s.x1mth2 * (2 * etasq - eeta * (1 + etasq)) * Math.cos(2 * argpo)));
    s.cc5 = 2 * coef1 * ao * omeosq * (1 + 2.75 * (etasq + eeta) + eeta * etasq);
    var cosio4 = cosio2 * cosio2, temp1 = 1.5 * J2 * pinvsq * no, temp2 = 0.5 * temp1 * J2 * pinvsq, temp3 = -0.46875 * J4 * pinvsq * pinvsq * no;
    s.mdot = no + 0.5 * temp1 * rteosq * s.con41 + 0.0625 * temp2 * rteosq * (13 - 78 * cosio2 + 137 * cosio4);
    s.argpdot = -0.5 * temp1 * con42 + 0.0625 * temp2 * (7 - 114 * cosio2 + 395 * cosio4) + temp3 * (3 - 36 * cosio2 + 49 * cosio4);
    var xhdot1 = -temp1 * cosio;
    s.nodedot = xhdot1 + (0.5 * temp2 * (4 - 19 * cosio2) + 2 * temp3 * (3 - 7 * cosio2)) * cosio;
    s.omgcof = bstar * cc3 * Math.cos(argpo);
    s.xmcof = ecco > 1e-4 ? -X2O3 * coef * bstar / eeta : 0;
    s.nodecf = 3.5 * omeosq * xhdot1 * s.cc1;
    s.t2cof = 1.5 * s.cc1;
    s.xlcof = Math.abs(cosio + 1) > 1.5e-12 ? -0.25 * J3OJ2 * sinio * (3 + 5 * cosio) / (1 + cosio) : -0.25 * J3OJ2 * sinio * (3 + 5 * cosio) / 1.5e-12;
    s.aycof = -0.5 * J3OJ2 * sinio;
    s.delmo = Math.pow(1 + s.eta * Math.cos(mo), 3);
    s.sinmao = Math.sin(mo);
    s.x7thm1 = 7 * cosio2 - 1;
    s.d2 = s.d3 = s.d4 = s.t3cof = s.t4cof = s.t5cof = 0;
    if (!s.isimp) {
      var cc1sq = s.cc1 * s.cc1;
      s.d2 = 4 * ao * tsi * cc1sq;
      var temp = s.d2 * tsi * s.cc1 / 3;
      s.d3 = (17 * ao + sfour) * temp;
      s.d4 = 0.5 * temp * ao * tsi * (221 * ao + 31 * sfour) * s.cc1;
      s.t3cof = s.d2 + 2 * cc1sq;
      s.t4cof = 0.25 * (3 * s.d3 + s.cc1 * (12 * s.d2 + 10 * cc1sq));
      s.t5cof = 0.2 * (3 * s.d4 + 12 * s.cc1 * s.d3 + 6 * s.d2 * s.d2 + 15 * cc1sq * (2 * s.d2 + cc1sq));
    }
  };

  /* Position (km) and velocity (km/s) [t] minutes after the epoch, or null. */
  Sgp4.prototype.propagate = function (t) {
    var s = this, vk = RE * XKE / 60;
    var xmdf = s.mo + s.mdot * t, argpdf = s.argpo + s.argpdot * t, nodedf = s.nodeo + s.nodedot * t;
    var argpm = argpdf, mm = xmdf, t2 = t * t, nodem = nodedf + s.nodecf * t2, tempa = 1 - s.cc1 * t, tempe = s.bstar * s.cc4 * t, templ = s.t2cof * t2;
    if (!s.isimp) {
      var delomg = s.omgcof * t, delm = s.xmcof * (Math.pow(1 + s.eta * Math.cos(xmdf), 3) - s.delmo), tp = delomg + delm;
      mm = xmdf + tp; argpm = argpdf - tp;
      var t3 = t2 * t, t4 = t3 * t;
      tempa = tempa - s.d2 * t2 - s.d3 * t3 - s.d4 * t4;
      tempe = tempe + s.bstar * s.cc5 * (Math.sin(mm) - s.sinmao);
      templ = templ + s.t3cof * t3 + t4 * (s.t4cof + t * s.t5cof);
    }
    var nm = s.no, em = s.ecco, inclm = s.inclo, am = Math.pow(XKE / nm, X2O3) * tempa * tempa;
    nm = XKE / Math.pow(am, 1.5);
    em = em - tempe;
    if (em >= 1 || em < -0.001 || am <= 0) return null;
    if (em < 1e-6) em = 1e-6;
    mm = mm + s.no * templ;
    var xlm = mm + argpm + nodem;
    nodem = mod(nodem, PI2); argpm = mod(argpm, PI2); xlm = mod(xlm, PI2); mm = mod(xlm - argpm - nodem, PI2);
    var sinip = Math.sin(inclm), cosip = Math.cos(inclm), ep = em;
    var axnl = ep * Math.cos(argpm), temp = 1 / (am * (1 - ep * ep)), aynl = ep * Math.sin(argpm) + temp * s.aycof;
    var xl = mm + argpm + nodem + temp * s.xlcof * axnl, u = mod(xl - nodem, PI2);
    var eo1 = u, tem5 = 9999.9, ktr = 1, sineo1 = 0, coseo1 = 1;
    while (Math.abs(tem5) >= 1e-12 && ktr <= 10) {
      sineo1 = Math.sin(eo1); coseo1 = Math.cos(eo1);
      tem5 = 1 - coseo1 * axnl - sineo1 * aynl;
      tem5 = (u - aynl * coseo1 + axnl * sineo1 - eo1) / tem5;
      if (Math.abs(tem5) >= 0.95) tem5 = tem5 > 0 ? 0.95 : -0.95;
      eo1 += tem5; ktr++;
    }
    var ecose = axnl * coseo1 + aynl * sineo1, esine = axnl * sineo1 - aynl * coseo1, el2 = axnl * axnl + aynl * aynl, pl = am * (1 - el2);
    if (pl < 0) return null;
    var rl = am * (1 - ecose), rdotl = Math.sqrt(am) * esine / rl, rvdotl = Math.sqrt(pl) / rl, betal = Math.sqrt(1 - el2);
    temp = esine / (1 + betal);
    var sinu = am / rl * (sineo1 - aynl - axnl * temp), cosu = am / rl * (coseo1 - axnl + aynl * temp), su = Math.atan2(sinu, cosu);
    var sin2u = (cosu + cosu) * sinu, cos2u = 1 - 2 * sinu * sinu;
    temp = 1 / pl;
    var temp1 = 0.5 * J2 * temp, temp2 = temp1 * temp;
    var mrt = rl * (1 - 1.5 * temp2 * betal * s.con41) + 0.5 * temp1 * s.x1mth2 * cos2u;
    su = su - 0.25 * temp2 * s.x7thm1 * sin2u;
    var xnode = nodem + 1.5 * temp2 * cosip * sin2u, xinc = inclm + 1.5 * temp2 * cosip * sinip * cos2u;
    var mvt = rdotl - nm * temp1 * s.x1mth2 * sin2u / XKE, rvdot = rvdotl + nm * temp1 * (s.x1mth2 * cos2u + 1.5 * s.con41) / XKE;
    var sinsu = Math.sin(su), cossu = Math.cos(su), snod = Math.sin(xnode), cnod = Math.cos(xnode), sini = Math.sin(xinc), cosi = Math.cos(xinc);
    var xmx = -snod * cosi, xmy = cnod * cosi, ux = xmx * sinsu + cnod * cossu, uy = xmy * sinsu + snod * cossu, uz = sini * sinsu;
    var vx = xmx * cossu - cnod * sinsu, vy = xmy * cossu - snod * sinsu, vz = sini * cossu;
    return { x: mrt * RE * ux, y: mrt * RE * uy, z: mrt * RE * uz, vx: (mvt * ux + rvdot * vx) * vk, vy: (mvt * uy + rvdot * vy) * vk, vz: (mvt * uz + rvdot * vz) * vk };
  };
  Sgp4.prototype.at = function (ms) { return this.propagate((ms - this.epochMs) / 60000); };
  Sgp4.RE = RE;
  g.Sgp4 = Sgp4;
  if (typeof module !== 'undefined') module.exports = Sgp4;
})(typeof window !== 'undefined' ? window : globalThis);
