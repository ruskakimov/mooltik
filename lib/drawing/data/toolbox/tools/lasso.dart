import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/drawing/data/frame/selection_stroke.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class Lasso extends ToolWithColor {
  Lasso(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  IconData get icon => MdiIcons.lasso;

  @override
  String get name => 'lasso';

  /// Lasso selected area.
  SelectionStroke? get selectionStroke => _selectionStroke;
  SelectionStroke? _selectionStroke;

  void removeSelection() {
    _selectionStroke = null;
  }

  @override
  Stroke? onStrokeStart(Offset canvasPoint) {
    _selectionStroke = SelectionStroke(canvasPoint);
  }

  @override
  void onStrokeUpdate(Offset canvasPoint) {
    _selectionStroke?.extend(canvasPoint);
  }

  @override
  Stroke? onStrokeEnd() {
    _selectionStroke?.finish();
  }

  @override
  Stroke? onStrokeCancel() {
    removeSelection();
  }

  @override
  PaintOn? makePaintOn(ui.Rect canvasArea) {
    _selectionStroke?.clipToFrame(canvasArea);
    if (_selectionStroke!.isTooSmall) removeSelection();
  }
}
