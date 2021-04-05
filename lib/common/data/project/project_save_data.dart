import 'package:mooltik/common/data/project/scene_model.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';

class ProjectSaveData {
  ProjectSaveData({
    this.width,
    this.height,
    this.scenes,
    this.sounds,
  });

  ProjectSaveData.fromJson(
    Map<String, dynamic> json,
    String frameDirPath,
    String soundDirPath,
  )   : width = json['width'],
        height = json['height'],
        scenes = (json['scenes'] as List<dynamic>)
            .map((d) => SceneModel.fromJson(d, frameDirPath))
            .toList(),
        sounds = json['sounds'] != null
            ? (json['sounds'] as List<dynamic>)
                .map((d) => SoundClip.fromJson(d, soundDirPath))
                .toList()
            : [];

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'scenes': scenes.map((d) => d.toJson()).toList(),
        'sounds': sounds.map((d) => d.toJson()).toList(),
      };

  final double width;
  final double height;
  final List<SceneModel> scenes;
  final List<SoundClip> sounds;
}
