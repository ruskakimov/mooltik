import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> openAllowAccessDialog({
  required BuildContext context,
  required String name,
}) async {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('$name permission required'),
      content: Text('Tap Settings and allow $name permission.'),
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
