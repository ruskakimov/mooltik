import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';

class SizePicker extends StatelessWidget {
  const SizePicker({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return _Circle(
      radius: 60,
      color: Color(0xC4C4C4).withOpacity(0.5),
      child: Center(
        child: _Circle(
          radius: 30,
          color: Colors.black,
          border: Border.all(color: Colors.white),
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({
    Key key,
    @required this.radius,
    @required this.color,
    this.border,
    this.child,
  }) : super(key: key);

  final double radius;
  final Color color;
  final BoxBorder border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: border,
      ),
      child: child,
    );
  }
}
