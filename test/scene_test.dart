import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

void main() async {
  final imageA = await pngRead(File('./test/test_images/rabbit_black.png'));
  final imageB = await pngRead(File('./test/test_images/rabbit_pink.png'));
  final imageC = await pngRead(File('./test/test_images/rabbit_yellow.png'));

  group('Scene', () {
    group('returns correct export frames', () {
      test('for looping animation on static background', () {
        final scene = Scene(
          layers: [
            SceneLayer(
              Sequence([
                Frame(
                  file: File('a'),
                  snapshot: imageA,
                  duration: Duration(milliseconds: 250),
                ),
                Frame(
                  file: File('b'),
                  snapshot: imageB,
                  duration: Duration(milliseconds: 250),
                ),
              ]),
              PlayMode.loop,
            ),
            SceneLayer(
              Sequence([
                Frame(
                  file: File('bg'),
                  snapshot: imageC,
                ),
              ]),
              PlayMode.extendLast,
            ),
          ],
          duration: Duration(seconds: 3),
        );

        final a = CompositeFrame(
          CompositeImage(
            width: imageA.width,
            height: imageA.height,
            layers: [imageA, imageC],
          ),
          Duration(milliseconds: 250),
        );

        final b = CompositeFrame(
          CompositeImage(
            width: imageB.width,
            height: imageB.height,
            layers: [imageB, imageC],
          ),
          Duration(milliseconds: 250),
        );

        expect(
          scene.exportFrames.toList(),
          [a, b, a, b, a, b, a, b, a, b, a, b],
        );
      });
    });
  });
}
