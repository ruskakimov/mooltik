import 'dart:ui';

import 'package:flutter/material.dart';

class Stroke {
  Stroke(Offset startingPoint, this.paint)
      : points = [startingPoint],
        assert(startingPoint != null);

  final List<Offset> points;
  final Paint paint;

  void extend(Offset point) {
    points.add(point);
  }

  void paintOn(Canvas canvas) {
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    points.skip(1).forEach((p) => path.lineTo(p.dx, p.dy));

    canvas.drawPath(path, paint);
  }
}
