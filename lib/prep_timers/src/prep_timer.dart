import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:preptime/prep_timers/src/team_label.dart';
import 'package:preptime/prep_timers/src/time_label.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:preptime/provider/models/event_controller.dart';
import 'package:preptime/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:preptime/provider/models/team.dart';

class PrepTimer extends StatefulWidget {
  /// Constructs a new prep timer for the given team.
  const PrepTimer({
    Key key,
    @required this.team,
  }) : super(key: key);

  /// The team which this prep timer object represents.
  final Team team;

  @override
  _PrepTimerState createState() => _PrepTimerState();
}

class _PrepTimerState extends State<PrepTimer> {
  static const Size _buttonSize = Size(100, 90);

  bool isDisabled;

  @override
  void initState() {
    DebateEvent event = (context.read<EventController>().event as DebateEvent);
    bool isOtherRunning = event.isAnyRunning;
    bool isRunning = event.isRunning(widget.team);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDisabled = context.select<Event, bool>(_handleSelector);
    return GestureDetector(
      onLongPressStart: (_) => _resetTimer(context),
      child: InkWell(
        onTap: _handleStartStop,
        borderRadius: BorderRadius.circular(10),
        highlightColor: Colors.transparent,
        splashColor: Colors.white10,
        child: Container(
          padding: EdgeInsets.all(10),
          height: _buttonSize.height,
          width: _buttonSize.width,
          child: Column(
            children: [
              TeamLabel(team: widget.team),
              TimeLabel(team: widget.team),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns whether or not the event's
  bool _handleSelector(Event event) {
    assert(event is DebateEvent);
    DebateEvent debateEvent = event as DebateEvent;
    return false;
  }

  void _handleStartStop() {
    isRunning ? event.stopPrep(widget.team) : event.startPrep(widget.team);
    _updateState();
  }

  void _updateState() {
    setState(() {
      isOtherRunning = event.isOtherRunning(widget.team);
      isRunning = event.isRunning(widget.team);
    });
  }

  void _resetTimer(BuildContext context) {
    event.stopPrep(widget.team);
    ClearTimer.showDialog(
      context,
      title: 'Reset Prep',
      content: 'Are you sure you want to reset the timer?',
      destructiveActionLabel: 'Reset',
      cancelActionLabel: 'Cancel',
      destructiveAction: () {
        event.resetPrep(widget.team);
        _updateState();
        Navigator.of(context).pop();
      },
      cancelAction: () => Navigator.of(context).pop(),
    );
    _updateState();
  }
}
