import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
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

    final double sliverHeight = 50;
    final double sliverTop = (size.height - sliverHeight) / 2;
    final double sliverBottom = (size.height + sliverHeight) / 2;

    Rect getSliverRect(double startX, double endX) =>
        Rect.fromLTRB(startX, sliverTop, endX, sliverBottom);

    final double selectedFrameWidth = getFrameWidth(selectedFrameIndex);
    final double selectedFrameStartX =
        midX - selectedFrameWidth * selectedFrameProgress;

    final Rect selectedFrameRect = getSliverRect(
      selectedFrameStartX,
      selectedFrameStartX + selectedFrameWidth,
    );
    final sliverRects = [selectedFrameRect];

    // Fill with slivers on left side.
    for (int i = selectedFrameIndex - 1;
        i >= 0 && sliverRects.first.left > 0;
        i--) {
      final double frameWidth = getFrameWidth(i);
      sliverRects.insert(
        0,
        getSliverRect(
          sliverRects.first.left - frameWidth,
          sliverRects.first.left,
        ),
      );
    }

    // Fill with slivers on right side.
    for (int i = selectedFrameIndex + 1;
        i < frames.length && sliverRects.last.right < size.width;
        i++) {
      final double frameWidth = getFrameWidth(i);
      sliverRects.add(getSliverRect(
        sliverRects.last.right,
        sliverRects.last.right + frameWidth,
      ));
    }

    for (final rect in sliverRects) {
      drawFrameSliver(canvas, rect);
    }
  }

  void drawFrameSliver(Canvas canvas, Rect rect) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(1), Radius.circular(4)),
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}
