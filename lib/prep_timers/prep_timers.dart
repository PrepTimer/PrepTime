import 'package:flutter/material.dart';
import 'package:preptime/prep_timers/src/prep_timer.dart';
import 'package:preptime/provider/models/team.dart';

class PrepTimers extends StatelessWidget {
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
