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

  @override
  void paint(Canvas canvas, Size size) {
    final double midX = size.width / 2;

    final double frameWidth =
        durationToPx(frames[selectedFrameIndex].duration, msPerPx);
    final double frameStartX = midX - frameWidth * selectedFrameProgress;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          frameStartX,
          (size.height - 60) / 2,
          frameWidth,
          60,
        ),
        Radius.circular(4),
      ),
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;
}
