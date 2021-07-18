import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/flood_fill.dart';
import 'package:mooltik/common/data/io/png.dart';

void main() {
  group('floodFill', () {
    test('fills transparent image with color', () async {
      final input =
          await pngRead(File('./test/test_images/flood_test/test_1/input.png'));
      final output =
          await pngRead(File('./test/test_images/flood_test/test_1/input.png'));

      final inputBytes = await input.toByteData();
      final outputBytes = await output.toByteData();

      final result = floodFill(
        inputBytes!,
        input.width,
        input.height,
        0,
        0,
        0xFFC107,
      );

      expect(result, outputBytes!);
    });
  });
}
