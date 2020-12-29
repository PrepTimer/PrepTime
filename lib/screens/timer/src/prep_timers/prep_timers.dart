// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/material.dart';
import 'package:preptime/models/team.dart';
import 'package:preptime/screens/timer/src/prep_timers/src/prep_timer.dart';

/// A pair of [PrepTimer] widgets that are used to track each team's prep.
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
