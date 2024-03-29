import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/drawing/data/frame/image_history_stack.dart';

void main() async {
  final imageA = await pngRead(File('./test/test_images/rabbit_black.png'));
  final imageB = await pngRead(File('./test/test_images/rabbit_pink.png'));
  final imageC = await pngRead(File('./test/test_images/rabbit_yellow.png'));

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

    test('can undo first pushed snapshot', () {
      final stack = ImageHistoryStack(maxCount: 5);
      expect(stack.currentSnapshot, isNull);

      stack.push(imageA);
      expect(stack.currentSnapshot, imageA);
      expect(stack.isUndoAvailable, isTrue);

      stack.undo();
      expect(stack.currentSnapshot, isNull);
    });

    test('can undo multiple times', () {
      final stack = ImageHistoryStack(maxCount: 5);
      stack.push(imageA);
      stack.push(imageB);
      expect(stack.currentSnapshot, imageB);

      stack.undo();
      expect(stack.currentSnapshot, imageA);

      stack.undo();
      expect(stack.currentSnapshot, isNull);
    });

    test('can redo', () {
      final stack = ImageHistoryStack(maxCount: 5);
      stack.push(imageA);
      stack.push(imageB);
      expect(stack.currentSnapshot, imageB);

      stack.undo();
      expect(stack.currentSnapshot, imageA);

      stack.redo();
      expect(stack.currentSnapshot, imageB);
    });

    test('should not undo initial snapshot', () {
      final stack = ImageHistoryStack(maxCount: 5, initialSnapshot: imageA);
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
