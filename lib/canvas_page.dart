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
  bool isRecording = true;
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Play'),
              onPressed: () {
                playIndex = 0;
                play();
              },
            ),
            RaisedButton(
              child: Text('Record'),
              color: isRecording ? Colors.red : null,
              onPressed: () {
                setState(() {
                  isRecording = !isRecording;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: Listener(
            onPointerDown: (PointerDownEvent e) {
              if (!isRecording) return;
              setState(() {
                instructions.add(TeleportTo(e.localPosition));
              });
            },
            onPointerMove: (PointerMoveEvent e) {
              if (!isRecording) return;
              final delay = e.timeStamp - (lastTimestamp ?? e.timeStamp);
              setState(() {
                instructions.add(DragTo(e.localPosition, delay));
              });
              lastTimestamp = e.timeStamp;
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: Painter(isRecording
                  ? instructions
                  : instructions.sublist(0, playIndex)),
            ),
          ),
        ),
      ],
    );
  }
}
