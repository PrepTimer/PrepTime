import 'package:flutter/material.dart';
import 'package:preptime/models/speech.dart';
import 'package:provider/provider.dart';

/// Defines the state and behavior of a timer button.
///
/// The button is a circle with a double ring around its edge. When the button
/// is pressed, the background color gets darker.
class TimerButton extends StatefulWidget {
  /// The function the button performs when the timer is paused.
  final void Function() whenPaused;

  /// The function the button performs when the timer is running.
  final void Function() whenRunning;

  /// The text displayed when the timer is paused.
  final String primaryText;

  /// The text displayed when the timer is running.
  final String secondaryText;

  /// The base color of the button.
  final Color primaryColor;

  /// The alternate color of the button.
  final Color secondaryColor;

  /// Constructs a new TimerButton.
  TimerButton({
    @required this.primaryText,
    this.secondaryText,
    @required this.primaryColor,
    this.secondaryColor,
    @required this.whenRunning,
    this.whenPaused,
  });

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  static const BorderStyle borderStyle = BorderStyle.solid;
  static const FontWeight fontWeight = FontWeight.w400;
  static const Color transparent = Colors.transparent;
  static const Size buttonSize = Size(100, 90);
  static const double strokeWidth = 2.5;
  static const double fontSize = 16;

  /// The opacity of the background.
  int alpha = 60;

  @override
  Widget build(BuildContext context) {
    /// Whether the speech timer is running or not.
    bool isRunning = context.watch<Speech>().isRunning;

    /// Handles the onPress callback for the button.
    void Function() handlePress =
        isRunning ? widget.whenRunning : widget.whenPaused;

    /// The color of the button background, not considering button disability.
    Color buttonColor = isRunning
        ? widget.secondaryColor.withAlpha(alpha)
        : widget.primaryColor.withAlpha(alpha);

    return Container(
      width: buttonSize.width,
      height: buttonSize.height,
      decoration: ShapeDecoration(shape: _circularRingWithColor(buttonColor)),
      child: MaterialButton(
        splashColor: transparent,
        highlightColor: transparent,
        shape: _circularRingWithColor(Colors.black), // background color
        child: Text(
          isRunning
              ? widget.secondaryText ?? widget.primaryText
              : widget.primaryText,
          style: TextStyle(
            color: isRunning ? widget.secondaryColor : widget.primaryColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
        color: buttonColor,
        disabledColor: buttonColor,
        onHighlightChanged: (tap) => this.setState(() => alpha = tap ? 30 : 60),
        onPressed: handlePress,
      ),
    );
  }

  /// Returns a circular ring with the given color.
  ShapeBorder _circularRingWithColor(Color color) {
    return CircleBorder(
      side: BorderSide(
        width: strokeWidth,
        color: color,
        style: borderStyle,
      ),
    );
  }
}
