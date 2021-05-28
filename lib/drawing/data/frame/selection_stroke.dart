import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';

class SelectionStroke extends Stroke {
  SelectionStroke(Offset startingPoint) : super(startingPoint, Paint());

  /// Whether the path has been closed.
  bool get finished => _finished;
  bool _finished = false;

  @override
  Rect get boundingRect => path.getBounds();

  double get area {
    final bounds = boundingRect;
    return bounds.width * bounds.height;
  }

  bool get isEmpty => area == 0;

  @override
  void finish() {
    path.close();
    _finished = true;
  }

  void setColorPaint(Color color) {
    paint
      ..style = PaintingStyle.fill
      ..color = color
      ..blendMode = BlendMode.srcOver;
  }

  void setErasingPaint() {
    paint
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;
  }
}
