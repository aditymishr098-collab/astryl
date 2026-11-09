import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/planets.dart';
import '../data/surface_sites.dart';
import '../l10n/names.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// A simplified flat map of the Moon or Mars with every landing site on it.
///
/// It is drawn, not a photo: the big seas, basins, craters and volcanoes are
/// ellipses in the right places, and each site sits at its real latitude and
/// longitude. Pinch to zoom, tap a marker for the story.
class SurfaceMapScreen extends StatefulWidget {
  const SurfaceMapScreen({super.key, required this.planet});

  /// The Moon or Mars.
  final Planet planet;

  /// Does this body have a surface map?
  static bool isAvailable(String planetId) =>
      planetId == 'moon' || planetId == 'mars';

  @override
  State<SurfaceMapScreen> createState() => _SurfaceMapScreenState();
}

/// The colour of a marker, by kind of landing.
Color siteColor(SiteKind kind) {
  switch (kind) {
    case SiteKind.crewed:
      return const Color(0xFFF5A524);
    case SiteKind.lander:
      return const Color(0xFF5B8CFF);
    case SiteKind.rover:
      return const Color(0xFF2FBF71);
    case SiteKind.sample:
      return const Color(0xFFB07CFF);
  }
}

class _SurfaceMapScreenState extends State<SurfaceMapScreen> {
  final TransformationController _view = TransformationController();
  SurfaceSite? _selected;

  late final SurfaceWorld _world =
      widget.planet.id == 'mars' ? SurfaceWorld.mars : SurfaceWorld.moon;
  late final List<SurfaceSite> _sites = sitesOf(_world);

  @override
  void dispose() {
    _view.dispose();
    super.dispose();
  }

  void _tapMap(Offset at, Size size) {
    final scale = _view.value.getMaxScaleOnAxis();
    final reach = 22 / scale;
    SurfaceSite? best;
    var bestDistance = reach;
    for (final s in _sites) {
      final d = (_SurfaceMapPainter.project(s.lat, s.lon, size) - at).distance;
      if (d < bestDistance) {
        bestDistance = d;
        best = s;
      }
    }
    setState(() => _selected = best);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final body = planetName(l, widget.planet);
    final selected = _selected;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.surfaceMapOf(body),
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: <Widget>[
          Text(l.surfaceMapTap,
              style: TextStyle(fontSize: 13, color: p.muted, height: 1.4)),
          const SizedBox(height: 10),
          LayoutBuilder(builder: (context, box) {
            final size = Size(box.maxWidth, box.maxWidth / 2);
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Semantics(
                label: l.surfaceMapOf(body),
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: InteractiveViewer(
                    transformationController: _view,
                    minScale: 1,
                    maxScale: 8,
                    child: GestureDetector(
                      onTapUp: (d) => _tapMap(d.localPosition, size),
                      child: AnimatedBuilder(
                        animation: _view,
                        builder: (context, _) => CustomPaint(
                          size: size,
                          painter: _SurfaceMapPainter(
                            world: _world,
                            sites: _sites,
                            selected: selected,
                            scale: _view.value.getMaxScaleOnAxis(),
                            labelFor: (id) => featureName(l, id),
                            nearSide: l.mapNearSide,
                            farSide: l.mapFarSide,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: <Widget>[
              for (final k in SiteKind.values)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          color: siteColor(k),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5)),
                    ),
                    const SizedBox(width: 6),
                    Text(siteKindLabel(l, k),
                        style: TextStyle(fontSize: 12, color: p.muted)),
                  ],
                ),
            ],
          ),
          if (selected != null) ...<Widget>[
            const SizedBox(height: 14),
            _SiteCard(site: selected),
          ],
          const SizedBox(height: 22),
          Text(l.surfaceMapSites,
              style: TextStyle(
                  fontFamily: headingFont,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: p.text)),
          const SizedBox(height: 10),
          for (final s in _sites)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _selected = s),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: p.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: identical(s, selected) ? p.accent : p.border,
                        width: identical(s, selected) ? 1.5 : 1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: siteColor(s.kind), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(s.name,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: p.text)),
                            Text('${s.agency} · ${s.year}',
                                style:
                                    TextStyle(fontSize: 12, color: p.muted)),
                          ],
                        ),
                      ),
                      Text(siteKindLabel(l, s.kind),
                          style: TextStyle(fontSize: 12, color: p.muted)),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(l.surfaceMapNote,
              style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
        ],
      ),
    );
  }
}

/// "0.67° N, 23.47° E"
String formatLatLon(double lat, double lon) {
  final ns = lat >= 0 ? 'N' : 'S';
  final ew = lon >= 0 ? 'E' : 'W';
  return '${lat.abs().toStringAsFixed(2)}° $ns, '
      '${lon.abs().toStringAsFixed(2)}° $ew';
}

class _SiteCard extends StatelessWidget {
  const _SiteCard({required this.site});

  final SurfaceSite site;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    return SurfaceCard(
      borderColor: siteColor(site.kind),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('${site.year}',
                  style: TextStyle(
                      fontFamily: headingFont,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: p.accentText)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(site.name,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: p.text)),
              ),
            ],
          ),
          Text(
              '${site.agency} · ${siteKindLabel(l, site.kind)} · '
              '${formatLatLon(site.lat, site.lon)}',
              style: TextStyle(fontSize: 12, color: p.muted)),
          const SizedBox(height: 8),
          Text(siteText(l, site.id),
              style: TextStyle(fontSize: 14, color: p.text, height: 1.4)),
        ],
      ),
    );
  }
}

