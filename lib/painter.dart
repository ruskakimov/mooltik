import 'package:flutter/material.dart';

import 'renderables/line.dart';

class Painter extends CustomPainter {
  Painter({this.lines});

  final List<Line> lines;

  @override
  void paint(Canvas canvas, Size size) {
    lines.forEach((line) => line.paint(canvas, size));
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(Painter oldDelegate) => false;
}
