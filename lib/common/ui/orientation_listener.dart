import 'package:flutter/material.dart';

class OrientationListener extends StatefulWidget {
  OrientationListener({
    Key? key,
    required this.onOrientationChanged,
    required this.child,
  }) : super(key: key);

  final ValueChanged<Orientation> onOrientationChanged;
  final Widget child;

  @override
  _OrientationListenerState createState() => _OrientationListenerState();
}

class _OrientationListenerState extends State<OrientationListener>
    with WidgetsBindingObserver {
  late Orientation _orientation;

  Orientation get currentOrientation {
    final size = WidgetsBinding.instance!.window.physicalSize;
    return size.width > size.height
        ? Orientation.landscape
        : Orientation.portrait;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _orientation = currentOrientation;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (currentOrientation != _orientation) {
      _orientation = currentOrientation;
      widget.onOrientationChanged(_orientation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
