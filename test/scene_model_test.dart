import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

void main() {
  group('SceneModel', () {
    test('handles extend last mode', () {
      final scene = Scene(
        layers: [
          SceneLayer(
            Sequence<Frame>([
              Frame(file: File('1.png'), duration: Duration(seconds: 2)),
              Frame(file: File('2.png'), duration: Duration(seconds: 2)),
            ]),
            PlayMode.extendLast,
          ),
        ],
        duration: Duration(seconds: 20),
      );
      expect(scene.imageFilesAt(Duration(seconds: 1)).first.path, '1.png');
      expect(scene.imageFilesAt(Duration(seconds: 4)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 5)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 10)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 20)).first.path, '2.png');
    });

    test('handles loop mode', () {
      final scene = Scene(
        layers: [
          SceneLayer(
            Sequence<Frame>([
              Frame(file: File('1.png'), duration: Duration(seconds: 2)),
              Frame(file: File('2.png'), duration: Duration(seconds: 2)),
            ]),
            PlayMode.loop,
          ),
        ],
        duration: Duration(seconds: 20),
      );
      expect(scene.imageFilesAt(Duration(seconds: 1)).first.path, '1.png');
      expect(scene.imageFilesAt(Duration(seconds: 2)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 3)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 4)).first.path, '1.png');
      expect(scene.imageFilesAt(Duration(seconds: 5)).first.path, '1.png');
      expect(scene.imageFilesAt(Duration(seconds: 6)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 7)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 8)).first.path, '1.png');
      expect(scene.imageFilesAt(Duration(seconds: 10)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 20)).first.path, '1.png');
    });

    test('handles ping-pong mode', () {
      final scene = Scene(
        layers: [
          SceneLayer(
            Sequence<Frame>([
              Frame(file: File('1.png'), duration: Duration(seconds: 1)),
              Frame(file: File('2.png'), duration: Duration(seconds: 1)),
              Frame(file: File('3.png'), duration: Duration(seconds: 1)),
            ]),
            PlayMode.pingPong,
          ),
        ],
        duration: Duration(seconds: 16),
      );
      expect(scene.imageFilesAt(Duration(seconds: 0)).first.path, '1.png');
      expect(scene.imageFilesAt(Duration(seconds: 1)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 2)).first.path, '3.png');
      expect(scene.imageFilesAt(Duration(seconds: 3)).first.path, '3.png');
      expect(scene.imageFilesAt(Duration(seconds: 4)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 5)).first.path, '1.png');
      expect(scene.imageFilesAt(Duration(seconds: 6)).first.path, '1.png');
      expect(scene.imageFilesAt(Duration(seconds: 7)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 8)).first.path, '3.png');
      expect(scene.imageFilesAt(Duration(seconds: 9)).first.path, '3.png');
      expect(scene.imageFilesAt(Duration(seconds: 10)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 11)).first.path, '1.png');
      expect(scene.imageFilesAt(Duration(seconds: 12)).first.path, '1.png');
      expect(scene.imageFilesAt(Duration(seconds: 13)).first.path, '2.png');
      expect(scene.imageFilesAt(Duration(seconds: 14)).first.path, '3.png');
      expect(scene.imageFilesAt(Duration(seconds: 15)).first.path, '3.png');
      expect(scene.imageFilesAt(Duration(seconds: 16)).first.path, '2.png');
    });

    test('returns correct export frames for extend last mode', () {
      final scene = Scene(
        layers: [
          SceneLayer(
            Sequence<Frame>([
              Frame(file: File('1.png'), duration: Duration(seconds: 1)),
              Frame(file: File('2.png'), duration: Duration(seconds: 2)),
            ]),
            PlayMode.extendLast,
          ),
        ],
        duration: Duration(seconds: 10),
      );
      expect(scene.exportFrames.toList(), [
        Frame(file: File('1.png'), duration: Duration(seconds: 1)),
        Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        Frame(file: File('2.png'), duration: Duration(seconds: 7)),
      ]);
    });

    test('returns correct export frames for loop mode', () {
      final scene = Scene(
        layers: [
          SceneLayer(
            Sequence<Frame>([
              Frame(file: File('1.png'), duration: Duration(seconds: 1)),
              Frame(file: File('2.png'), duration: Duration(seconds: 2)),
            ]),
            PlayMode.loop,
          ),
        ],
        duration: Duration(seconds: 10),
      );
      expect(scene.exportFrames.toList(), [
        Frame(file: File('1.png'), duration: Duration(seconds: 1)),
        Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        Frame(file: File('1.png'), duration: Duration(seconds: 1)),
        Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        Frame(file: File('1.png'), duration: Duration(seconds: 1)),
        Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        Frame(file: File('1.png'), duration: Duration(seconds: 1)),
      ]);
    });

    test('returns correct export frames for ping-pong mode', () {
      final scene = Scene(
        layers: [
          SceneLayer(
            Sequence<Frame>([
              Frame(file: File('1.png'), duration: Duration(seconds: 1)),
              Frame(file: File('2.png'), duration: Duration(seconds: 2)),
              Frame(file: File('3.png'), duration: Duration(seconds: 3)),
            ]),
            PlayMode.pingPong,
          ),
        ],
        duration: Duration(seconds: 24),
      );
      expect(scene.exportFrames.toList(), [
        Frame(file: File('1.png'), duration: Duration(seconds: 1)),
        Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        Frame(file: File('3.png'), duration: Duration(seconds: 3)),
        Frame(file: File('3.png'), duration: Duration(seconds: 3)),
        Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        Frame(file: File('1.png'), duration: Duration(seconds: 1)),
        Frame(file: File('1.png'), duration: Duration(seconds: 1)),
        Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        Frame(file: File('3.png'), duration: Duration(seconds: 3)),
        Frame(file: File('3.png'), duration: Duration(seconds: 3)),
        Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        Frame(file: File('1.png'), duration: Duration(seconds: 1)),
      ]);
    });
  });
}
