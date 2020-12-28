// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'dart:ui';

import 'package:flutter/material.dart';

abstract class PrepTimeThemeData {
  static final ThemeData darkTheme = ThemeData(
    /// The background color for the app, and associated brightness level.
    backgroundColor: Colors.black,
    brightness: Brightness.dark,

    /// The ripple effect to use for the [PrepTime] buttons.
    splashFactory: InkRipple.splashFactory,

    /// The green color of the [TimerButton].
    primaryColor: Color(0xFF32D74B),

    /// The orange color of the [TimerButton].
    accentColor: Color(0xFFFF9F0A),

    /// The gray color of the [TimerButton].
    buttonColor: Color(0xFF8E8E93),

    /// Background of [CustomRingPainter], inactive [SpeechIndicator], and the
    /// splashColor of the [PrepTimer].
    shadowColor: Colors.white10,

    /// Background color of an active [SpeechIndicator]
    focusColor: Colors.white38,

    /// The [TimerButton] splash and highlight colors (both are transparent)
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

    /// The main textTheme for the large clock in the center of the screen.
    textTheme: TextTheme(
      /// The [Enabled] text style for the [ClockLabel].
      headline1: const TextStyle(
        fontFeatures: [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w200,
        letterSpacing: -4.0,
        color: Colors.white,
        fontSize: 190.0,
      ),

      /// The [Disabled] text style for the [ClockLabel].
      headline2: const TextStyle(
        fontFeatures: [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w200,
        letterSpacing: -4.0,
        color: Colors.white24,
        fontSize: 190.0,
      ),

      /// The modal popup text style of the time signals.
      headline3: const TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.white38,
        fontSize: 24.0,
      ),

      /// The [Enabled] text style for a [SpeechLabel].
      subtitle1: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w300,
        color: Colors.white54,
      ),

      /// The [Disabled] text style for a [SpeechLabel].
      subtitle2: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w300,
        color: Colors.white24,
      ),

      /// The [Enabled] text style for a [TimeLabel].
      bodyText1: const TextStyle(
        color: Colors.white,
        fontFeatures: [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w100,
        fontSize: 100.0,
        height: 1.3,
      ),

      /// The [Disabled] text style for a [TimeLabel].
      bodyText2: const TextStyle(
        color: Colors.white24,
        fontFeatures: [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w100,
        fontSize: 100.0,
        height: 1.3,
      ),

      /// The [Enabled] text style for a [TeamLabel].
      overline: const TextStyle(
        color: Colors.white54,
        fontWeight: FontWeight.w200,
        fontSize: 30.0,
      ),

      /// The [Disabled] text style for a [TeamLabel].
      caption: const TextStyle(
        color: Colors.white24,
        fontWeight: FontWeight.w200,
        fontSize: 30.0,
      ),
    ),
  );
}
