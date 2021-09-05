import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/project/fps_config.dart';
import 'package:mooltik/common/data/project/layer_group/sync_layers.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

SceneLayer layer(
  List<int> frameCounts, [
  PlayMode playMode = PlayMode.extendLast,
]) {
  return SceneLayer(
    Sequence<Frame>(
      frameCounts
          .map((frameCount) => Frame(
                image: DiskImage(file: File('image.png')),
                duration: singleFrameDuration * frameCount,
              ))
          .toList(),
    ),
    playMode,
  );
}

bool matches(SceneLayer layer, List<int> frameCounts) {
  if (frameCounts.length != layer.frameSeq.length) return false;

  for (int i = 0; i < frameCounts.length; i++) {
    final expectedDuration = singleFrameDuration * frameCounts[i];
    final actualDuration = layer.frameSeq[i].duration;

    if (actualDuration != expectedDuration) return false;
  }

  return true;
}

void main() {
  group('areSynced', () {
    test('returns true if layers are synced', () {
      final a = layer([1, 2, 2, 10]);
      final b = layer([1, 2, 2, 10]);
      expect(areSynced(a, b), true);
    });

    test('returns false if layers are not synced', () {
      final a = layer([1, 2, 2, 10]);
      final b = layer([1, 2, 1, 10]);
      expect(areSynced(a, b), false);
    });
  });

  group('syncLayers', () {
    test('does nothing if layers are synced', () {
      final a = layer([1, 2, 3]);
      final b = layer([1, 2, 3]);
      expect(areSynced(a, b), true, reason: 'Are initially synced');
      syncLayers(a, b);
      expect(areSynced(a, b), true);
    });

    test('appends frames to secondary if primary is longer', () {
      final a = layer([1, 2, 3, 4, 5]);
      final b = layer([1, 2, 3]);
      syncLayers(a, b);
      expect(matches(a, [1, 2, 3, 4, 5]), true);
      expect(matches(b, [1, 2, 3, 4, 5]), true);
      expect(areSynced(a, b), true);
    });
  });
}
