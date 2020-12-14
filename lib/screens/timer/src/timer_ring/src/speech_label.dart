import 'package:flutter/material.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';
import 'package:provider/provider.dart';

/// The name of the speech currently being given.
class SpeechLabel extends StatelessWidget {
  SpeechLabel({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Speech speech = context.watch<Speech>();
    Event event = context.watch<Event>();
    bool isDisabled = (event is DebateEvent) && event.isAnyRunning;
    return Text(
      speech.name.toUpperCase(),
      style: isDisabled
          ? Theme.of(context).textTheme.subtitle2
          : Theme.of(context).textTheme.subtitle1,
    );
  }
}
