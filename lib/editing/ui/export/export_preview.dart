import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';
import 'package:mooltik/editing/data/export/exporter_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/ui/export/pie_progress_indicator.dart';

class ExportPreview extends StatelessWidget {
  const ExportPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exporter = context.watch<ExporterModel>();

    return GestureDetector(
      onTap: exporter.isDone ? exporter.openOutputFile : null,
      child: _PreviewBox(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (exporter.isVideoExport)
              _FadeInThumbnail(
                thumbnail: exporter.videoPreviewImage,
                fullyVisible: exporter.isDone,
              ),
            PieProgressIndicator(
              progress: exporter.progress,
            ),
            _FadeInIconButton(
              icon: exporter.isVideoExport
                  ? Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 48,
                    )
                  : Icon(
                      MdiIcons.zipBox,
                      color: Colors.black,
                      size: 36,
                    ),
              visible: exporter.isDone,
            ),
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
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: child,
      ),
    );
  }
}

class _FadeInThumbnail extends StatelessWidget {
  const _FadeInThumbnail({
    Key? key,
    required this.thumbnail,
    required this.fullyVisible,
  }) : super(key: key);

  final CompositeImage thumbnail;
  final bool fullyVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: fullyVisible ? 1 : 0.2,
      duration: Duration(milliseconds: 300),
      child: FittedBox(
        fit: BoxFit.contain,
        child: CustomPaint(
          size: thumbnail.size,
          painter: CompositeImagePainter(thumbnail),
          isComplex: true,
        ),
      ),
    );
  }
}

class _FadeInIconButton extends StatelessWidget {
  const _FadeInIconButton({
    Key? key,
    required this.icon,
    required this.visible,
  }) : super(key: key);

  final Icon icon;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
        ),
        child: icon,
      ),
    );
  }
}
