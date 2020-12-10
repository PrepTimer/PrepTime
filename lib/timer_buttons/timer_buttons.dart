import 'package:flutter/material.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:preptime/provider/models/speech.dart';
import 'package:preptime/timer_buttons/src/timer_button.dart';
import 'package:provider/provider.dart';

class TimerButtons extends StatelessWidget {
  TimerButtons({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Speech speech = context.watch<Speech>();
    Event _event = context.watch<Event>();
    bool isDisabled = (_event is DebateEvent) && _event.isAnyRunning;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TimerButton.cancel(context, isDisabled ? null : speech.reset),
        TimerButton.action(context, isDisabled, speech),
      ],
    );
  }
}
