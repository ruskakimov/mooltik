import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';

class ImporterModel extends ChangeNotifier {
  /// Whether import is in progress.
  bool get importing => _importing;
  bool _importing = false;

  /// Imports audio to project.
  /// Wrap in try-catch to handle bad input.
  Future<void> importAudioTo(Project project) async {
    if (_importing) return;

    final soundFile = await _pickSoundFile();

    // User closed picker.
    if (soundFile == null) return;

    _importing = true;
    notifyListeners();

    try {
      await project.loadSoundClipFromFile(soundFile);
    } catch (e) {
      rethrow;
    } finally {
      _importing = false;
      notifyListeners();
    }
  }

  Future<File?> _pickSoundFile() async {
    final iosAllowedExtensions = ['mp3', 'aac', 'flac', 'm4a', 'wav', 'ogg'];

    final result = await FilePicker.platform.pickFiles(
      // Audio type opens Apple Music on iOS, which doesn't allow you import downloaded sounds.
      // Custom type opens Files app instead.
      type: Platform.isIOS ? FileType.custom : FileType.audio,
      allowedExtensions: Platform.isIOS ? iosAllowedExtensions : null,
    );

    if (result == null || result.files.isEmpty) return null;

    return File(result.files.first.path!);
  }
}
