import 'package:flutter/material.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:provider/provider.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  double msPerPx = 10;
  double _prevMsPerPx = 10;
  double _scaleOffset;

  Duration pxToDuration(double offset) =>
      Duration(milliseconds: (offset * msPerPx).round());

  double durationToPx(Duration duration) => duration.inMilliseconds / msPerPx;

  @override
  Widget build(BuildContext context) {
    final reel = context.watch<ReelModel>();

    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _prevMsPerPx = msPerPx;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        _scaleOffset ??= 1 - details.scale;
        setState(() {
          msPerPx = _prevMsPerPx / (details.scale + _scaleOffset);
        });
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
