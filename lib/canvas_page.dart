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
            SizedBox(width: 16),
            if (!isRecording) _buildPlayButton(),
            SizedBox(width: 16),
            Text('${instructions.length}'),
            Spacer(),
            _buildClearButton(),
            SizedBox(width: 16),
            _buildRecordButton(),
            SizedBox(width: 16),
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
            if (playIndex == instructions.length) playIndex = 0;
          });
          play();
        }
      },
    );
  }

  Widget _buildClearButton() {
    return RaisedButton(
      child: Text('Clear'),
      onPressed: () {
        setState(() {
          instructions.clear();
          playIndex = 0;
        });
      },
    );
  }
}
