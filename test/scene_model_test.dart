import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/scene_model.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

void main() {
  group('SceneModel', () {
    test('handles extend last mode', () {
      final scene = SceneModel(
        frames: [
          FrameModel(file: File('1.png'), duration: Duration(seconds: 2)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        ],
        duration: Duration(seconds: 20),
        playMode: PlayMode.extendLast,
      );
      expect(scene.frameAt(Duration(seconds: 1)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 4)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 5)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 10)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 20)).file.path, '2.png');
    });
  });
}
