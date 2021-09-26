import 'package:mooltik/common/data/project/image_interface.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';

abstract class FrameInterface implements TimeSpan {
  ImageInterface get image;
  Duration get duration;
}
