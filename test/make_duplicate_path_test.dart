import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/make_duplicate_path.dart';

void main() {
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
