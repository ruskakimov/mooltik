import 'package:mooltik/common/data/duration_methods.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

class Scene extends TimeSpan {
  Scene({
    required this.layers,
    Duration duration = const Duration(seconds: 2, milliseconds: 500),
    this.description,
  }) : super(duration);

  final List<SceneLayer> layers;
  final String? description;

  Iterable<SceneLayer> get visibleLayers =>
      layers.where((layer) => layer.visible);

  int? get frameWidth => layers.first.frameSeq.current.image.width;
  int? get frameHeight => layers.first.frameSeq.current.image.height;

  /// Visible image at a given playhead position.
  CompositeImage imageAt(Duration playhead) {
    playhead = playhead.clamp(Duration.zero, duration);
    return CompositeImage(
      width: frameWidth!,
      height: frameHeight!,
      layers: visibleLayers
          .map((layer) => layer.frameAt(playhead).image.snapshot!)
          .toList(),
    );
  }

  /// All unique frames in this scene.
  Iterable<Frame> get allFrames sync* {
    for (var layer in layers) {
      yield* layer.frameSeq.iterable;
    }
  }

  /// Frames for export video.
  Iterable<CompositeFrame> get exportFrames sync* {
    final tracks =
        visibleLayers.map((layer) => layer.getExportFrames(duration)).toList();

    final trackIterators =
        tracks.map((frames) => frames.iterator..moveNext()).toList();

    final iteratorStartTimes = List.filled(tracks.length, Duration.zero);

    List<Duration> getIteratorEndTimes() => [
          for (var i = 0; i < trackIterators.length; i++)
            iteratorStartTimes[i] + trackIterators[i].current.duration
        ];

    var elapsed = Duration.zero;

    while (elapsed < duration) {
      final compositeImage = CompositeImage(
        width: frameWidth!,
        height: frameHeight!,
        layers: trackIterators.map((it) => it.current.image.snapshot!).toList(),
      );

      final iteratorEndTimes = getIteratorEndTimes();
      final closestFrameEnd = iteratorEndTimes.reduce(minDuration);
      final frameDuration = closestFrameEnd - elapsed;

      for (var i = 0; i < trackIterators.length; i++) {
        if (iteratorEndTimes[i] == closestFrameEnd) {
          iteratorStartTimes[i] = iteratorEndTimes[i];
          trackIterators[i].moveNext();
        }
      }

      yield CompositeFrame(compositeImage, frameDuration);

      elapsed += frameDuration;
    }
  }

  factory Scene.fromJson(Map<String, dynamic> json, String frameDirPath) =>
      Scene(
        layers: (json[_layersKey] as List<dynamic>)
            .map((d) => SceneLayer.fromJson(d, frameDirPath))
            .toList(),
        duration: (json[_durationKey] as String).parseDuration(),
        description: json[_descriptionKey] as String?,
      );

  Map<String, dynamic> toJson() => {
        _layersKey: layers.map((layer) => layer.toJson()).toList(),
        _durationKey: duration.toString(),
        _descriptionKey: description,
      };

  Scene copyWith({
    List<SceneLayer>? layers,
    Duration? duration,
    String? description,
  }) =>
      Scene(
        layers: layers ?? this.layers,
        duration: duration ?? this.duration,
        description: description ?? this.description,
      );

  @override
  String toString() => layers.fold(
        '',
        (previousValue, layer) => previousValue + layer.toString(),
      );
}

const String _layersKey = 'layers';
const String _durationKey = 'duration';
const String _descriptionKey = 'description';
