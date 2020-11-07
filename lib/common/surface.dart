import 'package:flutter/material.dart';

class Surface extends StatelessWidget {
  const Surface({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
          )
        ],
      ),
      child: child,
    );
  }
}
