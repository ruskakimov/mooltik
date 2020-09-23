import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/toolbox/tools.dart';

const twoPi = pi * 2;

class EaselModel extends ChangeNotifier {
  EaselModel({
    @required FrameModel frame,
    @required Tool selectedTool,
    @required this.frameWidth,
    @required this.frameHeight,
    @required this.createFrame,
    @required this.deleteFrame,
  })  : _frame = frame,
        _selectedTool = selectedTool;

  FrameModel _frame;

  Tool _selectedTool;

  final double frameWidth;
  final double frameHeight;
  final Function createFrame;
  final Function deleteFrame;

  Size _screenSize;

  Offset _offset = Offset.zero;

  double _rotation = 0;
  double _prevRotation = 0;

  double _scale = 1;
  double _prevScale;

  Offset _fixedFramePoint;

  bool _justCreatedFrame = false;

  /// Canvas offset from top of the easel area.
  double get canvasTopOffset => _offset.dy;

  /// Canvas offset from left of the easel area.
  double get canvasLeftOffset => _offset.dx;

  /// Canvas rotation with top left as the anchor point.
  double get canvasRotation => _rotation;

  /// Canvas width at current scale.
  double get canvasWidth => frameWidth * _scale;

  /// Canvas height at current scale.
  double get canvasHeight => frameHeight * _scale;

  void init(Size screenSize) {
    _screenSize = screenSize;
    _fitToScreenUprightCanvas();
  }

  void updateSelectedTool(Tool tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  void updateFrame(FrameModel frame) {
    _frame = frame;
    notifyListeners();
  }

  void _fitToScreenUprightCanvas() {
    _scale = _screenSize.width / frameWidth;
    _offset = Offset(0, (_screenSize.height - frameHeight * _scale) / 2);
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
    if (_frame == null) {
      _justCreatedFrame = true;
      _frame = createFrame();
    }
    final framePoint = _toFramePoint(details.localPosition);
    _frame.startStroke(framePoint, _selectedTool.paint);
  }

  void onStrokeUpdate(DragUpdateDetails details) {
    final framePoint = _toFramePoint(details.localPosition);
    _frame.extendLastStroke(framePoint);
  }

  void onStrokeEnd() {
    _justCreatedFrame = false;
    _frame.finishLastStroke();
  }

  void onStrokeCancel() {
    if (_justCreatedFrame) {
      // TODO: Create frame onStrokeEnd, move unrasterised strokes to easel.
      deleteFrame();
    }
    _frame.cancelLastStroke();
  }

  void onExpandTap() {
    _fitToScreenUprightCanvas();
    notifyListeners();
  }
}
