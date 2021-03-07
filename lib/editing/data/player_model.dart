import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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

  static Future<Duration> getSoundFileDuration(File soundFile) async {
    final player = AudioPlayer();
    final duration = await player.setFilePath(soundFile.path, preload: true);
    await player.dispose();
    return duration;
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
