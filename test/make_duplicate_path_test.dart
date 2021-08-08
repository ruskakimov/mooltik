import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/make_duplicate_path.dart';

void main() {
  group('makeDuplicatePath', () {
    test('should add counter when there is none', () {
      expect(
        makeDuplicatePath('/some/interesting/path/some_name.png'),
        '/some/interesting/path/some_name_1.png',
      );
    });
  });
}
