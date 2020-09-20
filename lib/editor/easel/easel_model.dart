import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/toolbox/tools.dart';

const twoPi = pi * 2;

class EaselModel extends ChangeNotifier {
  EaselModel({
    @required this.frame,
    @required this.selectedTool,
  });

  Tool selectedTool;
  final FrameModel frame;

  double easelWidth;
  double easelHeight;

  Offset _offset = Offset.zero;

  double _rotation = 0;
  double _prevRotation = 0;

  double _scale = 1;
  double _prevScale;

  Offset _fixedFramePoint;

  /// Canvas offset from top of the easel area.
  double get canvasTopOffset => _offset.dy;

  /// Canvas offset from left of the easel area.
  double get canvasLeftOffset => _offset.dx;

  /// Canvas rotation with top left as the anchor point.
  double get canvasRotation => _rotation;

  /// Canvas width at current scale.
  double get canvasWidth => frame.width * _scale;

  /// Canvas height at current scale.
  double get canvasHeight => frame.height * _scale;

  void resetCanvasPosition() {
    _scale = easelWidth / frame.width;
    _offset = Offset(0, (easelHeight - frame.height * _scale) / 2);
    notifyListeners();
  }

  void updateSelectedTool(Tool tool) {
    selectedTool = tool;
    notifyListeners();
  }

  Offset _toFramePoint(Offset point) {
    final p = (point - _offset) / _scale;
    return Offset(
      p.dx * cos(_rotation) + p.dy * sin(_rotation),
      -p.dx * sin(_rotation) + p.dy * cos(_rotation),
    );
  }

  Offset calcOffsetToMatchPoints(Offset framePoint, Offset screenPoint) {
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
        calcOffsetToMatchPoints(_fixedFramePoint, details.localFocalPoint);
    notifyListeners();
  }

  void onStrokeStart(DragStartDetails details) {
    final framePoint = _toFramePoint(details.localPosition);
    frame.startStroke(framePoint, selectedTool.paint);
    notifyListeners();
  }

  void onStrokeUpdate(DragUpdateDetails details) {
    final framePoint = _toFramePoint(details.localPosition);
    frame.extendLastStroke(framePoint);
    notifyListeners();
  }

  void onStrokeEnd() {
    frame.finishLastStroke();
    notifyListeners();
  }

  void onStrokeCancel() {
    frame.cancelLastStroke();
    notifyListeners();
  }
}
