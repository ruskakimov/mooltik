import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'tool.dart';

class Eraser extends Tool {
  Eraser({double strokeWidth, double opacity = 1})
      : assert(strokeWidth != null),
        assert(opacity != null),
        super(
          FontAwesomeIcons.eraser,
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.black.withOpacity(opacity)
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..blendMode = BlendMode.dstOut,
        );

  @override
  Stroke makeStroke(Offset startPoint) {
    return Stroke(startPoint, paint);
  }

  @override
  double get maxStrokeWidth => 300;

  @override
  double get minStrokeWidth => 10;

  @override
  List<double> get strokeWidthOptions => [20, 100, 300];
}
