import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:quiver/testing/async.dart';

void main() {
  group('reelModel', () {
    test('should toggle playing state on play/stop', () {
      final model = ReelModel(initialFrames: [
        FrameModel()..duration = 24,
        FrameModel()..duration = 12,
      ]);
      model.play();
      expect(model.playing, isTrue);
      model.stop();
      expect(model.playing, isFalse);
    });

    test('should show frames in sequence with correct duration (2 frames)', () {
      final model = ReelModel(initialFrames: [
        FrameModel()..duration = 24,
        FrameModel()..duration = 12,
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
        FrameModel()..duration = 6,
        FrameModel()..duration = 12,
        FrameModel()..duration = 6,
        FrameModel()..duration = 48,
        FrameModel()..duration = 6,
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
        FrameModel()..duration = 24,
        FrameModel()..duration = 12,
        FrameModel()..duration = 6,
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
        FrameModel()..duration = 2,
        FrameModel()..duration = 2,
        FrameModel()..duration = 2,
        FrameModel()..duration = 2,
        FrameModel()..duration = 2,
        FrameModel()..duration = 2,
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
            '0-0;1-83;2-166;3-249;4-332;5-415;0-498;1-581;2-664;3-747;4-830;5-913;0-996;1-1079;2-1162;3-1245;4-1328;5-1411;0-1494;1-1577;2-1660;3-1743;4-1826;5-1909;0-1992;');

        model.stop();
      });
    });
  });
}
