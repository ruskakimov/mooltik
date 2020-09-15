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

  void changeStrokeWidth(double value) {
    selectedTool.paint.strokeWidth = value;
    notifyListeners();
  }
}
