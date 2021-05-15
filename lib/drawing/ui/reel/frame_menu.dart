import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:provider/provider.dart';

class FrameMenu extends StatelessWidget {
  const FrameMenu({
    Key key,
    @required this.selectedFrame,
    @required this.scrollTo,
    @required this.jumpTo,
    @required this.closePopup,
  }) : super(key: key);

  final Frame selectedFrame;
  final Function(int) scrollTo;
  final Function(int) jumpTo;
  final VoidCallback closePopup;

  @override
  Widget build(BuildContext context) {
    final reel = context.watch<FrameReelModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabeledIconButton(
            icon: FontAwesomeIcons.plusSquare,
            label: 'Add before',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: () async {
              reel.addBeforeCurrent(
                await context.read<Project>().createNewFrame(),
              );

              // Keep current centered.
              jumpTo(reel.currentIndex);

              closePopup();

              await Future.delayed(Duration(milliseconds: 100));

              // Scroll to new frame.
              scrollTo(reel.currentIndex - 1);
            },
          ),
          LabeledIconButton(
            icon: FontAwesomeIcons.copy,
            label: 'Duplicate',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: () async {
              final newFrame = await context.read<Project>().createNewFrame();
              reel.addAfterCurrent(
                selectedFrame.copyWith(file: newFrame.file)..saveSnapshot(),
              );

              closePopup();

              await Future.delayed(Duration(milliseconds: 100));

              // Scroll to duplicated frame.
              scrollTo(reel.currentIndex + 1);
            },
          ),
          LabeledIconButton(
            icon: FontAwesomeIcons.trashAlt,
            label: 'Delete',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: reel.canDeleteCurrent
                ? () {
                    reel.deleteCurrent();
                    closePopup();
                  }
                : null,
          ),
          LabeledIconButton(
            icon: FontAwesomeIcons.plusSquare,
            label: 'Add after',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: () async {
              reel.addAfterCurrent(
                await context.read<Project>().createNewFrame(),
              );

              closePopup();

              await Future.delayed(Duration(milliseconds: 100));

              // Scroll to new frame.
              scrollTo(reel.currentIndex + 1);
            },
          ),
        ],
      ),
    );
  }
}
