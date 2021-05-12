import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/sava_data_transcoder.dart';

// To solve the issue of inconsistent directory from where tests are run (https://github.com/flutter/flutter/issues/20907).
String testData(String filePath) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  return File('$dir/test/$filePath')
      .readAsStringSync()
      .replaceAll(RegExp(r'\s'), '');
}

void main() {
  group('SaveDataTranscoder should', () {
    test('transcode v0.8 to v0.9', () {
      final transcoder = SaveDataTranscoder();
      final data_v0_8 = testData('project_data/a_v0_8.json');
      final data_v0_9 = testData('project_data/a_v0_9.json');
      final transcodedJson =
          transcoder.convert_v0_8_to_v0_9(jsonDecode(data_v0_8));
      expect(
        jsonEncode(transcodedJson),
        data_v0_9,
      );
    });

    test('transcode v0.9 to v1.0', () {
      final transcoder = SaveDataTranscoder();
      final data_v0_9 = testData('project_data/a_v0_9.json');
      final data_v1_0 = testData('project_data/a_v1_0.json');
      final transcodedJson =
          transcoder.convert_v0_9_to_v1_0(jsonDecode(data_v0_9));
      expect(
        jsonEncode(transcodedJson),
        data_v1_0,
      );
    });
  });
}
