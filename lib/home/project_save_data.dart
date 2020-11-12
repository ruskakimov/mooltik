class ProjectSaveData {
  ProjectSaveData({
    this.width,
    this.height,
    this.drawings,
  });

  ProjectSaveData.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        drawings = (json['drawings'] as List<dynamic>)
            .map((d) => DrawingSaveData.fromJson(d))
            .toList();

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'drawings': drawings.map((d) => d.toJson()).toList(),
      };

  final double width;
  final double height;
  final List<DrawingSaveData> drawings;
}

class DrawingSaveData {
  const DrawingSaveData({this.id, this.duration});

  DrawingSaveData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        duration = json['duration'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'duration': duration,
      };

  final int id;
  final int duration;
}
