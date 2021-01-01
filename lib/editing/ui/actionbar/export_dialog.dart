import 'package:flutter/material.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({
    Key key,
    this.sideWidth = 280,
    this.loadingStrokeWidth = 20,
  })  : assert(
          sideWidth >= 280,
          'Minimum flutter dialog width is 280px.',
        ),
        assert(loadingStrokeWidth < sideWidth / 2),
        super(key: key);

  final double sideWidth;
  final double loadingStrokeWidth;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: CircleBorder(),
      child: SizedBox(
        width: sideWidth,
        height: sideWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildLoadingIndicator(),
            _ExportButton(
              diameter: sideWidth - loadingStrokeWidth * 2,
              onTap: () {
                // get temp directory
                // timeline.frames -> images
                // write PNGs (cannot use project pngs, cos they have transparent bg)
                // mp4Write(slides, file, temp)
                // await ImageGallerySaver.saveFile(video.path);
              },
            ),
            // Text(
            //   '72%',
            //   style: TextStyle(
            //     fontSize: 32,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildLoadingIndicator() {
    return SizedBox(
      width: sideWidth - loadingStrokeWidth,
      height: sideWidth - loadingStrokeWidth,
      child: CircularProgressIndicator(
        value: 0,
        backgroundColor: Colors.black12,
        strokeWidth: loadingStrokeWidth,
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton({
    Key key,
    @required this.diameter,
    this.onTap,
  }) : super(key: key);

  final double diameter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).colorScheme.primary,
      highlightColor: Colors.white12,
      splashColor: Colors.white,
      shape: CircleBorder(),
      onPressed: onTap,
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Center(
          child: Text(
            'Export video',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
