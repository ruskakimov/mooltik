import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:quiver/testing/async.dart';

void main() {
  group('TimelineModel', () {
    test('should toggle playing state on play/stop', () {
      final model = TimelineModel(initialKeyframes: [
        FrameModel()..duration = 24,
        FrameModel()..duration = 12,
      ]);
      model.play();
      expect(model.playing, isTrue);
      model.stop();
      expect(model.playing, isFalse);
    });

    test('should show frames in sequence with correct duration', () {
      final model = TimelineModel(initialKeyframes: [
        FrameModel()..duration = 24,
        FrameModel()..duration = 12,
      ]);

      FakeAsync().run((async) {
        model.play();
        expect(model.selectedKeyframeId, 0);
        async.elapse(Duration(milliseconds: 999));
        expect(model.selectedKeyframeId, 0);
        async.elapse(Duration(milliseconds: 1));

        expect(model.selectedKeyframeId, 1);
        async.elapse(Duration(milliseconds: 499));
        expect(model.selectedKeyframeId, 1);
        async.elapse(Duration(milliseconds: 1));
        expect(model.selectedKeyframeId, 0);
        model.stop();
      });
    });
  });
}
