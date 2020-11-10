import 'dart:convert';
import 'dart:io';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:path/path.dart' as p;

// Scenario 1: new project
// Scenario 2: existing project (read from files)
class Project {
  Project(this.directory)
      : id = int.parse(p.basename(directory.path).split('_').last);

  final Directory directory;

  final int id;

  _ProjectData _projectData;
  ReelModel _reel;

  Future<void> open() async {
    final File dataFile = File(p.join(directory.path, 'project_data.json'));

    if (await dataFile.exists()) {
      final String contents = await dataFile.readAsString();
      _projectData = _ProjectData.fromJson(jsonDecode(contents));
    }
  }

  Future<void> write() async {}

  void close() {
    _projectData = null;
    _reel = null;
  }
}

class _ProjectData {
  _ProjectData(this.width, this.height, this.drawings, this.layers);

  _ProjectData.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        drawings = json['drawings'],
        layers = json['layers'];

  final double width;
  final double height;
  final List<_DrawingData> drawings;
  final List<_LayerData> layers;
}

class _DrawingData {
  _DrawingData(this.duration, this.id);

  final int duration;
  final int id;
}

class _LayerData {
  _LayerData(this.id);

  final int id;
}
