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
    Event event = context.watch<Event>();
    bool isDisabled = (event is DebateEvent) && event.isAnyRunning;
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<Duration>(
        initialData: _getInitialDataFromEventAtIndex(event, index),
        stream: _getSpeechFromEventAtIndex(event, index).timer.currentTime,
        builder: (context, durationSnapshot) {
          return AutoSizeText(
            durationSnapshot.data?.toStringAsClock(),
            maxLines: 1,
            style: isDisabled
                ? Theme.of(context).textTheme.headline2
                : Theme.of(context).textTheme.headline1,
          );
        },
      ),
    );
  }

  Duration _getInitialDataFromEventAtIndex(Event event, int index) {
    if (event.speech.shouldCountUp) {
      return Duration.zero;
    } else {
      return _getSpeechFromEventAtIndex(event, index).length;
    }
  }

  Speech _getSpeechFromEventAtIndex(Event event, int index) {
    return _getListOfSpeechesFromEvent(event)[index];
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
}
