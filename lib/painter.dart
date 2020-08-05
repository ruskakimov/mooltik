import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  Painter({this.dots});

  final List<Offset> dots;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();

    p.moveTo(dots.first.dx, dots.first.dy);

    dots.forEach((pos) => p.lineTo(pos.dx, pos.dy));

    canvas.drawPath(
      p,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(Painter oldDelegate) => false;
}
