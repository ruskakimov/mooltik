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
  int frameIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(child: FrameCanvas(frame: frames[frameIndex])),
          ),
          _buildThumbnails(),
        ],
      ),
    );
  }

  Row _buildThumbnails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 0; i < frames.length; i++)
          RaisedButton(
            child: Text('${i + 1}'),
            onPressed: () {
              setState(() {
                frameIndex = i;
              });
            },
          )
      ],
    );
  }
}
