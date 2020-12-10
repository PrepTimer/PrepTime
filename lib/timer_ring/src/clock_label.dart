import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:preptime/provider/models/speech.dart';
import 'package:provider/provider.dart';

/// The amount of time left on the clock.
class ClockLabel extends StatelessWidget {
  ClockLabel({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Speech speech = context.watch<Speech>();
    Event event = context.watch<Event>();
    bool isDisabled = (event is DebateEvent) && event.isAnyRunning;
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: AutoSizeText(
        speech.timeRemaining,
        maxLines: 1,
        style: isDisabled
            ? Theme.of(context).textTheme.headline2
            : Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
