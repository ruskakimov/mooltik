import 'dart:io';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:path/path.dart' as p;
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/mp4/ffmpeg_helpers.dart';

typedef void ProgressCallback(double progress);

Future<void> mp4Write(
  File mp4File,
  List<Slide> slides,
  List<SoundClip> soundClips,
  Directory tempDir,
  ProgressCallback progressCallback,
) async {
  assert(slides != null && slides.isNotEmpty);

  final concatFile = File(p.join(tempDir.path, 'concat.txt'));
  await concatFile.writeAsString(ffmpegSlideshowConcatDemuxer(slides));

  final config = FlutterFFmpegConfig();
  await config.resetStatistics();
  int totalTime;

  config.enableStatisticsCallback((Statistics stats) {
    if (totalTime == null) {
      totalTime = stats.time;
    } else {
      progressCallback?.call(stats.time / totalTime);
    }
  });

  final Duration videoDuration = slides.fold(
    Duration.zero,
    (duration, slide) => duration + slide.duration,
  );

  await FlutterFFmpeg().execute(ffmpegCommand(
    concatDemuxerPath: concatFile.path,
    soundClipPath: soundClips.isNotEmpty ? soundClips.first.file.path : null,
    soundClipOffset: soundClips.isNotEmpty ? soundClips.first.startTime : null,
    outputPath: mp4File.path,
    videoDuration: videoDuration,
  ));
}
