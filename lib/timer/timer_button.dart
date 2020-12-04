import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_status.dart';
import 'package:provider/provider.dart';

/// Defines the state and behavior of a timer button.
///
/// The button is a circle with a double ring around its edge. When the button
/// is pressed, the background color gets darker.
class TimerButton extends StatefulWidget {
  /// Tracks the function of the button across each animation state.
  final Map<SpeechStatus, void Function()> callback;

  /// The text of the button for each animation state.
  final Map<SpeechStatus, String> text;

  /// The color of the button for each animation state.
  final Map<SpeechStatus, Color> color;

  /// Constructs a new TimerButton.
  TimerButton({
    @required this.callback,
    @required this.color,
    @required this.text,
  });

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  static const BorderStyle _borderStyle = BorderStyle.solid;
  static const FontWeight _fontWeight = FontWeight.w300;
  static const Color _transparent = Colors.transparent;
  static const Size _buttonSize = Size(100, 90);
  static const double _strokeWidth = 2.5;
  static const double _fontSize = 17;
  static const int initialAlpha = 40;

  /// The opacity of the background.
  int alpha = initialAlpha;

  @override
  Widget build(BuildContext context) {
    /// Whether the speech timer is running or not.
    SpeechStatus status = context.watch<Speech>().status;
    return Container(
      width: _buttonSize.width,
      height: _buttonSize.height,
      decoration: ShapeDecoration(
        shape: _circularRingWithColor(_buttonColor(status)),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        splashColor: _transparent,
        highlightColor: _transparent,
        color: _buttonColor(status),
        onPressed: _handlePress(status),
        disabledColor: _buttonColor(status),
        shape: _circularRingWithColor(Colors.black), // background color
        onHighlightChanged: (bool isPressed) => this.setState(() {
          alpha = isPressed ? initialAlpha ~/ 2 : initialAlpha;
        }),
        child: Text(
          _buttonText(status),
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: _fontWeight,
            color: _buttonTextColor(status),
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }

  /// The color of the button.
  Color _buttonColor(SpeechStatus status) {
    int newAlpha = _handlePress(status) == null ? alpha ~/ 2 : alpha;
    return widget.color[status].withAlpha(newAlpha);
  }

  /// The button text to display.
  String _buttonText(SpeechStatus status) {
    return widget.text[status];
  }

  /// Handles the onPressed callback.
  void Function() _handlePress(SpeechStatus status) {
    return widget.callback[status];
  }

  /// The color of the button text.
  Color _buttonTextColor(SpeechStatus status) {
    if (_handlePress(status) == null) {
      return widget.color[status].withAlpha(alpha);
    }
    return widget.color[status];
  }

  /// Returns a circular ring with the given color.
  ShapeBorder _circularRingWithColor(Color color) {
    return CircleBorder(
      side: BorderSide(
        width: _strokeWidth,
        style: _borderStyle,
        color: color,
      ),
    );
  }
}
