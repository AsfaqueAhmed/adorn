library adorn;

import 'dart:io';

import 'adorn_comand.dart';
import 'adorn_console_writer.dart';
import 'constants/stubs/stubs.dart';
import 'services/adorn_cli_service.dart';

class AdornCommandProcessor {
  static List<AdornCommand> commands = [
    AdornCommand(
        commandName: 'init',
        commandType: 'project',
        operation: AdornCliService.initStructure,
        options: ['-h']),
    AdornCommand(
        commandName: 'theme',
        commandType: 'create',
        operation: AdornCliService.createTheme,
        options: ['dark', 'light', 'default', '-h', 'help', 'force']),
    AdornCommand(
        commandName: 'page',
        commandType: 'create',
        operation: AdornCliService.createPage,
        options: ['+controller', '+bloc', '-h', 'help', 'force']),
    AdornCommand(
        commandName: 'widget',
        commandType: 'create',
        operation: AdornCliService.createWidget,
        options: ['+controller',  '-h', 'help', 'force']),
    AdornCommand(
        commandName: 'bloc',
        commandType: 'create',
        operation: AdornCliService.createBloc,
        options: []),
  ];

  static Future processCommand(List<String> arguments) async {
    if (arguments.isEmpty) {
      AdornConsoleWriter.writeInBlack(infoStub);
      return;
    }

    if (commands.isEmpty) {
      AdornConsoleWriter.writeInBlack(
          'There is no operator for cli operations');
      exit(1);
    }
    List<String> argumentSplit = arguments[0].split(":");

    if (argumentSplit.isEmpty || argumentSplit.length <= 1) {
      AdornConsoleWriter.writeInBlack(
          'Invalid arguments ' + arguments.toString());
      exit(2);
    }

    String operationType = argumentSplit[0];
    String operationName = argumentSplit[1];

    AdornCommand? operator;
    for (AdornCommand element in commands) {
      if (element.commandType == operationType &&
          operationName == element.commandName) {
        operator = element;
        break;
      }
    }

    if (operator == null) {
      AdornConsoleWriter.writeInBlack(
          'Invalid arguments ' + arguments.toString());
      exit(1);
    }

    arguments.removeAt(0);
    await operator.operation(arguments);
  }
}
