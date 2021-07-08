import 'dart:io';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:mooltik/editing/data/export/generator.dart';
import 'package:mooltik/common/data/iterable_methods.dart';
import 'package:mooltik/common/data/io/mp4/mp4.dart';
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';

class VideoGenerator extends Generator {
  VideoGenerator({
    required this.fileName,
    required this.frames,
    required this.soundClips,
    required this.progressCallback,
    required Directory temporaryDirectory,
  }) : super(temporaryDirectory);

  final String fileName;
  final Iterable<CompositeFrame> frames;
  final List<SoundClip> soundClips;
  final ProgressCallback progressCallback;

  @override
  Future<File?> generate() async {
    final videoFile = makeTemporaryFile('$fileName.mp4');
    final slides = await _slidesFromFrames(frames);

    if (isCancelled) return null;

    final success = await mp4Write(
      videoFile,
      slides,
      soundClips,
      temporaryDirectory,
      progressCallback,
    );

    return success ? videoFile : null;
  }

  @override
  Future<void> cancel() async {
    if (isCancelled) return;
    super.cancel();
    await FlutterFFmpeg().cancel();
  }

  Future<List<Slide>> _slidesFromFrames(Iterable<CompositeFrame> frames) {
    return Future.wait(
      frames.mapIndexed((frame, i) async {
        final file = makeTemporaryFile('$i.png');
        final image = await frame.toImage();

        await pngWrite(file, image);

        return Slide(file, frame.duration);
      }),
    );
  }
}
