import 'dart:io';

import 'package:adorn/command_processpor/adorn_comand_processor.dart';
import 'package:adorn/command_processpor/adorn_console_writer.dart';

void main(List<String> args) async {
  var time = Stopwatch();
  bool hasDebugFlag = args.contains("--debug");
  if (hasDebugFlag == true) {
    time.start();
    args.removeWhere((element) => element == "--debug");
  }
  await AdornCommandProcessor.processCommand(args);
  if (hasDebugFlag == true) {
    time.stop();
    AdornConsoleWriter.writeInBlack(
        'Time: ${time.elapsed.inMilliseconds} Milliseconds');
  }
  exit(0);
}
