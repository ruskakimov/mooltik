import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/export/exporter_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/ui/export/pie_progress_indicator.dart';

class ExporterPreview extends StatelessWidget {
  const ExporterPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exporter = context.watch<ExporterModel>();

    return GestureDetector(
      onTap: exporter.isDone ? exporter.openOutputFile : null,
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: PieProgressIndicator(progress: exporter.progress),
        ),
      ),
    );
  }
}
