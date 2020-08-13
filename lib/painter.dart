import 'package:flutter/material.dart';

import 'instructions.dart';

class Painter extends CustomPainter {
  Painter(this.instructions);

  final List<Instruction> instructions;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (var i in instructions) {
      if (i is TeleportTo) {
        path.moveTo(i.to.dx, i.to.dy);
      } else if (i is DragTo) {
        path.lineTo(i.to.dx, i.to.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(Painter oldDelegate) => false;
}
