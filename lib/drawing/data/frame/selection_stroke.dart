import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';

class SelectionStroke extends Stroke {
  SelectionStroke(Offset startingPoint) : super(startingPoint, Paint());

  @override
  Rect get boundingRect => path.getBounds();

  @override
  void finish() {
    path.close();
  }
}
