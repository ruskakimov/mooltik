import 'package:flutter/material.dart';

/// Paints text on the canvas.
void paintText(
  Canvas canvas, {
  required String text,
  required Offset anchorCoordinate,
  Alignment anchorAlignment = Alignment.center,
  TextStyle? style,
}) {
  final TextPainter painter = makeTextPainter(text, style);
  paintWithTextPainter(
    canvas,
    painter: painter,
    anchorCoordinate: anchorCoordinate,
    anchorAlignment: anchorAlignment,
  );
}

/// Constructs a text painter and performs layout.
///
/// Use this in combination with `paintWithTextPainter`,
/// if you need to know text size on the canvas.
///
/// e.g.
/// ```
/// final tp = makeTextPainter('Hello', style);
/// final w = tp.width; // text width
/// final h = tp.height; // text height
///
/// paintWithTextPainter(
///   canvas,
///   painter: tp,
///   anchor: Offset(0, 0),
///   anchorAlignment: Alignment.centerRight,
/// );
/// ```
TextPainter makeTextPainter(String text, TextStyle? style) {
  final TextSpan span = TextSpan(
    text: text,
    style: style,
  );
  return TextPainter(
    text: span,
    textDirection: TextDirection.ltr,
  )..layout();
}

/// Paints on the canvas with the given text painter.
void paintWithTextPainter(
  Canvas canvas, {
  required TextPainter painter,
  required Offset anchorCoordinate,
  Alignment anchorAlignment = Alignment.center,
}) {
  painter.paint(
    canvas,
    Offset(
      anchorCoordinate.dx - painter.width / 2 * (anchorAlignment.x + 1),
      anchorCoordinate.dy - painter.height / 2 * (anchorAlignment.y + 1),
    ),
  );
}
