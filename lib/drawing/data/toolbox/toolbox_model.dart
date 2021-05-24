import 'package:flutter/material.dart';
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
    selectedTool.strokeWidth = strokeWidth;
    notifyListeners();
  }

  void changeToolColor(Color color) {
    selectedTool.color = color;
    notifyListeners();
  }

  void changeToolOpacity(double opacity) {
    selectedTool.opacity = opacity;
    notifyListeners();
  }
}
