// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'dart:collection';

import 'package:preptime/models/simple_timer.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/team.dart';

/// Manages the prep time for two teams in a forensic event.
///
/// The [PrepTimeMixin] manages the state of two [CountDownTimers], one for
/// each team. The mixin exposes the [Timeable] behavior of each timer such
/// as the [start()], [stop()], [reset()], [isPrepRunning], and [isPrepNotRunning]
/// methods. In this case, you simply pass the team who's prep you would like
/// to start as a parameter to the exposed [Timeable] methods and the mixin
/// will do the rest.
///
/// To listen to the stream of remaining prep time duration, simply pass the
/// team you would like to listen into the [remainingPrep] method.
mixin PrepTimeMixin on Event {
  /// Maps a countdown timer to each team.
  ///
  /// Each value in team is assigned its own [SimpleTimer] to track that
  /// team's use of prep time (in this case, there are only two teams). The
  /// [SimpleTimer] implements the [Timeable] interface, so you can call
  /// start(), stop(), reset(), and isRunning on each team's prep timer.
  Map<Team, SimpleTimer> _timers = LinkedHashMap();

  /// The initial amount of time to put on each prep clock.
  /// 
  /// Throws [StateError] if the PrepTimers have not been initialized.
  Duration get initialPrep {
    if (_initialPrep == null) {
      throw StateError('Must call initPrepTimers.');
    }
    return _initialPrep;
  }

  /// The initial duration of the prep timer.
  Duration _initialPrep;

  /// Whether to use AFF/NEG for prep names or PRO/CON;
  bool _useAffNeg = true;

  /// Initializes the prep timers.
  ///
  /// The prep timers will each be constructed with the given duration. This
  /// method should only be called once and there should be no timers setup
  /// before calling this method.
  ///
  /// The given duration must not be null.
  void initPrepTimers({Duration duration, bool useAffNeg = true}) {
    assert(duration != null);
    assert(_timers.isEmpty);
    _initialPrep = duration;
    _useAffNeg = useAffNeg;
    for (Team team in Team.values) {
      _timers.putIfAbsent(
        team,
        () => SimpleTimer(duration, onEnd: () => notifyListeners()),
      );
    }
  }

  /// Disposes the resources held by the PrepTimeMixin.
  void disposePrepTimers() {
    _timers.forEach((_, timer) {
      timer.dispose();
    });
    _timers.clear();
  }

  /// Checks if the prep timer for the given team is running.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  bool isPrepRunning(Team team) {
    _ensurePrepTimersHaveBeenInitialized(team);
    return _timers[team].isRunning;
  }

  /// Checks if the prep timer for the given team is not running.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  bool isPrepNotRunning(Team team) => !isPrepRunning(team);

  /// Checks if the other team's prep timer is running.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  bool isOtherPrepRunning(Team team) => isPrepRunning(team.otherTeam());

  /// Returns true if either team's prep timer is running.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  bool get isAnyPrepRunning {
    return isPrepRunning(Team.left) || isPrepRunning(Team.right);
  }

  /// Starts the prep timer for the given team.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  void startPrep(Team team) {
    _ensurePrepTimersHaveBeenInitialized(team);
    _timers[team].resume();
    notifyListeners();
  }

  /// Stops the prep time for the given team.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  void stopPrep(Team team) {
    _ensurePrepTimersHaveBeenInitialized(team);
    _timers[team].stop();
    notifyListeners();
  }

  /// Toggles the given team's prep timer between start and stop.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  void togglePrep(Team team) {
    isPrepRunning(team) ? stopPrep(team) : startPrep(team);
  }

  /// Resets the prep time for the given team.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  void resetPrep(Team team) {
    _ensurePrepTimersHaveBeenInitialized(team);
    _timers[team].reset();
    notifyListeners();
  }

  /// Returns the currentTime stream of the given team's prep timer.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  Stream<Duration> remainingPrep(Team team) {
    _ensurePrepTimersHaveBeenInitialized(team);
    return _timers[team].currentTime;
  }

  /// Returns whether the given team is out of prep.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  bool isOutOfPrep(Team team) {
    _ensurePrepTimersHaveBeenInitialized(team);
    return _timers[team].timeRemaining <= Duration.zero;
  }

  /// The name of each team as displayed above their prep time.
  String prepName(Team team) => team.toFormattedString(_useAffNeg);

  /// Checks that the timer is not null.
  ///
  /// Throws [StateError] if the PrepTimers have not been initialized.
  void _ensurePrepTimersHaveBeenInitialized(Team team) {
    if (_timers[team] == null) {
      throw StateError('Must call initPrepTimers');
    }
  }
}
