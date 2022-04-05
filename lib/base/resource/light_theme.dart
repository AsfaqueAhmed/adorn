import 'package:adorn/base/model/adorn_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdornLightTheme extends AdornTheme{
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

}