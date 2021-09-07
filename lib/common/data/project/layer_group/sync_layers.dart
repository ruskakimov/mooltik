import 'dart:io';

import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/io/make_duplicate_path.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

/// Synchronizes frame count and timing between 2 layers.
/// Layer with the highest frame count "wins".
/// If both are equal length, then the first "wins".
Future<void> syncLayers(SceneLayer a, SceneLayer b) async {
  if (a.frameSeq.length < b.frameSeq.length) {
    return syncLayers(b, a);
  }

  b.setPlayMode(a.playMode);

  final long = a.frameSeq;
  final short = b.frameSeq;

  await _appendEmptyFrames(short, long.length - short.length);

  for (int i = 0; i < long.length; i++) {
    short.changeSpanDurationAt(i, long[i].duration);
  }
}

Future<void> _appendEmptyFrames(Sequence<Frame> seq, int frameCount) async {
  if (frameCount == 0) return;

  final frameWidth = seq.last.image.width;
  final frameHeight = seq.last.image.height;

  final emptySnapshot = await generateEmptyImage(frameWidth, frameHeight);

  for (int i = 0; i < frameCount; i++) {
    final lastFile = seq.last.image.file;
    final emptyImage = DiskImage(
      file: File(makeFreeDuplicatePath(lastFile.path)),
      width: frameWidth,
      height: frameHeight,
      snapshot: emptySnapshot.clone(),
    );

    seq.insert(seq.length, Frame(image: emptyImage));
  }

  emptySnapshot.dispose();
}

/// Whether 2 layers have identical frame count and timing.
bool areSynced(SceneLayer a, SceneLayer b) {
  if (a.playMode != b.playMode) return false;
  if (a.frameSeq.length != b.frameSeq.length) return false;
  if (a.frameSeq.totalDuration != b.frameSeq.totalDuration) return false;

  for (int i = 0; i < a.frameSeq.length; i++) {
    if (a.frameSeq[i].duration != b.frameSeq[i].duration) return false;
  }

  return true;
}
