import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';

class TimelinePainter extends CustomPainter {
  TimelinePainter(this.timelineView);

  final TimelineViewModel timelineView;

  @override
  void paint(Canvas canvas, Size size) {
    final canvasArea = Rect.fromLTWH(0, 0, size.width, size.height);
    final rows = timelineView.getSliverRows();
    final selectedSliverId = timelineView.selectedSliverId;

    // Slivers.
    for (var row in rows) {
      for (var sliver in row) {
        if (sliver.area.overlaps(canvasArea)) {
          sliver.paint(canvas);
        }
      }
    }

    // Selection.
    if (selectedSliverId != null) {
      final selectedSliver =
          rows[selectedSliverId.rowIndex][selectedSliverId.colIndex];

      if (selectedSliver.area.overlaps(canvasArea)) {
        _paintSelection(canvas, selectedSliver.rrect);
      }
    }

    // Curtains.
    if (timelineView.isEditingScene) {
      final sceneStartX = timelineView.xFromTime(timelineView.sceneStart);
      final sceneEndX = timelineView.xFromTime(timelineView.sceneEnd);

      _paintCurtains(canvas, size, sceneStartX, sceneEndX);
    }
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}

void _paintSelection(Canvas canvas, RRect rect) {
  canvas.drawRRect(
    rect,
    Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.fill,
  );

  canvas.drawRRect(
    rect.deflate(2),
    Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4,
  );
}

void _paintCurtains(
  Canvas canvas,
  Size size,
  double sceneStartX,
  double sceneEndX,
) {
  final curtainPaint = Paint()..color = Colors.black45;
  canvas.drawRect(
    Rect.fromLTRB(0, 0, sceneStartX, size.height),
    curtainPaint,
  );
  canvas.drawRect(
    Rect.fromLTRB(sceneEndX, 0, size.width, size.height),
    curtainPaint,
  );
}
