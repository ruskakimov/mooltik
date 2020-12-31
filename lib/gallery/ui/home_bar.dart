import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/surface.dart';

class HomeBar extends StatelessWidget {
  const HomeBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Center(
        child: Container(
          width: 56,
          height: 56,
          color: Theme.of(context).colorScheme.primary,
          child: Image.asset('assets/logo_foreground.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
