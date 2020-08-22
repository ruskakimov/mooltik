import 'package:flutter/material.dart';

import 'painter.dart';
import 'stroke.dart';

class FrameCanvas extends StatefulWidget {
  FrameCanvas({Key key}) : super(key: key);

  @override
  _FrameCanvasState createState() => _FrameCanvasState();
}

class _FrameCanvasState extends State<FrameCanvas> {
  final List<Stroke> strokes = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        setState(() {
          strokes.add(Stroke(details.localPosition));
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          strokes.last.extend(details.localPosition);
        });
      },
      child: ClipRect(
        child: CustomPaint(
          foregroundPainter: Painter(strokes),
          child: Container(
            color: Colors.white,
            height: 250,
            width: 250,
          ),
        ),
      ),
    );
  }
}
