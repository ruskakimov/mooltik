import 'package:flutter/material.dart';
import 'package:mooltik/common/data/extensions/color_methods.dart';
import 'package:mooltik/drawing/data/toolbox/tools/bucket.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tools/tools.dart';

class ToolboxModel extends ChangeNotifier {
  ToolboxModel(SharedPreferences sharedPreferences)
      : _preferences = sharedPreferences,
        _bucket = Bucket(sharedPreferences),
        _paintBrush = PaintBrush(sharedPreferences),
        _eraser = Eraser(sharedPreferences),
        _lasso = Lasso(sharedPreferences),
        _hsvColor = _restoreHSVColor(sharedPreferences),
        _palette = _restorePalette(sharedPreferences) {
    _selectedTool = _paintBrush;
    _applyColorOnTools();
  }

  final SharedPreferences _preferences;

  Color get color => _hsvColor.toColor();
  HSVColor get hsvColor => _hsvColor;
  HSVColor _hsvColor;

  List<HSVColor?> get palette => _palette;
  final List<HSVColor?> _palette;
  double paletteScollOffset = 0; // For restoring scroll offset on reopening.

  void setPaletteCell(int cellIndex, HSVColor? color) {
    _palette[cellIndex] = color;
    notifyListeners();
    _savePalette();
  }

  List<Tool> get tools => [
        bucket,
        paintBrush,
        eraser,
        lasso,
      ];

  Bucket get bucket => _bucket;
  final Bucket _bucket;

  PaintBrush get paintBrush => _paintBrush;
  final PaintBrush _paintBrush;

  Eraser get eraser => _eraser;
  final Eraser _eraser;

  Lasso get lasso => _lasso;
  final Lasso _lasso;

  Tool? get selectedTool => _selectedTool;
  Tool? _selectedTool;

  void selectTool(Tool tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  void changeColor(HSVColor hsvColor) {
    _hsvColor = hsvColor;
    _applyColorOnTools();
    notifyListeners();
    _preferences.setString(_hsvColorKey, _hsvColor.toStr());
  }

  void _applyColorOnTools() {
    for (final tool in tools) {
      if (tool is ToolWithColor) tool.applyColor(color);
    }
  }

  static HSVColor _restoreHSVColor(SharedPreferences sharedPreferences) {
    if (sharedPreferences.containsKey(_hsvColorKey)) {
      final raw = sharedPreferences.getString(_hsvColorKey);
      if (raw != null) return raw.parseHSVColor();
    }
    return _startHsvColor;
  }

  static List<HSVColor?> _restorePalette(SharedPreferences sharedPreferences) {
    if (sharedPreferences.containsKey(_hsvPaletteKey)) {
      final raws = sharedPreferences.getStringList(_hsvPaletteKey);
      if (raws != null && raws.length == _paletteCellCount) {
        return raws
            .map((str) => str != '' ? str.parseHSVColor() : null)
            .toList();
      }
    }
    return _generateStartPalette();
  }

  void _savePalette() {
    _preferences.setStringList(
      _hsvPaletteKey,
      _palette.map((color) => color != null ? color.toStr() : '').toList(),
    );
  }

  static List<HSVColor?> _generateStartPalette() {
    final List<HSVColor?> colors = List.filled(_paletteCellCount, null);
    int i = _paletteCellCount - 1;
    for (var color in _materialColors.reversed) {
      for (var shade in _shades.reversed) {
        colors[i] = HSVColor.fromColor(color[shade]!);
        i--;
      }
    }
    return colors;
  }

  static const HSVColor _startHsvColor = HSVColor.fromAHSV(1, 0, 0, 0);
  static const int _paletteCellCount = 90;

  static const String _hsvColorKey = 'hsv_color';
  static const String _hsvPaletteKey = 'hsv_palette';
}

const _customGreyMaterial = MaterialColor(
  0xFF9E9E9E,
  <int, Color>{
    100: Colors.white,
    200: Color(0xFFEEEEEE),
    300: Color(0xFFE0E0E0),
    400: Color(0xFFBDBDBD),
    500: Color(0xFF9E9E9E),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    900: Colors.black,
  },
);

const _materialColors = <MaterialColor>[
  _customGreyMaterial,
  Colors.blueGrey,
  Colors.brown,
  Colors.orange,
  Colors.yellow,
  Colors.lime,
  Colors.green,
  Colors.teal,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.pink,
  Colors.red,
];

const _shades = [100, 300, 400, 500, 700, 900];
