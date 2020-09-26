import 'dart:ui';

import 'package:flutter/material.dart';

class Stroke {
  Stroke(Offset startingPoint, this.paint)
      : assert(startingPoint != null),
        _path = Path()..moveTo(startingPoint.dx, startingPoint.dy),
        _lastPoint = startingPoint;

  final Paint paint;
  final Path _path;
  Offset _lastPoint;

  Rect get boundingRect => _path.getBounds().inflate(paint.strokeWidth);

  void extend(Offset point) {
    if (_lastPoint == point) return;
    final mid = _midPoint(_lastPoint, point);
    _path.quadraticBezierTo(_lastPoint.dx, _lastPoint.dy, mid.dx, mid.dy);
    _lastPoint = point;
  }

  void finish() {
    // Extend by a small amount, so a single point stroke is painted.
    extend(_lastPoint.translate(0.01, 0.01));
  }

  Offset _midPoint(Offset p1, Offset p2) {
    return p1 + (p2 - p1) / 2;
  }

  void paintOn(Canvas canvas) {
    canvas.drawPath(_path, paint);
  }
}
