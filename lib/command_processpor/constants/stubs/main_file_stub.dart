part of 'stubs.dart';

String mainFileStub = '''import 'package:flutter/material.dart';

import 'package:adorn/base/bloc/bloc.dart';
import 'package:adorn/base/widget/adorn_app.dart';
import 'route.dart';

import 'res/themes/adorn_dark_theme.dart';
import 'res/themes/adorn_light_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Application());
}

class Application extends StatelessWidget {
  
  final String appName = "Adorn App";
  
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocContainer(
      child: AdornApp(
        darkTheme: AdornDarkTheme(),
        theme: AdornLightTheme(),
        currentLanguage:"en",
        appBuilder: (context, theme) => MaterialApp(
          title: appName,
          theme: theme,
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute,
          onUnknownRoute: unknownRoute,
        ),
      ),
    );
  }
}

''';
