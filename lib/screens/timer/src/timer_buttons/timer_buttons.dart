// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/material.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/screens/timer/src/timer_buttons/src/timer_button.dart';
import 'package:provider/provider.dart';

class TimerButtons extends StatelessWidget {
  TimerButtons({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Event event = context.watch<Event>();
    bool isDisabled = (event is DebateEvent) && event.isAnyPrepRunning;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TimerButton.cancel(context, isDisabled, event.reset),
        TimerButton.action(context, isDisabled, event),
      ],
    );
  }
}
