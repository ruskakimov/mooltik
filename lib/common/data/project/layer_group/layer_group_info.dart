import 'package:equatable/equatable.dart';

class LayerGroupInfo with EquatableMixin {
  LayerGroupInfo(this.firstLayerIndex, this.lastLayerIndex);

  int firstLayerIndex;
  int lastLayerIndex;

  int get layerCount => lastLayerIndex - firstLayerIndex + 1;

  @override
  List<Object?> get props => [firstLayerIndex, lastLayerIndex];
}
