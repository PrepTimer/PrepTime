import 'package:flutter/material.dart';

// TODO: #11 Fill in PrepTimeThemeData.
abstract class PrepTimeThemeData {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    splashFactory: InkRipple.splashFactory,
  );
}
