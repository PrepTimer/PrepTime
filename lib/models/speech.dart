import 'dart:async';

/// Describes the direction of how the timer counts.
enum TimerDirection { countDown, countsUp }

/// Describes what happens when the timer runs out.
enum TimerEndBehavior { stopClock, keepCounting }

/// Describes the state and behavior of a single speech.
class Speech {
  final TimerDirection direction;
  final TimerEndBehavior onEnd;
  final Function callback;
  final Duration length;
  final String name;

  /// Constructs a new speech object.
  Speech({
    this.name,
    this.length,
    this.direction,
    this.onEnd,
    this.callback,
  });

  /// Starts the speech timer.
  void startTimer() {}
}
