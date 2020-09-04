import 'package:flutter/material.dart';

typedef void StrokeStartCallback(Offset position);
typedef void StrokeUpdateCallback(Offset position);

class CanvasGestureDetector extends StatefulWidget {
  CanvasGestureDetector({
    Key key,
    this.child,
    this.onPanUpdate,
    this.onScaleStart,
    this.onScaleUpdate,
  }) : super(key: key);

  final Widget child;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;

  @override
  _CanvasGestureDetectorState createState() => _CanvasGestureDetectorState();
}

class _CanvasGestureDetectorState extends State<CanvasGestureDetector> {
  int _pointersOnScreen = 0;
  Offset _lastContactPoint;

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
          _lastContactPoint = details.focalPoint;
          widget.onScaleStart?.call(details);
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          if (_pointersOnScreen == 1) {
            _onSinglePointerMove(details);
          } else {
            widget.onScaleUpdate?.call(details);
          }
        },
        onScaleEnd: (ScaleEndDetails details) {},
        child: widget.child,
      ),
    );
  }

  void _onSinglePointerMove(ScaleUpdateDetails details) {
    final currentContactPoint = details.focalPoint;
    final dragUpdateDetails = DragUpdateDetails(
      delta: currentContactPoint - _lastContactPoint,
      globalPosition: currentContactPoint,
      localPosition: details.localFocalPoint,
    );
    _lastContactPoint = details.focalPoint;

    widget.onPanUpdate?.call(dragUpdateDetails);
  }
}
