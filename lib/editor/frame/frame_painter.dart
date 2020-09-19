import 'package:flutter/material.dart';

import 'frame_model.dart';

class FramePainter extends CustomPainter {
  FramePainter(this.frame);

  final FrameModel frame;

  @override
  void paint(Canvas canvas, Size size) {
    // Clip paint outside canvas.
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Scale image to fit the given size.
    canvas.scale(size.width / frame.width, size.height / frame.height);

    frame.paintOn(canvas);
  }

  @override
  bool shouldRepaint(FramePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(FramePainter oldDelegate) => false;
}
