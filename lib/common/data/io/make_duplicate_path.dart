import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

/// Returns an unoccupied duplicate path.
String makeFreeDuplicatePath(String originalPath) {
  var duplicatePath = makeDuplicatePath(originalPath);

  while (File(duplicatePath).existsSync()) {
    duplicatePath = makeDuplicatePath(duplicatePath);
  }

  return duplicatePath;
}

/// Returns a new path for a duplicate file.
/// `example/path/image.png` -> `example/path/image_1.png`
/// `example/path/image_1.png` -> `example/path/image_2.png`
@visibleForTesting
String makeDuplicatePath(String path) {
  final dir = p.dirname(path);
  final name = p.basenameWithoutExtension(path);
  final ext = p.extension(path);

  final newName =
      _hasCounter(name) ? _incrementCounter(name) : _createCounter(name);

  return p.join(dir, newName + ext);
}

bool _hasCounter(String name) {
  return RegExp(r'_\d+$').hasMatch(name);
}

String _createCounter(String name) {
  return name + '_1';
}

String _incrementCounter(String name) {
  final parts = name.split('_');

  final newCounterValue = int.parse(parts.last) + 1;
  parts.last = newCounterValue.toString();

  return parts.join('_');
}
