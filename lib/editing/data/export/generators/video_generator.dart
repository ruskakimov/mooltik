import 'dart:io';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:mooltik/editing/data/export/generators/generator.dart';
import 'package:mooltik/common/data/iterable_methods.dart';
import 'package:mooltik/common/data/io/mp4/mp4.dart';
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';

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
    final slides = await _slidesFromFrames(frames);

    if (isCancelled || slides == null) return null;
    _isRunningFfmpeg = true;
    final success = await mp4Write(
      videoFile,
      slides,
      soundClips,
      temporaryDirectory,
      progressCallback,
    );
    _isRunningFfmpeg = false;

    return success && !isCancelled ? videoFile : null;
  }

  @override
  Future<void> cancel() async {
    if (isCancelled) return;
    super.cancel();
    if (_isRunningFfmpeg) await FlutterFFmpeg().cancel();
  }

  Future<List<Slide>?> _slidesFromFrames(
    Iterable<CompositeFrame> frames,
  ) async {
    List<Slide>? result;

    try {
      result = await Future.wait(
        frames.mapIndexed((frame, i) async {
          if (isCancelled) throw Exception('Cancelled.');
          final file = makeTemporaryFile('$i.png');

          if (isCancelled) throw Exception('Cancelled.');
          final image = await frame.toImage();

          if (isCancelled) throw Exception('Cancelled.');
          print('Schedule writing PNG to ${file.path}');
          await pngWrite(file, image);
          print('Finished writing PNG to ${file.path}');

          return Slide(file, frame.duration);
        }),
        eagerError: true,
      );
    } catch (e) {
      result = null;
    }

    return result;
  }
}
