import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/sound_bite.dart';
import 'package:mooltik/editor/timeline/scrollable/convert.dart';
import 'package:mooltik/editor/timeline/scrollable/sliver/frame_sliver.dart';
import 'package:mooltik/editor/timeline/scrollable/sliver/sound_sliver.dart';

class TimelinePainter extends CustomPainter {
  TimelinePainter({
    @required this.frames,
    @required this.selectedFrameIndex,
    @required this.selectedFrameStartTime,
    @required this.msPerPx,
    @required this.playheadPosition,
    this.soundBite,
  });

  final List<FrameModel> frames;
  final int selectedFrameIndex;
  final Duration selectedFrameStartTime;
  final double msPerPx;
  final Duration playheadPosition;

  // TODO: Add multiple sound bites support.
  final SoundBite soundBite;

  double getFrameWidth(int frameIndex) => durationToPx(
        frames[frameIndex].duration,
        msPerPx,
      );

  FrameSliver getSelectedFrameSliver(double midX) {
    final double selectedFrameWidth = getFrameWidth(selectedFrameIndex);
    final double selectedFrameStartX =
        midX + durationToPx(selectedFrameStartTime - playheadPosition, msPerPx);
    return FrameSliver(
      startX: selectedFrameStartX,
      endX: selectedFrameStartX + selectedFrameWidth,
      thumbnail: frames[selectedFrameIndex].snapshot,
    );
  }

  List<FrameSliver> getVisibleFrameSlivers(Size size) {
    final double midX = size.width / 2;
    final List<FrameSliver> slivers = [getSelectedFrameSliver(midX)];

    // Fill with slivers on left side.
    for (int i = selectedFrameIndex - 1;
        i >= 0 && slivers.first.startX > 0;
        i--) {
      slivers.insert(
        0,
        FrameSliver(
          startX: slivers.first.startX - getFrameWidth(i),
          endX: slivers.first.startX,
          thumbnail: frames[i].snapshot,
        ),
      );
    }

    // Fill with slivers on right side.
    for (int i = selectedFrameIndex + 1;
        i < frames.length && slivers.last.endX < size.width;
        i++) {
      slivers.add(FrameSliver(
        startX: slivers.last.endX,
        endX: slivers.last.endX + getFrameWidth(i),
        thumbnail: frames[i].snapshot,
      ));
    }
    return slivers;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double midX = size.width / 2;

    final List<FrameSliver> frameSlivers = getVisibleFrameSlivers(size);

    final double sliverHeight = (size.height - 24) / 2;

    final double frameSliverTop = 8;
    final double frameSliverBottom = frameSliverTop + sliverHeight;

    for (final sliver in frameSlivers) {
      sliver.paint(canvas, frameSliverTop, frameSliverBottom);
    }

    final double soundSliverTop = frameSliverBottom + 8;
    final double soundSliverBottom = soundSliverTop + sliverHeight;

    final double soundSliverStart =
        midX + durationToPx(soundBite.startTime - playheadPosition, msPerPx);

    final double soundSliverWidth = durationToPx(soundBite.duration, msPerPx);

    SoundSliver(
      startX: soundSliverStart,
      endX: soundSliverStart + soundSliverWidth,
    ).paint(
      canvas,
      soundSliverTop,
      soundSliverBottom,
    );
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}
