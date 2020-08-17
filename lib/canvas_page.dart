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
  bool isRecording = false;
  final List<Instruction> instructions = [];
  Duration lastTimestamp;

  // Player state.
  int playIndex = 0;
  bool isPlaying = false;

  void play() {
    if (!isPlaying || playIndex >= instructions.length) {
      setState(() {
        isPlaying = false;
      });
      return;
    }
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
          children: <Widget>[
            if (!isRecording) _buildPlayButton(),
            Spacer(),
            _buildRecordButton(),
          ],
        ),
        Expanded(
          child: Listener(
            onPointerDown: (PointerDownEvent e) {
              if (!isRecording) return;

              setState(() {
                instructions.add(TeleportTo(e.localPosition));
                lastTimestamp = e.timeStamp;
              });
            },
            onPointerMove: (PointerMoveEvent e) {
              if (!isRecording) return;

              final delay = e.timeStamp - lastTimestamp;
              lastTimestamp = e.timeStamp;

              setState(() {
                instructions.add(DragTo(e.localPosition, delay));
              });
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

  Widget _buildRecordButton() {
    return RaisedButton(
      child: Text('Record'),
      color: isRecording ? Colors.red : null,
      onPressed: () {
        setState(() {
          isRecording = !isRecording;
          if (!isRecording) playIndex = instructions.length;
        });
      },
    );
  }

  Widget _buildPlayButton() {
    return RaisedButton(
      child: Text(isPlaying ? 'Pause' : 'Play'),
      onPressed: () {
        if (isPlaying) {
          setState(() {
            isPlaying = false;
          });
        } else {
          setState(() {
            isPlaying = true;
            playIndex = 0;
          });
          play();
        }
      },
    );
  }
}
