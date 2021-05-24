import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/paint_text.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';

class TimelinePainter extends CustomPainter {
  TimelinePainter(this.timelineView);

  final TimelineViewModel timelineView;

  @override
  void paint(Canvas canvas, Size size) {
    timelineView.size = size;

    final canvasArea = Rect.fromLTWH(0, 0, size.width, size.height);
    final rows = timelineView.getSliverRows();
    final selectedSliverId = timelineView.selectedSliverId;

    for (var row in rows) {
      for (var sliver in row) {
        if (sliver.area.overlaps(canvasArea)) {
          sliver.paint(canvas);

          if (selectedSliverId != null && selectedSliverId == sliver.id) {
            paintSelection(
              canvas,
              sliver.rrect,
              timelineView.selectedSliverDurationLabel,
            );
          }
        }
      }
    }

    if (timelineView.isEditingScene) {
      final fogPaint = Paint()..color = Colors.black45;
      canvas.drawRect(
        Rect.fromLTRB(
          0,
          0,
          timelineView.xFromTime(timelineView.sceneStart),
          size.height,
        ),
        fogPaint,
      );
      canvas.drawRect(
        Rect.fromLTRB(
          timelineView.xFromTime(timelineView.sceneEnd),
          0,
          size.width,
          size.height,
        ),
        fogPaint,
      );
    }
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}

void paintSelection(Canvas canvas, RRect rect, String label) {
  canvas.drawRRect(
    rect,
    Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.fill,
  );

  final labelPainter = makeTextPainter(
    label,
    const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  );

  if (labelPainter.width + 24 < rect.width) {
    paintWithTextPainter(
      canvas,
      painter: labelPainter,
      anchorCoordinate: rect.center,
    );
  }

  canvas.drawRRect(
    rect.deflate(2),
    Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4,
  );
}
