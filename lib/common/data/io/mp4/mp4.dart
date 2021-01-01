import 'dart:io';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path/path.dart' as p;
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/mp4/slideshow_concat_demuxer.dart';

Future<void> mp4Write(
  File mp4File,
  List<Slide> slides,
  Directory tempDir,
) async {
  assert(slides != null && slides.isNotEmpty);

  final concatFile = File(p.join(tempDir.path, 'concat.txt'));
  await concatFile.writeAsString(slideshowConcatDemuxer(slides));

  await FlutterFFmpeg().execute(
    '-y -f concat -safe 0 -i ${concatFile.path} -vf fps=24 -pix_fmt yuv420p ${mp4File.path}',
  );
}
