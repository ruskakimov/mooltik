import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
  final linePaint = Paint()
    ..color = Colors.grey[200]
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      8,
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width / 2 + 8, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}
