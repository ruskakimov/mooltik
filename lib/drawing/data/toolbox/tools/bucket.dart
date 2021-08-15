import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/data/flood_fill.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class Bucket extends ToolWithColor {
  Bucket(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  IconData get icon => MdiIcons.formatColorFill;

  @override
  String get name => 'bucket';

  Offset _lastPoint = Offset.zero;

  @override
  Stroke? onStrokeStart(Offset canvasPoint) {
    _lastPoint = canvasPoint;
  }

  @override
  void onStrokeUpdate(Offset canvasPoint) {
    _lastPoint = canvasPoint;
  }

  @override
  Stroke? onStrokeEnd() {}

  @override
  Stroke? onStrokeCancel() {}

  @override
  PaintOn? makePaintOn(ui.Rect canvasArea) {
    if (!canvasArea.contains(_lastPoint)) return null;

    final frozenColor = color;
    final frozenX = _lastPoint.dx.toInt();
    final frozenY = _lastPoint.dy.toInt();

    return (ui.Image canvasImage) {
      return floodFill(
        canvasImage,
        frozenX,
        frozenY,
        frozenColor,
      );
    };
  }
}
