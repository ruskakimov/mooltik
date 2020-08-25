import 'package:animation_app/frame_thumbnail.dart';
import 'package:flutter/material.dart';

import 'frame.dart';
import 'frame_canvas.dart';
import 'toolbar.dart';

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

  Frame get selectedFrame => _frames[_selectedFrameIndex];

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
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: FrameCanvas(frame: selectedFrame),
            ),
            Positioned(
              top: 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ToolBar(),
                  _buildPlayButton(),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _controller.isAnimating
                    ? _buildFpsStepper()
                    : _buildThumbnails(),
              ),
            ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => _updateFps(_fps - 1),
        ),
        SizedBox(
          width: 32,
          child: Column(
            children: <Widget>[
              Text(
                '$_fps',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('fps'),
            ],
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
