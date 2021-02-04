import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'tool.dart';

class Pen extends Tool {
  Pen({
    double strokeWidth,
    Color color = Colors.black,
  })  : assert(strokeWidth != null),
        assert(color != null),
        super(
          FontAwesomeIcons.marker,
          Paint()
            ..strokeWidth = strokeWidth
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
        );

  @override
  Stroke makeStroke(Offset startPoint) {
    return Stroke(startPoint, paint);
  }

  @override
  double get maxStrokeWidth => 50;

  @override
  double get minStrokeWidth => 5;

  @override
  List<double> get strokeWidthOptions => [5, 10, 20];
}
