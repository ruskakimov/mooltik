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
    @required this.frameSeq,
    Duration duration = const Duration(seconds: 5),
    this.playMode = PlayMode.extendLast,
  }) : super(duration);

  final Sequence<FrameModel> frameSeq;
  final PlayMode playMode;

  /// Frame at a given playhead position.
  FrameModel frameAt(Duration playhead) {
    playhead = playhead.clamp(Duration.zero, duration);

    if (playMode == PlayMode.extendLast) {
      playhead = playhead.clamp(Duration.zero, frameSeq.totalDuration);
    } else if (playMode == PlayMode.loop) {
      playhead = playhead % frameSeq.totalDuration;
    } else if (playMode == PlayMode.pingPong) {
      playhead = playhead % (frameSeq.totalDuration * 2);
      if (playhead >= frameSeq.totalDuration) {
        playhead = frameSeq.totalDuration * 2 - playhead;
        // Reverse precendence on the edge.
        playhead -= Duration(microseconds: 1);
      }
    }

    frameSeq.playhead = playhead;
    return frameSeq.current;
  }

  Iterable<FrameModel> get ghostFrames => exportFrames.skip(frameSeq.length);

  Iterable<FrameModel> get exportFrames sync* {
    var elapsed = Duration.zero;
    var i = 0;

    while (elapsed < duration) {
      var frame = _frameAt(i);

      final extendedFrame =
          playMode == PlayMode.extendLast && i == frameSeq.length;
      final overflowingFrame = elapsed + frame.duration > duration;

      if (extendedFrame || overflowingFrame) {
        final leftover = duration - elapsed;
        frame = frame.copyWith(duration: leftover);
      }

      yield frame;
      elapsed += frame.duration;
      i++;
    }
  }

  FrameModel _frameAt(int i) {
    final L = frameSeq.length;
    switch (playMode) {
      case PlayMode.extendLast:
        i = i.clamp(0, L - 1);
        break;
      case PlayMode.loop:
        i %= L;
        break;
      case PlayMode.pingPong:
        i %= L * 2;
        if (i >= L) i = 2 * L - i - 1;
        break;
    }
    return frameSeq[i];
  }

  factory SceneModel.fromJson(Map<String, dynamic> json, String frameDirPath) =>
      SceneModel(
        frameSeq: Sequence<FrameModel>((json['frames'] as List<dynamic>)
            .map((d) => FrameModel.fromJson(d, frameDirPath))
            .toList()),
        duration: (json['duration'] as String).parseDuration(),
        playMode: PlayMode.values[json['play_mode'] as int ?? 0],
      );

  Map<String, dynamic> toJson() => {
        'frames': frameSeq.iterable.map((d) => d.toJson()).toList(),
        'duration': duration.toString(),
        'play_mode': playMode.index,
      };

  SceneModel copyWith({
    List<FrameModel> frames,
    Duration duration,
    PlayMode playMode,
  }) =>
      SceneModel(
        frameSeq: frames ?? this.frameSeq,
        duration: duration ?? this.duration,
        playMode: playMode ?? this.playMode,
      );
}
