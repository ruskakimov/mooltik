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
        // 'drawings': drawings,
        // 'layers': layers,
      };

  final double width;
  final double height;
  final List<DrawingSaveData> drawings;
  final List<LayerSaveData> layers;
}

class DrawingSaveData {
  const DrawingSaveData({this.id, this.duration});

  final int id;
  final int duration;
}

class LayerSaveData {
  const LayerSaveData({this.id});

  final int id;
}
