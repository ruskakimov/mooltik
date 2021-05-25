import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'brush.dart';

class PaintBrush extends Brush {
  PaintBrush(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  String get name => 'paint_brush';

  @override
  IconData get icon => FontAwesomeIcons.paintBrush;

  @override
  List<Paint> get brushTips => [
        Paint()
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
        Paint()
          ..strokeWidth = 10
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
        Paint()
          ..strokeWidth = 20
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
      ];

  @override
  double get minStrokeWidth => 5;

  @override
  double get maxStrokeWidth => 50;
}
