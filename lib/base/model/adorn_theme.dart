import 'package:adorn/base/resource/theme.dart';
import 'package:flutter/material.dart';

abstract class AdornTheme {
  abstract String themeName;

  abstract Brightness brightness;

  abstract Color primaryColor;
  abstract Color secondaryColor;
  abstract Color backgroundColor;

  abstract Color textColor1;

  Color statusBarColor = Colors.transparent;

  Brightness statusBarIconBrightness = Brightness.light;

  Color? textColor2;
  Color? textColor3;

  Color backgroundColorLighter(double percent) =>
      backgroundColor.lighten(percent);

  Color backgroundColorDarken(double percent) =>
      backgroundColor.darken(percent);

  Color? backgroundColor2;
  Color? backgroundColor3;

  abstract Color appbarColor;

  abstract TextStyle defaultTextStyle;

  Color? appbarTitleColor;

  @mustCallSuper
  AdornTheme() {
    textColor2 ??= textColor1.lighten(25);
    textColor3 ??= textColor1.lighten(50);

    backgroundColor2 ??= backgroundColor;
    backgroundColor3 ??= backgroundColor;
  }

  Color errorColor = Colors.red;
}
