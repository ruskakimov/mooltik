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
  BlendMode get blendMode => BlendMode.dstOut;

  @override
  double get minStrokeWidth => 10;

  @override
  double get maxStrokeWidth => 300;

  @override
  List<BrushTip> get defaultBrushTips => [
        BrushTip(strokeWidth: 20, opacity: 1, blur: 0),
        BrushTip(strokeWidth: 100, opacity: 1, blur: 0),
        BrushTip(strokeWidth: 300, opacity: 1, blur: 0),
      ];
}
