import 'dart:ui';

import 'package:flutter/material.dart';

import 'renderable.dart';

class Line extends Renderable {
  Line({
    @required List<Offset> points,
    @required double width,
    @required Color color,
  })  : _points = points,
        _paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..color = color;

  final List<Offset> _points;
  final Paint _paint;

  void add(Offset point) {
    _points.add(point);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_points.isEmpty) return;

    final path = Path();
    path.moveTo(_points.first.dx, _points.first.dy);
    _points.forEach((pos) => path.lineTo(pos.dx, pos.dy));
    canvas.drawPath(
      path,
      _paint,
    );
  }
}
