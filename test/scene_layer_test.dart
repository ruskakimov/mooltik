import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

void main() async {
  final imageA = await pngRead(File('./test/test_images/rabbit_black.png'));
  final imageB = await pngRead(File('./test/test_images/rabbit_pink.png'));
  final imageC = await pngRead(File('./test/test_images/rabbit_yellow.png'));

  group('SceneLayer', () {
    test('handles extend last mode', () {
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(
            file: File('1.png'),
            snapshot: imageA,
            duration: Duration(seconds: 2),
          ),
          Frame(
            file: File('2.png'),
            snapshot: imageB,
            duration: Duration(seconds: 2),
          ),
        ]),
        PlayMode.extendLast,
      );
      expect(sceneLayer.frameAt(Duration(seconds: 1)).snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 4)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 5)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 10)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 20)).snapshot, imageB);
    });

    test('handles loop mode', () {
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(
            file: File('1.png'),
            snapshot: imageA,
            duration: Duration(seconds: 2),
          ),
          Frame(
            file: File('2.png'),
            snapshot: imageB,
            duration: Duration(seconds: 2),
          ),
        ]),
        PlayMode.loop,
      );
      expect(sceneLayer.frameAt(Duration(seconds: 1)).snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 2)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 3)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 4)).snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 5)).snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 6)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 7)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 8)).snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 10)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 20)).snapshot, imageA);
    });

    test('handles ping-pong mode', () {
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(
            file: File('1.png'),
            snapshot: imageA,
            duration: Duration(seconds: 1),
          ),
          Frame(
            file: File('2.png'),
            snapshot: imageB,
            duration: Duration(seconds: 1),
          ),
          Frame(
            file: File('3.png'),
            snapshot: imageC,
            duration: Duration(seconds: 1),
          ),
        ]),
        PlayMode.pingPong,
      );

      expect(sceneLayer.frameAt(Duration(seconds: 0)).snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 1)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 2)).snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 3)).snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 4)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 5)).snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 6)).snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 7)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 8)).snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 9)).snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 10)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 11)).snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 12)).snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 13)).snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 14)).snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 15)).snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 16)).snapshot, imageB);
    });

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
