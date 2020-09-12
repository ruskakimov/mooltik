import 'dart:ui';

import 'package:flutter/material.dart';

class Stroke {
  Stroke(Offset startingPoint, this.paint)
      : points = [startingPoint],
        assert(startingPoint != null);

  final List<Offset> points;
  final Paint paint;

  void extend(Offset point) {
    if (points.isNotEmpty && point == points.last) {
      return;
    }
    points.add(point);
  }

  void finish() {
    if (points.length == 1) {
      extend(points.first.translate(-0.1, 0.1));
    }
  }

  Offset _midPoint(Offset p1, Offset p2) {
    return p1 + (p2 - p1) / 2;
  }

  void paintOn(Canvas canvas) {
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      final p1 = points[i - 1];
      final p2 = points[i];
      final mid = _midPoint(p1, p2);
      path.quadraticBezierTo(p1.dx, p1.dy, mid.dx, mid.dy);
    }

    canvas.drawPath(path, paint);
  }
}
