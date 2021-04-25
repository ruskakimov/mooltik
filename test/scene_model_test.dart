import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/scene_model.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

void main() {
  group('SceneModel', () {
    test('handles extend last mode', () {
      final scene = SceneModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 2)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        duration: Duration(seconds: 20),
        playMode: PlayMode.extendLast,
      );
      expect(scene.frameAt(Duration(seconds: 1)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 4)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 5)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 10)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 20)).file.path, '2.png');
    });

    test('handles loop mode', () {
      final scene = SceneModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 2)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        duration: Duration(seconds: 20),
        playMode: PlayMode.loop,
      );
      expect(scene.frameAt(Duration(seconds: 1)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 2)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 3)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 4)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 5)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 6)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 7)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 8)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 10)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 20)).file.path, '1.png');
    });

    test('handles ping-pong mode', () {
      final scene = SceneModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 1)),
          FrameModel(file: File('3.png'), duration: Duration(seconds: 1)),
        ]),
        duration: Duration(seconds: 16),
        playMode: PlayMode.pingPong,
      );
      expect(scene.frameAt(Duration(seconds: 0)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 1)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 2)).file.path, '3.png');
      expect(scene.frameAt(Duration(seconds: 3)).file.path, '3.png');
      expect(scene.frameAt(Duration(seconds: 4)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 5)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 6)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 7)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 8)).file.path, '3.png');
      expect(scene.frameAt(Duration(seconds: 9)).file.path, '3.png');
      expect(scene.frameAt(Duration(seconds: 10)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 11)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 12)).file.path, '1.png');
      expect(scene.frameAt(Duration(seconds: 13)).file.path, '2.png');
      expect(scene.frameAt(Duration(seconds: 14)).file.path, '3.png');
      expect(scene.frameAt(Duration(seconds: 15)).file.path, '3.png');
      expect(scene.frameAt(Duration(seconds: 16)).file.path, '2.png');
    });

    test('returns correct export frames for extend last mode', () {
      final scene = SceneModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        duration: Duration(seconds: 10),
        playMode: PlayMode.extendLast,
      );
      expect(scene.exportFrames.toList(), [
        FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
        FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        FrameModel(file: File('2.png'), duration: Duration(seconds: 7)),
      ]);
    });

    test('returns correct export frames for loop mode', () {
      final scene = SceneModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        duration: Duration(seconds: 10),
        playMode: PlayMode.loop,
      );
      expect(scene.exportFrames.toList(), [
        FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
        FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
        FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
        FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
      ]);
    });

    test('returns correct export frames for ping-pong mode', () {
      final scene = SceneModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
          FrameModel(file: File('3.png'), duration: Duration(seconds: 3)),
        ]),
        duration: Duration(seconds: 24),
        playMode: PlayMode.pingPong,
      );
      expect(scene.exportFrames.toList(), [
        FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
        FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        FrameModel(file: File('3.png'), duration: Duration(seconds: 3)),
        FrameModel(file: File('3.png'), duration: Duration(seconds: 3)),
        FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
        FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
        FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        FrameModel(file: File('3.png'), duration: Duration(seconds: 3)),
        FrameModel(file: File('3.png'), duration: Duration(seconds: 3)),
        FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
      ]);
    });
  });
}
