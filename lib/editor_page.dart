import 'package:flutter/material.dart';

import 'frame.dart';
import 'frame_canvas.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key key}) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final List<Frame> _frames = [Frame(), Frame()];
  int _frameIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(child: FrameCanvas(frame: _frames[_frameIndex])),
          ),
          _buildThumbnails(),
        ],
      ),
    );
  }

  Row _buildThumbnails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        for (var i = 0; i < _frames.length; i++) _buildThumbnail(i),
      ],
    );
  }

  RaisedButton _buildThumbnail(int frameIndex) {
    return RaisedButton(
      child: Text('${frameIndex + 1}'),
      onPressed: () {
        setState(() {
          _frameIndex = frameIndex;
        });
      },
    );
  }
}
