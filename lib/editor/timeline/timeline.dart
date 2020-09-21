import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/timeline_painter.dart';

class Timeline extends StatefulWidget {
  const Timeline({
    Key key,
  }) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  double _offset = 0;

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
            setState(() {
              _offset =
                  (_offset - details.primaryDelta).clamp(0, double.infinity);
            });
          },
          child: CustomPaint(
            painter: TimelinePainter(
              frameWidth: 40,
              offset: _offset,
            ),
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
