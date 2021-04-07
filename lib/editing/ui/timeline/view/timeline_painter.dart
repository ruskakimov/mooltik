import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/ui/paint_text.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/image_sliver.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/sound_sliver.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';

class TimelinePainter extends CustomPainter {
  TimelinePainter({
    @required this.timelineView,
    this.soundBite,
  });

  final TimelineViewModel timelineView;

  // TODO: Add multiple sound bites support.
  // TODO: Move to timeline view model
  final SoundClip soundBite;

  @override
  void paint(Canvas canvas, Size size) {
    timelineView.size = size;

    final List<ImageSliver> imageSlivers =
        timelineView.getVisibleImageSlivers();

    for (final sliver in imageSlivers) {
      sliver.paint(
        canvas,
        timelineView.imageSliverTop,
        timelineView.imageSliverBottom,
      );

      if (timelineView.selectedSliverIndex == sliver.index) {
        paintSelection(
          canvas,
          sliver.getRrect(
            timelineView.imageSliverTop,
            timelineView.imageSliverBottom,
          ),
          timelineView.selectedSliverDurationLabel,
        );
      }
    }

    if (soundBite != null) {
      final double soundSliverTop = timelineView.imageSliverBottom + 8;
      final double soundSliverBottom =
          soundSliverTop + timelineView.sliverHeight;

      final double soundSliverStartX =
          timelineView.xFromTime(soundBite.startTime);
      final double soundSliverWidth =
          timelineView.widthFromDuration(soundBite.duration);

      SoundSliver(
        startX: soundSliverStartX,
        endX: soundSliverStartX + soundSliverWidth,
      ).paint(
        canvas,
        soundSliverTop,
        soundSliverBottom,
      );
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
      ..color = Colors.black54
      ..style = PaintingStyle.fill,
  );

  final labelPainter = makeTextPainter(
    label,
    const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      shadows: [Shadow(blurRadius: 2, color: Colors.black)],
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
