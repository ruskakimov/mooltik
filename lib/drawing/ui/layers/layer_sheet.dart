import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/sheet_title.dart';
import 'package:mooltik/drawing/ui/layers/layer_row.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';

const double _rowHeight = 80;

class LayerSheet extends StatelessWidget {
  const LayerSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                LayerList(),
                Positioned(
                  left: 16,
                  bottom: _rowHeight * 3,
                  height: _rowHeight * 3,
                  width: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SheetTitle('Layers'),
        Spacer(),
        AddLayerButton(),
        SizedBox(width: 8),
      ],
    );
  }
}

class LayerList extends StatelessWidget {
  const LayerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reelStack = context.watch<ReelStackModel>();

    return ClipRect(
      child: ReorderableListView.builder(
        primary: false,
        shrinkWrap: true,
        clipBehavior: Clip.none,
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        proxyDecorator: _proxyDecorator,
        onReorder: reelStack.onLayerReorder,
        itemCount: reelStack.reels.length,
        itemBuilder: (context, index) =>
            _buildLayerRow(context, index, reelStack),
      ),
    );
  }

  Widget _buildLayerRow(
    BuildContext context,
    int index,
    ReelStackModel reelStack,
  ) {
    final reel = reelStack.reels[index];
    final name = reelStack.getLayerName(index);
    final selected = reel == reelStack.activeReel;
    final visible = reelStack.isVisible(index);

    Widget rowContent = LayerRow(
      reel: reel,
      name: name,
      selected: selected,
      visible: visible,
      canDelete: reelStack.canDeleteLayer,
    );

    if (!visible) {
      rowContent = Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: rowContent,
      );
    }

    return SizedBox(
      key: Key(reel.currentFrame.image.file.path),
      height: _rowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: rowContent,
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
