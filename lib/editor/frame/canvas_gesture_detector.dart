import 'package:flutter/material.dart';

typedef void StrokeStartCallback(Offset position);
typedef void StrokeUpdateCallback(Offset position);

class CanvasGestureDetector extends StatefulWidget {
  CanvasGestureDetector({
    Key key,
    this.child,
    this.onStrokeStart,
    this.onStrokeUpdate,
    this.onStrokeCancel,
    this.onScaleStart,
    this.onScaleUpdate,
  }) : super(key: key);

  final Widget child;
  final GestureDragStartCallback onStrokeStart;
  final GestureDragUpdateCallback onStrokeUpdate;
  final VoidCallback onStrokeCancel;
  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;

  @override
  _CanvasGestureDetectorState createState() => _CanvasGestureDetectorState();
}

class _CanvasGestureDetectorState extends State<CanvasGestureDetector> {
  int _prevPointersOnScreen = 0;
  int _pointersOnScreen = 0;
  Offset _lastContactPoint;
  bool _veryQuickStroke = false;

  void changePointerOnScreenBy(int count) {
    _prevPointersOnScreen = _pointersOnScreen;
    _pointersOnScreen = _pointersOnScreen + count;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => changePointerOnScreenBy(1),
      onPointerUp: (e) => changePointerOnScreenBy(-1),
      onPointerCancel: (e) => changePointerOnScreenBy(-1),
      child: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          _lastContactPoint = details.focalPoint;

          if (_pointersOnScreen == 1) {
            _veryQuickStroke = true;

            Future.delayed(Duration(milliseconds: 1000), () {
              _veryQuickStroke = false;
            });

            widget.onStrokeStart?.call(DragStartDetails(
              globalPosition: details.focalPoint,
              localPosition: details.localFocalPoint,
            ));
          } else {
            widget.onScaleStart?.call(details);
          }
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          if (_pointersOnScreen == 1) {
            _onSinglePointerMove(details);
          } else {
            if (_veryQuickStroke) {
              _veryQuickStroke = false;
              widget.onStrokeCancel?.call();
            }

            widget.onScaleUpdate?.call(details);
          }
        },
        onScaleEnd: (ScaleEndDetails details) {},
        child: widget.child,
      ),
    );
  }

  void _onSinglePointerMove(ScaleUpdateDetails details) {
    if (_prevPointersOnScreen != 0) return;
    final currentContactPoint = details.focalPoint;
    final dragUpdateDetails = DragUpdateDetails(
      delta: currentContactPoint - _lastContactPoint,
      globalPosition: currentContactPoint,
      localPosition: details.localFocalPoint,
    );
    _lastContactPoint = details.focalPoint;

    widget.onStrokeUpdate?.call(dragUpdateDetails);
  }
}
