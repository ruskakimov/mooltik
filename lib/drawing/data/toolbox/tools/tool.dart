import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef PaintOn = Future<ui.Image?> Function(ui.Image);

abstract class Tool {
  Tool(this.sharedPreferences);

  /// Icon diplayed on the tool's button.
  IconData get icon;

  /// Tool name used to prefix shared preferences keys.
  String get name;

  final SharedPreferences sharedPreferences;

  Stroke? onStrokeStart(Offset canvasPoint);
  void onStrokeUpdate(Offset canvasPoint);
  Stroke? onStrokeEnd();
  Stroke? onStrokeCancel();

  PaintOn? makePaintOn(Rect canvasArea);
}

abstract class ToolWithColor extends Tool {
  ToolWithColor(SharedPreferences sharedPreferences) : super(sharedPreferences);

  Color get color => _color;
  Color _color = Colors.black;

  void applyColor(Color color) {
    _color = color;
  }
}
