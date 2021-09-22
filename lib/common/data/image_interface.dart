import 'package:flutter/material.dart';

abstract class ImageInterface {
  int get width;
  int get height;

  void draw(Canvas canvas, Offset offset, Paint paint);
}
