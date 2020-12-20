import 'package:mooltik/common/parse_duration.dart';
import 'package:mooltik/editor/sound_clip.dart';

class ProjectSaveData {
  ProjectSaveData({
    this.width,
    this.height,
    this.frames,
    this.sounds,
  });

  ProjectSaveData.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        frames = (json['frames'] as List<dynamic>)
            .map((d) => FrameSaveData.fromJson(d))
            .toList(),
        sounds = (json['sounds'] as List<dynamic>)
            .map((d) => SoundClip.fromJson(d))
            .toList();

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'frames': frames.map((d) => d.toJson()).toList(),
        'sounds': sounds.map((d) => d.toJson()).toList(),
      };

  final double width;
  final double height;
  final List<FrameSaveData> frames;
  final List<SoundClip> sounds;
}

class FrameSaveData {
  const FrameSaveData({this.id, this.duration});

  FrameSaveData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        duration = parseDuration(json['duration']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'duration': duration.toString(),
      };

  // TODO: Save file path instead. This will allow changing project folder structure.
  final int id;
  final Duration duration;
}
