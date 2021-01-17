import 'package:flutter/material.dart';

typedef void StrokeStartCallback(Offset position);
typedef void StrokeUpdateCallback(Offset position);

const veryQuickStrokeMaxDuration = Duration(milliseconds: 500);

class EaselGestureDetector extends StatefulWidget {
  EaselGestureDetector({
    Key key,
    this.child,
    this.onStrokeStart,
    this.onStrokeUpdate,
    this.onStrokeEnd,
    this.onStrokeCancel,
    this.onScaleStart,
    this.onScaleUpdate,
  }) : super(key: key);

  final Widget child;
  final GestureDragStartCallback onStrokeStart;
  final GestureDragUpdateCallback onStrokeUpdate;
  final VoidCallback onStrokeEnd;
  final VoidCallback onStrokeCancel;
  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;

  @override
  _EaselGestureDetectorState createState() => _EaselGestureDetectorState();
}

class _EaselGestureDetectorState extends State<EaselGestureDetector> {
  int _prevPointersOnScreen = 0;
  int _pointersOnScreen = 0;
  Offset _lastContactPoint;
  bool _startedStroke = false;
  bool _veryQuickStroke = false;

  bool get _firstPointerDown =>
      _prevPointersOnScreen == 0 && _pointersOnScreen == 1;
  bool get _secondPointerDown =>
      _prevPointersOnScreen == 1 && _pointersOnScreen == 2;

  void changePointerOnScreenBy(int count) {
    _prevPointersOnScreen = _pointersOnScreen;
    _pointersOnScreen = _pointersOnScreen + count;

    // First pointer down.
    if (_firstPointerDown) {
      _veryQuickStroke = true;
      _startedStroke = true;
      Future.delayed(veryQuickStrokeMaxDuration, () {
        _veryQuickStroke = false;
      });
    }

    // Second pointer down.
    else if (_secondPointerDown) {
      if (_veryQuickStroke) {
        widget.onStrokeCancel?.call();
        print('cancel stroke');
      } else if (_startedStroke) {
        widget.onStrokeEnd?.call();
        print('end stroke 1');
      }
      _veryQuickStroke = false;
      _startedStroke = false;
    }

    // Last pointer up.
    else if (_pointersOnScreen == 0) {
      if (_startedStroke) {
        widget.onStrokeEnd?.call();
        print('end stroke 2');
      }
      // Reset state.
      _startedStroke = false;
    }
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

          if (_firstPointerDown) {
            _onSinglePointerStart(details);
          } else if (_secondPointerDown) {
            widget.onScaleStart?.call(details);
          }
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          if (_firstPointerDown) {
            _onSinglePointerMove(details);
          } else if (_secondPointerDown) {
            widget.onScaleUpdate?.call(details);
          }
        },
        child: widget.child,
      ),
    );
  }

  void _onSinglePointerStart(ScaleStartDetails details) {
    widget.onStrokeStart?.call(DragStartDetails(
      globalPosition: details.focalPoint,
      localPosition: details.localFocalPoint,
    ));
    print('start stroke');
  }

  void _onSinglePointerMove(ScaleUpdateDetails details) {
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
