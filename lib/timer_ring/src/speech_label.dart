import 'package:flutter/material.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:preptime/provider/models/speech.dart';
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
      style: TextStyle(
        fontWeight: FontWeight.w300,
        color: isDisabled ? Color(0x44FFFFFF) : Color(0x88FFFFFF),
        fontSize: 18.0,
      ),
    );
  }
}
