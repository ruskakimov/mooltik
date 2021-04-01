import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

class SceneModel extends TimeSpan {
  SceneModel({
    @required this.frameSeq,
    Duration duration = const Duration(seconds: 5),
  }) : super(duration);

  final Sequence<FrameModel> frameSeq;
}
