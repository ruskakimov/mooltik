import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/extensions/duration_methods.dart';
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
                image: DiskImage(
                  file: File('image.png'),
                  width: 800,
                  height: 600,
                ),
                duration: singleFrameDuration * frameCount,
              ))
          .toList(),
    ),
    playMode,
  );
}

List<int> frameCounts(SceneLayer layer) {
  return layer.frameSeq.iterable.map((frame) {
    final count = frame.duration / singleFrameDuration;
    if (count % 1 == 0) return count.toInt();
    return -1;
  }).toList();
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
    test('does nothing if layers are synced', () async {
      final a = layer([1, 2, 3]);
      final b = layer([1, 2, 3]);
      expect(areSynced(a, b), true, reason: 'Are initially synced');
      await syncLayers(a, b);
      expect(areSynced(a, b), true);
    });

    test('syncs to A if A is longer', () async {
      final a = layer([1, 2, 3, 4, 5]);
      final b = layer([2, 2]);
      await syncLayers(a, b);
      expect(frameCounts(a), [1, 2, 3, 4, 5]);
      expect(frameCounts(b), [1, 2, 3, 4, 5]);
      expect(areSynced(a, b), true);
    });

    test('syncs to B if B is longer', () async {
      final a = layer([3, 4, 4]);
      final b = layer([2, 2, 2, 2, 2, 2, 2]);
      await syncLayers(a, b);
      expect(frameCounts(a), [2, 2, 2, 2, 2, 2, 2]);
      expect(frameCounts(b), [2, 2, 2, 2, 2, 2, 2]);
      expect(areSynced(a, b), true);
    });

    test('syncs to A if both have equal frame count', () async {
      final a = layer([1, 2, 3]);
      final b = layer([1, 1, 1]);
      await syncLayers(a, b);
      expect(frameCounts(a), [1, 2, 3]);
      expect(frameCounts(b), [1, 2, 3]);
      expect(areSynced(a, b), true);
    });

    test('uses playmode of A if A is longer', () async {
      final a = layer([1, 1, 1, 1, 1], PlayMode.pingPong);
      final b = layer([4]);
      await syncLayers(a, b);
      expect(a.playMode, PlayMode.pingPong);
      expect(b.playMode, PlayMode.pingPong);
      expect(areSynced(a, b), true);
    });

    test('uses playmode of B if B is longer', () async {
      final a = layer([4]);
      final b = layer([1, 1, 1, 1, 1], PlayMode.pingPong);
      await syncLayers(a, b);
      expect(a.playMode, PlayMode.pingPong);
      expect(b.playMode, PlayMode.pingPong);
      expect(areSynced(a, b), true);
    });

    test('uses playmode of A if both have equal frame count', () async {
      final a = layer([1, 2, 3], PlayMode.loop);
      final b = layer([1, 1, 1], PlayMode.pingPong);
      await syncLayers(a, b);
      expect(a.playMode, PlayMode.loop);
      expect(b.playMode, PlayMode.loop);
      expect(areSynced(a, b), true);
    });

    test('appends fully-transparent frames', () async {
      final a = layer([1, 1]);
      final b = layer([1]);
      await syncLayers(a, b);
      final appendedSnapshot = b.frameSeq.last.image.snapshot;
      expect(appendedSnapshot, isNotNull);
      final byteData = await appendedSnapshot!.toByteData();
      expect(
        byteData!.buffer.asUint8List().every((byte) => byte == 0),
        true,
      );
    });
  });
}
