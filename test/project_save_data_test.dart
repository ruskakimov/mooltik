import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/home/project_save_data.dart';

void main() {
  group('ProjectSaveData should', () {
    test('encode', () {
      final data = ProjectSaveData(
        width: 200,
        height: 100,
        frames: [FrameSaveData(id: 0, duration: 3)],
      );
      expect(
        jsonEncode(data),
        '{"width":200.0,"height":100.0,"frames":[{"id":0,"duration":3}],"layers":[{"id":0}]}',
      );
    });
    test('decode and encode back', () {
      final json =
          '{"width":200.0,"height":100.0,"frames":[{"id":0,"duration":3}],"layers":[{"id":0}]}';
      final data = ProjectSaveData.fromJson(jsonDecode(json));
      expect(jsonEncode(data), json);
    });
  });
}
