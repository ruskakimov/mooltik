import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:mooltik/editor/timeline/timeline_painter.dart';
import 'package:vibration/vibration.dart';

class Timeline extends StatefulWidget {
  const Timeline({
    Key key,
  }) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _prevOffset;

  final frameWidth = 40.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: double.infinity,
    )..addListener(() {
        if (_prevOffset != null) {
          final prevFrameNumber = _frameNumber(_prevOffset);
          final newFrameNumber = _frameNumber(_controller.value);

          if (newFrameNumber != prevFrameNumber) {
            Vibration.vibrate(duration: 20);
            context.read<TimelineModel>().selectFrame(newFrameNumber);
          }
        }
        _prevOffset = _controller.value;
      });
  }

  int _frameNumber(double offset) => offset ~/ frameWidth + 1;

  double _notchPositionBefore(double offset) => offset - offset % frameWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          _controller.value -= details.primaryDelta;
        },
        onHorizontalDragEnd: (details) {
          final snapTarget = _notchPositionBefore(_controller.value);
          _controller.animateTo(
            snapTarget,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              child: ColoredBox(
                color: Colors.blueGrey[900],
              ),
              foregroundPainter: TimelinePainter(
                frameWidth: frameWidth,
                offset: _controller.value,
                emptyKeyframes: [1],
                keyframes: [3, 4, 8, 10],
                animationDuration: 24,
              ),
            );
          },
        ),
      ),
    );
  }
}
