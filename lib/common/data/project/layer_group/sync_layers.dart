import 'package:mooltik/common/data/project/scene_layer.dart';

/// Synchronizes frame count and timing between 2 layers.
/// Preserves [primary] frame timing and playmode.
/// Appends empty frames to the shortest layer.
void syncLayers(SceneLayer primary, SceneLayer secondary) {}

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
