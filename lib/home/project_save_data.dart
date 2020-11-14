class ProjectSaveData {
  ProjectSaveData({
    this.width,
    this.height,
    this.frames,
  });

  ProjectSaveData.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        frames = (json['frames'] as List<dynamic>)
            .map((d) => FrameSaveData.fromJson(d))
            .toList();

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'frames': frames.map((d) => d.toJson()).toList(),
      };

  final double width;
  final double height;
  final List<FrameSaveData> frames;
}

class FrameSaveData {
  const FrameSaveData({this.id, this.duration});

  FrameSaveData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        duration = json['duration'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'duration': duration,
      };

  final int id;
  final int duration;
}
