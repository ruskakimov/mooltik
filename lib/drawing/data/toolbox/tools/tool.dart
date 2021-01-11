import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';

abstract class Tool {
  Tool(this.icon, this.paint);

  final IconData icon;
  final Paint paint;

  Stroke makeStroke(Offset startPoint);
}
