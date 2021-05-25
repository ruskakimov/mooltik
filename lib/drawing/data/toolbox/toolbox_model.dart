import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/tools/brush.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tools/tools.dart';

class ToolboxModel extends ChangeNotifier {
  ToolboxModel(SharedPreferences sharedPreferences)
      : assert(sharedPreferences != null),
        tools = [
          PaintBrush(sharedPreferences),
          Eraser(sharedPreferences),
          Lasso(sharedPreferences),
        ],
        _selectedToolId = 0;

  final List<Tool> tools;
  int _selectedToolId;

  Tool get selectedTool => tools[_selectedToolId];

  void selectTool(Tool tool) {
    assert(tools.contains(tool));
    _selectedToolId = tools.indexOf(tool);
    notifyListeners();
  }

  void changeToolColor(Color color) {
    if (selectedTool is Brush) {
      (selectedTool as Brush).color = color;
      notifyListeners();
    }
  }
}
