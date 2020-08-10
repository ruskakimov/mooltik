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
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => _handleMoveTo(e.localPosition),
      onPointerMove: (e) => _handleDragTo(e.localPosition),
      child: CustomPaint(
        painter: Painter(),
      ),
    );
  }

  void _handleMoveTo(Offset point) {
    print(point);
  }

  void _handleDragTo(Offset point) {
    print(point);
  }
}
