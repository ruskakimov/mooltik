import 'package:animation_app/frame_painter.dart';
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
      duration: Duration(milliseconds: 1000 ~/ 16), // 16 FPS
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 24),
            FloatingActionButton(
              backgroundColor: Colors.red,
              child: Icon(
                _controller.isAnimating ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                if (_controller.isAnimating) {
                  _controller.stop();
                } else {
                  _controller.forward(from: _selectedFrameIndex.toDouble());
                }
              },
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

  Row _buildThumbnails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var i = 0; i < _frames.length; i++) _buildThumbnail(i),
      ],
    );
  }

  Widget _buildThumbnail(int frameIndex) {
    final isSelected = frameIndex == _selectedFrameIndex;

    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
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
              _selectedFrameIndex = frameIndex;
            });
          },
        ),
      ),
    );
  }
}
