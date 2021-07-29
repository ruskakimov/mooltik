import 'dart:ui';

extension ColorMethods on Color {
  int toRGBA() {
    return [
      red,
      green,
      blue,
      alpha,
    ].reduce((color, channel) => (color << 8) | channel);
  }

  int toABGR() {
    return [
      alpha,
      blue,
      green,
      red,
    ].reduce((color, channel) => (color << 8) | channel);
  }
}
