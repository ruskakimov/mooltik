import 'package:flutter/material.dart';

import 'tools.dart';

class Toolbox extends ChangeNotifier {
  final List<Tool> _tools = [
    Pencil(strokeWidth: 5),
    Eraser(strokeWidth: 20),
  ];
  int _selectedToolId = 0;

  List<Tool> get tools => _tools;
  Tool get selectedTool => _tools[_selectedToolId];

  void selectTool(int toolId) {
    _selectedToolId = toolId;
    notifyListeners();
  }

  void changeStrokeWidth(int value) {
    selectedTool.paint.strokeWidth = value.toDouble();
    notifyListeners();
  }

  void changeColor(Color color) {
    selectedTool.paint.color = color;
    notifyListeners();
  }

  void changeOpacity(double value) {
    assert(value >= 0.0 && value <= 1.0);
    selectedTool.paint.color = selectedTool.paint.color.withOpacity(value);
    notifyListeners();
  }
}
