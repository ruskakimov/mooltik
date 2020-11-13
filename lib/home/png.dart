import 'dart:io';
import 'dart:ui';

Future<Image> pngRead(File pngFile) async {
  final bytes = await pngFile.readAsBytes();
  final codec = await instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}

Future<File> pngWrite(File pngFile, Image image) async {}
