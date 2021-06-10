import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
import 'package:mooltik/drawing/ui/layers/layer_sheet.dart';
import 'package:mooltik/common/ui/open_side_sheet.dart';

class LayerButton extends StatelessWidget {
  const LayerButton({
    Key? key,
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
    final project = context.read<Project>();

    openSideSheet(
      context: context,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: reelStack),
          ChangeNotifierProvider.value(value: project),
        ],
        child: LayerSheet(),
      ),
    );
  }
}
