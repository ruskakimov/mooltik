import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  Painter({this.lines});

  final List<List<Offset>> lines;

  @override
  void paint(Canvas canvas, Size size) {
    lines.forEach((line) => _paintLine(canvas, line));
  }

  void _paintLine(Canvas canvas, List<Offset> line) {
    final path = Path();
    path.moveTo(line.first.dx, line.first.dy);
    line.forEach((pos) => path.lineTo(pos.dx, pos.dy));
    canvas.drawPath(
      path,
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
