// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'dart:ui';

import 'package:flutter/material.dart';

/// Tracks the behavior of a [TimerButton] during a specific [SpeechStatus].
///
/// For each status, the button will have a specific behavior (defined here).
/// Each behavior has a [callback] that is called when the button is pressed,
/// a [color], and a [text] label.
class ButtonProperties {
  /// The function called when the button is pressed during a [speech_status].
  final void Function() callback;

  /// The color of the botton during a certain [speech_status].
  final Color color;

  /// The text label of the button during a certain [speech_status].
  final String text;

  /// Constructs the properties of a [gray button].
  ///
  /// By default, this will return an object with [callback] set to `null`, the
  /// [color] property set to the buttonColor fo the current theme and the
  /// [text] property set to `Cancel`.
  ButtonProperties.grayButton(
    BuildContext context, [
    this.callback,
    this.text = 'Cancel',
  ]) : this.color = Theme.of(context).buttonColor;

  /// Constructs the properties of a [green button].
  ///
  /// By default, this will return an object with [callback] set to `null`, the
  /// [color] property set to the primary color of the current theme and the
  /// [text] property set to `Start`.
  ButtonProperties.greenButton(
    BuildContext context, [
    this.callback,
    this.text = 'Start',
  ]) : color = Theme.of(context).primaryColor;

  /// Constructs the properties of an [orange button].
  ///
  /// By default, this will return an object with [callback] set to `null`, the
  /// [color] property set to the accent color of the current theme and the
  /// [text] property set to `Pause`.
  ButtonProperties.orangeButton(
    BuildContext context, [
    this.callback,
    this.text = 'Pause',
  ]) : color = Theme.of(context).accentColor;
}
