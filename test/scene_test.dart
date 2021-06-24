import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

void main() async {
  final imageA = await pngRead(File('./test/test_images/rabbit_black.png'));
  final imageB = await pngRead(File('./test/test_images/rabbit_pink.png'));
  final imageC = await pngRead(File('./test/test_images/rabbit_yellow.png'));

  group('Scene', () {
    test('handles extend last mode', () {
      final scene = Scene(
        layers: [
          SceneLayer(
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
          ),
        ],
        duration: Duration(seconds: 20),
      );
      expect(scene.imageAt(Duration(seconds: 1)).layers, [imageA]);
      expect(scene.imageAt(Duration(seconds: 4)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 5)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 10)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 20)).layers, [imageB]);
    });

    test('handles loop mode', () {
      final scene = Scene(
        layers: [
          SceneLayer(
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
          ),
        ],
        duration: Duration(seconds: 20),
      );
      expect(scene.imageAt(Duration(seconds: 1)).layers, [imageA]);
      expect(scene.imageAt(Duration(seconds: 2)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 3)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 4)).layers, [imageA]);
      expect(scene.imageAt(Duration(seconds: 5)).layers, [imageA]);
      expect(scene.imageAt(Duration(seconds: 6)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 7)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 8)).layers, [imageA]);
      expect(scene.imageAt(Duration(seconds: 10)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 20)).layers, [imageA]);
    });

    test('handles ping-pong mode', () {
      final scene = Scene(
        layers: [
          SceneLayer(
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
          ),
        ],
        duration: Duration(seconds: 16),
      );

      expect(scene.imageAt(Duration(seconds: 0)).layers, [imageA]);
      expect(scene.imageAt(Duration(seconds: 1)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 2)).layers, [imageC]);
      expect(scene.imageAt(Duration(seconds: 3)).layers, [imageC]);
      expect(scene.imageAt(Duration(seconds: 4)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 5)).layers, [imageA]);
      expect(scene.imageAt(Duration(seconds: 6)).layers, [imageA]);
      expect(scene.imageAt(Duration(seconds: 7)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 8)).layers, [imageC]);
      expect(scene.imageAt(Duration(seconds: 9)).layers, [imageC]);
      expect(scene.imageAt(Duration(seconds: 10)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 11)).layers, [imageA]);
      expect(scene.imageAt(Duration(seconds: 12)).layers, [imageA]);
      expect(scene.imageAt(Duration(seconds: 13)).layers, [imageB]);
      expect(scene.imageAt(Duration(seconds: 14)).layers, [imageC]);
      expect(scene.imageAt(Duration(seconds: 15)).layers, [imageC]);
      expect(scene.imageAt(Duration(seconds: 16)).layers, [imageB]);
    });
  });
}
