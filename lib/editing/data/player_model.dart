import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/editing/data/timeline_model.dart';

class PlayerModel extends ChangeNotifier {
  PlayerModel({
    @required this.soundClips,
    @required this.getNewSoundClipFile,
    TimelineModel timeline,
  });

  final List<SoundClip> soundClips;
  final Future<File> Function() getNewSoundClipFile;

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
