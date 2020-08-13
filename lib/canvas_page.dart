import 'package:flutter/material.dart';

import 'instructions.dart';
import 'painter.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({
    Key key,
  }) : super(key: key);

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final List<Instruction> instructions = [];

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent e) {
        setState(() {
          instructions.add(TeleportTo(e.localPosition));
        });
      },
      onPointerMove: (PointerMoveEvent e) {
        setState(() {
          instructions.add(DragTo(e.localPosition, Duration.zero));
        });
      },
      child: CustomPaint(
        painter: Painter(instructions),
      ),
    );
  }
}
