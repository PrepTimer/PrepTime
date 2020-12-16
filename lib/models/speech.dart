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

  /// Constructs a new Speech object.
  Speech({
    this.name = 'speech',
    this.length = const Duration(minutes: 8),
    this.shouldCountUp = false,
    this.useJudgeAssistant = false,
  });

  /// Initializes the controller.
  ///
  /// Binds the TickerProvider to the AnimationController and if the speech
  /// uses JudgeAssistant, the controller will also add the onStatusChange
  /// callback to the controller.
  ///
  /// - [ticker] a reference to the current context's TickerProvider.
  /// - [onSpeechEnd] a callback for when the speech is completed.
  /// - [onValueChanged] a callback for when the speech value changes.
  AnimationController initController(
    TickerProvider ticker, {
    void Function() onSpeechEnd,
    void Function() onValueChanged,
  }) {
    void _statusListener(AnimationStatus animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _status = SpeechStatus.completed;
          onSpeechEnd();
          break;
        case AnimationStatus.dismissed:
          _status = SpeechStatus.stoppedAtBeginning;
          break;
        default:
          _status = SpeechStatus.runningForward;
          break;
      }
    }

    void _valueListener() {
      onValueChanged();
      notifyListeners();
    }

    _controller ??= AnimationController(duration: length, vsync: ticker)
      ..value = shouldCountUp ? 0.0 : 1.0
      ..addListener(_valueListener)
      ..addStatusListener(_statusListener);
    return _controller;
  }

  /// A reference to the animation controller object.
  AnimationController get controller => _controller;
  AnimationController _controller; // intentionally not set in constructor

  /// Tracks the state of this speech object.
  SpeechStatus get status => _status;
  SpeechStatus _status = SpeechStatus.stoppedAtBeginning;

  /// Whether the [Speech] is running.
  ///
  /// Throws [StateError] if the speechController is null.
  bool get isRunning {
    _checkControllerNotNull();
    return _controller.isAnimating;
  }

  /// Whether the [Speech] is not running.
  ///
  /// Throws [StateError] if the speechController is null.
  bool get isNotRunning => !isRunning;

  /// The duration of time remaining in the speech.
  ///
  /// Throws [StateError] if the speechController is null.
  Duration get timeRemaining {
    _checkControllerNotNull();
    return _controller.duration * _controller.value;
  }

  /// Starts the speech animation from the beginning.
  ///
  /// If the speech [shouldCountUp], then the controller will starts the
  /// animation from 0.0 and count up toward 1.0. Otherwise, the controller
  /// will tick in reverse starting at 1.0 and decreasing toward 0.0.
  ///
  /// Throws [StateError] if the speechController is null.
  void start() {
    _checkControllerNotNull();
    if (shouldCountUp) {
      _controller.forward(from: 0.0);
    } else {
      _controller.reverse(from: 1.0);
    }
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
    _checkControllerNotNull();
    shouldCountUp ? _controller.forward() : _controller.reverse();
  }

  /// Stops the speech animation.
  ///
  /// Throws [StateError] if the speechController is null.
  void stop() {
    _checkControllerNotNull();
    _status = SpeechStatus.pausedInMiddle;
    _controller.stop();
  }

  /// Resets the speech animation.
  ///
  /// Throws [StateError] if the speechController is null.
  void reset() {
    _checkControllerNotNull();
    _controller.value = shouldCountUp ? 0.0 : 1.0;
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
  /// Throws [StateError] if the speechController is null.
  void _checkControllerNotNull() {
    if (_controller == null) {
      throw StateError('Must call initController() before using it.');
    }
  }
}
