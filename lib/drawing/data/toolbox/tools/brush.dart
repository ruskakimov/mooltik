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

  List<BrushTip> brushTips;

  double get minStrokeWidth;
  double get maxStrokeWidth;

  Paint get paint {
    final tipPaintStyle = brushTips[_selectedBrushTipIndex].paint;
    return tipPaintStyle
      ..color = _color.withOpacity(tipPaintStyle.color.opacity);
  }

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
    assert(index >= 0 && index < brushTips.length);
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

class BrushTip {
  BrushTip({
    @required this.strokeWidth,
    @required this.opacity,
    @required this.blur,
  })  : assert(strokeWidth != null),
        assert(opacity != null && opacity >= 0 && opacity <= 1),
        assert(blur != null);

  final double strokeWidth;
  final double opacity;
  final double blur;

  BlendMode get blendMode => BlendMode.srcOver;

  Paint get paint => Paint()
    ..strokeWidth = strokeWidth
    ..color = Colors.black.withOpacity(opacity)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5)
    ..blendMode = blendMode;

  factory BrushTip.fromJson(Map<String, dynamic> json) => BrushTip(
        strokeWidth: json[_strokeWidthKey] as double,
        opacity: json[_opacityKey] as double,
        blur: json[_blurKey] as double,
      );

  Map<String, dynamic> toJson() => {
        _strokeWidthKey: strokeWidth,
        _opacityKey: opacity,
        _blurKey: blur,
      };

  static const String _strokeWidthKey = 'stroke_width';
  static const String _opacityKey = 'opacity';
  static const String _blurKey = 'blur';
}
