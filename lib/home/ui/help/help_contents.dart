import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/ui/sheet_title.dart';

class _TutorialData {
  final String title;
  final String description;
  final String videoUri;

  const _TutorialData(this.title, this.description, this.videoUri);
}

const _tutorialData = [
  _TutorialData(
    'Basics',
    'Learn how to change frame duration, loop animation, and work with layers.',
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
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
            padding: const EdgeInsets.only(bottom: 32),
            itemBuilder: (context, index) {
              final data = _tutorialData[index];

              return _TutorialItem(
                title: '${index + 1}. ${data.title}',
                description: data.description,
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
  }) : super(key: key);

  final String title;
  final String description;

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
          _Thumbnail(),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Icon(
          MdiIcons.youtube,
          size: 64,
          color: Colors.red,
        ),
      ],
    );
  }
}
