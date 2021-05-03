import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LayerButton extends StatelessWidget {
  const LayerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      elevation: 2,
      child: Icon(FontAwesomeIcons.layerGroup, size: 20),
      onPressed: () {},
    );
  }
}
