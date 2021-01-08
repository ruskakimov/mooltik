import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/drawing/data/frame/image_history_stack.dart';

// To solve the issue of inconsistent directory from where tests are run (https://github.com/flutter/flutter/issues/20907).
File testImageFile(String fileName) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  return File('$dir/test/test_images/$fileName');
}

void main() async {
  final imageA = await pngRead(testImageFile('rabbit_black.png'));
  final imageB = await pngRead(testImageFile('rabbit_pink.png'));
  final imageC = await pngRead(testImageFile('rabbit_yellow.png'));

  group('ImageHistoryStack', () {
    test('has no snapshot initially', () {
      final stack = ImageHistoryStack(maxCount: 3);
      expect(stack.currentSnapshot, isNull);
    });

    test('should not undo with one snapshot left', () {
      final stack = ImageHistoryStack(maxCount: 1);
      stack.push(imageA);
      expect(stack.currentSnapshot, imageA);
      expect(stack.isUndoAvailable, isFalse);

      // Shouldn't do anything.
      stack.undo();
      expect(stack.currentSnapshot, imageA);
    });
  });
}
