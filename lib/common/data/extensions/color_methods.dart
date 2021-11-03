import 'dart:ui';

import 'package:flutter/material.dart';

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

extension HSVMethods on HSVColor {
  String toStr() => '$alpha,$hue,$saturation,$value';
}

extension HSVParsing on String {
  HSVColor parseHSVColor() {
    final parts = this.split(',').map((part) => double.parse(part)).toList();
    return HSVColor.fromAHSV(
      parts[0],
      parts[1],
      parts[2],
      parts[3],
    );
  }
}
