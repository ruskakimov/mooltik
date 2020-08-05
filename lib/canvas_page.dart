import 'package:flutter/material.dart';

import 'painter.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({
    Key key,
  }) : super(key: key);

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final List<List<Offset>> lines = [];

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
      lines.add([point]);
    });
  }

  void _extendLastLine(Offset point) {
    if (lines.last == null) return;
    setState(() {
      lines.last.add(point);
    });
  }
}
