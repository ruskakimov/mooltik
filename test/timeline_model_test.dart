import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/editing/data/timeline_model.dart';

const Size sampleSize = Size(1080, 720);

void main() {
  group('TimelineModel', () {
    test('starts with first frame selected', () {
      final timeline = TimelineModel(
        frames: [
          FrameModel(id: 1, size: sampleSize, duration: Duration(seconds: 2)),
          FrameModel(id: 2, size: sampleSize, duration: Duration(seconds: 2)),
        ],
        vsync: TestVSync(),
      );
      expect(timeline.currentFrame.id, 1);
    });

    test('scrubbing updates current frame', () {
      final timeline = TimelineModel(
        frames: [
          FrameModel(id: 1, size: sampleSize, duration: Duration(seconds: 2)),
          FrameModel(id: 2, size: sampleSize, duration: Duration(seconds: 2)),
        ],
        vsync: TestVSync(),
      );
      timeline.scrub(0.5);
      expect(timeline.currentFrame.id, 2);
      timeline.scrub(-0.01);
      expect(timeline.currentFrame.id, 1);
    });
  });
}
