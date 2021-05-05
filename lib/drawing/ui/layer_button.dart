import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/show_side_sheet.dart';

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
    showSideSheet(
      context: context,
      builder: (context) => Column(
        children: [
          Text('Layers'),
          Expanded(
            child: ListView(
              children: [
                Container(color: Colors.red, height: 80),
                Container(color: Colors.orange, height: 80),
                Container(color: Colors.yellow, height: 80),
                Container(color: Colors.red, height: 80),
                Container(color: Colors.orange, height: 80),
                Container(color: Colors.yellow, height: 80),
                Container(color: Colors.red, height: 80),
                Container(color: Colors.orange, height: 80),
                Container(color: Colors.yellow, height: 80),
                Container(color: Colors.red, height: 80),
                Container(color: Colors.orange, height: 80),
                Container(color: Colors.yellow, height: 80),
                Container(color: Colors.red, height: 80),
                Container(color: Colors.orange, height: 80),
                Container(color: Colors.yellow, height: 80),
                Container(color: Colors.red, height: 80),
                Container(color: Colors.orange, height: 80),
                Container(color: Colors.yellow, height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
