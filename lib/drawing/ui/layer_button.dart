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
      onPressed: () => _openLayersSheet(context),
    );
  }

  void _openLayersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(height: 300),
      shape: _roundedTopCorners,
    );
  }
}

const _roundedTopCorners = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  ),
);
