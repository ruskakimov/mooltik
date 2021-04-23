import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/scene_model.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';

void main() {
  group('TimelineViewModel', () {
    test('does not allow moving SceneEndHandle past playhead', () {
      final sceneA = SceneModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 2)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        duration: Duration(seconds: 4),
      );

      final sceneB = SceneModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('3.png'), duration: Duration(seconds: 1)),
          FrameModel(file: File('4.png'), duration: Duration(seconds: 1)),
        ]),
        duration: Duration(seconds: 9),
      );

      final timeline = TimelineModel(
        sceneSeq: Sequence<SceneModel>([sceneA, sceneB]),
        vsync: TestVSync(),
      );

      final timelineView = TimelineViewModel(
        timeline: timeline,
        sharedPreferences: null,
        createNewFrame: null,
      );

      timelineView.selectSliver(0);
      timelineView.editScene();

      timeline
          .scrub(TimeSpan.singleFrameDuration * 50 + Duration(milliseconds: 1));

      timelineView
          .onSceneEndHandleDragUpdate(TimeSpan.singleFrameDuration * 50);

      expect(timeline.currentScene, sceneA);
      expect(timeline.currentSceneEnd, TimeSpan.singleFrameDuration * 51);
    });
  });
}
