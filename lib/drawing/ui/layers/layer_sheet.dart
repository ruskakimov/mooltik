import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/project/layer_group/layer_group_info.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/sheet_title.dart';
import 'package:mooltik/drawing/ui/layers/all_fingers_lifted_listener.dart';
import 'package:mooltik/drawing/ui/layers/group_lines_layer.dart';
import 'package:mooltik/drawing/ui/layers/layer_row.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';

const double _rowHeight = 80;

class LayerSheet extends StatefulWidget {
  const LayerSheet({Key? key}) : super(key: key);

  @override
  _LayerSheetState createState() => _LayerSheetState();
}

class _LayerSheetState extends State<LayerSheet> {
  bool _reordering = false;
  ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layerGroups = context.select<ReelStackModel, List<LayerGroupInfo>>(
      (reelStack) => reelStack.layerGroups,
    );
    final scrollOffset = _controller.hasClients ? _controller.offset : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  setState(() {});
                  return true;
                },
                // Listen when `maxScrollExtent` changes that causes offset change,
                // e.g. when screen is rotated or layer is deleted.
                child: NotificationListener<ScrollMetricsNotification>(
                  onNotification: (notification) {
                    setState(() {});
                    return true;
                  },
                  child: _LayerList(
                    controller: _controller,
                    onReorderingStart: () => setState(() => _reordering = true),
                    onReorderingEnd: () => setState(() => _reordering = false),
                  ),
                ),
              ),
              IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _reordering ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: GroupLinesLayer(
                    layerGroups: layerGroups,
                    scrollOffset: scrollOffset,
                    rowHeight: _rowHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

class _LayerList extends StatelessWidget {
  const _LayerList({
    Key? key,
    required this.controller,
    required this.onReorderingStart,
    required this.onReorderingEnd,
  }) : super(key: key);

  final ScrollController controller;
  final VoidCallback onReorderingStart;
  final VoidCallback onReorderingEnd;

  @override
  Widget build(BuildContext context) {
    final reelStack = context.watch<ReelStackModel>();

    return AllFingersLiftedListener(
      onAllFingersLifted: () {
        // Wait for reordering animation to settle.
        Future.delayed(
          Duration(milliseconds: 300),
          onReorderingEnd,
        );
      },
      child: ClipRect(
        child: ReorderableListView.builder(
          scrollController: controller,
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

    return SizedBox(
      key: Key(reel.currentFrame.image.file.path),
      height: _rowHeight,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: grouped ? 16 : 0,
        ),
        child: LayerRow(
          reel: reel,
          name: name,
          selected: selected,
          visible: visible,
          canDelete: reelStack.canDeleteLayer,
          canGroupWithAbove: reelStack.canGroupWithAbove(index),
          canGroupWithBelow: reelStack.canGroupWithBelow(index),
          canUngroup: reelStack.isGrouped(index),
        ),
      ),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    if (animation.status == AnimationStatus.forward) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => onReorderingStart());
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = lerpDouble(1, 1.05, animValue)!;
        final double elevation = lerpDouble(0, 10, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Material(
            type: MaterialType.transparency,
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
