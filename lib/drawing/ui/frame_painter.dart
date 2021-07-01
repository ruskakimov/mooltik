import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';

import '../data/frame/frame.dart';

class FramePainter extends CustomPainter {
  FramePainter({
    required this.frame,
    this.strokes,
    this.filter,
  });

  final Frame frame;
  final List<Stroke?>? strokes;
  final ColorFilter? filter;

  bool get hasStrokes => strokes != null && strokes!.isNotEmpty;

  @override
  void paint(Canvas canvas, Size size) {
    // Clip paint outside canvas.
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Scale image to fit the given size.
    canvas.scale(
        size.width / frame.image.width!, size.height / frame.image.height!);

    if (hasStrokes) {
      // Save layer to erase paintings on it with `BlendMode.clear`.
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, frame.image.size.width, frame.image.size.height),
        Paint(),
      );
    }

    if (frame.image.snapshot != null) {
      canvas.drawImage(
        frame.image.snapshot!,
        Offset.zero,
        Paint()
          ..colorFilter = filter
          ..isAntiAlias = true
          ..filterQuality = FilterQuality.low,
      );
    }

    strokes?.forEach((stroke) => stroke!.paintOn(canvas));

    if (hasStrokes) {
      // Flatten layer. Combine drawing lines with erasing lines.
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(FramePainter oldDelegate) =>
      oldDelegate.frame.image.snapshot != frame.image.snapshot ||
      oldDelegate.strokes != strokes ||
      oldDelegate.filter != filter;

  @override
  bool shouldRebuildSemantics(FramePainter oldDelegate) => false;
}
