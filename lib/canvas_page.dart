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
  int playIndex = 0;
  Duration lastTimestamp;

  void play() {
    if (playIndex >= instructions.length) return;
    final instruction = instructions[playIndex];
    setState(() {
      playIndex++;
    });

    if (instruction is DelayedInstruction) {
      Future.delayed(instruction.delay, play);
    } else {
      play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Play'),
              onPressed: () {
                playIndex = 0;
                play();
              },
            )
          ],
        ),
        Expanded(
          child: Listener(
            onPointerDown: (PointerDownEvent e) {
              setState(() {
                instructions.add(TeleportTo(e.localPosition));
              });
            },
            onPointerMove: (PointerMoveEvent e) {
              final delay = e.timeStamp - (lastTimestamp ?? e.timeStamp);
              setState(() {
                instructions.add(DragTo(e.localPosition, delay));
              });
              lastTimestamp = e.timeStamp;
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: Painter(playIndex == 0
                  ? instructions
                  : instructions.sublist(0, playIndex)),
            ),
          ),
        ),
      ],
    );
  }
}
