import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/disk_image.dart';
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

  final bgGreen = await pngRead(File('./test/test_images/bg_green.png'));
  final bgRed = await pngRead(File('./test/test_images/bg_red.png'));

  group('Scene', () {
    group('returns correct export frames', () {
      test('for looping animation on static background', () {
        final scene = Scene(
          layers: [
            SceneLayer(
              Sequence([
                Frame(
                  image: DiskImage(
                    file: File('a'),
                    snapshot: imageA,
                  ),
                  duration: Duration(milliseconds: 240),
                ),
                Frame(
                  image: DiskImage(
                    file: File('b'),
                    snapshot: imageB,
                  ),
                  duration: Duration(milliseconds: 240),
                ),
              ]),
              PlayMode.loop,
            ),
            SceneLayer(
              Sequence([
                Frame(
                  image: DiskImage(
                    file: File('bg'),
                    snapshot: bgGreen,
                  ),
                  duration: Duration(seconds: 3),
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
            layers: [imageA, bgGreen],
          ),
          Duration(milliseconds: 240),
        );

        final b = CompositeFrame(
          CompositeImage(
            width: imageB.width,
            height: imageB.height,
            layers: [imageB, bgGreen],
          ),
          Duration(milliseconds: 240),
        );

        expect(
          scene.exportFrames.toList(),
          [
            a,
            b,
            a,
            b,
            a,
            b,
            a,
            b,
            a,
            b,
            a,
            b,
            a.copyWith(duration: Duration(milliseconds: 120)),
          ],
        );
      });

      test('for ping-pong animation on animated background', () {
        final scene = Scene(
          layers: [
            SceneLayer(
              Sequence([
                Frame(
                  image: DiskImage(
                    file: File('a'),
                    snapshot: imageA,
                  ),
                  duration: Duration(milliseconds: 600),
                ),
                Frame(
                  image: DiskImage(
                    file: File('b'),
                    snapshot: imageB,
                  ),
                  duration: Duration(milliseconds: 400),
                ),
                Frame(
                  image: DiskImage(
                    file: File('c'),
                    snapshot: imageC,
                  ),
                  duration: Duration(milliseconds: 200),
                ),
              ]),
              PlayMode.pingPong,
            ),
            SceneLayer(
              Sequence([
                Frame(
                  image: DiskImage(
                    file: File('bg-red'),
                    snapshot: bgRed,
                  ),
                  duration: Duration(seconds: 1),
                ),
                Frame(
                  image: DiskImage(
                    file: File('bg-green'),
                    snapshot: bgGreen,
                  ),
                  duration: Duration(seconds: 1),
                ),
              ]),
              PlayMode.loop,
            ),
          ],
          duration: Duration(seconds: 4),
        );

        CompositeFrame composite(foreground, background, duration) =>
            CompositeFrame(
              CompositeImage(
                width: foreground.width,
                height: foreground.height,
                layers: [foreground, background],
              ),
              duration,
            );

        // Expected result schematic (one letter is 200ms):
        // aaa bb c c bb a aa aaa bb c c b
        // rrr rr g g gg g rr rrr gg g g g

        expect(
          scene.exportFrames.toList(),
          [
            composite(imageA, bgRed, Duration(milliseconds: 600)),
            composite(imageB, bgRed, Duration(milliseconds: 400)),
            composite(imageC, bgGreen, Duration(milliseconds: 200)),
            composite(imageC, bgGreen, Duration(milliseconds: 200)),
            composite(imageB, bgGreen, Duration(milliseconds: 400)),
            composite(imageA, bgGreen, Duration(milliseconds: 200)),
            composite(imageA, bgRed, Duration(milliseconds: 400)),
            composite(imageA, bgRed, Duration(milliseconds: 600)),
            composite(imageB, bgGreen, Duration(milliseconds: 400)),
            composite(imageC, bgGreen, Duration(milliseconds: 200)),
            composite(imageC, bgGreen, Duration(milliseconds: 200)),
            composite(imageB, bgGreen, Duration(milliseconds: 200)),
          ],
        );
      });
    });
  });
}
