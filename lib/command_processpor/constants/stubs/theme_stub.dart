part of 'stubs.dart';

String themeStab(String themeName, String brightness) =>
    '''import 'package:flutter/material.dart';
import 'package:adorn/base/model/app_theme.dart';

class ${ReCase(themeName).pascalCase} extends AdornTheme{
    
  @override
  Color appbarColor;

  @override
  Color backgroundColor;

  @override
  Color primaryColor;

  @override
  Color secondaryColor;

  @override
  Color textColor1;

  @override
  Brightness brightness=Brightness.$brightness;

  @override
  String themeName="$themeName";
  
}''';

String defaultLightStab(String themeName, String brightness) =>
    '''import 'package:adorn/base/model/adorn_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ${ReCase(themeName).pascalCase} extends AdornTheme{
  @override
  Color appbarColor=Colors.white;

  @override
  Color backgroundColor=const Color(0xffeeeeff);

  @override
  Brightness brightness=Brightness.light;

  @override
  Color primaryColor=Colors.white;

  @override
  Color secondaryColor=Colors.white;

  @override
  Color textColor1=Colors.black;

  @override
  String themeName='adorn_light_theme';

  @override
  TextStyle defaultTextStyle=GoogleFonts.lato();
  
}''';

String defaultDarkStab(String themeName, String brightness) =>
    '''import 'package:adorn/base/model/adorn_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adorn/base/resource/theme.dart';

class ${ReCase(themeName).pascalCase} extends AdornTheme{
  @override
  Color appbarColor=tintColor(Colors.black,0.1);

  @override
  Color backgroundColor=tintColor(Colors.black,0.2);

  @override
  Brightness brightness=Brightness.dark;

  @override
  Color primaryColor=Colors.white;

  @override
  Color secondaryColor=Colors.white;

  @override
  Color textColor1=Colors.white;

  @override
  String themeName='adorn_dark_theme';

  @override
  TextStyle defaultTextStyle=GoogleFonts.notoSans();
  
}''';
