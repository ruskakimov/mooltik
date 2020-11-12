import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/home/project_data.dart';

void main() {
  test('ProjectData should encode', () {
    final data = ProjectData(
      width: 200,
      height: 100,
      drawings: [DrawingData(3, 0)],
    );
    expect(jsonEncode(data), '{"width":200.0,"height":100.0}');
  });
}
