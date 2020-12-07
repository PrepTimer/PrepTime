import 'package:flutter/material.dart';

abstract class PrepTimeThemeData {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    splashFactory: InkRipple.splashFactory,
  );
}
