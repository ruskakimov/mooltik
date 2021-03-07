import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/editing/data/timeline_model.dart';

class PlayerModel extends ChangeNotifier {
  PlayerModel({
    @required this.soundClips,
    TimelineModel timeline,
  });

  /// List of sound clips to play.
  final List<SoundClip> soundClips;

  /// Reference for listening to play/pause state and playing position.
  TimelineModel _timeline;

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
