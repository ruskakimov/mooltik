import 'dart:ui';

import 'package:flutter/material.dart';

import 'stroke.dart';

class Frame {
  Frame() : _strokes = [];

  final List<Stroke> _strokes;

  double get width => 250;

  double get height => 250;

  void startPencilStroke(Offset startPoint) {
    _strokes.add(Stroke(
      startPoint,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.black,
    ));
  }

  void startEraserStroke(Offset startPoint) {
    _strokes.add(Stroke(
      startPoint,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..blendMode = BlendMode.clear,
    ));
  }

  void extendLastStroke(Offset point) {
    _strokes.last.extend(point);
  }

  void clear() {
    _strokes.clear();
  }

  void paintOn(Canvas canvas) {
    for (var stroke in _strokes) stroke.paintOn(canvas);
  }
}
