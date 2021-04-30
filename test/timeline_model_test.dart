import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/editing/data/timeline_model.dart';

void main() {
  group('TimelineModel', () {
    test('starts with first frame selected', () {
      final sceneA = Scene(
        frameSeq: Sequence<Frame>([
          Frame(file: File('1.png'), duration: Duration(seconds: 2)),
          Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        duration: Duration(seconds: 4),
      );
      final timeline = TimelineModel(
        sceneSeq: Sequence<Scene>([sceneA]),
        vsync: TestVSync(),
      );
      expect(timeline.currentFrame.file.path, '1.png');
    });

    test('scrubbing updates current frame', () {
      final sceneA = Scene(
        frameSeq: Sequence<Frame>([
          Frame(file: File('1.png'), duration: Duration(seconds: 2)),
          Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        duration: Duration(seconds: 4),
      );
      final timeline = TimelineModel(
        sceneSeq: Sequence<Scene>([sceneA]),
        vsync: TestVSync(),
      );
      timeline.scrub(Duration(seconds: 2));
      expect(timeline.currentFrame.file.path, '2.png');
      timeline.scrub(Duration(milliseconds: -1));
      expect(timeline.currentFrame.file.path, '1.png');
    });
  });
}
