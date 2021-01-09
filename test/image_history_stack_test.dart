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
    test('has no snapshot initially if not specified', () {
      final stack = ImageHistoryStack(maxCount: 3);
      expect(stack.currentSnapshot, isNull);
    });

    test('has a snapshot initially if specified', () {
      final stack = ImageHistoryStack(maxCount: 3, initialSnapshot: imageA);
      expect(stack.currentSnapshot, imageA);
    });

    test('should not keep more images than maximum count', () {
      final stack = ImageHistoryStack(maxCount: 2);
      stack.push(imageA);
      stack.push(imageB);
      stack.push(imageC);
      stack.undo();
      expect(stack.currentSnapshot, imageB);
      expect(stack.isUndoAvailable, isFalse);
    });

    test('should undo', () {
      final stack = ImageHistoryStack(maxCount: 5);
      stack.push(imageA);
      stack.push(imageB);
      expect(stack.currentSnapshot, imageB);

      stack.undo();
      expect(stack.currentSnapshot, imageA);
    });

    test('should redo', () {
      final stack = ImageHistoryStack(maxCount: 5);
      stack.push(imageA);
      stack.push(imageB);
      expect(stack.currentSnapshot, imageB);

      stack.undo();
      expect(stack.currentSnapshot, imageA);

      stack.redo();
      expect(stack.currentSnapshot, imageB);
    });

    test('should not have undo available with only one snapshot', () {
      final stack = ImageHistoryStack(maxCount: 1);
      stack.push(imageA);
      expect(stack.currentSnapshot, imageA);
      expect(stack.isUndoAvailable, isFalse);

      // Should have no effect.
      stack.undo();
      expect(stack.currentSnapshot, imageA);
    });

    test('should not have redo available after a push', () {
      final stack = ImageHistoryStack(maxCount: 10);
      stack.push(imageA);
      expect(stack.currentSnapshot, imageA);
      expect(stack.isRedoAvailable, isFalse);

      // Should have no effect.
      stack.redo();
      expect(stack.currentSnapshot, imageA);

      stack.push(imageB);
      expect(stack.currentSnapshot, imageB);
      expect(stack.isRedoAvailable, isFalse);

      // Should have no effect.
      stack.redo();
      expect(stack.currentSnapshot, imageB);

      stack.push(imageC);
      expect(stack.currentSnapshot, imageC);
      expect(stack.isRedoAvailable, isFalse);

      // Should have no effect.
      stack.redo();
      expect(stack.currentSnapshot, imageC);
    });
  });
}
