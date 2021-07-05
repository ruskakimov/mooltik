import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/app_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/data/export/exporter_model.dart';
import 'package:mooltik/common/ui/editable_field.dart';

class ExportImagesForm extends StatelessWidget {
  const ExportImagesForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditableField(
      label: 'Selected frames',
      text: '148',
      onTap: () => _openSelectedFramesDialog(context),
    );
  }

  void _openSelectedFramesDialog(BuildContext context) {
    final exporter = context.read<ExporterModel>();

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditSelectedFramesDialog(),
      ),
    );
  }
}

class EditSelectedFramesDialog extends StatelessWidget {
  const EditSelectedFramesDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected frames'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            tooltip: 'Done',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: LabeledCheckbox(label: 'All frames'),
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppCheckbox(value: true),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
