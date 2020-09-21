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
    final gridPaint = Paint()..color = Colors.black.withOpacity(0.2);

    for (var x = size.width / 2 - offset;
        x <= size.width;
        x += frameWidth * 2) {
      canvas.drawRect(
        Rect.fromLTWH(x, 0, frameWidth, size.height),
        gridPaint,
      );
    }

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    canvas.drawLine(
      Offset(size.width / 2 - offset, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );

    canvas.drawCircle(
      Offset(size.width / 2 - offset, size.height / 2),
      8,
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.drawCircle(
      Offset(size.width / 2 - offset, size.height / 2),
      8,
      linePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}
