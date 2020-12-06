import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.frames,
  })  : assert(frames != null && frames.isNotEmpty),
        _playheadPosition = Duration.zero {
    _totalDuration = frames.fold(
      Duration.zero,
      (duration, frame) => duration + frame.duration,
    );
  }

  final List<FrameModel> frames;

  Duration get playheadPosition => _playheadPosition;
  Duration _playheadPosition;

  Duration get totalDuration => _totalDuration;
  Duration _totalDuration;
}
