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

    final midX = size.width / 2;
    final midY = size.height / 2;
    final firstFrameX = midX - offset;

    for (var x = firstFrameX; x <= size.width; x += frameWidth * 2) {
      canvas.drawRect(
        Rect.fromLTWH(x, 0, frameWidth, size.height),
        gridPaint,
      );
    }

    // Draw line and keyframes on a new frame, so they can be composited.
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // Timeline.
    canvas.drawLine(
      Offset(firstFrameX, midY),
      Offset(size.width, midY),
      linePaint,
    );

    // Empty keyframe.
    canvas.drawCircle(
      Offset(firstFrameX, midY),
      8,
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.drawCircle(
      Offset(firstFrameX, midY),
      8,
      linePaint,
    );

    // Merge and erase line inside empty keyframe.
    canvas.restore();

    canvas.drawLine(
      Offset(midX, 0),
      Offset(midX, size.height),
      Paint()
        ..color = Colors.amber
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}
