import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class AirBrush extends Tool {
  AirBrush(SharedPreferences sharedPreferences)
      : super(
          Paint()
            ..color = Colors.black26
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.bevel,
          sharedPreferences,
        ) {
    _updateBlur();
  }

  @override
  String get name => 'air_brush';

  @override
  IconData get icon => FontAwesomeIcons.sprayCan;

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

  @override
  set strokeWidth(double value) {
    super.strokeWidth = value;
    _updateBlur();
  }

  void _updateBlur() {
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth / 2);
  }
}
