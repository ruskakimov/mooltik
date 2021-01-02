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
  /// 0 - export hasn't began
  /// 1 - video exported successfully.
  double get progress => _progress;
  double _progress = 0;

  bool get isNotStarted => _progress == 0;

  Future<void> start() async {
    _progress = 0.1;
    notifyListeners();

    final videoFile = _tempFile('mooltik_video.mp4');
    final slides = await Future.wait(
      frames.map((frame) => _slideFromFrame(frame)),
    );
    await mp4Write(videoFile, slides, tempDir);

    await ImageGallerySaver.saveFile(videoFile.path);

    _progress = 1;
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
