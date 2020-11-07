import 'dart:io';
import 'package:path/path.dart' as p;

class Project {
  Project(this.directory)
      : id = int.parse(p.basename(directory.path).split('_').last);

  final Directory directory;

  final int id;
}
