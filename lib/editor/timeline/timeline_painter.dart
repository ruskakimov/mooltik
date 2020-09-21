import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
  TimelinePainter({
    @required this.frameWidth,
    @required this.offset,
  });

  final double frameWidth;
  final double offset;

  final linePaint = Paint()
    ..color = Colors.grey[200]
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final frameGridPaint = Paint()
      ..color = Colors.blueGrey[800]
      ..strokeWidth = 2;

    for (var x = size.width / 2; x <= size.width; x += frameWidth) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), frameGridPaint);
    }

    canvas.drawCircle(
      Offset(size.width / 2 + offset, size.height / 2),
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
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}
