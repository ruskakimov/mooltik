import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/home/project_save_data.dart';

void main() {
  group('ProjectSaveData should', () {
    test('encode', () {
      final data = ProjectSaveData(
        width: 200,
        height: 100,
        frames: [FrameSaveData(id: 0, duration: Duration(seconds: 3))],
      );
      expect(
        jsonEncode(data),
        '{"width":200.0,"height":100.0,"frames":[{"id":0,"duration":"0:00:03.000000"}],"sounds":[{"id":12,"start_time":"0:00:01.000000","duration":"0:00:02.000000"}]}',
      );
    });
    test('decode and encode back', () {
      final json =
          '{"width":200.0,"height":100.0,"frames":[{"id":0,"duration":"0:00:03.000000"}],"sounds":[{"id":12,"start_time":"0:00:01.000000","duration":"0:00:02.000000"}]}';
      final data = ProjectSaveData.fromJson(jsonDecode(json));
      expect(jsonEncode(data), json);
    });
  });
}
