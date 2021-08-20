import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/ui/frame_window.dart';

class AnimatedLayerPreview extends StatefulWidget {
  AnimatedLayerPreview({
    Key? key,
    required this.frames,
    this.frameDuration = const Duration(milliseconds: 40 * 5),
    this.pingPong = false,
  }) : super(key: key);

  final List<Frame> frames;
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
    return FrameWindow(frame: widget.frames[_frameIndex]);
  }
}
