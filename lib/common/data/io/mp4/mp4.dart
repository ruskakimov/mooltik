import 'dart:io';
import 'package:mooltik/common/data/io/mp4/slide.dart';

Future<void> mp4Write(File mp4File, List<Slide> slides) {
  assert(slides != null && slides.isNotEmpty);

  _getConcatDemuxer(slides);
}

String _getConcatDemuxer(List<Slide> slides) {
  String concatDemuxer = '';
  for (final slide in slides) {
    concatDemuxer += '''
      file '${slide.pngImage.path}'
      duration ${_formatDuration(slide.duration)}
    ''';
  }

  // Due to a quirk, the last image has to be specified twice - the 2nd time without any duration directive.
  // Source: https://trac.ffmpeg.org/wiki/Slideshow
  concatDemuxer += '''
    file '${slides.last.pngImage.path}'
  ''';

  return concatDemuxer;
}

String _formatDuration(Duration duration) => '${duration.inMilliseconds}ms';
