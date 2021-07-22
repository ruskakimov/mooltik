import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/project_save_data.dart';

void main() {
  group('ProjectSaveData should', () {
    test('decode and encode back A', () {
      final rawSaveData = File('./test/project_data/a_v1_13.json')
          .readAsStringSync()
          .replaceAll(RegExp(r'\s'), '');

      final data = ProjectSaveData.fromJson(jsonDecode(rawSaveData), '', '');
      expect(jsonEncode(data), rawSaveData);
    });

    test('decode and encode back B', () {
      final rawSaveData = File('./test/project_data/b_v1_13.json')
          .readAsStringSync()
          .replaceAll(RegExp(r'\s'), '');

      final data = ProjectSaveData.fromJson(jsonDecode(rawSaveData), '', '');
      expect(jsonEncode(data), rawSaveData);
    });
  });
}
