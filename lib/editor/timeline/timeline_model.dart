import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.frames,
  })  : assert(frames != null && frames.isNotEmpty),
        _playheadPosition = Duration.zero;

  final List<FrameModel> frames;

  Duration get playheadPosition => _playheadPosition;
  Duration _playheadPosition;
}
