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
            isComplex: true,
            willChange: false,
            painter: HueWheelPainter(
              outerRadius: outerRadius,
              innerRadius: innerRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(_hueWheelWidth * 2),
              child: CustomPaint(painter: ShadeSquarePainter(hue: 0)),
            ),
          );
        }),
      ),
    );
  }
}

class HueWheelPainter extends CustomPainter {
  HueWheelPainter({
    required this.outerRadius,
    required this.innerRadius,
  });

  final double outerRadius;
  final double innerRadius;

  static const shader = SweepGradient(
    center: Alignment.center,
    colors: <Color>[
      Color.fromARGB(255, 255, 0, 0),
      Color.fromARGB(255, 255, 0, 255),
      Color.fromARGB(255, 0, 0, 255),
      Color.fromARGB(255, 0, 255, 255),
      Color.fromARGB(255, 0, 255, 0),
      Color.fromARGB(255, 255, 255, 0),
      Color.fromARGB(255, 255, 0, 0),
    ],
  );

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;

    canvas.saveLayer(bounds, Paint());

    canvas.drawCircle(
      bounds.center,
      outerRadius,
      Paint()..shader = shader.createShader(bounds),
    );

    // Erase inner circle.
    canvas.drawCircle(
      bounds.center,
      innerRadius,
      Paint()..blendMode = BlendMode.clear,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(HueWheelPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(HueWheelPainter oldDelegate) => false;
}

class ShadeSquarePainter extends CustomPainter {
  ShadeSquarePainter({required this.hue});

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;

    final fullySaturated = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
    final fullyDesaturated = HSVColor.fromAHSV(1, hue, 0, 1).toColor();

    canvas.drawRect(
      bounds,
      Paint()
        ..shader = ui.Gradient.linear(
          bounds.centerLeft,
          bounds.centerRight,
          [fullyDesaturated, fullySaturated],
        ),
    );

    canvas.drawRect(
      bounds,
      Paint()
        ..shader = ui.Gradient.linear(
          bounds.topLeft,
          bounds.bottomLeft,
          [Colors.transparent, Colors.black],
        ),
    );
  }

  @override
  bool shouldRepaint(ShadeSquarePainter oldDelegate) => hue != oldDelegate.hue;

  @override
  bool shouldRebuildSemantics(ShadeSquarePainter oldDelegate) => false;
}
