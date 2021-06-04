import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef void StrokeStartCallback(Offset position);
typedef void StrokeUpdateCallback(Offset position);

const veryQuickStrokeMaxDuration = Duration(milliseconds: 500);

class EaselGestureDetector extends StatefulWidget {
  EaselGestureDetector({
    Key? key,
    this.child,
    this.onStrokeStart,
    this.onStrokeUpdate,
    this.onStrokeEnd,
    this.onStrokeCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.allowDrawingWithFinger,
  }) : super(key: key);

  final Widget? child;
  final GestureDragStartCallback? onStrokeStart;
  final GestureDragUpdateCallback? onStrokeUpdate;
  final VoidCallback? onStrokeEnd;
  final VoidCallback? onStrokeCancel;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final bool? allowDrawingWithFinger;

  @override
  _EaselGestureDetectorState createState() => _EaselGestureDetectorState();
}

class _EaselGestureDetectorState extends State<EaselGestureDetector> {
  int _prevPointersOnScreen = 0;
  int _pointersOnScreen = 0;
  late Offset _lastContactPoint;
  bool _startedStroke = false;
  bool _veryQuickStroke = false;
  PointerDeviceKind? _firstPointerKind;

  bool get _firstPointerDown =>
      _prevPointersOnScreen == 0 && _pointersOnScreen == 1;
  bool get _secondPointerDown =>
      _prevPointersOnScreen == 1 && _pointersOnScreen == 2;

  void changePointerOnScreenBy(int count) {
    _prevPointersOnScreen = _pointersOnScreen;
    _pointersOnScreen = _pointersOnScreen + count;

    // Second pointer down.
    if (_secondPointerDown) {
      if (_veryQuickStroke) {
        widget.onStrokeCancel?.call();
      } else if (_startedStroke) {
        widget.onStrokeEnd?.call();
      }
      _veryQuickStroke = false;
      _startedStroke = false;
    }

    // Last pointer up.
    else if (_pointersOnScreen == 0) {
      if (_startedStroke) {
        widget.onStrokeEnd?.call();
      }
      // Reset state.
      _startedStroke = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        changePointerOnScreenBy(1);
        if (_firstPointerDown) {
          _firstPointerKind = e.kind;
        }
      },
      onPointerUp: (e) => changePointerOnScreenBy(-1),
      onPointerCancel: (e) => changePointerOnScreenBy(-1),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
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

  bool get _blockDrawing =>
      !widget.allowDrawingWithFinger! &&
      _firstPointerKind == PointerDeviceKind.touch;

  void _onSinglePointerStart(ScaleStartDetails details) {
    if (_blockDrawing) return;

    widget.onStrokeStart?.call(DragStartDetails(
      globalPosition: details.focalPoint,
      localPosition: details.localFocalPoint,
    ));
    _startedStroke = true;
    _veryQuickStroke = true;
    Future.delayed(veryQuickStrokeMaxDuration, () {
      _veryQuickStroke = false;
    });
  }

  void _onSinglePointerMove(ScaleUpdateDetails details) {
    if (_blockDrawing) return;

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
