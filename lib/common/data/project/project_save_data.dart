import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

class ProjectSaveData {
  ProjectSaveData({
    this.width,
    this.height,
    this.frames,
    this.sounds,
  });

  ProjectSaveData.fromJson(Map<String, dynamic> json, String soundDirPath)
      : width = json['width'],
        height = json['height'],
        frames = (json['frames'] as List<dynamic>)
            .map((d) => FrameModel.fromJson(
                  d,
                  Size(json['width'], json['height']),
                ))
            .toList(),
        sounds = json['sounds'] != null
            ? (json['sounds'] as List<dynamic>)
                .map((d) => SoundClip.fromJson(d, soundDirPath))
                .toList()
            : [];

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'frames': frames.map((d) => d.toJson()).toList(),
        'sounds': sounds.map((d) => d.toJson()).toList(),
      };

  final double width;
  final double height;
  final List<FrameModel> frames;
  final List<SoundClip> sounds;
}
