import 'package:flutter/material.dart';

class Tool {
  Tool(Paint paint) : _paint = paint;

  final Paint _paint;

  Paint get paint => _paint;
}

class Pencil extends Tool {
  Pencil({
    double strokeWidth,
    Color color = Colors.black,
  })  : assert(strokeWidth != null),
        assert(color != null),
        super(Paint()
          ..strokeWidth = strokeWidth
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5));
}

class Eraser extends Tool {
  Eraser(double strokeWidth)
      : assert(strokeWidth != null),
        super(Paint()
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.clear);
}
