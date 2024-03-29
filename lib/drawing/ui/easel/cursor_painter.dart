import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';

class CursorPainter extends CustomPainter {
  CursorPainter({
    required this.frameSize,
    required this.lastStroke,
  });

  final Size frameSize;
  final Stroke lastStroke;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / frameSize.width;
    canvas.scale(scale);
    _drawCursor(
      canvas,
      lastStroke.lastPoint,
      lastStroke.width / 2,
      scale,
    );
  }

  @override
  bool shouldRepaint(CursorPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CursorPainter oldDelegate) => false;

  void _drawCursor(
    Canvas canvas,
    Offset center,
    double radius,
    double scale,
  ) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 / scale
        ..color = Colors.white,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 / scale
        ..color = Colors.black,
    );
  }
}
