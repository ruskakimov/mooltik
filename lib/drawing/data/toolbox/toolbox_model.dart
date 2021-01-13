import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tools/tools.dart';

const String _pencilStrokeWidthKey = 'pencil_stroke_width';
const String _eraserStrokeWidthKey = 'eraser_stroke_width';
const String _pencilColorKey = 'pencil_color';

class ToolboxModel extends ChangeNotifier {
  ToolboxModel(this.sharedPreferences)
      : _tools = [
          Pencil(
            strokeWidth: sharedPreferences.containsKey(_pencilStrokeWidthKey)
                ? sharedPreferences.getDouble(_pencilStrokeWidthKey)
                : 10,
            color: sharedPreferences.containsKey(_pencilColorKey)
                ? Color(sharedPreferences.getInt(_pencilColorKey))
                : Colors.black,
          ),
          Eraser(
            strokeWidth: sharedPreferences.containsKey(_eraserStrokeWidthKey)
                ? sharedPreferences.getDouble(_eraserStrokeWidthKey)
                : 100,
          ),
        ],
        _selectedToolId = 0;

  final SharedPreferences sharedPreferences;

  final List<Tool> _tools;
  int _selectedToolId;

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

      sharedPreferences.setDouble(
        selectedTool is Pencil ? _pencilStrokeWidthKey : _eraserStrokeWidthKey,
        strokeWidth,
      );
      notifyListeners();
    }
  }

  Color get selectedToolColor => selectedTool?.paint?.color;

  void changeToolColor(Color color) {
    if (selectedTool is Eraser) return;

    selectedTool.paint.color = color;

    if (selectedTool is Pencil) {
      sharedPreferences.setInt(_pencilColorKey, color.value);
    }
    notifyListeners();
  }
}
