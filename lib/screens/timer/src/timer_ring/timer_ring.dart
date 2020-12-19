import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech_event.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/clock_label.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/ring_painter.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/speech_indicator.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/speech_label.dart';
import 'package:preptime/utilities/modals/modals.dart';
import 'package:provider/provider.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/speech.dart';

/// Manages a timer ring including the ring painter, label, title, and dots.
class TimerRing extends StatefulWidget {
  TimerRing({Key key}) : super(key: key);
  @override
  _TimerRingState createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    _initializeAllSpeechControllersInEvent(context.watch<Event>());
    return Align(
      alignment: FractionalOffset.center,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: <Widget>[
            RingPainter(),
            ClockLabel(),
            Align(
              alignment: FractionalOffset(0.5, 0.69),
              child: SpeechLabel(),
            ),
            if (context.watch<Event>() is DebateEvent)
              Align(
                alignment: FractionalOffset(0.5, 0.8),
                child: SpeechIndicator(),
              )
          ],
        ),
      ),
    );
  }

  void _initializeAllSpeechControllersInEvent(Event event) {
    if (event is SpeechEvent) {
      _initializeSpeechController(event.speech);
    } else if (event is DebateEvent) {
      for (Speech speech in event.speeches) {
        _initializeSpeechController(speech);
      }
    }
  }

  void _initializeSpeechController(Speech speech) {
    speech.initController(
      this,
      onSpeechEnd: () => _autoMoveSpeeches(context),
      onValueChanged: () => _showTimeSignal(),
    );
  }

  void _autoMoveSpeeches(BuildContext context) {
    if (context.read<Speech>().useJudgeAssistant) {
      String body = 'body';
      Alerts.showAlertDialogWithTwoOptions(
        context,
        title: 'Time\'s up!',
        content: body,
        destructiveActionLabel: 'Foo',
        cancelActionLabel: 'Cancel',
        cancelAction: () => null,
        destructiveAction: () => null,
      );
    }
  }

  void _showTimeSignal() {}
}
