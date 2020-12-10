import 'dart:ui';

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

  /// Constructs a button properties object.
  const ButtonProperties({
    this.callback,
    this.color,
    this.text,
  });

  /// Constructs a cancel button.
  ///
  /// By default, this will return an object with [callback] set to `null`, the
  /// [color] property set to `Color(0xFF8E8E93)` and the [text] property set to
  /// `Cancel`.
  const ButtonProperties.cancelButton([this.callback])
      : this.color = const Color(0xFF8E8E93),
        this.text = 'Cancel';

  /// Constructs a start button.
  ///
  /// By default, this will return an object with [callback] set to `null`, the
  /// [color] property set to `Color(0xFF32D74B)` and the [text] property set
  /// to `Start`.
  const ButtonProperties.startButton({
    this.callback,
    this.color = const Color(0xFF32D74B),
    this.text = 'Start',
  });

  /// Constructs a new pause button.
  ///
  /// By default, this will return an object with [callback] set to `null`, the
  /// [color] property set to `Color(0xFFFF9F0A)` and the [text] property set
  /// to `Pause`.
  const ButtonProperties.pauseButton({
    this.callback,
    this.color = const Color(0xFFFF9F0A),
    this.text = 'Pause',
  });
}
