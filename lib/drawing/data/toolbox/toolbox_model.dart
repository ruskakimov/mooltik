import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tools/tools.dart';

class ToolboxModel extends ChangeNotifier {
  ToolboxModel(SharedPreferences sharedPreferences)
      : assert(sharedPreferences != null),
        _paintBrush = PaintBrush(sharedPreferences),
        _eraser = Eraser(sharedPreferences),
        _lasso = Lasso(sharedPreferences) {
    _selectedTool = _paintBrush;
  }

  PaintBrush get paintBrush => _paintBrush;
  final PaintBrush _paintBrush;

  Eraser get eraser => _eraser;
  final Eraser _eraser;

  Lasso get lasso => _lasso;
  final Lasso _lasso;

  Tool get selectedTool => _selectedTool;
  Tool _selectedTool;

  void selectTool(Tool tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  void changeToolColor(Color color) {
    if (selectedTool is ToolWithColor) {
      (selectedTool as ToolWithColor).color = color;
      notifyListeners();
    }
  }
}
