import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_status.dart';
import 'package:preptime/screens/timer/src/timer_buttons/src/button_properties.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

/// Defines the state and behavior of a timer button.
///
/// The button is a circle with a double ring around its edge. When the button
/// is pressed, the background color gets darker.
class TimerButton extends StatefulWidget {
  /// Tracks the behavior of the button across each animation state.
  final Map<SpeechStatus, ButtonProperties> behavior;

  /// Constructs a [cancel button].
  ///
  /// The button takes the given [BuildContext] to lookup the current theme and
  /// the callback [onTap] function which is called when the cancel button is
  /// tapped and active.
  TimerButton.cancel(
    BuildContext context,
    bool isDisabled,
    void Function() onPressed, {
    Key key,
  })  : behavior = {
          SpeechStatus.values[0]: ButtonProperties.grayButton(context),
          SpeechStatus.values[1]: ButtonProperties.grayButton(
              context, () => isDisabled ? null : onPressed),
          SpeechStatus.values[2]: ButtonProperties.grayButton(
              context, () => isDisabled ? null : onPressed),
          SpeechStatus.values[3]: ButtonProperties.grayButton(context),
        },
        super(key: key);

  /// Constructs an [action button].
  ///
  /// The button takes the given [BuildContext] to lookup the current theme and
  /// the boolean [isDisabled] along with the current [Speech] to determine the
  /// correct action that should be taken for the button on the right side of
  /// the screen.
  ///
  /// Typically, this button is a green 'Start' button, that can turn in to an
  /// orange 'Pause' button. When the timer is stopped, the button again turns
  /// green and the original text is replaced with 'Resume'. When the timer ends
  /// the text is once again replaced with the phrase 'Restart'.
  TimerButton.action(
    BuildContext context,
    bool isDisabled,
    Speech speech, {
    Key key,
  })  : behavior = {
          SpeechStatus.values[0]: ButtonProperties.greenButton(
              context, isDisabled ? null : speech.start),
          SpeechStatus.values[1]: ButtonProperties.orangeButton(
              context, isDisabled ? null : speech.stop),
          SpeechStatus.values[2]: ButtonProperties.greenButton(
              context, isDisabled ? null : speech.resume, 'Resume'),
          SpeechStatus.values[3]: ButtonProperties.greenButton(
              context, isDisabled ? null : speech.start, 'Restart'),
        },
        super(key: key);

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  static const BorderStyle _borderStyle = BorderStyle.solid;
  static const FontWeight _fontWeight = FontWeight.w300;
  static const Size _buttonSize = Size(100, 90);
  static const double _strokeWidth = 2.5;
  static const int _initialAlpha = 80;
  static const double _fontSize = 17;

  /// The opacity of the background.
  int alpha = _initialAlpha;

  @override
  Widget build(BuildContext context) {
    SpeechStatus status = context.watch<Event>().speech.status;
    bool _isEnabled = widget.behavior[status].callback != null;
    return Container(
      width: _buttonSize.width,
      height: _buttonSize.height,
      decoration: ShapeDecoration(
        shape: _circularRingWithColor(_buttonColor(status)),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        splashColor: Theme.of(context).splashColor,
        highlightColor: Theme.of(context).highlightColor,
        color: _buttonColor(status),
        onPressed: _handlePress(status),
        disabledColor: _buttonColor(status),
        shape: _circularRingWithColor(Colors.black),
        onHighlightChanged: (bool isPressed) => this.setState(() {
          alpha = (isPressed ? _initialAlpha ~/ 2 : _initialAlpha);
        }),
        child: Shimmer.fromColors(
          enabled: _isEnabled,
          period: const Duration(seconds: 2),
          baseColor: widget.behavior[status].color,
          highlightColor: widget.behavior[status].color.withOpacity(0.7),
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
      ),
    );
  }

  /// The color of the button.
  Color _buttonColor(SpeechStatus status) {
    int newAlpha = _handlePress(status) == null ? alpha ~/ 2 : alpha;
    return widget.behavior[status].color.withAlpha(newAlpha);
  }

  /// The button text to display.
  String _buttonText(SpeechStatus status) {
    return widget.behavior[status].text;
  }

  /// Handles the onPressed callback.
  void Function() _handlePress(SpeechStatus status) {
    return widget.behavior[status].callback;
  }

  /// The color of the button text.
  Color _buttonTextColor(SpeechStatus status) {
    if (_handlePress(status) == null) {
      return widget.behavior[status].color.withAlpha(alpha);
    }
    return widget.behavior[status].color;
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
