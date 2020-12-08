import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/timeline/scrollable/frame_sliver.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:provider/provider.dart';

class TimelineScrollable extends StatefulWidget {
  const TimelineScrollable({Key key}) : super(key: key);

  @override
  _TimelineScrollableState createState() => _TimelineScrollableState();
}

class _TimelineScrollableState extends State<TimelineScrollable> {
  double msPerPx = 10;
  double _prevMsPerPx = 10;
  double _scaleOffset;
  Offset _prevFocalPoint;

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();

    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _prevMsPerPx = msPerPx;
        _prevFocalPoint = details.localFocalPoint;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        _scaleOffset ??= 1 - details.scale;
        setState(() {
          msPerPx = _prevMsPerPx / (details.scale + _scaleOffset);
        });

        final diff = (details.localFocalPoint - _prevFocalPoint);
        timeline.scrub(pxToDuration(-diff.dx, msPerPx));
        _prevFocalPoint = details.localFocalPoint;
      },
      onScaleEnd: (ScaleEndDetails details) {
        _scaleOffset = null;
      },
      child: SizedBox.expand(
        child: ColoredBox(
          color: Colors.black.withOpacity(0.2),
          child: CustomPaint(
            painter: TimelinePainter(
              frames: timeline.frames,
              selectedFrameIndex: timeline.selectedFrameIndex,
              selectedFrameProgress: timeline.selectedFrameProgress,
              msPerPx: msPerPx,
            ),
          ),
        ),
      ),
    );
  }
}

Duration pxToDuration(double offset, double msPerPx) =>
    Duration(milliseconds: (offset * msPerPx).round());

double durationToPx(Duration duration, double msPerPx) =>
    duration.inMilliseconds / msPerPx;

class TimelinePainter extends CustomPainter {
  TimelinePainter({
    @required this.frames,
    @required this.selectedFrameIndex,
    @required this.selectedFrameProgress,
    @required this.msPerPx,
  });

  final List<FrameModel> frames;
  final int selectedFrameIndex;
  final double selectedFrameProgress;
  final double msPerPx;

  double getFrameWidth(int frameIndex) => durationToPx(
        frames[frameIndex].duration,
        msPerPx,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final double midX = size.width / 2;

    final double selectedFrameWidth = getFrameWidth(selectedFrameIndex);
    final double selectedFrameStartX =
        midX - selectedFrameWidth * selectedFrameProgress;

    final selectedFrameSliver = FrameSliver(
      startX: selectedFrameStartX,
      endX: selectedFrameStartX + selectedFrameWidth,
      thumbnail: frames[selectedFrameIndex].snapshot,
    );
    final List<FrameSliver> slivers = [selectedFrameSliver];

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

    final double sliverHeight = 50;
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
