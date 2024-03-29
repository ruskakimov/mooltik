import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/export/exporter_model.dart';
import 'package:mooltik/editing/ui/export/export_form.dart';
import 'package:mooltik/editing/ui/export/export_preview.dart';
import 'package:provider/provider.dart';

class ExportDialog extends StatefulWidget {
  const ExportDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ExportDialogState createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  GlobalKey shareButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final exporter = context.watch<ExporterModel>();

    return WillPopScope(
      onWillPop: () async => exporter.isInitial,
      child: SimpleDialog(
        contentPadding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            width: 248, // 280 - 16 * 2 (280 is a min dialog width)
            child: AnimatedCrossFade(
              duration: Duration(milliseconds: 200),
              crossFadeState: exporter.isInitial
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: ExportForm(
                selectedOption: exporter.selectedOption,
                onValueChanged: exporter.onExportOptionChanged,
              ),
              secondChild: ExportPreview(),
            ),
          ),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    final exporter = context.watch<ExporterModel>();

    if (exporter.isInitial)
      return _buildExportButton();
    else if (exporter.isExporting)
      return _buildButtonsForProgress();
    else
      return _buildButtonsForDone();
  }

  Widget _buildExportButton() {
    return ElevatedButton(
      child: Text('Export'),
      onPressed: () {
        final exporter = context.read<ExporterModel>();
        exporter.start();
      },
    );
  }

  Widget _buildButtonsForProgress() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            child: Text('Cancel'),
            onPressed: () {
              final exporter = context.read<ExporterModel>();
              exporter.cancel();
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            child: Text('Share'),
            onPressed: null,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsForDone() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            child: Text('Done'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            key: shareButtonKey,
            child: Text('Share'),
            onPressed: () {
              final exporter = context.read<ExporterModel>();
              exporter.shareOutputFile(_calcIPadSharePositionOrigin());
            },
          ),
        ),
      ],
    );
  }

  Rect _calcIPadSharePositionOrigin() {
    final shareButtonBox =
        shareButtonKey.currentContext?.findRenderObject() as RenderBox?;

    return shareButtonBox != null
        ? shareButtonBox.localToGlobal(Offset.zero) & shareButtonBox.size
        : Offset.zero & Size.square(1);
  }
}
