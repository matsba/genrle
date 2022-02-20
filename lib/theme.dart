import 'package:flutter/material.dart';

Color backgroundColor = Colors.blueGrey.shade900;
const primaryColor = Colors.deepPurple;
const textPrimaryColor = Colors.black;
const accentColor = Colors.amberAccent;

class GlobalTheme {
  final globalTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      primaryColorLight: accentColor,
      appBarTheme: AppBarTheme(elevation: 0, backgroundColor: backgroundColor),

      //Button
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: accentColor,
              primary: textPrimaryColor,
              visualDensity: VisualDensity.compact,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide()))));
}
