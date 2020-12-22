import 'package:flutter/material.dart';
import 'package:preptime/models/countdown_timer.dart';
import 'package:preptime/models/speech_status.dart';
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
/// with a [TickerProvider]. After that, you can call [toString] to get the
/// duration that should be shown on the clock. Finally, to properly dispose of
/// the resources used here, you should call [dispose] to free up the space
/// used by the [controller].
class Speech extends ChangeNotifier implements Timeable {
  final bool shouldCountUp, useJudgeAssistant;
  final CountDownTimer timer;
  final Duration length;
  final String name;

  /// Constructs a new Speech object.
  Speech({
    this.name = 'speech',
    this.length = const Duration(minutes: 8),
    this.shouldCountUp = false,
    this.useJudgeAssistant = true,
  }) : timer = CountDownTimer(
          length,
          timeBetweenTicks: Duration(milliseconds: 100),
          shouldCountUp: shouldCountUp,
        );

  /// Initializes the controller.
  ///
  /// Binds the TickerProvider to the AnimationController and if the speech
  /// uses JudgeAssistant, the controller will also add the onStatusChange
  /// callback to the controller.
  ///
  /// - [ticker] a reference to the current context's TickerProvider.
  /// - [onStatusChanged] a callback for when the speech status changes.
  AnimationController initController(
    TickerProvider ticker, {
    void Function(AnimationStatus) onStatusChanged,
  }) {
    _controller ??= AnimationController(duration: length, vsync: ticker)
      ..value = shouldCountUp ? 0.0 : 1.0
      ..addStatusListener(onStatusChanged);
    return _controller;
  }

  AnimationController get controller => _controller;
  AnimationController _controller;

  SpeechStatus status = SpeechStatus.stoppedAtBeginning;

  bool get isRunning => timer.isRunning;
  bool get isNotRunning => timer.isNotRunning;

  /// Starts the speech animation from the beginning.
  ///
  /// If the speech [shouldCountUp], then the controller will starts the
  /// animation from 0.0 and count up toward 1.0. Otherwise, the controller
  /// will tick in reverse starting at 1.0 and decreasing toward 0.0.
  ///
  /// Throws [StateError] if the speechController is null.
  void start() {
    _ensureControllerIsNotNull();
    if (shouldCountUp) {
      _controller.forward(from: 0.0);
    } else {
      _controller.reverse(from: 1.0);
    }
    timer.reset();
    timer.resume();
    status = SpeechStatus.runningForward;
  }

  /// Resumes the speech animation.
  ///
  /// If the speech [shouldCountUp], then the controller will starts the
  /// animation from the current value and count up toward 1.0. Otherwise, the
  /// controller will tick in reverse starting at the current value and
  /// decreasing toward 0.0.
  ///
  /// Throws [StateError] if the speechController is null.
  void resume() {
    _ensureControllerIsNotNull();
    if (shouldCountUp) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    timer.resume();
    status = SpeechStatus.runningForward;
  }

  /// Stops the speech animation.
  ///
  /// Throws [StateError] if the speechController is null.
  void stop() {
    _ensureControllerIsNotNull();
    _controller.stop();
    timer.stop();
    status = SpeechStatus.pausedInMiddle;
  }

  /// Resets the speech animation.
  ///
  /// Throws [StateError] if the speechController is null.
  void reset() {
    _ensureControllerIsNotNull();
    stop();
    _controller.animateTo(
      shouldCountUp ? 0.0 : 1.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    timer.reset();
    status = SpeechStatus.stoppedAtBeginning;
  }

  /// Disposes the resources used by the [Speech] object.
  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    timer.dispose();
    super.dispose();
  }

  /// Checks that the controller is not null.
  ///
  /// Throws [StateError] if the speechController is null.
  void _ensureControllerIsNotNull() {
    if (_controller == null) {
      throw StateError('Must call initController() before using it.');
    }
  }
}
