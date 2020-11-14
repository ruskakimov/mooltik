import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:mooltik/home/png.dart';
import 'package:mooltik/home/project_save_data.dart';
import 'package:path/path.dart' as p;

class Project {
  Project(this.directory)
      : id = int.parse(p.basename(directory.path).split('_').last),
        thumbnail = File(p.join(directory.path, 'thumbnail.png')),
        _dataFile = File(p.join(directory.path, 'project_data.json'));

  final Directory directory;

  final int id;

  final File thumbnail;

  final File _dataFile;

  ReelModel get reel => _reel;
  ReelModel _reel;

  Future<void> open() async {
    if (await _dataFile.exists()) {
      // Existing project.
      final contents = await _dataFile.readAsString();
      final data = ProjectSaveData.fromJson(jsonDecode(contents));
      final frameSize = Size(data.width, data.height);

      _reel = ReelModel(
        frameSize: frameSize,
        initialFrames: await Future.wait(
          data.frames.map((frameData) => _getFrame(frameData, frameSize)),
        ),
      );
    } else {
      // New project.
      _reel = ReelModel();
    }
  }

  Future<FrameModel> _getFrame(FrameSaveData frameData, Size size) async {
    final file = _getFrameFile(frameData.id);
    return FrameModel(
      id: frameData.id,
      duration: frameData.duration,
      size: size,
      initialSnapshot: await pngRead(file),
    );
  }

  Future<void> save() async {
    final List<FrameModel> frames = _reel.frames;

    // Write project data.
    final data = ProjectSaveData(
      width: _reel.frameSize.width,
      height: _reel.frameSize.height,
      frames: frames
          .map((f) => FrameSaveData(id: f.id, duration: f.duration))
          .toList(),
    );
    await _dataFile.writeAsString(jsonEncode(data));

    // Write images.
    await Future.wait(
      frames.map(
        (frame) => pngWrite(
          _getFrameFile(frame.id),
          frame.snapshot,
        ),
      ),
    );

    // Write thumbnail.
    await pngWrite(thumbnail, frames.first.snapshot);
  }

  void close() {
    _reel = null;
  }

  File _getFrameFile(int id) => File(p.join(directory.path, 'frame$id.png'));
}
