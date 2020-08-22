import 'package:flutter/material.dart';

import 'frame.dart';

class FramePainter extends CustomPainter {
  FramePainter(this.frame);

  final Frame frame;

  @override
  void paint(Canvas canvas, Size size) {
    frame.paint(canvas);
  }

  @override
  bool shouldRepaint(FramePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(FramePainter oldDelegate) => false;
}
