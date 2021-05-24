import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/project_save_data.dart';

// To solve the issue of inconsistent directory from where tests are run (https://github.com/flutter/flutter/issues/20907).
File testFile(String filePath) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  return File('$dir/test/$filePath');
}

void main() {
  group('ProjectSaveData should', () {
    test('decode and encode back A', () {
      final rawSaveData = testFile('project_data/a_v1_6.json')
          .readAsStringSync()
          .replaceAll(RegExp(r'\s'), '');

      final data = ProjectSaveData.fromJson(jsonDecode(rawSaveData), '', '');
      expect(jsonEncode(data), rawSaveData);
    });

    test('decode and encode back B', () {
      final rawSaveData = testFile('project_data/b_v1_6.json')
          .readAsStringSync()
          .replaceAll(RegExp(r'\s'), '');

      final data = ProjectSaveData.fromJson(jsonDecode(rawSaveData), '', '');
      expect(jsonEncode(data), rawSaveData);
    });
  });
}
