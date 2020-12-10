import 'package:flutter/material.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:preptime/timer_ring/src/clock_label.dart';
import 'package:preptime/timer_ring/src/speech_label.dart';
import 'package:provider/provider.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/speech.dart';
import 'package:preptime/timer_ring/src/ring_painter.dart';
import 'package:preptime/timer_ring/src/speech_indicator.dart';

/// Manages a timer ring including the ring painter, label, title, and dots.
class TimerRing extends StatefulWidget {
  TimerRing({Key key}) : super(key: key);
  @override
  _TimerRingState createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    context.watch<Speech>().initController(this);
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
}
