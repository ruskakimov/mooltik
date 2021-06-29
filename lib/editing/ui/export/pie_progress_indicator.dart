import 'dart:math';

import 'package:flutter/material.dart';

const double _rimWidth = 4;

class PieProgressIndicator extends StatelessWidget {
  const PieProgressIndicator({
    Key? key,
    required this.progress,
    this.color = Colors.white,
  }) : super(key: key);

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(64),
      painter: _PieLoadingPainter(progress, color),
    );
  }
}

class _PieLoadingPainter extends CustomPainter {
  _PieLoadingPainter(this.progress, this.color);

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(0, 0, size.width, size.height);
    final radius = size.width / 2;

    // Paint rim.
    canvas.drawCircle(
      area.center,
      radius - _rimWidth / 2,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = _rimWidth,
    );

    // Paint pie.
    canvas.drawArc(
      area.deflate(1),
      -pi / 2,
      2 * pi * progress,
      true,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_PieLoadingPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_PieLoadingPainter oldDelegate) => false;
}
