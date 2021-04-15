import 'package:flutter/material.dart';

abstract class Sliver {
  Sliver(this.area)
      : rrect = RRect.fromRectAndRadius(
          area.deflate(1),
          Radius.circular(8),
        );

  final Rect area;

  final RRect rrect;

  void paint(Canvas canvas);
}
