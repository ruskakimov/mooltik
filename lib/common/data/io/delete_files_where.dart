import 'dart:io';

/// Deletes some files from given directory.
Future<void> deleteFilesWhere(
  Directory directory,
  bool Function(String filePath) test,
) async {
  final List<FileSystemEntity> filesToDelete = await directory
      .list()
      .where((entity) => entity is File && test(entity.path))
      .toList();

  await Future.wait(filesToDelete.map((file) => file.delete()));
}
