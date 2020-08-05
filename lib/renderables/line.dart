import 'dart:ui';

import 'package:flutter/material.dart';

import 'renderable.dart';

class Line extends Renderable {
  Line(this.points);

  final List<Offset> points;

  void append(Offset point) {
    points.add(point);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    points.forEach((pos) => path.lineTo(pos.dx, pos.dy));
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.red,
    );
  }
}
