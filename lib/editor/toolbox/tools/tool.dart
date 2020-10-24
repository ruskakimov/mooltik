import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/stroke.dart';

abstract class Tool {
  Tool(this.icon, this.paint);

  final IconData icon;
  final Paint paint;

  Stroke makeStroke(Offset startPoint, Color color);
}
