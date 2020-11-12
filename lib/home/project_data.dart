class ProjectData {
  ProjectData(this.width, this.height, this.drawings, this.layers);

  ProjectData.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        drawings = json['drawings'],
        layers = json['layers'];

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'drawings': drawings,
        'layers': layers,
      };

  final double width;
  final double height;
  final List<DrawingData> drawings;
  final List<LayerData> layers;
}

class DrawingData {
  DrawingData(this.duration, this.id);

  final int duration;
  final int id;
}

class LayerData {
  LayerData(this.id);

  final int id;
}
