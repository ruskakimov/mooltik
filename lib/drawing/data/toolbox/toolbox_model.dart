import 'package:flutter/material.dart';

import 'tools/tools.dart';

class ToolboxModel extends ChangeNotifier {
  final List<Tool> _tools = [
    Pencil(strokeWidth: 10),
    Eraser(strokeWidth: 100),
  ];
  int _selectedToolId = 0;

  List<Tool> get tools => _tools;
  Tool get selectedTool => _tools[_selectedToolId];

  void selectTool(int toolId) {
    _selectedToolId = toolId;
    notifyListeners();
  }

  double get selectedToolStrokeWidth => selectedTool?.paint?.strokeWidth;

  void changeToolStrokeWidth(double strokeWidth) {
    if (strokeWidth <= selectedTool.maxStrokeWidth &&
        strokeWidth >= selectedTool.minStrokeWidth) {
      selectedTool.paint.strokeWidth = strokeWidth;
      notifyListeners();
    }
  }

  Color get selectedToolColor => selectedTool?.paint?.color;

  void changeToolColor(Color color) {
    selectedTool.paint.color = color;
    notifyListeners();
  }
}
