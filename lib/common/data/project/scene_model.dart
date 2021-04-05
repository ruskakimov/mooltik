import 'package:flutter/material.dart';
import 'package:mooltik/common/data/parse_duration.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

class SceneModel extends TimeSpan {
  SceneModel({
    @required List<FrameModel> frames,
    Duration duration = const Duration(seconds: 5),
  })  : frameSeq = Sequence<FrameModel>(frames),
        super(duration);

  final Sequence<FrameModel> frameSeq;

  // TODO: Frames for export
  List<FrameModel> get exportFrames => null;

  factory SceneModel.fromJson(Map<String, dynamic> json, String frameDirPath) =>
      SceneModel(
        frames: (json['frames'] as List<dynamic>)
            .map((d) => FrameModel.fromJson(d, frameDirPath))
            .toList(),
        duration: parseDuration(json['duration']),
      );

  Map<String, dynamic> toJson() => {
        'frames': frameSeq.iterable.map((d) => d.toJson()).toList(),
        'duration': duration.toString(),
      };
}
