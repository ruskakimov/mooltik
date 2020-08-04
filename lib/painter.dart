import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  Painter({this.dots});

  final List<Offset> dots;

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = Colors.red;
    dots.forEach((position) => canvas.drawCircle(position, 10, dotPaint));
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(Painter oldDelegate) => false;
}
