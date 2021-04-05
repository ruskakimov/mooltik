import 'package:flutter/material.dart';
import 'package:mooltik/common/data/duration_methods.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

/// Play behaviour when scene duration is longer than the total duration of frames.
enum PlayMode {
  /// Last frame is extended.
  extendLast,

  /// Frames are repeated again from the start.
  loop,

  /// Playhead goes back and forth.
  pingPong,
}

class SceneModel extends TimeSpan {
  SceneModel({
    @required List<FrameModel> frames,
    Duration duration = const Duration(seconds: 5),
    this.playMode = PlayMode.extendLast,
  })  : frameSeq = Sequence<FrameModel>(frames),
        super(duration);

  final Sequence<FrameModel> frameSeq;
  final PlayMode playMode;

  /// Frame at a given playhead position.
  FrameModel frameAt(Duration playhead) {
    if (playhead < Duration.zero || playhead > duration) {
      throw Exception(
          'Given playhead value $playhead is outside of scene range.');
    }

    if (playMode == PlayMode.extendLast) {
      // playhead
      // clamp between 0, frameSeq.totalDuration
    } else if (playMode == PlayMode.loop) {
      // playhead
      // mod frameSeq.totalDuration
    } else if (playMode == PlayMode.pingPong) {
      // playhead
      //
    }

    frameSeq.playhead = playhead;
    return frameSeq.current;
  }

  // TODO: Frames for export
  List<FrameModel> get exportFrames => null;

  factory SceneModel.fromJson(Map<String, dynamic> json, String frameDirPath) =>
      SceneModel(
        frames: (json['frames'] as List<dynamic>)
            .map((d) => FrameModel.fromJson(d, frameDirPath))
            .toList(),
        duration: (json['duration'] as String).parseDuration(),
      );

  Map<String, dynamic> toJson() => {
        'frames': frameSeq.iterable.map((d) => d.toJson()).toList(),
        'duration': duration.toString(),
      };
}
