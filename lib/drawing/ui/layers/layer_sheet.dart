import 'dart:ui';

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
              proxyDecorator: _proxyDecorator,
              onReorder: reelStack.onLayerReorder,
              children: [
                for (final reel in reelStack.reels)
                  LayerRow(
                    key: Key(reel.currentFrame.image.file.path),
                    reel: reel,
                    selected: reel == reelStack.activeReel,
                    visible: reelStack.isVisible(reelStack.reels.indexOf(reel)),
                    canDelete: reelStack.canDeleteLayer,
                  ),
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

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = lerpDouble(1, 1.05, animValue)!;
        final double elevation = lerpDouble(0, 10, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Material(
            child: child,
            elevation: elevation,
          ),
        );
      },
      child: child,
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
