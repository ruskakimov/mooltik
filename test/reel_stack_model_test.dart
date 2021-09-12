import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';

SceneLayer layer() => SceneLayer(Sequence<Frame>([]));

List<SceneLayer> layerGroup(int length) => [
      for (int i = 0; i < length - 1; i++)
        SceneLayer(Sequence<Frame>([]), PlayMode.extendLast, true, '', true),
      layer(),
    ];

ReelStackModel reelStack(List<SceneLayer> layers) => ReelStackModel(
      createNewFrame: () async => Frame(
        image: DiskImage(file: File(''), width: 100, height: 100),
      ),
      scene: Scene(layers: layers),
    );

void main() {
  group('ReelStackModel', () {
    group('deleteLayer', () {
      test('retains active layer when it is part of a group', () {
        final stack = reelStack([
          layer(),
          ...layerGroup(2),
        ]);

        stack.changeActiveReel(stack.reels[1]);
        expect(stack.activeReelIndex, 1);

        stack.deleteLayer(0);
        expect(stack.activeReelIndex, 0);
      });
    });
  });
}
