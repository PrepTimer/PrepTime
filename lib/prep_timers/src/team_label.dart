import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:preptime/provider/models/team.dart';
import 'package:provider/provider.dart';
import 'package:preptime/provider/models/debate_event.dart';

/// The name of the team whos prep time this widget labels.
class TeamLabel extends StatelessWidget {
  final Team team;
  final bool isDisabled;

  const TeamLabel({
    Key key,
    @required this.team,
    @required this.isDisabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prepName = (context.watch<Event>() as DebateEvent).prepName(team);
    return AutoSizeText(
      prepName + ' PREP',
      maxLines: 1,
      style: isDisabled
          ? Theme.of(context).textTheme.caption
          : Theme.of(context).textTheme.overline,
    );
  }
}
