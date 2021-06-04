import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/copy_paster_model.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:provider/provider.dart';

class FrameMenu extends StatelessWidget {
  const FrameMenu({
    Key? key,
    required this.scrollTo,
    required this.jumpTo,
    required this.closePopup,
  }) : super(key: key);

  final Function(int) scrollTo;
  final Function(int) jumpTo;
  final VoidCallback closePopup;

  static const Duration scrollDelay = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    final reel = context.watch<FrameReelModel>();
    final copyPaster = context.watch<CopyPasterModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFirstRow(context, reel, copyPaster),
          _buildSeparator(),
          _buildSecondRow(context, reel),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Ink(
      width: 150,
      height: 1,
      color: Colors.black12,
    );
  }

  Row _buildFirstRow(
    BuildContext context,
    FrameReelModel reel,
    CopyPasterModel copyPaster,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabeledIconButton(
          icon: Icons.copy_rounded,
          label: 'Copy',
          color: Theme.of(context).colorScheme.onPrimary,
          onTap: () {
            copyPaster.copyImage(reel.currentFrame.snapshot);
            closePopup();
          },
        ),
        LabeledIconButton(
          icon: Icons.cut_rounded,
          label: 'Cut',
          color: Theme.of(context).colorScheme.onPrimary,
          onTap: reel.canDeleteCurrent
              ? () {
                  copyPaster.copyImage(reel.currentFrame.snapshot);
                  reel.deleteCurrent();
                  closePopup();
                }
              : null,
        ),
        LabeledIconButton(
          icon: Icons.paste_rounded,
          label: 'Paste',
          color: Theme.of(context).colorScheme.onPrimary,
          onTap: copyPaster.canPaste
              ? () async {
                  closePopup();
                  final easel = context.read<EaselModel>();
                  final newSnapshot = await copyPaster.pasteOn(
                    easel.frame.snapshot!,
                  );
                  easel.pushSnapshot(newSnapshot);
                }
              : null,
        ),
      ],
    );
  }

  Row _buildSecondRow(BuildContext context, FrameReelModel reel) {
    return Row(
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
    );
  }
}
