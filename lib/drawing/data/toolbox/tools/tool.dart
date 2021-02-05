import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Tool {
  Tool(this.icon, this.paint, SharedPreferences sharedPreferences)
      : assert(sharedPreferences != null) {
    // Restore selected stroke width.
    paint.strokeWidth = sharedPreferences.containsKey(strokeWidthKey)
        ? sharedPreferences.getDouble(strokeWidthKey)
        : strokeWidthOptions[1];

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

  double get maxStrokeWidth;
  double get minStrokeWidth;

  List<double> get strokeWidthOptions;

  /// Tool name used to prefix shared preferences keys.
  String get name;

  /// Shared preferences key for stroke width.
  String get strokeWidthKey => name + '_stroke_width';

  /// Shared preferences key for color.
  String get colorKey => name + '_color';

  Stroke makeStroke(Offset startPoint);
}
