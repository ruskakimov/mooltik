import 'package:flutter/material.dart';

import 'frame_canvas.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: Center(child: FrameCanvas()),
    );
  }
}
