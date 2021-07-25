import 'dart:ui';

extension ColorMethods on Color {
  int toRgba() {
    final bytes = [
      red,
      green,
      blue,
      alpha,
    ];
    return bytes.reduce((a, b) => (a << 8) | b);
  }
}
