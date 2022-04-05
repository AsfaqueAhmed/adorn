import 'dart:io';

import 'package:adorn/command_processpor/constants/folder_allocation.dart';
import 'package:adorn/command_processpor/constants/stubs/stubs.dart';

import '../adorn_console_writer.dart';
import 'file_io_service.dart';

class AdornCliService {
  static Future initStructure(List<String> args) async {
    if (args.isNotEmpty) {
      AdornConsoleWriter.writeInYellow(
          "There is no options as ${args.toString()}");
      exit(0);
    }

    await makeDirectory(controllerFolder);
    AdornConsoleWriter.writeInBlack("Controller folder created");
    await makeDirectory(servicesFolder);
    AdornConsoleWriter.writeInBlack("Service folder created");
    await makeDirectory(utilityFolder);
    AdornConsoleWriter.writeInBlack("Utility folder created");
    await makeDirectory(widgetFolder);
    AdornConsoleWriter.writeInBlack("Widget folder created");
    await makeDirectory(blocFolder);
    AdornConsoleWriter.writeInBlack("Bloc folder created");
    await makeDirectory(pageFolder);
    AdornConsoleWriter.writeInBlack("Page folder created");
    await makeDirectory(modelFolder);
    AdornConsoleWriter.writeInBlack("Model folder created");
    await makeDirectory(themeFolder);
    AdornConsoleWriter.writeInBlack("Theme folder created");

    await createTheme(['adorn_light_theme', 'light', 'default', 'force']);
    await createTheme(['adorn_dark_theme', 'dark', 'default', 'force']);

    await createMainFile();
    await createRouteFile();
  }

  static Future createMainFile() async {
    await createNewFile(mainFile, mainFileStub);
  }

  static Future createRouteFile() async {
    await createNewFile(routeFile, routeFileStub);
  }

  static Future createTheme(List<String> args) async {
    _isEmptyArgs(args);

    if (args.first.trim() == "") {
      AdornConsoleWriter.writeInRed(
          'You cannot create a Theme with an empty string');
      createThemeHelp();
      exit(1);
    }

    if (args.last == '-h' || args.last == 'help') {
      createThemeHelp();
      exit(0);
    }

    bool forceCreate = _forceCreate(args);

    await makeDirectory(themeFolder);
    String filePath = "$themeFolder/${args[0]}.dart";
    late String stab;
    if (args.length > 2 && args.last == 'default') {
      String brightness = args.length > 2 ? args[args.length - 2] : 'light';
      if (brightness == 'light') {
        stab = defaultLightStab(args.first, brightness);
      } else if (brightness == 'dark') {
        stab = defaultDarkStab(args.first, brightness);
      } else {
        AdornConsoleWriter.writeInRed("Please provide valid brightness");
        createThemeHelp();
        exit(32);
      }
    } else {
      var brightness = args.length > 1 ? args.last : 'light';

      if (brightness != 'light' || brightness != 'dark') {
        AdornConsoleWriter.writeInRed("Please provide valid brightness");
        createThemeHelp();
        exit(33);
      }

      stab = themeStab(args.first, brightness);
    }
    await _createFile(filePath, forceCreate, stab);
  }

  static void createThemeHelp() {
    AdornConsoleWriter.writeInBlue("Use command as follows: ");
    AdornConsoleWriter.writeInBlack(
        "create:theme theme_name [light/dark] [default] [force] [-h/help]");
  }

  static Future createPage(List<String> args) async {
    _isEmptyArgs(args);

    if (args.first.trim() == "") {
      AdornConsoleWriter.writeInRed(
          'You cannot create a page with an empty string');
      createPageHelp();
      exit(1);
    }

    if (args.last == '-h' || args.last == 'help') {
      createPageHelp();
      exit(0);
    }

    bool forceCreate = _forceCreate(args);

    await makeDirectory("$pageFolder/${args[0]}");

    if (_withBloc(args) && _withController(args)) {
      await _createPageWithControllerAndBloc(args, forceCreate);
    } else if (_withController(args)) {
      await _createPageWithController(args, forceCreate);
    } else if (_withBloc(args)) {
      await _createPageWithBloc(args, forceCreate);
    } else {
      await _createPage(args, forceCreate);
    }
  }

  static void createPageHelp() {
    AdornConsoleWriter.writeInBlue("Use command as follows: ");
    AdornConsoleWriter.writeInBlack(
        "create:page page_name [+controller/+c] [+bloc/+b]");
  }

  static Future createBloc(List<String> args) async {
    _isEmptyArgs(args);

    if (args.first.trim() == "") {
      AdornConsoleWriter.writeInRed(
          'You cannot create a bloc with an empty string');
      createPageHelp();
      exit(1);
    }

    if (args.last == '-h' || args.last == 'help') {
      createPageHelp();
      exit(0);
    }

    bool forceCreate = _forceCreate(args);

    await _createBloc(args, forceCreate);
  }

