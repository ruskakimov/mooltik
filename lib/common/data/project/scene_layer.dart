import 'package:mooltik/common/data/extensions/duration_methods.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
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

class SceneLayer {
  SceneLayer(
    this.frameSeq, [
    PlayMode playMode = PlayMode.extendLast,
    bool? visible = true,
    String? name,
    bool? groupedWithNext,
  ])  : _playMode = playMode,
        _visible = visible ?? true,
        _name = name,
        _groupedWithNext = groupedWithNext ?? false;

  final Sequence<Frame> frameSeq;

  PlayMode get playMode => _playMode;
  PlayMode _playMode;

  bool get visible => _visible;
  bool _visible;

  String? get name => _name;
  String? _name;

  bool get groupedWithNext => _groupedWithNext;
  bool _groupedWithNext;

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

      final isExtendedFrame =
          playMode == PlayMode.extendLast && i == frameSeq.length;
      final isOverflowingFrame = elapsed + frame.duration > totalDuration;

      if (isExtendedFrame || isOverflowingFrame) {
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

  void nextPlayMode() {
    _playMode = PlayMode.values[(playMode.index + 1) % PlayMode.values.length];
  }

  void setPlayMode(PlayMode value) {
    _playMode = value;
  }

  void setVisibility(bool value) {
    _visible = value;
  }

  void setName(String value) {
    _name = value;
  }

  Future<SceneLayer> duplicate() async {
    final duplicateFrames = await Future.wait(
      frameSeq.iterable.map((frame) => frame.duplicate()),
    );
    return SceneLayer(Sequence(duplicateFrames), playMode);
  }

  factory SceneLayer.fromJson(Map<String, dynamic> json, String frameDirPath) =>
      SceneLayer(
        Sequence<Frame>((json[_framesKey] as List<dynamic>)
            .map((d) => Frame.fromJson(d, frameDirPath))
            .toList()),
        PlayMode.values[json[_playModeKey] as int? ?? 0],
        json[_visibilityKey] as bool?,
        json[_nameKey] as String?,
        json[_groupedWithNextKey] as bool?,
      );

  Map<String, dynamic> toJson() => {
        _framesKey: frameSeq.iterable.map((d) => d.toJson()).toList(),
        _playModeKey: playMode.index,
        _visibilityKey: visible,
        _nameKey: name,
        _groupedWithNextKey: _groupedWithNext,
      };

  @override
  String toString() => frameSeq.iterable.fold(
        '',
        (previousValue, frame) => previousValue + frame.toString(),
      );

  void dispose() {
    frameSeq.iterable.forEach((frame) => frame.dispose());
  }
}

const String _framesKey = 'frames';
const String _playModeKey = 'play_mode';
const String _visibilityKey = 'visible';
const String _nameKey = 'name';
const String _groupedWithNextKey = 'grouped_with_next';
