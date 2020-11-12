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
        drawings = json['drawings'],
        layers = json['layers'];

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'duration': duration,
      };

  final int id;
  final int duration;
}

class LayerSaveData {
  const LayerSaveData({this.id});

  Map<String, dynamic> toJson() => {
        'id': id,
      };

  final int id;
}
