import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tools/tools.dart';

class ToolboxModel extends ChangeNotifier {
  ToolboxModel(SharedPreferences sharedPreferences)
      : assert(sharedPreferences != null),
        _sharedPreferences = sharedPreferences,
        _tools = [
          FillPen(sharedPreferences),
          AirBrush(sharedPreferences),
          Pen(sharedPreferences),
          Eraser(sharedPreferences),
        ],
        _selectedToolId = 2;

  final SharedPreferences _sharedPreferences;

  final List<Tool> _tools;
  int _selectedToolId;

  List<Tool> get tools => _tools;
  Tool get selectedTool => _tools[_selectedToolId];

  void selectTool(Tool tool) {
    assert(_tools.contains(tool));
    _selectedToolId = _tools.indexOf(tool);
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

  /*
  Size picker state:
  */

  bool get sizePickerOpen => _sizePickerOpen;
  bool _sizePickerOpen = false;

  void openSizePicker() {
    _sizePickerOpen = true;
    notifyListeners();
  }

  void closeSizePicker() {
    _sizePickerOpen = false;
    notifyListeners();
  }
}
