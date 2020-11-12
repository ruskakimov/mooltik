import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:mooltik/home/project_save_data.dart';
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
      final contents = await _dataFile.readAsString();
      final data = ProjectSaveData.fromJson(jsonDecode(contents));
      final drawingSize = Size(data.width, data.height);

      _reel = ReelModel(
        frameSize: drawingSize,
        initialFrames: await Future.wait(
          data.drawings.map((drawing) => _getFrame(drawing, drawingSize)),
        ),
      );
    } else {
      // New project.
      _reel = ReelModel();
    }
  }

  Future<FrameModel> _getFrame(DrawingSaveData drawing, Size size) async {
    final file = _getDrawingFile(drawing.id);
    final bytes = await file.readAsBytes();
    decodePng(bytes);
    return FrameModel(
      id: drawing.id,
      duration: drawing.duration,
      size: size,
      // TODO: Convert image.Image to ui.Image
      // initialSnapshot: decodePng(bytes),
    );
  }

  Future<void> save() async {
    final List<FrameModel> frames = _reel.frames;

    // Write project data.
    final data = ProjectSaveData(
      width: _reel.frameSize.width,
      height: _reel.frameSize.height,
      drawings: frames
          .map((f) => DrawingSaveData(id: f.id, duration: f.duration))
          .toList(),
    );
    await _dataFile.writeAsString(jsonEncode(data));

    // Write images.
    for (final frame in frames) {
      final img = await imageFromFrame(frame);
      final pngBytes = encodePng(img, level: 0);
      final file = _getDrawingFile(frame.id);
      await file.writeAsBytes(pngBytes);
    }
  }

  void close() {
    _reel = null;
  }

  File _getDrawingFile(int id) =>
      File(p.join(directory.path, 'drawing$id.png'));
}
