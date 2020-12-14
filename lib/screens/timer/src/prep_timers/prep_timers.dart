import 'package:flutter/material.dart';
import 'package:preptime/models/team.dart';
import 'package:preptime/screens/timer/src/prep_timers/src/prep_timer.dart';

class PrepTimers extends StatelessWidget {
  PrepTimers({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrepTimer(team: Team.left),
        PrepTimer(team: Team.right),
      ],
    );
  }
}
