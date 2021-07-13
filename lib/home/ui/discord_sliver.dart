import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscordSliver extends StatelessWidget {
  const DiscordSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            [
              'Ask for more features.',
              'Get technical support.',
              'Look what others have created.',
            ].join('\n'),
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.4),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: Icon(FontAwesomeIcons.discord),
            label: Text('Join Discord community'),
            onPressed: () => launch('https://discord.gg/qCra96BsN4'),
          ),
        ],
      ),
    );
  }
}
