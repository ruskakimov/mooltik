import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'brush.dart';

class Eraser extends Brush {
  Eraser(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  String get name => 'eraser';

  @override
  IconData get icon => FontAwesomeIcons.eraser;

  @override
  List<Paint> get brushTips => [
        Paint()
          ..strokeWidth = 20
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.dstOut,
        Paint()
          ..strokeWidth = 100
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.dstOut,
        Paint()
          ..strokeWidth = 300
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.dstOut,
      ];

  @override
  double get minStrokeWidth => 10;

  @override
  double get maxStrokeWidth => 300;
}
