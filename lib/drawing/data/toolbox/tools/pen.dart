import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class Pen extends Tool {
  Pen(SharedPreferences sharedPreferences)
      : super(
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
          sharedPreferences,
        );

  @override
  String get name => 'pen';

  @override
  IconData get icon => FontAwesomeIcons.marker;

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
