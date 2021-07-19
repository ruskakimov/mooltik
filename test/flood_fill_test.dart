import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/flood_fill.dart';
import 'package:mooltik/common/data/io/image.dart';
import 'package:mooltik/common/data/io/png.dart';

void main() {
  group('floodFill', () {
    test('fills transparent image with color', () async {
      await runTest(
        testId: 1,
        fillColor: 0xFFC107FF,
        startX: 0,
        startY: 0,
      );
    });

    test('fills perfect rectangle', () async {
      await runTest(
        testId: 2,
        fillColor: 0xB358FFFF,
        startX: 10,
        startY: 10,
      );
    });

    test('fills surrounded perfect rectangle', () async {
      await runTest(
        testId: 3,
        fillColor: 0x277DDCFF,
        startX: 50,
        startY: 50,
      );
    });

    test('fills rounded rectangle', () async {
      await runTest(
        testId: 4,
        fillColor: 0xD22D2DFF,
        startX: 50,
        startY: 50,
      );
    });
  });
}

Future<Uint8List> pngRawBytes(File png) async {
  final image = await pngRead(png);
  final byteData = await image.toByteData();
  return byteData!.buffer.asUint8List();
}

File inputFile(int i) =>
    File('./test/test_images/flood_test/test_$i/input.png');

File expectedOutputFile(int i) =>
    File('./test/test_images/flood_test/test_$i/expected_output.png');

File actualOutputFile(int i) =>
    File('./test/test_images/flood_test/test_$i/actual_output.png');

Future<void> runTest({
  required int testId,
  required int fillColor,
  required int startX,
  required int startY,
}) async {
  _printColorMap(testId);

  final input = await pngRead(inputFile(testId));
  final inputBytes = await input.toByteData() as ByteData;

  final result = floodFill(
    inputBytes,
    input.width,
    input.height,
    startX,
    startY,
    fillColor,
  );

  await pngWrite(
    actualOutputFile(testId),
    await imageFromBytes(result, input.width, input.height),
  );

  expect(
    await pngRawBytes(actualOutputFile(testId)),
    await pngRawBytes(expectedOutputFile(testId)),
  );
}

void _printColorMap(int testId) async {
  final input = await pngRead(inputFile(testId));
  final inputBytes = await input.toByteData() as ByteData;

  final output = await pngRead(expectedOutputFile(testId));
  final outputBytes = await output.toByteData() as ByteData;

  final map = <int, int>{};

  for (int y = 0; y < input.height; y++) {
    for (int x = 0; x < input.width; x++) {
      final offset = (y * input.width + x) * 4;
      final inputColor = inputBytes.getUint32(offset);
      final outputColor = outputBytes.getUint32(offset);

      if (map.containsKey(inputColor) && map[inputColor] != outputColor) {
        print('No 1 to 1 relationship.');
      } else {
        map[inputColor] = outputColor;
      }
    }
  }

  for (int color in map.keys) {
    print('${color.toRadixString(16)} -> ${map[color]!.toRadixString(16)}');
  }
}
