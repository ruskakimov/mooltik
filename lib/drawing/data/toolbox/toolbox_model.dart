import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tools/tools.dart';

class ToolboxModel extends ChangeNotifier {
  ToolboxModel(SharedPreferences sharedPreferences)
      : assert(sharedPreferences != null),
        tools = [
          FillPen(sharedPreferences),
          AirBrush(sharedPreferences),
          Pen(sharedPreferences),
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

  double get selectedToolStrokeWidth => selectedTool?.strokeWidth;

  void changeToolStrokeWidth(double strokeWidth) {
    selectedTool.strokeWidth = strokeWidth;
    notifyListeners();
  }

  double get selectedToolOpacity => selectedTool?.opacity;

  void changeToolOpacity(double opacity) {
    selectedTool.opacity = opacity;
    notifyListeners();
  }
}