class _SurfaceMapPainter extends CustomPainter {
  _SurfaceMapPainter({
    required this.world,
    required this.sites,
    required this.selected,
    required this.scale,
    required this.labelFor,
    required this.nearSide,
    required this.farSide,
    required this.textColor,
  });

  final SurfaceWorld world;
  final List<SurfaceSite> sites;
  final SurfaceSite? selected;
  final double scale;
  final String Function(String id) labelFor;
  final String nearSide;
  final String farSide;
  final Color textColor;

  /// Flat (equirectangular) map: longitude across, latitude down.
  static Offset project(double lat, double lon, Size size) => Offset(
        (lon + 180) / 360 * size.width,
        (90 - lat) / 180 * size.height,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final moon = world == SurfaceWorld.moon;
    canvas.clipRect(Offset.zero & size);

    // The ground.
    final base = moon ? const Color(0xFF9C978E) : const Color(0xFFB5683F);
    final shade = moon ? const Color(0xFF55524D) : const Color(0xFF6E3A22);
    final high = moon ? const Color(0xFFC4BFB5) : const Color(0xFFD9915F);
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    final sx = size.width / 360;
    final sy = size.height / 180;

    void ellipse(SurfaceFeature f, double dx, Paint paint) {
      final c = project(f.lat, f.lon, size) + Offset(dx, 0);
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(-f.tilt * math.pi / 180);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset.zero, width: f.rx * 2 * sx, height: f.ry * 2 * sy),
          paint);
      canvas.restore();
    }

    for (final f in featuresOf(world)) {
      for (final dx in <double>[-size.width, 0, size.width]) {
        switch (f.kind) {
          case FeatureKind.sea:
            ellipse(f, dx, Paint()..color = shade.withValues(alpha: 0.62));
          case FeatureKind.basin:
            ellipse(f, dx, Paint()..color = shade.withValues(alpha: 0.42));
            ellipse(
                f,
                dx,
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.2
                  ..color = shade.withValues(alpha: 0.7));
          case FeatureKind.crater:
            ellipse(f, dx, Paint()..color = high.withValues(alpha: 0.9));
            ellipse(
                f,
                dx,
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = shade.withValues(alpha: 0.8));
          case FeatureKind.volcano:
            ellipse(f, dx, Paint()..color = high.withValues(alpha: 0.85));
            ellipse(
                f,
                dx,
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.2
                  ..color = shade.withValues(alpha: 0.8));
          case FeatureKind.canyon:
            ellipse(f, dx, Paint()..color = shade.withValues(alpha: 0.85));
          case FeatureKind.highland:
            ellipse(f, dx, Paint()..color = high.withValues(alpha: 0.5));
          case FeatureKind.cap:
            ellipse(f, dx, Paint()..color = Colors.white.withValues(alpha: 0.9));
        }
      }
    }

    // A grid every 30 degrees, with the degrees written at the edge.
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..strokeWidth = 0.6 / scale;
    for (var lon = -180; lon <= 180; lon += 30) {
      final x = (lon + 180) * sx;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var lat = -90; lat <= 90; lat += 30) {
      final y = (90 - lat) * sy;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final small = 9 / scale;
    for (var lon = -150; lon <= 150; lon += 60) {
      _text(canvas, '$lon°', Offset((lon + 180) * sx + 2 / scale, 1), small,
          Colors.white.withValues(alpha: 0.7));
    }
    for (var lat = -60; lat <= 60; lat += 30) {
      _text(canvas, '$lat°', Offset(2 / scale, (90 - lat) * sy - small - 1),
          small, Colors.white.withValues(alpha: 0.7));
    }

    if (moon) {
      _text(canvas, nearSide, project(-72, 0, size), 11 / scale,
          Colors.white.withValues(alpha: 0.85),
          center: true, bold: true);
      _text(canvas, farSide, project(-72, 150, size), 11 / scale,
          Colors.white.withValues(alpha: 0.85),
          center: true, bold: true);
    }

    // Names of the landforms.
    for (final f in featuresOf(world)) {
      if (f.kind == FeatureKind.cap) {
        continue;
      }
      if (!f.major && scale < 2.2) {
        continue;
      }
      _text(canvas, labelFor(f.id).split(' (').first,
          project(f.lat, f.lon, size), 10 / scale, Colors.white,
          center: true, shadow: true);
    }

    // The landing sites.
    for (final s in sites) {
      final c = project(s.lat, s.lon, size);
      final isSelected = identical(s, selected);
      final r = (isSelected ? 8.0 : 5.5) / scale;
      canvas.drawCircle(
          c,
          r + 1.6 / scale,
          Paint()
            ..color = isSelected ? Colors.white : Colors.black.withValues(alpha: 0.55));
      canvas.drawCircle(c, r, Paint()..color = siteColor(s.kind));
      if (isSelected || scale >= 2.6) {
        _text(canvas, s.name, c + Offset(r + 3 / scale, -5 / scale), 10 / scale,
            Colors.white,
            shadow: true, bold: true);
      }
    }
  }

  void _text(Canvas canvas, String text, Offset at, double size, Color color,
      {bool center = false, bool bold = false, bool shadow = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          shadows: shadow
              ? <Shadow>[
                  Shadow(
                      color: Colors.black.withValues(alpha: 0.9),
                      blurRadius: 2 / scale),
                ]
              : null,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center ? at - Offset(tp.width / 2, tp.height / 2) : at);
  }

  @override
  bool shouldRepaint(_SurfaceMapPainter old) =>
      old.scale != scale ||
      !identical(old.selected, selected) ||
      old.world != world ||
      old.nearSide != nearSide;
}
