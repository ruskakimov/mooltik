import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/editing/data/timeline_model.dart';

void main() {
  group('TimelineModel', () {
    test('starts with first frame selected', () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 2)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        vsync: TestVSync(),
      );
      expect(timeline.currentFrame.file.path, '1.png');
    });

    test('scrubbing updates current frame', () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 2)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        vsync: TestVSync(),
      );
      timeline.scrub(Duration(seconds: 2));
      expect(timeline.currentFrame.file.path, '2.png');
      timeline.scrub(Duration(milliseconds: -1));
      expect(timeline.currentFrame.file.path, '1.png');
    });

    test('playhead position doesn\'t change when frame duration is changed',
        () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(
              file: File('1.png'), duration: Duration(milliseconds: 500)),
          FrameModel(
              file: File('2.png'), duration: Duration(milliseconds: 500)),
        ]),
        vsync: TestVSync(),
      );
      timeline.scrub(Duration(milliseconds: 250));
      expect(timeline.playheadPosition, Duration(milliseconds: 250));
      timeline.changeFrameDurationAt(0, Duration(milliseconds: 900));
      expect(timeline.playheadPosition, Duration(milliseconds: 250));
      expect(timeline.currentFrame.file.path, '1.png');
    });

    test('handles frame duration change past playhead (from right to left)',
        () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(
              file: File('1.png'), duration: Duration(milliseconds: 500)),
          FrameModel(
              file: File('2.png'), duration: Duration(milliseconds: 500)),
        ]),
        vsync: TestVSync(),
      );
      timeline.scrub(Duration(milliseconds: 250));
      expect(timeline.playheadPosition, Duration(milliseconds: 250));
      timeline.changeFrameDurationAt(0, Duration(milliseconds: 200));
      expect(timeline.playheadPosition, Duration(milliseconds: 250));
      expect(timeline.currentFrame.file.path, '2.png');
    });

    test('handles deleting before current frame', () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
          FrameModel(file: File('3.png'), duration: Duration(seconds: 10)),
          FrameModel(file: File('4.png'), duration: Duration(seconds: 4)),
          FrameModel(file: File('5.png'), duration: Duration(seconds: 7)),
        ]),
        vsync: TestVSync(),
      );
      expect(timeline.totalDuration, Duration(seconds: 24));
      timeline.stepForward();
      timeline.stepForward();
      expect(timeline.playheadPosition, Duration(seconds: 3));
      expect(timeline.currentFrame.file.path, '3.png');
      expect(timeline.currentFrameStartTime, Duration(seconds: 3));
      timeline.deleteFrameAt(1);
      expect(timeline.totalDuration, Duration(seconds: 22));
      expect(timeline.playheadPosition, Duration(seconds: 1));
      expect(timeline.currentFrame.file.path, '3.png');
      expect(timeline.currentFrameStartTime, Duration(seconds: 1));
    });

    test('handles deleting current frame', () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 20)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 30)),
          FrameModel(file: File('3.png'), duration: Duration(seconds: 7)),
          FrameModel(file: File('4.png'), duration: Duration(seconds: 8)),
        ]),
        vsync: TestVSync(),
      );
      timeline.stepForward();
      expect(timeline.totalDuration, Duration(seconds: 65));
      expect(timeline.currentFrame.file.path, '2.png');
      expect(timeline.playheadPosition, Duration(seconds: 20));
      expect(timeline.currentFrameStartTime, Duration(seconds: 20));
      timeline.deleteFrameAt(1);
      expect(timeline.totalDuration, Duration(seconds: 35));
      expect(timeline.currentFrame.file.path, '3.png');
      expect(timeline.playheadPosition, Duration(seconds: 20));
      expect(timeline.currentFrameStartTime, Duration(seconds: 20));
    });

    test('handles deleting after current frame', () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 20)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 30)),
          FrameModel(file: File('3.png'), duration: Duration(seconds: 7)),
          FrameModel(file: File('4.png'), duration: Duration(seconds: 8)),
        ]),
        vsync: TestVSync(),
      );
      timeline.stepForward();
      expect(timeline.totalDuration, Duration(seconds: 65));
      expect(timeline.currentFrame.file.path, '2.png');
      expect(timeline.playheadPosition, Duration(seconds: 20));
      expect(timeline.currentFrameStartTime, Duration(seconds: 20));
      timeline.deleteFrameAt(2);
      expect(timeline.totalDuration, Duration(seconds: 58));
      expect(timeline.currentFrame.file.path, '2.png');
      expect(timeline.playheadPosition, Duration(seconds: 20));
      expect(timeline.currentFrameStartTime, Duration(seconds: 20));
    });

    test('handles deleting long frame', () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 5)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 300)),
          FrameModel(file: File('3.png'), duration: Duration(seconds: 7)),
          FrameModel(file: File('4.png'), duration: Duration(seconds: 8)),
          FrameModel(file: File('5.png'), duration: Duration(seconds: 10)),
          FrameModel(file: File('6.png'), duration: Duration(seconds: 10)),
        ]),
        vsync: TestVSync(),
      );
      timeline.scrub(Duration(seconds: 272));
      expect(timeline.totalDuration, Duration(seconds: 340));
      expect(timeline.currentFrame.file.path, '2.png');
      expect(timeline.playheadPosition, Duration(seconds: 272));
      expect(timeline.currentFrameStartTime, Duration(seconds: 5));
      timeline.deleteFrameAt(1);
      expect(timeline.totalDuration, Duration(seconds: 40));
      expect(timeline.currentFrame.file.path, '3.png');
      expect(timeline.playheadPosition, Duration(seconds: 5));
      expect(timeline.currentFrameStartTime, Duration(seconds: 5));
    });

    test('handles deleting current last frame', () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
        ]),
        vsync: TestVSync(),
      );
      timeline.stepForward();
      expect(timeline.totalDuration, Duration(seconds: 3));
      expect(timeline.currentFrame.file.path, '2.png');
      expect(timeline.playheadPosition, Duration(seconds: 1));
      expect(timeline.currentFrameStartTime, Duration(seconds: 1));
      timeline.deleteFrameAt(1);
      expect(timeline.totalDuration, Duration(seconds: 1));
      expect(timeline.currentFrame.file.path, '1.png');
      expect(timeline.playheadPosition, Duration(seconds: 1));
      expect(timeline.currentFrameStartTime, Duration.zero);
    });

    test('handles inserting frame after current', () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
          FrameModel(file: File('3.png'), duration: Duration(seconds: 3)),
        ]),
        vsync: TestVSync(),
      );
      timeline.jumpTo(Duration(milliseconds: 1500));
      expect(timeline.totalDuration, Duration(seconds: 6));
      expect(timeline.currentFrame.file.path, '2.png');
      expect(timeline.playheadPosition, Duration(milliseconds: 1500));
      expect(timeline.currentFrameStartTime, Duration(seconds: 1));
      timeline.insertFrameAt(
        2,
        FrameModel(file: File('4.png'), duration: Duration(seconds: 4)),
      );
      expect(timeline.totalDuration, Duration(seconds: 10));
      expect(timeline.currentFrame.file.path, '2.png');
      expect(timeline.playheadPosition, Duration(milliseconds: 1500));
      expect(timeline.currentFrameStartTime, Duration(seconds: 1));
    });

    test('handles inserting frame before current', () {
      final timeline = TimelineModel(
        frameSeq: Sequence<FrameModel>([
          FrameModel(file: File('1.png'), duration: Duration(seconds: 1)),
          FrameModel(file: File('2.png'), duration: Duration(seconds: 2)),
          FrameModel(file: File('3.png'), duration: Duration(seconds: 2)),
        ]),
        vsync: TestVSync(),
      );
      timeline.scrub(Duration(milliseconds: 2500));
      expect(timeline.totalDuration, Duration(seconds: 5));
      expect(timeline.currentFrame.file.path, '2.png');
      expect(timeline.playheadPosition, Duration(milliseconds: 2500));
      expect(timeline.currentFrameStartTime, Duration(seconds: 1));
      timeline.insertFrameAt(
        0,
        FrameModel(file: File('4.png'), duration: Duration(seconds: 3)),
      );
      expect(timeline.totalDuration, Duration(seconds: 8));
      expect(timeline.currentFrame.file.path, '2.png');
      expect(timeline.playheadPosition, Duration(milliseconds: 5500));
      expect(timeline.currentFrameStartTime, Duration(seconds: 4));
    });
  });
}
