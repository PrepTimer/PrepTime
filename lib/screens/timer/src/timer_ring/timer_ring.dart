import 'dart:async';

import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';
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
    _initializeAllSpeechControllersInEvent(context.watch<Event>(), context);
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

  void _initializeAllSpeechControllersInEvent(
      Event event, BuildContext context) {
    event.initSpeechController(
      this,
      context: context,
      onSpeechEnd: () => _autoMoveSpeeches(context),
    );
  }

  void _autoMoveSpeeches(BuildContext context) {
    Event event = context.read<Event>();
    if (event.speech.useJudgeAssistant && event is DebateEvent) {
      ShowAlertDialog.withDefaultAndBasicActions(
        context,
        title: 'Time\'s up!',
        content: 'Would either team like to take prep?',
        defaultActionLabel: 'Yes',
        secondaryActionLabel: 'No',
        secondaryAction: () => null,
        defaultAction: () {
          // Must present new alert asynchronously to avoid navigator pop loop.
          Timer.run(() {
            ShowAlertDialog.withTwoBasicActions(
              context,
              title: 'Awesome!',
              content: 'Which team will be taking prep?',
              firstActionLabel: event.prepName(Team.left),
              secondActionLabel: event.prepName(Team.right),
              firstAction: () => event.startPrep(Team.left),
              secondAction: () => event.startPrep(Team.right),
            );
          });
        },
      );
    }
  }
}
