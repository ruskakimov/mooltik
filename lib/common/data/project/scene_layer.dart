import 'package:mooltik/common/data/extensions/duration_methods.dart';
import 'package:mooltik/common/data/project/frame_interface.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/editing/data/timeline_scene_layer_interface.dart';

/// Play behaviour when scene duration is longer than the total duration of frames.
enum PlayMode {
  /// Last frame is extended.
  extendLast,

  /// Frames are repeated again from the start.
  loop,

  /// Playhead goes back and forth.
  pingPong,
}

class SceneLayer implements TimelineSceneLayerInterface {
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

  int get realFrameCount => frameSeq.length;
  Iterable<FrameInterface> get realFrames => frameSeq.iterable;

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

  Iterable<Frame> getPlayFrames(Duration totalDuration) sync* {
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

  void setPlayMode(PlayMode value) {
    _playMode = value;
  }

  void changePlayMode() {
    _playMode = PlayMode.values[(playMode.index + 1) % PlayMode.values.length];
  }

  void setVisibility(bool value) {
    _visible = value;
  }

  void toggleVisibility() {
    _visible = !_visible;
  }

  void setName(String value) {
    _name = value;
  }

  void setGroupedWithNext(bool value) {
    _groupedWithNext = value;
  }

  Future<SceneLayer> duplicate() async {
    final duplicateFrames = await Future.wait(
      frameSeq.iterable.map((frame) => frame.duplicate()),
    );
    return SceneLayer(Sequence(duplicateFrames), playMode);
  }

  factory SceneLayer.fromJson(
    Map<String, dynamic> json,
    String frameDirPath,
    int width,
    int height,
  ) =>
      SceneLayer(
        Sequence<Frame>((json[_framesKey] as List<dynamic>)
            .map((d) => Frame.fromJson(d, frameDirPath, width, height))
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

  void deleteAt(int realFrameIndex) {
    frameSeq.removeAt(realFrameIndex);
  }

  Future<void> duplicateAt(int realFrameIndex) async {
    final duplicate = await frameSeq[realFrameIndex].duplicate();
    frameSeq.insert(realFrameIndex, duplicate);
  }

  void changeDurationAt(int realFrameIndex, Duration newDuration) {
    frameSeq.changeSpanDurationAt(realFrameIndex, newDuration);
  }

  void changeAllFramesDuration(Duration newFrameDuration) {
    for (var i = 0; i < frameSeq.length; i++) {
      frameSeq.changeSpanDurationAt(i, newFrameDuration);
    }
  }

  Duration startTimeOf(int realFrameIndex) =>
      frameSeq.startTimeOf(realFrameIndex);

  Duration endTimeOf(int realFrameIndex) => frameSeq.endTimeOf(realFrameIndex);
}

const String _framesKey = 'frames';
const String _playModeKey = 'play_mode';
const String _visibilityKey = 'visible';
const String _nameKey = 'name';
const String _groupedWithNextKey = 'grouped_with_next';
