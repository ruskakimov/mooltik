import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/frame_sliver.dart';
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

    final List<FrameSliver> frameSlivers =
        timelineView.getVisibleFrameSlivers();

    for (final sliver in frameSlivers) {
      sliver.paint(
        canvas,
        timelineView.frameSliverTop,
        timelineView.frameSliverBottom,
      );

      // Draw border around highlighted.
      if (timelineView.highlightedFrameIndex == sliver.frameIndex) {
        canvas.drawRRect(
          sliver
              .getRrect(
                timelineView.frameSliverTop,
                timelineView.frameSliverBottom,
              )
              .deflate(2),
          Paint()
            ..color = Colors.amber
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4,
        );
      }
    }

    if (soundBite != null) {
      final double soundSliverTop = timelineView.frameSliverBottom + 8;
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
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}
