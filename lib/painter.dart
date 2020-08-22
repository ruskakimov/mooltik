import 'package:flutter/material.dart';

import 'stroke.dart';

class Painter extends CustomPainter {
  Painter(this.strokes);

  final List<Stroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) stroke.paint(canvas);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(Painter oldDelegate) => false;
}
