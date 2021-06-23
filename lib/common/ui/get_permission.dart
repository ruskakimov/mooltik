import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionStrings = {
  Permission.storage: 'Storage',
};

/// Handles permission flow and executes your code that required the permission.
Future<void> getPermission({
  required BuildContext context,
  required Permission permission,
  required VoidCallback onGranted,
}) async {
  assert(
    permissionStrings.containsKey(permission),
    'Permission string must be defined.',
  );

  final storageStatus = await permission.request();

  if (storageStatus.isGranted) {
    onGranted();
  } else if (storageStatus.isPermanentlyDenied) {
    _openAllowAccessDialog(
      context: context,
      name: permissionStrings[permission]!,
    );
  }
}

Future<void> _openAllowAccessDialog({
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
