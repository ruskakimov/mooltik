import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/ui/frame_window.dart';

class AnimatedLayerPreview extends StatefulWidget {
  AnimatedLayerPreview({
    Key? key,
    required this.frames,
    this.frameDuration = const Duration(milliseconds: 40 * 5),
  }) : super(key: key);

  final List<Frame> frames;
  final Duration frameDuration;

  @override
  AnimatedLayerPreviewState createState() => AnimatedLayerPreviewState();
}

class AnimatedLayerPreviewState extends State<AnimatedLayerPreview> {
  int _frameIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.frameDuration, _tick);
  }

  void _tick() {
    setState(() {
      _frameIndex = (_frameIndex + 1) % widget.frames.length;
    });
    _timer = Timer(widget.frameDuration, _tick);
  }

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
