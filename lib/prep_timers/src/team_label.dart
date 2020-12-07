import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:preptime/provider/models/team.dart';
import 'package:provider/provider.dart';
import 'package:preptime/provider/models/debate_event.dart';

/// The name of the team whos prep time this widget labels.
class TeamLabel extends StatelessWidget {
  static const Color primaryColor = Color(0x88FFFFFF);
  static const Color secondaryColor = Color(0x44FFFFFF);

  final Team team;

  const TeamLabel({@required this.team});

  @override
  Widget build(BuildContext context) {
    final isOtherRunning = context.select<Event, bool>(_selectBoolFromEvent);
    return AutoSizeText(
      (context.watch<Event>() as DebateEvent).prepName(team) + ' PREP',
      maxLines: 1,
      style: TextStyle(
        color: isOtherRunning ? secondaryColor : primaryColor,
        fontWeight: FontWeight.w200,
        fontSize: 30,
      ),
    );
  }

  bool _selectBoolFromEvent(Event event) {
    DebateEvent debateEvent = event as DebateEvent;
    return debateEvent.isAnyRunning && !debateEvent.isRunning(team);
  }
}
