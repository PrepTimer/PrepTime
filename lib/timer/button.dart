import 'package:flutter/material.dart';
import 'package:preptime/models/event_manager.dart';
import 'package:preptime/models/speech.dart';
import 'package:provider/provider.dart';

/// Defines the state and behavior of a timer button.
///
/// The button is a circle with a double ring around its edge. When the button
/// is pressed, the background color gets darker.
class TimerButton extends StatefulWidget {
  /// The function the button performs when the timer is running.
  final void Function() whenRunning;

  /// The function the button performs when the timer is paused.
  final void Function() whenPaused;

  /// The text in the center of the button.
  final String buttonText;

  /// The base color of the button.
  final Color color;

  /// The alternate color of the button.
  ///
  /// By default, this is equal to [color]. The button assumes the alternate
  /// color when the timer is running and returns to its base color when the
  /// timer is paused.
  final Color altColor;

  /// Constructs a new TimerButton.
  TimerButton({
    @required this.buttonText,
    @required this.color,
    this.altColor,
    @required this.whenPaused,
    @required this.whenRunning,
  });

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  static const BorderStyle borderStyle = BorderStyle.solid;
  static const Size buttonSize = Size(100, 90);
  static const double strokeWidth = 2.5;
  static const double fontSize = 16;

  Speech speech;
  Color buttonColor;

  @override
  void initState() {
    super.initState();
    buttonColor = widget.color.withAlpha(60);
  }

  @override
  void didChangeDependencies() {
    speech = Provider.of<EventManager>(context).event.speech;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize.width,
      height: buttonSize.height,
      decoration: ShapeDecoration(
        shape: _circularRingWithColor(buttonColor),
      ),
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        shape: _circularRingWithColor(Colors.black), // background color
        child: Text(
          widget.buttonText,
          style: TextStyle(
            color: speech.isNotRunning ? widget.color : widget.altColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        color: buttonColor,
        onHighlightChanged: (isPressed) => _toggleButtonColor,
        onPressed: () {
          speech.isRunning ? widget.whenRunning() : widget.whenPaused();
        },
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

  /// Toggles the color of the button.
  void _toggleButtonColor(bool buttonIsPressed) {
    this.setState(() {
      if (buttonIsPressed) {
        buttonColor = buttonColor.withAlpha(30); // darken
      } else {
        buttonColor = buttonColor.withAlpha(60); // lighten
      }
    });
  }
}
