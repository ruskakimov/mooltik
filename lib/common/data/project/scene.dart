import 'package:mooltik/common/data/extensions/duration_methods.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/project/layer_group/layer_group_info.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

class Scene extends TimeSpan {
  Scene({
    required this.layers,
    Duration duration = const Duration(seconds: 5),
    this.description,
  }) : super(duration);

  final List<SceneLayer> layers;
  final String? description;

  Iterable<SceneLayer> get visibleLayers =>
      layers.where((layer) => layer.visible);

  int get frameWidth => allFrames.first.image.width;
  int get frameHeight => allFrames.first.image.height;

  /// Visible image at a given playhead position.
  CompositeImage imageAt(Duration playhead) {
    playhead = playhead.clamp(Duration.zero, duration);
    return CompositeImage(
      width: frameWidth,
      height: frameHeight,
      layers:
          visibleLayers.map((layer) => layer.frameAt(playhead).image).toList(),
    );
  }

  /// All unique frames in this scene.
  Iterable<Frame> get allFrames sync* {
    for (var layer in layers) {
      yield* layer.frameSeq.iterable;
    }
  }

  /// Frames for export video.
  Iterable<CompositeFrame> getExportFrames() sync* {
    if (visibleLayers.isEmpty) {
      yield CompositeFrame(
        CompositeImage.empty(width: frameWidth, height: frameHeight),
        duration,
      );
      return;
    }

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
        width: frameWidth,
        height: frameHeight,
        layers: trackIterators.map((it) => it.current.image).toList(),
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

  List<LayerGroupInfo> get layerGroups {
    final groups = <LayerGroupInfo>[];

    bool inGroup = false;
    int groupStart = -1;

    for (var i = 0; i < layers.length; i++) {
      // Group start.
      if (layers[i].groupedWithNext && !inGroup) {
        inGroup = true;
        groupStart = i;
      }
      // Group end.
      if (!layers[i].groupedWithNext && inGroup) {
        groups.add(LayerGroupInfo(groupStart, i));
        inGroup = false;
      }
    }
    return groups;
  }

  Future<Scene> duplicate() async {
    final duplicateLayers =
        await Future.wait(layers.map((layer) => layer.duplicate()));
    return copyWith(layers: duplicateLayers);
  }

  factory Scene.fromJson(
    Map<String, dynamic> json,
    String frameDirPath,
    int width,
    int height,
  ) =>
      Scene(
        layers: (json[_layersKey] as List<dynamic>)
            .map((d) => SceneLayer.fromJson(d, frameDirPath, width, height))
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

  @override
  void dispose() {
    layers.forEach((layer) => layer.dispose());
  }
}

const String _layersKey = 'layers';
const String _durationKey = 'duration';
const String _descriptionKey = 'description';
