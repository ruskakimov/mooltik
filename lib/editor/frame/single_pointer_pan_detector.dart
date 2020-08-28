import 'package:flutter/material.dart';

class SinglePointerPanDetector extends StatefulWidget {
  SinglePointerPanDetector({
    Key key,
    this.child,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
  }) : super(key: key);

  final Widget child;
  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;

  @override
  _SinglePointerPanDetectorState createState() =>
      _SinglePointerPanDetectorState();
}

class _SinglePointerPanDetectorState extends State<SinglePointerPanDetector> {
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
        onPanStart: (DragStartDetails details) {
          if (_pointersOnScreen > 1) return;
          widget.onPanStart?.call(details);
        },
        onPanUpdate: (DragUpdateDetails details) {
          if (_pointersOnScreen > 1) return;
          widget.onPanUpdate?.call(details);
        },
        onPanEnd: (DragEndDetails details) {
          if (_pointersOnScreen > 1) return;
          widget.onPanEnd?.call(details);
        },
        child: widget.child,
      ),
    );
  }
}
