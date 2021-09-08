class LayerGroupInfo {
  LayerGroupInfo(this.firstLayerIndex, this.lastLayerIndex);

  int firstLayerIndex;
  int lastLayerIndex;

  int get layerCount => lastLayerIndex - firstLayerIndex + 1;
}
