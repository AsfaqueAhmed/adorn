import 'package:adorn/base/model/adorn_theme.dart';
import 'package:adorn/base/resource/dark_theme.dart';
import 'package:adorn/base/resource/light_theme.dart';
import 'package:adorn/base/resource/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdornApp extends StatefulWidget {
  AdornApp({
    Key? key,
    required this.appBuilder,
    AdornTheme? theme,
    AdornTheme? darkTheme,
    this.currentLanguage,
  })
      : theme = {
    "light": theme ?? AdornLightTheme(),
    'dark': darkTheme ?? AdornDarkTheme(),
  },
        super(key: key ?? GlobalKey<_AdornAppState>());

  AdornApp.multiTheme({
    Key? key,
    required this.appBuilder,
    required this.theme,
    this.currentLanguage,
  }) : super(key: key ?? GlobalKey<_AdornAppState>());

  final BuildApp appBuilder;
  final Map<String, AdornTheme> theme;
  final String? currentLanguage;

  static AdornApp? of(BuildContext context) {
    final AdornApp? result = context.findAncestorWidgetOfExactType<AdornApp>();
    assert(result != null, 'No Themed APP found in context');
    return result;
  }

  switchTheme({String? themeName}) {
    int availableTheme = 0;
    theme.forEach((key, value) {
      availableTheme++;
    });
    if (availableTheme > 1) {
      (key as GlobalKey<_AdornAppState>).currentState!.switchTheme(themeName);
    }
  }

  switchLanguage({required String language}) {
    (key as GlobalKey<_AdornAppState>).currentState!.switchLanguage(language);
  }

  AdornTheme getCurrentTheme() {
    return (key as GlobalKey<_AdornAppState>).currentState!.currentTheme;
  }

  String getCurrentLanguage() {
    return (key as GlobalKey<_AdornAppState>).currentState!.currentLanguage;
  }

  @override
  _AdornAppState createState() => _AdornAppState();
}

class _AdornAppState extends State<AdornApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _themeAnimation;

  String currentThemeName = '';
  String changedThemeName = '';

  String currentLanguage = "en";

  late AdornTheme currentTheme;
  AdornTheme? changedTheme;

  @override
  void initState() {
    currentLanguage = widget.currentLanguage ?? 'en';
    currentThemeName = "light";
    currentTheme = widget.theme[currentThemeName]!;
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
      value: currentTheme.brightness == Brightness.light ? SystemUiOverlayStyle
          .dark.copyWith(
        statusBarColor: currentTheme.statusBarColor,
      ) : SystemUiOverlayStyle.light.copyWith(
        statusBarColor: currentTheme.statusBarColor,
      ),
      child: widget.appBuilder(context, getTheme(theme: currentTheme)),
    );
  }

  void switchTheme(String? themeName) {
    if (themeName == null) {
      widget.theme.forEach((key, value) {
        if (currentThemeName != key) {
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
        currentTheme = changedTheme!;
        currentThemeName = changedThemeName;
        _themeAnimation.value = 0;
      });
    }
  }

  void switchLanguage(String language) {
    setState(() {
      currentLanguage = language;
    });
  }
}

typedef BuildApp = Function(BuildContext, ThemeData);
