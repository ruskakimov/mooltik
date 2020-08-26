import 'package:animation_app/editor/gif.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Throws exception if no frames are given', () {
    expect(() => createGif([], 1), throwsArgumentError);
  });
}
