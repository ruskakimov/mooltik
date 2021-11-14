import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:mooltik/common/data/copy_paster_model.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/io/image.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';
import 'package:mooltik/common/ui/open_delete_confirmation_dialog.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:mooltik/drawing/data/lasso/lasso_model.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/ui/lasso/transformed_image_painter.dart';
import 'package:mooltik/drawing/ui/painted_glass.dart';
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

  static Matrix4 _materialIconTransform =
      Matrix4Transform().scale(1.1, origin: Offset(9, 0)).m;

  @override
  Widget build(BuildContext context) {
    final reel = context.watch<FrameReelModel>();
    final copyPaster = context.watch<CopyPasterModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImageRow(context),
          _buildSeparator(),
          _buildActionRow(context, reel, copyPaster),
          _buildSeparator(),
          _buildFrameRow(context, reel),
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

  Row _buildImageRow(
    BuildContext context,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabeledIconButton(
          icon: MdiIcons.arrowUpDown,
          label: 'Flip Vert.',
          onTap: () async {
            closePopup();
            final easel = context.read<EaselModel>();
            final original = easel.image.snapshot!;
            final frameCenter = easel.frameSize.center(Offset.zero);

            final newSnapshot = await generateImage(
              TransformedImagePainter(
                transformedImage: original,
                transform: Matrix4Transform()
                    .flipVertically(origin: frameCenter)
                    .matrix4,
              ),
              original.width,
              original.height,
            );
            easel.pushSnapshot(newSnapshot);
          },
        ),
        LabeledIconButton(
          icon: Icons.image_outlined,
          iconTransform: _materialIconTransform,
          label: 'Add image',
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              withData: true,
            );
            closePopup();

            if (result != null) {
              final file = result.files.single;
              final image = await imageFromFileBytes(file.bytes!);

              final toolbox = context.read<ToolboxModel>();
              final lassoModel = context.read<LassoModel>();

              toolbox.selectTool(toolbox.lasso);
              lassoModel.startImportedImageTransform(image);
            }
          },
        ),
        LabeledIconButton(
          icon: MdiIcons.arrowLeftRight,
          label: 'Flip Horiz.',
          onTap: () async {
            closePopup();
            final easel = context.read<EaselModel>();
            final original = easel.image.snapshot!;
            final frameCenter = easel.frameSize.center(Offset.zero);

            final newSnapshot = await generateImage(
              TransformedImagePainter(
                transformedImage: original,
                transform: Matrix4Transform()
                    .flipHorizontally(origin: frameCenter)
                    .matrix4,
              ),
              original.width,
              original.height,
            );
            easel.pushSnapshot(newSnapshot);
          },
        ),
      ],
    );
  }

  Row _buildActionRow(
    BuildContext context,
    FrameReelModel reel,
    CopyPasterModel copyPaster,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabeledIconButton(
          icon: Icons.copy_rounded,
          iconTransform: _materialIconTransform,
          label: 'Copy',
          onTap: () {
            copyPaster.copyImage(reel.currentFrame.image.snapshot);
            closePopup();
          },
        ),
        LabeledIconButton(
          icon: Icons.paste_rounded,
          iconTransform: _materialIconTransform,
          label: 'Paste',
          onTap: copyPaster.canPaste
              ? () async {
                  closePopup();
                  final easel = context.read<EaselModel>();
                  final newSnapshot = await copyPaster.pasteOn(
                    easel.image.snapshot!,
                  );
                  easel.pushSnapshot(newSnapshot);
                }
              : null,
        ),
        LabeledIconButton(
          icon: FontAwesomeIcons.trashAlt,
          label: 'Delete',
          onTap: reel.canDeleteCurrent
              ? () async {
                  closePopup();
                  final deleteConfirmed = await openDeleteConfirmationDialog(
                    context: context,
                    name: 'cel',
                    preview: PaintedGlass(image: reel.deleteDialogFrame.image),
                  );
                  if (deleteConfirmed == true) {
                    reel.deleteCurrent();
                  }
                }
              : null,
        ),
      ],
    );
  }

  Row _buildFrameRow(BuildContext context, FrameReelModel reel) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabeledIconButton(
          icon: FontAwesomeIcons.plusSquare,
          label: 'Add before',
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
