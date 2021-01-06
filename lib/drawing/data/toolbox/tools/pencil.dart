import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'tool.dart';

class Pencil extends Tool {
  Pencil({
    double strokeWidth,
    Color color = Colors.black,
  })  : assert(strokeWidth != null),
        assert(color != null),
        super(
          FontAwesomeIcons.paintBrush,
          Paint()
            ..strokeWidth = strokeWidth
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
        );

  @override
  Stroke makeStroke(Offset startPoint, Color color) {
    return Stroke(startPoint, paint..color = color);
  }
}
