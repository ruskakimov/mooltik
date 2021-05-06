import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
import 'package:mooltik/drawing/ui/layers/layer_sheet.dart';
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
    final reelStack = context.read<ReelStackModel>();

    showSideSheet(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: reelStack,
        child: LayerSheet(),
      ),
    );
  }
}
