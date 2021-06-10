import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/drawing/ui/layers/layer_row.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';

class LayerSheet extends StatelessWidget {
  const LayerSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reelStack = context.watch<ReelStackModel>();

    return ClipRect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: ReorderableListView(
              onReorder: reelStack.onLayerReorder,
              children: [
                // TODO: Why is it nullable
                for (final reel in reelStack.reels) LayerRow(reel: reel!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitle(),
        Spacer(),
        AddLayerButton(),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Layers',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AddLayerButton extends StatelessWidget {
  const AddLayerButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: FontAwesomeIcons.plus,
      onTap: () async {
        final reelStack = context.read<ReelStackModel>();
        final project = context.read<Project>();

        reelStack.addLayerAboveActive(await project.createNewSceneLayer());
      },
    );
  }
}
