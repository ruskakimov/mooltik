import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'brush.dart';

class Eraser extends Brush {
  Eraser(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  String get name => 'eraser';

  @override
  IconData get icon => MdiIcons.eraser;

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
