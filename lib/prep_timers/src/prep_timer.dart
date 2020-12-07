import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:preptime/prep_timers/src/team_label.dart';
import 'package:preptime/prep_timers/src/time_label.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event_controller.dart';
import 'package:provider/provider.dart';
import 'package:preptime/provider/models/team.dart';

class PrepTimer extends StatefulWidget {
  static const Size _buttonSize = Size(100, 90);

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
  @override
  Widget build(BuildContext context) {
    DebateEvent event = (context.watch<EventController>().event as DebateEvent);
    bool isRunning = event.isRunning(widget.team);
    return InkWell(
      // highlightColor: Colors.transparent,
      splashColor: Colors.white10,
      borderRadius: BorderRadius.circular(10),
      onLongPress: () => null,
      onTap: () {
        isRunning ? event.stopPrep(widget.team) : event.startPrep(widget.team);
      },
      child: Container(
        color: isRunning ? Colors.blue : Colors.red,
        width: PrepTimer._buttonSize.width,
        height: PrepTimer._buttonSize.height,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TeamLabel(team: widget.team),
            TimeLabel(team: widget.team),
          ],
        ),
      ),
    );
  }
}
