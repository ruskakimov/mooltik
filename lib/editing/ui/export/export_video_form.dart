import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/data/export/exporter_model.dart';
import 'package:mooltik/common/ui/editable_field.dart';
import 'package:mooltik/common/ui/edit_text_dialog.dart';

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
      onTap: () => _openEditFileNameDialog(context),
    );
  }

  void _openEditFileNameDialog(BuildContext context) {
    final exporter = context.read<ExporterModel>();

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditTextDialog(
          title: 'File name',
          initialValue: exporter.fileName,
          onSubmit: (newName) {
            exporter.fileName = newName;
          },
          maxLength: 30,
          validator: _fileNameValidator,
        ),
      ),
    );
  }

  String? _fileNameValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }

    final reg = RegExp(r'^[A-Za-z0-9_-]+$');

    if (!reg.hasMatch(value)) {
      return 'Invalid character used';
    }

    return null;
  }
}
