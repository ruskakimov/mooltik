import 'package:flutter/material.dart';

abstract class Sliver {
  Sliver(this.startX, this.endX);

  final double startX;
  final double endX;

  RRect getRrect(double startY, double endY) => RRect.fromRectAndRadius(
        Rect.fromLTRB(startX, startY, endX, endY).deflate(1),
        Radius.circular(8),
      );

  void paint(Canvas canvas, double startY, double endY);
}
