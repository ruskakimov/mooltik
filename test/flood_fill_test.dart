import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/flood_fill.dart';
import 'package:mooltik/common/data/io/png.dart';

void main() {
  group('floodFill', () {
    test('fills transparent image with color', () async {
      await runTest(
        testId: 1,
        fillColor: Color(0xFFFFC107),
        startX: 0,
        startY: 0,
      );
    });

    test('fills perfect rectangle', () async {
      await runTest(
        testId: 2,
        fillColor: Color(0xFFB358FF),
        startX: 10,
        startY: 10,
      );
    });

    test('fills surrounded perfect rectangle', () async {
      await runTest(
        testId: 3,
        fillColor: Color(0xFF277DDC),
        startX: 50,
        startY: 50,
      );
    });

    test('fills rounded rectangle', () async {
      await runTest(
        testId: 4,
        fillColor: Color(0xFFD22D2D),
        startX: 50,
        startY: 50,
      );
    });

    test('fills outlined blob', () async {
      await runTest(
        testId: 5,
        fillColor: Color(0xFFFF0000),
        startX: 50,
        startY: 50,
      );
    });

    test('fills blurry apple blob', () async {
      await runTest(
        testId: 6,
        fillColor: Color(0xFFFF0000),
        startX: 50,
        startY: 50,
      );
    });
  });
}

File inputFile(int i) =>
    File('./test/test_images/flood_test/test_$i/input.png');

File expectedOutputFile(int i) =>
    File('./test/test_images/flood_test/test_$i/expected_output.png');

File actualOutputFile(int i) =>
    File('./test/test_images/flood_test/test_$i/actual_output.png');

Future<void> runTest({
  required int testId,
  required Color fillColor,
  required int startX,
  required int startY,
}) async {
  final input = await pngRead(inputFile(testId));

  final resultImage = await floodFill(
    input,
    startX,
    startY,
    fillColor,
  );

  await pngWrite(actualOutputFile(testId), resultImage!);

  final actualBytes = await pngRawRgba(actualOutputFile(testId));
  final expectedBytes = await pngRawRgba(expectedOutputFile(testId));

  // _printDiff(actualBytes, expectedBytes);

  expect(
    actualBytes.buffer.asUint8List(),
    expectedBytes.buffer.asUint8List(),
  );
}

Future<ByteData> pngRawRgba(File png) async {
  final image = await pngRead(png);
  final byteData = await image.toByteData();
  return byteData!;
}

// ==================
// Debugging helpers:
// ==================

void _printColors(ByteData rawImage, int width, int height) {
  final map = <int, int>{};

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final offset = (y * width + x) * 4;
      final inputColor = rawImage.getUint32(offset);

      map[inputColor] = (map[inputColor] ?? 0) + 1;
    }
  }

  final sortedKeys = map.keys.toList(growable: false)
    ..sort((a, b) => map[b]!.compareTo(map[a]!));

  for (int color in sortedKeys) {
    print('${_intToRgbaList(color)} - ${map[color]}');
  }
}

void _printDiff(ByteData actual, ByteData expected) {
  final actualColors = actual.buffer.asUint32List();
  final expectedColors = expected.buffer.asUint32List();

  for (int i = 0; i < actualColors.length; i++) {
    if (actualColors[i] != expectedColors[i]) {
      print(
        '${_intToRgbaList(actualColors[i])} is not ${_intToRgbaList(expectedColors[i])}',
      );
    }
  }
}

List<num> _intToRgbaList(int rgba) {
  final r = (rgba >> 24) & 0xFF;
  final g = (rgba >> 16) & 0xFF;
  final b = (rgba >> 8) & 0xFF;
  final a = rgba & 0xFF;
  return [r, g, b, a];
}
