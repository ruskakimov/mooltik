import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/stroke.dart';
import 'package:mooltik/editor/toolbox/tools/tool.dart';

const twoPi = pi * 2;

class EaselModel extends ChangeNotifier {
  EaselModel({
    @required FrameModel frame,
    @required this.frameSize,
    @required Tool selectedTool,
    @required Size screenSize,
  })  : _frame = frame,
        _selectedTool = selectedTool,
        _screenSize = screenSize {
    _fitToScreen();
  }

  FrameModel _frame;

  Tool _selectedTool;
  Color _selectedColor;

  final Size frameSize;

  Size _screenSize;

  Offset _offset = Offset.zero;

  double _rotation = 0;
  double _prevRotation = 0;

  double _scale = 1;
  double _prevScale;

  Offset _fixedFramePoint;

  Stroke _currentStroke;

  /// Current unfinished stroke.
  Stroke get currentStroke => _currentStroke;

  /// Canvas offset from top of the easel area.
  double get canvasTopOffset => _offset.dy;

  /// Canvas offset from left of the easel area.
  double get canvasLeftOffset => _offset.dx;

  /// Canvas rotation with top left as the anchor point.
  double get canvasRotation => _rotation;

  /// Canvas width at current scale.
  double get canvasWidth => frameSize.width * _scale;

  /// Canvas height at current scale.
  double get canvasHeight => frameSize.height * _scale;

  Rect get _frameArea => Rect.fromLTWH(0, 0, frameSize.width, frameSize.height);

  /// Used by provider to update dependency.
  void updateSelectedTool(Tool tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  /// Used by provider to update dependency.
  void updateSelectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  /// Used by provider to update dependency.
  void updateFrame(FrameModel frame) {
    _frame = frame;
    notifyListeners();
  }

  void _fitToScreen() {
    final topPadding = 44.0; // equals drawing actionbar height
    _scale = (_screenSize.height - topPadding) / frameSize.height;
    _offset = Offset(
      (_screenSize.width - frameSize.width * _scale) / 2,
      (topPadding + _screenSize.height - frameSize.height * _scale) / 2,
    );
    _rotation = 0;
  }

  Offset _toFramePoint(Offset point) {
    final p = (point - _offset) / _scale;
    return Offset(
      p.dx * cos(_rotation) + p.dy * sin(_rotation),
      -p.dx * sin(_rotation) + p.dy * cos(_rotation),
    );
  }

  Offset _calcOffsetToMatchPoints(Offset framePoint, Offset screenPoint) {
    final a = screenPoint.dx;
    final b = screenPoint.dy;
    final c = framePoint.dx;
    final d = framePoint.dy;
    final si = sin(_rotation);
    final co = cos(_rotation);
    final ta = si / co;
    final s = _scale;

    final e = -d * s - a * si + b * co;
    final f = -c * s + a * co + b * si;

    final x = (f - e * ta) / (co + si * ta);
    final y = (e + x * si) / co;

    return Offset(x, y);
  }

  void onScaleStart(ScaleStartDetails details) {
    _prevScale = _scale;
    _prevRotation = _rotation;
    _fixedFramePoint = _toFramePoint(details.localFocalPoint);
    notifyListeners();
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    _scale = (_prevScale * details.scale).clamp(0.1, 8.0);
    _rotation = (_prevRotation + details.rotation) % twoPi;
    _offset =
        _calcOffsetToMatchPoints(_fixedFramePoint, details.localFocalPoint);
    notifyListeners();
  }

  void onStrokeStart(DragStartDetails details) {
    final framePoint = _toFramePoint(details.localPosition);
    _currentStroke = _selectedTool.makeStroke(framePoint, _selectedColor);
    notifyListeners();
  }

  void onStrokeUpdate(DragUpdateDetails details) {
    final framePoint = _toFramePoint(details.localPosition);
    _currentStroke.extend(framePoint);
    notifyListeners();
  }

  void onStrokeEnd() {
    _currentStroke.finish();

    if (_currentStroke.boundingRect.overlaps(_frameArea)) {
      _frame.add(_currentStroke);
    }

    _currentStroke = null;
    notifyListeners();
  }

  void onStrokeCancel() {
    _currentStroke = null;
    notifyListeners();
  }
}
