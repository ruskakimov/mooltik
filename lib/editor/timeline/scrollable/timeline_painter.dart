import 'package:flutter/material.dart';
import 'package:mooltik/editor/sound_clip.dart';
import 'package:mooltik/editor/timeline/scrollable/sliver/frame_sliver.dart';
import 'package:mooltik/editor/timeline/scrollable/sliver/sound_sliver.dart';
import 'package:mooltik/editor/timeline/scrollable/timeline_view_model.dart';

class TimelinePainter extends CustomPainter {
  TimelinePainter({
    @required this.timelineView,
    this.soundBite,
  });

  final TimelineViewModel timelineView;

  // TODO: Add multiple sound bites support.
  final SoundClip soundBite;

  @override
  void paint(Canvas canvas, Size size) {
    timelineView.size = size;

    final List<FrameSliver> frameSlivers =
        timelineView.getVisibleFrameSlivers();

    final double sliverHeight = (size.height - 24) / 2;

    final double frameSliverTop = 8;
    final double frameSliverBottom = frameSliverTop + sliverHeight;

    for (final sliver in frameSlivers) {
      sliver.paint(canvas, frameSliverTop, frameSliverBottom);
    }

    if (soundBite != null) {
      final double soundSliverTop = frameSliverBottom + 8;
      final double soundSliverBottom = soundSliverTop + sliverHeight;

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
