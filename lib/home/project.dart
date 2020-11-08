import 'dart:io';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:path/path.dart' as p;

class Project {
  Project(this.directory)
      : id = int.parse(p.basename(directory.path).split('_').last);

  final Directory directory;

  final int id;

  ReelModel get reel => _reel;
  ReelModel _reel;

  Future<void> open() async {
    // Read frames
    // 1) size
    // 2) initial frames
  }

  Future<void> save() async {
    // Write frames
  }

  void close() {
    // Free memory
  }
}
