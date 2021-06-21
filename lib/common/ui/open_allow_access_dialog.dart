import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> openAllowAccessDialog({
  required BuildContext context,
  required String name,
}) async {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Allow access to $name'),
      content: Text('Tap Settings and enable $name'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('SETTINGS'),
        ),
      ],
    ),
  );
}
