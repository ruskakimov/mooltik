import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/flood_fill.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:image/image.dart' as duncan;

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

    test('fills outlined blob', () async {
      await runTest(
        testId: 5,
        fillColor: 0xFF0000FF,
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
  required int fillColor,
  required int startX,
  required int startY,
}) async {
  final input = await pngRead(inputFile(testId));
  final inputBytes = (await pngRawBytes(inputFile(testId))).buffer.asByteData();

  print('Input:');
  _printColors(inputBytes, input.width, input.height);

  final result = floodFill(
    inputBytes,
    input.width,
    input.height,
    startX,
    startY,
    fillColor,
  );

  print('\nFlood result:');
  _printColors(result, input.width, input.height);

  // await pngWrite(
  //   actualOutputFile(testId),
  //   await imageFromBytes(result, input.width, input.height),
  // );

  final pngBytes = duncan.encodePng(
    duncan.Image.fromBytes(
      input.width,
      input.height,
      result.buffer.asUint8List(),
    ),
    level: 0,
  );
  actualOutputFile(testId).writeAsBytesSync(pngBytes, flush: true);

  final outputBytes =
      (await pngRawBytes(actualOutputFile(testId))).buffer.asByteData();

  print('\nOutput:');
  _printColors(outputBytes, input.width, input.height);

  final expectedBytes =
      (await pngRawBytes(expectedOutputFile(testId))).buffer.asByteData();

  print('\nExpected:');
  _printColors(expectedBytes, input.width, input.height);

  expect(
    await pngRawBytes(actualOutputFile(testId)),
    await pngRawBytes(expectedOutputFile(testId)),
  );
}

Future<Uint8List> pngRawBytes(File png) async {
  // final image = await pngRead(png);
  // final byteData = await image.toByteData();
  // return byteData!.buffer.asUint8List();

  final bytes = png.readAsBytesSync();
  return duncan.decodePng(bytes)!.getBytes();
}

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

List<num> _intToRgbaList(int rgba) {
  final r = (rgba >> 24) & 0xFF;
  final g = (rgba >> 16) & 0xFF;
  final b = (rgba >> 8) & 0xFF;
  final a = rgba & 0xFF;
  return [r, g, b, a];
}
