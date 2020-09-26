import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/stroke.dart';

import 'frame_model.dart';

class FramePainter extends CustomPainter {
  FramePainter(this.frame, {this.strokes});

  final FrameModel frame;
  final List<Stroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    // Clip paint outside canvas.
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawColor(Colors.white, BlendMode.srcOver);

    // Scale image to fit the given size.
    canvas.scale(size.width / frame.width, size.height / frame.height);

    // Save layer to erase paintings on it with `BlendMode.clear`.
    canvas.saveLayer(Rect.fromLTWH(0, 0, frame.width, frame.height), Paint());

    if (frame.snapshot != null) {
      canvas.drawImage(frame.snapshot, Offset.zero, Paint());
    }

    frame.unrasterizedStrokes.forEach((stroke) => stroke.paintOn(canvas));

    strokes?.forEach((stroke) => stroke?.paintOn(canvas));

    // Flatten layer. Combine drawing lines with erasing lines.
    canvas.restore();
  }

  @override
  bool shouldRepaint(FramePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(FramePainter oldDelegate) => false;
}
