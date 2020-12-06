import 'package:flutter/material.dart';
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

  Duration pxToDuration(double offset) =>
      Duration(milliseconds: (offset * msPerPx).round());

  double durationToPx(Duration duration) => duration.inMilliseconds / msPerPx;

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
        timeline.scrub(pxToDuration(-diff.dx));
        _prevFocalPoint = details.localFocalPoint;
      },
      onScaleEnd: (ScaleEndDetails details) {
        _scaleOffset = null;
      },
      child: SizedBox.expand(
        child: ColoredBox(
          color: Colors.black.withOpacity(0.2),
          child: CustomPaint(),
        ),
      ),
    );
  }
}
