import 'package:flutter/material.dart';

class Playhead extends StatelessWidget {
  const Playhead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: SizedBox(
          width: 2,
          height: double.infinity,
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
            elevation: 4,
          ),
        ),
      ),
    );
  }
}
