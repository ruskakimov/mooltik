import 'package:flutter/material.dart';

abstract class Sliver {
  Sliver(this.area)
      : rrect = RRect.fromRectAndRadius(
          area.width > 4 ? _deflateSides(area, 1) : area,
          Radius.circular(8),
        );

  final Rect area;

  final RRect rrect;

  void paint(Canvas canvas);
}

Rect _deflateSides(Rect rect, double delta) {
  return Rect.fromLTRB(
    rect.left + delta,
    rect.top,
    rect.right - delta,
    rect.bottom,
  );
}
