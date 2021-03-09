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

    _importing = true;
    notifyListeners();

    final soundFile = await _pickSoundFile();
    if (soundFile == null) return;

    await project.loadSoundClipFromFile(soundFile);

    _importing = false;
    notifyListeners();
  }

  Future<File> _pickSoundFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'aac',
        'flac',
        'm4a',
        'wav',
      ],
    );
    return result != null ? File(result.files.single.path) : null;
  }
}
