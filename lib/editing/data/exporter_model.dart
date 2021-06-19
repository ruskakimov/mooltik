import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/io/mp4/mp4.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';

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

  /// Value between 0 and 1 that indicates video export progress.
  double get progress => _progress;
  double _progress = 0;

  bool get isInitial => _state == ExporterState.initial;
  bool get isExporting => state == ExporterState.exporting;
  bool get isDone => state == ExporterState.done;

  ExporterState get state => _state;
  ExporterState _state = ExporterState.initial;

  String? _outputFilePath;

  Future<void> start() async {
    _state = ExporterState.exporting;
    notifyListeners();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final videoFile = _tempFile('mooltik_video_$timestamp.mp4');
    final slides = await Future.wait(
      frames.map((frame) => _slideFromFrame(frame)),
    );

    await mp4Write(
      videoFile,
      slides,
      soundClips!,
      tempDir,
      (double progress) {
        _progress = progress;
        notifyListeners();
      },
    );

    await _saveToGallery(videoFile.path);

    _outputFilePath = videoFile.path;
    _progress = 1; // in case ffmpeg statistics callback didn't finish on 100%
    _state = ExporterState.done;
    notifyListeners();
  }

  Future<void> _saveToGallery(String path) async {
    try {
      final success =
          await GallerySaver.saveVideo(path).timeout(Duration(seconds: 5));

      if (success != true) {
        throw Exception(
            'Failed when tried uploading video to the gallery. Return value: $success');
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> openOutputFile() async {
    if (_outputFilePath == null) return;
    OpenFile.open(p.fromUri(_outputFilePath));
  }

  int _slideCount = 0;

  Future<Slide> _slideFromFrame(CompositeFrame frame) async {
    final image = await generateImage(
      CompositeImagePainter(frame.compositeImage),
      frame.width,
      frame.height,
    );
    final pngFile = _tempFile('${_slideCount++}.png');
    await pngWrite(pngFile, image);
    return Slide(pngFile, frame.duration);
  }

  File _tempFile(String fileName) => File(p.join(tempDir.path, fileName));
}
