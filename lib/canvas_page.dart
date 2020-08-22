import 'package:flutter/material.dart';

import 'painter.dart';
import 'stroke.dart';

class CanvasPage extends StatefulWidget {
  CanvasPage({Key key}) : super(key: key);

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final List<Stroke> strokes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: Center(
        child: GestureDetector(
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
        ),
      ),
    );
  }
}
