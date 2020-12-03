import 'package:flutter/material.dart';
import 'package:preptime/models/timeable.dart';

/// A speech given in an [Event].
///
/// Each speech has a [name] and [controller] which is used to animate the large
/// timer on screen for the given speech. Additionally, the speech tracks if it
/// [shouldCountUp] (as opposed to down), and whether this speech should
/// [useJudgeAssistant].
///
/// The [Speech] object also implements the [Timeable] interface. Therefore, it
/// exposes the [resume], [pause], and [reset] methods as well as the
/// [isRunning] and [isNotRunning] getter methods.
///
/// Before using the [Speech] you must call [initController] and initialize it
/// with a [TickerProvider]. After that, you can call [getDuration] to get the
/// duration that should be shown on the clock. Finally, to properly dispose of
/// the resources used here, you should call [dispose] to free up the space
/// used by the [controller].
class Speech implements Timeable {
  /// The name of the speech.
  final String name;

  /// The duration of the speech.
  final Duration length;

  /// Whether the timer should count up or down.
  final bool shouldCountUp;

  /// Whether the speech should use JudgeAssistant mode.
  final bool useJudgeAssistant;

  /// A reference to the animation controller object.
  AnimationController controller;

  /// Constructs a new Speech object
  Speech({this.name, this.length, this.shouldCountUp, this.useJudgeAssistant});

  /// Whether the [Speech] is running.
  bool get isRunning => controller.isAnimating;

  /// Whether the [Speech] is not running.
  bool get isNotRunning => !controller.isAnimating;

  /// Starts the speech animation from the beginning.
  ///
  /// If the speech [shouldCountUp], then the controller will starts the
  /// animation from 0.0 and count up toward 1.0. Otherwise, the controlelr
  /// will tick in reverse starting at 1.0 and decreasing toward 0.0.
  void start() {
    _checkControllerNotNull();
    if (shouldCountUp) {
      controller.forward(from: 0.0);
    } else {
      controller.reverse(from: 1.0);
    }
  }

  /// Resumes the speech animation.
  ///
  /// If the speech [shouldCountUp], then the controller will starts the
  /// animation from the current value and count up toward 1.0. Otherwise, the
  /// controller will tick in reverse starting at the current value and
  /// decreasing toward 0.0.
  void resume() {
    _checkControllerNotNull();
    if (shouldCountUp) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  /// Stops the speech animation.
  void stop() {
    _checkControllerNotNull();
    controller.stop();
  }

  /// Resets the speech animation.
  void reset() {
    _checkControllerNotNull();
    controller.reset();
  }

  /// Initializes the controller.
  ///
  /// Binds the TickerProvider to the AnimationController and if the speech
  /// uses JudgeAssistant, the controller will also add the onStatusChange
  /// callback to the controller.
  ///
  /// - [ticker] a reference to the current context's TickerProvider.
  /// - [onValueChange] a callback that is attached to the valueChange listener.
  /// - [onStatusChange] an optional function called when the status changes.
  void initController(
    TickerProvider ticker, {
    @required Function() onValueChange,
    void Function(AnimationStatus) onStatusChange,
  }) {
    controller = AnimationController(
      duration: length,
      vsync: ticker,
    );
    controller.addListener(() => onValueChange);
    if (useJudgeAssistant) {
      // controller.addListener(() => handleValueChange); // for time signals
      controller.addStatusListener((status) => onStatusChange); // auto-move
    }
  }

  /// Disposes the resources used by the [Speech] object.
  void dispose() {
    controller.dispose();
  }

  /// Returns the speech animation's duration.
  ///
  /// Throws ArgumentError if the controller is null.
  Duration getDuration() {
    _checkControllerNotNull();
    // TODO: Verify logic speech controller duration logic.
    return controller.duration * controller.value;
  }

  /// Returns a string representation of this `Duration`.
  ///
  /// Returns a string with minutes, seconds, and milliseconds, in the
  /// following format: `M:SS.m`. For example,
  ///
  /// var d = Duration(minutes: 6, seconds: 32, milliseconds: 400);
  /// d.toString();  // "6:32.4"
  @override
  String toString() {
    String sixDigits(int n) {
      if (n >= 100000) return "$n";
      if (n >= 10000) return "0$n";
      if (n >= 1000) return "00$n";
      if (n >= 100) return "000$n";
      if (n >= 10) return "0000$n";
      return "00000$n";
    }

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes =
        twoDigits(inMinutes.remainder(minutesPerHour) as int);
    String twoDigitSeconds =
        twoDigits(inSeconds.remainder(secondsPerMinute) as int);
    String sixDigitUs =
        sixDigits(inMicroseconds.remainder(microsecondsPerSecond) as int);
    return "$inHours:$twoDigitMinutes:$twoDigitSeconds.$sixDigitUs";
  }

  /// Checks that the controller is not null.
  ///
  /// If the controller is null, throws [ArgumentError].
  void _checkControllerNotNull() {
    if (controller == null) {
      throw ArgumentError('Controller should not be null.');
    }
  }
}
