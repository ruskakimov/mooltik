class ProjectSaveData {
  ProjectSaveData({
    this.width,
    this.height,
    this.drawings,
    this.layers = const [LayerSaveData(id: 0)],
  });

  ProjectSaveData.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        drawings = (json['drawings'] as List<dynamic>)
            .map((d) => DrawingSaveData.fromJson(d))
            .toList(),
        layers = (json['layers'] as List<dynamic>)
            .map((l) => LayerSaveData.fromJson(l))
            .toList();

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'drawings': drawings.map((d) => d.toJson()).toList(),
        'layers': layers.map((l) => l.toJson()).toList(),
      };

  final double width;
  final double height;
  final List<DrawingSaveData> drawings;
  final List<LayerSaveData> layers;
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

class LayerSaveData {
  const LayerSaveData({this.id});

  LayerSaveData.fromJson(Map<String, dynamic> json) : id = json['id'];

  Map<String, dynamic> toJson() => {
        'id': id,
      };

  final int id;
}
