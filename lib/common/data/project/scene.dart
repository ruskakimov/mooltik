import 'dart:io';

import 'package:flutter/material.dart';
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

  int? get frameWidth => layers.first.frameSeq.current.width;
  int? get frameHeight => layers.first.frameSeq.current.height;

  /// Visible image at a given playhead position.
  CompositeImage imageAt(Duration playhead) {
    playhead = playhead.clamp(Duration.zero, duration);
    return CompositeImage(
      width: frameWidth!,
      height: frameHeight!,
      layers: visibleLayers
          .map((layer) => layer.frameAt(playhead).snapshot!)
          .toList(),
    );
  }

  /// Files instead of a composite image for testing purposes.
  @visibleForTesting
  List<File> imageFilesAt(Duration playhead) {
    playhead = playhead.clamp(Duration.zero, duration);
    return layers.map((layer) => layer.frameAt(playhead).file).toList();
  }

  /// All unique frames in this scene.
  Iterable<Frame> get allFrames sync* {
    for (var layer in layers) {
      yield* layer.frameSeq.iterable;
    }
  }

  /// Frames for export video.
  Iterable<CompositeFrame> get exportFrames sync* {
    final rows =
        visibleLayers.map((layer) => layer.getExportFrames(duration)).toList();

    final rowIterators =
        rows.map((frames) => frames.iterator..moveNext()).toList();

    final iteratorStartTimes = List.filled(rows.length, Duration.zero);

    var elapsed = Duration.zero;

    while (elapsed < duration) {
      final compositeImage = CompositeImage(
        width: frameWidth!,
        height: frameHeight!,
        layers: rowIterators.map((it) => it.current.snapshot!).toList(),
      );

      var smallestJump = duration;
      var progressingIndices = <int>[];

      for (var i = 0; i < rowIterators.length; i++) {
        final frame = rowIterators[i].current;

        final frameStartTime = iteratorStartTimes[i];
        final frameEndTime = frameStartTime + frame.duration;

        final jump = frameEndTime - elapsed;

        if (jump < smallestJump) {
          progressingIndices = [i];
          smallestJump = jump;
        } else if (jump == smallestJump) {
          progressingIndices.add(i);
        }
      }

      yield CompositeFrame(compositeImage, smallestJump);

      progressingIndices.forEach((i) {
        final it = rowIterators[i];
        iteratorStartTimes[i] += it.current.duration;
        it.moveNext();
      });

      elapsed += smallestJump;
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
