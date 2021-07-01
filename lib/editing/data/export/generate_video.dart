import 'dart:io';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:mooltik/common/data/iterable_methods.dart';
import 'package:path/path.dart' as p;
import 'package:mooltik/common/data/io/mp4/mp4.dart';
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';

Future<File?> generateVideo({
  required String fileName,
  required Directory tempDir,
  required Iterable<CompositeFrame> frames,
  List<SoundClip>? soundClips,
  required ProgressCallback progressCallback,
}) async {
  final videoFile = _tempFile('$fileName.mp4', tempDir);
  final slides = await _slidesFromFrames(frames, tempDir);

  final success = await mp4Write(
    videoFile,
    slides,
    soundClips!,
    tempDir,
    progressCallback,
  );

  return success ? videoFile : null;
}

Future<void> cancelGenerateVideo() async {
  await FlutterFFmpeg().cancel();
}

Future<List<Slide>> _slidesFromFrames(
  Iterable<CompositeFrame> frames,
  Directory tempDir,
) {
  return Future.wait(
    frames.mapIndexed((frame, i) async {
      final file = _tempFile('$i.png', tempDir);
      final image = await frame.toImage();

      await pngWrite(file, image);

      return Slide(file, frame.duration);
    }),
  );
}

File _tempFile(String fileName, Directory directory) =>
    File(p.join(directory.path, fileName));
