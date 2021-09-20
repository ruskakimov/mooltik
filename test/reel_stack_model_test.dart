import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/delete_files_where.dart';

import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/project/layer_group/layer_group_info.dart';
import 'package:mooltik/common/data/project/layer_group/sync_layers.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';

Frame frame() => Frame(
      image: DiskImage(file: File('test.png'), width: 100, height: 100),
    );

SceneLayer layer([int frames = 1, bool groupedWithNext = false]) => SceneLayer(
      Sequence<Frame>([
        for (int i = 0; i < frames; i++) frame(),
      ]),
      PlayMode.extendLast,
      true,
      '',
      groupedWithNext,
    );

List<SceneLayer> layerGroup(int length, [int frames = 1]) => [
      for (int i = 0; i < length - 1; i++) layer(frames, true),
      layer(frames),
    ];

ReelStackModel reelStack(List<SceneLayer> layers) => ReelStackModel(
      scene: Scene(layers: layers),
    );

void main() {
  tearDown(() async {
    await deleteFilesWhere(
      Directory.current,
      (path) => path.endsWith('.png'),
    );
  });

  group('ReelStackModel', () {
    group('addLayerAboveActive', () {
      test('adds to group if inserting between group members', () async {
        final stack = reelStack([
          layer(),
          ...layerGroup(2, 3),
          layer(),
        ]);
        stack.setActiveReelIndex(2);
        await stack.addLayerAboveActive(layer());
        expect(stack.layerGroups, [LayerGroupInfo(1, 3)]);
        expect(isGroupSynced(stack.layerGroupOf(1)), true);
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

    group('onLayerReorder', () {
      test('preserves active group-member layer', () {
        final stack = reelStack([
          ...layerGroup(2),
          layer(),
        ]);
        expect(stack.activeReelIndex, 0);
        stack.onLayerReorder(2, 0);
        expect(stack.activeReelIndex, 1);
      });

      group('maintains the group when', () {
        test('last member is moved into a different position', () {
          final stack = reelStack([
            ...layerGroup(3),
          ]);
          expect(stack.layerGroups, [LayerGroupInfo(0, 2)]);
          stack.onLayerReorder(2, 0);
          expect(stack.layerGroups, [LayerGroupInfo(0, 2)]);
        });

        test('non-last member is moved into the last position', () {
          final stack = reelStack([
            ...layerGroup(3),
          ]);
          expect(stack.layerGroups, [LayerGroupInfo(0, 2)]);
          stack.onLayerReorder(0, 3);
          expect(stack.layerGroups, [LayerGroupInfo(0, 2)]);
        });
      });

      group('breaks the group ties when', () {
        test('non-member is moved between members', () {
          final stack = reelStack([
            layer(),
            ...layerGroup(2),
          ]);
          expect(stack.layerGroups, [LayerGroupInfo(1, 2)]);
          stack.onLayerReorder(0, 2);
          expect(stack.layerGroups, []);
        });

        test('member is moved outside the group', () {
          final stack = reelStack([
            ...layerGroup(3),
            layer(),
            layer(),
          ]);
          stack.onLayerReorder(0, 4);
          expect(stack.layerGroups, [LayerGroupInfo(0, 1)]);
        });

        test('member is moved outside the group of 2', () {
          final stack = reelStack([
            ...layerGroup(2),
            layer(),
          ]);
          stack.onLayerReorder(1, 3);
          expect(stack.layerGroups, []);
        });
      });
    });
  });
}
