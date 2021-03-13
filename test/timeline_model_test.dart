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

    test('playhead position doesn\'t change when frame duration is changed',
        () {
      final timeline = TimelineModel(
        frames: [
          FrameModel(
              id: 1, size: sampleSize, duration: Duration(milliseconds: 500)),
          FrameModel(
              id: 2, size: sampleSize, duration: Duration(milliseconds: 500)),
        ],
        vsync: TestVSync(),
      );
      timeline.scrub(0.25);
      expect(timeline.playheadPosition, Duration(milliseconds: 250));
      timeline.changeFrameDurationAt(0, Duration(milliseconds: 900));
      expect(timeline.playheadPosition, Duration(milliseconds: 250));
      expect(timeline.currentFrame.id, 1);
    });

    test('handles frame duration change past playhead (from right to left)',
        () {
      final timeline = TimelineModel(
        frames: [
          FrameModel(
              id: 1, size: sampleSize, duration: Duration(milliseconds: 500)),
          FrameModel(
              id: 2, size: sampleSize, duration: Duration(milliseconds: 500)),
        ],
        vsync: TestVSync(),
      );
      timeline.scrub(0.25);
      expect(timeline.playheadPosition, Duration(milliseconds: 250));
      timeline.changeFrameDurationAt(0, Duration(milliseconds: 200));
      expect(timeline.playheadPosition, Duration(milliseconds: 250));
      expect(timeline.currentFrame.id, 2);
    });
  });
}
