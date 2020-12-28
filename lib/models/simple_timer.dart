// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'dart:async';

import 'package:preptime/models/timeable.dart';

/// Manages a timer that counts down from an initial value.
///
/// The [SimpleTimer] implements the [Timeable] interface and therefore
/// exposes the following methods:
///
/// - [isRunning]
/// - [isNotRunning]
/// - [start]
/// - [stop]
/// - [reset]
///
/// Additionally, the [SimpleTimer] exposes a [currentTime] stream, which
/// periodically yeilds a new duration representing the time remaining. You can
/// access the [initialDuration] via the [initialDuration] getter method, and
/// you can dispose of the [SimpleTimer]'s resources with the [dispose]
/// method.
class SimpleTimer implements Timeable {
  /// The timer used internally to schedule tick callbacks.
  Timer _timer;

  /// The number of ticks that have elapsed since starting the timer.
  int _ticks = 0;

  /// The callback function that occurs when the timer ends.
  void Function() onEnd;

  /// The duration of time that should elapse between ticks.
  final Duration timeBetweenTicks;

  /// The duration of time that the timer initially takes on.
  final Duration initialDuration;

  /// Whether the timer counts up or down.
  final bool shouldCountUp;

  /// Constructs a new [SimpleTimer].
  ///
  /// The [initialDuration] is the value of the timer at the beginning. This is
  /// the same value that the timer will reset to when [reset()] is called. You
  /// can use shouldCountUp to force the timer to increase toward the initial
  /// duration. The callback [onEnd] is called when the timer is finished. To
  /// change the amount of time that elapses between ticks, you can update the
  /// value of [timeBetweenTicks] (defaults to one second).
  SimpleTimer(
    this.initialDuration, {
    this.onEnd,
    this.shouldCountUp = false,
    this.timeBetweenTicks = const Duration(seconds: 1),
  }) : _controller = StreamController.broadcast() {
    _controller.onListen = () => _controller.add(initialDuration);
  }

  /// A broadcast stream that emits a new [Duration] every [timeBetweenTicks]
  /// that represents the current time on the timer.
  Stream<Duration> get currentTime => _controller.stream;
  StreamController<Duration> _controller;

  /// A synchronous getter method to determine the amount of time remaining.
  Duration get timeRemaining => _calculateTimeRemaining();

  /// Whether the [SimpleTimer] is running.
  bool get isRunning => _timer?.isActive ?? false;

  /// Whether the [SimpleTimer] is not running.
  bool get isNotRunning => !isRunning;

  /// Starts the [SimpleTimer].
  ///
  /// Starts a periodic timer that adds a new [Duration] value to the sink. The
  /// [SimpleTimer] must not already be started.
  ///
  /// TODO: #5 Fix countdown timer ticks.
  /// Ticks should represent elapsed durations, not callback invocations. The
  /// problem is that we construct a new timer on each valid [start] call,
  /// and therefore we lose the ticks of the cancelled timer.
  void resume() {
    if (isNotRunning && _calculateTimeRemaining() >= Duration.zero) {
      _updateCurrentTime(null); // immediatley tick to let user know it worked.
      _timer = Timer.periodic(timeBetweenTicks, _updateCurrentTime);
    }
  }

  /// Stops the [SimpleTimer].
  ///
  /// Cancels a periodic timer that would add new [Duration] values to the sink.
  /// The [SimpleTimer] should be running when this method is called.
  void stop() {
    if (isRunning) {
      _timer.cancel();
    }
  }

  /// Resets the [SimpleTimer].
  ///
  /// If this timer [shouldCountDown] then the value resets to the
  /// [initialDuration]. Otherwise, the value resets to zero. If the timer is
  /// running when this method is called, the timer is canceled.
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

  /// Updates the [currentTime].
  ///
  /// If the timer has no time remaining, the timer will be stopped and [onEnd]
  /// will be called. Otherwise, it will add a new duration to the [currentTime]
  /// stream and increment [_ticks].
  void _updateCurrentTime(Timer _) {
    Duration timeRemaining = _calculateTimeRemaining();
    if (timeRemaining < Duration.zero) {
      stop();
      onEnd?.call(); // only calls the callback if the function is not null
    } else {
      _controller.add(timeRemaining);
      _ticks++;
    }
  }

  /// Calculates the amount of time remaining.
  ///
  /// This is based on [_ticks], the [timeBetweenTicks], and whether the timer
  /// [shouldCountUp] or not.
  Duration _calculateTimeRemaining() {
    Duration timeElapsed = timeBetweenTicks * _ticks;
    if (shouldCountUp) {
      return timeElapsed;
    } else {
      return initialDuration - timeElapsed;
    }
  }
}
