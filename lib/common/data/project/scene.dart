import 'package:flutter/material.dart';
import 'package:mooltik/common/data/duration_methods.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

class Scene extends TimeSpan {
  Scene({
    @required this.layers,
    Duration duration = const Duration(seconds: 5),
  }) : super(duration);

  final List<SceneLayer> layers;

  /// Visible image at a given playhead position.
  CompositeImage imageAt(Duration playhead) {
    playhead = playhead.clamp(Duration.zero, duration);
    return CompositeImage(
      layers.map((layer) => layer.frameAt(playhead).snapshot).toList(),
    );
  }

  /// All unique frames in this scene.
  Iterable<Frame> get allFrames sync* {
    for (var layer in layers) {
      yield* layer.frameSeq.iterable;
    }
  }

  /// Frames for export video.
  /// TODO: Implement
  Iterable<CompositeFrame> get exportFrames => throw UnimplementedError();

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
    List<SceneLayer> layers,
    Duration duration,
  }) =>
      Scene(
        layers: layers ?? this.layers,
        duration: duration ?? this.duration,
      );

  @override
  String toString() => layer.frameSeq.iterable
      .fold('', (previousValue, frame) => previousValue + frame.toString());
}
