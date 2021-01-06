import 'dart:ui';

import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';

Future<Image> imageFromFrame(FrameModel frame) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  FramePainter(frame: frame).paint(canvas, Size(frame.width, frame.height));
  final picture = recorder.endRecording();
  return picture.toImage(frame.width.toInt(), frame.height.toInt());
}
