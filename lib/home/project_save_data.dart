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
        duration = _parseDuration(json['duration']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'duration': duration.toString(),
      };

  // TODO: Save file path instead. This will allow changing project folder structure.
  final int id;
  final Duration duration;
}

Duration _parseDuration(String source) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = source.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}
