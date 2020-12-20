import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_event.dart';
import 'package:provider/provider.dart';
import 'package:preptime/utilities/duration_format/duration_format.dart';

/// The time remaining duration on the clock.
class ClockLabel extends StatelessWidget {
  final int index;

  ClockLabel.fromIndex(this.index);

  @override
  Widget build(BuildContext context) {
    Speech speech = Provider.of<Speech>(context);
    Event event = context.watch<Event>();
    bool isDisabled = (event is DebateEvent) && event.isAnyRunning;
    print("building... index: $index speech: ${speech.name}");
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: AutoSizeText(
        index == event.currentSpeechIndex
            ? _getTimeRemainingFromSpeech(speech)
            : _getTimeRemainingFromSpeech(
                _getListOfSpeechesFromEvent(event)[index]),
        maxLines: 1,
        style: isDisabled
            ? Theme.of(context).textTheme.headline2
            : Theme.of(context).textTheme.headline1,
      ),
    );
  }

  List<Speech> _getListOfSpeechesFromEvent(Event event) {
    List<Speech> speeches = List();
    if (event is SpeechEvent) {
      speeches.add(event.speech);
    } else if (event is DebateEvent) {
      for (Speech speech in event.speeches) {
        speeches.add(speech);
      }
    }
    return speeches;
  }

  String _getTimeRemainingFromSpeech(Speech speech) {
    return speech.timeRemaining.toStringAsClock();
  }
}
