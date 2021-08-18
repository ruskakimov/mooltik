import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class Sliver {
  Sliver(this.area, this.id)
      : rrect = RRect.fromRectAndRadius(
          area.width > 4 ? _deflateSides(area, 1) : area,
          Radius.circular(8),
        );

  final Rect area;

  final RRect rrect;

  final SliverId? id;

  void paint(Canvas canvas);
}

class SliverId extends Equatable {
  SliverId(this.rowIndex, this.spanIndex);

  final int rowIndex;
  final int spanIndex;

  @override
  List<Object> get props => [rowIndex, spanIndex];
}

Rect _deflateSides(Rect rect, double delta) {
  return Rect.fromLTRB(
    rect.left + delta,
    rect.top,
    rect.right - delta,
    rect.bottom,
  );
}
