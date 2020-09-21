import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/timeline_painter.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: double.infinity,
    );
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
            final snapTarget = _controller.value - _controller.value % 40;
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
                  frameWidth: 40,
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
