import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/disk_image.dart';
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
            image: DiskImage.loaded(file: File('1.png'), snapshot: imageA),
            duration: Duration(seconds: 2),
          ),
          Frame(
            image: DiskImage.loaded(file: File('2.png'), snapshot: imageB),
            duration: Duration(seconds: 2),
          ),
        ]),
        PlayMode.extendLast,
      );
      expect(sceneLayer.frameAt(Duration(seconds: 1)).image.snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 4)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 5)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 10)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 20)).image.snapshot, imageB);
    });

    test('handles loop mode', () {
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(
            image: DiskImage.loaded(file: File('1.png'), snapshot: imageA),
            duration: Duration(seconds: 2),
          ),
          Frame(
            image: DiskImage.loaded(file: File('2.png'), snapshot: imageB),
            duration: Duration(seconds: 2),
          ),
        ]),
        PlayMode.loop,
      );
      expect(sceneLayer.frameAt(Duration(seconds: 1)).image.snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 2)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 3)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 4)).image.snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 5)).image.snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 6)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 7)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 8)).image.snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 10)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 20)).image.snapshot, imageA);
    });

    test('handles ping-pong mode', () {
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(
            image: DiskImage.loaded(file: File('1.png'), snapshot: imageA),
            duration: Duration(seconds: 1),
          ),
          Frame(
            image: DiskImage.loaded(file: File('2.png'), snapshot: imageB),
            duration: Duration(seconds: 1),
          ),
          Frame(
            image: DiskImage.loaded(file: File('3.png'), snapshot: imageC),
            duration: Duration(seconds: 1),
          ),
        ]),
        PlayMode.pingPong,
      );

      expect(sceneLayer.frameAt(Duration(seconds: 0)).image.snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 1)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 2)).image.snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 3)).image.snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 4)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 5)).image.snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 6)).image.snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 7)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 8)).image.snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 9)).image.snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 10)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 11)).image.snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 12)).image.snapshot, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 13)).image.snapshot, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 14)).image.snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 15)).image.snapshot, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 16)).image.snapshot, imageB);
    });

    group('returns correct export frames', () {
      test('for extend last mode', () {
        final sceneLayer = SceneLayer(
          Sequence<Frame>([
            Frame(
              image: DiskImage(width: 100, height: 100, file: File('1.png')),
              duration: Duration(seconds: 1),
            ),
            Frame(
              image: DiskImage(width: 100, height: 100, file: File('2.png')),
              duration: Duration(seconds: 2),
            ),
          ]),
          PlayMode.extendLast,
        );
        final duration = Duration(seconds: 10);
        expect(sceneLayer.getFrames(duration).toList(), [
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('1.png')),
            duration: Duration(seconds: 1),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('2.png')),
            duration: Duration(seconds: 2),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('2.png')),
            duration: Duration(seconds: 7),
          ),
        ]);
      });

      test('for loop mode', () {
        final sceneLayer = SceneLayer(
          Sequence<Frame>([
            Frame(
              image: DiskImage(width: 100, height: 100, file: File('1.png')),
              duration: Duration(seconds: 1),
            ),
            Frame(
              image: DiskImage(width: 100, height: 100, file: File('2.png')),
              duration: Duration(seconds: 2),
            ),
          ]),
          PlayMode.loop,
        );
        final duration = Duration(seconds: 10);
        expect(sceneLayer.getFrames(duration).toList(), [
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('1.png')),
            duration: Duration(seconds: 1),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('2.png')),
            duration: Duration(seconds: 2),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('1.png')),
            duration: Duration(seconds: 1),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('2.png')),
            duration: Duration(seconds: 2),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('1.png')),
            duration: Duration(seconds: 1),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('2.png')),
            duration: Duration(seconds: 2),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('1.png')),
            duration: Duration(seconds: 1),
          ),
        ]);
      });

      test('for ping-pong mode', () {
        final sceneLayer = SceneLayer(
          Sequence<Frame>([
            Frame(
              image: DiskImage(width: 100, height: 100, file: File('1.png')),
              duration: Duration(seconds: 1),
            ),
            Frame(
              image: DiskImage(width: 100, height: 100, file: File('2.png')),
              duration: Duration(seconds: 2),
            ),
            Frame(
              image: DiskImage(width: 100, height: 100, file: File('3.png')),
              duration: Duration(seconds: 3),
            ),
          ]),
          PlayMode.pingPong,
        );
        final duration = Duration(seconds: 24);
        expect(sceneLayer.getFrames(duration).toList(), [
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('1.png')),
            duration: Duration(seconds: 1),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('2.png')),
            duration: Duration(seconds: 2),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('3.png')),
            duration: Duration(seconds: 3),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('3.png')),
            duration: Duration(seconds: 3),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('2.png')),
            duration: Duration(seconds: 2),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('1.png')),
            duration: Duration(seconds: 1),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('1.png')),
            duration: Duration(seconds: 1),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('2.png')),
            duration: Duration(seconds: 2),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('3.png')),
            duration: Duration(seconds: 3),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('3.png')),
            duration: Duration(seconds: 3),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('2.png')),
            duration: Duration(seconds: 2),
          ),
          Frame(
            image: DiskImage(width: 100, height: 100, file: File('1.png')),
            duration: Duration(seconds: 1),
          ),
        ]);
      });
    });
  });
}
