import 'package:flutter/material.dart';

class DrawingMenu extends StatelessWidget {
  const DrawingMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        ListTile(
          title: Text('Onion skinning'),
          trailing: Switch(value: false),
          onTap: () {},
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
