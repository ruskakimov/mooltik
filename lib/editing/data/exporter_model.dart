import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mooltik/common/data/io/mp4/mp4.dart';
import 'package:path/path.dart' as p;
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/drawing/data/frame/image_from_frame.dart';

enum ExporterState {
  initial,
  exporting,
  done,
}

class ExporterModel extends ChangeNotifier {
  ExporterModel({
    @required this.frames,
    @required this.soundClips,
    @required this.tempDir,
  });

  /// For output video.
  final List<FrameModel> frames;

  /// For output audio.
  final List<SoundClip> soundClips;

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

  Future<void> start() async {
    _state = ExporterState.exporting;
    notifyListeners();

    final videoFile = _tempFile('mooltik_video.mp4');
    final slides = await Future.wait(
      frames.map((frame) => _slideFromFrame(frame)),
    );

    await mp4Write(
      videoFile,
      slides,
      soundClips,
      tempDir,
      (double progress) {
        _progress = progress;
        notifyListeners();
      },
    );

    await ImageGallerySaver.saveFile(videoFile.path);

    _progress = 1; // in case ffmpeg statistics callback didn't finish on 100%
    _state = ExporterState.done;
    notifyListeners();
  }

  Future<Slide> _slideFromFrame(FrameModel frame) async {
    final image = await imageFromFrame(frame);
    final pngFile = _tempFile('${frame.id}.png');
    await pngWrite(pngFile, image);
    return Slide(pngFile, frame.duration);
  }

  File _tempFile(String fileName) => File(p.join(tempDir.path, fileName));
}
