import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

abstract class Generator {
  Generator(this.temporaryDirectory);

  /// Temporary directory for writting files with intermediate results.
  final Directory temporaryDirectory;

  bool get isCancelled => _isCancelled;
  bool _isCancelled = false;

  /// Generates and writes an output to a file.
  ///
  /// Returns `null` if operation is cancelled.
  /// Throws if fails to generate an output.
  Future<File?> generate();

  /// Cancels ongoing output generation.
  ///
  /// Nothing happens if there is no ongoing generation.
  @mustCallSuper
  Future<void> cancel() async {
    _isCancelled = true;
  }

  File makeTemporaryFile(String fileName) =>
      File(p.join(temporaryDirectory.path, fileName));
}
