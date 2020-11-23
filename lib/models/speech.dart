import 'dart:async';

import 'package:flutter/widgets.dart';

/// Describes the direction of how the timer counts.
enum TimerDirection { countDown, countsUp }

/// Describes what happens when the timer runs out.
enum TimerEndBehavior { stopClock, keepCounting }

/// Describes the state and behavior of a single speech.
class Speech {
  final TimerDirection direction;
  final TimerEndBehavior onEnd;
  final Function callback;
  final AnimationController controller;
  final String name;

  /// Constructs a new speech object.
  Speech({
    @required this.name,
    @required this.direction,
    Duration length,
    @required this.onEnd,
    this.callback,
  }) : controller = AnimationController(
          vsync: null,
          value: 1.0,
          duration: length,
        );

  /// Starts the speech timer.
  void startTimer() {}
}
