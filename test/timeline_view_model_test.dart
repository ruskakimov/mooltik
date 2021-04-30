import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';

void main() {
  group('TimelineViewModel', () {
    test('does not resize scene past playhead in scene mode', () {
      final sceneA = Scene(
        frameSeq: Sequence<Frame>([
          Frame(file: File('1.png'), duration: Duration(seconds: 2)),
          Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        duration: Duration(seconds: 4),
      );

      final sceneB = Scene(
        frameSeq: Sequence<Frame>([
          Frame(file: File('3.png'), duration: Duration(seconds: 1)),
          Frame(file: File('4.png'), duration: Duration(seconds: 1)),
        ]),
        duration: Duration(seconds: 9),
      );

      final timeline = TimelineModel(
        sceneSeq: Sequence<Scene>([sceneA, sceneB]),
        vsync: TestVSync(),
      );

      final timelineView = TimelineViewModel(
        timeline: timeline,
        sharedPreferences: null,
        createNewFrame: null,
      );

      timelineView.selectSliver(0);
      timelineView.editScene();

      timeline.jumpTo(TimeSpan.singleFrameDuration * 50);
      timelineView
          .onSceneEndHandleDragUpdate(TimeSpan.singleFrameDuration * 40);
      expect(timeline.currentScene.frameSeq, sceneA.frameSeq);
      expect(timeline.currentSceneEnd, TimeSpan.singleFrameDuration * 51);

      timeline.jumpTo(
          TimeSpan.singleFrameDuration * 50 + Duration(milliseconds: 1));
      timelineView.onSceneEndHandleDragUpdate(
          timeline.playheadPosition + Duration(milliseconds: 1));
      expect(timeline.currentScene.frameSeq, sceneA.frameSeq);
      expect(timeline.currentSceneEnd, TimeSpan.singleFrameDuration * 51);
    });
  });
}
