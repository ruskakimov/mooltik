import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/home/project_save_data.dart';

void main() {
  test('ProjectData should encode', () {
    final data = ProjectSaveData(
      width: 200,
      height: 100,
      drawings: [DrawingSaveData(id: 0, duration: 3)],
    );
    expect(
      jsonEncode(data),
      '{"width":200.0,"height":100.0,"drawings":[{"id":0,"duration":3}],"layers":[{"id":0}]}',
    );
  });
}
