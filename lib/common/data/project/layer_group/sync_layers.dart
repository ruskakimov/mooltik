import 'package:mooltik/common/data/project/scene_layer.dart';

/// Synchronizes frame count and timing between 2 layers.
/// Preserves [primary] frame timing and playmode.
/// Appends empty frames to the shortest layer.
Future<void> syncLayers(SceneLayer primary, SceneLayer secondary) async {
  while (secondary.frameSeq.length < primary.frameSeq.length) {
    await _appendFrame(secondary);
  }

  if (primary.frameSeq.length == secondary.frameSeq.length) {
    for (int i = 0; i < primary.frameSeq.length; i++) {
      final primaryDuration = primary.frameSeq[i].duration;
      secondary.frameSeq.changeSpanDurationAt(i, primaryDuration);
    }
  }
}

Future<void> _appendFrame(SceneLayer layer) async {
  final emptyFrame = await layer.frameSeq.last.duplicate();
  layer.frameSeq.insert(layer.frameSeq.length, emptyFrame);
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
