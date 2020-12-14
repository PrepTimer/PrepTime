import 'package:flutter/material.dart';
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
  /// The name of the speech.
  final String name;

  /// The duration of the speech.
  final Duration length;

  /// Whether the timer should count up or down.
  final bool shouldCountUp;

  /// Whether the speech should use JudgeAssistant mode.
  final bool useJudgeAssistant;

  /// A reference to the animation controller object.
  AnimationController get controller => _controller;
  AnimationController _controller;

  /// Tracks the state of this speech object.
  SpeechStatus status = SpeechStatus.stoppedAtBeginning;

  /// Constructs a new Speech object
  Speech({
    this.name = 'speech',
    this.length = const Duration(minutes: 8),
    this.shouldCountUp = false,
    this.useJudgeAssistant = false,
  });

  /// Whether the [Speech] is running.
  bool get isRunning {
    _checkControllerNotNull();
    return _controller.isAnimating;
  }

  /// Whether the [Speech] is not running.
  bool get isNotRunning => !isRunning;

  Duration get timeRemaining {
    _checkControllerNotNull();
    return _controller.duration * _controller.value;
  }

  /// Starts the speech animation from the beginning.
  ///
  /// If the speech [shouldCountUp], then the controller will starts the
  /// animation from 0.0 and count up toward 1.0. Otherwise, the controller
  /// will tick in reverse starting at 1.0 and decreasing toward 0.0.
  void start() {
    _checkControllerNotNull();
    status = SpeechStatus.runningForward;
    if (shouldCountUp) {
      _controller.forward(from: 0.0);
    } else {
      _controller.reverse(from: 1.0);
    }
    // notifyListeners();
  }

  /// Resumes the speech animation.
  ///
  /// If the speech [shouldCountUp], then the controller will starts the
  /// animation from the current value and count up toward 1.0. Otherwise, the
  /// controller will tick in reverse starting at the current value and
  /// decreasing toward 0.0.
  void resume() {
    _checkControllerNotNull();
    shouldCountUp ? _controller.forward() : _controller.reverse();
    status = SpeechStatus.runningForward;
    notifyListeners();
  }

  /// Stops the speech animation.
  void stop() {
    _checkControllerNotNull();
    _controller.stop();
    status = SpeechStatus.pausedInMiddle;
    notifyListeners();
  }

  /// Resets the speech animation.
  void reset() {
    _checkControllerNotNull();
    shouldCountUp ? _controller.reset() : _controller.value = 1.0;
    status = SpeechStatus.stoppedAtBeginning;
    notifyListeners();
  }

  /// Initializes the controller.
  ///
  /// Binds the TickerProvider to the AnimationController and if the speech
  /// uses JudgeAssistant, the controller will also add the onStatusChange
  /// callback to the controller.
  ///
  /// - [ticker] a reference to the current context's TickerProvider.
  /// - [onStatusChange] an optional function called when the status changes.
  AnimationController initController(
    TickerProvider ticker, {
    void Function(AnimationStatus) onStatusChange,
  }) {
    _controller ??= AnimationController(duration: length, vsync: ticker)
      ..value = shouldCountUp ? 0.0 : 1.0
      ..addListener(() => notifyListeners())
      ..addStatusListener((controllerStatus) {
        if (controllerStatus == AnimationStatus.dismissed ||
            controllerStatus == AnimationStatus.completed) {
          status = SpeechStatus.completed;
        }
      });
    // TODO: #6 Implement time signals and auto-move speeches.
    // if (useJudgeAssistant) {
    // controller.addListener(() => handleValueChange); // for time signals
    // controller.addStatusListener((status) => onStatusChange); // auto-move
    // }
    return _controller;
  }

  /// Disposes the resources used by the [Speech] object.
  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  /// Checks that the controller is not null.
  ///
  /// If the controller is null, throws [StateError].
  void _checkControllerNotNull() {
    if (controller == null) {
      throw StateError('Must call initController() before using it.');
    }
  }
}
