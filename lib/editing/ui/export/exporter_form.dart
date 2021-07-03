import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/common/ui/editable_field.dart';
import 'package:mooltik/common/ui/edit_text_dialog.dart';
import 'package:mooltik/editing/data/export/exporter_model.dart';

class ExporterForm extends StatelessWidget {
  const ExporterForm({
    Key? key,
    required this.selectedOption,
    required this.onValueChanged,
  }) : super(key: key);

  final ExportOption selectedOption;
  final ValueChanged<ExportOption?> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(),
        SizedBox(height: 8),
        _buildOptionMenu(),
        _buildForm(),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Export as',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOptionMenu() {
    return CupertinoSlidingSegmentedControl<ExportOption>(
      backgroundColor: Colors.black.withOpacity(0.25),
      groupValue: selectedOption,
      children: {
        ExportOption.video: Text('Video'),
        ExportOption.images: Text('Images'),
      },
      onValueChanged: onValueChanged,
    );
  }

  Widget _buildForm() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      crossFadeState: selectedOption == ExportOption.video
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: _VideoForm(),
      secondChild: EditableField(
        label: 'Selected frames',
        text: '148',
        onTap: () {},
      ),
    );
  }
}

class _VideoForm extends StatelessWidget {
  const _VideoForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fileName = context.select<ExporterModel, String>(
      (exporter) => exporter.videoFileName,
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
          initialValue: exporter.videoFileName,
          onSubmit: (newName) {
            exporter.videoFileName = newName;
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
