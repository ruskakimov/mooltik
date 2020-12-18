import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:mooltik/editor/sound_bite.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerModel extends ChangeNotifier {
  PlayerModel(this.directory);

  // TODO: Move file ownership to Project, since it is responsible for project folder IO.
  final Directory directory;

  FlutterSoundRecorder _recorder;

  bool get isRecording => _recorder?.isRecording ?? false;

  SoundBite get soundBite => _soundBite;
  SoundBite _soundBite = SoundBite(
    file: null,
    startTime: Duration(seconds: 1),
    duration: Duration(seconds: 2),
  );

  Future<void> initRecorder() async {
    final permit = await Permission.microphone.request();
    if (permit != PermissionStatus.granted) return;
    _recorder = FlutterSoundRecorder();
    await _recorder.openAudioSession();
  }

  Future<void> startRecording() async {
    if (_recorder == null) {
      await initRecorder();
      if (_recorder == null) return;
    }
    await _recorder.startRecorder(
      toFile: '${directory.path}/recording.aac',
      codec: Codec.aacADTS,
      audioSource: AudioSource.voice_communication,
    );
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _recorder.closeAudioSession();
  }
}
