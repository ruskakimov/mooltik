import 'dart:math';

import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
  TimelinePainter({
    @required this.frameHeight,
    @required this.offset,
    @required this.emptyKeyframes,
    @required this.keyframes,
    @required this.animationDuration,
  });

  /// Width of a single frame in pixels on a timeline.
  final double frameHeight;

  /// Pixel offset from the first frame.
  final double offset;

  /// Sorted list of empty keyframes' numbers.
  final List<int> emptyKeyframes;

  /// Sorted list of keyframes' numbers.
  final List<int> keyframes;

  /// Duration of the whole animation in frames.
  final int animationDuration;

  final linePaint = Paint()
    ..color = Colors.grey[200]
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  final keyframePaint = Paint()
    ..color = Colors.grey[200]
    ..style = PaintingStyle.fill;

  double _frameY(int frameNumber, double midY) {
    return midY - offset + (frameNumber - 1) * frameHeight;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = Colors.black.withOpacity(0.2);

    final midX = size.width / 2;
    final midY = size.height / 2;
    final startY = _frameY(1, midY);
    final endY = _frameY(animationDuration + 1, midY);

    // Frame grid.
    final gridStart = startY < 0 ? -(startY.abs() % (frameHeight * 2)) : startY;
    for (var y = gridStart; y <= size.height; y += frameHeight * 2) {
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, frameHeight),
        gridPaint,
      );
    }

    // Timeline.
    canvas.drawLine(
      Offset(midX, max(startY, 0)),
      Offset(midX, min(endY, size.height)),
      linePaint,
    );
    canvas.drawLine(
      Offset(0, endY),
      Offset(size.width, endY),
      linePaint,
    );

    for (final keyframeNumber in keyframes) {
      _drawKeyframe(
        canvas,
        Offset(midX, _frameY(keyframeNumber, midY)),
      );
    }

    // Playhead.
    canvas.drawLine(
      Offset(0, midY),
      Offset(size.width, midY),
      Paint()
        ..color = Colors.amber
        ..strokeWidth = 2,
    );
  }

  void _drawKeyframe(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 8, keyframePaint);
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}
