import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:mooltik/drawing/ui/canvas_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tool.dart';

BrushTip? _retrieveBrushTip(
    SharedPreferences sharedPreferences, String tipKey) {
  try {
    final encodedTip = sharedPreferences.getString(tipKey)!;
    final tipJson = jsonDecode(encodedTip);
    return BrushTip.fromJson(tipJson);
  } catch (e) {
    return null;
  }
}

abstract class Brush extends ToolWithColor {
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
  }

  BlendMode get blendMode;

  List<BrushTip> get defaultBrushTips;

  BrushTip get selectedBrushTip => brushTips[_selectedBrushTipIndex!];

  final List<BrushTip> brushTips = [];

  double get minStrokeWidth;
  double get maxStrokeWidth;

  Paint get paint {
    final tipPaintStyle = selectedBrushTip.paint;
    return tipPaintStyle
      ..color = color.withOpacity(tipPaintStyle.color.opacity)
      ..blendMode = blendMode;
  }

  /// Index of a selected brush tip option.
  int get selectedBrushTipIndex => _selectedBrushTipIndex!;
  int? _selectedBrushTipIndex = 0;
  set selectedBrushTipIndex(int index) {
    assert(index >= 0 && index < brushTips.length);
    _selectedBrushTipIndex = index;
    sharedPreferences.setInt(_selectedBrushTipIndexKey, index);
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

  double? get opacityPercentage => selectedBrushTip.opacity;

  void setOpacityPercentage(double percentage) {
    _replaceCurrentBrushTip(
      selectedBrushTip.copyWith(opacity: percentage),
    );
  }

  double? get blurPercentage => selectedBrushTip.blur;

  void setBlurPercentage(double percentage) {
    _replaceCurrentBrushTip(
      selectedBrushTip.copyWith(blur: percentage),
    );
  }

  void _replaceCurrentBrushTip(BrushTip newBrushTip) {
    brushTips.removeAt(_selectedBrushTipIndex!);
    brushTips.insert(_selectedBrushTipIndex!, newBrushTip);
    sharedPreferences.setString(
      _getBrushTipKey(selectedBrushTipIndex),
      jsonEncode(selectedBrushTip.toJson()),
    );
  }

  // ================
  // Stroke handlers:
  // ================

  Stroke? get currentStroke => _currentStroke;
  Stroke? _currentStroke;

  @override
  void onStrokeStart(Offset canvasPoint) {
    _currentStroke = Stroke(canvasPoint, paint);
  }

  @override
  void onStrokeUpdate(Offset canvasPoint) {
    _currentStroke?.extend(canvasPoint);
  }

  @override
  void onStrokeEnd() {
    _currentStroke?.finish();
  }

  @override
  void onStrokeCancel() {
    _currentStroke = null;
  }

  @override
  Future<ui.Image?> rasterizeStroke(
    Rect canvasArea,
    ui.Image canvasImage,
  ) async {
    final stroke = _currentStroke;
    if (stroke == null) return null;

    ui.Image? result;

    if (stroke.boundingRect.overlaps(canvasArea)) {
      result = await generateImage(
        CanvasPainter(image: canvasImage, strokes: [_currentStroke]),
        canvasImage.width,
        canvasImage.height,
      );
    }

    _currentStroke = null;
    return result;
  }

  // ========================
  // Shared preferences keys:
  // ========================

  String get _selectedBrushTipIndexKey => name + '_selected_brush_tip_index';

  String _getBrushTipKey(int brushTipIndex) =>
      name + '_brush_tip_$brushTipIndex';
}

class BrushTip {
  BrushTip({
    required this.strokeWidth,
    required this.opacity,
    required this.blur,
  })  : assert(opacity >= 0 && opacity <= 1),
        assert(blur >= 0 && blur <= 1);

  final double strokeWidth;
  final double opacity;
  final double blur;

  Paint get paint => Paint()
    ..strokeWidth = strokeWidth
    ..color = Colors.black.withOpacity(opacity)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur * strokeWidth / 4);

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
    double? strokeWidth,
    double? opacity,
    double? blur,
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
