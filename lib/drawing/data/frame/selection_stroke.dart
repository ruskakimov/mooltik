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

  bool get isTooSmall => area < 100;

  @override
  void finish() {
    path.close();
    _finished = true;
  }

  void clipToFrame(Rect frameArea) {
    final frameCircumference = Path()
      ..addPolygon([
        frameArea.topLeft,
        frameArea.topRight,
        frameArea.bottomRight,
        frameArea.bottomLeft,
      ], true);
    path = Path.combine(PathOperation.intersect, path, frameCircumference);
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
