import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:mooltik/editor/sound_bite.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerModel extends ChangeNotifier {
  PlayerModel({
    Directory directory,
    TimelineModel timeline,
  })  : _directory = directory,
        _timeline = timeline;

  // TODO: Move file ownership to Project, since it is responsible for project folder IO.
  final Directory _directory;

  final TimelineModel _timeline;

  FlutterSoundRecorder _recorder;

  bool get isRecording => _recorder?.isRecording ?? false;

  SoundBite get soundBite => _soundBite;
  SoundBite _soundBite;

  Future<void> _initRecorder() async {
    final permit = await Permission.microphone.request();
    if (permit != PermissionStatus.granted) return;
    _recorder = FlutterSoundRecorder();
    await _recorder.openAudioSession();
  }

  void _updateSoundBiteDuration() {
    _soundBite = _soundBite.copyWith(
      duration: _timeline.playheadPosition - _soundBite.startTime,
    );
    notifyListeners();
  }

  Future<void> startRecording() async {
    if (_recorder == null) {
      await _initRecorder();
      if (_recorder == null) return;
    }
    _soundBite = SoundBite(
      file: File('${_directory.path}/recording.aac'),
      startTime: _timeline.playheadPosition,
      duration: Duration.zero,
    );
    _timeline.addListener(_updateSoundBiteDuration);
    await _recorder.startRecorder(
      toFile: _soundBite.file.path,
      codec: Codec.aacADTS,
      audioSource: AudioSource.voice_communication,
    );
    _timeline.play();
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    _timeline.pause();
    _timeline.removeListener(_updateSoundBiteDuration);
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _recorder.closeAudioSession();
  }
}
