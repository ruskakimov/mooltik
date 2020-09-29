import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/frame/stroke.dart';

abstract class Tool {
  Tool(IconData icon, Paint paint)
      : _icon = icon,
        _paint = paint;

  final IconData _icon;
  final Paint _paint;

  IconData get icon => _icon;
  Paint get paint => _paint;

  Stroke makeStroke(Offset startPoint, Color color);
}

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
    return Stroke(startPoint, _paint..color = color);
  }
}

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
    return Stroke(startPoint, _paint);
  }
}
