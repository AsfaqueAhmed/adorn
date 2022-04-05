import 'package:adorn/base/model/adorn_theme.dart';
import 'package:adorn/base/resource/dark_theme.dart';
import 'package:adorn/base/resource/light_theme.dart';
import 'package:adorn/base/resource/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///create a folder named bloc and pless this file there
class ThemedApp extends StatefulWidget {
  ThemedApp({
    Key? key,
    required this.appBuilder,
    AdornTheme? theme,
    AdornTheme? darkTheme,
  })
      : theme = {
    "light": theme ?? AdornLightTheme(),
    'dark': darkTheme ?? AdornDarkTheme(),
  },
        super(key: key ?? GlobalKey<_ThemedAppState>());

  ThemedApp.multiTheme({
    Key? key,
    required this.appBuilder,
    required this.theme,
  }) : super(key: key ?? GlobalKey<_ThemedAppState>());

  final BuildApp appBuilder;
  final Map<String, AdornTheme?> theme;

  static ThemedApp? of(BuildContext context) {
    final ThemedApp? result =
    context.findAncestorWidgetOfExactType<ThemedApp>();
    assert(result != null, 'No Themed APP found in context');
    return result;
  }

  switchTheme({String? themeName}) {
    int availableTheme = 0;
    theme.forEach((key, value) {
      if (value != null) availableTheme++;
    });
    if (availableTheme > 1) {
      (key as GlobalKey<_ThemedAppState>).currentState!.switchTheme(themeName);
    }
  }

  getCurrentTheme() {
    return (key as GlobalKey<_ThemedAppState>).currentState!.currentTheme;
  }

  @override
  _ThemedAppState createState() => _ThemedAppState();
}

class _ThemedAppState extends State<ThemedApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _themeAnimation;

  String currentThemeName = '';
  String changedThemeName = '';

  AdornTheme? currentTheme;
  AdornTheme? changedTheme;

  @override
  void initState() {
    currentThemeName = "light";
    currentTheme = widget.theme[currentThemeName];
    _themeAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    super.initState();
  }

  @override
  void dispose() {
    _themeAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: currentTheme?.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ), child: widget.appBuilder(context, getTheme(theme: currentTheme!)),);
  }

  void switchTheme(String? themeName) {
    if (themeName == null) {
      widget.theme.forEach((key, value) {
        if (value != null && currentThemeName != key) {
          changedTheme = value;
          changedThemeName = key;
        }
      });
    } else {
      changedTheme = widget.theme[themeName];
      changedThemeName = themeName;
    }

    if (mounted) {
      setState(() {
        currentTheme = changedTheme;
        currentThemeName = changedThemeName;
        _themeAnimation.value = 0;
      });
    }
  }
}

typedef BuildApp = Function(BuildContext, ThemeData);
