import 'dart:io';
import 'dart:ui';

import 'package:mooltik/common/data/io/image.dart';

Future<Image> pngRead(File pngFile) async {
  final bytes = await pngFile.readAsBytes();
  return imageFromFileBytes(bytes);
}

Future<void> pngWrite(File pngFile, Image image) async {
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  await pngFile.writeAsBytes(byteData!.buffer.asUint8List(), flush: true);
}
