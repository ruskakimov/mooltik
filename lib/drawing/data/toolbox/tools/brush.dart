import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tool.dart';

BrushTip _retrieveBrushTip(SharedPreferences sharedPreferences, String tipKey) {
  try {
    final encodedTip = sharedPreferences.getString(tipKey);
    final tipJson = jsonDecode(encodedTip);
    return BrushTip.fromJson(tipJson);
  } catch (e) {
    return null;
  }
}

abstract class Brush extends Tool {
  Brush(SharedPreferences sharedPreferences) : super(sharedPreferences) {
    // Restore brush tips state.
    for (var i = 0; i < defaultBrushTips.length; i++) {
      final tipKey = _getBrushTipKey(i);
      brushTips.add(
        _retrieveBrushTip(sharedPreferences, tipKey) ?? defaultBrushTips[i],
      );
    }

    // Restore selected brush tip.
    if (sharedPreferences.containsKey(_selectedBrushTipIndexKey)) {
      _selectedBrushTipIndex =
          sharedPreferences.getInt(_selectedBrushTipIndexKey);
    }

    // Restore selected color.
    if (sharedPreferences.containsKey(_colorKey)) {
      _color = Color(sharedPreferences.getInt(_colorKey));
    }
  }

  BlendMode get blendMode;

  List<BrushTip> get defaultBrushTips;

  BrushTip get selectedBrushTip => brushTips[_selectedBrushTipIndex];

  final List<BrushTip> brushTips = [];

  double get minStrokeWidth;
  double get maxStrokeWidth;

  Paint get paint {
    final tipPaintStyle = selectedBrushTip.paint;
    return tipPaintStyle
      ..color = _color.withOpacity(tipPaintStyle.color.opacity)
      ..blendMode = blendMode;
  }

  /// Index of a selected brush tip option.
  int get selectedBrushTipIndex => _selectedBrushTipIndex;
  int _selectedBrushTipIndex = 0;
  set selectedBrushTipIndex(int index) {
    assert(index >= 0 && index < brushTips.length);
    _selectedBrushTipIndex = index;
    sharedPreferences.setInt(_selectedBrushTipIndexKey, index);
  }

  /// Brush color.
  Color get color => _color;
  Color _color = Colors.black;
  set color(Color color) {
    _color = color;
    sharedPreferences.setInt(_colorKey, _color.value);
  }

  // ===========
  // UI helpers:
  // ===========

  double get strokeWidthPercentage =>
      (selectedBrushTip.strokeWidth - minStrokeWidth) /
      (maxStrokeWidth - minStrokeWidth);

  void setStrokeWidthPercentage(double percentage) {
    final newStrokeWidth =
        minStrokeWidth + percentage * (maxStrokeWidth - minStrokeWidth);
    _replaceCurrentBrushTip(
      selectedBrushTip.copyWith(strokeWidth: newStrokeWidth),
    );
  }

  double get opacityPercentage => selectedBrushTip.opacity;

  void setOpacityPercentage(double percentage) {
    _replaceCurrentBrushTip(
      selectedBrushTip.copyWith(opacity: percentage),
    );
  }

  // TODO: Add min and max
  double get blurPercentage => selectedBrushTip.blur;

  void _replaceCurrentBrushTip(BrushTip newBrushTip) {
    brushTips.removeAt(_selectedBrushTipIndex);
    brushTips.insert(_selectedBrushTipIndex, newBrushTip);
    sharedPreferences.setString(
      _getBrushTipKey(selectedBrushTipIndex),
      jsonEncode(selectedBrushTip.toJson()),
    );
  }

  // ========================
  // Shared preferences keys:
  // ========================

  String get _selectedBrushTipIndexKey => name + '_selected_brush_tip_index';
  String get _colorKey => name + '_color';

  String _getBrushTipKey(int brushTipIndex) =>
      name + '_brush_tip_$brushTipIndex';
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

  Paint get paint => Paint()
    ..strokeWidth = strokeWidth
    ..color = Colors.black.withOpacity(opacity)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

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

  BrushTip copyWith({
    double strokeWidth,
    double opacity,
    double blur,
  }) =>
      BrushTip(
        strokeWidth: strokeWidth ?? this.strokeWidth,
        opacity: opacity ?? this.opacity,
        blur: blur ?? this.blur,
      );

  static const String _strokeWidthKey = 'stroke_width';
  static const String _opacityKey = 'opacity';
  static const String _blurKey = 'blur';
}
