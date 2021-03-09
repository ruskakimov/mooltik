import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/editing/data/timeline_model.dart';

Future<Duration> getSoundFileDuration(File soundFile) async {
  final player = AudioPlayer();
  final duration = await player.setFilePath(soundFile.path, preload: true);
  await player.dispose();
  return duration;
}

class PlayerModel extends ChangeNotifier {
  PlayerModel({
    @required this.soundClips,
    TimelineModel timeline,
  })  : _player = AudioPlayer(),
        _timeline = timeline;

  final AudioPlayer _player;

  /// List of sound clips to play.
  final List<SoundClip> soundClips;

  /// Reference for listening to play/pause state and playing position.
  TimelineModel _timeline;

  /// Prepare player for playing from current playhead position.
  Future<void> prepare() async {
    if (soundClips.isEmpty) return;

    await _player.setFilePath(
      soundClips.first.path,
      initialPosition: _timeline.playheadPosition,
      preload: true,
    );
  }

  @override
  Future<void> dispose() async {
    _player?.dispose();
    super.dispose();
  }
}
