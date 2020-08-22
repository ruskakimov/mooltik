import 'dart:ui';

import 'package:flutter/material.dart';

class Stroke {
  Stroke(Offset startingPoint)
      : points = [startingPoint],
        assert(startingPoint != null);

  final List<Offset> points;

  void extend(Offset point) {
    points.add(point);
  }

  void paint(Canvas canvas) {
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    points.skip(1).forEach((p) => path.lineTo(p.dx, p.dy));

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.black,
    );
  }
}
