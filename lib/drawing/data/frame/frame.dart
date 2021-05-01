import 'dart:io';
import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/duration_methods.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:path/path.dart' as p;

/// Single image with duration.
class Frame extends TimeSpan with EquatableMixin {
  Frame({
    @required this.file,
    Duration duration = const Duration(seconds: 1),
    ui.Image snapshot,
  })  : _snapshot = snapshot,
        super(duration);

  final File file;

  Size get size => Size(width.toDouble(), height.toDouble());

  int get width => _snapshot?.width;

  int get height => _snapshot?.height;

  ui.Image get snapshot => _snapshot;
  ui.Image _snapshot;

  Future<void> loadSnapshot() async {
    _snapshot = await pngRead(file);
  }

  Future<void> saveSnapshot() async {
    await pngWrite(file, _snapshot);
  }

  factory Frame.fromJson(Map<String, dynamic> json, String frameDirPath) =>
      Frame(
        file: File(p.join(frameDirPath, json[_fileNameKey])),
        duration: (json[_durationKey] as String).parseDuration(),
      );

  factory Frame.fromLegacyJsonWithId(
    Map<String, dynamic> json,
    String frameDirPath,
  ) {
    json[_fileNameKey] = 'frame${json[_legacyIdKey]}.png';
    return Frame.fromJson(json, frameDirPath);
  }

  Map<String, dynamic> toJson() => {
        _fileNameKey: p.basename(file.path),
        _durationKey: duration.toString(),
      };

  @override
  Frame copyWith({
    File file,
    Duration duration,
    ui.Image snapshot,
  }) =>
      Frame(
        file: file ?? this.file,
        duration: duration ?? this.duration,
        snapshot: snapshot ?? this._snapshot,
      );

  @override
  List<Object> get props => [file.path, duration];
}

const String _fileNameKey = 'file_name';
const String _durationKey = 'duration';

const String _legacyIdKey = 'id';
