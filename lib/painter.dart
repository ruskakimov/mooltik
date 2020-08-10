import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  Painter();

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(Painter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(Painter oldDelegate) => false;
}
