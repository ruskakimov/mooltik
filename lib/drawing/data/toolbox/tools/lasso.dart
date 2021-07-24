import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class Lasso extends ToolWithColor {
  Lasso(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  IconData get icon => MdiIcons.lasso;

  @override
  String get name => 'lasso';

  @override
  Stroke? onStrokeCancel() {
    // TODO: implement onStrokeCancel
    throw UnimplementedError();
  }

  @override
  Stroke? onStrokeEnd() {
    // TODO: implement onStrokeEnd
    throw UnimplementedError();
  }

  @override
  Stroke? onStrokeStart(Offset canvasPoint) {
    // TODO: implement onStrokeStart
    throw UnimplementedError();
  }

  @override
  void onStrokeUpdate(Offset canvasPoint) {
    // TODO: implement onStrokeUpdate
  }

  @override
  PaintOn? makePaintOn(ui.Rect canvasArea) {}
}
