import 'dart:io';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:path/path.dart' as p;

class Project {
  Project(this.directory)
      : id = int.parse(p.basename(directory.path).split('_').last);

  final Directory directory;

  final int id;

  _ProjectData _projectData;
  ReelModel _reel;

  Future<void> open() async {
    // TODO: Read project_data.json
  }
}

class _ProjectData {
  _ProjectData(this.width, this.height, this.drawings);

  final double width;
  final double height;
  final List<_DrawingData> drawings;
}

class _DrawingData {
  _DrawingData(this.duration, this.id);

  final int duration;
  final int id;
}
