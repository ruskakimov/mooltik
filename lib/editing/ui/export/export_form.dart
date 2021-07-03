import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/editable_field.dart';
import 'package:mooltik/editing/data/export/exporter_model.dart';
import 'package:mooltik/editing/ui/export/export_video_form.dart';

class ExportForm extends StatelessWidget {
  const ExportForm({
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
      firstChild: ExportVideoForm(),
      secondChild: EditableField(
        label: 'Selected frames',
        text: '148',
        onTap: () {},
      ),
    );
  }
}
