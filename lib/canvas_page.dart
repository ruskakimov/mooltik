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
  final contactPoints = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => _addContactPoint(e.localPosition),
      onPointerMove: (e) => _addContactPoint(e.localPosition),
      child: CustomPaint(
        painter: Painter(
          dots: contactPoints,
        ),
      ),
    );
  }

  void _addContactPoint(Offset position) {
    setState(() {
      contactPoints.add(position);
    });
  }
}
