import 'package:flutter/material.dart';

/// Defines the state and behavior of a timer button.
///
/// The button is a circle with a double ring around its edge. When the button
/// is pressed, the background color gets darker.
class TimerButton extends StatefulWidget {
  final Function onPressed;
  final String buttonText;
  final Color textColor;

  TimerButton({
    this.buttonText,
    this.textColor,
    this.onPressed,
  });

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  static const BorderStyle borderStyle = BorderStyle.solid;
  static const Size buttonSize = Size(100, 90);
  static const double strokeWidth = 2.5;
  static const double fontSize = 16;

  Color buttonColor;

  @override
  void initState() {
    super.initState();
    buttonColor = widget.textColor.withAlpha(60);
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
            color: widget.textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        color: buttonColor,
        onHighlightChanged: (value) => _toggleButtonColor(value),
        onPressed: widget.onPressed,
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
        buttonColor = buttonColor.withAlpha(30);
      } else {
        buttonColor = buttonColor.withAlpha(60);
      }
    });
  }
}
