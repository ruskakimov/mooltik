import 'package:equatable/equatable.dart';

class LayerGroupInfo with EquatableMixin {
  LayerGroupInfo(this.firstLayerIndex, this.lastLayerIndex);

  int firstLayerIndex;
  int lastLayerIndex;

  int get layerCount => lastLayerIndex - firstLayerIndex + 1;

  bool contains(int index) =>
      index >= firstLayerIndex && index <= lastLayerIndex;

  @override
  List<Object?> get props => [firstLayerIndex, lastLayerIndex];
}
