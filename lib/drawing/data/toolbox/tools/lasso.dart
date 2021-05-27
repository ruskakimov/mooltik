import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class Lasso extends Tool {
  Lasso(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  IconData get icon => MdiIcons.lasso;

  @override
  String get name => 'lasso';

  Stroke selectionStroke;

  void startSelection(Offset framePoint) {
    selectionStroke = Stroke(
      framePoint,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..color = Colors.red,
    );
    notifyListeners();
  }

  void updateSelection(Offset framePoint) {
    selectionStroke?.extend(framePoint);
    notifyListeners();
  }

  void finishSelection() {}
}
