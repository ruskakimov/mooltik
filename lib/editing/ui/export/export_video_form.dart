import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/export/open_edit_file_name_dialog.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/data/export/exporter_model.dart';
import 'package:mooltik/common/ui/editable_field.dart';

class ExportVideoForm extends StatelessWidget {
  const ExportVideoForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fileName = context.select<ExporterModel, String>(
      (exporter) => exporter.fileName,
    );

    return EditableField(
      label: 'File name',
      text: '$fileName.mp4',
      onTap: () => openEditFileNameDialog(context),
    );
  }
}
