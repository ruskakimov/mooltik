import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/timeline/scrollable/sliver/sliver.dart';

class SoundSliver extends Sliver {
  SoundSliver({
    @required double startX,
    @required double endX,
  }) : super(startX, endX);

  @override
  void paint(Canvas canvas, double startY, double endY) {
    final RRect rrect = getRrect(startY, endY);
    canvas.drawRRect(rrect, Paint()..color = Colors.green[300]);
  }
}
