import 'package:flutter/material.dart';
import 'package:mooltik/common/surface.dart';

class HomeBar extends StatelessWidget {
  const HomeBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Text(
          'Mooltik',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
