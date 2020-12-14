import 'dart:async';

import 'package:preptime/models/timeable.dart';

/// Manages a timer that counts down from an initial value.
///
/// The [CountDownTimer] implements the [Timeable] interface and therefore
/// exposes the following methods:
/// - isRunning
/// - isNotRunning
/// - start
/// - stop
/// - reset
///
/// Additionally, the [CountDownTimer] exposes a [currentTime] stream, which
/// periodically yeilds a new duration representing the time remaining. You can
/// access the [initialDuration] via the [initialDuration] getter method, and
/// you can dispose of the [CountDownTimer]'s resources with the [dispose]
/// method.
class CountDownTimer implements Timeable {
  /// The duration of a single second.
  static const Duration _second = Duration(seconds: 1);

  /// The timer that serves up periodic callbacks to add values to the sink.
  Timer _timer;

  /// The number of times the callback has been invoked.
  int _ticks = 0;

  /// Controlls the [currentTime] stream.
  StreamController<Duration> _controller;

  /// The current duration of time left on the clock.
  Stream<Duration> get currentTime => _controller.stream;

  /// The initial duration of the [CountDownTimer].
  ///
  /// This will also be the value that the timer will take when [reset] is
  /// called.
  final Duration initialDuration;

  /// Constructs a new [CountDownTimer].
  ///
  /// The initialDuration is the value of the timer at the beginning. This is
  /// the same value that the timer will reset to when [reset()] is called.
  CountDownTimer(this.initialDuration) {
    void handleListen() {
      _controller.add(initialDuration);
    }

    _controller = StreamController()
      ..onListen = handleListen
      ..onCancel = dispose
      ..onPause = stop
      ..onResume = resume;
  }

  /// Whether the [CountDownTimer] is running.
  bool get isRunning => _timer?.isActive ?? false;

  /// Whether the [CountDownTimer] is not running.
  bool get isNotRunning => !isRunning;

  /// Starts the [CountDownTimer].
  ///
  /// Starts a periodic timer that adds a new [Duration] value to the sink. The
  /// [CountDownTimer] must not already be started.
  ///
  /// TODO: #5 Fix countdown timer ticks.
  /// Ticks should represent elapsed durations, not callback invocations. The
  /// problem is that we construct a new timer on each valid [start] call,
  /// and therefore we lose the ticks of the cancelled timer.
  void resume() {
    if (isNotRunning) {
      _updateCurrentTime(null); // immediatley tick to let user know it worked.
      _timer = Timer.periodic(_second, _updateCurrentTime); // make const?
    }
  }

  /// Stops the [CountDownTimer].
  ///
  /// Cancels a periodic timer that would add new [Duration] values to the sink.
  /// The [CountDownTimer] must not already have been stopped.
  void stop() {
    if (isRunning) {
      _timer.cancel();
    }
  }

  /// Resets the [CountDownTimer] to the [initialDuration].
  void reset() {
    _timer?.cancel();
    _ticks = 0;
    _updateCurrentTime(null);
  }

  /// Closes out the resources being used by the controller.
  ///
  /// This method will cancel the timer and close out the [currentTime] stream.
  /// After calling this method, the stream will no longer be usable, as no
  /// more values can be added to the sink.
  void dispose() {
    stop();
    _controller.close();
  }

  /// Updates the [currentTime] by decrementing the duration.
  ///
  /// Calculates and adds a new duration value to the [currentTime] stream. If
  /// the timeRemaining is zero or negative, the stream is closed and the timer
  /// is stopped (via [dispose]).
  void _updateCurrentTime(Timer _) {
    Duration timeRemaining = initialDuration - _second * _ticks;
    _controller.add(timeRemaining);
    _ticks++;
    if (timeRemaining == Duration.zero || timeRemaining.isNegative) {
      dispose();
    }
  }
}
