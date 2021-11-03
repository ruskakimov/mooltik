import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

const _hueWheelWidth = 32.0;

class ColorWheel extends StatelessWidget {
  const ColorWheel({
    Key? key,
    required this.selectedColor,
    this.onSelected,
  }) : super(key: key);

  final Color selectedColor;
  final void Function(Color)? onSelected;

  @override
  Widget build(BuildContext context) {
    final hsv = HSVColor.fromColor(selectedColor);

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(builder: (context, constraints) {
          final outerRadius = constraints.maxWidth / 2;
          final innerRadius = outerRadius - _hueWheelWidth;
          final squareWidth = innerRadius * 2 / sqrt2 - 8;
          final squarePadding = (outerRadius - squareWidth / 2).ceilToDouble();

          final huePointerHandler = (PointerEvent e) {
            final x = e.localPosition.dx - outerRadius;
            final y = e.localPosition.dy - outerRadius;
            final distanceFromCenter = sqrt(pow(x, 2) + pow(y, 2));
            final cosAngle = x / distanceFromCenter;
            var angle = acos(cosAngle) * 180 / pi;
            if (y > 0) angle = 360 - angle;
            onSelected?.call(
              hsv.withHue(angle).toColor(),
            );
          };

          final shadePointerHandler = (PointerEvent e) {
            final newSaturation =
                e.localPosition.dx.clamp(0, squareWidth) / squareWidth;
            final newValue =
                1.0 - e.localPosition.dy.clamp(0, squareWidth) / squareWidth;
            onSelected?.call(
              hsv.withSaturation(newSaturation).withValue(newValue).toColor(),
            );
          };

          final hueWheelLayer = Listener(
            onPointerDown: huePointerHandler,
            onPointerMove: huePointerHandler,
            child: CustomPaint(
              isComplex: true,
              willChange: false,
              painter: HueWheelPainter(
                outerRadius: outerRadius,
                innerRadius: innerRadius,
              ),
            ),
          );

          final shadeSquareLayer = Padding(
            padding: EdgeInsets.all(squarePadding),
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: shadePointerHandler,
              onPointerMove: shadePointerHandler,
              child: CustomPaint(painter: ShadeSquarePainter(hue: hsv.hue)),
            ),
          );

          final midRadius = (outerRadius + innerRadius) / 2;
          final cosHue = cos(-hsv.hue * pi / 180);
          final sinHue = sin(-hsv.hue * pi / 180);
          final xHue = (midRadius * cosHue) + outerRadius;
          final yHue = (midRadius * sinHue) + outerRadius;

          final xSaturation = squarePadding + squareWidth * hsv.saturation;
          final yValue = squarePadding + squareWidth * (1 - hsv.value);

          return Stack(
            fit: StackFit.expand,
            children: [
              hueWheelLayer,
              shadeSquareLayer,
              Positioned(
                left: xHue,
                top: yHue,
                child: _Indicator(
                  color: HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor(),
                ),
              ),
              Positioned(
                left: xSaturation,
                top: yValue,
                child: _Indicator(color: selectedColor),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = _hueWheelWidth - 8;

    return IgnorePointer(
      child: Transform.translate(
        offset: Offset(-size / 2, -size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)],
            shape: BoxShape.circle,
          ),
        ),
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
  bool shouldRepaint(HueWheelPainter oldDelegate) =>
      outerRadius != oldDelegate.outerRadius ||
      innerRadius != oldDelegate.innerRadius;

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