  static Future<void> _createBloc(List<String> args, bool forceCreate) async {
    await makeDirectory(blocFolder);
    String blocPath = "$blocFolder/${args[0]}_bloc.dart";
    late String stub = blocStub(args[0]);

    await _createFile(blocPath, forceCreate, stub);
  }

  static void createBlocHelp() {
    AdornConsoleWriter.writeInBlue("Use command as follows: ");
    AdornConsoleWriter.writeInBlack("create:bloc bloc_name");
  }

  static Future createWidget(List<String> args) async {
    _isEmptyArgs(args);

    if (args.first.trim() == "") {
      AdornConsoleWriter.writeInRed(
          'You cannot create a widget with an empty string');
      createWidgetHelp();
      exit(1);
    }

    if (args.last == '-h' || args.last == 'help') {
      createWidgetHelp();
      exit(0);
    }

    bool forceCreate = _forceCreate(args);

    await makeDirectory(widgetFolder);

    if (_withController(args) || args.contains("+c")) {
      await _createWidgetWithController(args, forceCreate);
    } else {
      await _createWidget(args, forceCreate);
    }
  }

  static Future<void> _createPage(List<String> args, bool forceCreate) async {
    String stubForPage = pageStub(args[0]);

    await _createPageFromStub(args, forceCreate, stubForPage);
  }

  static Future<void> _createPageWithController(
      List<String> args, bool forceCreate) async {
    String stubForPage = pageStubWithController(args[0]);

    await _createPageFromStub(args, forceCreate, stubForPage);

    await _createPageController(args, forceCreate);
  }

  static Future<void> _createPageController(
      List<String> args, bool forceCreate) async {
    String pageControllerPath =
        "$pageFolder/${args[0]}/${args[0]}_controller.dart";
    String controllerStub = pageControllerStub(args[0]);

    await _createFile(pageControllerPath, forceCreate, controllerStub);
  }

  static Future<void> _createPageWithBloc(
      List<String> args, bool forceCreate) async {
    String stubForPage = pageStubWithBloc(args[0]);

    await _createPageFromStub(args, forceCreate, stubForPage);

    await _createBloc(args, forceCreate);
  }

  static Future<void> _createPageFromStub(
      List<String> args, bool forceCreate, String stubForPage) async {
    await makeDirectory("$pageFolder/${args[0]}");
    String pageFilePath = "$pageFolder/${args[0]}/${args[0]}.dart";
    await _createFile(pageFilePath, forceCreate, stubForPage);
  }

  static Future<void> _createPageWithControllerAndBloc(
      List<String> args, bool forceCreate) async {
    String stubForPage = pageStubWithControllerAndBloc(args[0]);

    await _createPageFromStub(args, forceCreate, stubForPage);

    await _createBloc(args, forceCreate);

    await _createPageController(args, forceCreate);
  }

  static Future<void> _createWidget(List<String> args, bool forceCreate) async {
    String widgetFilePath = "$widgetFolder/${args[0]}_widget.dart";
    late String stubForWidget = widgetStub(args[0]);

    await _createFile(widgetFilePath, forceCreate, stubForWidget);
  }

  static Future<void> _createWidgetWithController(
      List<String> args, bool forceCreate) async {
    await makeDirectory("$widgetFolder/${args[0]}");
    String widgetFilePath = "$widgetFolder/${args[0]}/${args[0]}_widget.dart";
    String stubForWidget = widgetStubWithController(args[0]);

    await _createFile(widgetFilePath, forceCreate, stubForWidget);

    String widgetControllerPath =
        "$widgetFolder/${args[0]}/${args[0]}_widget_controller.dart";
    String controllerStub = widgetControllerStub(args[0]);

    await _createFile(widgetControllerPath, forceCreate, controllerStub);
  }

  static void createWidgetHelp() {
    AdornConsoleWriter.writeInBlue("Use command as follows: ");
    AdornConsoleWriter.writeInBlack(
        "create:widget widget_name [+controller/+c]");
  }

  static bool _withController(List<String> args) =>
      args.contains("+controller") || args.contains("+c");

  static bool _withBloc(List<String> args) =>
      args.contains("+bloc") || args.contains("+b");

  static void _isEmptyArgs(List<String> args) {
    if (args.isEmpty) {
      AdornConsoleWriter.writeInRed("Please define theme file name");
      createThemeHelp();
      exit(1);
    }
  }

  static Future<void> _createFile(
    String filePath,
    bool forceCreate,
    String stub,
  ) async {
    await checkIfFileExists(filePath, shouldForceCreate: forceCreate);
    await createNewFile(filePath, stub);
  }

  static bool _forceCreate(List<String> args) {
    bool forceCreate = args.last == 'force';
    if (forceCreate) {
      args.removeAt(args.length - 1);
    }
    return forceCreate;
  }
}
