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

  double _midX;

  double xFromTime(Duration time) =>
      _midX + durationToPx(time - playheadPosition, msPerPx);

  double widthFromDuration(Duration duration) =>
      durationToPx(duration, msPerPx);

  FrameSliver getSelectedFrameSliver() {
    final double selectedFrameStartX = xFromTime(selectedFrameStartTime);
    final double selectedFrameWidth =
        widthFromDuration(frames[selectedFrameIndex].duration);
    return FrameSliver(
      startX: selectedFrameStartX,
      endX: selectedFrameStartX + selectedFrameWidth,
      thumbnail: frames[selectedFrameIndex].snapshot,
    );
  }

  List<FrameSliver> getVisibleFrameSlivers(Size size) {
    final List<FrameSliver> slivers = [getSelectedFrameSliver()];

    // Fill with slivers on left side.
    for (int i = selectedFrameIndex - 1;
        i >= 0 && slivers.first.startX > 0;
        i--) {
      slivers.insert(
        0,
        FrameSliver(
          startX: slivers.first.startX - widthFromDuration(frames[i].duration),
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
        endX: slivers.last.endX + widthFromDuration(frames[i].duration),
        thumbnail: frames[i].snapshot,
      ));
    }
    return slivers;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _midX = size.width / 2;

    final List<FrameSliver> frameSlivers = getVisibleFrameSlivers(size);

    final double sliverHeight = (size.height - 24) / 2;

    final double frameSliverTop = 8;
    final double frameSliverBottom = frameSliverTop + sliverHeight;

    for (final sliver in frameSlivers) {
      sliver.paint(canvas, frameSliverTop, frameSliverBottom);
    }

    if (soundBite != null) {
      final double soundSliverTop = frameSliverBottom + 8;
      final double soundSliverBottom = soundSliverTop + sliverHeight;

      final double soundSliverStartX = xFromTime(soundBite.startTime);
      final double soundSliverWidth = widthFromDuration(soundBite.duration);

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
