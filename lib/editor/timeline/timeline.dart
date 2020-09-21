import 'dart:math';

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
          final left = min(_prevOffset, _controller.value);
          final right = max(_prevOffset, _controller.value);
          final notch = right - right % frameWidth;
          if (left < notch) {
            Vibration.vibrate(duration: 20);
            context.read<TimelineModel>().selectFrame(notch ~/ frameWidth);
          }
        }
        _prevOffset = _controller.value;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Colors.blueGrey[900],
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            _controller.value -= details.primaryDelta;
          },
          onHorizontalDragEnd: (details) {
            final snapTarget =
                _controller.value - _controller.value % frameWidth;
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
                painter: TimelinePainter(
                  frameWidth: frameWidth,
                  offset: _controller.value,
                ),
              );
            },
          ),
        ),
        Center(
          child: Container(
            width: 2,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}
