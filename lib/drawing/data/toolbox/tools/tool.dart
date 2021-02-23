import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Tool {
  Tool(this.icon, this.paint, this.sharedPreferences)
      : assert(sharedPreferences != null) {
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
      paint.color = Colors.black.withOpacity(
        // This is to default back to black, if another color was selected before and saved to shared prefs.
        // TODO: Remove once color picker is added.
        Color(sharedPreferences.getInt(colorKey)).opacity,
      );
    }
  }

  final IconData icon;
  final Paint paint;
  final SharedPreferences sharedPreferences;

  double get maxStrokeWidth;
  double get minStrokeWidth;

  List<double> get strokeWidthOptions;

  /// Tool name used to prefix shared preferences keys.
  String get name;

  /// Shared preferences key for stroke width.
  String get strokeWidthKey => name + '_stroke_width';

  double get strokeWidth => paint.strokeWidth;

  set strokeWidth(double value) {
    assert(strokeWidth <= maxStrokeWidth && strokeWidth >= minStrokeWidth);
    paint.strokeWidth = value;
    sharedPreferences.setDouble(strokeWidthKey, strokeWidth);
  }

  /// Shared preferences key for color.
  String get colorKey => name + '_color';

  Stroke makeStroke(Offset startPoint);
}
