import 'package:animation_app/frame_thumbnail.dart';
import 'package:flutter/material.dart';

import 'frame.dart';
import 'frame_canvas.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key key}) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage>
    with SingleTickerProviderStateMixin {
  List<Frame> _frames;
  int _fps = 16;
  int _selectedFrameIndex;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _frames = [Frame(), Frame()];
    _selectedFrameIndex = 0;
    _controller = AnimationController(
      lowerBound: 0,
      upperBound: _frames.length.toDouble(),
      duration: Duration(milliseconds: 1000 ~/ _fps),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _selectedFrameIndex = (_selectedFrameIndex + 1) % _frames.length;
        });
        _controller.reset();
        _controller.forward();
      }
    });
  }

  void _updateFps(int newFps) {
    setState(() {
      _fps = (newFps).clamp(1, 16);
    });
    _controller.duration = Duration(milliseconds: 1000 ~/ _fps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildPlayButton(),
                SizedBox(width: 32),
                _buildFpsStepper(),
              ],
            ),
            Expanded(
              child: Center(
                child: FrameCanvas(frame: _frames[_selectedFrameIndex]),
              ),
            ),
            _buildThumbnails(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      child: Icon(
        _controller.isAnimating ? Icons.pause : Icons.play_arrow,
      ),
      onPressed: () {
        if (_controller.isAnimating) {
          _controller.stop();
          setState(() {});
        } else {
          _controller.forward(from: _selectedFrameIndex.toDouble());
        }
      },
    );
  }

  Widget _buildFpsStepper() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => _updateFps(_fps - 1),
        ),
        SizedBox(
          width: 32,
          child: Center(
            child: Text(
              '$_fps',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _updateFps(_fps + 1),
        ),
      ],
    );
  }

  Widget _buildThumbnails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var i = 0; i < _frames.length; i++)
          FrameThumbnail(
            frame: _frames[i],
            isSelected: i == _selectedFrameIndex,
            onTap: () {
              setState(() {
                _selectedFrameIndex = i;
              });
            },
          ),
      ],
    );
  }
}
