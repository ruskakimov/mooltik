import 'package:mooltik/editor/gif.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Throws exception if no frames are given', () {
    expect(() => makeGif([], []), throwsArgumentError);
  });
}
