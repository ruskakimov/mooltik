import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

CompositeFrame combineFrames(Iterable<Frame> frames) {
  assert(frames.isNotEmpty);
  assert(frames.every((frame) => frame.duration == frames.first.duration));

  final images = frames.map((frame) => frame.image).toList();
  return CompositeFrame(CompositeImage(images), frames.first.duration);
}

Iterable<CompositeFrame> combineFrameSequences(
  Iterable<Iterable<Frame>> frameSequences,
) sync* {
  assert(frameSequences.isNotEmpty);

  final iterators =
      frameSequences.map((sequence) => sequence.iterator).toList();

  while (iterators.every((iterator) => iterator.moveNext())) {
    yield combineFrames(iterators.map((iterator) => iterator.current));
  }
}
