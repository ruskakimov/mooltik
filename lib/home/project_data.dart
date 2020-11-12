class ProjectData {
  ProjectData({
    this.width,
    this.height,
    this.drawings,
    this.layers = const [LayerData(id: 0)],
  });

  ProjectData.fromJson(Map<String, dynamic> json)
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
  final List<DrawingData> drawings;
  final List<LayerData> layers;
}

class DrawingData {
  const DrawingData({this.id, this.duration});

  final int id;
  final int duration;
}

class LayerData {
  const LayerData({this.id});

  final int id;
}
