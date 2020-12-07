import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:provider/provider.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/speech.dart';
import 'package:preptime/timer_ring/src/ring_painter.dart';
import 'package:preptime/timer_ring/src/speech_indicator.dart';

/// Manages a timer ring including the ring painter, label, title, and dots.
class TimerRing extends StatefulWidget {
  @override
  _TimerRingState createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    context.watch<Speech>().initController(this);
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
            Container(
              alignment: FractionalOffset.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AutoSizeText(
                speech.timeRemaining,
                style: Theme.of(context).textTheme.headline1,
                maxLines: 1,
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
}
