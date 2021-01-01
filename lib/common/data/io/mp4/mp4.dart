import 'dart:io';
import 'package:mooltik/common/data/io/mp4/slide.dart';
import 'package:mooltik/common/data/io/mp4/slide_concat_demuxer.dart';

Future<void> mp4Write(File mp4File, List<Slide> slides) {
  assert(slides != null && slides.isNotEmpty);

  generateSlideConcatDemuxer(slides);
}
