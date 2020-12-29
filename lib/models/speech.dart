// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/material.dart';
import 'package:preptime/models/simple_timer.dart';
import 'package:preptime/models/speech_status.dart';
import 'package:preptime/models/timeable.dart';
import 'package:preptime/utilities/modals/modals.dart';

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
/// You can access a stream of the time remaining with the [currentTime] getter.
///
/// Before using the [Speech] you must call [initController] and initialize it
/// with a [TickerProvider]. After that, you can call [toString] to get the
/// duration that should be shown on the clock. Finally, to properly dispose of
/// the resources used here, you should call [dispose] to free up the space
/// used by the [controller].
class Speech extends ChangeNotifier implements Timeable {
  /// The context of the speech (used internally for modals).
  BuildContext _context;

  /// The simple timer used to track the time on the speech clock.
  final SimpleTimer _timer;

  /// Whether the speech should count up or down.
  final bool shouldCountUp;

  /// Whether the speech should useJudgeAssistant or not.
  final bool useJudgeAssistant;

  /// Whether to show time signals or not.
  final bool showTimeSignals;

  /// The initial length of the speech.
  final Duration length;

  /// The name of the speech.
  final String name;

  /// Constructs a new [Speech] object.
  Speech({
    this.name = 'speech',
    this.length = const Duration(minutes: 8),
    this.shouldCountUp = false,
    this.useJudgeAssistant = true,
    this.showTimeSignals = false,
  }) : _timer = SimpleTimer(
          length,
          timeBetweenTicks: Duration(milliseconds: 100),
          shouldCountUp: shouldCountUp,
        ) {
    _timer.onEnd = () => status = SpeechStatus.completed;
    if (showTimeSignals) {
      _attachListenerForTimeSignals();
    }
  }

  /// The stream of time remaining durations.
  Stream<Duration> get currentTime {
    _ensureControllerIsNotNull();
    return _timer.currentTime;
  }

  /// An animation controller for the spinning ring animation.
  AnimationController get controller => _controller;
  AnimationController _controller;

  /// The current status of the speech.
  SpeechStatus status = SpeechStatus.stoppedAtBeginning;

  /// Whether the speech clock is running.
  bool get isRunning {
    _ensureControllerIsNotNull();
    return _timer.isRunning;
  }

  /// Whether the speech clock is not running.
  bool get isNotRunning {
    _ensureControllerIsNotNull();
    return _timer.isNotRunning;
  }

  /// Initializes the controller.
  ///
  /// Binds the TickerProvider to the AnimationController and adds the
  /// [onStatusChange] callback to the controller. This method is `idempotent`,
  /// meaning that calling it once is the same as calling in many times.
  ///
  /// - [ticker] a reference to the current context's TickerProvider.
  /// - [context] the build context of this speech.
  /// - [onStatusChanged] a callback for when the speech status changes.
  AnimationController initController(
    TickerProvider ticker,
    BuildContext context, {
    void Function(AnimationStatus) onStatusChanged,
  }) {
    _context ??= context;
    _controller ??= AnimationController(duration: length, vsync: ticker)
      ..value = shouldCountUp ? 0.0 : 1.0
      ..addStatusListener((status) => onStatusChanged?.call(status));
    return _controller;
  }

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
    _timer.reset();
    _timer.resume();
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
    _timer.resume();
    status = SpeechStatus.runningForward;
  }

  /// Stops the speech animation.
  ///
  /// Throws [StateError] if the speechController is null.
  void stop() {
    _ensureControllerIsNotNull();
    _controller.stop();
    _timer.stop();
    status = SpeechStatus.pausedInMiddle;
  }

  /// Resets the speech animation.
  ///
  /// If the speech [shouldCountUp] then this method resets the value to 0.0,
  /// and it resets to 1.0 otherwise. If the speech is currently running, it is
  /// stopped.
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
    _timer.reset();
    status = SpeechStatus.stoppedAtBeginning;
  }

  /// Returns whether or not the animation is complete.
  ///
  /// The given [AnimationStatus] is termed `completed` if either:
  ///
  /// - The [AnimationStatus] is completed and [shouldCountUp] is true
  /// - The [AnimationStatus] is dismissed and [shouldCountUp] is false
  bool isAnimationCompleted(AnimationStatus status) {
    return (shouldCountUp && status == AnimationStatus.completed) ||
        (!shouldCountUp && status == AnimationStatus.dismissed);
  }

  /// Disposes the resources used by the [Speech] object.
  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _timer.dispose();
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

  /// Listens to each update from the Duration stream and shows time signals
  /// at the right time.
  void _attachListenerForTimeSignals() {
    _timer.currentTime.listen(_shouldShowTimeSignals);
  }

  /// Takes a duration and decides which time signal to show if any.
  void _shouldShowTimeSignals(Duration timeRemaining) {
    // We cannot use the client-facing isRunning method here because we want to
    // force the user to initialize the speech controller before using it but
    // we need access on construction.
    if (_timer.isRunning) {
      ShowTimeSignal.fromDuration(timeRemaining, _context);
    }
  }
}
