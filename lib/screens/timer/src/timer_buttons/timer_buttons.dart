import 'package:flutter/material.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/screens/timer/src/timer_buttons/src/timer_button.dart';
import 'package:provider/provider.dart';

class TimerButtons extends StatelessWidget {
  TimerButtons({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Event event = Provider.of<Event>(context);
    bool isDisabled = (event is DebateEvent) && event.isAnyRunning;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TimerButton.cancel(context, isDisabled ? null : event.speech.reset),
        TimerButton.action(context, isDisabled, event.speech),
      ],
    );
  }
}
