import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:quiver/testing/async.dart';

void main() {
  group('ReelModel', () {
    test('should toggle playing state on play/stop', () {
      final model = ReelModel(initialFrames: [
        FrameModel(size: Size(1280, 720)),
        FrameModel(size: Size(1280, 720)),
      ]);
      model.play();
      expect(model.playing, isTrue);
      model.stop();
      expect(model.playing, isFalse);
    });

    test('should show frames in sequence with correct duration (2 frames)', () {
      final model = ReelModel(initialFrames: [
        FrameModel(size: Size(1280, 720), duration: 24),
        FrameModel(size: Size(1280, 720), duration: 12),
      ]);

      FakeAsync().run((async) {
        model.play();
        expect(model.selectedFrameId, 0);
        async.elapse(Duration(milliseconds: 999));
        expect(model.selectedFrameId, 0);
        async.elapse(Duration(milliseconds: 1));

        expect(model.selectedFrameId, 1);
        async.elapse(Duration(milliseconds: 499));
        expect(model.selectedFrameId, 1);
        async.elapse(Duration(milliseconds: 1));

        expect(model.selectedFrameId, 0);
        model.stop();
      });
    });

    test('should show frames in sequence with correct duration (5 frames)', () {
      final model = ReelModel(initialFrames: [
        FrameModel(size: Size(1280, 720), duration: 6),
        FrameModel(size: Size(1280, 720), duration: 12),
        FrameModel(size: Size(1280, 720), duration: 6),
        FrameModel(size: Size(1280, 720), duration: 48),
        FrameModel(size: Size(1280, 720), duration: 6),
      ]);

      FakeAsync().run((async) {
        model.play();
        expect(model.selectedFrameId, 0);
        async.elapse(Duration(milliseconds: 249));
        expect(model.selectedFrameId, 0);
        async.elapse(Duration(milliseconds: 1));

        expect(model.selectedFrameId, 1);
        async.elapse(Duration(milliseconds: 499));
        expect(model.selectedFrameId, 1);
        async.elapse(Duration(milliseconds: 1));

        expect(model.selectedFrameId, 2);
        async.elapse(Duration(milliseconds: 249));
        expect(model.selectedFrameId, 2);
        async.elapse(Duration(milliseconds: 1));

        expect(model.selectedFrameId, 3);
        async.elapse(Duration(milliseconds: 1999));
        expect(model.selectedFrameId, 3);
        async.elapse(Duration(milliseconds: 1));

        expect(model.selectedFrameId, 4);
        async.elapse(Duration(milliseconds: 249));
        expect(model.selectedFrameId, 4);
        async.elapse(Duration(milliseconds: 1));

        expect(model.selectedFrameId, 0);
        model.stop();
      });
    });

    test('should loop animation correctly', () {
      final model = ReelModel(initialFrames: [
        FrameModel(size: Size(1280, 720), duration: 24),
        FrameModel(size: Size(1280, 720), duration: 12),
        FrameModel(size: Size(1280, 720), duration: 6),
      ]);

      FakeAsync().run((async) {
        model.play();

        void loop() {
          expect(model.selectedFrameId, 0);
          async.elapse(Duration(milliseconds: 999));
          expect(model.selectedFrameId, 0);
          async.elapse(Duration(milliseconds: 1));

          expect(model.selectedFrameId, 1);
          async.elapse(Duration(milliseconds: 499));
          expect(model.selectedFrameId, 1);
          async.elapse(Duration(milliseconds: 1));

          expect(model.selectedFrameId, 2);
          async.elapse(Duration(milliseconds: 249));
          expect(model.selectedFrameId, 2);
          async.elapse(Duration(milliseconds: 1));

          expect(model.selectedFrameId, 0);
        }

        loop();
        loop();
        loop();
        loop();
        loop();
        loop();

        model.stop();
      });
    });

    test('should notify listeners at the right time, with the right id', () {
      final model = ReelModel(initialFrames: [
        FrameModel(size: Size(1280, 720), duration: 2),
        FrameModel(size: Size(1280, 720), duration: 2),
        FrameModel(size: Size(1280, 720), duration: 2),
        FrameModel(size: Size(1280, 720), duration: 2),
        FrameModel(size: Size(1280, 720), duration: 2),
        FrameModel(size: Size(1280, 720), duration: 2),
      ]);

      FakeAsync().run((async) {
        final clock = async.getClock(DateTime.fromMillisecondsSinceEpoch(0));

        String timestamps = '';

        model.addListener(() {
          timestamps += model.selectedFrameId.toString() +
              '-' +
              clock.now().millisecondsSinceEpoch.toString() +
              ';';
        });

        model.play();

        async.elapse(Duration(seconds: 2));
        expect(timestamps,
            '0-0;1-83;2-166;3-249;4-333;5-416;0-499;1-583;2-666;3-749;4-833;5-916;0-999;1-1083;2-1166;3-1249;4-1333;5-1416;0-1499;1-1583;2-1666;3-1749;4-1833;5-1916;0-1999;');

        model.stop();
      });
    });
  });
}
