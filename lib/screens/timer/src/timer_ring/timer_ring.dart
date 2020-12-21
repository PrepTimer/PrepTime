import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/team.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/clock_carousel.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/ring_painter.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/speech_indicator.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/speech_label.dart';
import 'package:preptime/utilities/modals/modals.dart';
import 'package:provider/provider.dart';
import 'package:preptime/models/debate_event.dart';

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
            ClockCarousel(),
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
    event.initSpeechController(
      this,
      onSpeechEnd: () => _autoMoveSpeeches(context),
      // onValueChanged: () => _showTimeSignal(),
    );
  }

  void _autoMoveSpeeches(BuildContext context) {
    Event event = context.read<Event>();
    if (event.speech.useJudgeAssistant && event is DebateEvent) {
      Alerts.showAlertDialogWithOneDefaultOption(
        context,
        title: 'Time\'s up!',
        content: 'Would either team like to take prep?',
        defaultActionLabel: 'Yes',
        secondaryActionLabel: 'No',
        secondaryAction: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).pop();
          event.nextSpeech();
        },
        defaultAction: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).pop();
          Alerts.showAlertDialogWithTwoBasicOptions(
            context,
            title: 'Awesome!',
            content: 'Which team will be taking prep?',
            firstActionLabel: event.prepName(Team.left),
            secondActionLabel: event.prepName(Team.right),
            firstAction: () {
              HapticFeedback.selectionClick();
              event.startPrep(Team.left);
              Navigator.of(context).pop();
              event.nextSpeech();
            },
            secondAction: () {
              HapticFeedback.selectionClick();
              event.startPrep(Team.right);
              Navigator.of(context).pop();
              event.nextSpeech();
            },
          );
        },
      );
    }
  }

  /// TODO: DO THIS.
  void _showTimeSignal() {}
}
