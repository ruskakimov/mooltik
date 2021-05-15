import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:provider/provider.dart';

class FrameMenu extends StatelessWidget {
  const FrameMenu({
    Key key,
    @required this.scrollTo,
    @required this.jumpTo,
    @required this.closePopup,
  }) : super(key: key);

  final Function(int) scrollTo;
  final Function(int) jumpTo;
  final VoidCallback closePopup;

  static const Duration scrollDelay = Duration(milliseconds: 100);

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
              await reel.addBeforeCurrent();
              jumpTo(reel.currentIndex); // Keep current centered.
              closePopup();

              await Future.delayed(scrollDelay);

              // Scroll to new frame.
              scrollTo(reel.currentIndex - 1);
            },
          ),
          LabeledIconButton(
            icon: FontAwesomeIcons.copy,
            label: 'Duplicate',
            color: Theme.of(context).colorScheme.onPrimary,
            onTap: () async {
              await reel.duplicateCurrent();
              closePopup();

              await Future.delayed(scrollDelay);

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
              await reel.addAfterCurrent();
              closePopup();

              await Future.delayed(scrollDelay);

              // Scroll to new frame.
              scrollTo(reel.currentIndex + 1);
            },
          ),
        ],
      ),
    );
  }
}
