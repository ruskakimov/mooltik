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

  final Tool selectedTool;
  final FrameModel frame;

  Offset offset;

  double rotation = 0;
  double _prevRotation = 0;

  double scale;
  double _prevScale;

  Offset _fixedFramePoint;

  /// Canvas offset from top of the easel area.
  double get canvasTopOffset => offset.dy;

  /// Canvas offset from left of the easel area.
  double get canvasLeftOffset => offset.dx;

  /// Canvas rotation with top left as the anchor point.
  double get canvasRotation => rotation;

  void updateEaselArea(double width, double height) {
    scale ??= width / frame.width;
    offset ??= Offset(0, (height - frame.height * scale) / 2);
  }

  Offset toFramePoint(Offset point) {
    final p = (point - offset) / scale;
    return Offset(
      p.dx * cos(rotation) + p.dy * sin(rotation),
      -p.dx * sin(rotation) + p.dy * cos(rotation),
    );
  }

  Offset calcOffsetToMatchPoints(Offset framePoint, Offset screenPoint) {
    final a = screenPoint.dx;
    final b = screenPoint.dy;
    final c = framePoint.dx;
    final d = framePoint.dy;
    final si = sin(rotation);
    final co = cos(rotation);
    final ta = si / co;
    final s = scale;

    final e = -d * s - a * si + b * co;
    final f = -c * s + a * co + b * si;

    final x = (f - e * ta) / (co + si * ta);
    final y = (e + x * si) / co;

    return Offset(x, y);
  }

  void onScaleStart(ScaleStartDetails details) {
    _prevScale = scale;
    _prevRotation = rotation;
    _fixedFramePoint = toFramePoint(details.localFocalPoint);
    notifyListeners();
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    scale = (_prevScale * details.scale).clamp(0.1, 8.0);
    rotation = (_prevRotation + details.rotation) % twoPi;
    offset = calcOffsetToMatchPoints(_fixedFramePoint, details.localFocalPoint);
    notifyListeners();
  }
}
