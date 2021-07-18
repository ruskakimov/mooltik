import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/flood_fill.dart';
import 'package:mooltik/common/data/io/image.dart';
import 'package:mooltik/common/data/io/png.dart';

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

void main() {
  group('floodFill', () {
    test('fills transparent image with color', () async {
      final input = await pngRead(inputFile(1));
      final inputBytes = await input.toByteData() as ByteData;

      final result = floodFill(
        inputBytes,
        input.width,
        input.height,
        0,
        0,
        0xFFC107FF,
      );

      await pngWrite(
        actualOutputFile(1),
        await imageFromBytes(result, input.width, input.height),
      );

      expect(
        await pngRawBytes(actualOutputFile(1)),
        await pngRawBytes(expectedOutputFile(1)),
      );
    });
  });
}
