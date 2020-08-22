import 'package:flutter/material.dart';

import 'frame.dart';
import 'frame_canvas.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key key}) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final List<Frame> frames = [Frame(), Frame()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: Center(child: FrameCanvas(frame: frames.first)),
    );
  }
}
