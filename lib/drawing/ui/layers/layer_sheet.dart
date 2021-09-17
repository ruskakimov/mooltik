import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/project/layer_group/layer_group_info.dart';
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
    final layerGroups = context.select<ReelStackModel, List<LayerGroupInfo>>(
      (reelStack) => reelStack.layerGroups,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                LayerList(),
                for (var group in layerGroups)
                  _buildLine(group.firstLayerIndex, group.layerCount)
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Draws a group line starting from [topRowIndex] (inclusive) and spanning [rowCount] rows.
  Positioned _buildLine(int topRowIndex, int rowCount) {
    return Positioned(
      left: 0,
      top: _rowHeight * topRowIndex + 16,
      height: _rowHeight * rowCount - 32,
      width: 12,
      child: _LayerGroupLine(),
    );
  }

  Widget _buildHeader() {
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

class _LayerGroupLine extends StatelessWidget {
  const _LayerGroupLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CustomPaint(
        painter: LinePainter(Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  LinePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, 4, size.height), paint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 4), paint);
    canvas.drawRect(Rect.fromLTWH(0, size.height - 4, size.width, 4), paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LinePainter oldDelegate) => false;
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
          bottom: max(MediaQuery.of(context).padding.bottom, 24),
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
    final selected = reelStack.isActive(index);
    final visible = reelStack.isVisible(index);
    final grouped = reelStack.isGrouped(index);

    Widget rowContent = LayerRow(
      reel: reel,
      name: name,
      selected: selected,
      visible: visible,
      canDelete: reelStack.canDeleteLayer,
      canGroupWithAbove: reelStack.canGroupWithAbove(index),
      canGroupWithBelow: reelStack.canGroupWithBelow(index),
      canUngroup: reelStack.isGrouped(index),
    );

    return SizedBox(
      key: Key(reel.currentFrame.image.file.path),
      height: _rowHeight,
      child: AnimatedPadding(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: grouped ? 16 : 0,
        ),
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

class AddLayerButton extends StatefulWidget {
  const AddLayerButton({
    Key? key,
  }) : super(key: key);

  @override
  _AddLayerButtonState createState() => _AddLayerButtonState();
}

class _AddLayerButtonState extends State<AddLayerButton> {
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: FontAwesomeIcons.plus,
      onTap: _inProgress ? null : _addLayer,
    );
  }

  Future<void> _addLayer() async {
    if (_inProgress) return;

    setState(() => _inProgress = true);
    try {
      final reelStack = context.read<ReelStackModel>();
      final project = context.read<Project>();

      await reelStack.addLayerAboveActive(
        await project.createNewSceneLayer(),
      );
    } catch (e) {
      rethrow;
    } finally {
      setState(() => _inProgress = false);
    }
  }
}
