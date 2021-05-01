import 'package:mooltik/common/data/duration_methods.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

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
