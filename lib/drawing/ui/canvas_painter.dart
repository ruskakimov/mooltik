import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';

class CanvasPainter extends CustomPainter {
  CanvasPainter({
    required this.image,
    this.strokes,
    this.filter,
  });

  final ui.Image? image;
  final List<Stroke?>? strokes;
  final ColorFilter? filter;

  bool get hasStrokes => strokes != null && strokes!.isNotEmpty;

  @override
  void paint(Canvas canvas, Size size) {
    final img = image; // For nullability analysis.
    if (img == null) return;

    final canvasArea = Rect.fromLTWH(0, 0, size.width, size.height);

    // Clip paint outside canvas.
    canvas.clipRect(canvasArea);

    // Scale image to fit the given size.
    canvas.scale(size.width / img.width, size.height / img.height);

    if (hasStrokes) {
      // Save layer to erase paintings on it with `BlendMode.clear`.
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        Paint(),
      );
    }

    canvas.drawImage(
      img,
      Offset.zero,
      Paint()
        ..colorFilter = filter
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.low,
    );

    strokes?.forEach((stroke) => stroke!.paintOn(canvas));

    if (hasStrokes) {
      // Flatten layer. Combine drawing lines with erasing lines.
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) =>
      oldDelegate.image != image ||
      oldDelegate.strokes != strokes ||
      oldDelegate.filter != filter;

  @override
  bool shouldRebuildSemantics(CanvasPainter oldDelegate) => false;
}
