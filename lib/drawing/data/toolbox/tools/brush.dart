import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tool.dart';

abstract class Brush extends Tool {
  Brush(SharedPreferences sharedPreferences) : super(sharedPreferences) {
    // Restore selected color.
    if (sharedPreferences.containsKey(_colorKey)) {
      _color = Color(sharedPreferences.getInt(_colorKey));
    }

    // Restore selected opacity.
    if (sharedPreferences.containsKey(_opacityKey)) {
      _opacity = sharedPreferences.getDouble(_opacityKey);
    }

    // Restore selected brush tip.
    if (sharedPreferences.containsKey(_selectedBrushTipIndexKey)) {
      _selectedBrushTipIndex =
          sharedPreferences.getInt(_selectedBrushTipIndexKey);
    }
  }

  List<Paint> get brushTips;

  double get minStrokeWidth;
  double get maxStrokeWidth;

  Paint get paint =>
      brushTips[_selectedBrushTipIndex]..color = _color.withOpacity(_opacity);

  /// Brush color.
  Color get color => _color;
  Color _color = Colors.black;
  set color(Color color) {
    _color = color;
    sharedPreferences.setInt(_colorKey, _color.value);
  }

  /// Brush opacity.
  double get opacity => _opacity;
  double _opacity = 1;
  set opacity(double value) {
    assert(value >= 0 && value <= 1);
    _opacity = value;
    sharedPreferences.setDouble(_opacityKey, _opacity);
  }

  /// Index of a selected brush tip option.
  int get selectedBrushTipIndex => _selectedBrushTipIndex;
  int _selectedBrushTipIndex = 0;
  set selectedBrushTipIndex(int index) {
    // assert();
    _selectedBrushTipIndex = index;
    sharedPreferences.setInt(_selectedBrushTipIndexKey, index);
  }

  // ========================
  // Shared preferences keys:
  // ========================

  String get _colorKey => name + '_color';
  String get _opacityKey => name + '_opacity';
  String get _selectedBrushTipIndexKey => name + '_selected_brush_tip_index';
}
