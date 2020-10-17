import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:quiver/testing/async.dart';

void main() {
  FrameModel a, b, c, d, e, f;

  setUp(() {
    a = FrameModel(size: Size(1280, 720));
    b = FrameModel(size: Size(1280, 720));
    c = FrameModel(size: Size(1280, 720));
    d = FrameModel(size: Size(1280, 720));
    e = FrameModel(size: Size(1280, 720));
    f = FrameModel(size: Size(1280, 720));
  });

  group('ReelModel', () {
    test('should toggle playing state on play/stop', () {
      final model = ReelModel(initialFrames: [
        a,
        null,
        b,
        null,
      ]);
      model.play();
      expect(model.playing, isTrue);
      model.stop();
      expect(model.playing, isFalse);
    });

    test('should show frames in sequence with correct duration (2 frames)', () {
      final model = ReelModel(initialFrames: [
        a,
        ...List(23),
        b,
        ...List(11),
      ]);

      FakeAsync().run((async) {
        model.play();
        expect(model.visibleFrame, a);
        async.elapse(Duration(milliseconds: 999));
        expect(model.visibleFrame, a);
        async.elapse(Duration(milliseconds: 1));

        expect(model.visibleFrame, b);
        async.elapse(Duration(milliseconds: 499));
        expect(model.visibleFrame, b);
        async.elapse(Duration(milliseconds: 1));

        expect(model.visibleFrame, a);
        model.stop();
      });
    });

    test('should show frames in sequence with correct duration (5 frames)', () {
      final model = ReelModel(initialFrames: [
        a,
        ...List(5),
        b,
        ...List(11),
        c,
        ...List(5),
        d,
        ...List(47),
        e,
        ...List(5),
      ]);

      FakeAsync().run((async) {
        model.play();
        expect(model.visibleFrame, a);
        async.elapse(Duration(milliseconds: 249));
        expect(model.visibleFrame, a);
        async.elapse(Duration(milliseconds: 1));

        expect(model.visibleFrame, b);
        async.elapse(Duration(milliseconds: 499));
        expect(model.visibleFrame, b);
        async.elapse(Duration(milliseconds: 1));

        expect(model.visibleFrame, c);
        async.elapse(Duration(milliseconds: 249));
        expect(model.visibleFrame, c);
        async.elapse(Duration(milliseconds: 1));

        expect(model.visibleFrame, d);
        async.elapse(Duration(milliseconds: 1999));
        expect(model.visibleFrame, d);
        async.elapse(Duration(milliseconds: 1));

        expect(model.visibleFrame, e);
        async.elapse(Duration(milliseconds: 249));
        expect(model.visibleFrame, e);
        async.elapse(Duration(milliseconds: 1));

        expect(model.visibleFrame, a);
        model.stop();
      });
    });

    test('should loop animation correctly', () {
      final model = ReelModel(initialFrames: [
        a,
        ...List(23),
        b,
        ...List(11),
        c,
        ...List(5),
      ]);

      FakeAsync().run((async) {
        model.play();

        void loop() {
          expect(model.visibleFrame, a);
          async.elapse(Duration(milliseconds: 999));
          expect(model.visibleFrame, a);
          async.elapse(Duration(milliseconds: 1));

          expect(model.visibleFrame, b);
          async.elapse(Duration(milliseconds: 499));
          expect(model.visibleFrame, b);
          async.elapse(Duration(milliseconds: 1));

          expect(model.visibleFrame, c);
          async.elapse(Duration(milliseconds: 249));
          expect(model.visibleFrame, c);
          async.elapse(Duration(milliseconds: 1));

          expect(model.visibleFrame, a);
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
        a,
        null,
        b,
        null,
        c,
        null,
        d,
        null,
        e,
        null,
        f,
        null,
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
            '0-0;1-41;2-83;3-124;4-166;5-208;6-249;7-291;8-333;9-374;10-416;11-458;0-499;1-541;2-583;3-624;4-666;5-708;6-749;7-791;8-833;9-874;10-916;11-958;0-999;1-1041;2-1083;3-1124;4-1166;5-1208;6-1249;7-1291;8-1333;9-1374;10-1416;11-1458;0-1499;1-1541;2-1583;3-1624;4-1666;5-1708;6-1749;7-1791;8-1833;9-1874;10-1916;11-1958;0-1999;');

        model.stop();
      });
    });
  });
}
