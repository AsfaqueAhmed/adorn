import 'package:adorn/base/model/adorn_theme.dart';
import 'package:adorn/base/resource/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdornDarkTheme extends AdornTheme{
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

}