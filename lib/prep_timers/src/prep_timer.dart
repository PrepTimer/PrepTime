import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:preptime/prep_timers/src/team_label.dart';
import 'package:preptime/prep_timers/src/time_label.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event_controller.dart';
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

  DebateEvent event;
  bool isOtherRunning;
  bool isRunning;

  @override
  void initState() {
    event = (context.read<EventController>().event as DebateEvent);
    isOtherRunning = event.isOtherRunning(widget.team);
    isRunning = event.isRunning(widget.team);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressUp: _handleLongPress,
      child: InkWell(
        onTap: _handleTap,
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

  void _handleTap() {
    isRunning ? event.stopPrep(widget.team) : event.startPrep(widget.team);
    _updateState();
  }

  void _handleLongPress() {
    print('handling long press');
    event.resetPrep(widget.team);
    _updateState();
  }

  void _updateState() {
    setState(() {
      isOtherRunning = event.isOtherRunning(widget.team);
      isRunning = event.isRunning(widget.team);
    });
  }
}
