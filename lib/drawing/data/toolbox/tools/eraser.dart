import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class Eraser extends Tool {
  Eraser(SharedPreferences sharedPreferences)
      : super(
          FontAwesomeIcons.eraser,
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..blendMode = BlendMode.dstOut,
          sharedPreferences,
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

  @override
  String get name => 'eraser';
}
