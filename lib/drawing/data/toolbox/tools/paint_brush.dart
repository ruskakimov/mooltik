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
  BlendMode get blendMode => BlendMode.srcOver;

  @override
  double get minStrokeWidth => 5;

  @override
  double get maxStrokeWidth => 100;

  @override
  List<BrushTip> get defaultBrushTips => [
        BrushTip(strokeWidth: 5, opacity: 1, blur: 0.5),
        BrushTip(strokeWidth: 10, opacity: 1, blur: 0.5),
        BrushTip(strokeWidth: 20, opacity: 1, blur: 0.5),
      ];
}
