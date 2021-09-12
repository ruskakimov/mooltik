import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';

void main() {
  group('ReelStackModel', () {
    group('deleteLayer', () {
      test('retains active layer when it is part of a group', () {
        final b = SceneLayer(
            Sequence<Frame>([]), PlayMode.extendLast, true, '', true);
        final stack = ReelStackModel(
          createNewFrame: () async => Frame(
            image: DiskImage(
              file: File('img.png'),
              width: 100,
              height: 100,
            ),
          ),
          scene: Scene(
            layers: [
              SceneLayer(Sequence<Frame>([])),
              b,
              SceneLayer(Sequence<Frame>([])),
            ],
          ),
        );

        stack.changeActiveReel(stack.reels[1]);
        stack.deleteLayer(0);

        expect(stack.activeReel.frameSeq, b.frameSeq);
      });
    });
  });
}
