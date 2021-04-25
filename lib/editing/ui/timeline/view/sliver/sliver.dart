import 'package:flutter/material.dart';

abstract class Sliver {
  Sliver(this.area, this.index)
      : rrect = RRect.fromRectAndRadius(
          area.deflate(1),
          Radius.circular(8),
        );

  final Rect area;

  final RRect rrect;

  final int index;

  void paint(Canvas canvas);
}
