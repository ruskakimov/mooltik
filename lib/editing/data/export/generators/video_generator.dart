import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:mooltik/editing/data/export/generators/generator.dart';
import 'package:mooltik/common/data/io/mp4/mp4.dart';
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';

const _imagesProgressFraction = 0.5;
const _ffmpegProgressFraction = 1.0 - _imagesProgressFraction;

class VideoGenerator extends Generator {
  VideoGenerator({
    required this.videoName,
    required this.frames,
    required this.soundClips,
    required this.progressCallback,
    required Directory temporaryDirectory,
  }) : super(temporaryDirectory);

  final String videoName;
  final Iterable<CompositeFrame> frames;
  final List<SoundClip> soundClips;
  final ProgressCallback progressCallback;

  bool _isRunningFfmpeg = false;

  @override
  Future<File?> generate() async {
    final videoFile = makeTemporaryFile('$videoName.mp4');

    if (isCancelled) return null;
    final slides = await _slidesFromFrames(frames.toList());

    if (isCancelled || slides == null) return null;

    final success = await _runFFmpeg(videoFile, slides);

    return success && !isCancelled ? videoFile : null;
  }

  Future<bool> _runFFmpeg(File videoFile, List<Slide> slides) async {
    _isRunningFfmpeg = true;
    var success = false;

    try {
      success = await mp4Write(
        videoFile,
        slides,
        soundClips,
        temporaryDirectory,
        _ffmpegProgressCallback,
      );
    } catch (e, stack) {
      await FirebaseCrashlytics.instance.recordError(e, stack);
    } finally {
      _isRunningFfmpeg = false;
    }

    return success;
  }

  void _ffmpegProgressCallback(double ffmpegProgress) {
    return progressCallback(
      _imagesProgressFraction + ffmpegProgress * _ffmpegProgressFraction,
    );
  }

  @override
  Future<void> cancel() async {
    if (isCancelled) return;
    super.cancel();
    if (_isRunningFfmpeg) await FlutterFFmpeg().cancel();
  }

  Future<List<Slide>?> _slidesFromFrames(
    List<CompositeFrame> frames,
  ) async {
    final slides = <Slide>[];

    for (int i = 0; i < frames.length; i++) {
      final file = makeTemporaryFile('$i.png');

      final image = await frames[i].toImage();
      FirebaseCrashlytics.instance.log('Generated image $i in memory');

      if (isCancelled) {
        image.dispose();
        return null;
      }

      await pngWrite(file, image);
      image.dispose();

      progressCallback(_imagesProgressFraction * i / frames.length);
      FirebaseCrashlytics.instance.log('$i/${frames.length} ${file.path}');

      slides.add(Slide(file, frames[i].duration));
    }

    return slides;
  }
}
