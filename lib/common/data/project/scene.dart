import 'package:flutter/material.dart';
import 'package:mooltik/common/data/duration_methods.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

/// Play behaviour when scene duration is longer than the total duration of frames.
enum PlayMode {
  /// Last frame is extended.
  extendLast,

  /// Frames are repeated again from the start.
  loop,

  /// Playhead goes back and forth.
  pingPong,
}

class Scene extends TimeSpan {
  Scene({
    @required Sequence<Frame> frameSeq,
    Duration duration = const Duration(seconds: 5),
    PlayMode playMode = PlayMode.extendLast,
  })  : layer = SceneLayer(frameSeq, playMode),
        super(duration);

  final SceneLayer layer;

  Iterable<Frame> get uniqueFrames => layer.frameSeq.iterable;

  Iterable<Frame> get ghostFrames => layer.getGhostFrames(duration);

  Iterable<Frame> get exportFrames => layer.getExportFrames(duration);

  Frame frameAt(Duration playhead) {
    playhead = playhead.clamp(Duration.zero, duration);
    return layer.frameAt(playhead);
  }

  factory Scene.fromJson(Map<String, dynamic> json, String frameDirPath) =>
      Scene(
        frameSeq: Sequence<Frame>((json['frames'] as List<dynamic>)
            .map((d) => Frame.fromJson(d, frameDirPath))
            .toList()),
        duration: (json['duration'] as String).parseDuration(),
        playMode: PlayMode.values[json['play_mode'] as int ?? 0],
      );

  Map<String, dynamic> toJson() => {
        'frames': layer.frameSeq.iterable.map((d) => d.toJson()).toList(),
        'duration': duration.toString(),
        'play_mode': layer.playMode.index,
      };

  Scene copyWith({
    List<Frame> frames,
    Duration duration,
    PlayMode playMode,
  }) =>
      Scene(
        frameSeq:
            frames != null ? Sequence<Frame>(frames) : this.layer.frameSeq,
        duration: duration ?? this.duration,
        playMode: playMode ?? this.layer.playMode,
      );

  @override
  String toString() => layer.frameSeq.iterable
      .fold('', (previousValue, frame) => previousValue + frame.toString());
}
