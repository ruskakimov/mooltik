import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/project/fps_config.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/editing/data/timeline/timeline_model.dart';
import 'package:mooltik/editing/data/timeline/timeline_view_model.dart';

void main() {
  group('TimelineViewModel', () {
    test('does not resize scene past playhead in scene mode', () {
      final sceneA = Scene(
        layers: [
          SceneLayer(
            Sequence<Frame>([
              Frame(
                image: DiskImage(width: 10, height: 10, file: File('1.png')),
                duration: Duration(seconds: 2),
              ),
              Frame(
                image: DiskImage(width: 10, height: 10, file: File('2.png')),
                duration: Duration(seconds: 2),
              ),
            ]),
          ),
        ],
        duration: Duration(seconds: 4),
      );

      final sceneB = Scene(
        layers: [
          SceneLayer(
            Sequence<Frame>([
              Frame(
                image: DiskImage(width: 10, height: 10, file: File('3.png')),
                duration: Duration(seconds: 1),
              ),
              Frame(
                image: DiskImage(width: 10, height: 10, file: File('4.png')),
                duration: Duration(seconds: 1),
              ),
            ]),
          ),
        ],
        duration: Duration(seconds: 9),
      );

      final timeline = TimelineModel(
        sceneSeq: Sequence<Scene>([sceneA, sceneB]),
        vsync: TestVSync(),
      );

      final timelineView = TimelineViewModel(
        timeline: timeline,
        soundClips: [],
        sharedPreferences: null,
      );

      timelineView.selectSliver(SliverCoord(0, 0));
      timelineView.editScene();

      timeline.jumpTo(singleFrameDuration * 50);
      timelineView.onSceneEndHandleDragUpdate(singleFrameDuration * 40);
      expect(timeline.currentScene.toString(), sceneA.toString());
      expect(timeline.currentSceneEnd, singleFrameDuration * 51);

      timeline.jumpTo(singleFrameDuration * 50 + Duration(milliseconds: 1));
      timelineView.onSceneEndHandleDragUpdate(
          timeline.playheadPosition + Duration(milliseconds: 1));
      expect(timeline.currentScene.toString(), sceneA.toString());
      expect(timeline.currentSceneEnd, singleFrameDuration * 51);
    });
  });
}
