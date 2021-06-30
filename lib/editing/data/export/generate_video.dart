import 'dart:io';

import 'package:mooltik/common/data/iterable_methods.dart';
import 'package:path/path.dart' as p;
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/io/mp4/mp4.dart';
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';

Future<File> generateVideo({
  required String fileName,
  required Directory tempDir,
  required Iterable<CompositeFrame> frames,
  List<SoundClip>? soundClips,
  required ProgressCallback progressCallback,
}) async {
  final videoFile = _tempFile('$fileName.mp4', tempDir);
  final slides = await _slidesFromFrames(frames, tempDir);

  await mp4Write(
    videoFile,
    slides,
    soundClips!,
    tempDir,
    progressCallback,
  );

  return videoFile;
}

Future<List<Slide>> _slidesFromFrames(
  Iterable<CompositeFrame> frames,
  Directory tempDir,
) async {
  return await Future.wait(
    frames.mapIndexed((frame, i) {
      final png = File(p.join(tempDir.path, '$i.png'));
      return _slideFromFrame(frame, png);
    }),
  );
}

Future<Slide> _slideFromFrame(CompositeFrame frame, File pngFile) async {
  final image = await generateImage(
    CompositeImagePainter(frame.compositeImage),
    frame.width,
    frame.height,
  );
  await pngWrite(pngFile, image);
  return Slide(pngFile, frame.duration);
}

File _tempFile(String fileName, Directory directory) =>
    File(p.join(directory.path, fileName));
