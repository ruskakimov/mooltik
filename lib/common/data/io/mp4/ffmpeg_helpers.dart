import 'package:mooltik/common/data/io/mp4/slide.dart';

String ffmpegSlideshowConcatDemuxer(List<Slide> slides) {
  String concatDemuxer = '';
  for (final slide in slides) {
    concatDemuxer += '''
      file '${slide.pngImage.path}'
      duration ${ffmpegDurationLabel(slide.duration)}
    ''';
  }

  // Due to a quirk, the last image has to be specified twice - the 2nd time without any duration directive.
  // Source: https://trac.ffmpeg.org/wiki/Slideshow
  concatDemuxer += '''
    file '${slides.last.pngImage.path}'
  ''';

  return concatDemuxer;
}

String ffmpegDurationLabel(Duration duration) => '${duration.inMilliseconds}ms';

String ffmpegCommand({
  String concatDemuxerPath,
  String soundClipPath,
  Duration soundClipOffset,
  String outputPath,
  Duration videoDuration,
}) {
  final globalOptions = '-y';
  final videoInput = '-f concat -safe 0 -i $concatDemuxerPath';
  final audioInput = soundClipPath != null
      ? '-itsoffset ${ffmpegDurationLabel(soundClipOffset)} -i $soundClipPath'
      : '';
  final output =
      '-vf fps=50 -pix_fmt yuv420p -t ${ffmpegDurationLabel(videoDuration)} $outputPath';
  return '$globalOptions $videoInput $audioInput $output';
}
