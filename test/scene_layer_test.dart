import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/delete_files_where.dart';
import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

void main() async {
  tearDown(() async {
    await deleteFilesWhere(
      Directory.current,
      (path) => path.endsWith('.png'),
    );
  });

  final snapshotA = await pngRead(File('./test/test_images/rabbit_black.png'));
  final snapshotB = await pngRead(File('./test/test_images/rabbit_pink.png'));
  final snapshotC = await pngRead(File('./test/test_images/rabbit_yellow.png'));

  final imageA = DiskImage.loaded(file: File('a.png'), snapshot: snapshotA);
  final imageB = DiskImage.loaded(file: File('b.png'), snapshot: snapshotB);
  final imageC = DiskImage.loaded(file: File('c.png'), snapshot: snapshotC);

  group('SceneLayer', () {
    test('handles extend last mode', () {
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(image: imageA, duration: Duration(seconds: 2)),
          Frame(image: imageB, duration: Duration(seconds: 2)),
        ]),
        PlayMode.extendLast,
      );
      expect(sceneLayer.frameAt(Duration(seconds: 1)).image, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 4)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 5)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 10)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 20)).image, imageB);
    });

    test('handles loop mode', () {
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(image: imageA, duration: Duration(seconds: 2)),
          Frame(image: imageB, duration: Duration(seconds: 2)),
        ]),
        PlayMode.loop,
      );
      expect(sceneLayer.frameAt(Duration(seconds: 1)).image, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 2)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 3)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 4)).image, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 5)).image, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 6)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 7)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 8)).image, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 10)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 20)).image, imageA);
    });

    test('handles ping-pong mode', () {
      final sceneLayer = SceneLayer(
        Sequence<Frame>([
          Frame(image: imageA, duration: Duration(seconds: 1)),
          Frame(image: imageB, duration: Duration(seconds: 1)),
          Frame(image: imageC, duration: Duration(seconds: 1)),
        ]),
        PlayMode.pingPong,
      );

      expect(sceneLayer.frameAt(Duration(seconds: 0)).image, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 1)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 2)).image, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 3)).image, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 4)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 5)).image, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 6)).image, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 7)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 8)).image, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 9)).image, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 10)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 11)).image, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 12)).image, imageA);
      expect(sceneLayer.frameAt(Duration(seconds: 13)).image, imageB);
      expect(sceneLayer.frameAt(Duration(seconds: 14)).image, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 15)).image, imageC);
      expect(sceneLayer.frameAt(Duration(seconds: 16)).image, imageB);
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
        expect(sceneLayer.getPlayFrames(duration).toList(), [
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
        expect(sceneLayer.getPlayFrames(duration).toList(), [
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
        expect(sceneLayer.getPlayFrames(duration).toList(), [
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
