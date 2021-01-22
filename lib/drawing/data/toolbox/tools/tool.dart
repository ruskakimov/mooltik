import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';

abstract class Tool {
  Tool(this.icon, this.paint);

  final IconData icon;
  final Paint paint;

  double get maxStrokeWidth;
  double get minStrokeWidth;

  List<double> get strokeWidthOptions;

  Stroke makeStroke(Offset startPoint);
}
