import 'package:gallery_saver/gallery_saver.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> saveVideoToGallery(String path) async {
  try {
    final success =
        await GallerySaver.saveVideo(path).timeout(Duration(seconds: 5));

    if (success != true) {
      throw Exception(
          'Failed when tried uploading video to the gallery. Return value: $success');
    }
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
  }
}
