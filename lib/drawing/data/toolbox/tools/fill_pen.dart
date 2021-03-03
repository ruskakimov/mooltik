import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class FillPen extends Tool {
  FillPen(SharedPreferences sharedPreferences)
      : super(
          Paint()
            ..color = Colors.black26
            ..style = PaintingStyle.fill
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
          sharedPreferences,
        );

  @override
  String get name => 'fill_pen';

  @override
  IconData get icon => FontAwesomeIcons.penFancy;

  @override
  Stroke makeStroke(Offset startPoint) {
    return Stroke(startPoint, paint);
  }

  @override
  double get maxStrokeWidth => 0;

  @override
  double get minStrokeWidth => 0;

  @override
  List<double> get strokeWidthOptions => [];
}
