import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

/// Synchronizes frame count and timing between 2 layers.
/// Layer with the highest frame count "wins".
/// If both are equal length, then the first "wins".
Future<void> syncLayers(SceneLayer a, SceneLayer b) async {
  var long = a.frameSeq;
  var short = b.frameSeq;

  if (short.length > long.length) {
    var temp = long;
    long = short;
    short = temp;
  }

  while (short.length < long.length) {
    await _appendFrame(short);
  }

  for (int i = 0; i < long.length; i++) {
    short.changeSpanDurationAt(i, long[i].duration);
  }
}

Future<void> _appendFrame(Sequence<Frame> seq) async {
  final emptyFrame = await seq.last.duplicate();
  seq.insert(seq.length, emptyFrame);
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
