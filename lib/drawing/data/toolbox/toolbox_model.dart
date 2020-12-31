import 'package:flutter/material.dart';

import 'tools/tools.dart';

class ToolboxModel extends ChangeNotifier {
  final List<Tool> _tools = [
    Pencil(strokeWidth: 10),
    Eraser(strokeWidth: 100),
  ];
  int _selectedToolId = 0;
  Color _selectedColor = Colors.black;

  List<Tool> get tools => _tools;
  Tool get selectedTool => _tools[_selectedToolId];
  Color get selectedColor => _selectedColor;

  void selectTool(int toolId) {
    _selectedToolId = toolId;
    notifyListeners();
  }

  void selectColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void changeToolWidth(int value) {
    selectedTool.paint.strokeWidth = value.toDouble();
    notifyListeners();
  }

  void changeToolOpacity(double value) {
    assert(value >= 0.0 && value <= 1.0);
    selectedTool.paint.color = selectedTool.paint.color.withOpacity(value);
    notifyListeners();
  }
}
