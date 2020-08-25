import 'dart:ui';

import 'stroke.dart';

class Frame {
  Frame() : _strokes = [];

  final List<Stroke> _strokes;

  double get width => 250;

  double get height => 250;

  void startPaintingStroke(Offset startPoint) {
    _strokes.add(Stroke(startPoint));
  }

  void extendLastStroke(Offset point) {
    _strokes.last.extend(point);
  }

  void clear() {
    _strokes.clear();
  }

  void paint(Canvas canvas) {
    for (var stroke in _strokes) stroke.paint(canvas);
  }
}
