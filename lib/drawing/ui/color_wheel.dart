import 'dart:ui' as ui;
import 'package:flutter/material.dart';

const _hueWheelWidth = 36.0;

class ColorWheel extends StatelessWidget {
  const ColorWheel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(builder: (context, constraints) {
          final outerRadius = constraints.maxWidth / 2;
          final innerRadius = outerRadius - _hueWheelWidth;

          return CustomPaint(
            painter: WheelPainter(
              hue: 0,
              outerRadius: outerRadius,
              innerRadius: innerRadius,
            ),
          );
        }),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  WheelPainter({
    required this.hue,
    required this.outerRadius,
    required this.innerRadius,
  });

  final double hue;
  final double outerRadius;
  final double innerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(outerRadius, outerRadius);
    final bounds = Offset.zero & size;

    canvas.saveLayer(bounds, Paint());

    canvas.drawCircle(
      center,
      outerRadius,
      Paint()
        ..shader = ui.Gradient.sweep(center, [
          Color(0xFFFF0000), // Red
          Color(0xFFFF00FF), // Magenta
          Color(0xFF0000FF), // Blue
          Color(0xFF00FFFF), // Cyan
          Color(0xFF00FF00), // Green
          Color(0xFFFFFF00), // Yellow
          Color(0xFFFF0000), // Red
        ], [
          0.000,
          0.166,
          0.333,
          0.499,
          0.666,
          0.833,
          0.999
        ]),
    );

    canvas.drawCircle(
      center,
      innerRadius,
      Paint()..blendMode = BlendMode.clear,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(WheelPainter oldDelegate) => false;
}
