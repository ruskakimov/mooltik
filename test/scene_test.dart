import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/delete_files_where.dart';
import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

void main() async {
  tearDown(() async {
    try {
      await deleteFilesWhere(
        Directory.current,
        (path) => path.endsWith('.png'),
      );
    } catch (e) {
      print(e);
    }
  });

  final imageA = await pngRead(File('./test/test_images/rabbit_black.png'));
  final imageB = await pngRead(File('./test/test_images/rabbit_pink.png'));
  final imageC = await pngRead(File('./test/test_images/rabbit_yellow.png'));

  final bgGreen = await pngRead(File('./test/test_images/bg_green.png'));
  final bgRed = await pngRead(File('./test/test_images/bg_red.png'));

  final a = DiskImage.loaded(
    file: File('a.png'),
    snapshot: imageA,
  );

  final b = DiskImage.loaded(
    file: File('b.png'),
    snapshot: imageB,
  );

  final c = DiskImage.loaded(
    file: File('c.png'),
    snapshot: imageC,
  );

  final green = DiskImage.loaded(
    file: File('bg-green.png'),
    snapshot: bgGreen,
  );

  final red = DiskImage.loaded(
    file: File('bg-red.png'),
    snapshot: bgRed,
  );

  group('Scene', () {
    group('returns correct export frames', () {
      test('for looping animation on static background', () {
        final scene = Scene(
          layers: [
            SceneLayer(
              Sequence([
                Frame(image: a, duration: Duration(milliseconds: 240)),
                Frame(image: b, duration: Duration(milliseconds: 240)),
              ]),
              PlayMode.loop,
            ),
            SceneLayer(
              Sequence([
                Frame(image: green, duration: Duration(seconds: 3)),
              ]),
              PlayMode.extendLast,
            ),
          ],
          duration: Duration(seconds: 3),
        );

        final aOnGreen = CompositeFrame(
          CompositeImage([a, green]),
          Duration(milliseconds: 240),
        );

        final bOnGreen = CompositeFrame(
          CompositeImage([b, green]),
          Duration(milliseconds: 240),
        );

        expect(
          scene.getExportFrames().toList(),
          [
            aOnGreen,
            bOnGreen,
            aOnGreen,
            bOnGreen,
            aOnGreen,
            bOnGreen,
            aOnGreen,
            bOnGreen,
            aOnGreen,
            bOnGreen,
            aOnGreen,
            bOnGreen,
            aOnGreen.copyWith(duration: Duration(milliseconds: 120)),
          ],
        );
      });

      test('for ping-pong animation on animated background', () {
        final scene = Scene(
          layers: [
            SceneLayer(
              Sequence([
                Frame(image: a, duration: Duration(milliseconds: 600)),
                Frame(image: b, duration: Duration(milliseconds: 400)),
                Frame(image: c, duration: Duration(milliseconds: 200)),
              ]),
              PlayMode.pingPong,
            ),
            SceneLayer(
              Sequence([
                Frame(image: red, duration: Duration(seconds: 1)),
                Frame(image: green, duration: Duration(seconds: 1)),
              ]),
              PlayMode.loop,
            ),
          ],
          duration: Duration(seconds: 4),
        );

        CompositeFrame composite(foreground, background, duration) =>
            CompositeFrame(
              CompositeImage([foreground, background]),
              duration,
            );

        // Expected result schematic (one letter is 200ms):
        // aaa bb c c bb a aa aaa bb c c b
        // rrr rr g g gg g rr rrr gg g g g

        expect(
          scene.getExportFrames().toList(),
          [
            composite(a, red, Duration(milliseconds: 600)),
            composite(b, red, Duration(milliseconds: 400)),
            composite(c, green, Duration(milliseconds: 200)),
            composite(c, green, Duration(milliseconds: 200)),
            composite(b, green, Duration(milliseconds: 400)),
            composite(a, green, Duration(milliseconds: 200)),
            composite(a, red, Duration(milliseconds: 400)),
            composite(a, red, Duration(milliseconds: 600)),
            composite(b, green, Duration(milliseconds: 400)),
            composite(c, green, Duration(milliseconds: 200)),
            composite(c, green, Duration(milliseconds: 200)),
            composite(b, green, Duration(milliseconds: 200)),
          ],
        );
      });
    });
  });
}
