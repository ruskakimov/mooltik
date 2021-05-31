import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Fills the whole canvas with masked original.
class MaskedImagePainter extends CustomPainter {
  MaskedImagePainter({
    @required this.original,
    @required this.mask,
  });

  final ui.Image original;
  final Path mask;

  @override
  void paint(Canvas canvas, Size size) {
    final maskBounds = mask.getBounds();

    canvas.translate(-maskBounds.left, -maskBounds.top);

    canvas.clipPath(mask);
    canvas.drawImage(
      original,
      Offset.zero,
      Paint()
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(MaskedImagePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MaskedImagePainter oldDelegate) => false;
}
