import 'package:flutter/material.dart';

class ExporterModel extends ChangeNotifier {
  /// Value between 0 and 1 that indicates video export progress.
  /// 0 - export hasn't began
  /// 1 - video exported successfully.
  double get progress => _progress;
  double _progress = 0;

  bool get isNotStarted => _progress == 0;

  void start() {
    // get temp directory
    // timeline.frames -> images
    // write PNGs (cannot use project pngs, cos they have transparent bg)
    // mp4Write(slides, file, temp)
    // await ImageGallerySaver.saveFile(video.path);
  }
}
