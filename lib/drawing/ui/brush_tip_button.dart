import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/tools/brush.dart';

class BrushTipButton extends StatelessWidget {
  const BrushTipButton({
    Key? key,
    this.size = 52,
    required this.canvasSize,
    required this.brushTip,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  final double size;

  final Size canvasSize;
  final BrushTip brushTip;

  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);

    return InkWell(
      borderRadius: borderRadius,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        foregroundDecoration: selected
            ? BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
                borderRadius: borderRadius,
              )
            : null,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          borderRadius: borderRadius,
        ),
        clipBehavior: Clip.antiAlias,
        child: FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.contain,
          child: CustomPaint(
            size: canvasSize,
            painter: BrushTipPainter(brushTip),
          ),
        ),
      ),
    );
  }
}

class BrushTipPainter extends CustomPainter {
  BrushTipPainter(this.brushTip);

  final BrushTip brushTip;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = brushTip.paint
      ..color = Colors.white.withOpacity(brushTip.opacity);

    canvas.drawPoints(
      PointMode.points,
      [center],
      paint,
    );
  }

  @override
  bool shouldRepaint(BrushTipPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BrushTipPainter oldDelegate) => false;
}
