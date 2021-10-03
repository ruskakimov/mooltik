import 'package:mooltik/common/data/project/base_image.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';

abstract class FrameInterface implements TimeSpan {
  BaseImage get image;
  Duration get duration;
}
