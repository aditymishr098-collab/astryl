import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../theme.dart';
import 'common.dart';

/// Turns the planet card on screen into a PNG for sharing, with a small
/// Heliora footer underneath.
Future<Uint8List> renderShareCard(
    RenderRepaintBoundary boundary, Palette palette) async {
  const ratio = 3.0;
  const pad = 48.0;
  const footer = 132.0;
  final card = await boundary.toImage(pixelRatio: ratio);
  final width = card.width + pad * 2;
  final height = card.height + pad * 2 + footer;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height), Paint()..color = palette.background);
  canvas.drawImage(card, const Offset(pad, pad), Paint());

  final top = pad + card.height + 28;
  canvas.save();
  canvas.translate(pad, top);
  const HelioraLogoPainter().paint(canvas, const Size(80, 80));
  canvas.restore();

  final title = TextPainter(
    text: TextSpan(
      text: 'Heliora',
      style: TextStyle(
          color: palette.text, fontSize: 42, fontWeight: FontWeight.w700),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  title.paint(canvas, Offset(pad + 104, top));
  final link = TextPainter(
    text: TextSpan(
      text: 'github.com/lumio-apps/heliora',
      style: TextStyle(color: palette.muted, fontSize: 26),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  link.paint(canvas, Offset(pad + 104, top + 50));

  final picture = recorder.endRecording();
  final image = await picture.toImage(width.round(), height.round());
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  card.dispose();
  image.dispose();
  picture.dispose();
  if (data == null) {
    throw const FormatException('Could not make the image');
  }
  return data.buffer.asUint8List();
}
