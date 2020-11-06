import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddProjectButton extends StatelessWidget {
  const AddProjectButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(
        FontAwesomeIcons.plus,
        size: 18,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      onPressed: () {},
    );
  }
}
