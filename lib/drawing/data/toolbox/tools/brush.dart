import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'tool.dart';

class Brush extends Tool {
  Brush({
    double strokeWidth = 100,
    Color color = Colors.black26,
  })  : assert(strokeWidth != null),
        assert(color != null),
        super(
          FontAwesomeIcons.paintBrush,
          Paint()
            ..strokeWidth = strokeWidth
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.bevel
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
        );

  @override
  Stroke makeStroke(Offset startPoint) {
    return Stroke(startPoint, paint);
  }

  @override
  double get maxStrokeWidth => 200;

  @override
  double get minStrokeWidth => 10;

  @override
  List<double> get strokeWidthOptions => [50, 100, 200];
}
