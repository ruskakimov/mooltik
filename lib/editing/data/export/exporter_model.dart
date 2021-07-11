import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/editing/data/export/generators/generator.dart';
import 'package:mooltik/editing/data/export/generators/images_archive_generator.dart';
import 'package:mooltik/editing/data/export/save_video_to_gallery.dart';
import 'package:mooltik/editing/data/export/generators/video_generator.dart';
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
    required this.videoExportFrames,
    required this.imagesExportFrames,
    required this.soundClips,
    required this.tempDir,
  }) {
    _selectedFrames.addAll(imagesExportFrames.expand((frames) => frames));
  }

  /// Frames for video export option.
  final Iterable<CompositeFrame> videoExportFrames;

  /// Frames for images export option. Frames are listed scene-by-scene.
  final List<List<CompositeFrame>> imagesExportFrames;

  final List<SoundClip>? soundClips;

  /// Temporary directory to store intermediate results.
  final Directory tempDir;

  /// User selected export output option.
  ExportOption get selectedOption => _selectedOption;
  ExportOption _selectedOption = ExportOption.video;

  bool get isVideoExport => _selectedOption == ExportOption.video;
  bool get isImagesExport => _selectedOption == ExportOption.images;

  void onExportOptionChanged(ExportOption? option) {
    if (option == null) return;
    _selectedOption = option;
    notifyListeners();
  }

  CompositeImage get videoPreviewImage =>
      videoExportFrames.first.compositeImage;

  /// Value between 0 and 1 that indicates video export progress.
  double get progress => _progress;
  double _progress = 0;

  bool get isInitial => _state == ExporterState.initial;
  bool get isExporting => state == ExporterState.exporting;
  bool get isDone => state == ExporterState.done;

  ExporterState get state => _state;
  ExporterState _state = ExporterState.initial;

  Generator? generator;
  File? outputFile;

  Future<void> start() async {
    _state = ExporterState.exporting;
    notifyListeners();

    // HACK: Waits for UI animation.
    await Future.delayed(Duration(milliseconds: 250));

    generator = isVideoExport
        ? VideoGenerator(
            videoName: _fileName,
            frames: videoExportFrames,
            soundClips: soundClips!,
            progressCallback: _onProgressUpdate,
            temporaryDirectory: tempDir,
          )
        : ImagesArchiveGenerator(
            archiveName: _fileName,
            framesSceneByScene: imagesExportFrames
                .map((sceneFrames) => sceneFrames
                    .where((frame) => _selectedFrames.contains(frame))
                    .toList())
                .toList(),
            progressCallback: _onProgressUpdate,
            temporaryDirectory: tempDir,
          );

    outputFile = await generator!.generate();

    if (outputFile != null) {
      if (isVideoExport) await saveVideoToGallery(outputFile!.path);
      _finish();
    }

    notifyListeners();
  }

  void _onProgressUpdate(double progress) {
    if (generator == null || generator!.isCancelled) return;
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
    generator?.cancel();
    _reset();
    notifyListeners();
  }

  Future<void> openOutputFile() async {
    if (outputFile == null) return;
    await OpenFile.open(p.fromUri(outputFile!.path));
  }

  Future<void> shareOutputFile(Rect iPadSharePositionOrigin) async {
    if (outputFile == null) return;
    await Share.shareFiles(
      [outputFile!.path],
      sharePositionOrigin: iPadSharePositionOrigin,
    );
  }

  // ==========
  // Form data:
  // ==========

  /// Output file name.
  String get fileName => _fileName;
  String _fileName = '${DateTime.now().millisecondsSinceEpoch}';

  set fileName(String name) {
    if (name.isEmpty) throw ArgumentError.value(name);

    _fileName = name;
    notifyListeners();
  }

  /// Frames selected for images export.
  Set<CompositeFrame> get selectedFrames => _selectedFrames;
  Set<CompositeFrame> _selectedFrames = Set();

  set selectedFrames(Set<CompositeFrame> selected) {
    if (selected.isEmpty)
      throw ArgumentError('Selected frames must not be empty.');

    _selectedFrames = selected;
    notifyListeners();
  }
}
