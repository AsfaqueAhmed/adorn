part of 'stubs.dart';

String mainFileStub = '''import 'package:flutter/material.dart';

import 'package:adorn/base/bloc/bloc.dart';
import 'package:adorn/base/widget/themed_app.dart';
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
      child: ThemedApp(
        darkTheme: AdornDarkTheme(),
        theme: AdornLightTheme(),
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
