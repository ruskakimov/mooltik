import 'package:flutter/material.dart';

abstract class ImageInterface implements ChangeNotifier {
  int get width;
  int get height;

  Size get size => Size(width.toDouble(), height.toDouble());

  void draw(Canvas canvas, Offset offset, Paint paint);
}
