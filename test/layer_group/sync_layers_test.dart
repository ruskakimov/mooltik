import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/layer_group/sync_layers.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';

String raw(int testId, String name) {
  final str =
      File('./test/layer_group/data/$testId/$name.json').readAsStringSync();
  return jsonEncode(jsonDecode(str));
}

void main() {
  group('syncLayers', () {
    test('1: does nothing if layers are synced', () {
      final a = raw(1, 'a');
      final b = raw(1, 'b');
      final aL = SceneLayer.fromJson(jsonDecode(a), '');
      final bL = SceneLayer.fromJson(jsonDecode(b), '');
      syncLayers(aL, bL);
      expect(jsonEncode(aL), a);
      expect(jsonEncode(bL), b);
    });
  });
}
