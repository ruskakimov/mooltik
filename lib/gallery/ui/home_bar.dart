import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/surface.dart';
import 'package:mooltik/gallery/ui/trash_button.dart';

class HomeBar extends StatelessWidget {
  const HomeBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Row(
        children: [
          _Logo(),
          Spacer(),
          TrashButton(),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: Theme.of(context).colorScheme.primary,
      child: Image.asset('assets/logo_foreground.png', fit: BoxFit.cover),
    );
  }
}
