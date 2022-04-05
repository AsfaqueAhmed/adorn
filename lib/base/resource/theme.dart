import 'dart:math';

import 'package:adorn/base/model/adorn_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextStyle headline1TextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 96,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      color: color,
    );

TextStyle headline2TextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 60,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      color: color,
    );

TextStyle headline3TextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 48,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: color,
    );

TextStyle headline4TextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 34,
      fontWeight: FontWeight.w400,
      letterSpacing: .25,
      color: color,
    );

TextStyle headline5TextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: color,
    );

TextStyle headline6TextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: .15,
      color: color,
    );

TextStyle subTitle1TextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: .15,
      color: color,
    );

TextStyle subTitle2TextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: .1,
      color: color,
    );

TextStyle body1TextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: .5,
      color: color,
    );

TextStyle body2TextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: .25,
      color: color,
    );

TextStyle buttonTextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      color: color,
    );

TextStyle captionTextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: .4,
      color: color,
    );

TextStyle overlineTextStyle(TextStyle defaultStyle, {required Color color}) =>
    defaultStyle.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: color,
    );

getTextTheme(Color textColor, TextStyle defaultStyle) {
  return TextTheme(
    headline1: headline1TextStyle(defaultStyle, color: textColor),
    headline2: headline2TextStyle(defaultStyle, color: textColor),
    headline3: headline3TextStyle(defaultStyle, color: textColor),
    headline4: headline4TextStyle(defaultStyle, color: textColor),
    headline5: headline5TextStyle(defaultStyle, color: textColor),
    headline6: headline6TextStyle(defaultStyle, color: textColor),
    subtitle1: subTitle1TextStyle(defaultStyle, color: textColor),
    subtitle2: subTitle2TextStyle(defaultStyle, color: textColor),
    bodyText1: body1TextStyle(defaultStyle, color: textColor),
    bodyText2: body2TextStyle(defaultStyle, color: textColor),
    button: buttonTextStyle(defaultStyle, color: textColor),
    caption: captionTextStyle(defaultStyle, color: textColor),
    overline: overlineTextStyle(defaultStyle, color: textColor),
  );
}

MaterialColor _matColor(Color color) {
  return MaterialColor(color.value, {
    50: color.darken(90),
    100: color.darken(70),
    200: color.darken(50),
    300: color.darken(30),
    400: color.darken(10),
    500: color,
    600: color.lighten(20),
    700: color.lighten(40),
    800: color.lighten(60),
    900: color.lighten(80),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

enum ThemeType { dark, light }

///create a folder named config and pless this file there
getTheme({required AdornTheme theme}) {
  var appbarTextColor = theme.appbarTitleColor ??
      (theme.brightness == Brightness.light ? Colors.black : Colors.white);
  return ThemeData(
    brightness: theme.brightness,
    textTheme: getTextTheme(theme.textColor1, theme.defaultTextStyle),
    scaffoldBackgroundColor: theme.backgroundColor,
    backgroundColor: theme.backgroundColor,
    colorScheme: ColorScheme(
        primary: theme.primaryColor,
        primaryVariant: theme.primaryColor,
        secondary: theme.secondaryColor,
        secondaryVariant: theme.secondaryColor,
        surface: theme.backgroundColor,
        background: theme.backgroundColor,
        error: theme.errorColor,
        onPrimary: theme.primaryColor,
        onSecondary: theme.secondaryColor,
        onSurface: theme.backgroundColor,
        onBackground: theme.backgroundColor,
        onError: theme.errorColor,
        brightness: theme.brightness),
    appBarTheme: AppBarTheme(
      backgroundColor: theme.appbarColor,
      iconTheme: IconThemeData(
        color: appbarTextColor,
      ),
      actionsIconTheme: IconThemeData(
        color: appbarTextColor,
      ),
      titleTextStyle: headline6TextStyle(
        theme.defaultTextStyle,
        color: appbarTextColor,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: theme.brightness,
        statusBarIconBrightness: theme.brightness,
        statusBarColor: Colors.transparent,
      ),
    ),
  );
}

extension LightenAndDarken on Color {
  Color darken(double percent) {
    assert(percent < 100 && percent > 0);
    return shadeColor(this, percent / 100);
  }

  Color lighten(double percent) {
    assert(percent < 100 && percent > 0);
    return tintColor(this, percent / 100);
  }
}
