import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Tool {
  Tool(this.sharedPreferences) : assert(sharedPreferences != null);

  /// Icon diplayed on the tool's button.
  IconData get icon;

  /// Tool name used to prefix shared preferences keys.
  String get name;

  final SharedPreferences sharedPreferences;
}

abstract class ToolWithColor extends Tool {
  ToolWithColor(SharedPreferences sharedPreferences)
      : super(sharedPreferences) {
    // Restore selected color.
    if (sharedPreferences.containsKey(_colorKey)) {
      _color = Color(sharedPreferences.getInt(_colorKey));
    }
  }

  /// Tool color.
  Color get color => _color;
  Color _color = Colors.black;
  set color(Color color) {
    _color = color;
    sharedPreferences.setInt(_colorKey, _color.value);
  }

  // ========================
  // Shared preferences keys:
  // ========================

  String get _colorKey => name + '_color';
}
