import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/onion_model.dart';

class DrawingMenu extends StatelessWidget {
  const DrawingMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onion = context.watch<OnionModel>();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        ListTile(
          title: Text('Onion skinning'),
          trailing: Switch(
            value: onion.enabled,
            onChanged: (_) => onion.toggle(),
          ),
          onTap: () => onion.toggle(),
        ),
        Divider(),
        ListTile(
          title: Text('Add empty frame'),
          onTap: () {},
        ),
        ListTile(
          title: Text('Duplicate this frame'),
          onTap: () {},
        ),
      ],
    );
  }
}
