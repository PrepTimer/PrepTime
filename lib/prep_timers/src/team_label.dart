import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:preptime/provider/models/team.dart';
import 'package:provider/provider.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event_controller.dart';

/// The name of the team whos prep time this widget labels.
class TeamLabel extends StatelessWidget {
  final Team team;

  const TeamLabel({@required this.team});

  @override
  Widget build(BuildContext context) {
    DebateEvent event = (context.watch<EventController>().event as DebateEvent);
    return AutoSizeText(
      event.prepName(team).toUpperCase() + ' PREP',
      maxLines: 1,
      style: const TextStyle(
        fontSize: 30,
        color: Color(0x88FFFFFF),
        fontWeight: FontWeight.w200,
      ),
    );
  }
}
