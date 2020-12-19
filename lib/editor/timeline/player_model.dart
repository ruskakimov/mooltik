import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:mooltik/editor/sound_clip.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerModel extends ChangeNotifier {
  PlayerModel({
    @required this.soundClips,
    @required this.getNewSoundClipFile,
    TimelineModel timeline,
  })  : _timeline = timeline,
        _player = FlutterSoundPlayer() {
    _player.openAudioSession().then((_) {
      _timeline.addListener(_timelineListener);
    });
  }

  // TODO: These two can be combined into a single class.
  final List<SoundClip> soundClips;
  final Future<File> Function() getNewSoundClipFile;

  final TimelineModel _timeline;

  FlutterSoundRecorder _recorder;
  FlutterSoundPlayer _player;

  bool get isRecording => _recorder?.isRecording ?? false;

  bool get isPlaying => _player?.isPlaying ?? false;
  bool _isPlayerBusy = false;

  Future<void> _initRecorder() async {
    final permit = await Permission.microphone.request();
    if (permit != PermissionStatus.granted) return;
    _recorder = FlutterSoundRecorder();
    await _recorder.openAudioSession();
  }

  void _timelineListener() {
    if (isRecording) {
      _recorderListener();
    } else {
      _playerListener();
    }
  }

  void _recorderListener() {
    _updateSoundBiteDuration();
    if (!_timeline.isPlaying) stopRecording();
  }

  void _playerListener() async {
    if (soundClips.isEmpty) return;

    final soundClip = soundClips.first;
    final shouldPlay = _timeline.isPlaying &&
        _timeline.playheadPosition >= soundClip.startTime &&
        _timeline.playheadPosition <= soundClip.endTime;

    if (shouldPlay && !isPlaying && !_isPlayerBusy) {
      _isPlayerBusy = true;

      // TODO: This is expensive (~80ms), prime the sound beforehand
      await _player.startPlayer(
        fromURI: soundClip.uri,
        codec: Codec.aacADTS,
      );

      await _player.seekToPlayer(
        _timeline.playheadPosition - soundClip.startTime,
      );

      _isPlayerBusy = false;
    } else if (!shouldPlay && isPlaying && !_isPlayerBusy) {
      _isPlayerBusy = true;
      await _player.stopPlayer();
      _isPlayerBusy = false;
    }
  }

  void _updateSoundBiteDuration() {
    if (soundClips.isEmpty) return;
    soundClips.first = soundClips.first.copyWith(
      duration: _timeline.playheadPosition - soundClips.first.startTime,
    );
    notifyListeners();
  }

  Future<void> startRecording() async {
    if (_recorder == null) {
      await _initRecorder();
      if (_recorder == null) return;
    }
    soundClips.clear();
    soundClips.add(
      SoundClip(
        file: await getNewSoundClipFile(),
        startTime: _timeline.playheadPosition,
        duration: Duration.zero,
      ),
    );
    await _recorder.startRecorder(
      toFile: soundClips.first.uri,
      codec: Codec.aacADTS,
      audioSource: AudioSource.voice_communication,
    );
    _timeline.play();
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    _timeline.pause();
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _recorder?.closeAudioSession();
    await _player?.closeAudioSession();
  }
}
