import 'package:flutter/material.dart';

class GroupLine extends StatelessWidget {
  const GroupLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CustomPaint(
        painter: _BracketPainter(Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  _BracketPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, 4, size.height), paint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 4), paint);
    canvas.drawRect(Rect.fromLTWH(0, size.height - 4, size.width, 4), paint);
  }

  @override
  bool shouldRepaint(_BracketPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_BracketPainter oldDelegate) => false;
}
