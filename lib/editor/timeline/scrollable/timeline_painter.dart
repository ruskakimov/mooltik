import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/sound_bite.dart';
import 'package:mooltik/editor/timeline/scrollable/convert.dart';
import 'package:mooltik/editor/timeline/scrollable/sliver/frame_sliver.dart';

class TimelinePainter extends CustomPainter {
  TimelinePainter({
    @required this.frames,
    @required this.selectedFrameIndex,
    @required this.selectedFrameProgress,
    @required this.msPerPx,
    this.soundBite,
  });

  final List<FrameModel> frames;
  final int selectedFrameIndex;
  final double selectedFrameProgress;
  final double msPerPx;

  // TODO: Add multiple sound bites support.
  final SoundBite soundBite;

  double getFrameWidth(int frameIndex) => durationToPx(
        frames[frameIndex].duration,
        msPerPx,
      );

  FrameSliver getSelectedFrameSliver(double midX) {
    final double selectedFrameWidth = getFrameWidth(selectedFrameIndex);
    final double selectedFrameStartX =
        midX - selectedFrameWidth * selectedFrameProgress;
    return FrameSliver(
      startX: selectedFrameStartX,
      endX: selectedFrameStartX + selectedFrameWidth,
      thumbnail: frames[selectedFrameIndex].snapshot,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
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

    final double sliverHeight = 80;
    final double sliverTop = (size.height - sliverHeight) / 2;
    final double sliverBottom = (size.height + sliverHeight) / 2;

    for (final sliver in slivers) {
      sliver.paint(canvas, sliverTop, sliverBottom);
    }
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}
