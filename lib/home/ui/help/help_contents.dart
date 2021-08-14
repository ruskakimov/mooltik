import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/ui/sheet_title.dart';
import 'package:url_launcher/url_launcher.dart';

class _TutorialData {
  final String title;
  final String description;
  final String videoUri;

  const _TutorialData(
    this.title,
    this.description,
    this.videoUri,
  );
}

const _tutorialData = [
  _TutorialData(
    'Basics',
    'Learn how to change frame duration, loop animation, and work with layers.',
    'https://youtu.be/MrD6UXaOCGI',
  ),
];

class HelpContents extends StatelessWidget {
  const HelpContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SheetTitle('Tutorials'),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 32,
            ),
            itemBuilder: (context, index) {
              final data = _tutorialData[index];
              final id = index + 1;

              return _TutorialItem(
                title: '$id. ${data.title}',
                description: data.description,
                videoUri: data.videoUri,
                thumbnailPath: 'assets/tutorial_thumbnails/$id.png',
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 32),
            itemCount: _tutorialData.length,
          ),
        ),
      ],
    );
  }
}

class _TutorialItem extends StatelessWidget {
  const _TutorialItem({
    Key? key,
    required this.title,
    required this.description,
    required this.videoUri,
    required this.thumbnailPath,
  }) : super(key: key);

  final String title;
  final String description;
  final String videoUri;
  final String thumbnailPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          _Thumbnail(
            videoUri: videoUri,
            thumbnailPath: thumbnailPath,
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    Key? key,
    required this.videoUri,
    required this.thumbnailPath,
  }) : super(key: key);

  final String videoUri;
  final String thumbnailPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(videoUri)) {
          await launch(videoUri);
        } else {
          throw Exception('Failed to open tutorial video $videoUri.');
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 140,
              width: 140,
              foregroundDecoration: BoxDecoration(color: Colors.black54),
              child: Image.asset(thumbnailPath),
            ),
          ),
          Icon(
            MdiIcons.youtube,
            size: 64,
          ),
        ],
      ),
    );
  }
}
