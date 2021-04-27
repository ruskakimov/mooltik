import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiscordSliver extends StatelessWidget {
  const DiscordSliver({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text('Share your thoughts and creations.'),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: Icon(FontAwesomeIcons.discord),
            label: Text('Join Discord community'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
