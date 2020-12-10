import 'package:flutter/material.dart';
import 'package:preptime/prep_timers/src/prep_timer.dart';
import 'package:preptime/provider/models/team.dart';

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
