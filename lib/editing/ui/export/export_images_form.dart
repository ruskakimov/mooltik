import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/export/frame_picker.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/data/export/exporter_model.dart';
import 'package:mooltik/common/ui/editable_field.dart';

class ExportImagesForm extends StatelessWidget {
  const ExportImagesForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberOfSelectedFrames = context.select<ExporterModel, int>(
      (exporter) => exporter.selectedFrames.length,
    );

    return EditableField(
      label: 'Selected frames',
      text: '$numberOfSelectedFrames',
      onTap: () => _openSelectedFramesDialog(context),
    );
  }

  void _openSelectedFramesDialog(BuildContext context) {
    final exporter = context.read<ExporterModel>();

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FramesPicker(
          framesSceneByScene: exporter.imagesExportFrames,
          initialSelectedFrames: exporter.selectedFrames,
          onSubmit: (selected) {
            exporter.selectedFrames = selected;
          },
        ),
      ),
    );
  }
}
