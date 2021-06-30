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
      child: _PreviewBox(
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieProgressIndicator(progress: exporter.progress),
            _PlayIcon(visible: exporter.isDone),
          ],
        ),
      ),
    );
  }
}

class _PreviewBox extends StatelessWidget {
  const _PreviewBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _PlayIcon extends StatelessWidget {
  const _PlayIcon({
    Key? key,
    required this.visible,
  }) : super(key: key);

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: Icon(
        Icons.play_arrow_rounded,
        color: Colors.black,
        size: 48,
      ),
    );
  }
}
