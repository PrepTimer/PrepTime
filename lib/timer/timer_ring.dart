import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:preptime/debate_events/debate_events.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event_controller.dart';
import 'package:preptime/provider/models/speech.dart';
import 'package:preptime/timer/ring_painter.dart';
import 'package:preptime/timer/speech_indicator.dart';
import 'package:provider/provider.dart';

/// Manages a timer ring including the ring painter, label, title, and dots.
class TimerRing extends StatefulWidget {
  @override
  _TimerRingState createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing> with TickerProviderStateMixin {
  @override
  void initState() {
    context.read<Speech>().initController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Speech speech = context.watch<Speech>();
    return Align(
      alignment: FractionalOffset.center,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: <Widget>[
            /// The large, circular ring animation
            Positioned.fill(
              child: RingPainter(),
            ),

            /// The large, white clock text (eg. 00:00.0)
            Align(
              alignment: FractionalOffset.center,
              child: Text(
                speech.timeRemaining,
                style: const TextStyle(
                  fontFeatures: [FontFeature.tabularFigures()],
                  fontWeight: FontWeight.w200,
                  letterSpacing: -4.0,
                  color: Colors.white,
                  fontSize: 85.0,
                ),
              ),
            ),

            /// The name of the speech being given.
            Align(
              alignment: FractionalOffset(0.5, 0.69),
              child: Text(
                speech.name.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Color(0x88FFFFFF),
                  fontSize: 18.0,
                ),
              ),
            ),

            /// Dots indicating which speech is active (debate only).
            if (context.watch<EventController>().event is DebateEvent)
              Align(
                alignment: FractionalOffset(0.5, 0.8),
                child: SpeechIndicator(),
              )
          ],
        ),
      ),
    );
  }
}
