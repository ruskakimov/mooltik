import 'package:animation_app/editor/fps_stepper.dart';
import 'package:animation_app/editor/frame_thumbnail.dart';
import 'package:animation_app/editor/gif.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';

import 'frame/frame.dart';
import 'frame/frame_canvas.dart';
import 'toolbar/toolbar.dart';
import 'toolbar/tools.dart';

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
  Tool _selectedTool = Tool.pencil;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: FrameCanvas(
                frame: selectedFrame,
                selectedTool: _selectedTool,
              ),
            ),
            Positioned(
              top: 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildToolBar(),
                  _buildPlayButton(),
                  _buildDownloadButton(),
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

  ToolBar _buildToolBar() {
    return ToolBar(
      value: _selectedTool,
      onChanged: (tool) {
        setState(() {
          _selectedTool = tool;
        });
      },
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

  Widget _buildDownloadButton() {
    return IconButton(
      icon: Icon(Icons.file_download),
      onPressed: () async {
        final bytes = await makeGif(_frames, _fps);
        await Share.file('Share GIF', 'image.gif', bytes, 'image/gif');
      },
    );
  }

  Widget _buildFpsStepper() {
    return FpsStepper(
      value: _fps,
      minValue: 1,
      maxValue: 16,
      onChanged: (int newFps) {
        setState(() {
          _fps = newFps;
        });
        _controller.duration = Duration(milliseconds: 1000 ~/ _fps);
      },
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
