import 'package:flutter/material.dart';

class AllFingersLiftedListener extends StatefulWidget {
  AllFingersLiftedListener({
    Key? key,
    required this.onAllFingersLifted,
    required this.child,
  }) : super(key: key);

  final VoidCallback onAllFingersLifted;
  final Widget child;

  @override
  _AllFingersLiftedListenerState createState() =>
      _AllFingersLiftedListenerState();
}

class _AllFingersLiftedListenerState extends State<AllFingersLiftedListener> {
  int _pointersDown = 0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        _pointersDown++;
      },
      onPointerUp: (_) {
        _pointersDown--;
        if (_pointersDown == 0) widget.onAllFingersLifted();
      },
      onPointerCancel: (_) {
        _pointersDown--;
        if (_pointersDown == 0) widget.onAllFingersLifted();
      },
      child: widget.child,
    );
  }
}
