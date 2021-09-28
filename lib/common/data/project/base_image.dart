import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BaseImage extends ChangeNotifier with EquatableMixin {
  int get width;
  int get height;

  Size get size => Size(width.toDouble(), height.toDouble());

  void draw(Canvas canvas, Offset offset, Paint paint);
}
