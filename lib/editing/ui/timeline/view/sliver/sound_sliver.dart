import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/sliver.dart';

class SoundSliver extends Sliver {
  SoundSliver({
    required Rect area,
  }) : super(area, null);

  @override
  void paint(Canvas canvas) {
    canvas.drawRRect(rrect, Paint()..color = Colors.green[300]!);
  }
}
