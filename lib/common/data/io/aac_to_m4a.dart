import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

/// Wraps raw AAC with M4A container.
/// Raw AAC doesn't support seeking, therefore it is unusable.
Future<void> aacToM4a(File inputAAC, File outputM4A) async {
  assert(p.extension(inputAAC.path) == '.aac');
  assert(p.extension(outputM4A.path) == '.m4a');

  final command = '-i ${inputAAC.path} -codec: copy ${outputM4A.path}';
  final code = await FlutterFFmpeg().execute(command);

  if (code != 0) {
    throw Exception('Could not convert AAC to M4A, error code: $code');
  }
}
