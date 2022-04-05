import 'dart:io';

import '../adorn_console_writer.dart';

/// Creates a new file from a [path] and [value].
createNewFile(String path, String value) async {
  AdornConsoleWriter.writeInYellow("Creating File $path");
  final File file = File(path);
  await file.writeAsString(value);
  AdornConsoleWriter.writeInGreen("Created File $path");
}

/// Creates a new directory from a [path] if it doesn't exist.
makeDirectory(String path) async {
  Directory directory = Directory(path);
  if (!(await directory.exists())) {
    String rootDir = path.substring(0, path.lastIndexOf('/'));
    await makeDirectory(rootDir);

    await directory.create();

    AdornConsoleWriter.writeInBlack("Folder created $path");
  }
}

/// Checks if a file exists from a [path].
/// Use [shouldForceCreate] to override check.
checkIfFileExists(path, {bool shouldForceCreate = false}) async {
  if (await File(path).exists() && shouldForceCreate == false) {
    AdornConsoleWriter.writeInRed('$path already exists');
    exit(1);
  }
}


/// Check if a file exist by passing in a [path].
hasFile(path) async {
  return await File(path).exists();
}
