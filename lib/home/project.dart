import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:path/path.dart' as p;

class Project {
  Project(this.directory)
      : id = int.parse(p.basename(directory.path).split('_').last),
        _dataFile = File(p.join(directory.path, 'project_data.json'));

  final Directory directory;

  final int id;

  final File _dataFile;

  ReelModel get reel => _reel;
  ReelModel _reel;

  Future<void> open() async {
    if (await _dataFile.exists()) {
      // Existing project.
      final String contents = await _dataFile.readAsString();
      final _ProjectData data = _ProjectData.fromJson(jsonDecode(contents));
      // TODO: Read images and init ReelModel.
    } else {
      // New project.
      _reel = ReelModel();
    }
  }

  Future<void> save() async {
    final List<FrameModel> frames = _reel.frames;

    // Write project data.
    final _ProjectData data = _ProjectData(
      _reel.frameSize.width,
      _reel.frameSize.height,
      // TODO: Get id from FrameModel
      frames.map((f) => _DrawingData(f.duration, 0)).toList(),
      [_LayerData(0)],
    );
    await _dataFile.writeAsString(jsonEncode(data));

    // Write images.
    for (int i = 0; i < frames.length; i++) {
      final img = await imageFromFrame(frames[i]);
      final pngBytes = encodePng(img, level: 0);
      // TODO: Create a folder `/drawing_$id`
      // TODO: Get id from FrameModel
      final file = File(p.join(directory.path, 'frame$i.png'));
      await file.writeAsBytes(pngBytes);
    }
  }

  void close() {
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

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'drawings': drawings,
        'layers': layers,
      };

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
