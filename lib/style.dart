import 'dart:ui';

import 'package:flutter/material.dart';

// TODO: #11 Fill in PrepTimeThemeData.
abstract class PrepTimeThemeData {
  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      splashFactory: InkRipple.splashFactory,
      backgroundColor: Colors.black,
      primaryColor: Color(0xFF32D74B),
      accentColor: Color(0xFFFF9F0A),
      textTheme: TextTheme(
        /// The large clock in the center of the screen.
        headline1: const TextStyle(
          fontFeatures: [FontFeature.tabularFigures()],
          fontWeight: FontWeight.w200,
          letterSpacing: -4.0,
          color: Colors.white,
          fontSize: 90.0,
        ),
      ));
}
