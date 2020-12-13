import 'dart:collection';

import 'package:preptime/models/countdown_timer.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/team.dart';

/// Manages the prep time for two teams in a forensic event.
///
/// The [PrepTimeMixin] manages the state of two [CountDownTimers], one for
/// each team. The mixin exposes the [Timeable] behavior of each timer such
/// as the [start()], [stop()], [reset()], [isRunning], and [isNotRunning]
/// methods. In this case, you simply pass the team who's prep you would like
/// to start as a parameter to the exposed [Timeable] methods and the mixin
/// will do the rest.
///
/// To listen to the stream of remaining prep time duration, simply pass the
/// team you would like to listen into the [remainingPrep] method.
mixin PrepTimeMixin on Event {
  /// Maps a countdown timer to each team.
  ///
  /// Each value in team is assigned its own [CountDownTimer] to track that
  /// team's use of prep time (in this case, there are only two teams). The
  /// [CountDownTimer] implements the [Timeable] interface, so you can call
  /// start(), stop(), reset(), and isRunning on each team's prep timer.
  Map<Team, CountDownTimer> _timers = LinkedHashMap();

  /// The initial amount of time to put on each prep clock.
  Duration get initialPrep {
    if (_initialPrep == null) throw StateError('Must call initPrepTimers.');
    return _initialPrep;
  }

  /// The initial duration of the prep timer.
  Duration _initialPrep;

  /// Whether to use AFF/NEG for prep names or PRO/CON;
  bool _useAffNeg = true;

  /// Initializes the prep timers.
  ///
  /// The prep timers will each be constructed with the given duration. This
  /// method should only be called once and there should be no timers setup yet.
  void initPrepTimers({Duration duration, bool useAffNeg = true}) {
    assert(duration != null);
    assert(_timers.isEmpty);
    _initialPrep = duration;
    _useAffNeg = useAffNeg;
    for (Team team in Team.values) {
      _timers.putIfAbsent(team, () => CountDownTimer(duration));
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
  bool isRunning(Team team) {
    CountDownTimer timer = _timers[team];
    if (timer == null) throw StateError('Must call initPrepTimers');
    return timer.isRunning;
  }

  /// Checks if the prep timer for the given team is not running.
  bool isNotRunning(Team team) => !isRunning(team);

  /// Checks if the other team's prep timer is running.
  bool isOtherRunning(Team team) => isRunning(team.otherTeam());
  
  /// Returns true if either team's prep timer is running.
  bool get isAnyRunning => isRunning(Team.left) || isRunning(Team.right);

  /// Starts the prep timer for the given team.
  void startPrep(Team team) {
    if (_timers[team] == null) throw StateError('Must call initPrepTimers');
    _timers[team].resume();
    notifyListeners();
  }

  /// Stops the prep time for the given team.
  void stopPrep(Team team) {
    if (_timers[team] == null) throw StateError('Must call initPrepTimers');
    _timers[team].stop();
    notifyListeners();
  }

  /// Toggles the given team's prep timer between start and stop.
  void togglePrep(Team team) {
    isRunning(team) ? stopPrep(team) : startPrep(team);
  }

  /// Resets the prep time for the given team.
  void resetPrep(Team team) {
    if (_timers[team] == null) throw StateError('Must call initPrepTimers');
    _timers[team].reset();
    notifyListeners();
  }

  /// Returns the currentTime stream of the given team's prep timer.
  ///
  /// This method assumes that the timer has alredy been initialized. If it is
  /// not initialized, then this method will throw a RangeError.
  Stream<Duration> remainingPrep(Team team) {
    if (_timers[team] == null) throw StateError('Must call initPrepTimers');
    return _timers[team].currentTime;
  }

  /// The name of each team as displayed above their prep time.
  String prepName(Team team) => team.toFormattedString(_useAffNeg);
}
