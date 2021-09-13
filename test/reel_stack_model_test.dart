import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/project/layer_group/layer_group_info.dart';
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
    group('addLayerAboveActive', () {
      test('adds to group if inserting between group members', () {
        final stack = reelStack([
          layer(),
          ...layerGroup(2),
          layer(),
        ]);
        stack.setActiveReelIndex(2);
        stack.addLayerAboveActive(layer());
        expect(stack.layerGroups, [LayerGroupInfo(1, 3)]);
      });
    });

    group('deleteLayer', () {
      test('retains active layer when deleted before', () {
        final stack = reelStack([
          layer(),
          layer(),
          layer(),
        ]);
        stack.setActiveReelIndex(1);
        stack.deleteLayer(0);
        expect(stack.activeReelIndex, 0);
      });

      test('retains active layer when deleted after', () {
        final stack = reelStack([
          layer(),
          layer(),
          layer(),
        ]);
        stack.setActiveReelIndex(1);
        stack.deleteLayer(2);
        expect(stack.activeReelIndex, 1);
      });

      test('makes next layer active when active is deleted', () {
        final stack = reelStack([
          layer(),
          layer(),
          layer(),
        ]);
        stack.setActiveReelIndex(1);
        stack.deleteLayer(1);
        expect(stack.activeReelIndex, 1);
      });

      test('makes last layer active when active is deleted and is last', () {
        final stack = reelStack([
          layer(),
          layer(),
          layer(),
        ]);
        stack.setActiveReelIndex(2);
        stack.deleteLayer(2);
        expect(stack.activeReelIndex, 1);
      });

      test('retains active layer when it is part of a group', () {
        final stack = reelStack([
          layer(),
          ...layerGroup(2),
        ]);
        stack.setActiveReelIndex(1);
        stack.deleteLayer(0);
        expect(stack.activeReelIndex, 0);
      });

      test('dissolves group of 2 when first is removed', () {
        final stack = reelStack([
          ...layerGroup(2),
          layer(),
        ]);
        stack.deleteLayer(0);
        expect(stack.layerGroups, []);
      });

      test('dissolves group of 2 when second is removed', () {
        final stack = reelStack([
          ...layerGroup(2),
          layer(),
        ]);
        stack.deleteLayer(1);
        expect(stack.layerGroups, []);
      });

      test('keeps group when middle is removed', () {
        final stack = reelStack([
          ...layerGroup(3),
        ]);
        stack.deleteLayer(1);
        expect(stack.layerGroups, [LayerGroupInfo(0, 1)]);
      });

      test('shortens the group when last is removed', () {
        final stack = reelStack([
          ...layerGroup(3),
          layer(),
        ]);
        stack.deleteLayer(2);
        expect(stack.layerGroups, [LayerGroupInfo(0, 1)]);
      });
    });
  });
}
