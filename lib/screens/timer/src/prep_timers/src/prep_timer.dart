import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/screens/timer/src/prep_timers/src/team_label.dart';
import 'package:preptime/screens/timer/src/prep_timers/src/time_label.dart';
import 'package:preptime/utilities/modals/modals.dart';
import 'package:provider/provider.dart';
import 'package:preptime/models/team.dart';

/// Tracks the used prep for a single team.
///
/// A [PrepTimer] is composed of a [TeamLabel] which describes the team name in
/// language specific to the event (eg. AFF/NEG for policy and PRO/CON for pofo)
/// and a [TimeLabel] which shows the amount of time remaining on the given
/// team's PrepTimer.
class PrepTimer extends StatefulWidget {
  /// Constructs a new prep timer for the given team.
  const PrepTimer({
    Key key,
    @required this.team,
  }) : super(key: key);

  /// The team which this prep timer object represents.
  ///
  /// A [Team] is either the left team or the right team. Each event will have
  /// a specific name that they call each team by calling the toFormattedString
  /// extension method on the team. For example, Policy calls the left team the
  /// "AFF" and the right team the 'NEG".
  final Team team;

  @override
  _PrepTimerState createState() => _PrepTimerState();
}

class _PrepTimerState extends State<PrepTimer> {
  static const Size _buttonSize = Size(100, 90);

  /// Whether the prep timer is disabled.
  ///
  /// A [PrepTimer] is defined as disabled if [isAnyRunning] and [isNotRunning]
  /// are both true, meaning one of the prepTimers is running, but it is not
  /// this one. Therefore, this one should be disabled.
  bool _isDisabled;

  /// The current debate event.
  ///
  /// A [DebateEvent] is an event that uses the [PrepTimeMixin] to support
  /// the starting and stopping of PrepTimers. Each timer implements the
  /// [Timeable] interface, allowing you to call `start`, `stop`, `reset` on
  /// each countdown timer.
  DebateEvent _debateEvent;

  /// The current speech event.
  ///
  /// We will watch the speech event for changes when start, stop, cancel, or
  /// resume are called on the speech event. In particular, we want to disable
  /// the PrepTime buttons when the speech timer is active.
  Speech _speech;

  @override
  Widget build(BuildContext context) {
    _debateEvent = context.watch<Event>() as DebateEvent;
    _speech = _debateEvent.speech;
    _isDisabled = context.select<Event, bool>(_didChangeDisability);
    return GestureDetector(
      onLongPressStart: (_) => _handleReset(context),
      child: InkWell(
        onTap: _isDisabled ? null : () => _debateEvent.togglePrep(widget.team),
        borderRadius: BorderRadius.circular(10),
        highlightColor: Theme.of(context).highlightColor,
        splashColor: Theme.of(context).shadowColor,
        child: Container(
          padding: EdgeInsets.all(10),
          height: _buttonSize.height,
          width: _buttonSize.width,
          child: Column(
            children: [
              TeamLabel(team: widget.team, isDisabled: _isDisabled),
              TimeLabel(team: widget.team, isDisabled: _isDisabled),
            ],
          ),
        ),
      ),
    );
  }

  /// Decides if the current team's prep timer should be disabled.
  ///
  /// This [PrepTimer] should be disabled when either of the following are
  /// considered to be true:
  ///
  /// - The other [PrepTimer] is currently running (`isOtherTimerRunning`)
  /// - The [Speech] is currently running (`Event.speech.isRunning`)
  ///
  /// The other PrepTimer is running when there is at least one timer that is
  /// running (`Event.isAnyRunning` is `true`) and the current PrepTimer is not
  /// running (`Event.isNotRunning(this.team)`);
  bool _didChangeDisability(Event _) {
    bool isAnyTimerRunning = _debateEvent.isAnyRunning;
    bool isThisTimerNotRunning = _debateEvent.isNotRunning(widget.team);
    bool isOtherTimerRunning = isAnyTimerRunning && isThisTimerNotRunning;
    return isOtherTimerRunning || _speech.isRunning;
  }

  /// Handles the [reset] callback.
  ///
  /// This method pauses the timer if it is currently running and displays a
  /// modal dialog which asks the user if the are sure they want to reset the
  /// prep time. The user can either select `cancel` or `reset` and the modal
  /// will dismiss. If the user selects `reset` then the prep time will also be
  /// reset to the initial value.
  void _handleReset(BuildContext context) {
    HapticFeedback.selectionClick();
    if (_debateEvent.isRunning(widget.team)) _debateEvent.stopPrep(widget.team);
    Alerts.showAlertDialogWithOneDestructiveOption(
      context,
      title: 'Reset Prep?',
      content: 'The current prep time will be lost.',
      destructiveActionLabel: 'Reset',
      cancelActionLabel: 'Cancel',
      destructiveAction: () {
        _debateEvent.resetPrep(widget.team);
        Navigator.of(context).pop();
      },
      cancelAction: () => Navigator.of(context).pop(),
    );
  }
}
