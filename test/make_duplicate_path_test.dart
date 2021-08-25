import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/make_duplicate_path.dart';

void main() {
  group('makeFreeDuplicatePath', () {
    test('should increment if next path is occupied', () {
      final tempFile = File('./image_1.png')..createSync(recursive: true);

      expect(
        makeFreeDuplicatePath('./image.png'),
        './image_2.png',
      );

      tempFile.deleteSync(recursive: true);
    });

    test('should increment until path is free', () {
      final tempFile = File('./image_1.png')..createSync(recursive: true);
      final tempFile2 = File('./image_2.png')..createSync(recursive: true);

      expect(
        makeFreeDuplicatePath('./image.png'),
        './image_3.png',
      );

      tempFile.deleteSync(recursive: true);
      tempFile2.deleteSync(recursive: true);
    });
  });

  group('makeDuplicatePath', () {
    test('should add a counter when there is none', () {
      expect(
        makeDuplicatePath('example/path/image.png'),
        'example/path/image_1.png',
      );
    });

    test('should increment an existing counter', () {
      expect(
        makeDuplicatePath('example/path/image_1.png'),
        'example/path/image_2.png',
      );

      expect(
        makeDuplicatePath('example/path/image_2.png'),
        'example/path/image_3.png',
      );
    });

    test('should increment an existing counter with a large value', () {
      expect(
        makeDuplicatePath('example/path/frame123123123_99999999.png'),
        'example/path/frame123123123_100000000.png',
      );
    });
  });
}
