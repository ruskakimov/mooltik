import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tool.dart';

abstract class Brush extends Tool {
  Brush(this.paint, SharedPreferences sharedPreferences)
      : super(sharedPreferences) {
    // Restore selected stroke width.
    if (sharedPreferences.containsKey(strokeWidthKey)) {
      paint.strokeWidth = sharedPreferences.getDouble(strokeWidthKey);
    }

    // Default to middle stroke width option if none selected.
    if (strokeWidthOptions.isNotEmpty &&
        !strokeWidthOptions.contains(paint.strokeWidth)) {
      final midIndex = strokeWidthOptions.length ~/ 2;
      paint.strokeWidth = strokeWidthOptions[midIndex];
    }

    // Restore selected color.
    if (sharedPreferences.containsKey(colorKey)) {
      paint.color = Color(sharedPreferences.getInt(colorKey));
    }
  }

  final Paint paint;

  double get maxStrokeWidth;
  double get minStrokeWidth;

  List<double> get strokeWidthOptions;

  /// Tool name used to prefix shared preferences keys.
  String get name;

  /// Shared preferences key for stroke width.
  String get strokeWidthKey => name + '_stroke_width';

  /// Shared preferences key for color.
  String get colorKey => name + '_color';

  double get strokeWidth => paint.strokeWidth;

  Color get color => paint.color.withOpacity(1);

  double get opacity => paint.color.opacity;

  set strokeWidth(double value) {
    assert(strokeWidth <= maxStrokeWidth && strokeWidth >= minStrokeWidth);
    paint.strokeWidth = value;
    sharedPreferences.setDouble(strokeWidthKey, strokeWidth);
  }

  set color(Color color) {
    paint.color = color.withOpacity(opacity);
    sharedPreferences.setInt(colorKey, paint.color.value);
  }

  set opacity(double value) {
    assert(opacity >= 0 && opacity <= 1);
    paint.color = paint.color.withOpacity(value);
    sharedPreferences.setInt(colorKey, paint.color.value);
  }

  Stroke makeStroke(Offset startPoint);
}
