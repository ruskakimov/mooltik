import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';

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
  });
}
