import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/editing/data/export/generate_video.dart';
import 'package:mooltik/editing/data/export/save_video_to_gallery.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;

import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:share_plus/share_plus.dart';

enum ExportOption {
  video,
  images,
}

enum ExporterState {
  initial,
  exporting,
  done,
}

class ExporterModel extends ChangeNotifier {
  ExporterModel({
    required this.frames,
    required this.soundClips,
    required this.tempDir,
  });

  /// For output video.
  final Iterable<CompositeFrame> frames;

  /// For output audio.
  final List<SoundClip>? soundClips;

  /// Temporary directory to store intermediate results.
  final Directory tempDir;

  /// User selected export output option.
  ExportOption get selectedOption => _selectedOption;
  ExportOption _selectedOption = ExportOption.video;

  void onExportOptionChanged(ExportOption? option) {
    if (option == null) return;
    _selectedOption = option;
    notifyListeners();
  }

  /// Value between 0 and 1 that indicates video export progress.
  double get progress => _progress;
  double _progress = 0;

  bool get isInitial => _state == ExporterState.initial;
  bool get isExporting => state == ExporterState.exporting;
  bool get isDone => state == ExporterState.done;

  ExporterState get state => _state;
  ExporterState _state = ExporterState.initial;

  File? outputFile;

  String get videoFileName => _videoFileName;
  String _videoFileName = '${DateTime.now().millisecondsSinceEpoch}';
  set videoFileName(String name) {
    if (name.isEmpty) throw ArgumentError.value(name);
    _videoFileName = name;
    notifyListeners();
  }

  Future<void> start() async {
    _state = ExporterState.exporting;
    notifyListeners();

    // Wait for animation.
    await Future.delayed(Duration(milliseconds: 250));

    outputFile = await generateVideo(
      fileName: _videoFileName,
      tempDir: tempDir,
      frames: frames,
      soundClips: soundClips,
      progressCallback: _onProgressUpdate,
    );

    if (outputFile != null) {
      await saveVideoToGallery(outputFile!.path);
      _finish();
    } else {
      _reset();
    }

    notifyListeners();
  }

  void _onProgressUpdate(double progress) {
    _progress = progress;
    notifyListeners();
  }

  void _reset() {
    _progress = 0;
    _state = ExporterState.initial;
  }

  void _finish() {
    _progress = 1; // in case ffmpeg statistics callback didn't finish on 100%
    _state = ExporterState.done;
  }

  void cancel() {
    cancelGenerateVideo();
  }

  Future<void> openOutputFile() async {
    if (outputFile == null) return;
    await OpenFile.open(p.fromUri(outputFile!.path));
  }

  Future<void> shareOutputFile() async {
    if (outputFile == null) return;
    await Share.shareFiles([outputFile!.path]);
  }
}
