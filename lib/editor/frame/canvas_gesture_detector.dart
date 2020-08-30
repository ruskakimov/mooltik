import 'package:flutter/material.dart';

typedef void StrokeStartCallback(Offset position);
typedef void StrokeUpdateCallback(Offset position);

class CanvasGestureDetector extends StatefulWidget {
  CanvasGestureDetector({
    Key key,
    this.child,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onStrokeStart,
    this.onStrokeUpdate,
  }) : super(key: key);

  final Widget child;
  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;
  final StrokeStartCallback onStrokeStart;
  final StrokeUpdateCallback onStrokeUpdate;

  @override
  _CanvasGestureDetectorState createState() => _CanvasGestureDetectorState();
}

class _CanvasGestureDetectorState extends State<CanvasGestureDetector> {
  int _pointersOnScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        _pointersOnScreen += 1;
      },
      onPointerUp: (e) {
        _pointersOnScreen -= 1;
      },
      onPointerCancel: (e) {
        _pointersOnScreen -= 1;
      },
      child: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          widget.onStrokeStart?.call(details.localFocalPoint);
          widget.onScaleStart?.call(details);
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          if (_pointersOnScreen == 1) {
            widget.onStrokeUpdate?.call(details.localFocalPoint);
          } else {
            widget.onScaleUpdate?.call(details);
          }
        },
        onScaleEnd: (ScaleEndDetails details) {},
        child: widget.child,
      ),
    );
  }
}
