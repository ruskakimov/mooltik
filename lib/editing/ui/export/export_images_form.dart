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
        builder: (context) => FramesPicker(),
      ),
    );
  }
}

class FramesPicker extends StatelessWidget {
  const FramesPicker({Key? key}) : super(key: key);

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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        itemCount: 20,
        itemBuilder: (context, i) {
          if (i == 0) return LabeledCheckbox(label: 'All frames');
          return SceneFramesPicker(sceneNumber: i);
        },
        separatorBuilder: (context, i) => Divider(),
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
        SizedBox(width: 8),
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

class SceneFramesPicker extends StatelessWidget {
  const SceneFramesPicker({
    Key? key,
    required this.sceneNumber,
  }) : super(key: key);

  final int sceneNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledCheckbox(label: 'Scene $sceneNumber'),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
              top: 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            itemCount: 20,
            itemBuilder: (context, i) {
              return Container(
                width: 150,
                color: Colors.grey,
              );
            },
            separatorBuilder: (context, i) => SizedBox(width: 16),
          ),
        ),
      ],
    );
  }
}
