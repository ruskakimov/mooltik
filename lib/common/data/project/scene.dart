import 'package:flutter/material.dart';
import 'package:mooltik/common/data/duration_methods.dart';
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

class SceneLayer {
  SceneLayer(this.frameSeq, this.playMode);

  final Sequence<Frame> frameSeq;
  final PlayMode playMode;

  /// Frame at a given playhead position.
  Frame frameAt(Duration playhead) {
    // playhead = playhead.clamp(Duration.zero, duration);

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

  Iterable<Frame> getGhostFrames(Duration totalDuration) =>
      getExportFrames(totalDuration).skip(frameSeq.length);

  Iterable<Frame> getExportFrames(Duration totalDuration) sync* {
    var elapsed = Duration.zero;
    var i = 0;

    while (elapsed < totalDuration) {
      var frame = _frameAt(i);

      final extendedFrame =
          playMode == PlayMode.extendLast && i == frameSeq.length;
      final overflowingFrame = elapsed + frame.duration > totalDuration;

      if (extendedFrame || overflowingFrame) {
        final leftover = totalDuration - elapsed;
        frame = frame.copyWith(duration: leftover);
      }

      yield frame;
      elapsed += frame.duration;
      i++;
    }
  }

  Frame _frameAt(int i) {
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
}
