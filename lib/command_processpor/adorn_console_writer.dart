import 'dart:io';

class AdornConsoleWriter {
  /// writes a [message] in black.
  static writeInBlack(String message) {
    stdout.writeln(message);
  }

  /// writes a [message] in red.
  static writeInRed(String message) {
    stdout.writeln('\x1B[91m' + message + '\x1B[0m');
  }

  /// writes a [message] in green.
  static writeInGreen(String message) {
    stdout.writeln('\x1B[92m' + message + '\x1B[0m');
  }

  /// writes a [message] in yellow.
  static writeInYellow(String message) {
    stdout.writeln('\x1B[93m' + message + '\x1B[0m');
  }

  /// writes a [message] in blue.
  static writeInBlue(String message) {
    stdout.writeln('\x1B[94m' + message + '\x1B[0m');
  }
}