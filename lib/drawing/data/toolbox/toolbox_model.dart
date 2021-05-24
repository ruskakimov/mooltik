import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/tools/brush.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tools/tools.dart';

class ToolboxModel extends ChangeNotifier {
  ToolboxModel(SharedPreferences sharedPreferences)
      : assert(sharedPreferences != null),
        tools = [
          FillPen(sharedPreferences),
          AirBrush(sharedPreferences),
          PaintBrush(sharedPreferences),
          Eraser(sharedPreferences),
        ],
        _selectedToolId = 2;

  final List<Tool> tools;
  int _selectedToolId;

  Tool get selectedTool => tools[_selectedToolId];

  void selectTool(Tool tool) {
    assert(tools.contains(tool));
    _selectedToolId = tools.indexOf(tool);
    notifyListeners();
  }

  void changeToolStrokeWidth(double strokeWidth) {
    if (selectedTool is Brush) {
      (selectedTool as Brush).strokeWidth = strokeWidth;
      notifyListeners();
    }
  }

  void changeToolColor(Color color) {
    if (selectedTool is Brush) {
      (selectedTool as Brush).color = color;
      notifyListeners();
    }
  }

  void changeToolOpacity(double opacity) {
    if (selectedTool is Brush) {
      (selectedTool as Brush).opacity = opacity;
      notifyListeners();
    }
  }
}
