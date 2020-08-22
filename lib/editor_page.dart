import 'package:animation_app/frame_painter.dart';
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var i = 0; i < _frames.length; i++) _buildThumbnail(i),
      ],
    );
  }

  Widget _buildThumbnail(int frameIndex) {
    final isSelected = frameIndex == _frameIndex;

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      foregroundDecoration: BoxDecoration(
        border: isSelected ? Border.all(color: Colors.red, width: 3) : null,
      ),
      child: Material(
        elevation: 2,
        color: Colors.white,
        child: InkWell(
          child: CustomPaint(
            size: Size(60, 60),
            painter: FramePainter(_frames[frameIndex]),
          ),
          onTap: () {
            setState(() {
              _frameIndex = frameIndex;
            });
          },
        ),
      ),
    );
  }
}
