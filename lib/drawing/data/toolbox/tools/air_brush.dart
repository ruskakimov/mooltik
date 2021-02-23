import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class AirBrush extends Tool {
  AirBrush(SharedPreferences sharedPreferences)
      : super(
          FontAwesomeIcons.sprayCan,
          Paint()
            ..color = Colors.black26
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.bevel
            // TODO: Change blur to 50% of stroke size
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 25),
          sharedPreferences,
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

  @override
  String get name => 'air_brush';
}
