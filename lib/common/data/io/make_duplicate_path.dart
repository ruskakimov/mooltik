import 'package:path/path.dart' as p;

/// Returns new duplicate path of the given path.
String makeDuplicatePath(String path) {
  final dir = p.dirname(path);
  final name = p.basenameWithoutExtension(path);
  final ext = p.extension(path);
  return p.join(dir, name + '_1' + ext);
}
