import 'package:flutter/material.dart';

import 'painter.dart';
import 'renderables/line.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({
    Key key,
  }) : super(key: key);

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final List<Line> lines = [];

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => _startNewLine(e.localPosition),
      onPointerMove: (e) => _extendLastLine(e.localPosition),
      child: CustomPaint(
        painter: Painter(
          lines: lines,
        ),
      ),
    );
  }

  void _startNewLine(Offset point) {
    setState(() {
      lines.add(Line(
        points: [point],
        width: 2,
        color: Colors.white,
      ));
    });
  }

  void _extendLastLine(Offset point) {
    if (lines.last == null) return;
    setState(() {
      lines.last.add(point);
    });
  }
}
