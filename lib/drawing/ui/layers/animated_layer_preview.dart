import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/fps_config.dart';
import 'package:mooltik/common/data/project/frame_interface.dart';
import 'package:mooltik/drawing/ui/painted_glass.dart';

class AnimatedLayerPreview extends StatefulWidget {
  AnimatedLayerPreview({
    Key? key,
    required this.frames,
    this.frameDuration = const Duration(milliseconds: singleFrameMs * 5),
    this.pingPong = false,
  }) : super(key: key);

  final List<FrameInterface> frames;
  final Duration frameDuration;
  final bool pingPong;

  @override
  AnimatedLayerPreviewState createState() => AnimatedLayerPreviewState();
}

class AnimatedLayerPreviewState extends State<AnimatedLayerPreview> {
  int _frameIndex = 0;
  late Timer _timer;
  bool _playForward = true; // Used to control ping-pong animation.

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.frameDuration, _tick);
  }

  void _tick() {
    setState(() {
      _frameIndex = widget.pingPong
          ? _nextFrameIndexForPingPong()
          : _nextFrameIndexForLoop();
    });
    _timer = Timer(widget.frameDuration, _tick);
  }

  int _nextFrameIndexForLoop() => (_frameIndex + 1) % widget.frames.length;

  int _nextFrameIndexForPingPong() {
    final step = _playForward ? 1 : -1;

    if (_isValidFrameIndex(_frameIndex + step)) {
      return _frameIndex + step;
    } else {
      _playForward = !_playForward;
      return _frameIndex;
    }
  }

  bool _isValidFrameIndex(int index) =>
      index >= 0 && index < widget.frames.length;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaintedGlass(image: widget.frames[_frameIndex].image);
  }
}
