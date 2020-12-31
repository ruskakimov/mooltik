import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'tool.dart';

class Eraser extends Tool {
  Eraser({double strokeWidth})
      : assert(strokeWidth != null),
        super(
          FontAwesomeIcons.eraser,
          Paint()
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..blendMode = BlendMode.dstOut,
        );

  @override
  Stroke makeStroke(Offset startPoint, Color color) {
    return Stroke(startPoint, paint);
  }
}
