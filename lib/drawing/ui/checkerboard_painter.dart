import 'package:flutter/material.dart';

class CheckerboardPainter extends CustomPainter {
  CheckerboardPainter({
    this.tileWidth = 4,
  });

  final double tileWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final grey = Paint()..color = Colors.grey[300]!;
    final white = Paint()..color = Colors.white;

    for (double x = 0; x < size.width; x += tileWidth) {
      for (double y = 0; y < size.height; y += tileWidth) {
        final rowId = x ~/ tileWidth;
        final colId = y ~/ tileWidth;

        final isGrey = (rowId + colId) % 2 == 1;

        canvas.drawRect(
          Rect.fromLTWH(x, y, tileWidth, tileWidth),
          isGrey ? grey : white,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CheckerboardPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CheckerboardPainter oldDelegate) => false;
}
