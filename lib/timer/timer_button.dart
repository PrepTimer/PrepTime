import 'package:flutter/material.dart';
import 'package:preptime/models/speech.dart';
import 'package:provider/provider.dart';

/// Defines the state and behavior of a timer button.
///
/// The button is a circle with a double ring around its edge. When the button
/// is pressed, the background color gets darker.
class TimerButton extends StatefulWidget {
  /// Tracks the function of the button across each animation state.
  final Map<AnimationStatus, > callbacks;

  /// The function the button performs when the timer is paused.
  final void Function() whenPaused;

  /// The function the button performs when the timer is running.
  final void Function() whenRunning;

  /// The text displayed when the timer is paused.
  final String pausedText;

  /// The text displayed when the timer is running.
  final String runningText;

  /// The color of the button when the button is paused.
  final Color pausedColor;

  /// The color of the button when the button is running.
  final Color runningColor;

  /// Constructs a new TimerButton.
  TimerButton({
    @required this.pausedText,
    @required this.runningText,
    @required this.runningColor,
    @required this.pausedColor,
    @required this.whenRunning,
    @required this.whenPaused,
  });

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  static const BorderStyle _borderStyle = BorderStyle.solid;
  static const FontWeight _fontWeight = FontWeight.w400;
  static const Color _transparent = Colors.transparent;
  static const Size _buttonSize = Size(100, 90);
  static const double _strokeWidth = 2.5;
  static const double _fontSize = 16;

  /// The opacity of the background.
  int alpha = 60;

  @override
  Widget build(BuildContext context) {
    /// Whether the speech timer is running or not.
    bool isRunning = context.watch<Speech>().isRunning;
    return Container(
      width: _buttonSize.width,
      height: _buttonSize.height,
      decoration: ShapeDecoration(
        shape: _circularRingWithColor(_buttonColor(isRunning)),
      ),
      child: MaterialButton(
        splashColor: _transparent,
        highlightColor: _transparent,
        color: _buttonColor(isRunning),
        onPressed: _handlePress(isRunning),
        disabledColor: _buttonColor(isRunning),
        shape: _circularRingWithColor(Colors.black), // background color
        onHighlightChanged: (tap) => this.setState(() => alpha = tap ? 30 : 60),
        child: Text(
          _buttonText(isRunning),
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: _fontWeight,
            color: _buttonTextColor(isRunning),
          ),
        ),
      ),
    );
  }

  /// The color of the button.
  Color _buttonColor(bool isRunning) {
    if (_handlePress(isRunning) == null) {
      if (isRunning) return widget.runningColor.withAlpha(alpha ~/ 2);
      return widget.pausedColor.withAlpha(alpha ~/ 2);
    } else {
      if (isRunning) return widget.runningColor.withAlpha(alpha);
      return widget.pausedColor.withAlpha(alpha);
    }
  }

  /// The button text to display.
  String _buttonText(bool isRunning) {
    if (isRunning) return widget.runningText;
    return widget.pausedText;
  }

  /// Handles the onPressed callback.
  void Function() _handlePress(bool isRunning) {
    if (isRunning) return widget.whenRunning;
    return widget.whenPaused;
  }

  /// The color of the button text.
  Color _buttonTextColor(bool isRunning) {
    if (_handlePress(isRunning) == null) {
      if (isRunning) return widget.runningColor.withAlpha(alpha ~/ 2);
      return widget.pausedColor.withAlpha(alpha ~/ 2);
    } else {
      if (isRunning) return widget.runningColor;
      return widget.pausedColor;
    }
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
