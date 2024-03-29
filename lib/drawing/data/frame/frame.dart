import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/extensions/duration_methods.dart';
import 'package:mooltik/common/data/project/fps_config.dart';
import 'package:mooltik/common/data/project/frame_interface.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:path/path.dart' as p;

/// Single image with duration.
class Frame extends TimeSpan with EquatableMixin implements FrameInterface {
  Frame({
    required this.image,
    Duration duration = const Duration(milliseconds: singleFrameMs * 5),
  }) : super(duration);

  final DiskImage image;

  Future<Frame> duplicate() async {
    return this.copyWith(image: await image.duplicate());
  }

  /// Creates an empty frame with the same dimensions and duration.
  Future<Frame> cloneEmpty() async {
    return this.copyWith(image: await image.cloneEmpty());
  }

  factory Frame.fromJson(
    Map<String, dynamic> json,
    String frameDirPath,
    int width,
    int height,
  ) =>
      Frame(
        image: DiskImage(
          file: File(p.join(frameDirPath, json[_fileNameKey])),
          width: width,
          height: height,
        ),
        duration: (json[_durationKey] as String).parseDuration(),
      );

  Map<String, dynamic> toJson() => {
        _fileNameKey: p.basename(image.file.path),
        _durationKey: duration.toString(),
      };

  @override
  Frame copyWith({
    DiskImage? image,
    Duration? duration,
  }) =>
      Frame(
        image: image ?? this.image,
        duration: duration ?? this.duration,
      );

  void dispose() {
    image.dispose();
  }

  @override
  List<Object> get props => [image.file.path, duration];

  static const String _fileNameKey = 'file_name';
  static const String _durationKey = 'duration';
}
