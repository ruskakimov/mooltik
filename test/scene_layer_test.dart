import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

void main() {
  group('SceneLayer', () {
    test('returns correct export frames for extend last mode', () {
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(file: File('1.png'), duration: Duration(seconds: 1)),
          Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        PlayMode.extendLast,
      );
      final duration = Duration(seconds: 10);
      expect(sceneLayer.getExportFrames(duration).toList(), [
        Frame(file: File('1.png'), duration: Duration(seconds: 1)),
        Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        Frame(file: File('2.png'), duration: Duration(seconds: 7)),
      ]);
    });

    test('returns correct export frames for loop mode', () {
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(file: File('1.png'), duration: Duration(seconds: 1)),
          Frame(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        PlayMode.loop,
      );
      final duration = Duration(seconds: 10);
      expect(sceneLayer.getExportFrames(duration).toList(), [
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
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(file: File('1.png'), duration: Duration(seconds: 1)),
          Frame(file: File('2.png'), duration: Duration(seconds: 2)),
          Frame(file: File('3.png'), duration: Duration(seconds: 3)),
        ]),
        PlayMode.pingPong,
      );
      final duration = Duration(seconds: 24);
      expect(sceneLayer.getExportFrames(duration).toList(), [
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
