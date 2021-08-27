import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:path/path.dart' as p;
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/mp4/ffmpeg_helpers.dart';

typedef void ProgressCallback(double progress);

/// Constructs mp4 from slides and returns `true` if it was successful.
Future<bool> mp4Write(
  File mp4File,
  List<Slide> slides,
  List<SoundClip> soundClips,
  Directory tempDir,
  ProgressCallback progressCallback,
) async {
  assert(slides.isNotEmpty);

  final concatFile = File(p.join(tempDir.path, 'concat.txt'));
  await concatFile.writeAsString(ffmpegSlideshowConcatDemuxer(slides));

  final config = FlutterFFmpegConfig();
  config.resetStatistics();

  final Duration videoDuration = slides.fold(
    Duration.zero,
    (duration, slide) => duration + slide.duration,
  );

  config.enableStatisticsCallback((Statistics stats) {
    progressCallback.call(stats.time / videoDuration.inMilliseconds);
    FirebaseCrashlytics.instance.log(stats.toLog());
  });

  final command = ffmpegCommand(
    concatDemuxerPath: concatFile.path,
    soundClipPath: soundClips.isNotEmpty ? soundClips.first.file.path : null,
    soundClipOffset: soundClips.isNotEmpty ? soundClips.first.startTime : null,
    outputPath: mp4File.path,
    videoDuration: videoDuration,
  );

  FirebaseCrashlytics.instance.log(command);

  final code = await FlutterFFmpeg().execute(command);

  FirebaseCrashlytics.instance.log('FFmpeg exit code: $code');

  // TODO: Report error to crashlytics

  return code == 0;
}

extension StatisticsLog on Statistics {
  String toLog() {
    return 'FFmpeg stats: executionId: $executionId, time: $time, size: $size, bitrate: $bitrate, speed: $speed, videoFrameNumber: $videoFrameNumber, videoQuality: $videoQuality, videoFps: $videoFps';
  }
}
